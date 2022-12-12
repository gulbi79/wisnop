<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.summary"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
var codeMapWeekList, codeMapBucketList, codeMapMeaList;
var popupWidth, popupHeight;
var dataRow, bucketList;
var gridInstance, grdMain, dataProvider;
var popUpMenuCd = "${param.menuCd}";
var lv_conFirmFlag = true;
$("document").ready(function (){
	gfn_popresize();
	fn_init();
	fn_initGrid();
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

//데이터 초기화
function fn_init() {
	
	//부모검색조건
	FORM_SEARCH = {};
	
	$.each(opener.FORM_SEARCH, function(i, el){
		if (!$.isArray(el)) {
			FORM_SEARCH[i] = el;
		}
	});
	
	$("#btnClose").click("on", function() { window.close(); });
	
	fn_initData();
	
	$(':radio[name=weekMonth]').on('change', function () {
		searchChk();
	});
	
}

function searchChk(){
	
	var weekMonth = $(':radio[name=weekMonth]:checked').val();
	
	if(weekMonth == "month"){
		FORM_SEARCH.sql      = false;
		FORM_SEARCH._mtd	 = "getList";
		FORM_SEARCH.measCd   = "${param.measCd}";
		FORM_SEARCH.currentWeekPop	     = "${param.currentWeekPop}";
		FORM_SEARCH.planIdOnePlusWeekPop = "${param.planIdOnePlusWeekPop}";
		FORM_SEARCH.planStartWeekPop     = "${param.planStartWeekPop}";
		FORM_SEARCH.currentMonthPop      = "${param.currentMonthPop}";
		FORM_SEARCH.currentMonthNextPop  = "${param.currentMonthNextPop}";
		
		FORM_SEARCH.tranData = [{ outDs : "rtnList", _siq : "dp.planCommon.salesPlanSummaryMonth"}];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj.do",
			data   : FORM_SEARCH,
			success: function(data) {
				
				codeMapWeekList = data.rtnList;
				
				fn_getGridData();
			}
		}, "obj");
	}else if(weekMonth == "week"){
		fn_initData();
	}
}



function fn_initData(){

	FORM_SEARCH.sql      = false;
	FORM_SEARCH._mtd	 = "getList";
	FORM_SEARCH.measCd   = "${param.measCd}";
	FORM_SEARCH.currentWeekPop	     = "${param.currentWeekPop}";
	FORM_SEARCH.planIdOnePlusWeekPop = "${param.planIdOnePlusWeekPop}";
	FORM_SEARCH.planStartWeekPop     = "${param.planStartWeekPop}";
	FORM_SEARCH.currentMonthPop      = "${param.currentMonthPop}";
	FORM_SEARCH.currentMonthNextPop  = "${param.currentMonthNextPop}";
	
	FORM_SEARCH.tranData = [
							{ outDs : "rtnList", _siq : "dp.planCommon.salesPlanSummaryDate"},
							{ outDs : "bucketList", _siq : "dp.planCommon.salesPlanSummaryBucket"},		
							{ outDs : "meaList", _siq : "dp.planCommon.salesPlanSummaryMeaList"}		
							];
	
	gfn_service({
		url    : GV_CONTEXT_PATH + "/biz/obj.do",
		data   : FORM_SEARCH,
		success: function(data) {
			
			codeMapWeekList = data.rtnList;
			codeMapBucketList = data.bucketList;
			codeMapMeaList = data.meaList;
			
			fn_getGridData();
		}
	}, "obj");
}



