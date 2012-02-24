﻿#pragma warning disable 1591
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.239
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CmsWeb.Views.Shared
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Text;
    using System.Web;
    using System.Web.Helpers;
    using System.Web.Mvc;
    using System.Web.Mvc.Ajax;
    using System.Web.Mvc.Html;
    using System.Web.Routing;
    using System.Web.Security;
    using System.Web.UI;
    using System.Web.WebPages;
    using CmsData;
    using CmsWeb;
    using UtilityExtensions;
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("RazorGenerator", "1.3.2.0")]
    [System.Web.WebPages.PageVirtualPathAttribute("~/Views/Shared/SiteLayout.cshtml")]
    public class SiteLayout : System.Web.Mvc.WebViewPage<dynamic>
    {
        public SiteLayout()
        {
        }
        public override void Execute()
        {
WriteLiteral("<!DOCTYPE html>\r\n<html>\r\n<head>\r\n    <title>");


            
            #line 4 "..\..\Views\Shared\SiteLayout.cshtml"
      Write(ViewBag.Title);

            
            #line default
            #line hidden
WriteLiteral("</title>\r\n    <link rel=\"shortcut icon\" href=\"/favicon.ico\" type=\"image/x-icon\" /" +
">\r\n    ");


            
            #line 6 "..\..\Views\Shared\SiteLayout.cshtml"
Write(Html.Partial("CombinedCss"));

            
            #line default
            #line hidden
WriteLiteral("\r\n    ");


            
            #line 7 "..\..\Views\Shared\SiteLayout.cshtml"
Write(RenderSection("head", required: false));

            
            #line default
            #line hidden
WriteLiteral("\r\n</head>\r\n<body>\r\n");


            
            #line 10 "..\..\Views\Shared\SiteLayout.cshtml"
   
    var admin = User.IsInRole("Admin");
    var manageemails = User.IsInRole("ManageEmails");
    var managetrans = User.IsInRole("ManageTransactions");


            
            #line default
            #line hidden

            
            #line 15 "..\..\Views\Shared\SiteLayout.cshtml"
 if (Util.UrgentMessage.HasValue())
{

            
            #line default
            #line hidden
WriteLiteral("        <div id=\'urgentNotice\'>");


            
            #line 17 "..\..\Views\Shared\SiteLayout.cshtml"
                          Write(Util.UrgentMessage);

            
            #line default
            #line hidden
WriteLiteral("</div>\r\n");


            
            #line 18 "..\..\Views\Shared\SiteLayout.cshtml"
}

            
            #line default
            #line hidden

            
            #line 19 "..\..\Views\Shared\SiteLayout.cshtml"
 if (DbUtil.TopNotice().HasValue())
{

            
            #line default
            #line hidden
WriteLiteral("        <div id=\'TopNotice\'>");


            
            #line 21 "..\..\Views\Shared\SiteLayout.cshtml"
                       Write(Html.Raw(DbUtil.TopNotice()));

            
            #line default
            #line hidden
WriteLiteral("</div>\r\n");


            
            #line 22 "..\..\Views\Shared\SiteLayout.cshtml"
}

            
            #line default
            #line hidden

            
            #line 23 "..\..\Views\Shared\SiteLayout.cshtml"
 if (Request.Browser.Type == "IE7")
{

            
            #line default
            #line hidden
WriteLiteral("        <div id=\"urgentNotice\">You are running IE7. This application requires IE8" +
"+, Firefox, Chrome or Safari</div>\r\n");


            
            #line 26 "..\..\Views\Shared\SiteLayout.cshtml"
}

            
            #line default
            #line hidden
WriteLiteral(@"    <div id=""container"">
        <div class=""header"">
            <table cellpadding=""0"" cellspacing=""0"" style=""width: 100%"">
                <tr>
                    <td class=""left"">
                        <a href=""/"">
                            ");


            
            #line 33 "..\..\Views\Shared\SiteLayout.cshtml"
                       Write(Html.Raw(DbUtil.HeaderImage(@"<img src=""/Content/bvcms132x55.png"" width=""132"" height=""55"" />")));

            
            #line default
            #line hidden
WriteLiteral("</a>\r\n                    </td>\r\n                    <td class=\"center\">\r\n       " +
"                 ");


            
            #line 36 "..\..\Views\Shared\SiteLayout.cshtml"
                   Write(Html.Raw(DbUtil.Header()));

            
            #line default
            #line hidden
WriteLiteral(@"
                    </td>
                    <td class=""right"">
                        <div id=""userarea"">
                            <div id=""welcome"" class=""dropdown left"">
                                <div>
                                    <a href=""#"" title=""");


            
            #line 42 "..\..\Views\Shared\SiteLayout.cshtml"
                                                  Write(Util.UserName);

            
            #line default
            #line hidden
WriteLiteral("\">Welcome, ");


            
            #line 42 "..\..\Views\Shared\SiteLayout.cshtml"
                                                                           Write(Util.UserPreferredName);

            
            #line default
            #line hidden
WriteLiteral("!\r\n                                        <img src=\"/Content/Welcome.png\" width=" +
"\"11\" height=\"16\"></a></div>\r\n                                <div class=\"sublink" +
"s\">\r\n                                    <a href=\"/Account/LogOff/\" title=\"");


            
            #line 45 "..\..\Views\Shared\SiteLayout.cshtml"
                                                                 Write(Util.UserName);

            
            #line default
            #line hidden
WriteLiteral("\">Logout</a>\r\n                                    <a href=\"/Account/ChangePasswor" +
"d\">Change Password</a>\r\n");


            
            #line 47 "..\..\Views\Shared\SiteLayout.cshtml"
 if (admin)
{

            
            #line default
            #line hidden
WriteLiteral("                                        <a href=\"/Admin/Users.aspx\">Manage Users<" +
"/a>\r\n");



WriteLiteral("                                        <a href=\"/Admin/Activity.aspx\">Activity L" +
"og</a>\r\n");


            
            #line 51 "..\..\Views\Shared\SiteLayout.cshtml"
}

            
            #line default
            #line hidden
WriteLiteral("                                </div>\r\n                            </div>\r\n");


            
            #line 54 "..\..\Views\Shared\SiteLayout.cshtml"
 if (User.IsInRole("Access"))
{

            
            #line default
            #line hidden
WriteLiteral("                                <strong>Active Tag:</strong> ");



WriteLiteral("<a id=\"activetag\" href=\"/Tags\">\r\n                                    ");


            
            #line 57 "..\..\Views\Shared\SiteLayout.cshtml"
                               Write(Util2.CurrentTagName);

            
            #line default
            #line hidden
WriteLiteral("</a>");



WriteLiteral("<br />\r\n");



WriteLiteral("                                <form method=\"post\">\r\n                           " +
"     <input id=\"SearchText\" type=\"text\" title=\'Partial names: \"last\" or \"first l" +
"ast\" or \"first<sp>\"\' />\r\n                                </form>\r\n");


            
            #line 61 "..\..\Views\Shared\SiteLayout.cshtml"
}

            
            #line default
            #line hidden
WriteLiteral(@"                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan=""2"">
                        <div>
                        </div>
                    </td>
                    <td>
                    </td>
                </tr>
            </table>
");


            
            #line 74 "..\..\Views\Shared\SiteLayout.cshtml"
 if (User.IsInRole("Access"))
{

            
            #line default
            #line hidden
WriteLiteral(@"                <table id=""cmenu"">
                    <tr>
                        <td class=""dropdown"">
                            <div>
                                <a href=""/"">Home</a></div>
                        </td>
                        <td class=""dropdown"">
                            <div>
                                <a href=""/QuickSearch"">People</a></div>
                            <div class=""sublinks"">
                                <a href=""/QuickSearch"">People Search</a>
                                <a id=""addpeople"" href=""#"">Add People</a> 
                                <a href=""/Tags"">Manage Tags</a>
                                <a href=""/Task/List/"">Tasks</a> <a href=""/ContactSearch"">Contact Search</a>
");


            
            #line 90 "..\..\Views\Shared\SiteLayout.cshtml"
     if (Util2.CurrentPeopleId != 0)
    {

            
            #line default
            #line hidden
WriteLiteral("                                    <a href=\"/Person/Index/");


            
            #line 92 "..\..\Views\Shared\SiteLayout.cshtml"
                                                      Write(Util2.CurrentPeopleId);

            
            #line default
            #line hidden
WriteLiteral("\">\r\n                                        ");


            
            #line 93 "..\..\Views\Shared\SiteLayout.cshtml"
                                   Write(Session["ActivePerson"]);

            
            #line default
            #line hidden
WriteLiteral("</a>\r\n");


            
            #line 94 "..\..\Views\Shared\SiteLayout.cshtml"
    }

            
            #line default
            #line hidden
WriteLiteral(@"                            </div>
                        </td>
                        <td class=""dropdown"">
                            <div>
                                <a href=""/OrgSearch"">Organization</a></div>
                            <div class=""sublinks"">
                                <a href=""/OrgSearch"">Search</a> <a href=""/EmailAttendanceNotices.aspx"">Email Attendance Notices</a> 
");


            
            #line 102 "..\..\Views\Shared\SiteLayout.cshtml"
     if (User.IsInRole("Edit"))
    {

            
            #line default
            #line hidden
WriteLiteral("                                <a id=\"addorg\" href=\"#\">Add Organization</a> \r\n");



WriteLiteral("                                <a href=\"/OrgMembers\">Org Members Management</a>\r" +
"\n");


            
            #line 106 "..\..\Views\Shared\SiteLayout.cshtml"
    }

            
            #line default
            #line hidden

            
            #line 107 "..\..\Views\Shared\SiteLayout.cshtml"
     if (User.IsInRole("Coupon"))
    {

            
            #line default
            #line hidden
WriteLiteral("                                <a href=\"/Coupon/\">Coupons</a>\r\n");


            
            #line 110 "..\..\Views\Shared\SiteLayout.cshtml"
    }

            
            #line default
            #line hidden
WriteLiteral("                                <a href=\"/EnrollmentControlReport.aspx\">Enrollmen" +
"t Control Report</a>\r\n");


            
            #line 112 "..\..\Views\Shared\SiteLayout.cshtml"
     if (((string)Session["ActiveOrganization"]).HasValue())
    {

            
            #line default
            #line hidden
WriteLiteral("                                <a href=\"/Organization/Index/");


            
            #line 114 "..\..\Views\Shared\SiteLayout.cshtml"
                                                        Write(Util2.CurrentOrgId);

            
            #line default
            #line hidden
WriteLiteral("\">\r\n                                        ");


            
            #line 115 "..\..\Views\Shared\SiteLayout.cshtml"
                                   Write(Session["ActiveOrganization"]);

            
            #line default
            #line hidden
WriteLiteral("</a>\r\n");


            
            #line 116 "..\..\Views\Shared\SiteLayout.cshtml"
    }

            
            #line default
            #line hidden
WriteLiteral(@"                            </div>
                        </td>
                        <td class=""dropdown"">
                            <div>
                                <a href=""/Reports/ChurchAttendance"" target=""_blank"">Reports</a></div>
                            <div class=""sublinks"">
                                <a href=""/Reports/VitalStats"" target=""_blank"">Vital Stats</a> 
                                <a href=""/Reports/ChurchAttendance"" target=""_blank"">Week at a Glance</a> 
                                <a href=""/Reports/ChurchAttendance2"" target=""_blank"">Average Week at a Glance</a> 
");


            
            #line 126 "..\..\Views\Shared\SiteLayout.cshtml"
     if (DbUtil.Db.Setting("Bellevue", "false") == "true")
    {

            
            #line default
            #line hidden
WriteLiteral("                                <a href=\"/Report/ChurchAttendanceSummaryRpt.aspx\"" +
" target=\"_blank\">Church Attendance Summary</a> \r\n");


            
            #line 129 "..\..\Views\Shared\SiteLayout.cshtml"
    }

            
            #line default
            #line hidden
WriteLiteral(@"                                <a href=""/Report/ChurchAttendanceRpt.aspx"" target=""_blank"">Weekly Decisions</a> 
                                <a href=""/Report/DecisionSummary.aspx"" target=""_blank"">Decision Summary</a>
                            </div>
                        </td>
                        <td class=""dropdown"">
                            <div>
                                <a href=""/QueryBuilder/Main"">QueryBuilder</a></div>
                            <div class=""sublinks"">
                                <a href=""/QueryBuilder/Main"">Last Query</a>
                                <a href=""/QueryBuilder/NewQuery"">New Query</a>
                                <a href=""/SavedQuery"">Saved Queries</a>
");


            
            #line 141 "..\..\Views\Shared\SiteLayout.cshtml"
     if ((string)ViewData["OnQueryBuilder"] == "true")
    {

            
            #line default
            #line hidden
WriteLiteral("                                    <a id=\"ShowOpenQuery\" href=\"#\">Open Saved Que" +
"ry</a>\r\n");



WriteLiteral("                                    <a id=\"ShowSaveQuery\" href=\"#\">Save Query As<" +
"/a>\r\n");


            
            #line 145 "..\..\Views\Shared\SiteLayout.cshtml"
    }

            
            #line default
            #line hidden
WriteLiteral("                                <a href=\"/Reports/ExtraValues\">Extra Values</a>\r\n" +
"                            </div>\r\n                        </td>\r\n");


            
            #line 149 "..\..\Views\Shared\SiteLayout.cshtml"
     if (User.IsInRole("Finance"))
    {

            
            #line default
            #line hidden
WriteLiteral("                            <td class=\"dropdown\">\r\n                              " +
"  <div>\r\n                                    <a href=\"/Contributions/Bundles.asp" +
"x\">Contributions</a></div>\r\n                                <div class=\"sublinks" +
"\">\r\n                                    <a href=\"/Contributions/Bundles.aspx\">Bu" +
"ndles</a>\r\n                                    <a href=\"/Contributions/All.aspx\"" +
"> All</a>\r\n                                    <a href=\"#\" class=\"heading\">&mdas" +
"h; Reports &mdash;</a>\r\n                                    <a href=\"/Statements" +
"\" target=\"_blank\">Statements (All)</a>\r\n                                    <a h" +
"ref=\"/Contributions/GLExtract.aspx\">GL Extract</a>\r\n                            " +
"        <a href=\"/Contributions/Reports/TotalsByFund2.aspx\" target=\"_blank\">Tota" +
"ls by Fund</a>\r\n                                    <a href=\"/Contributions/Repo" +
"rts/TotalsByFundAgeRange.aspx\" target=\"_blank\">Totals by Fund Age Range</a>\r\n   " +
"                                 <a href=\"/Contributions/Reports/TotalsByFundAge" +
"Range.aspx?pledged=both\" target=\"_blank\">Totals by Fund Age Range (pledges inclu" +
"ded)</a>\r\n                                    <a href=\"/Contributions/Reports/To" +
"talsByFundRange.aspx\" target=\"_blank\">Totals by Fund Range</a>\r\n                " +
"                    <a href=\"/Contributions/Reports/TotalsByFund2.aspx?pledged=t" +
"rue\" target=\"_blank\">Pledge Totals by Fund</a>\r\n                                " +
"    <a href=\"/Contributions/Reports/TotalsByFundRange.aspx?pledged=true\" target=" +
"\"_blank\">Pledge Totals by Fund Range</a>\r\n                                    <a" +
" href=\"/Contributions/Reports/PledgeReport.aspx\" target=\"_blank\">Pledge Report</" +
"a>\r\n                                </div>\r\n                            </td>\r\n");


            
            #line 169 "..\..\Views\Shared\SiteLayout.cshtml"
    }

            
            #line default
            #line hidden

            
            #line 170 "..\..\Views\Shared\SiteLayout.cshtml"
     if (admin || manageemails || managetrans)
    {

            
            #line default
            #line hidden
WriteLiteral("                            <td class=\"dropdown\">\r\n                              " +
"  <div>\r\n                                    <a href=\"/Admin/Users.aspx\">Admin</" +
"a></div>\r\n                                <div class=\"sublinks\" class=\"last\">\r\n");


            
            #line 176 "..\..\Views\Shared\SiteLayout.cshtml"
                                 if (admin)
                                {

            
            #line default
            #line hidden
WriteLiteral("                                    <a href=\"/Setup/Program/\">Programs</a> ");



WriteLiteral("<a href=\"/Setup/Division/\">Divisions</a>\r\n");



WriteLiteral("                                    <a href=\"/Setup/Setting\">Settings</a> ");



WriteLiteral("<a href=\"/Display/Index/\">Special Content</a>\r\n");



WriteLiteral("                                    <a href=\"/Setup/MetroZip/\">Metro Zips</a> \r\n");


            
            #line 181 "..\..\Views\Shared\SiteLayout.cshtml"
                                }

            
            #line default
            #line hidden

            
            #line 182 "..\..\Views\Shared\SiteLayout.cshtml"
                                 if (admin || managetrans)
                                {

            
            #line default
            #line hidden
WriteLiteral("                                    <a href=\"/Manage/Transactions\">Transactions</" +
"a>\r\n");


            
            #line 185 "..\..\Views\Shared\SiteLayout.cshtml"
                                }

            
            #line default
            #line hidden

            
            #line 186 "..\..\Views\Shared\SiteLayout.cshtml"
                                 if (admin || manageemails)
                                {

            
            #line default
            #line hidden
WriteLiteral("                                    <a href=\"/Manage/Emails\">Emails</a> \r\n");


            
            #line 189 "..\..\Views\Shared\SiteLayout.cshtml"
                                }

            
            #line default
            #line hidden

            
            #line 190 "..\..\Views\Shared\SiteLayout.cshtml"
                                 if (admin)
                                {

            
            #line default
            #line hidden
WriteLiteral("                                    <a href=\"/Setup/Lookup/\">Lookups</a>\r\n");



WriteLiteral("                                    <a href=\"/Batch/UpdateFields/\"> Update for a " +
"Tag</a> \r\n");



WriteLiteral("                                    <a href=\"/Admin/ToggleOrgMembersOnly.ashx\">");


            
            #line 194 "..\..\Views\Shared\SiteLayout.cshtml"
                                                                           Write(Util2.OrgMembersOnly ? "OrgMembersOnly is on" : "OrgMembersOnly is off");

            
            #line default
            #line hidden
WriteLiteral("</a>\r\n");



WriteLiteral("                                    <a href=\"/Admin/ToggleOrgLeadersOnly.ashx\">");


            
            #line 195 "..\..\Views\Shared\SiteLayout.cshtml"
                                                                           Write(Util2.OrgLeadersOnly ? "OrgLeadersOnly is on" : "OrgLeadersOnly is off");

            
            #line default
            #line hidden
WriteLiteral("</a>\r\n");



WriteLiteral("                                    <a href=\"/Batch/UpdateQueryBits\">Update Query" +
"Bits</a>\r\n");



WriteLiteral("                                    <a href=\"/Batch/FindTagPeople\">Find Tag Peopl" +
"e</a>\r\n");



WriteLiteral("                                    <a href=\"/Batch/TagPeopleIds\">Tag PeopleIds</" +
"a>\r\n");



WriteLiteral("                                    <a href=\"/Admin/ClearCache.aspx\">Clear Cache<" +
"/a>\r\n");


            
            #line 200 "..\..\Views\Shared\SiteLayout.cshtml"
                                }

            
            #line default
            #line hidden
WriteLiteral("                                </div>\r\n                            </td>\r\n");


            
            #line 203 "..\..\Views\Shared\SiteLayout.cshtml"
    }

            
            #line default
            #line hidden
WriteLiteral("                        <td class=\"dropdown left\">\r\n                            <" +
"div>\r\n                                <a href=\"");


            
            #line 206 "..\..\Views\Shared\SiteLayout.cshtml"
                                    Write(Util.HelpLink(Util.Helpfile));

            
            #line default
            #line hidden
WriteLiteral("\" target=\"_blank\">Help</a></div>\r\n                            <div class=\"sublink" +
"s\">\r\n                                <a href=\"");


            
            #line 208 "..\..\Views\Shared\SiteLayout.cshtml"
                                    Write(Util.HelpLink(Util.Helpfile));

            
            #line default
            #line hidden
WriteLiteral("\" target=\"_blank\">Wiki Documentation</a>\r\n                                <a href" +
"=\"mailto:support@bvcms.com?subject=Support request from ");


            
            #line 209 "..\..\Views\Shared\SiteLayout.cshtml"
                                                                                          Write(Util.UserFullName);

            
            #line default
            #line hidden
WriteLiteral(" at ");


            
            #line 209 "..\..\Views\Shared\SiteLayout.cshtml"
                                                                                                                Write(Util.CmsHost2);

            
            #line default
            #line hidden
WriteLiteral("\" target=\"_blank\">Email Support</a>\r\n                                <a href=\"/Ho" +
"me/About\">About</a>\r\n                            </div>\r\n                       " +
" </td>\r\n                    </tr>\r\n                </table>\r\n");


            
            #line 215 "..\..\Views\Shared\SiteLayout.cshtml"
}

            
            #line default
            #line hidden
WriteLiteral("            <div style=\"clear: both; border-bottom: 4px solid #ddd\">\r\n           " +
" </div>\r\n        </div>\r\n        <div id=\"main\">\r\n            ");


            
            #line 220 "..\..\Views\Shared\SiteLayout.cshtml"
       Write(RenderBody());

            
            #line default
            #line hidden
WriteLiteral("\r\n        </div>\r\n    </div>\r\n    <div id=\"ChooseLabelType\" class=\"modalPopup\" st" +
"yle=\"display: none; width: 400px;\r\n        padding: 10px\">\r\n        <table>\r\n   " +
"         <tr>\r\n                <td style=\"margin: 3px; border: solid thin black\"" +
" nowrap=\"nowrap\">\r\n                    <input type=\"radio\" id=\"addressedto1\" nam" +
"e=\"addressedto\" value=\"Individual\" checked=\"checked\"\r\n                        ti" +
"tle=\"Addressed to individuals\" />\r\n                    Individual<br />\r\n       " +
"             <input type=\"radio\" id=\"addressedto2\" name=\"addressedto\" value=\"Fam" +
"ily\" title=\"Addressed as a family when there are children\" />\r\n                 " +
"   Family<br />\r\n                    <input type=\"radio\" id=\"addressedto6\" name=" +
"\"addressedto\" value=\"FamilyMembers\" title=\"Includes entire Family as individuals" +
"\" />\r\n                    Family Members<br />\r\n                    <input type=" +
"\"radio\" id=\"addressedto3\" name=\"addressedto\" value=\"CouplesBoth\" title=\"Addresse" +
"d to a couple, if both are in selection\" />\r\n                    Couples (both)<" +
"br />\r\n                    <input type=\"radio\" id=\"addressedto4\" name=\"addressed" +
"to\" value=\"CouplesEither\" title=\"Addressed to a couple, if one or both are in se" +
"lection\" />\r\n                    Couples (either)<br />\r\n                    <in" +
"put type=\"radio\" id=\"addressedto5\" name=\"addressedto\" value=\"ParentsOf\" title=\"A" +
"ddressed to parents or parent\" />\r\n                    Parents Of<br />\r\n       " +
"         </td>\r\n                <td>\r\n                    <input type=\"checkbox\"" +
" id=\"UseTitle\" name=\"UseTitle\" />\r\n                    Use Titles<br />\r\n       " +
"             <input type=\"checkbox\" id=\"UsePhone\" name=\"UsePhone\" />\r\n          " +
"          Include Phone\r\n                </td>\r\n            </tr>\r\n            <" +
"tr>\r\n                <td colspan=\"2\" align=\"right\">\r\n                    <input " +
"id=\"cmdOK\" type=\"button\" value=\"OK\" />\r\n                </td>\r\n            </tr>" +
"\r\n        </table>\r\n    </div>\r\n    <div id=\"ExportStartEnd\" class=\"modalDiv dia" +
"log\" style=\"display: none\">\r\n        <table>\r\n        <tr><th colspan=\"2\">Select" +
" a date range</th></tr>\r\n        <tr><th>Start Date</th><td><input id=\"startdt\" " +
"type=\"text\"  class=\'datepicker\' /></td></tr>\r\n        <tr><th>End Date</th><td><" +
"input id=\"enddt\" type=\"text\" class=\'datepicker\' /></td></tr>\r\n        <tr><td al" +
"ign=\"right\" colspan=\"2\">\r\n            <a class=\"bt\" id=\"ExportStartEndRun\" href=" +
"\"#\"> run </a></td>\r\n        </tr>\r\n        </table>\r\n    </div>\r\n    <div id=\"Se" +
"tExtraValues\" class=\"modalDiv dialog\" style=\"display: none\">\r\n        <table>\r\n " +
"       <tr><th>Field</th><td><input id=\"field\" type=\"text\" /></td></tr>\r\n       " +
" <tr><th>Value</th><td><input id=\"value\" type=\"text\" /></td></tr>\r\n        <tr><" +
"td align=\"right\" colspan=\"2\">\r\n            <a class=\"bt\" id=\"SetExtraValuesRun\" " +
"href=\"#\"> OK </a></td>\r\n        </tr>\r\n        </table>\r\n    </div>\r\n    <div id" +
"=\"AddDialog\">\r\n    <iframe id=\"AddDialogiframe\" style=\"width:100%;height:99%;bor" +
"der-width:0px\"></iframe>\r\n    </div>\r\n");


            
            #line 278 "..\..\Views\Shared\SiteLayout.cshtml"
Write(RenderSection("PopupsPlaceholder", required: false));

            
            #line default
            #line hidden
WriteLiteral("\r\n");


            
            #line 279 "..\..\Views\Shared\SiteLayout.cshtml"
Write(Html.Partial("CombinedJs"));

            
            #line default
            #line hidden
WriteLiteral("\r\n");


            
            #line 280 "..\..\Views\Shared\SiteLayout.cshtml"
Write(RenderSection("scripts", required: false));

            
            #line default
            #line hidden
WriteLiteral("\r\n</body>\r\n</html>\r\n\r\n");


        }
    }
}
#pragma warning restore 1591
