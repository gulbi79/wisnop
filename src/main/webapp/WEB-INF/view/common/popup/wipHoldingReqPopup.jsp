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
var codeMapEx;
var itemType;
var itemTypeDisabled;
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
	itemType   = "${param.item_type}";
	itemTypeDisabled   = "${param.item_type_disabled}";
	searchCode = "${param.searchCode}";
	searchName = "${param.searchName}";
	
	if (gfn_isNull(searchCode) && !gfn_isNull(searchName)) {
		$("#ITEM_NM").val(searchName);
	}

	//하이라키 정보 설정
	gfn_getCurWindow().gfn_getHrcyChecked(gfn_getCurWindow().gv_zTreeObj.product,"product",null,searchTreeArr);
	
	var grpCd = "ITEM_TYPE,PROCUR_TYPE";
	codeMap = gfn_getComCode(grpCd); //공통코드 조회
	codeMapEx = gfn_getComCodeEx([ "ROUTING" ], null, {itemType : "10,50"});
	
	
	if ($("#POP_TYPE").val() == "COM_ITEM_PLAN") {
		codeMap.ITEM_TYPE = $.grep(codeMap.ITEM_TYPE, function (v) {
			if (v.ATTB_2_CD == "Y") return true;
			return false;
		});
	}
	
	
	gfn_setMsCombo("ITEM_TYPE", codeMap.ITEM_TYPE, [], {width:"122px"});
	gfn_setMsCombo("PROCUR_TYPE", codeMap.PROCUR_TYPE, [], {width:"122px"});
	gfn_setMsCombo("ROUTING", codeMapEx.ROUTING, [], {width:"122px"});
	
	if (!gfn_isNull(itemType)) {
		var aItemType = itemType.split(",");
		$("#ITEM_TYPE").multipleSelect("setSelects", aItemType);
		
		if (!gfn_isNull(itemTypeDisabled)) {
			$("#ITEM_TYPE").multipleSelect(itemTypeDisabled);
		}
		
	}
}

//이벤트 정의
function fn_initEvent() {
	$("#btnSearch").click("on", function() { fn_apply(); });
	$("#btnClose").on("click", function() { window.close(); });
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
			eval("opener.${param.callback}")(returnData,"${param.objId}","ITEM_CD","ITEM_CD");
		} else {
			eval("opener.${param.callback}")(returnData,"${param.rowId}");
		}
	}
	window.close();
}

function fn_apply() {
	var rows = grdMain.getCheckedRows(true);
	gfn_clearArrayObject(arrChkData);
	gfn_clearArrayObject(chkData);
	$.each(rows, function(n,v) {
		chkData.push(dataProvider.getValue(v,"ITEM_CD"));
		arrChkData.push(dataProvider.getJsonRow(v));
	});
	
	var data = $("#searchForm").serializeObject();
	data.CHK_DATA  = chkData.toString();
	data.INIT_DATA = searchCode;
	data.productList = searchTreeArr;
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
        {fieldName: "PROD_ORDER_NO"},
        {fieldName: "ORDER_STATUS_NM"},
        {fieldName: "ITEM_CD"},
        {fieldName: "ITEM_NM"},
        {fieldName: "SPEC"},
        {fieldName: "ROUTING_ID"},
        {fieldName: "UPPER_ITEM_GROUP_NM"},
        {fieldName: "ITEM_GROUP_NM"},
        {fieldName: "ITEM_GRADE"},
        {fieldName: "REP_CUST_GROUP_NM"},
        {fieldName: "CUST_GROUP_NM"},
        {fieldName: "PROD_ORDER_QTY"},
        {fieldName: "REMAIN_QTY"},
    ];
    provider.setFields(fields);
}

