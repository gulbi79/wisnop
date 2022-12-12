<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
$(function() {
	//input 이벤트 정의
	$("#treewrap").bind("keydown", function() {
		if (event.ctrlKey == true && event.keyCode == 70) {
			
			var inHtml = '';
			inHtml += '<div class="popup2" style="width:250px;" id="treeFind">';
			inHtml += '	<div class="drag">';
			inHtml += '	<div class="pop_tit">Find Hierarchy</div>';
			inHtml += '	<div class="popCont" style="height:23px;">';
			inHtml += '		<div class="view_combo">';
			inHtml += '			<div class="ilist">';
			inHtml += '				<input type="text" id="SEARCH_TREE" name="SEARCH_TREE" class="ipt" style="width:157px;"> <a onClick="gfn_findTree();" href="#" class="app">Find</a>';
			inHtml += '			</div>';
			inHtml += '		</div>';
			inHtml += '	</div>';
			inHtml += '	</div>';
			inHtml += '	<a href="#" class="popClose"><img src="'+ GV_CONTEXT_PATH +'/statics/images/common/pop_close.png" alt=""></a>';
			inHtml += '</div>';

			$("#divTreeFindPopup").html(""); //초기화
			$("#divTreeFindPopup").html(inHtml);
			
			$("#divTreeFindPopup").draggable({
				containment: '#wrap', 
				scroll: false,
				handle:'.drag .pop_tit'
			});
			
			$("#divTreeFindPopup").css('zIndex',99999);
			$("#divTreeFindPopup").show();
			$("#SEARCH_TREE").focus();
			//$(".back_white").show();
			$(".back_white").on("click", function() {
				//$(".popup2").hide();
				$("#divTreeFindPopup").hide();
				$(".back_white").hide();
			});

			$(".popClose").click(function() {
				$(".back_white").trigger("click");
			});
			
			//text 초기화
			$("#SEARCH_TREE").unbind();
			$("#SEARCH_TREE").bind("keydown", function() {
				if (event.keyCode == 13) {
					gfn_findTree();
					return false;
				}
				if (event.key == "Escape") {
					$(".back_white").trigger("click");
				}
			});
			
			$("#divTreeFindPopup").click( function( e ) {
		        return false;
		    });

			/*
			var w = $("#divTreeFindPopup").height() / 2; // 레이어 팝업의 가로 길이의 절반
			var h = $("#divTreeFindPopup").width() / 2; // 레이어 팝업의 세로 길이의 절반
			$("#divTreeFindPopup").css("left", "calc(20% - "+w+"px)");
			$("#divTreeFindPopup").css("top", "calc(35% - "+h+"px)");
			*/
			$("#divTreeFindPopup").css("left", $("#treewrap").width()+10);
			$("#divTreeFindPopup").css("top", $("#treewrap").offset().top+25);
			
			return false;
		}
	});
});

function gfn_findTree() {
	
	var person = $("#SEARCH_TREE").val();
	if (gfn_isNull(person)) {
		return false;
	}
	
	var treeObj;
	var treeTabId = $("#treeTab > li > .on")[0].id;
	$.each(HRCY.mapHrcy, function(n,v) {
		if (v.treeTabId == treeTabId) {
			treeObj = gv_zTreeObj[v.id];
		}
	});
	
	var sNodeNm = "";
	var sPath   = "";
	var sIdx    = 0;
	var sNodes = treeObj.getSelectedNodes();
	if (sNodes.length > 0) {
		sNodeNm = sNodes[0].name;
		//sPath   = sNodes[0].PATH;
		sPath   = sNodes[0].pId;
		sIdx    = Number(sNodes[0].ROW_IDX);
	}
	
   	var nodes = treeObj.getNodesByParamFuzzy("name", person, null);
	var selIdx = -1;
	var wrapFlag = true;
	if (!gfn_isNull(sPath)) {
		$.each(nodes, function(n,v) {
			selIdx++;
			if (sIdx < Number(v.ROW_IDX)) {
				wrapFlag = false;
				return false;
			}
		});

		if (wrapFlag == true) {
			selIdx = -1;
			$.each(nodes, function(n,v) {
				selIdx++;
				if (sIdx >= Number(v.ROW_IDX)) {
					return false;
				}
			});
		}
	}
	
	if (selIdx == -1) selIdx = 0;
	
	if (nodes.length == 0) {
		alert('<spring:message code="msg.noDataFound"/>', function() {
			$("#treewrap").attr("tabindex", -1).focus();
		});
	} else {
	   	treeObj.selectNode(nodes[selIdx]);
	}
   	
   	return false;
}

</script>

<c:if test="${menuInfo.producthrcyYn eq 'Y' or menuInfo.customerhrcyYn eq 'Y' or menuInfo.salesOrghrcyYn eq 'Y'}">
	<c:set var="classOn">on</c:set>
	<c:set var="display">display:;</c:set>
			<div id="treewrap">
				<div class="inner">
					<div class="content_wrap">
						<ul id="treeTab" class="treeNav">
							<c:if test="${menuInfo.producthrcyYn eq 'Y'}">
								<li><a id="treeTab1" href="#" class="${classOn}">Product</a></li>
	                        	<c:set var="classOn">off</c:set>
							</c:if>
							<c:if test="${menuInfo.customerhrcyYn eq 'Y'}">
								<li><a id="treeTab2" href="#" class="${classOn}">Customer</a></li>
	                        	<c:set var="classOn">off</c:set>
							</c:if>
							<c:if test="${menuInfo.salesOrghrcyYn eq 'Y'}">
								<li><a id="treeTab3" href="#" class="${classOn}">Sales Org</a></li>
	                        	<c:set var="classOn">off</c:set>
							</c:if>
						</ul>
						
						<div class="treeborder">
							<!-- 
							<div class="tree_srhChk">
								<input type="checkbox" id="trck1" name=""> <label for="trck1">FERT</label>
								<input type="checkbox" id="trck2" name=""> <label for="trck2">HAWA</label>
								<input type="checkbox" id="trck3" name=""> <label for="trck3">HALB</label>
							</div>
 							-->
							<div class="scroll">
								<c:set var="display">display:;</c:set>
								<c:if test="${menuInfo.producthrcyYn eq 'Y'}">
									<div id="treeMenu1" class="zTreeDemoBackground left" style="${display}">
										<ul id="treeProduct" class="ztree"></ul>
									</div>
									<c:set var="display">display:none;</c:set>
								</c:if>
								<c:if test="${menuInfo.customerhrcyYn eq 'Y'}">
									<div id="treeMenu2" class="zTreeDemoBackground left" style="${display}">
										<ul id="treeCustomer" class="ztree"></ul>
									</div>
									<c:set var="display">display:none;</c:set>
								</c:if>
								<c:if test="${menuInfo.salesOrghrcyYn eq 'Y'}">
									<div id="treeMenu3" class="zTreeDemoBackground left" style="${display}">
										<ul id="treeSalesOrg" class="ztree"></ul>
									</div>
									<c:set var="display">display:none;</c:set>
								</c:if>
							</div>
						</div>
					</div>
				</div>
			</div>
</c:if>