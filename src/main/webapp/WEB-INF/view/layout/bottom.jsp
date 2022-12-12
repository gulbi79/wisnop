<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
var userTimeInt = Number("${sessionScope.LOGIN_TIMER}") || 0;
var intDay,intHour,intMinute,intSec;
$(function() {
	setInterval("fn_setUserLoginTime()", 1000);
	clock();
	setInterval("clock()", 1000);
	$(".show_sitemap").on("click", function() { fn_setSiteMap(); });
});

function fn_setUserLoginTime() {
	userTimeInt++;
	intDay    = Math.floor(userTimeInt / (60*60*24));
	intHour   = Math.floor(userTimeInt / (60*60)) - (intDay*24);
	intMinute = Math.floor(userTimeInt / (60)) - (intHour*60);
	intSec    = userTimeInt%60;
	intHour = intHour < 10 ? "0"+intHour : intHour;
	intMinute = intMinute < 10 ? "0"+intMinute : intMinute;
	intSec = intSec < 10 ? "0"+intSec : intSec;
	var timeText = "[" + intDay + " day " + intHour + ":" + intMinute + ":" + intSec +"]";
	$("#userLoginTime").text(timeText);
}

function getFormatDate(date){
	
	var year = date.getFullYear();
	var month = (1+date.getMonth());
	
	month = month >= 10 ? month: '0' + month;
	
	var day = date.getDate();
	
	day = day >= 10 ? day:'0' + day;
	
	var hour = date.getHours();

	hour = hour >= 10 ? hour:'0' + hour;
	
	var minutes = date.getMinutes();
	
	minutes = minutes >= 10 ? minutes: '0' + minutes;	
	
	var seconds = date.getSeconds();
	
	seconds = seconds >=10 ? seconds: '0' + seconds;
	
	return year + '/'+ month + '/' + day + ' ' +hour + ':' + minutes +':'+seconds ;
	
}

function clock() {
    
	var currWeek = ${currWeek};
	
	var date = new Date();
	
    var fullTimeText = getFormatDate(date) + ' ['+currWeek+'W]' ;
	
    $("#bottom_currTime").text(fullTimeText);
}


function fn_setSiteMap() {
	if (!$("#sitemappop .scroll").find("h3").html()) {
		var menuHtml = '';
		var tmpChk1 = false;
		var tmpChk2 = false;
		$.each(global.DS_MENU, function(n,v) {
			
			if (v.MENU_LVL == 1) {
				menuHtml += '<h3>'+v.MENU_NM+'</h3>\n';
				menuHtml += '<ul class="list_site">\n';
			}
				
			tmpChk1 = false;
			$.each(global.DS_MENU, function(n2,v2) {
				if (v.MENU_CD == v2.UPPER_MENU_CD && v2.MENU_LVL == 2) {
					menuHtml += '	<li><a href="#">'+v2.MENU_NM+'</a>\n';
					menuHtml += '		<ul>\n';
					
					tmpChk2 = false;
					$.each(global.DS_MENU, function(n3,v3) {
						if (v2.MENU_CD == v3.UPPER_MENU_CD && v3.MENU_LVL == 3) {
							menuHtml += '			<li><a href="javascript:subAddTab(null, \''+v3.MENU_CD+'\');">'+v3.MENU_NM+'</a></li>\n';
							tmpChk2 = true;
						} else if (tmpChk2 == true) {
							menuHtml += '		</ul>\n';
							menuHtml += '	</li>\n';
							return false;
						}
					});
					
				} else if (tmpChk1 == true) {
					return false;
				}
			});
		});
		if (menuHtml != "") menuHtml += '</ul>\n';
		
		$("#sitemappop .scroll").html(menuHtml);
	}
}

function fn_topClose() {
	if($(".header_wrap").css("display") == "none"){
		$(".header_wrap").css("display", "block");
		$(".tabs").css("display", "block");
	} else {
		$(".header_wrap").css("display", "none");
		$(".tabs").css("display", "none");
	}
	//brresize();
	
	var tab = $('#tt').tabs('getSelected');
	if (tab) {
		var index = $('#tt').tabs('getTabIndex', tab);
		var tab_id = $("iframe:eq("+index+")").attr("id");
		var tmpFrame = $(top.document).find("iframe[id="+tab_id+"]");
		tmpFrame[0].contentWindow.gfn_tabresize();
	}
}

</script>
	<footer>
		<div class="foot_wrap">
			<div class="foot_info">
			<ul>
				<li class="ft1" style="width:295px;"><strong>Current Time :</strong> <span id="bottom_currTime">${currWeek}</span></li>
				<li class="ft1"><strong>Search Row :</strong> <span id="bottom_searchRow"></span></li>
				<li class="ft2"><strong>Login Info :</strong> <span>${sessionScope.userInfo.userNm}</span></li>
				<li class="ft3"><strong>Run Time   :</strong> <span id="userLoginTime"></span></li>
				<li style="width:170px"><strong>Sum  :</strong> <span id="bottom_userSum"></span></li>
				<li style="width:165px"><strong>Avg  :</strong> <span id="bottom_userAvg"></span></li>
			</ul>
			</div>
			<div class="foot_lnk">
			<ul>
				<li><a href="#" onclick="fn_topClose();return false;"><img src="${ctx}/statics/images/common/foot_resize1.gif" alt="" title='<spring:message code="lbl.upDownAdjustment"/>'></a></li>
				<li><a href="#" onclick="removeTabs();return false;"><img src="${ctx}/statics/images/common/foot_link3.gif" alt="" title='<spring:message code="lbl.tabClose"/>'></a></li>
			</ul>
			</div>
			<div class="treeMenu">
				<a href="#" class="show_sitemap">Site Map</a>
			</div>
		</div>
	</footer>

	<div id="sitemappop" class="popup">
		<div class="drag">
			<div class="pop_tit">Site Map</div>
			<div class="pop_body">
				<div class="scroll"></div>
			</div>
		</div>
		<a href="#" class="popClose"><img src="${ctx}/statics/images/common/pop_close2.png" alt=""></a>
	</div>
	
	