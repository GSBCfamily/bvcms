﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CmsData;
using CmsData.ExtraValue;
using CmsWeb.Code;
using Dapper;
using MoreLinq;
using UtilityExtensions;

namespace CmsWeb.Models.ExtraValues
{
    public class NewExtraValueModel
    {
        public int Id { get; set; }
        public Guid QueryId { get; set; }
        public string ExtraValueTable { get; set; }
        public string ExtraValueLocation { get; set; }

        [DisplayName("Name"), StringLength(50), Required]
        public string ExtraValueName { get; set; }

        [DisplayName("Type")]
        public CodeInfo ExtraValueType { get; set; }

        [DisplayName("Checkboxes Prefix")]
        public string ExtraValueBitPrefix { get; set; }

        [DisplayName("Type")]
        public CodeInfo AdhocExtraValueType { get; set; }

        [DisplayName("HyperLink")]
        public string ExtraValueLink { get; set; }

        [DisplayName("Text Value")]
        public string ExtraValueTextBox { get; set; }

        [DisplayName("Text Value"), UIHint("Textarea")]
        public string ExtraValueTextArea { get; set; }

        [DisplayName("Date Value")]
        public DateTime? ExtraValueDate { get; set; }

        [DisplayName("Checkbox Value")]
        public bool ExtraValueCheckbox { get; set; }

        [DisplayName("Integer Value")]
        public int ExtraValueInteger { get; set; }

        public bool RemoveAnyValue { get; set; }

        private string BitPrefix
        {
            get
            {
                if (ExtraValueBitPrefix.HasValue())
                    return ExtraValueBitPrefix + ":";
                return "";
            }
        }
        [DisplayName("Codes")]
        public string ExtraValueCodes { get; set; }

        [DisplayName("Checkboxes"), UIHint("Textarea")]
        public string ExtraValueCheckboxes { get; set; }

        [DisplayName("Limit to Roles")]
        public string VisibilityRoles
        {
            get { return string.Join(", ", VisibilityRolesList ?? new string[0]); }
            set { VisibilityRolesList = (value ?? "").Split(',').Select(x => x.Trim()).Where(x => !string.IsNullOrWhiteSpace(x)).ToArray(); }
        }

        [DisplayName("Limit to Roles")]
        public string[] VisibilityRolesList { get; set; }

		public IEnumerable<SelectListItem> Roles()
		{
			var q = from r in DbUtil.Db.Roles
			        orderby r.RoleName
			        select new SelectListItem
			        {
						Value = r.RoleName,
						Text = r.RoleName
			        };
			var list = q.ToList();
		    foreach (var item in list.Where(item => VisibilityRoles.Contains(item.Text)))
		    {
		        item.Selected = true;
		    }
			return list;
		}

        public NewExtraValueModel(Guid id)
        {
            ExtraValueType = new CodeInfo("Text", "ExtraValueType");
            AdhocExtraValueType = new CodeInfo("Text", "AdhocExtraValueType");
            QueryId = id;
            ExtraValueTable = "People";
            ExtraValueLocation = "Adhoc";
        }

        public NewExtraValueModel(int id, string table, string location)
        {
            ExtraValueType = new CodeInfo("Text", "ExtraValueType");
            AdhocExtraValueType = new CodeInfo("Text", "AdhocExtraValueType");
            Id = id;
            ExtraValueTable = table;
            ExtraValueLocation = location;
        }
        public NewExtraValueModel() { }

        public NewExtraValueModel(string table, string name)
        {
            var f = Views.GetStandardExtraValues(DbUtil.Db, table).Single(ee => ee.Name == name);
            ExtraValueType = new CodeInfo(f.Type, "ExtraValueType");
            ExtraValueName = name;
            ExtraValueTable = table;
            VisibilityRoles = f.VisibilityRoles;
            ExtraValueLink = HttpUtility.HtmlDecode(f.Link);
            var codes = string.Join("\n", f.Codes);
            switch (ExtraValueType.Value)
            {
                case "Bits": ExtraValueCheckboxes = codes; break;
                case "Code": ExtraValueCodes = codes; break;
            }
        }

