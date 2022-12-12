<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.custGroupSelection"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
var popupWidth, popupHeight;
var gridInstance, grdMain, dataProvider;

$("document").ready(function (){
	gfn_popresize();
	fn_initGrid();
	fn_initEvent();
	fn_apply();
});

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

//그리드 초기화
function fn_initGrid() {
	//그리드 설정
	gridInstance = new GRID();
	gridInstance.init("realgrid");
	grdMain      = gridInstance.objGrid;
	dataProvider = gridInstance.objData;
	
	fn_setFields(dataProvider);
	fn_setColumns(grdMain);
	fn_setOptions(grdMain);
}

//그리드필드
function fn_setFields(provider) {
	var fields = [
		{ fieldName : "REP_CUST_CD" },
		{ fieldName : "REP_CUST_NM" }
	];
	dataProvider.setFields(fields);
}

//그리드컬럼
function fn_setColumns(grd) {
	
	var columns = [
		{
			name         : "REP_CUST_CD",
			fieldName    : "REP_CUST_CD",
			editable     : false,
			header       : { text: '<spring:message code="lbl.reptCust"/>' },
			styles       : { background : gv_noneEditColor },
			width        : 100,
		},
		{
			name         : "REP_CUST_NM",
			fieldName    : "REP_CUST_NM",
			editable     : true,
			header       : { text: '<spring:message code="lbl.reptCustName"/>' },
			styles       : { textAlignment: "near", background : gv_noneEditColor },
			width        : 200,
		}
	];
	grdMain.setColumns(columns);
}

//그리드 옵션
function fn_setOptions(grd) {
	grd.setOptions({
		checkBar: { visible: true, exclusive : true },
	});
}

//이벤트 초기화
function fn_initEvent() {
	
	//버튼 이벤트
	$(".fl_app"   ).click("on", function() { fn_apply(); });
	$("#btnClose" ).click("on", function() { window.close(); });
	$("#btnApply" ).click("on", function() { 
		var rows = grdMain.getCheckedRows(true);
		if (rows.lenght != 0) {
			fn_selection(rows[0]);
		} else {
			fn_selection(-1);
		}
	});
	
	//그리드 이벤트
	grdMain.onDataCellDblClicked = function (grid, index) {
		fn_selection(index.dataRow);
   	};
}

function fn_selection(dataRow) {
	
	if (opener && opener.fn_popupSaveCallback) {
		if (dataRow != -1) {
			opener.fn_popupSaveCallback(dataProvider.getJsonRow(dataRow), Number('${param.dataRow}'));	
		} else {
			opener.fn_popupSaveCallback();
		}
	}
	
	window.close();
}

//조회
function fn_apply(sqlFlag) {
	
	//조회조건 설정
	FORM_SEARCH = $("#searchForm").serializeObject();
	
	//그리드 데이터 조회
	fn_getGridData(sqlFlag);
}

//그리드 데이터 조회
function fn_getGridData(sqlFlag) {
	
	FORM_SEARCH.sql	     = sqlFlag;
	FORM_SEARCH._mtd     = "getList";
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"master.popup.custGroupSelection"}];
	
	gfn_service({
		url    : GV_CONTEXT_PATH + "/biz/obj.do",
		data   : FORM_SEARCH,
		success: function(data) {
			maxSeq = 0;
			//그리드 데이터 삭제
			dataProvider.clearRows();
			grdMain.cancel();
			//그리드 데이터 생성
			dataProvider.setRows(data.rtnList);
			//그리드 초기화 포인트 저장
			dataProvider.clearSavePoints();
			dataProvider.savePoint();
			// 그리드 데이터 건수 출력
			gfn_setSearchRow(dataProvider.getRowCount());
		}
	}, "obj");
}

</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit"><spring:message code="lbl.custGroupSelection"/></div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
					<div class="srhcondi">
						<ul>
							<li>
								<strong><spring:message code="lbl.reptCust"/></strong>
								<div class="selectBox">
									<input type="text" id="reptCust" name="reptCust" class="ipt">
								</div>
							</li>
						</ul>
					</div>
				</form>
				<div class="bt_btn">
					<a href="javascript:;" class="fl_app"><spring:message code="lbl.search"/></a>
				</div>
			</div>
			<div id="realgrid" class="realgrid1"></div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnApply" class="pbtn pApply"><spring:message code="lbl.apply"/></a>
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>