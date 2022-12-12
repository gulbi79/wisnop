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
	fn_initGrid();
	fn_apply();
	fn_initEvent(); //이벤트 정의
});

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

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
	grd.setCheckBar({exclusive: true});
}

function fn_setFields(provider) {
	var fields = [
        {fieldName : "OPERATION_NO"},
        {fieldName : "JOB_CD"},
        {fieldName : "JOB_NM"},
        {fieldName : "WC_CD"},
        {fieldName : "WC_NM"},
        {fieldName : "PROCESS_TIME", dataType : "number"}
    ];
    provider.setFields(fields);
}

function fn_setColumns(grd) {
	var totAr =  ['OPERATION_NO', 'JOB_CD', 'JOB_NM', 'WC_CD', 'WC_NM', 'W2_RATE', 'PROCESS_TIME'];
	var columns = 
	[
		{ 
			name : "OPERATION_NO", fieldName : "OPERATION_NO", editable : false, header: {text: '<spring:message code="lbl.operationNo" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "JOB_CD", fieldName : "JOB_CD", editable : false, header: {text: '<spring:message code="lbl.jobCd4" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "JOB_NM", fieldName : "JOB_NM", editable : false, header: {text: '<spring:message code="lbl.jobCd" javaScriptEscape="true" />'},
			styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "WC_CD", fieldName : "WC_CD", editable : false, header: {text: '<spring:message code="lbl.workplacesCode" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "WC_NM", fieldName : "WC_NM", editable : false, header: {text: '<spring:message code="lbl.workplacesName" javaScriptEscape="true" />'},
			styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "PROCESS_TIME", fieldName : "PROCESS_TIME", editable : false, header: {text: '<spring:message code="lbl.proccessTime" javaScriptEscape="true" />'},
			editor    : { type : "number", textAlignment : "far", editFormat : "#,##0", positiveOnly : true},
			styles    : { textAlignment : "far", background : gfn_getArrDimColor(0), numberFormat : "#,##0.0"}, 
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
	
	$.each(rows, function(n, v) {
		chkData.push(dataProvider.getValue(v, "JOB_CD"));
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
	data.tranData = [{outDs:"rtnList",_siq:"aps.static.facilitySupportPop3"}];
	
	var sMap = {
		url : "${ctx}/biz/obj.do",
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

	var temp = $("#jobCd").val();
	
	//코드가 있는경우 체크
	if(!gfn_isNull(temp)) {
		var arrCode = temp.split(",");
		$.each(arrCode, function(n, v) {
			
			for (var i = 0; i < dataProvider.getRowCount(); i++) {
				if (grdMain.getValue(i, "JOB_CD") == v) {
					grdMain.checkRow(i, true, false);
					break;
				}
			}
		});
	}
	grdMain.resetCurrent();
};

function fn_setData(returnData) {
	eval("opener.${param.callback}")(returnData, $("#rowId").val());
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
				<input type="hidden" id="rowId" name="rowId" value="${param.rowId }">
				<input type="hidden" id="jobCd" name="jobCd" value="${param.jobCd }">
				<div class="srhcondi">
				<c:set var="lvWidth" value="115px" />
				<ul>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.prodOrderNo3"/></strong>
						<div class="selectBox">
							<input type="text" id="prodOrderNo" name="prodOrderNo" value="${param.prodOrderNo }" class="ipt" style="width:${lvWidth};" readonly="readonly">
						</div>
					</li>
				</ul>
				</div>
				</form>
 				<div class="bt_btn">
					<%-- <a href="#" id="btnSearch" class="fl_app"><spring:message code="lbl.search"/></a> --%>
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