        private void TryCheckIntegrity()
        {
            const string nameAlreadyExistsAsADifferentType = "{0} already exists as a different type";
            string type = ExtraValueLocation == "Adhoc" ? AdhocExtraValueType.Value : ExtraValueType.Value;
            if (type == "Text2")
                type = "Text";
            switch (ExtraValueTable)
            {
                case "People":
                    if (type == "Bits")
                        foreach (var b in ConvertToCodes().Where(b => DbUtil.Db.PeopleExtras.Any(ee => ee.Field == b && ee.Type != "Bit")))
                            throw new Exception(nameAlreadyExistsAsADifferentType.Fmt(b));
                    else
                        if (DbUtil.Db.PeopleExtras.Any(ee => ee.Field == ExtraValueName && ee.Type != type))
                            throw new Exception(nameAlreadyExistsAsADifferentType.Fmt(ExtraValueName));
                    break;
                case "Family":
                    if (type == "Bits")
                        foreach (var b in ConvertToCodes().Where(b => DbUtil.Db.FamilyExtras.Any(ee => ee.Field == b && ee.Type != "Bit")))
                            throw new Exception(nameAlreadyExistsAsADifferentType.Fmt(b));
                    else
                        if (DbUtil.Db.FamilyExtras.Any(ee => ee.Field == ExtraValueName && ee.Type != type))
                            throw new Exception(nameAlreadyExistsAsADifferentType.Fmt(ExtraValueName));
                    break;
                case "Organization":
                    if (type == "Bits")
                        foreach (var b in ConvertToCodes().Where(b => DbUtil.Db.OrganizationExtras.Any(ee => ee.Field == b && ee.Type != "Bit")))
                            throw new Exception(nameAlreadyExistsAsADifferentType.Fmt(b));
                    else
                        if (DbUtil.Db.OrganizationExtras.Any(ee => ee.Field == ExtraValueName && ee.Type != type))
                            throw new Exception(nameAlreadyExistsAsADifferentType.Fmt(ExtraValueName));
                    break;
                case "Meeting":
                    if (type == "Bits")
                        foreach (var b in ConvertToCodes().Where(b => DbUtil.Db.MeetingExtras.Any(ee => ee.Field == b && ee.Type != "Bit")))
                            throw new Exception(nameAlreadyExistsAsADifferentType.Fmt(b));
                    else
                        if (DbUtil.Db.MeetingExtras.Any(ee => ee.Field == ExtraValueName && ee.Type != type))
                            throw new Exception(nameAlreadyExistsAsADifferentType.Fmt(ExtraValueName));
                    break;
            }
        }

        public List<string> ConvertToCodes()
        {
            const string defaultCodes = @"
Option 1
Option 2
";
            var codes = ExtraValueType.Value == "Bits"
                ? ExtraValueCheckboxes ?? defaultCodes
                : ExtraValueType.Value == "Code"
                    ? ExtraValueCodes ?? defaultCodes
                    : null;
            return codes.SplitLines(noblanks: true).Select(ss => BitPrefix + ss).ToList();
        }

        public string AddAsNewStandard()
        {
            ExtraValueName = ExtraValueName.Replace('/', '-');
            var fields = Views.GetStandardExtraValues(DbUtil.Db, ExtraValueTable);
            var existing = fields.SingleOrDefault(ff => ff.Name == ExtraValueName);
            if (existing != null)
                throw new Exception("{0} already exists".Fmt(ExtraValueName));

            TryCheckIntegrity();

            var v = new CmsData.ExtraValue.Value
            {
                Type = ExtraValueType.Value,
                Name = ExtraValueName,
                VisibilityRoles = VisibilityRoles,
                Codes = ConvertToCodes(),
                Link = HttpUtility.HtmlEncode(ExtraValueLink)
            };
            var i = Views.GetViewsView(DbUtil.Db, ExtraValueTable, ExtraValueLocation);
            i.view.Values.Add(v);
            i.views.Save(DbUtil.Db);
            return null;
        }

