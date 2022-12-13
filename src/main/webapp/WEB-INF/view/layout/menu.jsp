<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<script type="text/javascript">
$(function() {
	//이벤트 변수 정의  ------------------------------------------------
	$("#company").change(fn_changeFrame);
	$("#bu").change(fn_changeFrame);
	$("#btnLogOut").on("click", function () {
		if (confirm("로그아웃 하시겠습니까?")) {
			fn_goLogOut();
		}
	});

	$("#btnHelp").on("click", function () {
		fn_pdfPopup();
	});
	
	// MY FAVORITE 기능
	$("#myFav").click(function() {
		fn_getFavorite("F");
		return false;
	});

	// MY Recent
	$("#myRecent").click(function() {
		fn_getFavorite("R");
		return false;
	});
});

function fn_getFavorite(type) {
	var _siq, tClass, tId;
	if (type == "F") {
		$("#util .cMyRecent").hide();
		_siq   = "common.bookMark";
		tClass = ".cMyFav";
		tId    = "#myfavList";
	} else {
		$("#util .cMyFav").hide();
		_siq   = "common.recent";
		tClass = ".cMyRecent";
		tId    = "#myRecentList";
	}
	
	$(".tabcontextbox").hide(); //context menu
	if ($("#util "+tClass).css("display") == "none") {
		var params = {};
		params._mtd = "getList";
		params.tranData = [{outDs:"rtnList",_siq:_siq}];
		var pMap = {
		    type: 'post', // POST 로 전송
		    async: false,
		    url: "${ctx}/biz/obj",
		    dataType: 'json',
		    data:params,
		    success:function(data) {
		    	$(tId).html("");
		    	$.each(data.rtnList, function(n, v) {
		    		if (type == "F") {
		    	    	$(tId).append('<li><a onClick="fn_removeBookMark(\''+v.MENU_CD+'\')" href="#" class="close"><img src="${ctx}/statics/images/common/pop_close2.png" alt=""></a><a href="#" class="fav" onClick="fn_goBookMark(\''+v.MENU_CD+'\');" title="'+v.MENU_NM+'" >'+v.MENU_NM+'</a></li>');
		    		} else {
		    	    	$(tId).append('<li><a href="#" class="fav" onClick="fn_goBookMark(\''+v.MENU_CD+'\');" title="'+v.MENU_NM+'" >'+v.MENU_NM+'</a></li>');
		    		}
		    	});
		    },
		    beforeSend: function(xhr) {
				gfn_setAjaxCsrf(xhr);
				xhr.setRequestHeader("AJAX",true);
				xhr.setRequestHeader("Accept", "application/json");
				xhr.setRequestHeader("Content-Type", "application/json");
			}
		}
		pMap.data = JSON.stringify(pMap.data);
		$.ajax(pMap);
		$("#util "+tClass).css('display','block');
		
	} else {
		$("#util "+tClass).css('display','none');
	}
}

function fn_pdfPopup() {
	var params = params || {}; //재정의
	params.popupYn = "Y";

	var url = "${ctx}/common/popup/pdfViewerPopup";
	var popupTitle = params.popupTitle || "PDF Viewer";
	var pWidth = params.width || 1200;
	var pHeight = params.height || 800;
	var pPos  = gfn_getPopupXY(pWidth,pHeight);
	var pLeft = pPos.left
	var pTop  = pPos.top

	var popOption = "left="+pLeft+", top="+pTop+", width="+pWidth+", height="+pHeight+", scrollbars=no, status=no, resizable=yes"; //, resizable=no
	window.open('', 'pdf_popup', popOption);
	
	//동적 hidden 데이터 생성
	var elem = $("#pdfPopForm > input[type='hidden']");
	$.each(elem, function(n,v) {
		if (v.name != "_csrf") $(v).remove();
	});
	$.each(params, function(n, v) {
	    $("#pdfPopForm").append('<input type="hidden" name="'+n+'" value="'+v+'" />');
	});

	$("#pdfPopForm").append('<input type="hidden" name="popupTitle" value="'+popupTitle+'" />');
    $("#pdfPopForm").attr("onSubmit","return true");
	$("#pdfPopForm").attr("action",url);
	$("#pdfPopForm").attr("target","pdf_popup");
	$("#pdfPopForm").submit().attr("onSubmit","return false");
}

//이동
function fn_goBookMark(cd) {
	$("#util .subbox").hide();
	subAddTab(null,cd);
}

//삭제
function fn_removeBookMark(cd) {
	if (cd == null || cd == undefined) return;
	
	$("#util .subbox").hide();
	var params = {};
	params._mtd     = "saveUpdate";
	params.tranData = [{outDs:"saveCnt",_siq:"common.bookMarkDel", grdData : [{P_MENU_CD: cd}]}];
	var pMap = {
	    type: 'post', // POST 로 전송
	    async: false,
	    url: "${ctx}/biz/obj",
	    dataType: 'json',
	    data:params,
	    success:function(data) {
	    	alert('<spring:message code="msg.saveOk"/>');
	    },
	}
	
	pMap.data = JSON.stringify(pMap.data);
	pMap.headers = {
		"Accept" : "application/json",
		"Content-Type" : "application/json",
		"AJAX" : true
	}
	$.ajax(pMap);
	
}

function fn_changeFrame() {
	$("#userTimeInt").val(userTimeInt+1);
	
	$("#mainForm").attr("onSubmit","return true");
    $("#mainForm").attr("action","${ctx}/common/godashboard");
    $("#mainForm").submit().attr("onSubmit","return false");
}

function fn_goLogOut() {
    $("#mainForm").attr("onSubmit","return true");
    $("#mainForm").attr("action","${ctx}/login/logout");
    $("#mainForm").submit().attr("onSubmit","return false");
}
</script>
	<div>
		<form id="menuForm" name="menuForm" method="POST" onSubmit="return false;">
			<input type="hidden" id="moduleCd" name="moduleCd" value="" />
			<input type="hidden" id="menuCd" name="menuCd" value="" />
			<input type="hidden" id="frameMenuCd" name="frameMenuCd" value="" />
			<input type="hidden" id="menuUrl" name="menuUrl" value="" />
			<sec:csrfInput />
			<div id="menuFormArgs"></div>
		</form>
	</div>
	<div id="menu">
		<ul id="nav">
			<c:forEach var="item1" items="${menuList}" varStatus="status">
			<c:if test="${item1.MENU_LVL eq 1}">
			<li class="top">
				<a href="#" class="top_link"><span class="down">${item1.MENU_NM}</span></a>
				<ul class="depth2" style="display:none;">
				<c:forEach var="item2" items="${menuList}" varStatus="status">
					<c:if test="${item2.MENU_LVL eq 2 and item2.UPPER_MENU_CD eq item1.MENU_CD}">
					<li>
						<a href="#"><span class="down">${item2.MENU_NM}</span></a>
						<ul class="depth3" style="display:none;">
						<c:forEach var="item3" items="${menuList}" varStatus="status">
						<c:if test="${item3.MENU_LVL eq 3 and item3.UPPER_MENU_CD eq item2.MENU_CD}">
							<li><a href="#" ><span onclick="addTab('','${item3.MENU_CD}','${item3.URL}');">${item3.MENU_NM}</span></a></li>
						</c:if>
						</c:forEach>
						</ul>
					</li>
					</c:if>
				</c:forEach>
				</ul>
			</li>
			</c:if>
			</c:forEach>
		</ul>
<!-- 	<div class="subDiv"></div> -->
	</div>
	
	<form id="pdfPopForm" name=pdfPopForm method="POST" onSubmit="return false;">
	<sec:csrfInput />
   	</form>
