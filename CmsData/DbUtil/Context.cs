﻿/* Author: David Carroll
 * Copyright (c) 2008, 2009 Bellevue Baptist Church 
 * Licensed under the GNU General Public License (GPL v2)
 * you may not use this code except in compliance with the License.
 * You may obtain a copy of the License at http://bvcms.codeplex.com/license 
 */
using System;
using System.Data.Common;
using System.Linq;
using CmsData.Finance;
using UtilityExtensions;
using System.Web;
using System.Data.Linq.Mapping;
using System.Data.Linq;
using System.Reflection;
using System.Collections.Generic;
using System.Diagnostics;
using CmsData.Codes;
using System.Text.RegularExpressions;

namespace CmsData
{
    public partial class CMSDataContext
    {
        const string STR_System = "System";

        private int nextTagId = 11;

        public int NextTagId
        {
            get { return nextTagId++; }
        }

        internal string ConnectionString;
        public static CMSDataContext Create(string connStr, string host)
        {
            return new CMSDataContext(connStr) {ConnectionString = connStr, Host = host};
        }
        partial void OnCreated()
        {
#if DEBUG
            CommandTimeout = 60;
#else
            CommandTimeout = 1200;
#endif
        }
        private string _LogFile;
        public string LogFile
        {
            get
            {
                if (_LogFile == null)
                    _LogFile = Setting("LinqLogFile", null);
                return _LogFile;
            }
        }
        public override void SubmitChanges(System.Data.Linq.ConflictMode failureMode)
        {
            if (this.ObjectTrackingEnabled == true)
            {
                ChangeSet cs = this.GetChangeSet();
                var typesToCheck = new Type[] { typeof(string), typeof(System.Data.Linq.Binary) };//, typeof(DateTime) };
                var insertsUpdates = (
                    from i in cs.Inserts.Union(cs.Updates)
                    join m in this.Mapping.GetTables() on i.GetType() equals m.RowType.Type
                    select new
                    {
                        Entity = i,
                        Members = m.RowType.DataMembers.Where(dm => typesToCheck.Contains(dm.Type)).ToList()
                    }).Where(m => m.Members.Any()).ToList();
                foreach (var ins in insertsUpdates)
                    foreach (var mm in ins.Members)
                    {
                        //if (mm.DbType == "datetime NOT NULL")
                        //{
                        //    var dt = mm.MemberAccessor.GetBoxedValue(ins.Entity).ToDate();
                        //    if (dt < DateTime.Parse("1/1/1753"))
                        //    {
                        //        var iex = new InvalidOperationException(mm.Name + " in " + mm.DeclaringType.Name + " has a value that will not fit into " + mm.DbType + " " + dt.FormatDate());
                        //        throw iex;
                        //    }
                        //}
                        //else
                        {
                            var maxLength = GetMaxLength(mm.DbType);
                            if (mm.MemberAccessor.HasValue(ins.Entity))
                            {
                                var memberValueLength = GetMemberValueLength(mm.MemberAccessor.GetBoxedValue(ins.Entity));
                                if (maxLength > 0 && memberValueLength > maxLength)
                                {
                                    var iex = new InvalidOperationException(mm.Name + " in " + mm.DeclaringType.Name + " has a value that will not fit into " + mm.DbType);
                                    throw iex;
                                }
                            }
                        }
                    }
                base.SubmitChanges(failureMode);
            }
            else
                base.SubmitChanges(failureMode);
        }
        public void ClearCache2()
        {
            const BindingFlags Flags = BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic;
            var method = this.GetType().GetMethod("ClearCache", Flags);
            method.Invoke(this, null);
        }

        private int GetMaxLength(string dbType)
        {
            int maxLength = 0;

            if (dbType == null)
                return maxLength;
            if (dbType.Contains("("))
                dbType = dbType.Substring(dbType.IndexOf("(") + 1);
            if (dbType.Contains(")"))
                dbType = dbType.Substring(0, dbType.IndexOf(")"));
            int.TryParse(dbType, out maxLength);
            return maxLength;
        }

        private int GetMemberValueLength(object value)
        {
            if (value == null)
                return 0;
            if (value.GetType() == typeof(string))
                return ((string)value).Length;
            else if (value.GetType() == typeof(Binary))
                return ((Binary)value).Length;
            else
                throw new ArgumentException("Unknown type.");
        }
        public Person LoadPersonById(int id)
        {
            return this.People.FirstOrDefault(p => p.PeopleId == id);
        }
        public Family LoadFamilyByPersonId(int id)
        {
            return this.Families.SingleOrDefault(ff => ff.People.Any(mm => mm.PeopleId == id));
        }
        public Organization LoadOrganizationById(int? id)
        {
            return this.Organizations.FirstOrDefault(o => o.OrganizationId == id);
        }
        public Meeting LoadMeetingById(int? id)
        {
            return this.Meetings.SingleOrDefault(m => m.MeetingId == id);
        }
        public Organization LoadOrganizationByName(string name)
        {
            return this.Organizations.FirstOrDefault(o => o.OrganizationName == name);
        }
        public string FetchExtra(int pid, string field)
        {
            return this.PeopleExtras.OrderByDescending(e => e.TransactionTime)
                .First(e => e.Field == field && e.PeopleId == pid).StrValue;
        }
        public DateTime? FetchExtraDate(int pid, string field)
        {
            return this.PeopleExtras.OrderByDescending(e => e.TransactionTime)
                .First(e => e.Field == field && e.PeopleId == pid).DateValue;
        }

        public IQueryable<Person> PeopleQueryLast()
        {
            var qid = FetchLastQuery().Id;
            return PeopleQuery(qid);
        }
        public IQueryable<Person> PeopleQuery(Guid id)
        {
            if (id == null)
                return null;
            IQueryable<Person> q = null;
            var query = LoadQueryById2(id);
            if (query == null)
                return null;
            var c = query.ToClause();
            q = People.Where(c.Predicate(this));
            if (c.PlusParentsOf)
                q = PersonQueryPlusParents(q);
            else if (c.ParentsOf)
                q = PersonQueryParents(q);
            return q;
        }

        public IQueryable<Person> PeopleQuery2(object name)
        {
            return PeopleQuery2(name.ToString());
        }

