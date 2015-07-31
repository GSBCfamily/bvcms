using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;
using CmsData;
using CmsData.Registration;
using CmsWeb.Areas.People.Models;
using Dapper;
using Newtonsoft.Json;
using UtilityExtensions;
using CmsWeb.Models;
using HtmlAgilityPack;

namespace CmsWeb.Controllers
{
    public class HomeController : CmsStaffController
    {
        public ActionResult Index()
        {
            if (!Util2.OrgMembersOnly && User.IsInRole("OrgMembersOnly"))
            {
                Util2.OrgMembersOnly = true;
                DbUtil.Db.SetOrgMembersOnly();
            }
            else if (!Util2.OrgLeadersOnly && User.IsInRole("OrgLeadersOnly"))
            {
                Util2.OrgLeadersOnly = true;
                DbUtil.Db.SetOrgLeadersOnly();
            }
            var m = new HomeModel();
            return View(m);
        }

        [ValidateInput(false)]
        public ActionResult ShowError(string error, string url)
        {
            ViewData["error"] = Server.UrlDecode(error);
            ViewData["url"] = url;
            return View();
        }

        public ActionResult NewQuery()
        {
            var qb = DbUtil.Db.ScratchPadCondition();
            qb.Reset(DbUtil.Db);
            qb.Save(DbUtil.Db);
            return Redirect("/Query");
        }

#if DEBUG
        [HttpGet, Route("~/Test")]
        public ActionResult Test()
        {
            var o = DbUtil.Db.LoadOrganizationById(90796);
            var os = new Settings(o.RegSetting, DbUtil.Db, o.OrganizationId);
            var x = Util.Serialize(os);
            var rs = Util.DeSerialize<Settings>(x);
            return Content(x, "text/plain");
        }
#endif

        public ActionResult RecordTest(int id, string v)
        {
            var o = DbUtil.Db.LoadOrganizationById(id);
            o.AddEditExtra(DbUtil.Db, "tested", v);
            DbUtil.Db.SubmitChanges();
            return Content(v);
        }

        public ActionResult NthTimeAttenders(int id)
        {
            var name = "VisitNumber-" + id;
            var q = DbUtil.Db.Queries.FirstOrDefault(qq => qq.Owner == "System" && qq.Name == name);
            if (q != null)
                return Redirect("/Query/" + q.QueryId);

            const CompareType comp = CompareType.Equal;
            var cc = DbUtil.Db.ScratchPadCondition();
            cc.Reset(DbUtil.Db);
            Condition c;
            switch (id)
            {
                case 1:
                    c = cc.AddNewClause(QueryType.RecentVisitNumber, comp, "1,T");
                    c.Quarters = "1";
                    c.Days = 7;
                    break;
                case 2:
                    c = cc.AddNewClause(QueryType.RecentVisitNumber, comp, "1,T");
                    c.Quarters = "2";
                    c.Days = 7;
                    c = cc.AddNewClause(QueryType.RecentVisitNumber, comp, "0,F");
                    c.Quarters = "1";
                    c.Days = 7;
                    break;
                case 3:
                    c = cc.AddNewClause(QueryType.RecentVisitNumber, comp, "1,T");
                    c.Quarters = "3";
                    c.Days = 7;
                    c = cc.AddNewClause(QueryType.RecentVisitNumber, comp, "0,F");
                    c.Quarters = "2";
                    c.Days = 7;
                    break;
            }
            cc.Description = name;
            cc.Save(DbUtil.Db, owner: "System");
            TempData["autorun"] = true;
            return Redirect("/Query/" + cc.Id);
        }

        [Authorize(Roles = "Admin")]
        public ActionResult ActiveRecords(DateTime? dt)
        {
            if (dt.HasValue)
            {
                TempData["ActiveRecords"] = DbUtil.Db.ActiveRecordsdt(dt.Value);
                TempData["ActiveRecords2"] = DbUtil.Db.ActiveRecords2dt(dt.Value);
            }
            else
            {
                TempData["ActiveRecords"] = DbUtil.Db.ActiveRecords();
                TempData["ActiveRecords2"] = DbUtil.Db.ActiveRecords2();
            }
            return View("Support2");
        }

