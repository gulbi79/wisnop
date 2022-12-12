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
var fileNo;
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
	$("#btnClose").on("click", function() { window.close(); });
	$("#btnSave").click(fn_save);
	$("#btnAdd").click(fn_add);
	$("#btnDel").click(fn_del);
}

function fn_apply() {
	fn_getGridData();
}

function fn_add() {
	dataProvider.addRow([]);
}

function fn_del() {
	var rows = grdMain.getCheckedRows();
	dataProvider.removeRows(rows);
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
    
  	//row 상태에따른 컬럼 속성정의
    grdMain.onCurrentRowChanged = function (grid, oldRow, newRow) {
   		var editable = (newRow < 0 || dataProvider.getRowState(newRow) === "created");
   		grid.setColumnProperty("REMARK","editable",editable);
   	};
}

function fn_setOptions(grd) {
    grd.setOptions({
        checkBar: { visible: true, showAll:true },
        stateBar: { visible: true },
        sorting : { enabled: false},
        edit    : { insertable: true, appendable: true, updatable: true, editable: true, deletable: true},
    });
}

function fn_setFields(provider) {
	//필드 배열 객체를  생성합니다.
    var fields = [
        {fieldName: "COMPANY_CD"},
        {fieldName: "ISSUE_ID"},
        {fieldName: "REMARK_SEQ"},
        {fieldName: "REMARK"},
        {fieldName: "CREATE_DTTM"},
    ];
    dataProvider.setFields(fields);
}

function fn_setColumns(tree) {
	//필드와 연결된 컬럼 배열 객체를 생성합니다.
    var columns = [
        {name: "REMARK"      ,fieldName: "REMARK"      ,header: {text: '<spring:message code="lbl.remark"/>'    }, styles: {textAlignment: "near"}, width: 250, editable : true },
		{name: "CREATE_DTTM" ,fieldName: "CREATE_DTTM" ,header: {text: '<spring:message code="lbl.createDttm"/>'}, styles: {textAlignment: "near"}, width: 120, editable : false },
    ];
    grdMain.setColumns(columns);
}

//그리드 데이터 조회
function fn_getGridData() {
	FORM_SEARCH = $("#frm").serializeObject(); //초기화
	FORM_SEARCH._mtd = "getList";
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"snop.meetingMng.remark"}];
	var sMap = {
        url: "${ctx}/biz/obj.do",
        data: FORM_SEARCH,
        success:function(data) {
        	dataProvider.clearRows(); //데이터 초기화
        	
	    	//그리드 데이터 생성
	    	grdMain.cancel();
			var grdData = data.rtnList;
			dataProvider.setRows(grdData);
        }
    }
    gfn_service(sMap,"obj");
}

//저장
function fn_save() {
	
	//수정된 그리드 데이터만 가져온다.
	var grdData = gfn_getGrdSavedataAll(grdMain);
	if (grdData.length == 0) {
		alert('<spring:message code="msg.noChangeData"/>');
		return;
	}
	
	//그리드 유효성 검사
	var arrColumn = ["REMARK"];
	if (!gfn_getValidation(gridInstance,arrColumn)) return;
	
	confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
			
		//저장
		FORM_SAVE = {}; //초기화
		FORM_SAVE = $("#frm").serializeObject(); //초기화
		FORM_SAVE._mtd   = "saveAll";
		FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"snop.meetingMng.remark", grdData : grdData}];
    	var sMap = {
            url: GV_CONTEXT_PATH + "/biz/obj.do",
            data: FORM_SAVE,
            success:function(data) {
            	alert('<spring:message code="msg.saveOk"/>', function() {
	            	fn_apply();
	            	eval("opener.${param.callback}")();
            	});
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
			<div id="realgrid" class="realgrid1"></div>
			<div class="pop_btn">
				<a href="#" id="btnDel" class="pbtn pApply"><spring:message code="lbl.delete"/></a>
				<a href="#" id="btnAdd" class="pbtn pApply"><spring:message code="lbl.add"/></a>
				<a href="#" id="btnSave" class="pbtn pApply"><spring:message code="lbl.save"/></a>
				<a href="#" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>		
	</div>
	<form id="frm" method="post">
		<c:forEach var="item" items="${param}">
		<input type="hidden" id="${item.key}" name="${item.key}" value="${item.value}" />
		</c:forEach>
	</form>
</body>
</html>