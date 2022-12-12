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
var arrChkData = [];
var chkData = [];
var chkKeyData = [];

$("document").ready(function (){
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
	searchCode = "${param.searchCode}";
	searchName = "${param.searchName}";

	if (gfn_isNull(searchCode) && !gfn_isNull(searchName)) {
		$("#EMP_NM").val(searchName);
	}
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

function fn_setData(returnData) {
	if("${param.callback}" != "" && "${param.callback}" != null) {
		//필터 키워드 팝업
		if ("${param.callback}" == "gfn_comPopupCallback") {
			eval("opener.${param.callback}")(returnData,"${param.objId}","EMP_ID","EMP_NM","ROW_KEY");
		} else {
			eval("opener.${param.callback}")(returnData,"${param.rowId}");
		}
	}
	window.close();
}

function fn_apply() {
	var rows = grdMain.getCheckedRows(true);
	gfn_clearArrayObject(arrChkData);
	gfn_clearArrayObject(chkKeyData);
	gfn_clearArrayObject(chkData);
	$.each(rows, function(n,v) {
		chkKeyData.push(dataProvider.getValue(v,"DEPT_ID")+dataProvider.getValue(v,"EMP_ID"));
		chkData.push(dataProvider.getValue(v,"DEPT_ID")+dataProvider.getValue(v,"EMP_ID"));
		arrChkData.push(dataProvider.getJsonRow(v));
	});
	
	var data = $("#searchForm").serializeObject();
	data.CHK_DATA  = chkKeyData.toString();
	data.INIT_DATA = searchCode;
	fn_getGridData(data);
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

    grdMain.onItemChecked = function (grid, itemIndex, checked) {
    	if("${param.singleYn}"=="Y") {
    		var items = grdMain.getCheckedItems();
    		if(items.length>1) {
    			grdMain.checkAll(false);
    			grdMain.checkRow(itemIndex, true);
    		}
    	}
    };

    grdMain.onDataCellDblClicked =  function (grid, index) {
   	  	var returnData = [];
   	 	returnData.push(dataProvider.getJsonRow(index.dataRow));
   	 	fn_setData(returnData);
   	};
}

function fn_setOptions(grd) {
	var showAll = true;
	if("${param.singleYn}"=="Y") {
		showAll = false;
	}

    grd.setOptions({
        checkBar: { visible: true, showAll:showAll },
        edit    : { insertable: false, appendable: false, updatable: false, editable: false, deletable: false},
    });
}

function fn_setFields(provider) {
	//필드 배열 객체를  생성합니다.
    var fields = [
        {fieldName: "DEPT_ID"},
        {fieldName: "DEPT_NM"},
        {fieldName: "SALES_TEAM_NM"},
        {fieldName: "EMP_ID"},
        {fieldName: "EMP_NM"},
        {fieldName: "ROW_KEY"}
    ];
    //DataProvider의 setFields함수로 필드를 입력합니다.
    dataProvider.setFields(fields);
}

function fn_setColumns(tree) {
	//필드와 연결된 컬럼 배열 객체를 생성합니다.
    var columns = [
        {name: "DEPT_NM"      , fieldName: "DEPT_NM"       , header: {text: '<spring:message code="lbl.hRTeamName"/>'      } ,styles: {textAlignment: "near"}, width: 100},
        {name: "SALES_TEAM_NM", fieldName: "SALES_TEAM_NM" , header: {text: '<spring:message code="lbl.teamName"/>'        } ,styles: {textAlignment: "near"}, width: 100},
		{name: "EMP_ID"       , fieldName: "EMP_ID"        , header: {text: '<spring:message code="lbl.salesPerson"/>'     } ,styles: {textAlignment: "near"}, width: 80 },
		{name: "EMP_NM"       , fieldName: "EMP_NM"        , header: {text: '<spring:message code="lbl.salesPersonName"/>' } ,styles: {textAlignment: "near"}, width: 242}
    ];
    //컬럼을 GridView에 입력 합니다.김
    grdMain.setColumns(columns);
}

var fn_gridCallback = function(data) {
	grdMain.cancel();
	var grdData = data.rtnList;
	dataProvider.setRows($.merge(arrChkData, grdData));
	searchCode = chkKeyData.toString() || searchCode;
	dataProvider.clearSavePoints();
	dataProvider.savePoint(); //초기화 포인트 저장
	gfn_unblockUI();

	//코드가 있는경우 체크
	if(!gfn_isNull(searchCode)) {
		var arrCode = searchCode.split(",");
		$.each(arrCode, function(n,v) {
			for (var i=0; i<dataProvider.getRowCount(); i++) {
				if (dataProvider.getValue(i, "ROW_KEY") == v) {
					grdMain.checkRow(i,true,false);
					break;
				}
			}
		});
	}
};

//그리드 데이터 조회
function fn_getGridData(data) {
	var sMap = {
        url: "${ctx}/common/salesPersonList.do",
        data: data,
        success:fn_gridCallback,
    }

	gfn_blockUI();
	gfn_service(sMap);
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
				<input type="hidden" id="masterYn" name="masterYn" value="${param.masterYn}"/>
				<div class="srhcondi">
				<ul>
					<li>
					<strong>Emp Nm.</strong>
					<div class="selectBox">
					<input type="text" id="EMP_NM" name="EMP_NM" value="${param.EMP_NM}" class="ipt">
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