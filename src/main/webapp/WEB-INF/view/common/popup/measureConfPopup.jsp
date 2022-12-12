<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
//전역변수 설정
var popupWidth, popupHeight;
var gridInstanceSub, grdSub, dataProviderSub;
var lvMenuCd;

$("document").ready(function () {
	gfn_popresize();
	fn_init();
	fn_initGrid();
	fn_initEvent(); //이벤트 정의
});

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

function fn_init() {
	lvMenuCd = "${param.P_MENU_CD}";
}

//이벤트 정의
function fn_initEvent() {
	fn_apply();
	$("#moveUp").click("on", function() { fn_moveSort("U"); });
	$("#moveDown").click("on", function() { fn_moveSort("D"); });
	$("#moveFirst").click("on", function() { fn_moveSort("F"); });
	$("#moveLast").click("on", function() { fn_moveSort("L"); });
	$("#btnReset").click("on", function() { fn_apply(); });
	$("#btnSave").click("on", function() { fn_save(); });
	$("#btnClose").on("click", function() { window.close(); });
}

function fn_apply(sqlFlag) {
	//조회조건 설정
	FORM_SEARCH = {}; //초기화
	FORM_SEARCH.sql = sqlFlag;
	FORM_SEARCH.SEARCH_MENU_CD = lvMenuCd;
	FORM_SEARCH.menuCd = lvMenuCd;
	fn_getGridData();
}

//그리드를 그린다.
function fn_initGrid() {
	gridInstanceSub = new GRID();
	gridInstanceSub.init("realgridSub");
	grdSub = gridInstanceSub.objGrid;
	dataProviderSub = gridInstanceSub.objData;
	
	fn_setFields(dataProviderSub); //set fields
    fn_setColumns(grdSub); // set columns
    fn_setOptions(grdSub); // set options
    
    //헤더체크
   	grdSub.onColumnCheckedChanged = function (grid, column, checked) {
   		var checkedVal = checked ? "Y":"N";
   		dataProviderSub.beginUpdate();
    	for (var i=0; i<dataProviderSub.getRowCount(); i++) {
    		if (dataProviderSub.getValue(i, "MAND_FLAG") == "Y") continue;
    		dataProviderSub.setValue(i, column.name, checkedVal);
    	}
    	dataProviderSub.endUpdate();
   	};
}

function fn_setOptions(grd,grdType) {
	var options = {
        checkBar: { visible: false },
     stateBar: { visible: true },
     edit    : { editable: true},
     //hideDeletedRows : true
    };
  	grd.setOptions(options);
  	dataProviderSub.setOptions({softDeleting: false});
  	
    //renderer 처리
    fn_setRenderers(grd);
}

function fn_setFields(provider,grdType) {
	//필드 배열 객체를  생성합니다.
	var fields = [
		{fieldName: "COMPANY_CD"},
		{fieldName: "BU_CD"},
		{fieldName: "USER_ID"},
		{fieldName: "MENU_CD"},
		{fieldName: "MEAS_CD"},
		{fieldName: "MEAS_NM"},
		{fieldName: "SORT"},
		{fieldName: "MAND_FLAG"},
		{fieldName: "DEFAULT_FLAG"},
		{fieldName: "USER_USE_FLAG"},
    ];
	provider.setFields(fields); //DataProvider의 setFields함수로 필드를 입력합니다.
}

function fn_setColumns(grd,grdType) {
	//필드와 연결된 컬럼 배열 객체를 생성합니다.
	var columns;
		columns = [
            {
                name: "MEAS_CD",
                fieldName: "MEAS_CD",
                header: {text: '<spring:message code="lbl.measure"/>'},
                styles: {textAlignment: "near",background: gv_noneEditColor},
                width: 100,
                editable: false,
            },
            {
            	name: "MEAS_NM",
                fieldName: "MEAS_NM",
                header: {text: '<spring:message code="lbl.measureName"/>'},
                styles: {textAlignment: "near",background: gv_noneEditColor},
                width: 100,
                editable: false,
            },
            {
                name: "MAND_FLAG",
                fieldName: "MAND_FLAG",
                header: {text: '<spring:message code="lbl.required"/>'},
                styles: {textAlignment: "near",background: gv_noneEditColor},
                width: 60,
                editable: false,
                renderer : gfn_getRenderer("CHECK",{editable:false})
            },
            {
                name: "USER_USE_FLAG",
                fieldName: "USER_USE_FLAG",
                header: {text: '<spring:message code="lbl.useYn"/>',checkLocation: "left"},
                styles: {textAlignment: "near",background: gv_editColor},
                width: 80,
                editable: false,
                dynamicStyles: [{
                    criteria: ["values['MAND_FLAG']<>'Y'","values['MAND_FLAG']='Y'"],
                    styles: ["renderer=check1","renderer=check2"]
                }],
            },
        ];
    grd.setColumns(columns); //컬럼을 GridView에 입력 합니다.
}