        public string AddAsNewAdhoc()
        {
            TryCheckIntegrity();
            if (Id > 0)
                return AddNewExtraValueToRecord();
            return AddNewExtraValueToSelectionFromQuery();
        }

        private string AddNewExtraValueToRecord()
        {
            var o = ExtraValueModel.TableObject(Id, ExtraValueTable);
            switch (AdhocExtraValueType.Value)
            {
                case "Code":
                    o.AddEditExtraValue(ExtraValueName, ExtraValueTextBox);
                    break;
                case "Text":
                    o.AddEditExtraData(ExtraValueName, ExtraValueTextArea);
                    break;
                case "Text2":
                    o.AddEditExtraData(ExtraValueName, ExtraValueTextArea);
                    break;
                case "Date":
                    o.AddEditExtraDate(ExtraValueName, ExtraValueDate);
                    break;
                case "Int":
                    o.AddEditExtraInt(ExtraValueName, ExtraValueInteger);
                    break;
                case "Bit":
                    o.AddEditExtraBool(ExtraValueName, ExtraValueCheckbox);
                    break;
            }
            DbUtil.Db.SubmitChanges();
            return null;
        }

        private string AddNewExtraValueToSelectionFromQuery()
        {
            var list = DbUtil.Db.PeopleQuery(QueryId).Select(pp => pp.PeopleId).ToList();

            switch (AdhocExtraValueType.Value)
            {
                case "Code":
                    return AddNewExtraValueCodes(list);
                case "Text":
                case "Text2":
                    return AddNewExtraValueDatums(list);
                case "Date":
                    return AddNewExtraValueDates(list);
                case "Int":
                    return AddNewExtraValueInts(list);
                case "Bit":
                    return AddNewExtraValueBools(list);
            }
            return null;
        }

        private string AddNewExtraValueCodes(IEnumerable<int> list)
        {
            foreach (var pid in list)
            {
                Person.AddEditExtraValue(DbUtil.Db, pid, ExtraValueName, ExtraValueTextBox);
                DbUtil.Db.SubmitChanges();
                DbUtil.DbDispose();
            }
            return null;
        }
        private string AddNewExtraValueDatums(IEnumerable<int> list)
        {
            foreach (var pid in list)
            {
                Person.AddEditExtraData(DbUtil.Db, pid, ExtraValueName, ExtraValueTextArea);
                DbUtil.Db.SubmitChanges();
                DbUtil.DbDispose();
            }
            return null;
        }
        private string AddNewExtraValueDates(IEnumerable<int> list)
        {
            foreach (var pid in list)
            {
                Person.AddEditExtraDate(DbUtil.Db, pid, ExtraValueName, ExtraValueDate);
                DbUtil.Db.SubmitChanges();
                DbUtil.DbDispose();
            }
            return null;
        }
        private string AddNewExtraValueInts(IEnumerable<int> list)
        {
            foreach (var pid in list)
            {
                Person.AddEditExtraInt(DbUtil.Db, pid, ExtraValueName, ExtraValueInteger);
                DbUtil.Db.SubmitChanges();
                DbUtil.DbDispose();
            }
            return null;
        }
        private string AddNewExtraValueBools(IEnumerable<int> list)
        {
            foreach (var pid in list)
            {
                Person.AddEditExtraBool(DbUtil.Db, pid, ExtraValueName, ExtraValueCheckbox);
                DbUtil.Db.SubmitChanges();
                DbUtil.DbDispose();
            }
            return null;
        }