function fn_setColumns(grid) {
    var columns = [
		{name: "PROD_ORDER_NO"		,fieldName: "PROD_ORDER_NO"		,header: {text: '<spring:message code="lbl.prodOrderNo"/>'			} ,styles: {textAlignment: "near"  } ,width: 80 },
		{name: "ORDER_STATUS_NM"		,fieldName: "ORDER_STATUS_NM"		,header: {text: '<spring:message code="lbl.orderStatus"/>'			} ,styles: {textAlignment: "near"  } ,width: 80 },
		{name: "ITEM_CD"		,fieldName: "ITEM_CD"		,header: {text: '<spring:message code="lbl.item"/>'		} ,styles: {textAlignment: "near"  } ,width: 120 },
		{name: "ITEM_NM"			,fieldName: "ITEM_NM"			,header: {text: '<spring:message code="lbl.itemName"/>'			} ,styles: {textAlignment: "near"  } ,width: 120 },
		{name: "SPEC"	,fieldName: "SPEC"	,header: {text: '<spring:message code="lbl.spec"/>'		} ,styles: {textAlignment: "near"  } ,width: 50  },
		{name: "ROUTING_ID"		,fieldName: "ROUTING_ID"		,header: {text: '<spring:message code="lbl.routing"/>'		} ,styles: {textAlignment: "near"  } ,width: 120 },
		{name: "UPPER_ITEM_GROUP_NM"	,fieldName: "UPPER_ITEM_GROUP_NM"	,header: {text: '<spring:message code="lbl.upperItemGroup"/>'} ,styles: {textAlignment: "near"  } ,width: 120 },
		{name: "ITEM_GROUP_NM"	,fieldName: "ITEM_GROUP_NM"	,header: {text: '<spring:message code="lbl.itemGroupName"/>'} ,styles: {textAlignment: "near"  } ,width: 100 },
		{name: "ITEM_GRADE"			,fieldName: "ITEM_GRADE"			,header: {text: '<spring:message code="lbl.itemGrade"/>'			} ,styles: {textAlignment: "near"  } ,width: 120 },
		{name: "REP_CUST_GROUP_NM"	,fieldName: "REP_CUST_GROUP_NM"	,header: {text: '<spring:message code="lbl.repCustGroupN"/>'		} ,styles: {textAlignment: "near"  } ,width: 50  },
		{name: "CUST_GROUP_NM"		,fieldName: "CUST_GROUP_NM"		,header: {text: '<spring:message code="lbl.custGroupName"/>'		} ,styles: {textAlignment: "near"  } ,width: 120 },
		{name: "PROD_ORDER_QTY"	,fieldName: "PROD_ORDER_QTY"	,header: {text: '<spring:message code="lbl.prodOrderQty3"/>'} ,styles: {textAlignment: "near"  } ,width: 120 },
		{name: "REMAIN_QTY"	,fieldName: "REMAIN_QTY"	,header: {text: '<spring:message code="lbl.remainQty2"/>'} ,styles: {textAlignment: "near"  } ,width: 100 },
    ];
    grid.setColumns(columns);
}

var fn_gridCallback = function(data) {
	grdMain.cancel();
	var grdData = data.rtnList;
	dataProvider.setRows($.merge(arrChkData, grdData));
	searchCode = chkData.toString() || searchCode;
	dataProvider.clearSavePoints();
	dataProvider.savePoint(); //초기화 포인트 저장
	gfn_unblockUI();

	//코드가 있는경우 체크
	if(!gfn_isNull(searchCode)) {
		var arrCode = searchCode.split(",");
		$.each(arrCode, function(n,v) {
			for (var i=0; i<dataProvider.getRowCount(); i++) {
				if (grdMain.getValue(i, "ITEM_CD") == v) {
					grdMain.checkRow(i, true, false);
					break;
				}
			}
		});
	}
	
	grdMain.resetCurrent();
};

//그리드 데이터 조회
function fn_getGridData(data) {
	data._mtd = "getList";
	data.tranData = [{outDs : "rtnList", _siq : "common.wipHoldingReqPopup"}];
	var sMap = {
		url: "${ctx}/biz/obj",
        data: data,
        success:fn_gridCallback,
    }

	gfn_service(sMap, "obj");
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
				<input type="hidden" id="POP_TYPE" name="POP_TYPE" value="${param.popType}">
				<div class="srhcondi">
				<c:set var="lvWidth" value="115px" />
				<ul>
					<li>
					<strong class="srhcondipop"><spring:message code="lbl.item"/></strong>
					<div class="selectBox">
					<input type="text" id="ITEM_NM" name="ITEM_NM" value="" class="ipt" style="width:${lvWidth};">
					</div>
					</li>
					<li>
					<strong class="srhcondipop"><spring:message code="lbl.prodOrderNo3"/></strong>
					<div class="selectBox">
					<input type="text" id="PROD_ORDER_NO" name="PROD_ORDER_NO" value="" class="ipt" style="width:${lvWidth};">
					</div>
					</li>
					<%-- <li>
					<strong class="srhcondipop"><spring:message code="lbl.itemGroup"/></strong>
					<div class="selectBox">
					<input type="text" id="ITEM_GROUP_CD" name="ITEM_GROUP_CD" value="" class="ipt" style="width:${lvWidth};">
					</div>
					</li> --%>
				</ul>
				<ul>
					<li>
					<strong class="srhcondipop"><spring:message code="lbl.procureType"/></strong>
					<div class="selectBox">
					<select id="PROCUR_TYPE" name="PROCUR_TYPE" multiple="multiple"></select>
					<%-- <input type="text" id="SPEC" name="SPEC" value="" class="ipt" style="width:${lvWidth};"> --%>
					</div>
					</li>
					<li>
					<strong class="srhcondipop"><spring:message code="lbl.routing"/></strong>
					<div class="selectBox">
					<select id="ROUTING" name="ROUTING" multiple="multiple"></select>
					<%-- <input type="text" id="DRAW_NO" name="DRAW_NO" value="" class="ipt" style="width:${lvWidth};"> --%>
					</div>
					</li>
					<%-- <li>
					<strong class="srhcondipop"><spring:message code="lbl.custGroup"/></strong>
					<div class="selectBox">
					<input type="text" id="CUST_GROUP_CD" name="CUST_GROUP_CD" value="" class="ipt" style="width:${lvWidth};">
					</div>
					</li> --%>
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