        public ActionResult TargetPerson(bool id)
        {
            DbUtil.Db.SetUserPreference("TargetLinkPeople", id ? "false" : "true");
            DbUtil.Db.SubmitChanges();
            if (Request.UrlReferrer != null)
                return Redirect(Request.UrlReferrer.OriginalString);
            return Redirect("/");
        }
        public ActionResult TargetOrg(bool id)
        {
            DbUtil.Db.SetUserPreference("TargetLinkOrg", id ? "false" : "true");
            DbUtil.Db.SubmitChanges();
            if (Request.UrlReferrer != null)
                return Redirect(Request.UrlReferrer.OriginalString);
            return Redirect("/");
        }
        public ActionResult UseNewFeature(bool id)
        {
            Util2.UseNewFeature = id;
            DbUtil.Db.SubmitChanges();
            if (Request.UrlReferrer != null)
                return Redirect(Request.UrlReferrer.OriginalString);
            return Redirect("/");
        }
        public ActionResult UseNewEditor(bool id)
        {
            DbUtil.Db.SetUserPreference("UseNewEditor", id ? "false" : "true");
            DbUtil.Db.SubmitChanges();
            if (Request.UrlReferrer != null)
                return Redirect(Request.UrlReferrer.OriginalString);
            return Redirect("/");
        }

        public ActionResult Names(string term)
        {
            var q = HomeModel.Names(term).ToList();
            return Json(q, JsonRequestBehavior.AllowGet);
        }

        [HttpPost, Route("~/FastSearch")]
        public ActionResult FastSearch(string q)
        {
            var qq = HomeModel.FastSearch(q).ToArray();
            return Content(JsonConvert.SerializeObject(qq));
        }

        [HttpGet, Route("~/FastSearchPrefetch")]
        public ActionResult FastSearchPrefetch()
        {
            Response.NoCache();
            var qq = HomeModel.PrefetchSearch().ToArray();
            return Content(JsonConvert.SerializeObject(qq));
        }

        public ActionResult SwitchTag(string tag)
        {
            var m = new TagsModel { tag = tag };
            m.SetCurrentTag();
            if (Request.UrlReferrer != null)
                return Redirect(Request.UrlReferrer.ToString());
            return Redirect("/");
        }

        [HttpGet, Route("~/TestScript")]
        [Authorize(Roles = "Developer")]
        public ActionResult TestScript()
        {
            return View();
        }

        [HttpPost, Route("~/TestScript")]
        [ValidateInput(false)]
        [Authorize(Roles = "Developer")]
        public ActionResult TestScript(string script)
        {
            return Content(PythonEvents.RunScript(Util.Host, script));
        }

        private string RunScriptSql(CMSDataContext Db, string parameter, string body)
        {
            if (!CanRunScript(body))
                return "Not Authorized to run this script";
            var declareqtagid = "";
            if (body.Contains("@qtagid"))
            {
                var id = Db.FetchLastQuery().Id;
                var tag = Db.PopulateSpecialTag(id, DbUtil.TagTypeId_Query);
                declareqtagid = $"DECLARE @qtagid INT = {tag.Id}\n";
            }
            return $"{declareqtagid}DECLARE @p1 VARCHAR(100) = '{parameter}' {body}";
        }

        [HttpGet, Route("~/RunScript/{name}/{parameter?}/{title?}")]
        public ActionResult RunScript(string name, string parameter = null, string title = null)
        {
            var content = DbUtil.Content(name);
            if (content == null)
                return Content("no content");
            var cs = User.IsInRole("Finance")
                ? Util.ConnectionString
                : Util.ConnectionStringReadOnly;
            var cn = new SqlConnection(cs);
            cn.Open();
            var script = RunScriptSql(DbUtil.Db, parameter, content.Body);
            if (script.StartsWith("Not Authorized"))
                return Message(script);
            ViewBag.name = title ?? $"Run Script {name} {parameter}";
            var cmd = new SqlCommand(script, cn);
            var rd = cmd.ExecuteReader();
            return View(rd);
        }

        private bool CanRunScript(string script)
        {
            if (!script.StartsWith("--Roles="))
                return true;
            var re = new Regex("--Roles=(?<roles>.*)");
            var roles = re.Match(script).Groups["roles"].Value.Split(',').Select(aa => aa.Trim());
            if (!roles.Any(rr => User.IsInRole(rr)))
                return false;
            return true;
        }

        [HttpGet, Route("~/RunScriptExcel/{scriptname}/{parameter?}")]
        public ActionResult RunScriptExcel(string scriptname, string parameter = null)
        {
            var content = DbUtil.Content(scriptname);
            if (content == null)
                return Message("no content");
            var cs = User.IsInRole("Finance")
                ? Util.ConnectionString
                : Util.ConnectionStringReadOnly;
            var cn = new SqlConnection(cs);
            var script = RunScriptSql(DbUtil.Db, parameter, content.Body);
            if (script.StartsWith("Not Authorized"))
                return Message(script);
            return cn.ExecuteReader(script).ToExcel("RunScript.xlsx");
        }