        public void DeleteFromQuery()
        {
            var tag = DbUtil.Db.PopulateSpecialTag(QueryId, DbUtil.TagTypeId_ExtraValues);

            var cn = new SqlConnection(Util.ConnectionString);
            cn.Open();
            const string sql = @"
delete from dbo.PeopleExtra
where Field = @name
and PeopleId in (select PeopleId from TagPerson where Id = @id)
";
            if (RemoveAnyValue)
            {
                cn.Execute(sql, new { name = ExtraValueName, id = tag.Id });
                return;
            }
            switch (AdhocExtraValueType.Value)
            {
                case "Bit":
                    cn.Execute(sql + "and BitValue = @value",
                        new { name = ExtraValueName, value = ExtraValueCheckbox, id = tag.Id });
                    break;
                case "Code":
                    cn.Execute(sql + "and StrValue = @value",
                        new { name = ExtraValueName, value = ExtraValueCheckbox, id = tag.Id });
                    break;
                case "Text2":
                case "Text":
                    cn.Execute(sql + "and Data = @value",
                        new { name = ExtraValueName, value = ExtraValueTextArea, id = tag.Id });
                    break;
                case "Date":
                    cn.Execute(sql + "and Date = @value",
                        new { name = ExtraValueName, value = ExtraValueDate, id = tag.Id });
                    break;
                case "Int":
                    cn.Execute(sql + "and IntValue = @value",
                        new { name = ExtraValueName, value = ExtraValueInteger, id = tag.Id });
                    break;
            }
        }

        public void ConvertToStandard(string name)
        {
//            var oldfields = StandardExtraValues.GetExtraValues().ToList();
            var oldfields = CmsData.ExtraValue.Views.GetStandardExtraValues(DbUtil.Db, "People");
            ExtraValue ev = null;
            List<string> codes = null;
            var v = new CmsData.ExtraValue.Value { Name = name };
            switch (ExtraValueTable)
            {
                case "People":
                    ev = (from vv in DbUtil.Db.PeopleExtras
                          where vv.Field == name
                          select new ExtraValue(vv, null)).First();

                    //StandardExtraValues.Field bits = null;
                    var bits = oldfields.SingleOrDefault(ff => ff.Codes.Contains(name));
                    if (bits != null)
                    {
                        codes = bits.Codes;
                        ev.Type = "Bits";
                        v.Name = bits.Name;
                        v.VisibilityRoles = bits.VisibilityRoles;
                    }
                    else
                    {
                        var f = oldfields.SingleOrDefault(ff => ff.Name == name);
                        if (f != null)
                            v.VisibilityRoles = f.VisibilityRoles;
                        if (ev.Type == "Code")
                        {
                            codes = (from vv in DbUtil.Db.PeopleExtras
                                     where vv.Field == name
                                     select vv.StrValue).Distinct().ToList();
                        }
                    }
                    break;
                case "Organization":
                    ev = (from vv in DbUtil.Db.OrganizationExtras
                          where vv.Field == name
                          select new ExtraValue(vv, null)).First();
                    if (ev.Type == "Code")
                        codes = (from vv in DbUtil.Db.OrganizationExtras
                                 where vv.Field == name
                                 select vv.StrValue).Distinct().ToList();
                    break;
                case "Family":
                    ev = (from vv in DbUtil.Db.FamilyExtras
                          where vv.Field == name
                          select new ExtraValue(vv, null)).First();
                    if (ev.Type == "Code")
                        codes = (from vv in DbUtil.Db.FamilyExtras
                                 where vv.Field == name
                                 select vv.StrValue).Distinct().ToList();
                    break;
                case "Meeting":
                    ev = (from vv in DbUtil.Db.MeetingExtras
                          where vv.Field == name
                          select new ExtraValue(vv, null)).First();
                    if (ev.Type == "Code")
                        codes = (from vv in DbUtil.Db.MeetingExtras
                                 where vv.Field == name
                                 select vv.StrValue).Distinct().ToList();
                    break;
                default:
                    return;
            }
            v.Type = ev.Type;
            v.Codes = codes;
            var i = Views.GetViewsView(DbUtil.Db, ExtraValueTable, ExtraValueLocation);
            i.view.Values.Add(v);
            i.views.Save(DbUtil.Db);
        }
    }
}
