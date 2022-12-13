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
var codeMap, codeMapEx;
var popUpMenuCd = "${param.menuCd}";
var lv_conFirmFlag = true;
$("document").ready(function () {
	gfn_popresize();
	fn_init();
	fn_initGrid();
	fn_initEvent(); //이벤트 정의
	fn_excelSqlAuth();
	
	
	$(".viewfnc5").click("on", function() {
		gfn_doExportExcel({fileNm:"${menuInfo.menuNm}", conFirmFlag: lv_conFirmFlag}); 
		$(".pClose").click(function() {
			$("#divTempLayerPopup").hide();
			$(".back").hide();
		});
	    $(".popClose").click(function() {
	    	$("#divTempLayerPopup").hide();
			$(".back").hide();
		});
	    $(".back").click(function() {
			$(".popup2").hide();
			$(".back").hide();
		});
	});
	
	$(".viewfnc4").click("on", function() {
		fn_apply(true);
		
		$(document).on("click",".popup2 .popClose, .popup2 .pClose",function() {
			$(".popup2").hide();
			$(".back").hide();
		});
		
		$(".back").click(function() {
			$(".popup2").hide();
			$(".back").hide();
		});
	    
	})
	
	
});

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

function fn_init() {
	FORM_SEARCH = {};
	DATEPICKET(null, $("#fromDate").val(), $("#toDate").val());
	
	var grpCd = "";
	codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
	codeMapEx = gfn_getComCodeEx(["ROUTING", "RESOURCE_GROUP_CD"], null, {itemType : ""});
	
	gfn_setMsCombo("routing", codeMapEx.ROUTING, ["*"], {width:"122px"});
	gfn_setMsCombo("facilityGroup", codeMapEx.RESOURCE_GROUP_CD, ["*"], {width:"160px"});
}

//이벤트 정의
function fn_initEvent() {
	
	$("#btnSearch").click("on", function() { 
		fn_apply(); 
	});
	
	$("#btnClose").on("click", function() { 
		window.close(); 
	});
	
	/* $("#btnApply").on("click", function() {
		var rows = grdMain.getCheckedRows(true);
		var returnData = [];
		$.each(rows, function(n,v) {
			returnData.push(dataProvider.getJsonRow(v));
		});
		fn_setData(returnData); 
	}); */
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
	//grd.setSelectOptions({style: "rows"});
}

function fn_setFields(provider) {
	var fields = [
        {fieldName : "ROUTING_ID"},
        {fieldName : "RESOURCE_GROUP_NM"},
        {fieldName : "RESOURCE_CD"},
        {fieldName : "RESOURCE_NM"},
        {fieldName : "YYYYMMDD"},
        {fieldName : "CONS_TIME"}
    ];
    provider.setFields(fields);
}

