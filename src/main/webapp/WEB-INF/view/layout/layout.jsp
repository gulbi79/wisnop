<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//JSP 캐시 삭제
	response.setHeader("Cache-Control", "no-cache"); 
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
<meta http-equiv="Expires" content="-1" /> 
<meta http-equiv="Pragma" content="no-cache" /> 
<meta http-equiv="Cache-Control" content="No-Cache" />
<sec:csrfMetaTags/>
<title>WonIk S&OP</title>
<link rel="stylesheet" href="${ctx}/statics/css/style.css" type="text/css" />
<link rel="stylesheet" href="${ctx}/statics/css/themes/easyui.css" type="text/css" />
<link rel="stylesheet" href="${ctx}/statics/css/themes/icon.css" type="text/css" />

<script type="text/javascript" src="${ctx}/statics/js/jquery/jquery-3.1.0.min.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/pub/pubCommon.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/biz/comutil.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/biz/common.js"></script>

<script type="text/javascript">
/*
 
 페이지 로딩시 위 FORM ELEMENT를 공지사항 개수만큼 동적으로 생성
 
 1. 공지사항 테이블에서 유효한 공지사항 갯수를 받아와 form element를 개수에 맞게 동적으로 생성(필요인자: form개수=>유효공지사항개수, 각 NOTICE_ID)
 2. 동적으로 생성한 form element를 바라보는 popup을 갯수만큼 호출
 3. 팝업호출 시, 각각의 NOTICE_ID를 인자값으로 팝업에 전달
 4. 각가의 팝업은 전달받은 NOTICE_ID를 기준으로 팝업에 표시할 CONTENT를 조회 후 표시
 
 */
    var value = "<spring:eval expression="@environment.getProperty('props.devMode')"/>";
    if(value != "REAL"){
        window.document.title = "WonIk S&OP TEST"
    }
	var offSet = 25;
	var popupWidth = window.screen.width*0.5;
	var popupHeight = window.screen.height*0.6;
	
	var popupX = (window.screen.width / 2) - (popupWidth / 2);
	var popupY= (window.screen.height / 2) - (popupHeight / 2);
	
	var popType = "noticeBoardPopup";
	$(document).ready(function() {
	
		fn_loadNoticeBoardContents();
		
		
 	});//end of document. ready



	//global 
	var global = {
		DS_HRCY_PRODUCT : null,
		DS_HRCY_CUSTOMER : null,
		DS_HRCY_SALES_ORG : null,
		exInstance : null,
		exGrdMain : null,
		exDataProvider : null,
		DS_MENU : []
	};
			 
	$(function() {
		var params;
		var pMap = {
		    type: 'post', // POST 로 전송
		    async: false,
		    url: "${ctx}/common/menuList",
		    dataType: 'json',
		    data:params,
		    success:function(data) {
		    	global.DS_MENU =  data.rtnList;
		    },
		    beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX",true);
				gfn_setAjaxCsrf(xhr);
			}
		}
		$.ajax(pMap);
		
		$("#sitemappop").draggable({
			containment: '#wrap', 
			scroll: false,
			handle:'.drag .pop_tit'
		});
		
		$("#sitemappop").resizable({   
			minHeight: 500,
		   	minWidth: 200
		});
		
		$('#tt').tabs({
		    border:false,
		    onSelect:function(title){
		    	var tab = $('#tt').tabs('getSelected');
		    	if (tab[0] != undefined) {
		    		var tmpId = tab[0].id;
		    		var tmpFrame = $(top.document).find("iframe[name="+tmpId+"]");
		    		if (tmpFrame[0] != undefined && (typeof tmpFrame[0].contentWindow.gfn_setSearchRow == 'function')) {
		    			tmpFrame[0].contentWindow.gfn_setSearchRow(); //search row set	
		    		}
		    	}
		    	$(".tabcontextbox").hide(); //context menu
		    	fn_filterImgToggle();
		    },
		    onContextMenu:function(e, title,index) {
		    	$(".tabcontextbox").css("top", e.clientY);
		        $(".tabcontextbox").css("left", e.clientX);
		        $(".tabcontextbox").show();
		    },
		    onBeforeClose: function(title,index) {
		    	return closeTab(index);
			}
		});
		
		//subAddTab(null, 'BSC001');
		createFrame('Home', 'HOME');
	});
	
	function addTab(title, menuCd, menuUrl, args) {
		if (!menuUrl) return;
		
		subAddTab(title, menuCd, menuUrl, args);
	}
	
	function subAddTab(title, menuCd, menuUrl, args) {
		var flag = 0;
		var chkMenu = false;
		if (title == null || title == undefined || title == "") {
			$.each(global.DS_MENU, function(n,v) {
				if (v.MENU_CD == menuCd) {
					title = v.MENU_NM;
					chkMenu = true;
					return false;
				}
			});
			
			if (chkMenu == false) {
				return false;
			}
		}
		  
		// menuCd 가 동일한 것이 있으면 그쪽으로 탭 활성화
		$("iframe").each(function(i, e) {
			var tab_id = $(e).attr("id");
		   	if(tab_id == menuCd) {
		    	$('#tt').tabs('select', i);
		    	flag = 1;
		    	return false;
		   	}
		});
		
		//이미존재
		if (flag == 1) {
			var tab = $('#tt').tabs('getSelected');
			//파라미터가 있는경우 기존탭닫고 새로생성
			if (args != undefined && args != null && args != "") {
				var index = $('#tt').tabs('getTabIndex', tab);
				$('#tt').tabs('close', index);
			} else {
				//search row set
				//$("#"+menuCd)[0].contentWindow.gfn_setSearchRow();
				if (tab[0] != undefined) {
		    		var tmpId = tab[0].id;
		    		var tmpFrame = $(top.document).find("iframe[name="+tmpId+"]");
		    		if (tmpFrame[0] != undefined && (typeof tmpFrame[0].contentWindow.gfn_setSearchRow == 'function')) {
		    			tmpFrame[0].contentWindow.gfn_setSearchRow(); //search row set	
		    		}
		    	}
			}
			
			fn_filterImgToggle();
		
		//없는경우 생성
		} else {
			createFrame(title, menuCd, menuUrl, args);
		}
	}
	
	function removeTabs(){
		
		if ($("iframe").length == 0) return;
		
		if (confirm("Do you want to close all tabs?")) {
			//$('#tt').tabs('remove');
			for(;;){
				var tab = $('#tt').tabs('getSelected');
				if (tab){
					var index = $('#tt').tabs('getTabIndex', tab);
					$('#tt').tabs('close', index);
				} else {
					break;
				}
			}
		}
	}
	
	function closeTab(index) {
		var tab = $('#tt').tabs('getTab',index);
		if (tab) {
			var checkData = true;
			if (tab[0] != undefined) {
	    		var tmpId = tab[0].id;
	    		var tmpFrame = $(top.document).find("iframe[name="+tmpId+"]");
	    		if (tmpFrame[0] != undefined && (typeof tmpFrame[0].contentWindow.fn_checkClose == 'function')) {
	    			checkData = tmpFrame[0].contentWindow.fn_checkClose();
	    		}
	    	}
			if (checkData == true) {
				return true;
			} else {
				return confirm("수정된 데이터가 있습니다. 탭을 닫의시겠습니까?");
			}
		}
		return true;
	}
	
	//tab 복사
	function copyFrame() {
		var pp = $('#tt').tabs('getSelected');
		var tab = pp.panel('options');
		if (tab != undefined && tab.menuCd != "HOME") {
			
			var tab2 = $('#tt').tabs('tabs');
			var options;
			var fCnt = 0;
			$.each(tab2, function(n,v) {
				options = v.panel('options');
				if (options.menuCd == tab.menuCd) fCnt++;
			});
			
			var title = tab.title;
			$.each(global.DS_MENU, function(n,v) {
				if (v.MENU_CD == tab.menuCd) {
					title = v.MENU_NM;
					return false;
				}
			});
			
			createFrame(title+"_"+fCnt, tab.menuCd, null, null, tab.menuCd+"_"+fCnt);
		}
	}
	
	function createFrame(title, menuCd, menuUrl, args, frameMenuCd) {

		frameMenuCd = frameMenuCd || menuCd;
		
		if ($("iframe").length > 10) {
			/* alert('<spring:message code="Available to open max 15 tabs."/>'); */
			alert('<spring:message code="msg.availableToOpenMax10Tabs."/>');
			

			return; //tab 10개까지만 구성	
		}
		
		var content = '<iframe scrolling="auto" name="'+frameMenuCd+'" id="'+frameMenuCd+'" frameborder="0" style="width:100%;height:100%;"></iframe>';
		$('#tt').tabs('add',{
			title:title,
			content:content,
			closable:true,
			id: frameMenuCd,
			menuCd: menuCd,
		});
		
		//동적 hidden 데이터 생성
		$("#menuFormArgs").html("");
		$.each(args, function(n, v) {
		    $("#menuFormArgs").append('<input type="hidden" name="'+n+'" value="'+v+'" />');
		});

		$("#moduleCd").val("");
		$("#menuCd").val(menuCd);
		$("#menuUrl").val(menuUrl);
		$("#frameMenuCd").val(frameMenuCd);
		
		$("#menuForm").attr("onSubmit","return true");
	    $("#menuForm").attr("action","${ctx}/common/goFrame");
	    $("#menuForm").attr("target",frameMenuCd);
	    
	    $("#menuForm").submit().attr("onSubmit","return false");
	}
	
	function fn_leftClose() {
		var tab = $('#tt').tabs('getSelected');
		if (tab) {
 			var index = $('#tt').tabs('getTabIndex', tab);
 			var tab_id = $("iframe:eq("+index+")").attr("id");
 			var tabDoc = $("#"+tab_id).contents()[0].contentDocument;
 			
 			// 왼쪽 트리 or 필터 가 있다면
 			if ($(tabDoc).find("#a").html()) {
  				if ($(tabDoc).find("#a").css("display") == "none") {
   					$(tabDoc).find("#a").css("display", "block");
   					$(tabDoc).find("#a").next().css("display", "block");
				   	var aWidth = $(tabDoc).find("#a").width() * 1;
				   	var aWidthSplit = $(tabDoc).find("#a").next().width() * 1;
   					$(tabDoc).find("#b").width("calc(100% - "+(aWidth+aWidthSplit)+"px)");
  				} else {
   					$(tabDoc).find("#a").css("display", "none");
				   	$(tabDoc).find("#a").next().css("display", "none");
				   	$(tabDoc).find("#b").width("calc(100% - 1px)");
  				}
  				var tmpFrame = $(top.document).find("iframe[id="+tab_id+"]");
  				tmpFrame[0].contentWindow.gfn_tabresize();
 			}
		}
		
		fn_filterImgToggle();
	}
	
	function fn_filterImgToggle() {
		var tab = $('#tt').tabs('getSelected');
		if (tab) {
 			var index = $('#tt').tabs('getTabIndex', tab);
 			var tab_id = $("iframe:eq("+index+")").attr("id");
 			var tabDoc = $("#"+tab_id).contents()[0].contentDocument;
 			
 			// 왼쪽 트리 or 필터 가 있다면
 			if ($(tabDoc).find("#a").html()) {
  				if ($(tabDoc).find("#a").css("display") == "none") {
  					$("#btnNav").attr("src", "${ctx}/statics/images/common/btn_nav_view.gif");
  				} else {
  					$("#btnNav").attr("src", "${ctx}/statics/images/common/btn_nav.gif");
  				}
 			} else {
  					$("#btnNav").attr("src", "${ctx}/statics/images/common/btn_nav.gif");
 			}
		}
	}
	
	function fn_loadNoticeBoardContents(){
		
		// 필요 인자:
		// 1. 유효공지사항 개수
		// 2. 각 공지사항의 PK값: NOTICE_ID 
		
		FORM_SEARCH = {};
		FORM_SEARCH._mtd = "getList";
		FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"admin.noticeBoardPopup"}]
		
		
		var pMap = {
			    type: 'post', // POST 로 전송
			    async: false,
			    contentType: 'application/json',
			    data:JSON.stringify(FORM_SEARCH),
			    dataType: 'json',
			    url: "${ctx}/biz/obj",
			    
			    success:function(data) {
			    	
			    	FORM_SEARCH.rtnList = data.rtnList;
			    	FORM_SEARCH.validCnt = data.rtnList.length;
			    },
			    beforeSend: function(xhr) {
					xhr.setRequestHeader("AJAX",true);
					gfn_setAjaxCsrf(xhr);
				}
			}
			$.ajax(pMap);
		
		if(FORM_SEARCH.validCnt>0)
		{
			fn_dynamicFormGen();	
		}
		
		
	}
	
	function fn_dynamicFormGen()
	{
		//쿠키를 검사하여 (더이상 띄우지 않음)조건인 팝업만 띄울 것
		for(i=0;i<FORM_SEARCH.validCnt;i++)
		{
			
			
			if(getCookie(FORM_SEARCH.rtnList[i].NOTICE_ID)!="end")
			{	
				
				var popOption = "left="+popupX+", top="+popupY+", width="+popupWidth+", height="+popupHeight+", scrollbars=yes, status=no, resizable=yes"; //, resizable=no
				window.open("",FORM_SEARCH.rtnList[i].NOTICE_ID , popOption);
				
				popupX +=offSet;
				popupY  +=offSet;
				
				
				var params = {
		   				rootUrl : "admin/popup",
		   				url : "/admin/popup/noticeBoardContentPopup",
		   				NOTICE_ID : FORM_SEARCH.rtnList[i].NOTICE_ID,
		   				FILE_NO : FORM_SEARCH.rtnList[i].FILE_NO
		   			}
				
				$('.mainFrame').append('<form id="noticePopForm'+(i+1)+'" name="noticePopForm'+(i+1)+'" method="POST" onSubmit="return false;"><sec:csrfInput /></form> ')
				
				
				var elem = $('#noticePopForm'+(i+1)+' > input[type="hidden"]');
				$.each(elem, function(n,v) {
					if (v.name != "_csrf") $(v).remove();
				});
				
				$("#noticePopForm"+(i+1)).append('<input type="hidden" name="popType" value="'+popType+'" />');
				
				$.each(params, function(n, v) {
				    $("#noticePopForm"+(i+1)).append('<input type="hidden" name="'+ n +'" value="'+ v +'" />');
				});
				
				$("#noticePopForm"+(i+1)).append('<input type="hidden" name="popupTitle" value="'+popType+'" />');
			
	
			    $("#noticePopForm"+(i+1)).attr("onSubmit","return true");
				$("#noticePopForm"+(i+1)).attr("action","${ctx}/admin/popup/noticeBoardContentPopup");
				$("#noticePopForm"+(i+1)).attr("target",FORM_SEARCH.rtnList[i].NOTICE_ID);
				
				$("#noticePopForm"+(i+1)).submit().attr("onSubmit","return false");
			
			}//end of if
			
		}	
		
		
		
	}
	
	
	function getCookie(key) {
	    var result = null;
	    var cookie = document.cookie.split(';');
	    
	    cookie.some(function (item) {
	        // 공백을 제거
	        item = item.replace(' ', '');
	 
	        var dic = item.split('=');
	 
	        if (key === dic[0]) {
	            result = dic[1];
	            
	            return true;    // break;
	        }
	    });
	    return result;
	}


	
