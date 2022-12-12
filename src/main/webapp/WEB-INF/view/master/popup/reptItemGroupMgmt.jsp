<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.reptItemGroupMgmt"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
var popupWidth, popupHeight;
var gridInstance, grdMain, dataProvider;
var maxSeq = 0;

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
	
	grdMain.addCellStyles([{ id: "editFalse", editable: false }]);
}

//그리드필드
function fn_setFields(provider) {
	var fields = [
		{ fieldName : "COMPANY_CD" },
		{ fieldName : "BU_CD" },
		{ fieldName : "REP_ITEM_GROUP_CD" },
		{ fieldName : "REP_ITEM_GROUP_NM" },
		{ fieldName : "UPDATE_DTTM" },
		{ fieldName : "UPDATE_ID" },
		{ fieldName : "CREATE_DTTM" },
		{ fieldName : "CREATE_ID" },
	];
	dataProvider.setFields(fields);
}

//그리드컬럼
function fn_setColumns(grd) {
	var columns = [
		{
			name         : "REP_ITEM_GROUP_CD",
			fieldName    : "REP_ITEM_GROUP_CD",
			editable     : false,
			header       : { text: '<spring:message code="lbl.reptItemGroup"/>' },
			styles       : { background : gv_noneEditColor, textAlignment: "near" },
			width        : 100,
		},
		{
			name         : "REP_ITEM_GROUP_NM",
			fieldName    : "REP_ITEM_GROUP_NM",
			editable     : true,
			header       : { text: '<spring:message code="lbl.reptItemGroupName"/>' },
			styles       : { textAlignment: "near" },
			dynamicStyles: [{
                criteria: ["(state='d') or (state='x')","(state<>'d') and (state<>'x')"],
                styles  : ["background="+gv_noneEditColor,"background="+gv_requiredColor]
            }],
			width        : 150,
		},
		{
			name         : "UPDATE_DTTM",
			fieldName    : "UPDATE_DTTM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.updateDttm"/>' },
			styles       : { background : gv_noneEditColor },
			width        : 120,
		},
		{
			name         : "UPDATE_ID",
			fieldName    : "UPDATE_ID",
			editable     : false,
			header       : { text: '<spring:message code="lbl.updateBy"/>' },
			styles       : { background : gv_noneEditColor, textAlignment: "near" },
			width        : 100,
		},
		{
			name         : "CREATE_DTTM",
			fieldName    : "CREATE_DTTM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.createDttm"/>' },
			styles       : { background : gv_noneEditColor },
			width        : 120,
		},
		{
			name         : "CREATE_ID",
			fieldName    : "CREATE_ID",
			editable     : false,
			header       : { text: '<spring:message code="lbl.createBy"/>' },
			styles       : { background : gv_noneEditColor, textAlignment: "near" },
			width        : 100,
		},
	];
	grdMain.setColumns(columns);
}

//그리드 옵션
function fn_setOptions(grd) {
	grd.setOptions({
		checkBar: { visible: true, showAll: true },
		stateBar: { visible: true }
	});
}

//이벤트 초기화
function fn_initEvent() {
	$(".fl_app"   ).click("on", function() { fn_apply(); });
	$("#btnReset" ).click("on", function() { fn_reset(); });
	$("#btnAdd"   ).click("on", function() { fn_add(); });
	$("#btnDelete").click("on", function() { fn_del(); });
	$("#btnSave"  ).click("on", function() { fn_save(); });
	$("#btnClose" ).click("on", function() { window.close(); });
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
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"master.popup.reptItemGroupMgmt"}];
	
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

//그리드 초기화
function fn_reset() {
	grdMain.cancel();
	dataProvider.rollback(dataProvider.getSavePoints()[0]);
	maxSeq = 0;
}

