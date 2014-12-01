using System.Web.Mvc;
using CmsData;
using CmsWeb.Areas.People.Models;
using CmsWeb.Models;
using UtilityExtensions;

namespace CmsWeb.Areas.People.Controllers
{
    public partial class PersonController
    {
        [HttpPost]
        public ActionResult ContactsMade(int id, PagerModel2 pager)
        {
            var m = new ContactsMadeModel(id, pager);
            return View("Ministry/Contacts", m);
        }
        [HttpPost]
        public ActionResult AddContactMade(int id)
        {
            var p = DbUtil.Db.LoadPersonById(id);
            DbUtil.LogActivity("Adding contact from: {0}".Fmt(p.Name));
            var c = new Contact
            {
                CreatedDate = Util.Now,
                CreatedBy = Util.UserId1,
                ContactDate = Util.Now.Date,
            };

            DbUtil.Db.Contacts.InsertOnSubmit(c);
            DbUtil.Db.SubmitChanges();

            var cp = new Contactor
            {
                PeopleId = p.PeopleId,
                ContactId = c.ContactId
            };

            DbUtil.Db.Contactors.InsertOnSubmit(cp);
            DbUtil.Db.SubmitChanges();

            TempData["ContactEdit"] = true;
            return Content("/Contact2/" + c.ContactId);
        }
        [HttpPost]
        public ActionResult ContactsReceived(int id, PagerModel2 pager)
        {
            var m = new ContactsReceivedModel(id, pager);
            return View("Ministry/Contacts", m);
        }
        [HttpPost]
        public ActionResult AddContactReceived(int id)
        {
            var p = DbUtil.Db.LoadPersonById(id);
            DbUtil.LogActivity("Adding contact to: {0}".Fmt(p.Name));
            var c = new Contact
            {
                CreatedDate = Util.Now,
                CreatedBy = Util.UserId1,
                ContactDate = Util.Now.Date,
            };

            DbUtil.Db.Contacts.InsertOnSubmit(c);
            DbUtil.Db.SubmitChanges();

            c.contactees.Add(new Contactee { PeopleId = p.PeopleId });
            c.contactsMakers.Add(new Contactor { PeopleId = Util.UserPeopleId.Value });
            DbUtil.Db.SubmitChanges();

            TempData["ContactEdit"] = true;
            return Content("/Contact2/{0}".Fmt(c.ContactId));
        }
        [HttpPost]
        public ActionResult TasksAbout(int id, PagerModel2 pager)
        {
            var m = new TasksAboutModel(id, pager);
            return View("Ministry/Tasks", m);
        }
        [HttpPost]
        public ActionResult AddTaskAbout(int id)
        {
            var p = DbUtil.Db.LoadPersonById(id);
            if (p == null || !Util.UserPeopleId.HasValue)
                return Content("no id");
            var t = p.AddTaskAbout(DbUtil.Db, Util.UserPeopleId.Value, "Please Contact");
            DbUtil.Db.SubmitChanges();
            return Content("/Task/List/{0}".Fmt(t.Id));
        }
        [HttpPost]
        public ActionResult TasksAssigned(int id, PagerModel2 pager)
        {
            var m = new TasksAssignedModel(id, pager);
            return View("Ministry/Tasks", m);
        }
        [HttpPost]
        public ActionResult VolunteerApprovals(int id)
        {
            var m = new Main.Models.Other.VolunteerModel(id);
            return View("Ministry/Volunteer", m);
        }
    }
}