        public IQueryable<Person> PeopleQuery2(string name)
        {
            if (name.AllDigits())
                name = "peopleid=" + name;
            if (name.StartsWith("peopleid", StringComparison.OrdinalIgnoreCase))
            {
                var pids = new List<int>();
                var re = new Regex(@"(\d+)");
                var m = re.Match(name);
                while (m.Success)
                {
                    pids.Add(m.Value.ToInt());
                    m = m.NextMatch();
                }
                if (pids.Count > 0)
                return People.Where(pp => pids.Contains(pp.PeopleId));
            }

            var qB = Queries.FirstOrDefault(cc => cc.Name == name);
            if (qB == null)
                qB = MatchNothing();
            var c = qB.ToClause();
            var q = People.Where(c.Predicate(this));
            if (c.PlusParentsOf)
                q = PersonQueryPlusParents(q);
            else if (c.ParentsOf)
                q = PersonQueryParents(q);
            return q;
        }
        public IQueryable<Person> PersonQueryParents(IQueryable<Person> q)
        {
            var q2 = from p in q
                     from m in p.Family.People
                     where m.PositionInFamilyId == 10
                     //					 where (m.PositionInFamilyId == 10 && p.PositionInFamilyId != 10)
                     //					 || (m.PeopleId == p.PeopleId && p.PositionInFamilyId == 10)
                     where m.DeceasedDate == null
                     select m.PeopleId;
            var tag = PopulateTemporaryTag(q2.Distinct());
            var q3 = from p in q
                     let ev = p.PeopleExtras.SingleOrDefault(ee => ee.Field == "Parent" && ee.IntValue > 0)
                     where ev != null
                     where !q2.Any(pp => pp == ev.IntValue)
                     select ev.IntValue;

            foreach (var i in q3.Distinct())
                tag.PersonTags.Add(new TagPerson { PeopleId = i.Value });
            SubmitChanges();
            return tag.People(this);
        }
        public IQueryable<Person> PersonQueryPlusParents(IQueryable<Person> q)
        {
            var tag1 = PopulateTemporaryTag(q.Select(pp => pp.PeopleId).Distinct());
            var q2 = from p in q
                     from m in p.Family.People
                     where m.PositionInFamilyId == 10
                     //					 where (m.PositionInFamilyId == 10 && p.PositionInFamilyId != 10)
                     //					 || (m.PeopleId == p.PeopleId && p.PositionInFamilyId == 10)
                     where m.DeceasedDate == null
                     select m.PeopleId;

            var tag2 = PopulateTemporaryTag(q2.Distinct());
            var q3 = from p in q
                     let ev = p.PeopleExtras.SingleOrDefault(ee => ee.Field == "Parent" && ee.IntValue > 0)
                     where ev != null
                     where !q2.Any(pp => pp == ev.IntValue)
                     select ev.IntValue;

            foreach (var i in q3.Distinct())
                tag2.PersonTags.Add(new TagPerson { PeopleId = i.Value });
            SubmitChanges();
            AddTag1ToTag2(tag1.Id, tag2.Id);
            return tag2.People(this);
        }
        public IQueryable<Person> ReturnPrimaryAdults(IQueryable<Person> q)
        {
            var q2 = from p in q
                     from m in p.Family.People
                     where m.PositionInFamilyId == 10
                     where m.DeceasedDate == null
                     select m.PeopleId;
            var tag = PopulateTemporaryTag(q2.Distinct());

            SubmitChanges();
            return tag.People(this);
        }
        public void TagAll(IQueryable<Person> list)
        {
            var tag = TagCurrent();
            TagAll(list, tag);
        }
        public void TagAll(IQueryable<Person> list, Tag tag)
        {
            var q = from p in list
                    where !p.Tags.Any(tp => tp.Id == tag.Id)
                    select p.PeopleId;
            foreach (var id in q)
                tag.PersonTags.Add(new TagPerson { PeopleId = id });
            SubmitChanges();
        }
        public void TagAll2(IQueryable<Person> list, Tag tag)
        {
            ExecuteCommand("delete TagPerson where Id = {0}", tag.Id);
            var q2 = list.Select(pp => pp.PeopleId);
            var cmd = GetCommand(q2);
            var s = cmd.CommandText;
            var plist = new List<DbParameter>();
            int n = 0, pn = 0;
            foreach (var p in cmd.Parameters)
            {
                var pa = p as DbParameter;
                if (pa != null && pa.Value is DBNull)
                {
                    s = Regex.Replace(s, @"@p{0}\b".Fmt(n++), "NULL");
                    continue;
                }
                s = Regex.Replace(s, @"@p{0}\b".Fmt(n++), "{{{0}}}".Fmt(pn++));
                plist.Add(pa);
            }
            s = Regex.Replace(s, "^SELECT( DISTINCT)?",
                @"INSERT INTO TagPerson (Id, PeopleId) $0 " + tag.Id + ",");
            var a = plist.Select(pp => pp.Value).ToArray();
            ExecuteCommand(s, a);
        }
        public void TagAll(IEnumerable<int> list, Tag tag)
        {
            foreach (var id in list)
                tag.PersonTags.Add(new TagPerson { PeopleId = id });
            SubmitChanges();
        }
        public void UnTagAll(IQueryable<Person> list)
        {
            var person = list.FirstOrDefault();
            var tag = TagCurrent();
            var q = from p in list
                    from t in p.Tags
                    where t.Id == tag.Id
                    select t;

            foreach (var t in q)
                TagPeople.DeleteOnSubmit(t);
            SubmitChanges();
        }
        const int maxints = 1000;
        public void UnTagAll(List<int> list, Tag tag)
        {
            for(var i = 0; i< list.Count; i+=maxints)
            {
                var s = string.Join(",", list.Skip(i).Take(maxints));
                var cmd = "DELETE dbo.TagPerson WHERE Id = {0} AND PeopleId IN ({1})".Fmt(tag.Id, s);
                ExecuteCommand(cmd);
            }
        }
        public void TagAll(List<int> list, Tag tag)
        {
            for(var i = 0; i< list.Count; i+=maxints)
            {
                var s = string.Join(",", list.Skip(i).Take(maxints));
                var cmd = "INSERT dbo.TagPerson (Id, PeopleId) SELECT {0}, Value FROM dbo.SplitInts('{1}')".Fmt(tag.Id, s);
                ExecuteCommand(cmd);
            }
        }
        public Tag PopulateSpecialTag(Guid QueryId, int TagTypeId)
        {
            var q = PeopleQuery(QueryId);
            return PopulateSpecialTag(q, TagTypeId);
        }
        public Tag PopulateSpecialTag(IQueryable<Person> q, int TagTypeId)
        {
            string name;
            if (TagTypeId != DbUtil.TagTypeId_Emailer)
                name = Util.SessionId;
            else
            {
                name = ".temp email tag {0:t}".Fmt(DateTime.Now);
                TagTypeId = DbUtil.TagTypeId_Personal;
            }
            var tag = FetchOrCreateTag(name, Util.UserPeopleId ?? Util.UserId1, TagTypeId);
            ExecuteCommand("delete TagPerson where Id = {0}", tag.Id);
            var qpids = q.Select(pp => pp.PeopleId);
            var cmd = GetCommand(qpids);
            var s = cmd.CommandText;
            var plist = new List<DbParameter>();
            int n = 0, pn = 0;
            foreach (var p in cmd.Parameters)
            {
                var pa = p as DbParameter;
                if (pa != null && pa.Value is DBNull)
                {
                    s = Regex.Replace(s, @"@p{0}\b".Fmt(n++), "NULL");
                    continue;
                }
                s = Regex.Replace(s, @"@p{0}\b".Fmt(n++), "{{{0}}}".Fmt(pn++));
                plist.Add(pa);
            }
            s = Regex.Replace(s, "^SELECT( DISTINCT)?",
                @"INSERT INTO TagPerson (Id, PeopleId) $0 " + tag.Id + ",");
            ExecuteCommand(s, plist.Select(pp => pp.Value).ToArray());
            return tag;
        }
        public Tag PopulateTemporaryTag(IQueryable<int> q)
        {
            var tag = FetchOrCreateTag(Util.SessionId, Util.UserPeopleId ?? Util.UserId1, NextTagId);
            Debug.Assert(NextTagId != 10, "got a 10");
            ExecuteCommand("delete TagPerson where Id = {0}", tag.Id);
            var cmd = GetCommand(q);
            var s = cmd.CommandText;
            var plist = new List<DbParameter>();
            
            int n = 0, pn = 0;
            foreach (var p in cmd.Parameters)
            {
                var pa = p as DbParameter;
                if (pa != null && pa.Value is DBNull)
                {
                    s = Regex.Replace(s, @"@p{0}\b".Fmt(n++), "NULL");
                    continue;
            }
                s = Regex.Replace(s, @"@p{0}\b".Fmt(n++), "{{{0}}}".Fmt(pn++));
                plist.Add(pa);
            }

            s = Regex.Replace(s, "^SELECT( DISTINCT)?",
                @"INSERT INTO TagPerson (Id, PeopleId) $0 " + tag.Id + ",");
            ExecuteCommand(s, plist.Select(pp => pp.Value).ToArray());
            return tag;
        }
        public Tag PopulateTempTag(IEnumerable<int> a)
        {
            var tag = FetchOrCreateTag(Util.SessionId, Util.UserPeopleId ?? Util.UserId1, NextTagId);
            ExecuteCommand("delete TagPerson where Id = {0}", tag.Id);
            var list = string.Join(",", a);
            PopulateTempTag(tag.Id, list);
            return tag;
        }
        public void ClearTag(Tag tag)
        {
            ExecuteCommand("delete TagPerson where Id = {0}", tag.Id);
        }
        public void PopulateSpecialTag(IQueryable<Person> q, string tagname)
        {
            var tag = FetchOrCreateTag(tagname, Util.UserPeopleId ?? Util.UserId1, DbUtil.TagTypeId_Personal);
            TagPeople.DeleteAllOnSubmit(tag.PersonTags);
            SubmitChanges();
            TagAll(q, tag);
        }
        public void DePopulateSpecialTag(IQueryable<Person> q, int TagTypeId)
        {
            var tag = FetchOrCreateTag(Util.SessionId, Util.UserPeopleId ?? Util.UserId1, TagTypeId);
            TagPeople.DeleteAllOnSubmit(tag.PersonTags);
            SubmitChanges();
        }
        public Tag TagById(int id)
        {
            return Tags.SingleOrDefault(t => t.Id == id);
        }
        public Tag TagCurrent()
        {
            return FetchOrCreateTag(Util2.CurrentTagName, Util2.CurrentTagOwnerId, DbUtil.TagTypeId_Personal);
        }
        //public string NewPeopleEmailAddressx
        //{
        //    get
        //    {
        //        var em = DbUtil.SystemEmailAddress;
        //        var npm = People.SingleOrDefault(p => p.PeopleId == DbUtil.NewPeopleManagerId);
        //        if (npm != null && npm.EmailAddress.HasValue())
        //            em = npm.EmailAddress;
        //        var s = Settings.Where(ss => ss.Id == "NewPeopleEmailAddress").Select(ss => ss.SettingX).SingleOrDefault();
        //        return Util.PickFirst(s, em);
        //    }
        //}
        public int NewPeopleManagerId
        {
            get
            {
                var s = Setting("NewPeopleManagerIds", "1");
                if (s.HasValue())
                    return s.SplitStr(",;")[0].ToInt();
                var q = from u in Users
                        where u.UserRoles.Any(ur => ur.Role.RoleName == "Admin")
                        select u.PeopleId.Value;
                return q.First();
            }
        }
        public IEnumerable<Person> GetNewPeopleManagers()
        {
            var s = Setting("NewPeopleManagerIds", "");
            IEnumerable<Person> q = null;
            if (s.HasValue())
            {
                var a = s.SplitStr(",").Select(ss => ss.ToInt());
                q = from p in People
                    where a.Contains(p.PeopleId)
                    select p;
                return q;
            }
            return null;
        }
        private User _currentuser;
        public User CurrentUser
        {
            get
            {
                if (_currentuser != null)
                    return _currentuser;
                GetCurrentUser();
                return _currentuser;
            }
            set
            {
                _currentuser = value;
            }
        }
        private void GetCurrentUser()
        {
            var q = from u in Users
                    where u.UserId == Util.UserId
                    select new
                           {
                               u,
                               roleids = u.UserRoles.Select(uu => uu.RoleId).ToArray(),
                               roles = u.UserRoles.Select(uu => uu.Role.RoleName).ToArray(),
                           };
            var i = q.SingleOrDefault();
            if (i == null)
                return;
            _roles = i.roles;
            _roleids = i.roleids;
            _currentuser = i.u;
        }

