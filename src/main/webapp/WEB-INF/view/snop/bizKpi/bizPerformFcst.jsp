<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>

	<script type="text/javascript">
	var enterSearchFlag = "Y";
	var actMonth = 1;
	var curMonth = 1;
	var bizPerformFcst = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.initSearch();
			this.events();
			this.bizGrid.initGrid();
		},
		
		_siq : "snop.bizKpi.bizPerformFcst",
		_initVar : null,
		
		initFilter : function() {
			gfn_setMsComboAll([
				{target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>',  data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"]}
			]);
			
			$(':radio[name=rdoAqType]:input[value="MON"]').attr("checked", true);
		},
		
		comCode : {
			codeMap : null,
			codeReptMap : null,
			
			initCode : function () {
				
				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP"]);
			}
		},
		
		/********************************************************************************************************
		** grid  선언  
		********************************************************************************************************/
		bizGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;

				this.setFields();
				this.setColumn();
				
				this.setOptions();
			},
			
			setColumn : function () {
				
				var dnmStyle1 = [], dnmStyle2 = [], dnmStyle3 = [];
				
				var dnmStyle1 = 
				[ {
					criteria : [
						"(value < 0) and ( (values['MEAS_CD'] = 'BUSINESS_PLAN_GAP') or (values['MEAS_CD'] = 'EXECUTE_PLAN_GAP') ) ",
						"(value < 100) and ( (values['MEAS_CD'] = 'BUSINESS_PLAN_RATE') or (values['MEAS_CD'] = 'EXECUTE_PLAN_RATE') ) ",
						"(values['MEAS_CD'] = 'BUSINESS_PLAN')", "(values['MEAS_CD'] = 'EXECUTE_PLAN')",
						"( (values['MEAS_CD'] = 'BUSINESS_PLAN_RATE') or (values['MEAS_CD'] = 'EXECUTE_PLAN_RATE') )",
						"(values['MEAS_CD'] = 'SALES_AMT')"
						],
					styles : ["foreground=#ffff0000", "foreground=#ffff0000;numberFormat=#,##0.0", "background=#edf7fd", "background=#dcfbef", "numberFormat=#,##0.0", "background=#FFA2A2"]
				} ];
				
				var dnmStyle2 = 
				[ {
					criteria : [
						"(value < 0) and ( (values['MEAS_CD'] = 'BUSINESS_PLAN_GAP') or (values['MEAS_CD'] = 'EXECUTE_PLAN_GAP') ) ",
						"(value < 100) and ( (values['MEAS_CD'] = 'BUSINESS_PLAN_RATE') or (values['MEAS_CD'] = 'EXECUTE_PLAN_RATE') ) ",
						"(values['MEAS_CD'] = 'BUSINESS_PLAN')", "(values['MEAS_CD'] = 'EXECUTE_PLAN')",
						"( (values['MEAS_CD'] = 'BUSINESS_PLAN_RATE') or (values['MEAS_CD'] = 'EXECUTE_PLAN_RATE') )",
						"(values['MEAS_CD'] = 'SALES_AMT')"
						],
					styles : ["foreground=#ffff0000", "foreground=#ffff0000;numberFormat=#,##0.0", "background=#edf7fd", "background=#edf7fd", "numberFormat=#,##0.0", "background=#FFA2A2"]
				} ];
				
				var dnmStyle3 = 
				[ {
					criteria : [
						"(value < 0) and ( (values['MEAS_CD'] = 'BUSINESS_PLAN_GAP') or (values['MEAS_CD'] = 'EXECUTE_PLAN_GAP') ) ",
						"(value < 100) and ( (values['MEAS_CD'] = 'BUSINESS_PLAN_RATE') or (values['MEAS_CD'] = 'EXECUTE_PLAN_RATE') ) ",
						"(values['MEAS_CD'] = 'BUSINESS_PLAN')", "(values['MEAS_CD'] = 'EXECUTE_PLAN')",
						"( (values['MEAS_CD'] = 'BUSINESS_PLAN_RATE') or (values['MEAS_CD'] = 'EXECUTE_PLAN_RATE') )",
						"(values['MEAS_CD'] = 'SALES_AMT')"
						],
					styles : ["foreground=#ffff0000", "foreground=#ffff0000;numberFormat=#,##0.0", "background=#edf7fd", "background=#dcfbef", "numberFormat=#,##0.0", "background=#dcfbef"]
				} ];
				
				var columns = 
				[	
					{
						name      : "BU_NM",
						fieldName : "BU_NM",
						header    : {text : '<spring:message code="lbl.buName"/>'},
						styles    : {textAlignment : "near"},
						editable  : false,
						mergeRule : { criteria: "values['BU_CD'] + value" },
						width     : 80
					}, {
						name      : "REP_CUST_GROUP_NM",
						fieldName : "REP_CUST_GROUP_NM",
						header    : {text : '<spring:message code="lbl.reptCustGroup"/>'},
						styles    : {textAlignment : "near"},
						editable  : false,
						mergeRule : { criteria: "values['REP_CUST_GROUP_NM'] + value" },
						width     : 120
					}, {
						name      : "MEAS_NM",
						fieldName : "MEAS_NM",
						header    : {text : '<spring:message code="lbl.measureName"/>'},
						styles    : {textAlignment : "near"},
						editable  : false,
						width     : 140
					}, {
						type      : "group",
						header    : { fixedHeight : 20, text : '<spring:message code="lbl.expActual"/>' },
						width     : 1120,
						columns   : [
							{
								name      : "M01", 
								fieldName : "M01", 
								header    : {text: '<spring:message code="lbl.january" javaScriptEscape="true" />'},
								styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
								editable  : false,
								dataType  : "number",
								//dynamicStyles : ( (1 <= actMonth) ? dnmStyle1 : dnmStyle2) ,
								//dynamicStyles : ( (1 <= actMonth) ? (1 <= curMonth ? dnmStyle1 : dnmStyle3) : dnmStyle2),
								dynamicStyles : ( (1 <= curMonth) ? dnmStyle3 : (1 <= actMonth ? dnmStyle1 : dnmStyle2)) ,
								width     : 80
							}, {
								name      : "M02", 
								fieldName : "M02", 
								header    : {text: '<spring:message code="lbl.february" javaScriptEscape="true" />'},
								styles    : {textAlignment : "far", numberFormat : "#,##0.0"},
								editable  : false,
								dataType  : "number",
								//dynamicStyles : ( (2 <= actMonth) ? dnmStyle1 : dnmStyle2) ,
								//dynamicStyles : ( (2 <= actMonth) ? (2 <= curMonth ? dnmStyle1 : dnmStyle3) : dnmStyle2),
								dynamicStyles : ( (2 <= curMonth) ? dnmStyle3 : (2 <= actMonth ? dnmStyle1 : dnmStyle2)) ,
								width     : 80
							}, {
								name      : "M03", 
								fieldName : "M03",  
								header    : {text: '<spring:message code="lbl.march" javaScriptEscape="true" />'},
								styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
								editable  : false,
								dataType  : "number",
								//dynamicStyles : ( (3 <= actMonth) ? dnmStyle1 : dnmStyle2) ,
								//dynamicStyles : ( (3 <= actMonth) ? (3 <= curMonth ? dnmStyle1 : dnmStyle3) : dnmStyle2),
								dynamicStyles : ( (3 <= curMonth) ? dnmStyle3 : (3 <= actMonth ? dnmStyle1 : dnmStyle2)) ,
								width     : 80
							}, {
								name      : "M04", 
								fieldName : "M04", 
								header    : {text: '<spring:message code="lbl.april" javaScriptEscape="true" />'},
								styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
								editable  : false,
								dataType  : "number",
								//dynamicStyles : ( (4 <= actMonth) ? dnmStyle1 : dnmStyle2) ,
								//dynamicStyles : ( (4 <= actMonth) ? (4 <= curMonth ? dnmStyle1 : dnmStyle3) : dnmStyle2),
								dynamicStyles : ( (4 <= curMonth) ? dnmStyle3 : (4 <= actMonth ? dnmStyle1 : dnmStyle2)) ,
								width     : 80
							}, {
								name      : "M05", 
								fieldName : "M05", 
								header    : {text: '<spring:message code="lbl.may" javaScriptEscape="true" />'},
								styles    : {textAlignment : "far", numberFormat : "#,##0.0"},
								editable  : false,
								dataType  : "number",
								//dynamicStyles : ( (5 <= actMonth) ? dnmStyle1 : dnmStyle2) ,
								//dynamicStyles : ( (5 <= actMonth) ? (5 <= curMonth ? dnmStyle1 : dnmStyle3) : dnmStyle2),
								dynamicStyles : ( (5 <= curMonth) ? dnmStyle3 : (5 <= actMonth ? dnmStyle1 : dnmStyle2)) ,
								width     : 80
							}, {
								name      : "M06", 
								fieldName : "M06",  
								header    : {text: '<spring:message code="lbl.june" javaScriptEscape="true" />'},
								styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
								editable  : false,
								dataType  : "number",
								//dynamicStyles : ( (6 <= actMonth) ? dnmStyle1 : dnmStyle2) ,
								//dynamicStyles : ( (6 <= actMonth) ? (6 <= curMonth ? dnmStyle1 : dnmStyle3) : dnmStyle2),
								dynamicStyles : ( (6 <= curMonth) ? dnmStyle3 : (6 <= actMonth ? dnmStyle1 : dnmStyle2)) ,
								width     : 80
							}, {
								name      : "M07", 
								fieldName : "M07", 
								header    : {text: '<spring:message code="lbl.july" javaScriptEscape="true" />'},
								styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
								editable  : false,
								dataType  : "number",
								//dynamicStyles : ( (7 <= actMonth) ? dnmStyle1 : dnmStyle2) ,
								//dynamicStyles : ( (7 <= actMonth) ? (7 <= curMonth ? dnmStyle1 : dnmStyle3) : dnmStyle2),
								dynamicStyles : ( (7 <= curMonth) ? dnmStyle3 : (7 <= actMonth ? dnmStyle1 : dnmStyle2)) ,
								width     : 80
							}, {
								name      : "M08", 
								fieldName : "M08", 
								header    : {text: '<spring:message code="lbl.august" javaScriptEscape="true" />'},
								styles    : {textAlignment : "far", numberFormat : "#,##0.0"},
								editable  : false,
								dataType  : "number",
								//dynamicStyles : ( (8 <= actMonth) ? dnmStyle1 : dnmStyle2) ,
								//dynamicStyles : ( (8 <= actMonth) ? (8 <= curMonth ? dnmStyle1 : dnmStyle3) : dnmStyle2),
								dynamicStyles : ( (8 <= curMonth) ? dnmStyle3 : (8 <= actMonth ? dnmStyle1 : dnmStyle2)) ,
								width     : 80
							}, {
								name      : "M09", 
								fieldName : "M09",  
								header    : {text: '<spring:message code="lbl.september" javaScriptEscape="true" />'},
								styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
								editable  : false,
								dataType  : "number",
								//dynamicStyles : ( (9 <= actMonth) ? dnmStyle1 : dnmStyle2) ,
								//dynamicStyles : ( (9 <= actMonth) ? (9 <= curMonth ? dnmStyle1 : dnmStyle3) : dnmStyle2),
								dynamicStyles : ( (9 <= curMonth) ? dnmStyle3 : (9 <= actMonth ? dnmStyle1 : dnmStyle2)) ,
								width     : 80
							}, {
								name      : "M10", 
								fieldName : "M10",  
								header    : {text: '<spring:message code="lbl.october" javaScriptEscape="true" />'},
								styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
								editable  : false,
								dataType  : "number",
								//dynamicStyles : ( (10 <= actMonth) ? dnmStyle1 : dnmStyle2) ,
								//dynamicStyles : ( (10 <= actMonth) ? (10 <= curMonth ? dnmStyle1 : dnmStyle3) : dnmStyle2),
								dynamicStyles : ( (10 <= curMonth) ? dnmStyle3 : (10 <= actMonth ? dnmStyle1 : dnmStyle2)) ,
								width     : 80
							}, {
								name      : "M11", 
								fieldName : "M11",  
								header    : {text: '<spring:message code="lbl.november" javaScriptEscape="true" />'},
								styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
								editable  : false,
								dataType  : "number",
								//dynamicStyles : ( (11 <= actMonth) ? dnmStyle1 : dnmStyle2) ,
								//dynamicStyles : ( (11 <= actMonth) ? (11 <= curMonth ? dnmStyle1 : dnmStyle3) : dnmStyle2),
								dynamicStyles : ( (11 <= curMonth) ? dnmStyle3 : (11 <= actMonth ? dnmStyle1 : dnmStyle2)) ,
								width     : 80
							}, {
								name      : "M12", 
								fieldName : "M12",  
								header    : {text: '<spring:message code="lbl.december" javaScriptEscape="true" />'},
								styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
								editable  : false,
								dataType  : "number",
								//dynamicStyles : ( (12 <= actMonth) ? dnmStyle1 : dnmStyle2) ,
								//dynamicStyles : ( (12 <= actMonth) ? (12 <= curMonth ? dnmStyle1 : dnmStyle3) : dnmStyle2),
								dynamicStyles : ( (12 <= curMonth) ? dnmStyle3 : (12 <= actMonth ? dnmStyle1 : dnmStyle2)) ,
								width     : 80
							}, {
								name      : "M_TOT", 
								fieldName : "M_TOT",  
								header    : { text : '<spring:message code="lbl.total" javaScriptEscape="true" />'},
								styles    : { textAlignment : "far", numberFormat : "#,##0.0"},
								editable  : false,
								dataType  : "number",
								dynamicStyles : [ {
									criteria : [
										"(value < 0) and ( (values['MEAS_CD'] = 5) or (values['MEAS_CD'] = 6) ) ",
										"(value < 100) and ( (values['MEAS_CD'] = 7) or (values['MEAS_CD'] = 8) ) ",
										"( (values['MEAS_CD'] = 7) or (values['MEAS_CD'] = 8) ) "
										],
									styles : ["foreground=#ffff0000", "foreground=#ffff0000;numberFormat=#,##0.0", "numberFormat=#,##0.0"]
								} ],
								width     : 100
							}
						]
					}
				];
				
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols) {
				
				var fields = new Array();
				
				fields = [
					{ fieldName : "BU_CD",             dataType : "text" },
					{ fieldName : "BU_NM",             dataType : "text" },
					{ fieldName : "REP_CUST_GROUP_NM", dataType : "text" },
					{ fieldName : "MEAS_CD",           dataType : "text" },
					{ fieldName : "MEAS_NM",           dataType : "text" },
					{ fieldName : "M01",               dataType : "number" },
					{ fieldName : "M02",               dataType : "number" },
					{ fieldName : "M03",               dataType : "number" },
					{ fieldName : "M04",               dataType : "number" },
					{ fieldName : "M05",               dataType : "number" },
					{ fieldName : "M06",               dataType : "number" },
					{ fieldName : "M07",               dataType : "number" },
					{ fieldName : "M08",               dataType : "number" },
					{ fieldName : "M09",               dataType : "number" },
					{ fieldName : "M10",               dataType : "number" },
					{ fieldName : "M11",               dataType : "number" },
					{ fieldName : "M12",               dataType : "number" },
					{ fieldName : "M_TOT",             dataType : "number" },
					
		        ];
				
				this.dataProvider.setFields(fields);
			},
			
			setOptions : function () {
				this.grdMain.setOptions({
					sorting : { enabled      : false },
					display : { columnMovable: false }
				});
				
				this.dataProvider.setOptions({
					softDeleting : true
				});
			},
			
		},
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
		}, 
		
		excelSubSearch : function (){
			$.each($(".view_combo"), function(i, val){
				
				var temp = "";
				var id = gfn_nvl($(this).attr("id"), "");
				
				if(id != ""){
					
					var name = $("#" + id + " .ilist .itit").html();
					
					//타이틀
					if(i == 0){
						EXCEL_SEARCH_DATA = name + " : ";	
					}else{
						EXCEL_SEARCH_DATA += "\n" + name + " : ";	
					}
					
					//데이터
					if(id == "divRepCustGroup"){
						$.each($("#reptCustGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}
				}
			});
		},
		
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.CUR_MONTH = bizPerformFcst._initVar.CUR_MONTH;
			FORM_SEARCH.ACT_MONTH = bizPerformFcst._initVar.ACT_MONTH;
			FORM_SEARCH.tranData = [{outDs : "resList", _siq : bizPerformFcst._siq}];
			
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						bizPerformFcst.bizGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						bizPerformFcst.bizGrid.grdMain.cancel();
						bizPerformFcst.bizGrid.dataProvider.setRows(data.resList);
						bizPerformFcst.bizGrid.dataProvider.clearSavePoints();
						bizPerformFcst.bizGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(bizPerformFcst.bizGrid.dataProvider.getRowCount());
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		initSearch : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{outDs : "res", _siq : "snop.bizKpi.bizPerformInit"}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				async   : false,
				success : function (data) {
					bizPerformFcst._initVar = data.res[0];
					actMonth = Number(data.res[0].ACT_MONTH);
					curMonth = Number(data.res[0].CUR_MONTH);
				}
			}
			
			gfn_service(aOption, "obj");
		},
	};
	
	/********************************************************************************************************
	** 조회 
	********************************************************************************************************/
	var fn_apply = function (sqlFlag) {
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		
		FORM_SEARCH     = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH.meaList    = MEASURE.user;
		FORM_SEARCH.sql = sqlFlag;
		
		bizPerformFcst.search();
		bizPerformFcst.excelSubSearch();
	}

	/********************************************************************************************************
	** onload  
	********************************************************************************************************/
	$(document).ready(function() {
		bizPerformFcst.init();
	});

	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp"%>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%-- <%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%> --%>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divRepCustGroup"></div>
				</div>
				<div class="bt_btn">
					<a href="#" class="fl_app" id="btnSearch"><spring:message code="lbl.search" /></a>
				</div>
			</div>
		</div>
		</form>
	</div>
	
	<div id="b" class="split split-horizontal">
		<!-- contents -->
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp"%>
			
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" class="realgrid1"></div>
			</div>
		</div>
	</div>
</body>
</html>
