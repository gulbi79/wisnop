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

$("document").ready(function () {
	gfn_popresize();
	fn_init();
	fn_initGrid();
	fn_setGridEvent();
	fn_showError();
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
}

//그리드를 그린다.
function fn_initGrid() {
	//변수처리
	gridInstance = new GRID();
	gridInstance.init("realgrid");
	grdMain = gridInstance.objGrid;
	dataProvider = gridInstance.objData;

	var fields = [];
	var columns = [];

	//라인
	fields[fields.length] = { fieldName : "LINE", dataType : "number" };
	columns[columns.length] = {  
			name : "LINE",
            fieldName : "LINE",
            editor : { type : "none" },
            header : { text : "Error Line" },
            styles : { textAlignment: "far", background : gv_noneEditColor, numberFormat: "#,##0"},
            width : 60 
  	};
	
	//에러 메세지
	fields[fields.length] = { fieldName : "ERROR_MSG", dataType : "text" };
	columns[columns.length] = {  
			name : "ERROR_MSG",
            fieldName : "ERROR_MSG",
            editor : { type : "none" },
            header : { text : "Error Columns" },
            styles : { textAlignment: "near", background : gv_noneEditColor},
            width : 300 
  	};

	//그리드 컬럼
	var columnNames = opener.gErrorGrid.getColumnNames(true);
	for ( var i = 0; i < columnNames.length; i++ ) {
		fields[fields.length] = { fieldName : columnNames[i], dataType : "text" };
		
		var header = opener.gErrorGrid.getColumnProperty(columnNames[i], "header")
		columns[columns.length] = {  
				name : columnNames[i],
                fieldName : columnNames[i],
                editor : { type : "none" },
                header : { text : header.text },
                styles : { textAlignment: "near", background : gv_noneEditColor},
                width : 80 
      	};
	}
	
	dataProvider.setFields(fields);
	grdMain.setColumns(columns);

	grdMain.setOptions({
        checkBar: { visible: false },
        stateBar: { visible: false },
        edit    : { insertable: true, appendable: true, updatable: true, editable: true, deletable: true},
        hideDeletedRows : false
    });
    dataProvider.setOptions({
    	softDeleting:true 
    });
}

function fn_setGridEvent() {
	grdMain.onDataCellDblClicked =  function (grid, index) {
		opener.gErrorGrid.setCurrent(
				{
					itemIndex : parseInt(grdMain.getValue(index.itemIndex, "LINE")) - 1
					,fieldName : opener.gErrorGrid.getColumnNames()[0]
				}
		);
	};
}

function fn_showError() {
	var lines = opener.gErrorLine.split(",");
	var Msgs = opener.gErrorMsg.split(",");
	for ( var i = 0; i < lines.length; i++ ) {
		var row = opener.gErrorGrid.getValues(parseInt(lines[i]) -1);
		row.LINE = lines[i];
		row.ERROR_MSG = Msgs[i].replace(/[|]/gi, ",");
		
		dataProvider.addRow(row);
	}
}
</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit">Error Popup</div>
		<div class="popCont">
			<div id="realgrid" class="realgrid1"></div>
			<div class="pop_btn">
				<a href="#" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>		
	</div>
</body>
</html>