        private string[] _roles;
        public string[] CurrentRoles()
        {
            if (_roles == null)
                GetCurrentUser();
            return _roles ?? new string[0];
        }

        private int[] _roleids;
        public int[] CurrentRoleIds()
        {
            if (_roleids == null)
                GetCurrentUser();
            return _roleids;
        }

        public Person CurrentUserPerson
        {
            get
            {
                return Users.Where(u => u.UserId == Util.UserId).Select(u => u.Person).SingleOrDefault();
            }
        }
        public Tag OrgMembersOnlyTag2()
        {
            return FetchOrCreateTag(Util.SessionId, Util.UserPeopleId ?? Util.UserId1, DbUtil.TagTypeId_OrgMembersOnly);
        }
        public Tag OrgLeadersOnlyTag2()
        {
            return FetchOrCreateTag(Util.SessionId, Util.UserPeopleId ?? Util.UserId1, DbUtil.TagTypeId_OrgLeadersOnly);
        }

        public Tag FetchOrCreateTag(string tagname, int? OwnerId, int tagtypeid)
        {
            var tag = FetchTag(tagname, OwnerId, tagtypeid);
            if (tag == null)
            {
                tag = new Tag { Name = tagname.Replace('!', '*'), PeopleId = OwnerId, TypeId = tagtypeid };
                Tags.InsertOnSubmit(tag);
                SubmitChanges();
            }
            return tag;
        }
        public Tag FetchTag(string tagname, int? OwnerId, int tagtypeid)
        {
            var tag = Tags.FirstOrDefault(t =>
                t.Name == tagname && t.PeopleId == OwnerId && t.TypeId == tagtypeid);
            return tag;
        }
        public Tag FetchOrCreateSystemTag(string tagname)
        {
            var tag = Tags.FirstOrDefault(t => t.Name == tagname && t.TypeId == 100);
            if (tag == null)
            {
                tag = new Tag { Name = tagname, TypeId = 100 };
                Tags.InsertOnSubmit(tag);
                SubmitChanges();
            }
            return tag;
        }

