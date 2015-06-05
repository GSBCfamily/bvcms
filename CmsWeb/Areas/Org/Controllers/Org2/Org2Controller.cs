using System.Linq;
using System.Web.Mvc;
using CmsData;
using UtilityExtensions;
using CmsData.Codes;
using CmsWeb.Areas.Org2.Models;

namespace CmsWeb.Areas.Org2.Controllers
{
    [RouteArea("Org", AreaPrefix = "Org"), Route("{action}/{id?}")]
    [ValidateInput(false)]
    [SessionExpire]
    public partial class Org2Controller : CmsStaffController
    {
        const string needNotify = "WARNING: please add the notify persons on messages tab.";

        [HttpGet, Route("~/Org/{id:int}")]
        public ActionResult Index(int id, int? peopleid = null)
        {
//            if(!Util2.UseNewOrg)
//                return Redirect("/Organization/" + id);
            var db = DbUtil.Db;
            db.CurrentOrg = new CurrentOrg() { Id=id, GroupSelect = GroupSelectCode.Member};

            var m = new OrganizationModel(id);
            if (peopleid.HasValue)
                m.NameFilter = peopleid.ToString();

            if (m.Org == null)
                return Content("organization not found");

            if (Util2.OrgMembersOnly)
            {
                if (m.Org.SecurityTypeId == 3)
                    return NotAllowed("You do not have access to this page", m.Org.OrganizationName);
                if (m.Org.OrganizationMembers.All(om => om.PeopleId != Util.UserPeopleId))
                    return NotAllowed("You must be a member of this organization", m.Org.OrganizationName);
            }
            else if (Util2.OrgLeadersOnly)
            {
                var oids = DbUtil.Db.GetLeaderOrgIds(Util.UserPeopleId);
                if (!oids.Contains(m.Org.OrganizationId))
                    return NotAllowed("You must be a leader of this organization", m.Org.OrganizationName);
                var sgleader = DbUtil.Db.SmallGroupLeader(id, Util.UserPeopleId);
                if (sgleader.HasValue())
                {
                    db.CurrentOrg.SgFilter = sgleader;
                    m.SgFilter = sgleader;
                }
            }
            if (m.Org.LimitToRole.HasValue())
                if (!User.IsInRole(m.Org.LimitToRole))
                    return NotAllowed("no privilege to view ", m.Org.OrganizationName);

            DbUtil.LogActivity("Viewing Org({0})".Fmt(m.Org.OrganizationName), m.Org.OrganizationName, orgid: id);

            ViewBag.OrganizationContext = true;
            ViewBag.orgname = m.Org.FullName;
            ViewBag.model = m;
            ViewBag.selectmode = 0;
            InitExportToolbar(id);
            m.GroupSelect = "10";
            Session["ActiveOrganization"] = m.Org.OrganizationName;
            return View(m);
        }
        private ActionResult NotAllowed(string error, string name)
        {
            DbUtil.LogActivity("Trying to view Organization ({0})".Fmt(name));
            return Content("<h3 style='color:red'>{0}</h3>\n<a href='{1}'>{2}</a>"
                                    .Fmt(error, "javascript: history.go(-1)", "Go Back"));
        }

        [Authorize(Roles = "Delete")]
        [HttpPost]
        public ActionResult Delete(int id)
        {
            var org = DbUtil.Db.LoadOrganizationById(id);
            if (org == null)
                return Content("error, bad orgid");
            if (id == 1)
                return Content("Cannot delete first org");
            if (!org.PurgeOrg(DbUtil.Db))
                return Content("error, not deleted");
            var currorg = Util2.CurrentOrganization;
            currorg.Id = 0;
            currorg.SgFilter = null;
            DbUtil.LogActivity("Delete Org {0}".Fmt(Session["ActiveOrganization"]));
            Session.Remove("ActiveOrganization");
            return Content("ok");
        }

        private void InitExportToolbar(int oid)
        {
            ViewBag.oid = oid;
            var qid = DbUtil.Db.QueryInCurrentOrg().QueryId;
            ViewBag.queryid = qid;
            ViewBag.TagAction = "/Org/TagAll/" + qid;
            ViewBag.UnTagAction = "/Org/UnTagAll/" + qid;
            ViewBag.AddContact = "/Org/AddContact/" + qid;
            ViewBag.AddTasks = "/Org/AddTasks/" + qid;
            ViewBag.OrganizationContext = true;
            if (!DbUtil.Db.Organizations.Any(oo => oo.ParentOrgId == oid)) 
                return;
            ViewBag.ParentOrgContext = true;
            ViewBag.leadersqid = DbUtil.Db.QueryLeadersUnderCurrentOrg().QueryId;
            ViewBag.membersqid = DbUtil.Db.QueryMembersUnderCurrentOrg().QueryId;
        }

        [HttpPost]
        public ActionResult Settings(int id)
        {
            var m = new OrganizationModel(id);
            return PartialView(m);
        }
        [HttpPost]
        public ActionResult Registrations(int id)
        {
            var m = new OrganizationModel(id);
            return PartialView(m);
        }
    }
}