function fn_setRenderers(grid) {
    grid.addCellRenderers([{
        id: "check1",
       	type: "check",
        shape: "box",
        editable: true,
        startEditOnClick: true,
        trueValues: "Y",
        falseValues: "N"
    },{
        id: "check2",
       	type: "check",
        shape: "box",
        editable: false,
        startEditOnClick: true,
        trueValues: "Y",
        falseValues: "N"
    }]);
}

//그리드 데이터 조회
function fn_getGridData() {
	FORM_SEARCH._mtd = "getList";
	FORM_SEARCH.tranData = [{outDs:"meaConfList",_siq:"common.meaConf"}];
	
	var sMap = {
		url: "${ctx}/biz/obj.do",
        data: FORM_SEARCH,
        success:function(data) {
			grdSub.cancel();
			dataProviderSub.setRows(data.meaConfList);
        }
    }
    gfn_service(sMap,"obj");
}

//저장
function fn_save() {
	
	//순서변경
	for (var i=0; i<dataProviderSub.getRowCount(); i++) {
		dataProviderSub.setValue(i,"SORT",i+1);
		dataProviderSub.setRowState(i, "updated", false);
	}
	
	//수정된 그리드 데이터만 가져온다.
	var grdData = gfn_getGrdSavedataAll(grdSub);
	if (grdData.length == 0) {
		//부모창 조회실행
		if(lvMenuCd == "DP216" || lvMenuCd == "DP217"){
			opener.fn_popCallback(grdData, "call");
		}else{
			opener.fn_apply();	
		}
    	self.close();
	}
	
	//그리드 유효성 검사
	var arrColumn = ["MEAS_CD","MEAS_NM"];
	if (!gfn_getValidation(gridInstanceSub,arrColumn)) return;
	
	//confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
		//저장
   		FORM_SAVE = {}; //초기화
   		FORM_SAVE._mtd   = "saveAll";
   		FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"common.meaConf",mergeFlag:"Y", grdData : grdData}];
		var serviceMap = {
			url: "${ctx}/biz/obj.do",
            data: FORM_SAVE,
            success:function(data) {
            	
            	if(lvMenuCd == "DP216" || lvMenuCd == "DP217"){
					opener.fn_popCallback(grdData, "call");
            	}else{
            		opener.fn_apply();	
            	}
            	window.close();
            }
        }
		gfn_service(serviceMap, "obj");
	//}); 
}

function fn_moveSort(type) {
	var index = grdSub.getCurrent();
	var toIdx = -1;
	if (type == "U" && index.dataRow > 0) {
		toIdx = index.dataRow-1;
	} else if (type == "D" && index.dataRow < dataProviderSub.getRowCount()-1) {
		toIdx = index.dataRow+1;
	} else if (type == "F" && index.dataRow > 0) {
		toIdx = 0;
	} else if (type == "L" && index.dataRow < dataProviderSub.getRowCount()-1) {
		toIdx = dataProviderSub.getRowCount()-1;
	} 
	
	if (toIdx != -1) {
		dataProviderSub.moveRow(index.dataRow,toIdx);
		grdSub.setCurrent({dataRow : toIdx});
		//커서이동
		grdSub.setCurrent({dataRow : toIdx});
	}
}

</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div class="popupDv">
		<div class="pop_tit">${param.popupTitle}</div>
		<div class="popCont">
			<div class="topbtn" style="float:right;margin-bottom:5px">
				<a href="#" id="moveUp"><img src="${ctx}/statics/images/common/pop_st1.gif" alt=""></a>
				<a href="#" id="moveDown"><img src="${ctx}/statics/images/common/pop_st2.gif" alt=""></a>
				<a href="#" id="moveFirst"><img src="${ctx}/statics/images/common/pop_st4.gif" alt=""></a>
				<a href="#" id="moveLast"><img src="${ctx}/statics/images/common/pop_st3.gif" alt=""></a>
			</div>
			<br>
			<div id="realgridSub" class="realgrid1"></div>

			<div class="pop_btn">
				<a href="#" id="btnReset" class="pbtn pApply"><spring:message code="lbl.reset"/></a>
				<a href="#" id="btnSave" class="pbtn pApply"><spring:message code="lbl.apply"/></a>
				<a href="#" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>