        public void SetOrgMembersOnly()
        {
            var me = Util.UserPeopleId;
            var dt = Util.Now.AddYears(-1);

            // members of any of my orgs excluding unshared orgs
            var q = from p in People
                    where p.OrganizationMembers.Any(m =>
                        OrganizationMembers.Any(um =>
                            (um.Organization.SecurityTypeId != 3
                                || um.MemberTypeId == MemberTypeCode.Teacher)
                             && um.OrganizationId == m.OrganizationId && um.PeopleId == me))
                    select p;
            var tag = PopulateSpecialTag(q, DbUtil.TagTypeId_OrgMembersOnly);
            //PopulateSpecialTag(q, "OrgMemberOnlyInMyOrg");

            // prev members of any of my orgs excluding unshared orgs

            q = from p in People
                where p.EnrollmentTransactions.Any(et =>
                        et.TransactionDate > dt
                        && et.TransactionTypeId >= 4
                        && et.Organization.SecurityTypeId != 3
                        && OrganizationMembers.Any(um =>
                            um.OrganizationId == et.OrganizationId && um.PeopleId == me))
                select p;
            TagAll(q, tag);
            //PopulateSpecialTag(q, "OrgMemberOnlyPrevInMyOrg");

            // members of my family
            q = from p in People
                where p.FamilyId == CurrentUser.Person.FamilyId
                select p;
            TagAll(q, tag);
            //PopulateSpecialTag(q, "OrgMemberOnlyInMyFamily");

            // visitors in the last year to one of my orgs excluding unshared
            var attype = new int[] { 40, 50, 60 };
            q = from p in People
                where p.Attends.Any(a =>
                    OrganizationMembers.Any(um =>
                        um.Organization.SecurityTypeId != 3 &&
                        um.OrganizationId == a.Meeting.OrganizationId && um.PeopleId == me)
                    && attype.Contains(a.AttendanceTypeId.Value) && a.MeetingDate > dt)
                select p;
            TagAll(q, tag);
            //PopulateSpecialTag(q, "OrgMemberOnlyVisitMyOrg");

            // people assigned to me in one of my tasks
            q = from p in People
                where p.TasksAboutPerson.Any(at => at.OwnerId == me || at.CoOwnerId == me)
                select p;
            TagAll(q, tag);
            //PopulateSpecialTag(q, "OrgMemberOnlyInMyTask");

            // people I have visited in a contact
            q = from p in People
                where p.contactsHad.Any(c => c.contact.contactsMakers.Any(cm => cm.PeopleId == me))
                select p;
            TagAll(q, tag);
            //PopulateSpecialTag(q, "OrgMemberOnlyIHaveContacted");
        }
        public int[] GetLeaderOrgIds(int? me)
        {
            var o1 = from o in Organizations
                     where o.OrganizationMembers.Any(om => om.MemberType.AttendanceTypeId == AttendTypeCode.Leader && om.PeopleId == me)
                     select o.OrganizationId;
            var o2 = from o in Organizations
                     where o1.Contains(o.OrganizationId)
                     from co in o.ChildOrgs
                     select co.OrganizationId;
            var o3 = from o in Organizations
                     where o1.Contains(o.OrganizationId)
                     from co in o.ChildOrgs
                     from cco in co.ChildOrgs
                     select cco.OrganizationId;
            var oids = o1.Union(o2).Union(o3).ToArray();
            return oids;
        }
        public int[] GetParentChildOrgIds(int? parent)
        {
            var o1 = from o in Organizations
                     where o.OrganizationId == parent
                     select o.OrganizationId;
            var o2 = from o in Organizations
                     where o1.Contains(o.OrganizationId)
                     from co in o.ChildOrgs
                     select co.OrganizationId;
            var o3 = from o in Organizations
                     where o1.Contains(o.OrganizationId)
                     from co in o.ChildOrgs
                     from cco in co.ChildOrgs
                     select cco.OrganizationId;
            var oids = o1.Union(o2).Union(o3).ToArray();
            return oids;
        }
        public void SetOrgLeadersOnly()
        {
            var me = Util.UserPeopleId;
            var dt = Util.Now.AddYears(-3);

            var oids = GetLeaderOrgIds(Util.UserPeopleId);
            // current members of one of my orgs I lead
            var q = from p in People
                    where p.OrganizationMembers.Any(m => oids.Contains(m.OrganizationId))
                    select p;
            var tag = PopulateSpecialTag(q, DbUtil.TagTypeId_OrgLeadersOnly);

            // previous members of my org
            q = from p in People
                where p.EnrollmentTransactions.Any(et =>
                        et.TransactionDate > dt
                        && et.TransactionTypeId >= 4
                        && oids.Contains(et.OrganizationId)
                        && et.Organization.SecurityTypeId != 3
                        && OrganizationMembers.Any(um =>
                            um.OrganizationId == et.OrganizationId && um.PeopleId == me))
                select p;
            TagAll(q, tag);

            // members of my family
            q = from p in People
                where p.FamilyId == CurrentUser.Person.FamilyId
                select p;
            TagAll(q, tag);

            // visitors in the last year to one of my orgs excluding unshared
            var attype = new int[] { 40, 50, 60 };
            q = from p in People
                where p.Attends.Any(a =>
                    OrganizationMembers.Any(um =>
                        um.MemberType.AttendanceTypeId == AttendTypeCode.Leader
                        && um.Organization.SecurityTypeId != 3
                        && oids.Contains(um.OrganizationId)
                        && um.OrganizationId == a.Meeting.OrganizationId
                        && um.PeopleId == me)
                    && attype.Contains(a.AttendanceTypeId.Value) && a.MeetingDate > dt)
                select p;
            TagAll(q, tag);

            // people assigned to me in one of my tasks
            q = from p in People
                where p.TasksAboutPerson.Any(at => at.OwnerId == me || at.CoOwnerId == me)
                select p;
            TagAll(q, tag);

            // people I have visited in a contact
            q = from p in People
                where p.contactsHad.Any(c => c.contact.contactsMakers.Any(cm => cm.PeopleId == me))
                select p;
            TagAll(q, tag);
        }
        [Function(Name = "dbo.AddAbsents")]
        public int AddAbsents([Parameter(DbType = "Int")] int? meetid, [Parameter(DbType = "Int")] int? userid)
        {
            var result = this.ExecuteMethodCall(this, (MethodInfo)(MethodInfo.GetCurrentMethod()), meetid, userid);
            return (int)(result.ReturnValue);
        }
        [Function(Name = "dbo.UpdateAttendStr")]
        public int UpdateAttendStr([Parameter(DbType = "Int")] int? orgid, [Parameter(DbType = "Int")] int? pid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), orgid, pid);
            return ((int)(result.ReturnValue));
        }
        public class TopGiver
        {
            public int PeopleId;
            public string Name;
            public decimal Amount;
        }
        public class AttendMeetingInfo1
        {
            public AttendMeetingInfo2 info;
            public Attend AttendanceOrg;
            public Attend Attendance;
            public Meeting Meeting;
            public List<Attend> VIPAttendance;
            public OrganizationMember BFCMember;
            public Attend BFCAttendance;
            public Meeting BFCMeeting;
            public int path;
        }
        public class AttendMeetingInfo2
        {
            public int? AttendedElsewhere { get; set; }
            public int? MemberTypeId { get; set; }
            //public bool? IsRegularHour { get; set; }
            //public int? ScheduleId { get; set; }
            //public bool? IsSameHour { get; set; }
            public bool? IsOffSite { get; set; }
            public bool? IsRecentVisitor { get; set; }
            public string Name { get; set; }
            public int? BFClassId { get; set; }
        }

        [Function(Name = "dbo.AttendMeetingInfo")]
        [ResultType(typeof(AttendMeetingInfo2))]
        [ResultType(typeof(Attend))] // Attendance
        [ResultType(typeof(Meeting))] // Meeting Attended
        [ResultType(typeof(Attend))] // VIP Attendance
        [ResultType(typeof(OrganizationMember))] // BFC membership
        [ResultType(typeof(Attend))] // BFC Attendance at same time
        [ResultType(typeof(Meeting))] // BFC Meeting Attended
        public IMultipleResults AttendMeetingInfo(int MeetingId, int PeopleId)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), MeetingId, PeopleId);
            return (IMultipleResults)result.ReturnValue;
        }
        public AttendMeetingInfo1 AttendMeetingInfo0(int MeetingId, int PeopleId)
        {
            var r = AttendMeetingInfo(MeetingId, PeopleId);
            var o = new AttendMeetingInfo1();
            o.info = r.GetResult<CMSDataContext.AttendMeetingInfo2>().First();
            o.Attendance = r.GetResult<Attend>().FirstOrDefault();
            if (o.Attendance != null)
            {
                o.AttendanceOrg = new Attend
                {
                    AttendanceFlag = o.Attendance.AttendanceFlag,
                    AttendanceTypeId = o.Attendance.AttendanceTypeId,
                    AttendId = o.Attendance.AttendId,
                    CreatedBy = o.Attendance.CreatedBy,
                    CreatedDate = o.Attendance.CreatedDate,
                    EffAttendFlag = o.Attendance.EffAttendFlag,
                    MeetingDate = o.Attendance.MeetingDate,
                    MeetingId = o.Attendance.MeetingId,
                    MemberTypeId = o.Attendance.MemberTypeId,
                    OrganizationId = o.Attendance.OrganizationId,
                    OtherOrgId = o.Attendance.OtherOrgId,
                    PeopleId = o.Attendance.PeopleId,
                };
            }

            o.Meeting = r.GetResult<Meeting>().First();
            o.VIPAttendance = r.GetResult<Attend>().ToList();
            o.BFCMember = r.GetResult<OrganizationMember>().FirstOrDefault();
            o.BFCAttendance = r.GetResult<Attend>().FirstOrDefault();
            o.BFCMeeting = r.GetResult<Meeting>().FirstOrDefault();
            return o;
        }
        public class RecordAttendInfo
        {
            public string ret { get; set; }
        }
        [Function(Name = "dbo.RecordAttend")]
        [ResultType(typeof(RecordAttendInfo))]
        private IMultipleResults RecordAttend([Parameter(DbType = "Int")] int? meetingId, [Parameter(DbType = "Int")] int? peopleId, [Parameter(DbType = "Bit")] bool? present)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), meetingId, peopleId, present);
            return ((IMultipleResults)(result.ReturnValue));
        }
        [Function(Name = "dbo.RecordAttendance")]
        [ResultType(typeof(RecordAttendInfo))]
        private IMultipleResults RecordAttendance(
            [Parameter(DbType = "Int")] int? orgId,
            [Parameter(DbType = "Int")] int? peopleId,
            [Parameter(DbType = "DateTime")] DateTime meetingDate,
            [Parameter(DbType = "bit")] bool present,
            [Parameter(DbType = "Varchar(50)")] string location,
            [Parameter(DbType = "Int")] int? userId)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), orgId, peopleId, meetingDate, present, location, userId);
            return ((IMultipleResults)(result.ReturnValue));
        }

        public string RecordAttendance(
            int? orgId, int? peopleId, DateTime meetingDate, bool present, string location)
        {
            var r = RecordAttendance(orgId, peopleId, meetingDate, present, location, Util.UserId1);
            var s = r.GetResult<RecordAttendInfo>().First();
            return s.ret;
        }

        public string RecordAttendance(int MeetingId, int PeopleId, bool present)
        {
            var r = RecordAttend(MeetingId, PeopleId, present);
            var s = r.GetResult<RecordAttendInfo>().First();
            return s.ret;
        }

        //        public class RollListView
        //        {
        //            public int? Section { get; set; }
        //            public int? PeopleId { get; set; }
        //            public string Name { get; set; }
        //            public string Last { get; set; }
        //            public int? FamilyId { get; set; }
        //            public string First { get; set; }
        //            public string Email { get; set; }
        //            public bool? Attended { get; set; }
        //            public int? CommitmentId { get; set; }
        //            public string CurrMemberType { get; set; }
        //            public string MemberType { get; set; }
        //            public string AttendType { get; set; }
        //            public int? OtherAttends { get; set; }
        //            public bool? CurrMember { get; set; }
        //        }
        //
        //        [Function(Name = "dbo.RollListMeeting")]
        //        [ResultType(typeof(RollListView))]
        //        public IMultipleResults RollListMeeting(
        //            [Parameter(DbType = "Int")] int? mid
        //            , [Parameter(DbType = "DateTime")] DateTime meetingdt
        //            , [Parameter(DbType = "Int")] int oid
        //            , [Parameter(DbType = "Bit")] bool current
        //            , [Parameter(DbType = "Bit")] bool createmeeting)
        //        {
        //            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), 
        //                mid, meetingdt, oid, current, createmeeting);
        //            return ((IMultipleResults)(result.ReturnValue));
        //        }
        //        public IEnumerable<RollListView> RollList(int? mid ,  DateTime meetingdt ,  int oid ,  bool current ,  bool createmeeting)
        //        {
        //            var r = RollListMeeting(mid, meetingdt, oid, current, createmeeting);
        //            return r.GetResult<RollListView>();
        //        }
        public string UserPreference(string pref)
        {
            return UserPreference(pref, string.Empty);
        }
        public string UserPreference(string pref, string defaultValue)
        {
            var d = HttpContext.Current.Session["preferences"] as Dictionary<string, string>;
            if (d != null && d.ContainsKey(pref))
                return d[pref] ?? defaultValue;
            if (d == null)
            {
                d = new Dictionary<string, string>();
                HttpContext.Current.Session["preferences"] = d;
            }
            Preference p = null;
            if (CurrentUser != null)
                p = CurrentUser.Preferences.SingleOrDefault(up => up.PreferenceX == pref);
            if (p != null)
            {
                d[pref] = p.ValueX;
                return p.ValueX;
            }
            d[pref] = null;
            return defaultValue;
        }

        public void ToggleUserPreference(string pref)
        {
            var value = UserPreference(pref);
            SetUserPreference(pref, value == "true" ? "false" : "true");
        }
        public void SetUserPreference(string pref, object value)
        {
            if (UserPreference(pref) == value.ToString())
                return;
            if (CurrentUser == null)
                return;
            var p = CurrentUser.Preferences.SingleOrDefault(up => up.PreferenceX == pref);
            if (p != null)
                p.ValueX = value.ToString();
            else
            {
                p = new Preference { UserId = Util.UserId1, PreferenceX = pref, ValueX = value.ToString() };
                Preferences.InsertOnSubmit(p);
            }
            var d = HttpContext.Current.Session["preferences"] as Dictionary<string, string>;
            if (d == null)
            {
                d = new Dictionary<string, string>();
                HttpContext.Current.Session["preferences"] = d;
            }
            d[pref] = p.ValueX;
            SubmitChanges();
        }
        public void SetUserPreference(int id, string pref, object value)
        {
            var u = Users.Single(uu => uu.UserId == id);
            var p = u.Preferences.SingleOrDefault(up => up.PreferenceX == pref);
            if (p != null)
            {
                if (p.ValueX == value.ToString())
                    return;
                p.ValueX = value.ToString();
            }
            else
            {
                p = new Preference { UserId = id, PreferenceX = pref, ValueX = value.ToString() };
                Preferences.InsertOnSubmit(p);
            }
            SubmitChanges();
        }

        [Function(Name = "dbo.LinkEnrollmentTransaction")]
        public int LinkEnrollmentTransaction([Parameter(DbType = "Int")] int? tid, [Parameter(DbType = "DateTime")] DateTime? trandt, [Parameter(DbType = "Int")] int? typeid, [Parameter(DbType = "Int")] int? orgid, [Parameter(DbType = "Int")] int? pid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), tid, trandt, typeid, orgid, pid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.FlagOddTransaction")]
        public int FlagOddTransaction([Parameter(DbType = "Int")] int? pid, [Parameter(DbType = "Int")] int? orgid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), pid, orgid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.PurgePerson")]
        public int PurgePerson([Parameter(DbType = "Int")] int? pid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), pid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.PurgeOrganization")]
        public int PurgeOrganization([Parameter(DbType = "Int")] int? oid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), oid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.UpdateMainFellowship")]
        public int UpdateMainFellowship([Parameter(DbType = "Int")] int? orgid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), orgid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.UpdateMeetingCounters")]
        public int UpdateMeetingCounters([Parameter(DbType = "Int")] int? mid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), mid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.DeletePeopleExtras")]
        public int DeletePeopleExtras([Parameter(DbType = "varchar(50)")] string field)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), field);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.DeleteSpecialTags")]
        public int DeleteSpecialTags([Parameter(DbType = "Int")] int? pid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), pid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.UpdateResCodes")]
        public int UpdateResCodes()
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())));
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.PurgeAllPeopleInCampus")]
        public int PurgeAllPeopleInCampus([Parameter(DbType = "Int")] int? cid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), cid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.PopulateComputedEnrollmentTransactions")]
        public int PopulateComputedEnrollmentTransactions([Parameter(DbType = "Int")] int? orgid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), orgid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.RepairTransactions")]
        public int RepairTransactions([Parameter(DbType = "Int")] int? orgid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), orgid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.RepairTransactionsOrgs")]
        public int RepairTransactionsOrgs([Parameter(DbType = "Int")] int? orgid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), orgid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.UpdateSchoolGrade")]
        public int UpdateSchoolGrade([Parameter(DbType = "Int")] int? pid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), pid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.UpdateLastActivity")]
        public int UpdateLastActivity([Parameter(DbType = "Int")] int? userid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), userid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.PurgeUser")]
        public int PurgeUser([Parameter(DbType = "Int")] int? uid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), uid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.DeleteQBTree")]
        public int DeleteQBTree([Parameter(DbType = "Int")] int? qid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), qid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.SetMainDivision")]
        public int SetMainDivision([Parameter(DbType = "Int")] int? orgid, [Parameter(DbType = "Int")] int? divid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), orgid, divid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.DeleteQueryBitTags")]
        public int DeleteQueryBitTags()
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())));
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.CreateMeeting")]
        public int CreateMeeting([Parameter(DbType = "Int")] int oid, [Parameter(DbType = "DateTime")] DateTime? mdt)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), oid, mdt);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.InsertDuplicate")]
        public int InsertDuplicate([Parameter(DbType = "Int")] int i1, [Parameter(DbType = "Int")] int i2)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), i1, i2);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.NoEmailDupsInTag")]
        public int NoEmailDupsInTag([Parameter(DbType = "Int")] int tagid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), tagid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.AttendUpdateN")]
        public int AttendUpdateN([Parameter(DbType = "Int")] int pid, [Parameter(DbType = "Int")] int max)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), pid, max);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.TrackOpen")]
        public int TrackOpen([Parameter(DbType = "UniqueIdentifier")] Guid guid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), guid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.TrackClick")]
        public int TrackClick([Parameter(DbType = "VarChar(50)")] string hash,
            [Parameter(DbType = "VarChar(2000)")] ref string link)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), hash, link);
            link = ((string)(result.GetParameterValue(1)));
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.SpamReporterRemove")]
        public int SpamReporterRemove([Parameter(DbType = "VARCHAR(100)")] string email)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), email);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.DropOrgMember")]
        public int DropOrgMember([Parameter(DbType = "Int")] int oid, [Parameter(DbType = "Int")] int pid)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), oid, pid);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.PopulateTempTag")]
        public int PopulateTempTag([Parameter(DbType = "Int")] int id, [Parameter(DbType = "VARCHAR(MAX)")] string list)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), id, list);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.AddTag1ToTag2")]
        public int AddTag1ToTag2([Parameter(DbType = "Int")] int t1, [Parameter(DbType = "Int")] int t2)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), t1, t2);
            return ((int)(result.ReturnValue));
        }
        [Function(Name = "dbo.UpdateQuestion")]
        public int UpdateQuestion(
            [Parameter(DbType = "Int")] int? oid, 
            [Parameter(DbType = "Int")] int? pid, 
            [Parameter(DbType = "Int")] int? n,
            [Parameter(DbType = "VARCHAR(1000)")] string answer)
        {
            var result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), oid, pid, n, answer);
            return ((int)(result.ReturnValue));
        }
        public IQueryable<View.OrgPerson> OrgPeople(int? oid, string sgfilter)
	    {
	        return OrgPeople(oid, GroupSelectCode.Member, null, null, sgfilter, false, false, false);
	    }
	    public IQueryable<View.OrgPerson> OrgPeople(
             int? oid,
             string first,
             string last,
             string sgfilter,
             bool filterchecked,
             bool filtertag
	        )
	    {
	        return OrgPeople(oid, GroupSelectCode.Member, first, last, sgfilter, false, 
                Util2.CurrentTag, Util2.CurrentTagOwnerId, filterchecked,
	            filtertag, null, Util.UserPeopleId);
	    }
	    public IQueryable<View.OrgPerson> OrgPeople(
             int? oid,
             string grouptype,
             string first,
             string last,
             string sgfilter,
             bool showhidden,
             bool filterchecked,
             bool filtertag
	        )
	    {
	        return OrgPeople(oid, grouptype, first, last, sgfilter, showhidden, 
                Util2.CurrentTag, Util2.CurrentTagOwnerId, filterchecked,
	            filtertag, null, Util.UserPeopleId);
	    }
        public OrganizationMember LoadOrgMember(int PeopleId, string OrgName, bool orgmustexist)
        {
            if (orgmustexist)
            {
                var org = Organizations.SingleOrDefault(oo => oo.OrganizationName == OrgName);
                if (org == null)
                    throw new Exception("Org Named '" + OrgName + "' does not exist");
            }
            return OrganizationMember.Load(this, PeopleId, OrgName);
        }
        public IEnumerable<string[]> StatusFlags()
        {
            var q = from c in Queries
                    where c.Name.StartsWith("F") && c.Name.Contains(":")
                    orderby c.Name
                    select c.Name;

            const string FindPrefix = @"^F\d+:.*";
            var re = new Regex(FindPrefix, RegexOptions.Singleline | RegexOptions.Multiline);
            var q2 = from s in q.ToList()
                     where re.Match(s).Success
                     let a = s.SplitStr(":", 2)
                     select new[] { a[0], a[1] };
            return q2;
        }
        public IEnumerable<string[]> QueryStatClauses()
        {
            var q = from c in Queries
                    where c.Name.StartsWith("S") && c.Name.Contains(":")
                    select c.Name;

            const string FindPrefix = @"^S\d+:.*";
            var re = new Regex(FindPrefix, RegexOptions.Singleline | RegexOptions.Multiline);
            var q2 = from s in q.ToList()
                     where re.Match(s).Success
                     let a = s.SplitStr(":", 2)
                     select new[] { a[0], a[1] };
            return q2;
        }
        public Content Content(string name)
        {
            return Contents.FirstOrDefault(c => c.Name == name);
        }
        public string Content(string name, string defaultValue)
        {
            var content = Contents.FirstOrDefault(c => c.Name == name);
            if (content != null)
                return content.Body;
            return defaultValue;
        }
        public Content ContentOfTypeHtml(string name)
        {
            var content = (from c in Contents
                           where c.Name == name
                           where c.TypeID == ContentTypeCode.TypeHtml
                           select c).FirstOrDefault();
            return content;
        }
        public string ContentOfTypePythonScript(string name)
        {
            var content = (from c in Contents
                           where c.Name == name
                           where c.TypeID == ContentTypeCode.TypePythonScript
                           select c).FirstOrDefault();
            if (content == null)
                return "";
            return content.Body;
        }
        public Content Content(string name, string defaultValue, int contentTypeId)
        {
            var c = Contents.FirstOrDefault(cc => cc.Name == name);
            if (c == null)
            {
                c = new Content()
                        {
                            Name = name,
                            Title = name,
                            Body = defaultValue,
                            TypeID = contentTypeId
                        };
                Contents.InsertOnSubmit(c);
                SubmitChanges();
            }
            return c;
        }
        public string Content2(string name, string defaultValue, int contentTypeId)
        {
            var c = Content(name, defaultValue, contentTypeId);
            return c.Body;
        }
        public string ContentHtml(string name, string defaultValue)
        {
            return Content2(name, defaultValue, ContentTypeCode.TypeHtml);
        }
        public string ContentText(string name, string defaultValue)
        {
            return Content2(name, defaultValue, ContentTypeCode.TypeText);
        }
        public void SetNoLock()
        {
            //ExecuteCommand("SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED"); 
        }

        public int FetchOrCreateCampusId(string name)
        {
            var c = Campus.SingleOrDefault(pp => pp.Description == name);
            if (c == null)
            {
                var max = 10;
                if (Campus.Any())
                    max = Campus.Max(mm => mm.Id) + 10;
                c = new Campu() { Id = max, Description = name, Code = name.Truncate(20) };
                Campus.InsertOnSubmit(c);
                SubmitChanges();
            }
            return c.Id;
        }

        public ContributionFund FetchOrCreateFund(string Description)
        {
            return FetchOrCreateFund(0, Description);
        }
        public EntryPoint FetchOrCreateEntryPoint(string type)
        {
            var ep = EntryPoints.SingleOrDefault(pp => pp.Description == type);
            if (ep == null)
            {
                var max = EntryPoints.Max(mm => mm.Id) + 10;
                if (max < 1000)
                    max = 1010;
                ep = new EntryPoint { Id = max, Description = type, Code = type.Truncate(20) };
                EntryPoints.InsertOnSubmit(ep);
                SubmitChanges();
            }
            return ep;
        }
        public ContributionFund FetchOrCreateFund(int FundId, string Description)
        {
            ContributionFund fund;
            if (FundId > 0)
                fund = ContributionFunds.SingleOrDefault(f => f.FundId == FundId);
            else
                fund = ContributionFunds.FirstOrDefault(f => f.FundName == Description && f.FundStatusId == 1);
            if (fund == null)
            {
                int nextfundid;
                if (FundId > 0)
                    nextfundid = FundId;
                else
                    nextfundid = ContributionFunds.Max(ff => ff.FundId) + 1;
                fund = new ContributionFund
                {
                    FundName = Description,
                    FundDescription = Description,
                    FundId = nextfundid,
                    CreatedBy = 1,
                    CreatedDate = DateTime.Now,
                    FundStatusId = 1,
                    FundTypeId = 1,
                    FundPledgeFlag = false,
                };
                ContributionFunds.InsertOnSubmit(fund);
                SubmitChanges();
            }
            return fund;
        }
        public int ActiveRecords()
        {
            const string name = "ActiveRecords";
            var qb = Queries.FirstOrDefault(c => c.Name == name && c.Owner == "public");
            Condition cc = qb == null ? ScratchPadCondition() : qb.ToClause();
            cc.Reset(this);
            cc.SetComparisonType(CompareType.AnyTrue);
            var clause = cc.AddNewClause(QueryType.RecentAttendCount, CompareType.GreaterEqual, "1");
            clause.Days = 365;
            clause = cc.AddNewClause(QueryType.RecentHasIndContributions, CompareType.Equal, "1,T");
            clause.Days = 365;
            cc.AddNewClause(QueryType.IncludeDeceased, CompareType.Equal, "1,T");
            qb = cc.JustLoadedQuery;
            cc.Description = name;
            cc.Save(this, owner: "public");
            FromActiveRecords = true;
            var n = PeopleQuery(cc.Id).Count();
            FromActiveRecords = false;
            return n;
        }
        public int ActiveRecords2()
        {
            const string name = "ActiveRecords2";
            var qb = Queries.FirstOrDefault(c => c.Name == name && c.Owner == "david");
            Condition cc = qb == null ? ScratchPadCondition() : qb.ToClause();
            cc.Reset(this);
            cc.SetComparisonType(CompareType.AnyTrue);
            var clause = cc.AddNewClause(QueryType.RecentAttendCount, CompareType.Greater, "1");
            clause.Days = 365;
            clause = cc.AddNewClause(QueryType.RecentHasIndContributions, CompareType.Equal, "1,T");
            clause.Days = 365;
            cc.AddNewClause(QueryType.IncludeDeceased, CompareType.Equal, "1,T");
            qb = cc.JustLoadedQuery;
            cc.Description = name;
            cc.Save(this, owner: "david");
            FromActiveRecords = true;
            var n = PeopleQuery(cc.Id).Count();
            FromActiveRecords = false;
            return n;
        }
        public int ActiveRecordsdt(DateTime dt)
        {
            Condition cc = ScratchPadCondition();
            cc.Reset(this);
            cc.SetComparisonType(CompareType.AnyTrue);
            var clause = cc.AddNewClause(QueryType.AttendCntHistory, CompareType.GreaterEqual, "1");
            clause.StartDate = dt.AddDays(-365);
            clause.EndDate = dt;
            clause = cc.AddNewClause(QueryType.HadIndContributions, CompareType.Equal, "1,T");
            clause.StartDate = dt.AddDays(-365);
            clause.EndDate = dt;
            cc.AddNewClause(QueryType.IncludeDeceased, CompareType.Equal, "1,T");
            cc.Save(this);
            FromActiveRecords = true;
            var n = PeopleQuery(cc.Id).Count();
            FromActiveRecords = false;
            return n;
        }
        public int ActiveRecords2dt(DateTime dt)
        {
            Condition cc = ScratchPadCondition();
            cc.Reset(this);
            cc.SetComparisonType(CompareType.AnyTrue);
            var clause = cc.AddNewClause(QueryType.AttendCntHistory, CompareType.Greater, "1");
            clause.StartDate = dt.AddDays(-365);
            clause.EndDate = dt;
            clause = cc.AddNewClause(QueryType.HadIndContributions, CompareType.Equal, "1,T");
            clause.StartDate = dt.AddDays(-365);
            clause.EndDate = dt;
            cc.AddNewClause(QueryType.IncludeDeceased, CompareType.Equal, "1,T");
            cc.Save(this);
            FromActiveRecords = true;
            var n = PeopleQuery(cc.Id).Count();
            FromActiveRecords = false;
            return n;
        }



        internal bool FromActiveRecords { get; set; }
        public bool FromBatch { get; set; }

        public IGateway Gateway(bool testing = false, string usegateway = null)
        {
            var type = Setting("TransactionGateway", "not specified");
            if (usegateway != null)
                type = usegateway;

            switch (type.ToLower())
            {
                case "sage":
                    return new SageGateway(this, testing);

                case "authorizenet":
                    return new AuthorizeNetGateway(this, testing);

                case "transnational":
                    return new TransNationalGateway(this, testing);
                //IS THIS the only place that the new paymentGateway needs to be hooked up?
                case "bluepay":
                    return new BluePayGateway(this, testing);
            }

            throw new Exception("Gateway ({0}) is not supported.".Fmt(type));
        }
    }
}