//그리드 행추가
function fn_add() {
	
	// 최대 시컨스값 조회
	if (maxSeq == 0) {
		maxSeq = fn_getReptItemGroupCodeMaxSeq();
	} 
	
	// 로우추가
	grdMain.commit();
	var rowIdx = dataProvider.getRowCount();
	dataProvider.insertRow(rowIdx, { REP_ITEM_GROUP_CD : "RIG" + gfn_lpad(maxSeq+"", 3, "0") });
	grdMain.setCurrent({dataRow : rowIdx});
	
	//
	maxSeq++;
}

//삭제
function fn_del() {
	var rows = grdMain.getCheckedRows();
	grdMain.setCellStyles(rows,["REP_ITEM_GROUP_CD","REP_ITEM_GROUP_NM"],"editFalse");
	dataProvider.removeRows(rows, false);
}

//대표 품목그룹코드 MAX 시컨스 조회
function fn_getReptItemGroupCodeMaxSeq() {
	var rtnSeq;
	gfn_service({
	    async   : false,
	    url     : GV_CONTEXT_PATH + "/biz/obj.do",
	    data    : {_mtd:"getList",tranData:[{outDs:"rtnSeq",_siq:"master.popup.reptItemGroupMgmtMaxSeq"}]},
	    success :function(data) {
	    	rtnSeq = data.rtnSeq[0].MAX_SEQ;
	    }
	}, "obj");
	return rtnSeq
}

//그리드 저장
function fn_save() {
	
	//수정된 그리드 데이터
	var grdData = gfn_getGrdSavedataAll(grdMain);
	if (grdData.length == 0) {
		alert('<spring:message code="msg.noChangeData"/>');
		return;
	}
	
	//그리드 유효성 검사
	var arrColumn = ["REP_ITEM_GROUP_CD","REP_ITEM_GROUP_NM"];
	if (!gfn_getValidation(gridInstance,arrColumn)) return;
	
	// 저장
	confirm('<spring:message code="msg.saveCfm"/>', function() {
		
		FORM_SAVE          = {}; //초기화
		FORM_SAVE._mtd     = "saveAll";
		FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"master.popup.reptItemGroupMgmt", grdData : grdData, custDupChkYn : {"delete":"Y"}}];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj.do",
			data   : FORM_SAVE,
			success: function(data) {
				if ( data.errCode == -10 ) {
					//alert(gfn_getDomainMsg("msg.dupData",data.errLine));
					alert('<spring:message code="msg.duplicateCheck"/>');
					grdMain.setCurrent({dataRow : data.errLine - 1, column : "REP_ITEM_GROUP_CD"});
				} else if ( data.errCode == -30 ) {
					//alert(gfn_getDomainMsg("msg.dataBeInUse",data.errLine));
					var lblReptItemGroup = '<spring:message code="lbl.reptItemGroup"/>';
					var lblItemGroup     = '<spring:message code="lbl.itemGroup"/>';
					alert(gfn_getDomainMsg("msg.activeCheck",lblReptItemGroup+"|"+lblItemGroup));
					grdMain.setCurrent({dataRow : data.errLine - 1, column : "REP_ITEM_GROUP_CD"});
				} else {
					alert('<spring:message code="msg.saveOk"/>');
					fn_apply();
					if (opener && opener.fn_popupSaveCallback) {
						opener.fn_popupSaveCallback();
					}
				}
			}
		}, "obj");
	});
}

</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit"><spring:message code="lbl.reptItemGroupMgmt"/></div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
					<div class="srhcondi">
						<ul>
							<li>
								<strong><spring:message code="lbl.reptItemGroup"/></strong>
								<div class="selectBox">
									<input type="text" id="reptItemGroup" name="reptItemGroup" value="" class="ipt">
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
				<a href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset"/></a>
				<a href="javascript:;" id="btnAdd" class="app1 roleWrite"><spring:message code="lbl.add"/></a>
				<a href="javascript:;" id="btnDelete" class="app1 roleWrite"><spring:message code="lbl.delete"/></a>
				<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save"/></a>
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>