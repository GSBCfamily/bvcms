using System.Web.Mvc;
using CmsData;
using CmsWeb.Models;

namespace CmsWeb.Areas.Manage.Controllers
{
    [Authorize(Roles="Edit")]
    [RouteArea("Manage", AreaPrefix= "OrgMembers"), Route("{action=index}/{id?}")]
    public class OrgMembersController : CmsStaffController
    {
        [HttpGet]
        public ActionResult Index()
        {
            var m = new OrgMembersModel2();
            m.FetchSavedIds();
            return View(m);
        }

        [HttpPost]
        public ActionResult Move(OrgMembersModel2 m)
        {
            if (m.List.Count == 0)
                return Content("!None Selected");
            if (m.TargetId == 0)
                return Content("!Target required");
            m.Move();
            return View("List", m);
        }
        [HttpPost]
        public ActionResult EmailNotices(OrgMembersModel2 m)
        {
            m.SendMovedNotices();
            return View("List", m);
        }
        public ActionResult GradeList(int id)
        {
            var m = new OrgMembersModel2();
            UpdateModel(m);
            return m.ToExcel(id);
        }

        [HttpPost]
        public ActionResult List(OrgMembersModel2 m)
        {
            m.ValidateIds();
            DbUtil.Db.SetUserPreference("OrgMembersModelIds", $"{m.ProgId}.{m.SourceDivId}.{m.SourceId}");
            DbUtil.DbDispose();
            DbUtil.Db.SetNoLock();
            return View(m);
        }
        [HttpPost]
        public ActionResult ResetMoved(OrgMembersModel2 m)
        {
            m.ResetMoved();
            return View("List", m);
        }
    }
}
