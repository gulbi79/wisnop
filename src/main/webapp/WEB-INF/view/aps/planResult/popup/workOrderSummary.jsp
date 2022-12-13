<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
var popupWidth, popupHeight;
var gridInstance, grdMain, dataProvider;
var searchCode, searchName;
var searchTreeArr = [];
var arrChkData = [];
var chkData = [];
var codeMap, codeMapEx;
var lv_conFirmFlag = true;
var popUpMenuCd = "${param.menuCd}";
$("document").ready(function () {
	gfn_popresize();
	fn_init();
	fn_initGrid();
	fn_apply();
	fn_initEvent(); //이벤트 정의
	fn_excelSqlAuth();
	$(".viewfnc5").click("on", function() {
		gfn_doExportExcel({fileNm:"${menuInfo.menuNm}", conFirmFlag: lv_conFirmFlag}); 
		$(".pClose").click(function() {
			console.log(".pClose clicked");
			$("#divTempLayerPopup").hide();
			$(".back").hide();
		});
	    $(".popClose").click(function() {
	    	console.log(".popClose clicked");
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

function fn_init() {
	
	var pRoute = "${param.P_ROUTE}";
	var pRouteSplit = pRoute.split(",");
	var pRouteArray = new Array();
	
	var pItemGroup = "${param.P_ITEM_GROUP}";
	var pItemGroupSplit = pItemGroup.split(",");
	var pItemGroupArray = new Array();
	
	$.each(pRouteSplit, function(i, val){
		pRouteArray.push(val);
	});
	
	$.each(pItemGroupSplit, function(i, val){
		pItemGroupArray.push(val);
	});
	
	codeMapEx = gfn_getComCodeEx(["ROUTING", "ITEM_GROUP"], null, {});
	
	gfn_setMsCombo("route", codeMapEx.ROUTING, ["*"], {width:"122px"});
	gfn_setMsCombo("itemGroup", codeMapEx.ITEM_GROUP, ["*"], {width:"122px"});
	
	$("#route").multipleSelect("open");
	$("#route").multipleSelect("setSelects", pRouteArray);
	$("#route").multipleSelect("close");
	
	$("#itemGroup").multipleSelect("open");
	$("#itemGroup").multipleSelect("setSelects", pItemGroupArray);
	$("#itemGroup").multipleSelect("close");
	
}


//이벤트 정의
function fn_initEvent() {
	
	$("#btnSearch").click("on", function() { 
		fn_apply(); 
	});
	
	$("#btnClose").on("click", function() { 
		window.close(); 
	});
}


//그리드를 그린다.
function fn_initGrid() {
	//변수처리
	gridInstance = new GRID();
	gridInstance.init("realgrid");
	grdMain = gridInstance.objGrid;
	dataProvider = gridInstance.objData;

    fn_setFields(dataProvider); 
    fn_setColumns(grdMain);
    fn_setOptions(grdMain);
}

function fn_setOptions(grd) {
	var options = {
		//checkBar: { visible: true },
        //stateBar: { visible: false },
        edit    : { editable: false},
        hideDeletedRows : true
	};
	grd.setOptions(options);
	//grd.setSelectOptions({style: "rows"});
}

function fn_setFields(provider) {
	var fields = [
        {fieldName : "ROUTING_ID"},
        {fieldName : "ITEM_CD"},
        {fieldName : "ITEM_NM"},
        {fieldName : "SPEC"},
        {fieldName : "ITEM_GROUP_CD"},
        {fieldName : "CUST_NM"},
        {fieldName : "PROD_ORDER_QTY"}
    ];
    provider.setFields(fields);
}

function fn_setColumns(grd) {
	var totAr =  ['ROUTING_ID', 'ITEM_CD', 'ITEM_NM', 'SPEC', 'ITEM_GROUP_CD', 'CUST_NM', 'PROD_ORDER_QTY'];
	var columns = 
	[
		{ 
			name : "ROUTING_ID", fieldName : "ROUTING_ID", editable : false, header: {text: '<spring:message code="lbl.routing" javaScriptEscape="true" />'},
			styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "ITEM_CD", fieldName : "ITEM_CD", editable : false, header: {text: '<spring:message code="lbl.item" javaScriptEscape="true" />'},
			styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "ITEM_NM", fieldName : "ITEM_NM", editable : false, header: {text: '<spring:message code="lbl.itemName" javaScriptEscape="true" />'},
			styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "SPEC", fieldName : "SPEC", editable : false, header: {text: '<spring:message code="lbl.spec" javaScriptEscape="true" />'},
			styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "ITEM_GROUP_CD", fieldName : "ITEM_GROUP_CD", editable : false, header: {text: '<spring:message code="lbl.itemGroup" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "CUST_NM", fieldName : "CUST_NM", editable : false, header: {text: '<spring:message code="lbl.reptCust" javaScriptEscape="true" />'},
			styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "PROD_ORDER_QTY", fieldName : "PROD_ORDER_QTY", editable : false, header: {text: '<spring:message code="lbl.prodOrderQty" javaScriptEscape="true" />'},
			styles : {textAlignment: "far", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}
	];
	
	grd.setColumns(columns); 
}

function fn_apply(sqlFlag) {
	
	var data = $("#searchForm").serializeObject();
	data._mtd = "getList";
	data.tranData = [{outDs : "rtnList", _siq : "aps.planResult.workOrderSummary"}];
	data.sql	= sqlFlag;	
	var aOption = {
			url : "${ctx}/biz/obj",
		data    : data,
		success : function (data) {
			dataProvider.setRows(data.rtnList);
		}
	}
	
	gfn_service(aOption, "obj");
}

//엑셀, 쿼리 다운로드 권한 확인
function fn_excelSqlAuth() {
	
	gfn_service({
	    async   : false,
	    url     : GV_CONTEXT_PATH + "/biz/obj",
	    data    : {
   			_mtd : "getList",
   			popUpMenuCd : popUpMenuCd,
   			tranData : [
   				{outDs : "authorityList", _siq : "aps.planResult.workOrderReplaceExcelSql"}//APS > 계획결과 > 작업지시 조회 페이지의 SQL, 엑셀 권한을 참조하므로 공통쿼리 사용 
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


</script>
<style type="text/css">
.locationext .fnc a {display:inline-block;overflow:hidden;height:27px;margin-left:4px;}
.li_none {list-style-type:none;background:white}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit">${param.popupTitle}</div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
				<input type="hidden" id="plan_id" name="plan_id" value="${param.P_PLAN_ID }"/>
				
				<div class="srhcondi">
				<c:set var="lvWidth" value="115px" />
				<ul>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.routing"/></strong>
						<div class="selectBox">
							<select id="route" name="route" multiple="multiple"></select>
						</div>
					</li>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.itemGroup"/></strong>
						<div class="selectBox">
							<select id="itemGroup" name="itemGroup" multiple="multiple"></select>
						</div>
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
						<strong class="srhcondipop"><spring:message code="lbl.reptCust"/></strong>
						<div class="selectBox">
							<input type="text" id="reptCust" name="reptCust" value="" class="ipt" style="width:${lvWidth};">
						</div>
					</li>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.item"/></strong>
						<div class="selectBox">
							<input type="text" id="item" name="item" value="" class="ipt" style="width:${lvWidth};">
						</div>
					</li>
				</ul>
				</div>
				</form>
 				<div class="bt_btn">
					<a href="#" id="btnSearch" class="fl_app"><spring:message code="lbl.search"/></a>
				</div>
			</div>
			<div id="realgrid" class="realgrid1"></div>
			
		</div>
		<div class="pop_btm">
			<div class="pop_btn_info">
				<strong >Sum  :</strong> <span id="bottom_userSum"></span>
			</div>
			<div class="pop_btn_info">
				<strong >Avg  :</strong> <span id="bottom_userAvg"></span>
			</div>	
			<div class="pop_btn">
				<%-- <a href="#" id="btnApply" class="pbtn pApply"><spring:message code="lbl.apply"/></a> --%>
				<a href="#" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>