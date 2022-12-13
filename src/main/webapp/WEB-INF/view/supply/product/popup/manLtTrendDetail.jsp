<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.summary"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>
<script type="text/javascript">
var lv_conFirmFlag = true;
var popupHeight;
var gridInstance, grdMain, dataProvider;
var popUpMenuCd = "${param.menuCd}";
var lv_conFirmFlag = true;
var codeMap = null;
var codeMapEx = null;
$("document").ready(function (){
	gfn_popresize();
	fn_init();
	fn_initFilter();
	fn_initGrid();
	fn_excelSqlAuth();
	
	gfn_keyPopAddEvent([
		{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>', popupYn : "Y" }
	]);
	
	
	$(".viewfnc5").click("on", function() {
		gfn_doExportExcel({fileNm:"${menuInfo.menuNm}", conFirmFlag: lv_conFirmFlag}); 
		$(".pClose").click(function() {
			$("#divTempLayerPopup").hide();
			$(".back").hide();
		});
	    $(".popClose").click(function() {
	    	$("#divTempLayerPopup").hide();
			$(".back").hide();
		});
	    $(".back").click(function() {
			$(".popup2").hide();
			$(".back").hide();
		});
	});
	
	$(".viewfnc4").click("on", function() {
		fn_apply(true);
		
		$(document).on("click",".popup2 .popClose, .popup2 .pClose",function() {
			$(".popup2").hide();
			$(".back").hide();
		});
		
		$(".back").click(function() {
			$(".popup2").hide();
			$(".back").hide();
		});
	    
	})
	
});

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

//데이터 초기화
function fn_init() {
	
	$(".fl_app").click("on", function() { fn_apply(); });
	$("#btnClose").click("on", function() { window.close(); });
	
	$(".viewfnc5").click("on", function() {
		gfn_doExportExcel({fileNm:'<spring:message code="lbl.pLtDetail"/>', conFirmFlag: lv_conFirmFlag}); 
		$(".pClose").click(function() {
			$("#divTempLayerPopup").hide();
			$(".back").hide();
		});
		
	    $(".popClose").click(function() {
			$("#divTempLayerPopup").hide();
			$(".back").hide();
		});
	});
	
	fn_comCode();
	
	
	//fn_apply();
}

//그리드 초기화
function fn_initGrid() {
	
	//그리드 설정
	gridInstance = new GRID();
	gridInstance.init("realgrid");
	grdMain	  = gridInstance.objGrid;
	dataProvider = gridInstance.objData;
	
	//그리드 옵션
	grdMain.setOptions({
		sorting : { enabled	  : false },
		display : { columnMovable: false }
	});

	var columns = 
	[
		{
   			name         : "ROUTING_ID",
   			fieldName    : "ROUTING_ID",
   			editable     : false,
   			header       : { text: '<spring:message code="lbl.routing"/>' },
   			styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
   			width        : 100,
   			mergeRule    : { criteria: "value" }
   		}, {
   			name         : "ITEM_GROUP_CD",
   			fieldName    : "ITEM_GROUP_CD",
   			editable     : false,
   			header       : { text: '<spring:message code="lbl.itemGroup"/>' },
   			styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
   			width        : 100,
   			mergeRule    : { criteria: "value" }
   		}, {
   			name         : "ITEM_GROUP_NM",
   			fieldName    : "ITEM_GROUP_NM",
   			editable     : false,
   			header       : { text: '<spring:message code="lbl.itemGroupName"/>' },
   			styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
   			width        : 100,
   			mergeRule    : { criteria: "value" }
   		}, {
   			name         : "ITEM_CD",
   			fieldName    : "ITEM_CD",
   			editable     : false,
   			header       : { text: '<spring:message code="lbl.itemCd"/>' },
   			styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
   			width        : 100,
   			mergeRule    : { criteria: "value" }
   		}, {
   			name         : "ITEM_NM",
   			fieldName    : "ITEM_NM",
   			editable     : false,
   			header       : { text: '<spring:message code="lbl.itemName"/>' },
   			styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
   			width        : 100,
   			mergeRule    : { criteria: "value" }
   		}, {
            name         : "ITEM_TYPE",
            fieldName    : "ITEM_TYPE",
            editable     : false,
            header       : { text: '<spring:message code="lbl.itemType"/>' },
            styles       : { textAlignment: "center", background : "rgba(237, 247, 253, 1)" },
            width        : 100,
            mergeRule    : { criteria: "value" }
        }
   		, {
            name         : "ITEM_TYPE_NM",
            fieldName    : "ITEM_TYPE_NM",
            editable     : false,
            header       : { text: '<spring:message code="lbl.itemTypeNm"/>' },
            styles       : { textAlignment: "center", background : "rgba(237, 247, 253, 1)" },
            width        : 100,
            mergeRule    : { criteria: "value" }
        }
        
        , {
   			name         : "SPEC",
   			fieldName    : "SPEC",
   			editable     : false,
   			header       : { text: '<spring:message code="lbl.spec"/>' },
   			styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
   			width        : 100,
   			mergeRule    : { criteria: "value" }
   		}, {
   			name         : "PROD_ORDER_NO",
   			fieldName    : "PROD_ORDER_NO",
   			editable     : false,
   			header       : { text: '<spring:message code="lbl.prodOrderNo4"/>' },
   			styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
   			width        : 100,
   			mergeRule    : { criteria: "value" }
   		}, {
   			name         : "PROD_ORDER_QTY",
   			fieldName    : "PROD_ORDER_QTY",
   			editable     : false,
   			header       : { text: '<spring:message code="lbl.prodOrderQty3"/>' },
   			styles       : { textAlignment: "far", background : "rgba(237, 247, 253, 1)", numberFormat : "#,##0" },
   			width        : 100,
   			dataType : "number"
   		}, {
   			name         : "RESULT_QTY",
   			fieldName    : "RESULT_QTY",
   			editable     : false,
   			header       : { text: '<spring:message code="lbl.resultQty"/>' },
   			styles       : { textAlignment: "far", background : "rgba(237, 247, 253, 1)", numberFormat : "#,##0" },
   			width        : 100,
   			dataType : "number"
   		}, {
   			name         : "REMAIN_QTY",
   			fieldName    : "REMAIN_QTY",
   			editable     : false,
   			header       : { text: '<spring:message code="lbl.remainQty2"/>' },
   			styles       : { textAlignment: "far", background : "rgba(237, 247, 253, 1)", numberFormat : "#,##0" },
   			width        : 100,
   			dataType : "number"
   		}, {
   			name         : "APPLY_APS_BAL_LT",
   			fieldName    : "APPLY_APS_BAL_LT",
   			editable     : false,
   			header       : { text: '<spring:message code="lbl.precedProd3"/>' },
   			styles       : { textAlignment: "far", background : "rgba(237, 247, 253, 1)", numberFormat : "#,##0" },
   			width        : 100,
   			dataType : "number"
   		}, {
   			name         : "RELEASE_DATE",
   			fieldName    : "RELEASE_DATE",
   			editable     : false,
   			header       : { text: '<spring:message code="lbl.releaseDate"/>' },
   			styles       : { textAlignment: "center", background : "rgba(237, 247, 253, 1)"},
   			width        : 100
   		}, {
   			name         : "COMP_DATE",
   			fieldName    : "COMP_DATE",
   			editable     : false,
   			header       : { text: '<spring:message code="lbl.endTime"/>' },
   			styles       : { textAlignment: "center", background : "rgba(237, 247, 253, 1)"},
   			width        : 100
   		}, {
   			name         : "MFG_LT",
   			fieldName    : "MFG_LT",
   			editable     : false,
   			header       : { text: '<spring:message code="lbl.lt"/>' },
   			styles       : { textAlignment: "far", background : "rgba(237, 247, 253, 1)", numberFormat : "#,##0" },
   			width        : 100,
   			dataType : "number"
   		}
	];

	grdMain.setColumns(columns);
	
	var fields = new Array();
	fields = [
		{ fieldName : "ROUTING_ID"},
		{ fieldName : "ITEM_GROUP_CD"},
		{ fieldName : "ITEM_GROUP_NM"},
		{ fieldName : "ITEM_CD"},
		{ fieldName : "ITEM_NM"},
		{ fieldName : "ITEM_TYPE"},
	      { fieldName : "ITEM_TYPE_NM"},
		{ fieldName : "SPEC"},
		{ fieldName : "PROD_ORDER_NO"},
		{ fieldName : "PROD_ORDER_QTY", dataType : 'number'},
		{ fieldName : "RESULT_QTY", dataType : 'number'},
		{ fieldName : "REMAIN_QTY", dataType : 'number'},
		{ fieldName : "APPLY_APS_BAL_LT", dataType : 'number'},
		{ fieldName : "RELEASE_DATE"},
		{ fieldName : "COMP_DATE"},
		{ fieldName : "MFG_LT", dataType : 'number'},
	];
	
	dataProvider.setFields(fields);
}

//그리드 데이터 조회
function fn_apply(sqlFlag) {
	
	FORM_SEARCH = $("#searchForm").serializeObject();
	FORM_SEARCH.sql = sqlFlag;
	FORM_SEARCH._mtd = "getList";
	FORM_SEARCH.prodPart = "${param.prodPart}";
	FORM_SEARCH.ltCompPoint	= "${param.ltCompPoint}";
	FORM_SEARCH.fromDate = "${param.fromDate}";
	FORM_SEARCH.toDate = "${param.toDate}";
	FORM_SEARCH.tranData = [{ outDs : "rtnList", _siq : "supply.product.manLtTrendDetailList"}];
	
	gfn_service({
		url    : GV_CONTEXT_PATH + "/biz/obj",
		data   : FORM_SEARCH,
		success: function(data) {
			
			//그리드 데이터 삭제
			dataProvider.clearRows();
			grdMain.cancel();
			//그리드 데이터 생성
			dataProvider.setRows(data.rtnList);
			gfn_actionMonthSum(gridInstance);
			
			
		}
	}, "obj");
	
}

//엑셀 다운로드 권한 확인
function fn_excelSqlAuth() {
	
	gfn_service({
	    async   : false,
	    url     : GV_CONTEXT_PATH + "/biz/obj",
	    data    : {
   			_mtd : "getList",
   			popUpMenuCd : popUpMenuCd,
   			tranData : [
   				{outDs : "authorityList", _siq : "supply.product.manLtTrendDetaiExcelSql"}
   			]
	    },
	    success :function(data) {
	    	
	    	for(i=0;i<data.authorityList.length;i++)
	    	{
	    		if(data.authorityList[i].USE_FLAG == "Y"&&data.authorityList[i].ACTION_CD=="EXCEL")
	    		{
	    			$('#excelSqlContainer').show();
	    			$("#excel").show();
	    		}
	    		else if(data.authorityList[i].USE_FLAG == "Y"&&data.authorityList[i].ACTION_CD=="SQL")
	    		{
	    			$('#excelSqlContainer').show();
	    			$("#sql").show();
	    		}
	    	}
	    		
	    }
	}, "obj");
	
}

function fn_comCode(){
	
	var grpCd    = 'ITEM_TYPE';
	   
	codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
	codeMapEx = gfn_getComCodeEx(["ITEM_GROUP"], null, {itemType : "" });
	
}
function fn_initFilter(){
	
    // 콤보박스
    gfn_setMsComboAll([
    	
    	
    	{target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : codeMap.ITEM_TYPE, exData:[""], option: {allFlag:"Y"}},
    	{target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : codeMapEx.ITEM_GROUP, exData:["*"]}
    	
    ])
	
	
}
</script>

</head>
<style type="text/css">
.locationext .fnc a {display:inline-block;overflow:hidden;height:27px;margin-left:4px;}
.li_none {list-style-type:none;background:white}
</style>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit"><spring:message code="lbl.detail2"/></div>
		<div class="popCont">
			<div class="srhwrap">
			<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
				<div class="srhcondi">
					<ul>
						<li id="divItem"></li>
						<li>
							<strong><spring:message code="lbl.prodOrderNo"/></strong>
							<input type="text" id="prodOrderNo" name="prodOrderNo" class="ipt" style="width:125px">
						</li>
						<li id="excelSqlContainer" style="display:none;">
								<div class="locationext">
									<div class="fnc">
										<a href="#" id='excel' style="display:none" class="viewfnc5"><img src="${ctx}/statics/images/common/btn_gun5.gif" title="Excel Download"></a>
							    		<a href="#" id='sql' style="display:none"class="viewfnc4"><img src="${ctx}/statics/images/common/btn_gun4.gif" title="SQL View"></a>
							    		
							    	</div>
								</div>
						</li>
					</ul>
					<ul>
					   <li>
                            <strong class="srhcondipop"><spring:message code="lbl.itemType"/></strong>
                            <div class="selectBox">
                                <select id="itemType" name="itemType" multiple="multiple" ></select>
                            </div>
                        </li>
                        <li>
                            <strong class="srhcondipop"><spring:message code="lbl.itemGroup"/></strong>
                            <div class="selectBox">
                                <select id="itemGroup" name="itemGroup" multiple="multiple"></select>
                            </div>
                        </li>
					
					</ul>
				</div>
			</form>
			<div class="bt_btn">
				<a href="javascript:;" class="fl_app"><spring:message code="lbl.search"/></a>
			</div>
			</div>
			<div id="realgrid" class="realgrid1" height="600"></div>
			
		</div>
		<div class="pop_btm">
			<div class="pop_btn_info">
				<strong >Sum  :</strong> <span id="bottom_userSum"></span>
			</div>
			<div class="pop_btn_info">
				<strong >Avg  :</strong> <span id="bottom_userAvg"></span>
			</div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>