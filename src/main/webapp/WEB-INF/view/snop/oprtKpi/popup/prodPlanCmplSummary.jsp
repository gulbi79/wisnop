<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.summary"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
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

	var totAr =  ['TEAM_CD_NM', 'ROUTING_ID_NM'];
	var columns = 
		[
			{
				name	  : "TEAM_CD_NM",
				fieldName : "TEAM_CD_NM",
				header    : {text : '<spring:message code="lbl.team"/>'},
				styles    : {textAlignment : "near", background : gv_editColor},
				mergeRule : { criteria : "values['TEAM_CD_NM'] + value" },
				dynamicStyles:[gfn_getDynamicStyle(1, totAr)],
				editable  : false,
				width     : 100
			}, {
				name      : "TEAM_NM_NM",
				fieldName : "TEAM_NM_NM",
				header    : {text : '<spring:message code="lbl.teamName"/>'},
				styles    : {textAlignment : "near", background : gv_editColor},
				mergeRule : { criteria : "values['TEAM_CD_NM'] + value" },
				dynamicStyles:[gfn_getDynamicStyle(1, totAr)],
				editable  : false,
				width     : 90
			}, {
				name	  : "ROUTING_ID_NM",
				fieldName : "ROUTING_ID_NM",
				header    : {text : '<spring:message code="lbl.routing"/>'},
				styles    : {textAlignment : "near", background : gv_editColor},
				mergeRule : { criteria : "values['ROUTING_ID_NM'] + value" },
				dynamicStyles:[gfn_getDynamicStyle(1, totAr)],
				editable  : false,
				width     : 90
			}, { //합계
				name	  : "TOT_CNT", 
				fieldName : "TOT_CNT", 
				header    : {text: '<spring:message code="lbl.total" javaScriptEscape="true" />'},
				styles    : {textAlignment: "far", background : gv_editColor, numberFormat : "#,##0"},
				dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, { //계획건수
				name	  : "PLAN_CNT", 
				fieldName : "PLAN_CNT", 
				header    : {text: '<spring:message code="lbl.planCnt" javaScriptEscape="true" />'},
				styles    : {textAlignment: "far", background : gv_editColor, numberFormat : "#,##0"},
				dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
				type   : "group",
				name   : "GroupProd",
				width  : 300,
				header : {
					fixedHeight : 0, visible : false
				},
				columns: [
					{ //계획준수
						type        : "group",
						name        : "divUN",
						orientation : "vertical",
						header      : {text: '<spring:message code="lbl.prodCmpl" javaScriptEscape="true" />', fixedHeight : 20},
						columns : [
							{
								name	  : "OB_CNT",
								fieldName : "OB_CNT",
								header	: { visible : false},
								type	  : "data",
								editable  : false,
								width	 : 100,
								styles	: { textAlignment : "far", numberFormat : "#,##0" },
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
							}, {
								name	  : "OB_RATE",
								fieldName : "OB_RATE",
								header	: { visible : false},
								editable  : false,
								type	  : "data",
								width	 : 100,
								styles	: { textAlignment : "far", numberFormat : "#,##0.0", suffix: " %"  },
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
							}
						]
					},
					/* { //계획 미준수
						type        : "group",
						name        : "divUNEX",
						orientation : "vertical",
						header      : {text: '<spring:message code="lbl.noProdCmpl" javaScriptEscape="true" />', fixedHeight : 20},
						columns : [
							{
								name	  : "UN_EX_CNT",
								fieldName : "UN_EX_CNT",
								header	: { visible : false},
								type	  : "data",
								editable  : false,
								width	 : 100,
								styles	: { textAlignment : "far", numberFormat : "#,##0" },
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
							}, {
								name	  : "UN_EX_RATE",
								fieldName : "UN_EX_RATE",
								header	: { visible : false},
								editable  : false,
								type	  : "data",
								width	 : 100,
								styles	: { textAlignment : "far", numberFormat : "#,##0.0", suffix: " %"  },
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
							}
						]
					}, */
					{ // 미달
						type		: "group",
						name		: "divOB",
						orientation : "vertical",
						header	: {text: '<spring:message code="lbl.shot" javaScriptEscape="true" />', fixedHeight : 20},
						columns : [
							{
								name	  : "UN_CNT",
								fieldName : "UN_CNT",
								header	: { visible : false},
								editable  : false,
								type	  : "data",
								width	 : 200,
								styles	: { textAlignment : "far", numberFormat : "#,##0" },
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
							}, {
								name	  : "UN_RATE",
								fieldName : "UN_RATE",
								header	: { visible : false},
								editable  : false,
								type	  : "data",
								width	 : 100,
								styles	: { textAlignment : "far", numberFormat : "#,##0.0", suffix: " %"  },
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
							}
						]
					}/* , { //초과
						type		: "group",
						name		: "divEX",
						orientation : "vertical",
						header	: {text: '<spring:message code="lbl.over" javaScriptEscape="true" />', fixedHeight : 20},
						columns : [
							{
								name	  : "EX_CNT",
								fieldName : "EX_CNT",
								header	: { visible : false},
								editable  : false,
								type	  : "data",
								width	 : 200,
								styles	: { textAlignment : "far", numberFormat : "#,##0" },
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
							}, {
								name	  : "EX_RATE",
								fieldName : "EX_RATE",
								header	: { visible : false},
								editable  : false,
								type	  : "data",
								width	 : 100,
								styles	: { textAlignment : "far", numberFormat : "#,##0.0", suffix: " %" },
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
							}
						]
					} */
				]
			}
		];

	grdMain.setColumns(columns);
	
	var fields = new Array();
	fields = [
		{ fieldName : "TEAM_CD_NM"},
		{ fieldName : "TEAM_NM_NM"},
		{ fieldName : "ROUTING_ID_NM"},
		{ fieldName : "TOT_CNT"   , dataType : 'number'},
		{ fieldName : "PLAN_CNT"  , dataType : 'number'},
		{ fieldName : "UN_CNT"    , dataType : 'number'},
		{ fieldName : "OB_CNT"    , dataType : 'number'},
		{ fieldName : "UN_EX_CNT" , dataType : 'number'},
		{ fieldName : "EX_CNT"    , dataType : 'number'},
		{ fieldName : "UN_RATE"   , dataType : 'number'},
		{ fieldName : "OB_RATE"   , dataType : 'number'},
		{ fieldName : "EX_RATE"   , dataType : 'number'},
		{ fieldName : "UN_EX_RATE", dataType : 'number'}
	];
	
	dataProvider.setFields(fields);
	
	var divUN = grdMain.columnByName("divUN");
	if (divUN) {
		var hide = !this.grdMain.getColumnProperty(divUN, "hideChildHeaders");
		this.grdMain.setColumnProperty(divUN, "hideChildHeaders", hide);
	}
	
	var divUNEX = grdMain.columnByName("divUNEX");
	if (divUNEX) {
		var hide = !this.grdMain.getColumnProperty(divUNEX, "hideChildHeaders");
		this.grdMain.setColumnProperty(divUNEX, "hideChildHeaders", hide);
	}
	
	
	var divOB = grdMain.columnByName("divOB");
	if (divOB) {
		var hide = !this.grdMain.getColumnProperty(divOB, "hideChildHeaders");
		this.grdMain.setColumnProperty(divOB, "hideChildHeaders", hide);
	}
	var divEX = grdMain.columnByName("divEX");
	if (divEX) {
		var hide = !this.grdMain.getColumnProperty(divEX, "hideChildHeaders");
		this.grdMain.setColumnProperty(divEX, "hideChildHeaders", hide);
	}
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
	FORM_SEARCH.tranData = [];
	FORM_SEARCH.tranData.push( { "outDs" : "rtnList", "_siq" : "snop.oprtKpi.prodPalnCmplSummary"} );

	gfn_service({
		url    : GV_CONTEXT_PATH + "/biz/obj",
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
	    url     : GV_CONTEXT_PATH + "/biz/obj",
	    data    : {
   			_mtd : "getList",
   			popUpMenuCd : popUpMenuCd,
   			tranData : [
   				{outDs : "authorityList", _siq : "snop.oprtKpi.prodPalnCmplSummaryExcelSql"}
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
		<div class="pop_tit"><spring:message code="lbl.summary"/></div>
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