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
var lv_conFirmFlag = true;
var popUpMenuCd = "${param.menuCd}";
$("document").ready(function (){
	gfn_popresize();
	fn_init();
	fn_initGrid();
	fn_apply();
	fn_excelSqlAuth();
	$(".viewfnc5").click("on", function() {
		gfn_doExportExcel({fileNm:"${menuInfo.menuNm}", conFirmFlag: lv_conFirmFlag}); 
		$(".pClose").click(function() {
			console.log(".pClose clicked");
			$("#divTempLayerPopup").hide();
			$(".back").hide();
		});
	    $(".popClose").click(function() {
	    	console.log(".popClose clicked");
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
	
	$("#btnClose" ).click("on", function() { window.close(); });
	
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

	var totAr =  ['ROUTING_ID'];
	var columns = 
		[
			{
				name	  : "ROUTING_ID",
				fieldName : "ROUTING_ID",
				header    : {text : '<spring:message code="lbl.routing"/>'},
				styles    : {textAlignment : "near", background : gv_editColor},
				mergeRule : { criteria : "values['ROUTING_ID'] + value" },
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
				editable  : false,
				width     : 100
			}, {
				name : "REQ_AMOUNT", fieldName: "REQ_AMOUNT", editable: false, header: {text: '<spring:message code="lbl.necessityMoney" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
				dynamicStyles : [gfn_getDynamicStyle(-1, totAr)],
				dataType : "number",
				width: 100
			}, {
				name : "MRP_AMOUNT", fieldName: "MRP_AMOUNT", editable: false, header: {text: '<spring:message code="lbl.mrpAmount" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
				dynamicStyles : [gfn_getDynamicStyle(-1, totAr)],
				dataType : "number",
				width: 100
			}, {
				name : "MRP_REQ_AMOUNT", fieldName: "MRP_REQ_AMOUNT", editable: false, header: {text: '<spring:message code="lbl.notConfirm" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
				dynamicStyles : [gfn_getDynamicStyle(-1, totAr)],
				dataType : "number",
				width: 100
			}, {
				name : "ONE_WEEK_DATA", fieldName: "ONE_WEEK_DATA", editable: false, header: {text: '<spring:message code="lbl.w-1RepAmount" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
				dynamicStyles : [gfn_getDynamicStyle(-1, totAr)],
				dataType : "number",
				width: 100
			}, {
				name : "TWO_WEEK_DATA", fieldName: "TWO_WEEK_DATA", editable: false, header: {text: '<spring:message code="lbl.w-2RepAmount" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
				dynamicStyles : [gfn_getDynamicStyle(-1, totAr)],
				dataType : "number",
				width: 100
			}, {
				name : "THREE_WEEK_DATA", fieldName: "THREE_WEEK_DATA", editable: false, header: {text: '<spring:message code="lbl.w-3RepAmount" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
				dynamicStyles : [gfn_getDynamicStyle(-1, totAr)],
				dataType : "number",
				width: 100
			}, {
				name : "FOUR_WEEK_DATA", fieldName: "FOUR_WEEK_DATA", editable: false, header: {text: '<spring:message code="lbl.w-4RepAmount" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
				dynamicStyles : [gfn_getDynamicStyle(-1, totAr)],
				dataType : "number",
				width: 100
			}
		];

	grdMain.setColumns(columns);
	
	var fields = new Array();
	fields = [
		{ fieldName : "ROUTING_ID"},
		{ fieldName : "REQ_AMOUNT", dataType : 'number'},
		{ fieldName : "MRP_AMOUNT", dataType : 'number'},
		{ fieldName : "MRP_REQ_AMOUNT", dataType : 'number'},
		{ fieldName : "ONE_WEEK_DATA", dataType : 'number'},
		{ fieldName : "TWO_WEEK_DATA", dataType : 'number'},
		{ fieldName : "THREE_WEEK_DATA", dataType : 'number'},
		{ fieldName : "FOUR_WEEK_DATA", dataType : 'number'}
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
	
	FORM_SEARCH.sql      = sqlFlag;
	FORM_SEARCH._mtd	 = "getList";
	FORM_SEARCH.fromWeek = "${param.fromWeek}";
	FORM_SEARCH.fromCal  = "${param.fromCal}";
	FORM_SEARCH.tranData = [];
	FORM_SEARCH.tranData.push( { "outDs" : "rtnList", "_siq" : "snop.oprtKpi.materialSummary"} );
	
	//console.log("FORM_SEARCH : ", FORM_SEARCH);
 
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
   				{outDs : "authorityList", _siq : "snop.oprtKpi.materialSummaryExcelSql"}
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