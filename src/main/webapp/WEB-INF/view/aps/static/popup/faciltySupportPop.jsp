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
var codeMap;
$("document").ready(function () {
	gfn_popresize();
	fn_init();
	fn_initGrid();
	//fn_apply();
	fn_initEvent(); //이벤트 정의
});

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

function fn_init() {
	
	var grpCd = "PROD_PART,ORDER_STATUS";
	codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
	
	codeMap.PROD_PART = $.grep(codeMap.PROD_PART, function(v, n) {
		
		var result = v.CODE_CD;
		
		if(result != "MATERIAL"){
			return result;
		}
	});
	
	codeMap.ORDER_STATUS = $.grep(codeMap.ORDER_STATUS, function(v, n) {
		
		var result = v.CODE_CD;
		
		if(result != "CL"){
			return result;
		}
	});
	
	gfn_setMsCombo("prodPart", codeMap.PROD_PART, ["*"], {width:"122px"});
	gfn_setMsCombo("ordrStatus", codeMap.ORDER_STATUS, ["*"], {width:"122px"});
}

//이벤트 정의
function fn_initEvent() {
	
	$("#btnSearch").click("on", function() { 
		fn_apply(); 
	});
	
	$("#btnClose").on("click", function() { 
		window.close(); 
	});
	
	$("#btnApply").on("click", function() {
		var rows = grdMain.getCheckedRows(true);
		var returnData = [];
		$.each(rows, function(n,v) {
			returnData.push(dataProvider.getJsonRow(v));
		});
		fn_setData(returnData); 
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
		checkBar: { visible: true },
        stateBar: { visible: false },
        edit    : { editable: false},
        hideDeletedRows : true
	};
	grd.setOptions(options);
	grd.setSelectOptions({style: "rows"});
}

function fn_setFields(provider) {
	var fields = [
        {fieldName : "ITEM_CD"},
        {fieldName : "ITEM_NM"},
        {fieldName : "SPEC"},
        {fieldName : "ITEM_GROUP_CD"},
        {fieldName : "ROUTING_ID"},
        {fieldName : "PROD_PART"},
        {fieldName : "PROD_PART_NM"},
        {fieldName : "CUST_CD"},
        {fieldName : "CUST_NM"},
        {fieldName : "WORKER_GROUP"},
        {fieldName : "WORKER_GROUP_NM"},
        {fieldName : "PROD_ORDER_NO"},
        {fieldName : "ORDER_STATUS"},
        {fieldName : "ORDER_STATUS_NM"},
        {fieldName : "PROD_ORDER_QTY"},
        {fieldName : "REMAIN_QTY"},
        {fieldName : "ROUTING_NO"},
        {fieldName : "ITEM_TYPE"},
        {fieldName : "ITEM_TYPE_NM"}
        
    ];
    provider.setFields(fields);
}

function fn_setColumns(grd) {
	var totAr =  ['ITEM_CD', 'ITEM_NM', 'SPEC', 'ITEM_GROUP_CD', 'ROUTING_ID', 'PROD_PART_NM', 'CUST_NM', 'WORKER_GROUP_NM', 'PROD_ORDER_NO', 'ORDER_STATUS_NM', 'PROD_ORDER_QTY', 'REMAIN_QTY'];
	var columns = 
	[
		{ 
			name : "ITEM_CD", fieldName : "ITEM_CD", editable : false, header: {text: '<spring:message code="lbl.item" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
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
			name : "ROUTING_ID", fieldName : "ROUTING_ID", editable : false, header: {text: '<spring:message code="lbl.routing" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "PROD_PART_NM", fieldName : "PROD_PART_NM", editable : false, header: {text: '<spring:message code="lbl.prodPart2" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "CUST_NM", fieldName : "CUST_NM", editable : false, header: {text: '<spring:message code="lbl.custNm" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "WORKER_GROUP_NM", fieldName : "WORKER_GROUP_NM", editable : false, header: {text: '<spring:message code="lbl.workerGroup" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "PROD_ORDER_NO", fieldName : "PROD_ORDER_NO", editable : false, header: {text: '<spring:message code="lbl.prodOrderNo3" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "ORDER_STATUS_NM", fieldName : "ORDER_STATUS_NM", editable : false, header: {text: '<spring:message code="lbl.ordrStatus" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "PROD_ORDER_QTY", fieldName : "PROD_ORDER_QTY", editable : false, header: {text: '<spring:message code="lbl.prodOrderQty3" javaScriptEscape="true" />'},
			styles : {textAlignment: "far", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "REMAIN_QTY", fieldName : "REMAIN_QTY", editable : false, header: {text: '<spring:message code="lbl.remainQty2" javaScriptEscape="true" />'},
			styles : {textAlignment: "far", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}
	];
	
	grd.setColumns(columns); 
}

function fn_apply() {
	
	var rows = grdMain.getCheckedRows(true);
	gfn_clearArrayObject(arrChkData);
	gfn_clearArrayObject(chkData);
	$.each(rows, function(n,v) {
		chkData.push(dataProvider.getValue(v, "ITEM_CD"));
		arrChkData.push(dataProvider.getJsonRow(v));
	});
	
	var data = $("#searchForm").serializeObject();
	data.CHK_DATA  = chkData.toString();
	data.INIT_DATA = searchCode;
	data.productList = searchTreeArr;
	fn_getGridData(data);
}

//그리드 데이터 조회
function fn_getGridData(data) {
	
	data._mtd = "getList";
	data.tranData = [{outDs:"rtnList",_siq:"aps.static.facilitySupportPop"}];
	
	var sMap = {
		url : "${ctx}/biz/obj",
        data : data,
        success : fn_gridCallback,
    }

	gfn_service(sMap, "obj");
}

var fn_gridCallback = function(data) {
	
	grdMain.cancel();
	var grdData = data.rtnList;
	dataProvider.setRows($.merge(arrChkData, grdData));
	searchCode = chkData.toString() || searchCode;
	dataProvider.clearSavePoints();
	dataProvider.savePoint(); //초기화 포인트 저장
	gfn_unblockUI();

	var temp = $("#itemMappingData").val();
	//코드가 있는경우 체크
	if(!gfn_isNull(temp)) {
		var arrCode = temp.split(",");
		$.each(arrCode, function(n, v) {
			for (var i = 0; i < dataProvider.getRowCount(); i++) {
				if (grdMain.getValue(i, "ITEM_CD") == v) {
					grdMain.checkRow(i, true, false);
					break;
				}
			}
		});
	}
	grdMain.resetCurrent();
};

function fn_setData(returnData) {
	eval("opener.${param.callback}")(returnData);
	window.close();
}
</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit">${param.popupTitle}</div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
				<div class="srhcondi">
				<c:set var="lvWidth" value="115px" />
				<ul>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.prodPart2"/></strong>
						<div class="selectBox">
							<select id="prodPart" name="prodPart" multiple="multiple"></select>
						</div>
					</li>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.item"/></strong>
						<div class="selectBox">
							<input type="text" id="ITEM_NM" name="ITEM_NM" value="" class="ipt" style="width:${lvWidth};">
						</div>
					</li>
				</ul>
				<ul>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.ordrStatus"/></strong>
						<div class="selectBox">
							<select id="ordrStatus" name="ordrStatus" multiple="multiple"></select>
						</div>
					</li>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.prodOrderNo3"/></strong>
						<div class="selectBox">
							<input type="text" id="prodOrder" name="prodOrder" value="" class="ipt" style="width:${lvWidth};">
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
			<div class="pop_btn">
				<a href="#" id="btnApply" class="pbtn pApply"><spring:message code="lbl.apply"/></a>
				<a href="#" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>