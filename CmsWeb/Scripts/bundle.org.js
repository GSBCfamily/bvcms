$(function(){$('a[data-toggle="tab"]').on("shown",function(f){f.preventDefault();var g=$(f.target).attr("href").replace("#","#tab-");window.location.hash=g;$.cookie("lasttab",g);return false});var a=$.cookie("lasttab");if(window.location.hash){a=window.location.hash}if(a){var d=$("a[href='"+a.replace("tab-","")+"']");var c=d.closest("ul").data("tabparent");if(c){$("a[href='#"+c+"']").click().tab("show")}if(d.attr("href")!=="#"){$.cookie("lasttab",d.attr("href"));d.click().tab("show")}}$("a[href='#Settings-tab']").on("shown",function(f){if($("#SettingsOrg").length<2){$("a[href='#SettingsOrg']").click().tab("show")}});$("#tab-area > ul.nav-tabs > li > a").on("shown",function(f){switch($(this).text()){case"People":$("#bluetoolbarstop li > a.qid").parent().removeClass("hidy");break;case"Settings":case"Meetings":$("#bluetoolbarstop li > a.qid").parent().addClass("hidy");break}});$("#excludesg").live("click",function(e){e.stopPropagation();$(this).toggleClass("active");if($(this).hasClass("active")){$("a.selectsg .fa-minus").show()}else{$("a.selectsg .fa-minus").hide()}});$("a.selectsg").live("click",function(e){var g=$(this).text();var f=$("#sgFilter").val();switch(g){case"Match All":f="All:"+f;break;case"None Assigned":f="None";break;default:if(f&&f!=="All:"){f=f+","}if($("#excludesg").hasClass("active")){g="-"+g}f=f+g;break}$("#sgFilter").val(f);$("#excludesg").removeClass("active");$("a.selectsg .fa-minus").hide()});$("#showhide").live("click",function(e){e.preventDefault();$(this).toggleClass("active");$("#ShowHidden").val($(this).hasClass("active"));RebindMemberGrids();return false});$("#filter-ind").live("click",function(e){e.preventDefault();$(this).toggleClass("active");$("#FilterIndividuals").val($(this).hasClass("active"));RebindMemberGrids();return false});$("#filter-tag").live("click",function(e){e.preventDefault();$(this).toggleClass("active");$("#FilterTag").val($(this).hasClass("active"));RebindMemberGrids();return false});$("#clear-filter").live("click",function(e){e.preventDefault();$("input[name='sgFilter']").val("");$("input[name='nameFilter']").val("");$("#FilterTag").val(false);$("#FilterIndividuals").val(false);RebindMemberGrids()});$("#ministryinfo").live("click",function(e){e.preventDefault();$(this).toggleClass("active");$("#ShowMinistryInfo").val($(this).hasClass("active"));RebindMemberGrids();return false});$("#showaddress").live("click",function(e){e.preventDefault();$(this).toggleClass("active");$("#ShowAddress").val($(this).hasClass("active"));RebindMemberGrids();return false});$("#multigroup").live("click",function(f){f.preventDefault();var e=$(this);e.toggleClass("active");var g=e.hasClass("active");$("#MultiSelect").val(g);if(g){$("#groupSelector button.dropdown-toggle").hide();$("li.orgcontext").hide()}else{$("#groupSelector button.grp.active").removeClass("active");$("#groupSelector button[value='10']").addClass("active").closest("button.dropdown-toggle").show();$("#GroupSelect").val("10");$("#showhide").removeClass("active");$("#ShowHidden").val($("#showhide").hasClass("active"))}RebindMemberGrids();return false});$("#groupSelector button.grp").live("click",function(g){g.preventDefault();var f=$(this);if($("#multigroup").hasClass("active")){f.toggleClass("active")}else{$("#groupSelector button.grp.active").removeClass("active");$("#groupSelector button.dropdown-toggle").hide();f.addClass("active");f.next().find("button.dropdown-toggle").show();$("li.orgcontext").hide();switch(f.text()){case"Members":$("li.current-list").show();break;case"Pending":$("li.pending-list").show();break}}var e="";$("#groupSelector button.grp.active").each(function(){e+=$(this).val()});if(e===""){f.toggleClass("active");return false}$("#GroupSelect").val(e);RebindMemberGrids();return false});var b=null;$("input.omck").live("click",function(g){var i=null;if(g.shiftKey&&b){var j=$("input.omck").index(this);var h=$("input.omck").index(b);i=$("input.omck").slice(Math.min(j,h),Math.max(j,h)+1);i.attr("checked",b.checked)}else{i=$(this);b=this}var f=i.map(function(){return $(this).val()}).get();$.post("/Organization/ToggleCheckboxes/{0}".format($("#Id").val()),{pids:f,chkd:b.checked})});$("#deleteorg").click(function(e){e.preventDefault();var f=$(this).attr("href");if(confirm("Are you sure you want to delete?")){$.block("deleting org");$.post(f,null,function(g){if(g!="ok"){window.location=g}else{$.block("org deleted");$(".blockOverlay").attr("title","Click to unblock").click(function(){$.unblock();window.location="/"})}})}return false});$("#sendreminders").click(function(e){e.preventDefault();var f=$(this).attr("href");if(confirm("Are you sure you want to send reminders?")){$.block("sending reminders");$.post(f,null,function(g){if(g!="ok"){$.unblock();$.growlUI("error",g)}else{$.unblock();$.growlUI("Email","Reminders Sent")}})}});$("#reminderemails").click(function(e){e.preventDefault();var f=$(this).attr("href");if(confirm("Are you sure you want to send reminders?")){$.block("sending reminders");$.post(f,null,function(g){if(g!="ok"){$.block(g);$(".blockOverlay").attr("title","Click to unblock").click($.unblock)}else{$.block("org deleted");$(".blockOverlay").attr("title","Click to unblock").click(function(){$.unblock();window.location="/"})}})}return false});$(".CreateAndGo").click(function(e){e.preventDefault();if(confirm($(this).attr("confirm"))){$.post($(this).attr("href"),null,function(f){window.location=f})}return false});$("a.members-dialog").live("click",function(f){var e=$(this);f.preventDefault();$("<div />").load(this.href,{},function(){var g=$(this);var h=g.find("form");h.modal("show");$.DatePickersAndChosen();h.on("hidden",function(){g.remove();h.remove();RebindMemberGrids()})})});$("a.membertype").live("click",function(e){e.preventDefault();$("<div />").load(this.href,{},function(){var g=$(this);var h=g.find("form");h.modal("show");h.on("hidden",function(){g.remove();h.remove();RebindMemberGrids()})})});$("#divisionlist").live("click",function(f){f.preventDefault();var e=$(this);$("<div />").load(e.attr("href"),{},function(){var g=$(this);var h=g.find("form");h.modal("show");h.on("hidden",function(){e.load(e.data("refresh"),{});g.remove();h.remove()});h.on("change","input:checkbox",function(){$("input[name='TargetDivision']",h).val($(this).val());$("input[name='Adding']",h).val($(this).is(":checked"));$.formAjaxClick($(this),"/SearchDivisions/AddRemoveDiv")});h.on("click","a.move",function(){$("input[name='TargetDivision']",h).val($(this).data("moveid"));$.formAjaxClick($(this),"/SearchDivisions/MoveToTop")})})});$.maxZIndex=$.fn.maxZIndex=function(f){var e={inc:10,group:"*"};$.extend(e,f);var g=0;$(e.group).each(function(){var h=parseInt($(this).css("z-index"));g=h>g?h:g});if(!this.jquery){return g}return this.each(function(){g+=e.inc;$(this).css("z-index",g)})};$.InitFunctions.datetimepicker=function(e){$(".datetimepicker").datetimepicker({format:"m/d/yyyy H:ii P",showMeridian:true,autoclose:true,todayBtn:false})};$.InitFunctions.ReloadMeetings=function(e){$("#Meetings-tab").load("/Organization/Meetings",{id:$("input[name=Id]","#Meetings-tab").val()})};$.InitFunctions.showHideRegTypes=function(e){$("#Fees-tab").show();$("#Questions-tab").show();$("#Messages-tab").show();$("#QuestionList li").show();$(".yes6").hide();switch($("#org_RegistrationTypeId").val()){case"0":$("#Fees-tab").hide();$("#Questions-tab").hide();$("#Messages-tab").hide();break;case"6":$("#QuestionList > li").hide();$(".yes6").show();break}};$("#org_RegistrationTypeId").live("change",$.InitFunctions.showHideRegTypes);$("#selectquestions a").live("click",function(e){e.preventDefault();$.post("/Organization/NewAsk/",{id:"AskItems",type:$(this).attr("type")},function(g){$("#selectquestions").dialog("close");$("html, body").animate({scrollTop:$("body").height()},800);var f=$("#QuestionList").append(g);$("#QuestionList > li:last").effect("highlight",{},3000);$(".tip",f).tooltip({opacity:0,showBody:"|"});$.updateQuestionList()});return false});$("ul.enablesort a.del").live("click",function(e){e.preventDefault();if(!$(this).attr("href")){return false}$(this).parent().parent().parent().remove();return false});$("ul.enablesort a.delt").live("click",function(e){e.preventDefault();if(!$(this).attr("href")){return false}if(confirm("are you sure?")){$(this).parent().parent().remove();$.InitFunctions.updateQuestionList()}return false});$.exceptions=["AskDropdown","AskCheckboxes","AskExtraQuestions","AskHeader","AskInstruction","AskMenu"];$.InitFunctions.updateQuestionList=function(){$("#selectquestions li").each(function(){var f=this.className;var e=$(this).text();if(!e){e=f}if($.inArray(f,$.exceptions)>=0||$("li.type-"+f).length==0){$(this).html("<a href='#' type='"+f+"'>"+e+"</a>")}else{$(this).html("<span>"+e+"</span>")}})};$(".helptip").tooltip({showBody:"|",blocked:true});$("form.DisplayEdit a.submitbutton").live("click",function(e){e.preventDefault();var g=$(this).closest("form");if(!$(g).valid()){return false}var h=g.serialize();$.post($(this).attr("href"),h,function(f){if(f.startsWith("error:")){$("div.formerror",g).html(f.substring(6))}else{$(g).html(f).ready(function(){$(".submitbutton,.bt").button();$.regsettingeditclick(g);$.showHideRegTypes()})}});return false});$("#future").live("click",function(){var e=$(this).closest("form");var g=e.serialize();$.post($(e).attr("action"),g,function(f){$(e).html(f);$(".bt",e).button()})});$.InitFunctions.CreateMeeting=function(e){};$("a.taguntag").live("click",function(e){e.preventDefault();$.post("/Organization/ToggleTag/"+$(this).attr("pid"),null,function(f){$(e.target).text(f)});return false});$.validator.addMethod("time",function(f,e){return this.optional(e)||/^\d{1,2}:\d{2}\s(?:AM|am|PM|pm)/.test(f)},"time format h:mm AM/PM");$.validator.setDefaults({highlight:function(e){$(e).addClass("ui-state-highlight")},unhighlight:function(e){$(e).removeClass("ui-state-highlight")}});$("#orginfoform").validate({rules:{"org.OrganizationName":{required:true,maxlength:100}}});$("#settingsForm").validate({rules:{"org.SchedTime":{time:true},"org.OnLineCatalogSort":{digits:true},"org.Limit":{digits:true},"org.NumCheckInLabels":{digits:true},"org.NumWorkerCheckInLabels":{digits:true},"org.FirstMeetingDate":{date:true},"org.LastMeetingDate":{date:true},"org.RollSheetVisitorWks":{digits:true},"org.GradeAgeStart":{digits:true},"org.GradeAgeEnd":{digits:true},"org.Fee":{number:true},"org.Deposit":{number:true},"org.ExtraFee":{number:true},"org.ShirtFee":{number:true},"org.ExtraOptionsLabel":{maxlength:50},"org.OptionsLabel":{maxlength:50},"org.NumItemsLabel":{maxlength:50},"org.GroupToJoin":{digits:true},"org.RequestLabel":{maxlength:50},"org.DonationFundId":{number:true}}});$("#namefilter").keypress(function(f){if((f.keyCode||f.which)===13){f.preventDefault();RebindMemberGrids()}return true});$("#addsch").live("click",function(e){e.preventDefault();var h=$(this).attr("href");if(h){var g=$(this).closest("form");$.post(h,null,function(f){$("#schedules",g).append(f).ready(function(){$.renumberListItems();$.InitFunctions.datetimepicker()})})}return false});$("a.deleteschedule").live("click",function(e){e.preventDefault();var f=$(this).attr("href");if(f){$(this).parent().remove();$.renumberListItems()}});$.renumberListItems=function(){var e=1;$(".renumberMe").each(function(){$(this).val(e);e++})};$("#ScheduleListPrev").change(function(){var e=$(this).val().split(",");$("#PrevMeetingDate").val(e[0]);$("#NewMeetingTime").val(e[1]);$("#AttendCreditList").val(e[2])});$("#ScheduleListNext").change(function(){var e=$(this).val().split(",");$("#NextMeetingDate").val(e[0]);$("#NewMeetingTime").val(e[1]);$("#AttendCreditList").val(e[2])});$.GetPrevMeetingDateTime=function(){var e=$("#PrevMeetingDate").val();return $.GetMeetingDateTime(e)};$.GetNextMeetingDateTime=function(){var e=$("#NextMeetingDate").val();return $.GetMeetingDateTime(e)};$.GetMeetingDateTime=function(e){var f=/^ *(\d{1,2}):[0-5][0-9] *((a|p|A|P)(m|M)){0,1} *$/;var g=$("#NewMeetingTime").val();var h=true;if(!f.test(g)){$.growlUI("error","enter valid time");h=false}if(!$.DateValid(e)){$.growlUI("error","enter valid date");h=false}return{date:e,time:g,valid:h}};$("a.joinlink").live("click",function(f){f.preventDefault();var e=$(this);bootbox.confirm(e.attr("confirm"),function(g){if(g){$.post(e[0].href,function(h){if(h==="ok"){RebindMemberGrids()}else{alert(h)}})}});return false});$.extraEditable=function(){$(".editarea").editable("/Organization/EditExtra/",{type:"textarea",submit:"OK",rows:5,width:200,indicator:'<img src="/Content/images/loading.gif">',tooltip:"Click to edit..."});$(".editline").editable("/Organization/EditExtra/",{indicator:"<img src='/images/loading.gif'>",tooltip:"Click to edit...",style:"display: inline",width:200,height:25,submit:"OK"})};$.extraEditable();$("a.deleteextra").live("click",function(e){e.preventDefault();if(confirm("are you sure?")){$.post("/Organization/DeleteExtra/"+$("#OrganizationId").val(),{field:$(this).attr("field")},function(f){if(f.startsWith("error")){alert(f)}else{$("#extras > tbody").html(f);$.extraEditable()}})}return false});$.updateTable=function(f){if(!f){return false}var e=f.closest("form.ajax");if(e.length){$.formAjaxClick(f)}return false};$.InitFunctions.ReloadPeople=function(){RebindMemberGrids()}});function RebindMemberGrids(){$.formAjaxClick($("a.setfilter"))}function AddSelected(){RebindMemberGrids()}function CloseAddDialog(a){$("#memberDialog").dialog("close")}function UpdateSelectedUsers(a){}function UpdateSelectedOrgs(a){$.post("/Organization/UpdateOrgIds",{id:$("#OrganizationId").val(),list:a},function(b){$("#orgpickdiv").html(b);$("#orgsDialog").dialog("close")})};(function(a){a.fn.SearchUsers=function(c){b(this);var d=a.extend({},{},c);return this.each(function(){var e=a(this);e.click(function(f){f.preventDefault();var g=a(this).attr("href");a("<div class='dialog' style='margin: 5px'>Loading...</div>").dialog({closeOnEscape:true,title:d.title||"Select Users",width:"550px"}).bind("dialogclose",function(){a(this).dialog("destroy")}).load(g,function(){var h=a(this);h.dialog("option","position",["center","center"]);h.dialog("option","width",h.offsetWidth+10);a("table.results > tbody > tr:even",h).addClass("alt");a(".bt").button();a(".UpdateSelected",a(this)).click(function(j){j.preventDefault();var k=a("table.results tbody tr:first ",h).find("input[type=checkbox]").attr("value");var l=a("#topid0").val();if(d.UpdateShared){d.UpdateShared(k,l,e)}h.dialog("close");return false});var i=a("a.search",h).closest("form");i.submit(function(){a("a.search",h).click();return false});a("a.newsearch",h).click(function(j){j.preventDefault();a("#searchname").val("");var k=i.serialize();a.post(a(this).attr("href"),k,function(l){a("table.results",i).replaceWith(l);a("table.results > tbody > tr:even",i).addClass("alt")});return false});a("a.search",h).click(function(j){j.preventDefault();var k=i.serialize();a.post(a(this).attr("href"),k,function(l){a("table.results",i).replaceWith(l);a("table.results > tbody > tr:even",i).addClass("alt")});return false});a("a.close",h).click(function(j){j.preventDefault();h.dialog("close");return false});a("#searchname").live("keypress",function(j){if((j.which&&j.which==13)||(j.keyCode&&j.keyCode==13)){j.preventDefault();a("a.search").click();return false}return true});a(h).off("click","input[type=checkbox]");a(h).on("change","input[type=checkbox]",function(){var m=a(this).parents("tr:eq(0)").find("span.move");var j=a(this).is(":checked");var l=a(this).attr("value");var k=a("#ordered").val();a.post("/SearchUsers/TagUntag/"+l,{ischecked:!j,isordered:k},function(n){if(j&&!n){m.html("<a href='#' class='move' value='"+l+"'>move to top</a>")}else{m.empty()}if(n){a("#topid").val(l)}})});a(h).off("click","a.move");a(h).on("click","a.move",function(j){j.preventDefault();var k=a(this).closest("form");a("#topid").val(a(this).attr("value"));var l=k.serialize();a.post("/SearchUsers/MoveToTop",l,function(m){a("table.results",k).replaceWith(m).ready(function(){a("table.results > tbody > tr:even",k).addClass("alt")})})})});return false})})};function b(c){if(window.console&&window.console.log){window.console.log("SearchUsers selection count: "+c.size())}}})(jQuery);$(function(){CKEDITOR.replace("editor",{height:200,customConfig:"/scripts/js/ckeditorconfig.js"});$("body").on("click","ul.enablesort div.newitem > a",function(c){if(!$(this).attr("href")){return false}c.preventDefault();var b=$(this);var d=b.closest("form");$.post(b.attr("href"),null,function(a){b.parent().prev().append(a);b.parent().prev().find(".tip").tooltip({opacity:0,showBody:"|"});$.initDatePicker(d)})});$.InitFunctions.SettingFormsInit=function(a){$(".tip",a).tooltip({opacity:0,showBody:"|"});$("ul.noedit input",a).attr("disabled","disabled");$("ul.noedit select",a).attr("disabled","disabled");$("ul.noedit a",a).not('[target="otherorg"]').removeAttr("href");$("ul.noedit a",a).not('[target="otherorg"]').css("color","grey");$("ul.noedit a",a).not('[target="otherorg"]').unbind("click");$("ul.edit a.notifylist").SearchUsers({UpdateShared:function(c,d,b){$.post("/Organization/UpdateNotifyIds",{id:$("#OrganizationId").val(),topid:c,field:b.data("field")},function(e){b.html(e)})}})};$("a.editor").live("click",function(a){if(!$(this).attr("href")){return false}var b=$(this).attr("tb");a.preventDefault();CKEDITOR.instances.editor.setData($("#"+b).val());dimOn();$("#EditorDialog").center().show();$("#saveedit").off("click").on("click",function(c){c.preventDefault();var d=CKEDITOR.instances.editor.getData();$("#"+b).val(d);$("#"+b+"_ro").html(d);CKEDITOR.instances.editor.setData("");$("#EditorDialog").hide("close");dimOff();return false});return false});$("#canceledit").live("click",function(a){a.preventDefault();$("#EditorDialog").hide("close");dimOff();return false})});CKEDITOR.on("dialogDefinition",function(d){var c=d.data.name;var b=d.data.definition;if(c=="link"){var a=b.getContents("advanced");a.label="SpecialLinks";a.remove("advCSSClasses");a.remove("advCharset");a.remove("advContentType");a.remove("advStyles");a.remove("advAccessKey");a.remove("advName");a.remove("advId");a.remove("advTabIndex");var g=a.get("advRel");g.label="SmallGroup";var h=a.get("advTitle");h.label="Message";var e=a.get("advLangCode");e.label="OrgId/MeetingId";var f=a.get("advLangDir");f.label="Confirmation";f.items[1][0]="Yes, send confirmation";f.items[2][0]="No, do not send confirmation"}});$(function(){$("#membergroups .ckbox").live("click",function(a){$.post($(this).attr("href"),{ck:$(this).is(":checked")});return true});$("#dropmember").live("click",function(a){var b=$(this).closest("form");var c=this.href;bootbox.confirm("are you sure?",function(d){if(d){$.post(c,null,function(e){b.modal("hide");RebindMemberGrids()})}});return false});$("#OrgSearch").live("keydown",function(a){if(a.keyCode===13){a.preventDefault();$("#orgsearchbtn").click()}});$("a.movemember").live("click",function(a){a.preventDefault();var b=$(this).closest("form");var c=$(this).attr("href");bootbox.confirm("are you sure?",function(d){if(d){$.post(c,null,function(e){b.modal("hide");$.RebindMemberGrids()})}});return false})});