</script>

</head>

<body class="mainFrame" oncontextmenu="return false">


<div id="wrap">
	<div class="header_wrap">
		<div class="gnbWrap">
			<div id="util">
			<ul>
				<li class="tselect">
					<form id="mainForm" name="mainForm" method="POST" onSubmit="return false;">
					<sec:csrfInput />
					<input type="hidden" id="userTimeInt" name="userTimeInt" value="" />
					<input type="hidden" id="userLang" name="userLang" value="${sessionScope.GV_LANG}" />
					<select id="company" name="company" title="company">
			    		<c:forEach var="item" items="${userCompanyList}">
			            <option value="${item.CODE_CD}" <c:if test="${sessionScope.GV_COMPANY_CD == item.CODE_CD}">selected</c:if> >${item.CODE_NM}</option>
			    		</c:forEach>
			        </select>
					
					<select id="bu" name="bu" title="bu">
		    		<c:forEach var="item" items="${userBuList}">
		            <option value="${item.CODE_CD}" <c:if test="${sessionScope.GV_BU_CD == item.CODE_CD}">selected</c:if> >${item.CODE_NM}</option>
		    		</c:forEach>
		        	</select>
					</form>
				</li>
				<!-- 즐겨찾기 버튼 및 클릭시 나오는 화면 시작 -->
				<li><a href="#" id="btnHelp"><img src="${ctx}/statics/images/common/btn_listview.png" alt="View" title='<spring:message code="lbl.pdfViewer"/>'/></a></li>
	            <li class="myfav"><a href="#" id="myRecent"><img src="${ctx}/statics/images/common/btn_menual.png" alt="Menual" title='<spring:message code="lbl.menual"/>'/></a>
					<div class="subbox cMyRecent">
					<ul id="myRecentList"></ul>
					</div>
	            </li>
	            <li class="myfav"><a href="#" id="myFav"><img src="${ctx}/statics/images/common/btn_favorite.png" alt="MY FAVORITE" title='<spring:message code="lbl.myFavorite"/>'/></a>
					<div class="subbox cMyFav">
					<ul id="myfavList"></ul>
					</div>
				</li>
				<li class="layout"><a href="#" id="btnLogOut"><img src="../statics/images/common/btn_logout.png" alt="LogOut" title='<spring:message code="lbl.logOuts"/>'/></a></li>
				<!-- 즐겨찾기 버튼 및 클릭시 나오는 화면 끝 -->
			</ul>
			</div>
		</div>

	  	<header class="hdt2">
		    <h1><a href="${ctx}/login/goPortal"><img src="${ctx}/statics/images/common/logo.png" alt="WonIk"></a></h1>
			<nav id="gnb"><h2><a href="#" onclick="fn_leftClose();return false;"><img id="btnNav" src="${ctx}/statics/images/common/btn_nav.gif" alt=""></a></h2></nav>
			<%@ include file="/WEB-INF/view/layout/menu.jsp" %>
	  	</header>
	</div>
<div id="tt" class="easyui-tabs" style="width:100%;"></div>
<div class="back"></div>
<div class="tabcontextbox">
	<ul>
		<li><a href="#" onClick="copyFrame();">COPY</a></li>
	</ul>
  </div>
  <%@ include file="/WEB-INF/view/layout/bottom.jsp" %> 
</div>
</body>
</html>
