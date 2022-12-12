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
	fn_init();
	fn_initGrid();
	fn_apply();
	fn_initEvent(); //이벤트 정의
});

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

function fn_init() {
}

//이벤트 정의
function fn_initEvent() {
	$("#btnReset").on("click", function() { fn_apply(); });
	$("#btnClose").on("click", function() { window.close(); });
	$("#btnSave").on("click", function() { fn_save(); });
}

//그리드를 그린다.
function fn_initGrid() {
	//변수처리
	gridInstance = new GRID();
	gridInstance.init("realgrid");
	grdMain = gridInstance.objGrid;
	dataProvider = gridInstance.objData;

    fn_setFields(dataProvider); //set fields
    fn_setColumns(grdMain); // set columns
    fn_setOptions(grdMain);
    fn_setGrdEvent(grdMain);
}

function fn_setOptions(grd) {
    grd.setOptions({
    	stateBar: { visible: true },
    	checkBar: { visible: true, showAll: true },
        edit    : { editable: false},
    });
}

function fn_setFields(provider) {
    var fields = [
        {fieldName: "COMPANY_CD"},
        {fieldName: "BU_CD"},
        {fieldName: "PART_CD"},
        {fieldName: "SCM_SCORE_ID"},
        {fieldName: "SCM_SCORE_NM"},
        {fieldName: "CHK_YN"},
        {fieldName: "CHK_YN_ORG"},
    ];
    provider.setFields(fields);
}

function fn_setColumns(grid) {
    var columns = [
        {name: "SCM_SCORE_ID" ,fieldName: "SCM_SCORE_ID" ,header: {text: '<spring:message code="lbl.scmScoreId2"/>'}, styles: {textAlignment: "near"}, width: 100 },
		{name: "SCM_SCORE_NM" ,fieldName: "SCM_SCORE_NM" ,header: {text: '<spring:message code="lbl.scmScoreNm"/>'}, styles: {textAlignment: "near"}, width: 200 },
    ];
    grid.setColumns(columns);
}

function fn_setGrdEvent(grd) {
	grd.onItemChecked = function (grid, itemIndex, checked) {
   		grid.setValue(itemIndex, "CHK_YN", checked ? "Y" : "N");
    };
}

function fn_apply() {
	var data = $("#searchForm").serializeObject();
	data._mtd = "getList";
	data.tranData = [{outDs:"rtnList",_siq:"master.master.scmScore"}];
	var sMap = {
		url: "${ctx}/biz/obj.do",
        data: data,
        success: function(data) {
        	grdMain.cancel();
        	var grdData = data.rtnList;
        	dataProvider.setRows(grdData);
        	dataProvider.clearSavePoints();
        	dataProvider.savePoint(); //초기화 포인트 저장
        	grdMain.resetCurrent();
        	
        	//체크처리
        	for (var i=0; i<dataProvider.getRowCount(); i++) {
				if (dataProvider.getValue(i, "CHK_YN_ORG") == "Y") {
					grdMain.checkRow(i,true,false);
				}
			}
        }
    }
	gfn_service(sMap, "obj");
}

//저장
function fn_save() {
	//수정된 그리드 데이터만 가져온다.
	var grdData = gfn_getGrdSavedataAll(grdMain);
	if (grdData.length == 0) {
		alert('<spring:message code="msg.noChangeData"/>');
		return;
	}
	
	confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
		//저장
		FORM_SAVE = {}; //초기화
		FORM_SAVE._mtd   = "saveAll";
		FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"master.master.scmScore", mergeFlag: "Y", grdData : grdData, custDupChkYn : {"insert":"Y"}}];
    	var sMap = {
            url: GV_CONTEXT_PATH + "/biz/obj.do",
            data: FORM_SAVE,
            success:function(data) {
            	if ( data.errCode == -20 ) {
            		alert(gfn_getDomainMsg("msg.dupData",data.errLine));
            		grdMain.setCurrent({dataRow : data.errLine - 1, column : "DATA_SCOPE_ID"});
            	} else {
	            	alert('<spring:message code="msg.saveOk"/>');
	            	fn_apply();
            	}
            }
        }
        gfn_service(sMap,"obj");
	});
}

</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit">${param.popupTitle}</div>
		<div class="popCont">
			<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
			<c:forEach var="item" items="${param}">
			<input type="hidden" id="${item.key}" name="${item.key}" value="${item.value}" />
			</c:forEach>
			</form>
			<div id="realgrid" class="realgrid1"></div>
			<div class="pop_btn">
				<a href="#" id="btnSave" class="pbtn pApply"><spring:message code="lbl.save"/></a>
				<a href="#" id="btnReset" class="pbtn pApply"><spring:message code="lbl.reset"/></a>
				<a href="#" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>		
	</div>

</body>
</html>