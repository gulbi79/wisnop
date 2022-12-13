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
$("document").ready(function () {
	gfn_popresize();
	fn_initGrid();
	fn_initEvent();
	fn_apply();
});

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

function fn_initEvent() {
	
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
        edit    : { editable: false},
        hideDeletedRows : true
	};
	grd.setOptions(options);
	grd.setSelectOptions({style: "rows"});
}

function fn_setFields(provider) {
	var fields = [
        {fieldName : "STEP_NO"},
        {fieldName : "CB_TASK_CD_NM"},
        {fieldName : "START_DTTM", dataType : 'datetime'},
        {fieldName : "END_DTTM", dataType : 'datetime'},
        {fieldName : "CB_STATUS_CD_NM"},
        {fieldName : "REMARK"}
    ];
    provider.setFields(fields);
}

function fn_setColumns(grd) {
	var totAr =  ['STEP_NO', 'CB_TASK_CD_NM', 'START_DTTM', 'END_DTTM', 'CB_STATUS_CD_NM', 'REMARK'];
	var columns = 
	[
		{ 
			name : "STEP_NO", fieldName : "STEP_NO", editable : false, header: {text: '<spring:message code="lbl.stepNo" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
			width : 80,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "CB_TASK_CD_NM", fieldName : "CB_TASK_CD_NM", editable : false, header: {text: '<spring:message code="lbl.task" javaScriptEscape="true" />'},
			styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
			width : 150,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "START_DTTM", fieldName : "START_DTTM", editable : false, header: {text: '<spring:message code="lbl.startTime" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0), datetimeFormat : "yyyy-MM-dd HH:mm:ss"},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "END_DTTM", fieldName : "END_DTTM", editable : false, header: {text: '<spring:message code="lbl.endTime2" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0), datetimeFormat : "yyyy-MM-dd HH:mm:ss"},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "CB_STATUS_CD_NM", fieldName : "CB_STATUS_CD_NM", editable : false, header: {text: '<spring:message code="lbl.status" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}, {
			name : "REMARK", fieldName : "REMARK", editable : false, header: {text: '<spring:message code="lbl.remark2" javaScriptEscape="true" />'},
			styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
			width : 120,
			dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
		}
	];
	
	grd.setColumns(columns); 
}

function fn_apply() {
	
	var data = $("#searchForm").serializeObject();
	data._mtd = "getList";
	data.tranData = [{outDs : "rtnList", _siq : "aps.planExecute.controlBoardAPop"}];
	
	var aOption = {
			url : "${ctx}/biz/obj",
		data    : data,
		success : function (data) {
			dataProvider.setRows(data.rtnList);
		}
	}
	
	gfn_service(aOption, "obj");
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
				<input type="hidden" id="company_cd" name="company_cd" value="${param.company_cd }"/>
				<input type="hidden" id="bu_cd" name="bu_cd" value="${param.bu_cd }"/>
				<input type="hidden" id="row_id" name="row_id" value="${param.row_id }"/>
				
				<div class="srhcondi">
				<c:set var="lvWidth" value="115px" />
				<ul>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.planId"/></strong>
						<div class="selectBox">
							<input type="text" id="plan_id" name="plan_id" value="${param.plan_id }" class="ipt" style="width:${lvWidth};" readonly="readonly">
						</div>
					</li>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.prodPart2"/></strong>
						<div class="selectBox">
							<input type="text" id="prod_part" name="prod_part" value="${param.prod_part }" class="ipt" style="width:${lvWidth};" readonly="readonly">
						</div>
					</li>
				</ul>
				<ul>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.planVersion"/></strong>
						<div class="selectBox">
							<input type="text" id="version_id" name="version_id" value="${param.version_id }" class="ipt" style="width:${lvWidth};" readonly="readonly">
						</div>
					</li>
					<%-- <li>
						<strong class="srhcondipop"><spring:message code="lbl.item"/></strong>
						<div class="selectBox">
							<input type="text" id="item" name="item" value="" class="ipt" style="width:${lvWidth};">
						</div>
					</li> --%>
				</ul>
				</div>
				</form>
 				<div class="bt_btn">
					<%-- <a href="#" id="btnSearch" class="fl_app"><spring:message code="lbl.search"/></a> --%>
				</div>
			</div>
			<div id="realgrid" class="realgrid1"></div>
			<div class="pop_btn">
				<%-- <a href="#" id="btnApply" class="pbtn pApply"><spring:message code="lbl.apply"/></a> --%>
				<a href="#" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>