function fn_setColumns(grd) {
	//var totAr =  ['ITEM_CD', 'ITEM_NM', 'SPEC', 'ITEM_GROUP_CD', 'ROUTING_ID', 'PROD_PART_NM', 'CUST_NM', 'WORKER_GROUP_NM', 'PROD_ORDER_NO', 'ORDER_STATUS_NM', 'PROD_ORDER_QTY', 'REMAIN_QTY'];
	var columns = 
	[
		{ 
			name : "ROUTING_ID", fieldName : "ROUTING_ID", editable : false, header: {text: '<spring:message code="lbl.routing" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
			width : 100,
			dynamicStyles:[gfn_getDynamicStyle(0)],
		}, {
			name : "RESOURCE_GROUP_NM", fieldName : "RESOURCE_GROUP_NM", editable : false, header: {text: '<spring:message code="lbl.facilityGroup" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
			width : 100,
			dynamicStyles:[gfn_getDynamicStyle(0)],
		}, {
			name : "RESOURCE_CD", fieldName : "RESOURCE_CD", editable : false, header: {text: '<spring:message code="lbl.facilityCode" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
			width : 100,
			dynamicStyles:[gfn_getDynamicStyle(0)],
		}, {
			name : "RESOURCE_NM", fieldName : "RESOURCE_NM", editable : false, header: {text: '<spring:message code="lbl.facilityName" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
			width : 100,
			dynamicStyles:[gfn_getDynamicStyle(0)],
		}, {
			name : "YYYYMMDD", fieldName : "YYYYMMDD", editable : false, header: {text: '<spring:message code="lbl.workDate" javaScriptEscape="true" />'},
			styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
			width : 100,
			dynamicStyles:[gfn_getDynamicStyle(0)],
		}, {
			name : "CONS_TIME", fieldName : "CONS_TIME", editable : false, header: {text: '<spring:message code="lbl.workTime" javaScriptEscape="true" />'},
			styles : {textAlignment: "far", background : gfn_getArrDimColor(0)},
			width : 80,
			dynamicStyles:[gfn_getDynamicStyle(0)],
		}
	];
	
	grd.setColumns(columns); 
}

function fn_apply(sqlFlag) {
	
	/* var rows = grdMain.getCheckedRows(true);
	gfn_clearArrayObject(arrChkData);
	gfn_clearArrayObject(chkData);
	$.each(rows, function(n,v) {
		chkData.push(dataProvider.getValue(v, "ITEM_CD"));
		arrChkData.push(dataProvider.getJsonRow(v));
	});
	 */
	 
	FORM_SEARCH = $("#searchForm").serializeObject();
	fn_getGridData(sqlFlag);
}

//그리드 데이터 조회
function fn_getGridData(sqlFlag) {
	
	FORM_SEARCH._mtd = "getList";
	FORM_SEARCH.sql  = sqlFlag;
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"supply.product.equiTrendDetailList"}];
	
	var sMap = {
		url : "${ctx}/biz/obj",
        data : FORM_SEARCH,
        success :function(data) {
			
			//그리드 데이터 삭제
			dataProvider.clearRows();
			grdMain.cancel();
			//그리드 데이터 생성
			dataProvider.setRows(data.rtnList);
		}
    }

	gfn_service(sMap, "obj");
}

/* var fn_gridCallback = function(data) {
	
	grdMain.cancel();
	var grdData = data.rtnList;
	dataProvider.setRows($.merge(arrChkData, grdData));
	searchCode = chkData.toString() || searchCode;
	dataProvider.clearSavePoints();
	dataProvider.savePoint(); //초기화 포인트 저장
	gfn_unblockUI();

	var temp = $("#itemMappingData").val();
	//코드가 있는경우 체크
	if(!gfn_isNull(temp)) {
		var arrCode = temp.split(",");
		$.each(arrCode, function(n, v) {
			for (var i = 0; i < dataProvider.getRowCount(); i++) {
				if (grdMain.getValue(i, "ITEM_CD") == v) {
					grdMain.checkRow(i, true, false);
					break;
				}
			}
		});
	}
	grdMain.resetCurrent();
}; */

/* function fn_setData(returnData) {
	eval("opener.${param.callback}")(returnData);
	window.close();
} */

//엑셀, 쿼리 다운로드 권한 확인
function fn_excelSqlAuth() {
	
	gfn_service({
	    async   : false,
	    url     : GV_CONTEXT_PATH + "/biz/obj",
	    data    : {
   			_mtd : "getList",
   			popUpMenuCd : popUpMenuCd,
   			tranData : [
   				{outDs : "authorityList", _siq : "supply.product.equiTrendDetailListExcelSql"}
   			]
	    },
	    success :function(data) {
	    	
	    	for(i=0;i<data.authorityList.length;i++)
	    	{
	    		if(data.authorityList[i].USE_FLAG == "Y"&&data.authorityList[i].ACTION_CD=="EXCEL")
	    		{
	    			$('#excelSqlContainer').show();
	    			$("#excel").show();
	    		}
	    		else if(data.authorityList[i].USE_FLAG == "Y"&&data.authorityList[i].ACTION_CD=="SQL")
	    		{
	    			$('#excelSqlContainer').show();
	    			$("#sql").show();
	    		}
	    	}
	    		
	    }
	}, "obj");
}


</script>
<style type="text/css">
.locationext .fnc a {display:inline-block;overflow:hidden;height:27px;margin-left:4px;}
.li_none {list-style-type:none;background:white}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit">${param.popupTitle}</div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
				
				<input type="hidden" id="prodPart" name="prodPart" value="${param.prodPart}"/>
				<input type="hidden" id="workplaces" name="workplaces" value="${param.workplaces}"/>
				<input type="hidden" id="fromDate" name="fromDate" value="${param.fromDate}"/>
				<input type="hidden" id="toDate" name="toDate" value="${param.toDate}"/>
				
				<div class="srhcondi">
				<c:set var="lvWidth" value="115px" />
				<ul>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.routing"/></strong>
						<div class="selectBox">
							<select id="routing" name="routing" multiple="multiple"></select>
						</div>
					</li>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.facilityGroup"/></strong>
						<div class="selectBox">
							<select id="facilityGroup" name="facilityGroup" multiple="multiple"></select>
						</div>
					</li>
					
				</ul>
				<ul>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.facility"/></strong>
						<div class="selectBox">
							<input type="text" id="facility" name="facility" value="" class="ipt" style="width:${lvWidth};">
						</div>
					</li>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.facility"/></strong>
						<input type="text" id="fromCal" name="fromCal" class="iptdate datepicker1" readonly value="" />
						<%-- <input type="<c:if test="${param.wType=='SW'}">hidden</c:if><c:if test="${param.wType!='SW'}">text</c:if>" id="fromPWeek" name="fromPWeek" class="iptdateweek" disabled="disabled" value=""/>
						<input type="<c:if test="${param.wType=='SW'}">text</c:if><c:if test="${param.wType!='SW'}">hidden</c:if>" id="fromWeek" name="fromWeek" class="iptdateweek" disabled="disabled" value=""/> --%>
						<input type="hidden" id="swFromDate" name="swFromDate"/>
						<input type="hidden" id="pwFromDate" name="pwFromDate"/>
						~
						<input type="text" id="toCal" name="toCal" class="iptdate datepicker2" readonly value="" />
						<%-- <input type="<c:if test="${param.wType=='SW'}">hidden</c:if><c:if test="${param.wType!='SW'}">text</c:if>" id="toPWeek" name="toPWeek" class="iptdateweek" disabled="disabled" value=""/>
						<input type="<c:if test="${param.wType=='SW'}">text</c:if><c:if test="${param.wType!='SW'}">hidden</c:if>" id="toWeek" name="toWeek" class="iptdateweek" disabled="disabled" value=""/> --%>
						<input type="hidden" id="swToDate" name="swToDate"/>
						<input type="hidden" id="pwToDate" name="pwToDate"/>
					
					</li>
					<li id="excelSqlContainer" style="display:none;">
								<div class="locationext">
									<div class="fnc">
										<a href="#" id='excel' style="display:none" class="viewfnc5"><img src="${ctx}/statics/images/common/btn_gun5.gif" title="Excel Download"></a>
							    		<a href="#" id='sql' style="display:none"class="viewfnc4"><img src="${ctx}/statics/images/common/btn_gun4.gif" title="SQL View"></a>
							    	</div>
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
			
		</div>
		<div class="pop_btm">
			<div class="pop_btn_info">
				<strong >Sum  :</strong> <span id="bottom_userSum"></span>
			</div>
			<div class="pop_btn_info">
				<strong >Avg  :</strong> <span id="bottom_userAvg"></span>
			</div>
			<div class="pop_btn">
				<a href="#" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>