//그리드 초기화
function fn_initGrid() {
	
	//메저 width 설정
	gv_meaW = 150;
	
	//그리드 설정
	gridInstance = new GRID();
	gridInstance.init("realgrid");
	grdMain	  = gridInstance.objGrid;
	dataProvider = gridInstance.objData;
	
	//그리드 옵션
	grdMain.setOptions({
		sorting : { enabled	  : false },
		display : { columnMovable: false }
	});

	var totAr =  ['PROD_LVL3_CD', 'PROD_LVL3_NM', 'CATEGORY_NM', 'RCG001', 'RCG002', 'RCG003', 'RCG004', 'RCG005', 'RCG006', 'RCG007'];
	var columns = 
		[
			{
				name	  : "PROD_LVL3_CD",
				fieldName : "PROD_LVL3_CD",
				header    : {text : '<spring:message code="lbl.itemGroup"/>'},
				styles    : {textAlignment : "near", background : gfn_getArrDimColor(0)},
				mergeRule : { criteria : "values['PROD_LVL3_CD'] + value" },
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
				editable  : false,
				width     : 100
			}, {
				name : "PROD_LVL3_NM", fieldName: "PROD_LVL3_NM", editable: false, header: {text: '<spring:message code="lbl.itemGroupName" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gfn_getArrDimColor(0), numberFormat : "#,##0"},
				mergeRule : { criteria : "values['PROD_LVL3_NM'] + value" },
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
				dataType : "number",
				width: 120
			}, {
				name : "CATEGORY_NM", fieldName: "CATEGORY_NM", editable: false, header: {text: '<spring:message code="lbl.category" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gfn_getArrDimColor(1), numberFormat : "#,##0"},
				//dynamicStyles : [gfn_getDynamicStyle(-2)],
				dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
				dataType : "number",
				width: 100
			}, {
				name : "RCG001", fieldName: "RCG001", editable: false, header: {text: '<spring:message code="lbl.rcg001" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gfn_getArrDimColor(2), numberFormat : "#,##0.0"},
				//dynamicStyles : [gfn_getDynamicStyle(-2)],
				dynamicStyles:[gfn_getDynamicStyle(-2, totAr)],
				dataType : "number",
				width: 80
			}, {
				name : "RCG002", fieldName: "RCG002", editable: false, header: {text: '<spring:message code="lbl.rcg002" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gfn_getArrDimColor(2), numberFormat : "#,##0.0"},
				//dynamicStyles : [gfn_getDynamicStyle(-2)],
				dynamicStyles:[gfn_getDynamicStyle(-2, totAr)],
				dataType : "number",
				width: 80
			}, {
				name : "RCG005", fieldName: "RCG005", editable: false, header: {text: '<spring:message code="lbl.rcg005" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gfn_getArrDimColor(2), numberFormat : "#,##0.0"},
				//dynamicStyles : [gfn_getDynamicStyle(-2)],
				dynamicStyles:[gfn_getDynamicStyle(-2, totAr)],
				dataType : "number",
				width: 80
			}, {
				name : "RCG006", fieldName: "RCG006", editable: false, header: {text: '<spring:message code="lbl.rcg006" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gfn_getArrDimColor(2), numberFormat : "#,##0.0"},
				//dynamicStyles : [gfn_getDynamicStyle(-2)],
				dynamicStyles:[gfn_getDynamicStyle(-2, totAr)],
				dataType : "number",
				width: 80
			}, {
				name : "RCG007", fieldName: "RCG007", editable: false, header: {text: '<spring:message code="lbl.rcg007" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gfn_getArrDimColor(2), numberFormat : "#,##0.0"},
				//dynamicStyles : [gfn_getDynamicStyle(-2)],
				dynamicStyles:[gfn_getDynamicStyle(-2, totAr)],
				dataType : "number",
				width: 80
			}, {
				name : "RCG003", fieldName: "RCG003", editable: false, header: {text: '<spring:message code="lbl.rcg003" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gfn_getArrDimColor(2), numberFormat : "#,##0.0"},
				//dynamicStyles : [gfn_getDynamicStyle(-2)],
				dynamicStyles:[gfn_getDynamicStyle(-2, totAr)],
				dataType : "number",
				width: 80
			}, {
				name : "RCG004", fieldName: "RCG004", editable: false, header: {text: '<spring:message code="lbl.rcg004" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gfn_getArrDimColor(2), numberFormat : "#,##0.0"},
				//dynamicStyles : [gfn_getDynamicStyle(-2)],
				dynamicStyles:[gfn_getDynamicStyle(-2, totAr)],
				dataType : "number",
				width: 80
			}
		];

	grdMain.setColumns(columns);
	
	var fields = new Array();
	fields = [
		{ fieldName : "PROD_LVL3_CD"},
		{ fieldName : "PROD_LVL3_NM"},
		{ fieldName : "CATEGORY_NM"},
		{ fieldName : "RCG001", dataType : 'number'},
		{ fieldName : "RCG002", dataType : 'number'},
		{ fieldName : "RCG003", dataType : 'number'},
		{ fieldName : "RCG004", dataType : 'number'},
		{ fieldName : "RCG005", dataType : 'number'},
		{ fieldName : "RCG006", dataType : 'number'},
		{ fieldName : "RCG007", dataType : 'number'}
	];
	
	dataProvider.setFields(fields);
}


//조회
function fn_apply(sqlFlag) {
	
	//메인 데이터를 조회
	fn_getGridData(sqlFlag);
}

//그리드 데이터 조회
function fn_getGridData(sqlFlag) {

	var flag = $(':radio[name=weekMonth]:checked').val();
	
	FORM_SEARCH.sql      = sqlFlag;
	FORM_SEARCH._mtd	 = "getList";
	FORM_SEARCH.measCd   = "${param.measCd}";
	FORM_SEARCH.currentWeekPop	     = "${param.currentWeekPop}";
	FORM_SEARCH.planIdOnePlusWeekPop = "${param.planIdOnePlusWeekPop}";
	FORM_SEARCH.planStartWeekPop     = "${param.planStartWeekPop}";
	FORM_SEARCH.currentMonthPop      = "${param.currentMonthPop}";
	FORM_SEARCH.currentMonthNextPop  = "${param.currentMonthNextPop}";
	FORM_SEARCH.weekList 			 = codeMapWeekList;
	FORM_SEARCH.bucketList 			 = codeMapBucketList;
	FORM_SEARCH.meaList 			 = codeMapMeaList;
	FORM_SEARCH.flag 			     = flag;
	FORM_SEARCH.tranData = [];
	FORM_SEARCH.tranData.push( { "outDs" : "rtnList", "_siq" : "dp.planCommon.salesPlanSummary"} );
	
	
	gfn_service({
		url    : GV_CONTEXT_PATH + "/biz/obj.do",
		data   : FORM_SEARCH,
		success: function(data) {
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

//엑셀, 쿼리 다운로드 권한 확인
function fn_excelSqlAuth() {
	
	gfn_service({
	    async   : false,
	    url     : GV_CONTEXT_PATH + "/biz/obj.do",
	    data    : {
   			_mtd : "getList",
   			popUpMenuCd : popUpMenuCd,
   			tranData : [
   				{outDs : "authorityList", _siq : "dp.planCommon.salesPlanSummaryExcelSql"}
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
		<div class="pop_tit"><spring:message code="lbl.summary"/>
			<div style="float:right;margin-right: 30px;">
			<input type="radio" name="weekMonth" value="week" checked/> 차주
			<input type="radio" name="weekMonth" value="month"/>차월
		</div>
		</div>
		<div class="popCont">
			<div class="srhwrap">
				<div class="srhcondi">
					<ul style="float:right;">
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
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>