        [HttpGet, Route("~/PyScript/{name}")]
        public ActionResult PyScript(string name, string p1, string p2, string v1, string v2)
        {
            try
            {
                var script = DbUtil.Db.ContentOfTypePythonScript(name);
                if (!script.HasValue())
                    return Message("no script named " + name);

                if (script.Contains("model.Form"))
                    return Redirect("/PyScriptForm/" + name);
                script = script.Replace("@P1", p1 ?? "NULL")
                    .Replace("@P2", p2 ?? "NULL")
                    .Replace("V1", v1 ?? "None")
                    .Replace("V2", v2 ?? "None");

                var pe = new PythonEvents(Util.Host);

                foreach (var key in Request.QueryString.AllKeys)
                {
                    pe.DictionaryAdd(key, Request.QueryString[key]);
                }

                pe.RunScript(script);

                return View(pe);
            }
            catch (Exception ex)
            {
                return RedirectShowError(ex.Message);
            }
        }
        private string FetchPyScriptForm(string name)
        {
#if DEBUG2
                return System.IO.File.ReadAllText(Server.MapPath("~/PythonForm.py"));
#else
                return DbUtil.Db.ContentOfTypePythonScript(name);
#endif
        }
        [HttpGet, Route("~/PyScriptForm/{name}")]
        public ActionResult PyScriptForm(string name)
        {
            try
            {
                var script = FetchPyScriptForm(name);

                if (!script.HasValue())
                    return Message("no script named " + name);
                var pe = new PythonEvents(Util.Host);
                foreach (var key in Request.QueryString.AllKeys)
                    pe.DictionaryAdd(key, Request.QueryString[key]);
                pe.DictionaryAdd("pyscript", name);
                pe.HttpMethod = "get";
                pe.RunScript(script);
                return View(pe);
            }
            catch (Exception ex)
            {
                return RedirectShowError(ex.Message);
            }
        }
        [HttpPost, Route("~/PyScriptForm")]
        public ActionResult PyScriptForm()
        {
            try
            {
                var pe = new PythonEvents(Util.Host);
                foreach (var key in Request.Form.AllKeys)
                    pe.DictionaryAdd(key, Request.Form[key]);
                pe.HttpMethod = "post";

                var script = FetchPyScriptForm(pe.Dictionary("pyscript"));
                return Content(pe.RunScript(script));
            }
            catch (Exception ex)
            {
                return RedirectShowError(ex.Message);
            }
        }

        [HttpGet, Route("~/Preferences")]
        public ActionResult UserPreferences()
        {
            return View(DbUtil.Db.CurrentUser);
        }

        [HttpGet, Route("~/Home/Support2")]
        public ActionResult Support2(string helplink)
        {
            if (helplink.HasValue())
                TempData["HelpLink"] = HttpUtility.UrlDecode(helplink);
            return View();
        }
    }

    public class Home2Controller : CmsController
    {
        [HttpGet, Route("~/Home/MyDataSupport")]
        public ActionResult MyDataSupport()
        {
            return View("../Home/MyDataSupport");
        }

        [HttpPost, Route("~/HideTip")]
        public ActionResult HideTip(string tip)
        {
            DbUtil.Db.SetUserPreference("hide-tip-" + tip, "true");
            return new EmptyResult();
        }

        [HttpGet, Route("~/ResetTips")]
        public ActionResult ResetTips()
        {
            DbUtil.Db.ExecuteCommand("DELETE dbo.Preferences WHERE Preference LIKE 'hide-tip-%' AND UserId = {0}",
                Util.UserId);
            var d = Session["preferences"] as Dictionary<string, string>;
            var keys = d.Keys.Where(kk => kk.StartsWith("hide-tip-")).ToList();
            foreach (var k in keys)
                d.Remove(k);

            if (Request.UrlReferrer != null)
                return Redirect(Request.UrlReferrer.ToString());
            return Redirect("/");
        }

        [HttpGet]
        [Route("~/Person/TinyImage/{id}")]
        [Route("~/Person2/TinyImage/{id}")]
        [Route("~/TinyImage/{id}")]
        public ActionResult TinyImage(int id)
        {
            return new PictureResult(id, portrait: true, tiny: true);
        }

        [HttpGet]
        [Route("~/Person/Image/{id:int}/{w:int?}/{h:int?}")]
        [Route("~/Person2/Image/{id:int}/{w:int?}/{h:int?}")]
        [Route("~/Image/{id:int}/{w:int?}/{h:int?}")]
        public ActionResult Image(int id, int? w, int? h, string mode)
        {
            return new PictureResult(id);
        }

        [HttpGet, Route("~/ImageSized/{id:int}/{w:int}/{h:int}/{mode}")]
        public ActionResult ImageSized(int id, int w, int h, string mode)
        {
            var p = DbUtil.Db.LoadPersonById(id);
            return new PictureResult(p.Picture.LargeId ?? 0, w, h, portrait: true, mode: mode);
        }
    }
}
