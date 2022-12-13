<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>

	<script type="text/javascript">
	var enterSearchFlag = "Y";
	var actMonth = 1;
	var curMonth = 1;
	var product = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.prodGrid.initGrid();
		},
		
		_siq : "snop.bizKpi.",
		
		initFilter : function() {
			gfn_setMsComboAll([
				{ target : 'divYear', id : 'year', title : '<spring:message code="lbl.year"/>', data : this.comCode.codeMap.YEAR_INFO, exData:[  ], type : "S" }
			]);
		},
		
		comCode : {
			codeMap     : null,
			
			initCode : function () {
				gfn_service({
					async   : false,
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : {_mtd:"getList",tranData:[
						{outDs:"yearList" , _siq : product._siq + "productivityYear"},
					]},
					success : function(data) {
						product.comCode.codeMap = [];
						product.comCode.codeMap.YEAR_INFO = data.yearList;
					}
				}, "obj");
			}
		},

		/********************************************************************************************************
		** grid  선언  
		********************************************************************************************************/
		prodGrid : {
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
				this.gridEvents();
			},
			
			setColumn : function () {
				var totAr =  ['BU_NM', 'DIV_NM', 'TEAM_NM', 'PART_NM', 'MEAS_NM'];
				
				var dnmStyle1 = [
					{
						criteria : [
							"((values['DIV_NM'] = 'Sub Total') and (values['MEAS_CD'] = 'AMT_PROD'))",
							"((values['DIV_NM'] = 'Sub Total') and (values['MEAS_CD'] = 'WORK_PEOPLE'))",
							"((values['DIV_NM'] = 'Sub Total') and (values['MEAS_CD'] = 'WORK_TIME'))",
							"((values['DIV_NM'] = 'Sub Total') and (values['MEAS_CD'] = 'PEOPLE_PROD'))",
							"((values['DIV_NM'] = 'Sub Total') and (values['MEAS_CD'] = 'TIME_PROD'))",
							"((values['DIV_NM'] = 'Sub Total') and (values['MEAS_CD'] = 'QTY_PERFORM'))",
							
							"((values['PART_NM'] = 'Sub Total') and (values['MEAS_CD'] = 'AMT_PROD'))",
							"((values['PART_NM'] = 'Sub Total') and (values['MEAS_CD'] = 'WORK_PEOPLE'))",
							"((values['PART_NM'] = 'Sub Total') and (values['MEAS_CD'] = 'WORK_TIME'))",
							"((values['PART_NM'] = 'Sub Total') and (values['MEAS_CD'] = 'PEOPLE_PROD'))",
							"((values['PART_NM'] = 'Sub Total') and (values['MEAS_CD'] = 'TIME_PROD'))",
							"((values['PART_NM'] = 'Sub Total') and (values['MEAS_CD'] = 'QTY_PERFORM'))",
							
							"((values['PART_NM'] <> '') and (values['PART_NM'] <> 'Sub Total') and (values['MEAS_CD'] = 'AMT_PROD'))",
							"((values['PART_NM'] <> '') and (values['PART_NM'] <> 'Sub Total') and (values['MEAS_CD'] = 'WORK_PEOPLE'))",
							"((values['PART_NM'] <> '') and (values['PART_NM'] <> 'Sub Total') and (values['MEAS_CD'] = 'WORK_TIME'))",
							"((values['PART_NM'] <> '') and (values['PART_NM'] <> 'Sub Total') and (values['MEAS_CD'] = 'PEOPLE_PROD'))",
							"((values['PART_NM'] <> '') and (values['PART_NM'] <> 'Sub Total') and (values['MEAS_CD'] = 'TIME_PROD'))",
							"((values['PART_NM'] <> '') and (values['PART_NM'] <> 'Sub Total') and (values['MEAS_CD'] = 'QTY_PERFORM'))"
						],
						styles : [
							"background=#edf7fd;numberFormat=#,##0", 
							"background=#edf7fd;numberFormat=#,##0", 
							"background=#edf7fd;numberFormat=#,##0", 
							"background=#edf7fd;numberFormat=#,##0.0", 
							"background=#edf7fd;numberFormat=#,##0.0",
							"background=#edf7fd;numberFormat=#,##0",
							
							"background=#fbffec;numberFormat=#,##0", 
							"background=#fbffec;numberFormat=#,##0", 
							"background=#fbffec;numberFormat=#,##0", 
							"background=#fbffec;numberFormat=#,##0.0", 
							"background=#fbffec;numberFormat=#,##0.0",
							"background=#fbffec;numberFormat=#,##0",
							
							"background=#EAEAEA;numberFormat=#,##0", 
							"background=#F5F6CE;numberFormat=#,##0", 
							"background=#F5F6CE;numberFormat=#,##0", 
							"background=#EAEAEA;numberFormat=#,##0.0", 
							"background=#EAEAEA;numberFormat=#,##0.0",
							"background=#EAEAEA;numberFormat=#,##0"
						]
					}
				];
				
				var columns = [
					{
						name      : "BU_NM",
						fieldName : "BU_NM",
						header    : {text : '<spring:message code="lbl.buName"/>'},
						styles    : { textAlignment : "near", background : gfn_getArrDimColor(0)},
						mergeRule : { criteria : "values['BU_CD'] + value" },
						dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
						editable  : false,
						width     : 80
					},
					{
						name      : "DIV_NM",
						fieldName : "DIV_NM",
						header: {text: '<spring:message code="lbl.division"/>'},
						styles    : { textAlignment : "near", background : gfn_getArrDimColor(1)},
						mergeRule : { criteria : "values['DIV_CD'] + value" },
						dynamicStyles:[gfn_getDynamicStyle(1, totAr)],
						editable  : false,
						width     : 80
					},
					{
						name      : "TEAM_NM",
						fieldName : "TEAM_NM",
						header: {text: '<spring:message code="lbl.team"/>'},
						styles    : { textAlignment : "near", background : gfn_getArrDimColor(2)},
						mergeRule : { criteria : "values['TEAM_CD'] + value" },
						dynamicStyles:[gfn_getDynamicStyle(2, totAr)],
						editable  : false,
						width     : 80
					},
					{
						name      : "PART_NM",
						fieldName : "PART_NM",
						header: {text: '<spring:message code="lbl.part"/>'},
						styles    : { textAlignment : "near", background : gfn_getArrDimColor(3)},
						dynamicStyles:[gfn_getDynamicStyle(3, totAr)],
						mergeRule : { criteria : "values['PART_CD'] + value" },
						editable  : false,
						width     : 80
					},
					{
						name      : "MEAS_NM",
						fieldName : "MEAS_NM",
						header    : {text : '<spring:message code="lbl.measureName"/>'},
						styles    : {textAlignment : "near", background : gfn_getArrDimColor(4)},
						dynamicStyles:[gfn_getDynamicStyle(4, totAr)],
						editable  : false,
						width     : 90
					},
					
					{
						name      : "M01", 
						fieldName : "M01", 
						header    : {text: '<spring:message code="lbl.january" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0.0", background : gv_noneEditColor},
						dynamicStyles : dnmStyle1,
						editor    : { type : "number", textAlignment : "far", editFormat : "#,##0", positiveOnly : true},
						editable  : false,
						dataType  : "number",
						width     : 90
					},
					{
						name      : "M02", 
						fieldName : "M02", 
						header    : {text: '<spring:message code="lbl.february" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0.0", background : gv_noneEditColor},
						dynamicStyles : dnmStyle1,
						editor    : { type : "number", textAlignment : "far", editFormat : "#,##0", positiveOnly : true},
						editable  : false,
						dataType  : "number",
						width     : 90
					}, 
					{
						name      : "M03", 
						fieldName : "M03",  
						header    : {text: '<spring:message code="lbl.march" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0.0", background : gv_noneEditColor},
						dynamicStyles : dnmStyle1,
						editor    : { type : "number", textAlignment : "far", editFormat : "#,##0", positiveOnly : true},
						editable  : false,
						dataType  : "number",
						width     : 90
					}, 
					{
						name      : "M04", 
						fieldName : "M04", 
						header    : {text: '<spring:message code="lbl.april" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0.0", background : gv_noneEditColor},
						dynamicStyles : dnmStyle1,
						editor    : { type : "number", textAlignment : "far", editFormat : "#,##0", positiveOnly : true},
						editable  : false,
						dataType  : "number",
						width     : 90
					}, 
					{
						name      : "M05", 
						fieldName : "M05", 
						header    : {text: '<spring:message code="lbl.may" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0.0", background : gv_noneEditColor},
						dynamicStyles : dnmStyle1,
						editor    : { type : "number", textAlignment : "far", editFormat : "#,##0", positiveOnly : true},
						editable  : false,
						dataType  : "number",
						width     : 90
					}, 
					{
						name      : "M06", 
						fieldName : "M06",  
						header    : {text: '<spring:message code="lbl.june" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0.0", background : gv_noneEditColor},
						dynamicStyles : dnmStyle1,
						editor    : { type : "number", textAlignment : "far", editFormat : "#,##0", positiveOnly : true},
						editable  : false,
						dataType  : "number",
						width     : 90
					}, 
					{
						name      : "M07", 
						fieldName : "M07", 
						header    : {text: '<spring:message code="lbl.july" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0.0", background : gv_noneEditColor},
						dynamicStyles : dnmStyle1,
						editor    : { type : "number", textAlignment : "far", editFormat : "#,##0", positiveOnly : true},
						editable  : false,
						dataType  : "number",
						width     : 90
					}, 
					{
						name      : "M08", 
						fieldName : "M08", 
						header    : {text: '<spring:message code="lbl.august" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0.0", background : gv_noneEditColor},
						dynamicStyles : dnmStyle1,
						editor    : { type : "number", textAlignment : "far", editFormat : "#,##0", positiveOnly : true},
						editable  : false,
						dataType  : "number",
						width     : 90
					}, 
					{
						name      : "M09", 
						fieldName : "M09",  
						header    : {text: '<spring:message code="lbl.september" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0.0", background : gv_noneEditColor},
						dynamicStyles : dnmStyle1,
						editor    : { type : "number", textAlignment : "far", editFormat : "#,##0", positiveOnly : true},
						editable  : false,
						dataType  : "number",
						width     : 90
					}, 
					{
						name      : "M10", 
						fieldName : "M10",  
						header    : {text: '<spring:message code="lbl.october" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0.0", background : gv_noneEditColor},
						dynamicStyles : dnmStyle1,
						editor    : { type : "number", textAlignment : "far", editFormat : "#,##0", positiveOnly : true},
						editable  : false,
						dataType  : "number",
						width     : 90
					}, 
					{
						name      : "M11", 
						fieldName : "M11",  
						header    : {text: '<spring:message code="lbl.november" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0.0", background : gv_noneEditColor},
						dynamicStyles : dnmStyle1,
						editor    : { type : "number", textAlignment : "far", editFormat : "#,##0", positiveOnly : true},
						editable  : false,
						dataType  : "number",
						width     : 90
					}, 
					{
						name      : "M12", 
						fieldName : "M12",  
						header    : {text: '<spring:message code="lbl.december" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0.0", background : gv_noneEditColor},
						dynamicStyles : dnmStyle1,
						editor    : { type : "number", textAlignment : "far", editFormat : "#,##0", positiveOnly : true},
						editable  : false,
						dataType  : "number",
						width     : 90
					}
				];
				
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols) {
				var fields = new Array();
				
				fields = [
					{ fieldName : "COMPANY_CD", dataType : "text" },
					{ fieldName : "BU_CD"     , dataType : "text" },
					{ fieldName : "BU_NM"     , dataType : "text" },
					{ fieldName : "DIV_CD"    , dataType : "text" },
					{ fieldName : "DIV_NM"    , dataType : "text" },
					{ fieldName : "TEAM_CD"   , dataType : "text" },
					{ fieldName : "TEAM_NM"   , dataType : "text" },
					{ fieldName : "PART_CD"   , dataType : "text" },
					{ fieldName : "PART_NM"   , dataType : "text" },
					{ fieldName : "MEAS_CD"   , dataType : "text" },
					{ fieldName : "MEAS_NM"   , dataType : "text" },
					{ fieldName : "M01"       , dataType : "number" },
					{ fieldName : "M02"       , dataType : "number" },
					{ fieldName : "M03"       , dataType : "number" },
					{ fieldName : "M04"       , dataType : "number" },
					{ fieldName : "M05"       , dataType : "number" },
					{ fieldName : "M06"       , dataType : "number" },
					{ fieldName : "M07"       , dataType : "number" },
					{ fieldName : "M08"       , dataType : "number" },
					{ fieldName : "M09"       , dataType : "number" },
					{ fieldName : "M10"       , dataType : "number" },
					{ fieldName : "M11"       , dataType : "number" },
					{ fieldName : "M12"       , dataType : "number" }
					
		        ];
				
				this.dataProvider.setFields(fields);
				
			},
			
			setOptions : function () {
				this.grdMain.setOptions({
					stateBar: { visible       : true  },
					sorting : { enabled      : false },
					display : { columnMovable: false }
				});
				
				this.dataProvider.setOptions({
					softDeleting : true
				});
				
				product.prodGrid.grdMain.addCellStyles([
					{ id : "editStyleRow", editable : true, background : gv_editColor },
					{ id : "nonEditStyleRow", editable : false, background : gv_noneEditColor }
				]);
			},
			
			gridCallback : function() {
				var month = ["M01","M02","M03","M04","M05","M06","M07","M08","M09","M10","M11","M12"];
				var monCnt = month.length;
				
				for (var i = 0; i < this.dataProvider.getRowCount(); i++) {
					var partCd = this.dataProvider.getValue(i, "PART_CD");
					var measCd = this.dataProvider.getValue(i, "MEAS_CD");
					
					if(partCd != undefined) {
						
						if(measCd == "WORK_PEOPLE" || measCd == "WORK_TIME") {
							
							for(var j=0; j < monCnt; j++) {
								product.prodGrid.grdMain.setCellStyles(i, month[j], "editStyleRow");
							}
						}
						
					}
				}
			},
			
			gridEvents   : function () {
				
			}
		},
		
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnReset").click("on", function() { fn_reset(); });
			$("#btnSave").click("on", function() { fn_save(); });
			
		}, 
		
		excelSubSearch : function (){
			
			$.each($(".view_combo"), function(i, val){
				
				var temp = "";
				var id = gfn_nvl($(this).attr("id"), "");
				
				if(id != ""){
					
					var name = gfn_nvl($("#" + id + " .ilist .itit").html(), "");
					
					if(name == ""){
						name = $("#" + id + " .filter_tit").html();
					}
					
					//타이틀
					if(i == 0){
						EXCEL_SEARCH_DATA = name + " : ";	
					}else{
						EXCEL_SEARCH_DATA += "\n" + name + " : ";	
					}
					
					//데이터
					if(id == "divYear"){
						EXCEL_SEARCH_DATA += $("#year option:selected").text();
					}
				}
			});
		},
		
		search : function () {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{outDs : "resList", _siq : product._siq + "productivity"}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						product.prodGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						product.prodGrid.grdMain.cancel();
						product.prodGrid.dataProvider.setRows(data.resList);
						
						product.prodGrid.dataProvider.clearSavePoints();
						product.prodGrid.dataProvider.savePoint(); //초기화 포인트 저장
						
						gfn_setSearchRow(product.prodGrid.dataProvider.getRowCount());
						
						product.prodGrid.gridCallback();
					}
				}
			}
			
			gfn_service(aOption, "obj");
		}
	};
	
	/********************************************************************************************************
	** 조회 
	********************************************************************************************************/
	var fn_apply = function (sqlFlag) {
		
		fn_checkClose();
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		
		FORM_SEARCH     = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH.meaList    = MEASURE.user;
		FORM_SEARCH.sql = sqlFlag;
		
		product.search();
		product.excelSubSearch();
	}
	
	//그리드 초기화
	function fn_reset() {
		product.prodGrid.grdMain.cancel();
		product.prodGrid.dataProvider.rollback(product.prodGrid.dataProvider.getSavePoints()[0]);
		product.prodGrid.gridCallback();
	}
	
	function fn_checkClose() {
		return gfn_getGrdSaveCount(product.prodGrid.grdMain) == 0;
	}
	
	//그리드 저장
	function fn_save() {
		//수정된 그리드 데이터
		var grdData = gfn_getGrdSavedataAll(product.prodGrid.grdMain);
		if (grdData.length == 0) {
			alert('<spring:message code="msg.noChangeData"/>');
			return;
		}
		
		// 저장
		confirm('<spring:message code="msg.saveCfm"/>', function() {
			FORM_SAVE          = {}; //초기화
			FORM_SAVE._mtd     = "saveAll";
			FORM_SAVE.year     = $("#year").val();
			FORM_SAVE.tranData = [{outDs:"saveCnt",_siq: product._siq + "productivity",grdData:grdData, mergeFlag : "Y"}];
			
			gfn_service({
				url    : GV_CONTEXT_PATH + "/biz/obj",
				data   : FORM_SAVE,
				success: function(data) {
					alert('<spring:message code="msg.saveOk"/>');
					fn_apply();
				}
			}, "obj");
		});
	}
	
	/********************************************************************************************************
	** onload  
	********************************************************************************************************/
	$(document).ready(function() {
		product.init();
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
					<div class="view_combo" id="divYear"></div>
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
			<div class="cbt_btn">
				<div class="bright">
					<a href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset"/></a>
					<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save"/></a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
