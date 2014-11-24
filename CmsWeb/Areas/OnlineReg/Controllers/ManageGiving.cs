using System;
using System.Linq;
using System.Web.Mvc;
using CmsData;
using CmsWeb.Models;
using UtilityExtensions;

namespace CmsWeb.Areas.OnlineReg.Controllers
{
	public partial class OnlineRegController
	{
		public ActionResult ManagePledge(string id)
		{
			if (!id.HasValue())
				return Content("bad link");
			ManagePledgesModel m = null;
			var td = TempData["mp"];
			if (td != null)
				m = new ManagePledgesModel(td.ToInt(), id.ToInt());
			else
			{
				var guid = id.ToGuid();
				if (guid == null)
					return Content("invalid link");
				var ot = DbUtil.Db.OneTimeLinks.SingleOrDefault(oo => oo.Id == guid.Value);
				if (ot == null)
					return Content("invalid link");
				if (ot.Used)
					return Content("link used");
				if (ot.Expires.HasValue && ot.Expires < DateTime.Now)
					return Content("link expired");
				var a = ot.Querystring.Split(',');
				m = new ManagePledgesModel(a[1].ToInt(), a[0].ToInt());
				ot.Used = true;
				DbUtil.Db.SubmitChanges();
			}
			SetHeaders(m.orgid);
			DbUtil.LogActivity("Manage Pledge: {0} ({1})".Fmt(m.Organization.OrganizationName, m.person.Name));
            return View("ManagePledge/Index", m);
		}

		[HttpGet]
		public ActionResult ManageGiving(string id, bool? testing)
		{
			if (!id.HasValue())
				return Content("bad link");
			ManageGivingModel m = null;
			var td = TempData["mg"];
			if (td != null)
				m = new ManageGivingModel(td.ToInt(), id.ToInt());
			else
			{
				var guid = id.ToGuid();
				if (guid == null)
					return Content("invalid link");
				var ot = DbUtil.Db.OneTimeLinks.SingleOrDefault(oo => oo.Id == guid.Value);
				if (ot == null)
					return Content("invalid link");
#if DEBUG2
#else
				if (ot.Used)
					return Content("link used");
#endif
				if (ot.Expires.HasValue && ot.Expires < DateTime.Now)
					return Content("link expired");
				var a = ot.Querystring.Split(',');
				m = new ManageGivingModel(a[1].ToInt(), a[0].ToInt());
				ot.Used = true;
				DbUtil.Db.SubmitChanges();
			}
			if (!m.testing)
				m.testing = testing ?? false;
			SetHeaders(m.orgid);
			DbUtil.LogActivity("Manage Giving: {0} ({1})".Fmt(m.Organization.OrganizationName, m.person.Name));
            return View("ManageGiving/Setup", m);
		}

		[HttpPost]
		public ActionResult ManageGiving(ManageGivingModel m)
		{
			SetHeaders(m.orgid);

            // only validate if the amounts are greater than zero.
		    if (m.FundItemsChosen().Sum(f => f.amt) > 0)
		    {
                m.ValidateModel(ModelState);
                if (!ModelState.IsValid)
                {
                    m.total = 0;
                    foreach (var ff in m.FundItemsChosen())
                        m.total += ff.amt;
                    return View("ManageGiving/Setup", m);
                }
		    }
            
            try
			{
				m.Update();
			}
			catch (Exception ex)
			{
				ModelState.AddModelError("form", ex.Message);
			}
		    if (!ModelState.IsValid)
				return View("ManageGiving/Setup", m);

			TempData["managegiving"] = m;
			return Redirect("/OnlineReg/ConfirmRecurringGiving");
		}

	    public ActionResult ConfirmRecurringGiving()
		{
			var m = TempData["managegiving"] as ManageGivingModel;
			if (m == null)
				return Content("No active registration");

            if (Util.IsDebug())
    			m.testing = true;

            if (!m.ManagedGivingStopped)
                m.Confirm(this);

	        SetHeaders(m.orgid);
	        LogOutOfOnlineReg();

		    return View("ManageGiving/Confirm", m);
		}

	    [HttpPost]
		public ActionResult ConfirmPledge(ManagePledgesModel m)
		{
            m.Confirm();
	        SetHeaders(m.orgid);
			return View("ManagePledge/Confirm", m);
		}

	    [HttpPost]
	    public ActionResult RemoveManagedGiving(int orgId)
	    {
	        var peopleId = Util.UserPeopleId ?? 0;
	        var manageGiving = new ManageGivingModel(peopleId, orgId);
            manageGiving.CancelManagedGiving(peopleId);
	        manageGiving.ThankYouMessage = "Your recurring giving has been stopped.";

	        TempData["managegiving"] = manageGiving;

	        return Json(new { Url = Url.Action("ConfirmRecurringGiving") });
	    }
	}
}
