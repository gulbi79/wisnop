<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">

<c:if test="${param.popupYn == '' || param.popupYn== null}">
	$(window).resize(function(event) {
		var browser_width = window.innerWidth || document.body.clientWidth;
		
		if (browser_width < 450) {			
			event.preventDefault();
			return false;
		}		
		gfn_tabresize();
	}).resize();
</c:if>

	//그리드 설정 ----------------------------------------------------------------
	try {
		RealGridJS.setRootContext(GV_CONTEXT_PATH + "/statics/js/realgrid");
	} catch(e) {
		console.log(e);
	}
	//RealGridJS.setTrace(true);

	// Input에 입력시 공백 제거 및 Enter시 조회 호출
	$(document).ready(function () {

		$("#divTempLayerPopup").draggable({containment: '#wrap', scroll: false});
		$("#divTempLayerPopup").resizable({   
			minHeight: 100,
		   	minWidth: 100
		});
		
		// INPUT 에서 Enter 시 조회 기능 구현.
		var tmpEnFlag = "N"; 
		<c:if test="${param.popupYn == 'Y'}">
		tmpEnFlag = "Y";
		</c:if>
		
		if ((typeof(enterSearchFlag) != "undefined" && enterSearchFlag == "Y") || tmpEnFlag == "Y") gfn_setEnterSearch();

	<c:if test="${param.popupYn == '' || param.popupYn== null}">
		gfn_tabresize();
		if($("#filterDv .scroll").hasVerticalScrollBar()){
			selectorAWidth = "270px";
		} else {
			selectorAWidth = "249px";
		}
		gfn_tabresize();
		
	</c:if>

	});
	
<c:if test="${param.siteMapYn == 'Y'}">
	function fn_siteMap() {
    	var menuHtml = '';
		var tmpChk1 = false;
		var tmpChk2 = false;
		var dsMenu = gfn_getGlobal("DS_MENU");
		$.each(dsMenu, function(n,v) {
			
			if (v.MENU_LVL == 1) {
				menuHtml += '<h3>'+v.MENU_NM+'</h3>\n';
				menuHtml += '<ul class="list_site">\n';
			}
				
			tmpChk1 = false;
			$.each(dsMenu, function(n2,v2) {
				if (v.MENU_CD == v2.UPPER_MENU_CD && v2.MENU_LVL == 2) {
					menuHtml += '	<li><a href="#">'+v2.MENU_NM+'</a>\n';
					menuHtml += '		<ul>\n';
					
					tmpChk2 = false;
					$.each(dsMenu, function(n3,v3) {
						if (v2.MENU_CD == v3.UPPER_MENU_CD && v3.MENU_LVL == 3) {
							menuHtml += '			<li><a href="javascript:gfn_newTab(\''+v3.MENU_CD+'\');">'+v3.MENU_NM+'</a></li>\n';
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

</c:if>
</script>
	<div>
	   	<c:if test="${param.popupYn == '' || param.popupYn== null}">
	   	<form id="commonForm" name="commonForm" method="POST" onSubmit="return false;">
	       	<input type="hidden" id="menuCd" name="menuCd" value="${menuInfo.menuCd}" />
	       	<input type="hidden" id="frameMenuCd" name="frameMenuCd" value="${menuInfo.frameMenuCd}" />
	       	<input type="hidden" id="dimensionYn" name="dimensionYn" value="${menuInfo.dimensionYn}" />
	       	<input type="hidden" id="measureYn" name="measureYn" value="${menuInfo.measureYn}" />
	       	<input type="hidden" id="producthrcyYn" name="producthrcyYn" value="${menuInfo.producthrcyYn}" />
	       	<input type="hidden" id="customerhrcyYn" name="customerhrcyYn" value="${menuInfo.customerhrcyYn}" />
	       	<input type="hidden" id="salesOrghrcyYn" name="salesOrghrcyYn" value="${menuInfo.salesOrghrcyYn}" />
	       	<input type="hidden" id="dimFixYn" name="dimFixYn" value="${menuInfo.dimFixYn}" />
	       	<input type="hidden" id="saveYn" name="saveYn" value="${menuInfo.saveYn}" />
	       	<input type="hidden" id="subMenuCnt" name="subMenuCnt" value="${menuInfo.subMenuCnt}" />
	       	<input type="hidden" id="comBucketMask" name="comBucketMask" value="${menuInfo.comBucketMask}" />
	       	<input type="hidden" id="menuType" name="menuType" value="${menuInfo.menuType}" />
	       	<input type="hidden" id="menuParam" name="menuParam" value="${menuInfo.menuParam}" />
	   	</form>
	   	</c:if>
	   	<form id="commonPopForm" name="commonPopForm" method="POST" onSubmit="return false;">
		<sec:csrfInput />
	   	</form>
	   	<c:if test="${param.popupYn != '' && param.popupYn != null}">
       	<input type="hidden" id="menuCd" name="menuCd" value="${menuInfo.menuCd}" />
   	   	<input type="hidden" id="saveYn" name="saveYn" value="${menuInfo.saveYn}" />
	   	</c:if>
	</div>
	<div id="divFindPopup" class="popup" style="display:none"></div>
	<div id="divTempLayerPopup" class="popup" style="display:none"></div>
	<div id="divTreeFindPopup" class="popup" style="display:none"></div>
	<div class="back"></div>
	<div class="back_white"></div>