<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>
<script type="text/javascript" src="${ctx}/statics/js/biz/gridcalc.js" ></script>
<!-- BSC 품질 -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	
	var bscSnop = {

		init : function () {
			
			gfn_formLoad();
			
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.bscGrid.initGrid();
			
			MONTHPICKER(null, 0, 0);
			var baseDt = new Date();
			
			$("#fromMon").monthpicker("option", "maxDate", new Date(baseDt.getFullYear(), baseDt.getMonth(), '01'));
			
		},
			
		_siq    : "bsc.bscSnop",
		
		initFilter : function() {
			gfn_setMsComboAll([
				{target : 'divMonthAcc', id : 'rdoAqType', title : '<spring:message code="lbl.monthAccFlag"/>', data : this.comCode.codeMap.MONTH_ACC_TYPE, exData:[""], type : "R"},
				{target : 'divHiddenFlag', id : 'hiddenFlag', title : '<spring:message code="lbl.hiddenFlag"/>', data : this.comCode.codeMap.HIDDEN_CD, exData:[""], type : "R"}
			]);
			
			$(':radio[name=rdoAqType]:input[value="MON"]').attr("checked", true);
			$(':radio[name=hiddenFlag]:input[value="Y"]').attr("checked", true);
		},
		
		comCode : {
			codeMap : null,
			codeReptMap : null,
			
			initCode : function () {
				var grpCd = 'MONTH_ACC_TYPE,HIDDEN_CD';
				this.codeMap = gfn_getComCode(grpCd, 'N'); //공통코드 조회
			}
		},
		
		/* 
		* grid  선언
		*/
		bscGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;

				this.setColumn();
				this.setFields();
				this.setOptions();
			},
			
			setColumn     : function () {
				var totAr =  ['BU_NM', 'DIV_NM', 'TEAM_NM', 'PART_NM'];
				var columns = 
				[
					{ 
						type      : "group",
						name      : "DIV", 
						header    : { fixedHeight : 20, text : "구분" },
						width     : 460, 
						columns   : [
							{
								name      : "BU_NM", 
								fieldName : "BU_NM", 
								header    : { text : "<spring:message code='BU_CD'/>" }, 
								styles    : { textAlignment : "near", background : gfn_getArrDimColor(0)},
								mergeRule : { criteria : "values['BU_CD'] + value" },
								dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
								width     : 100, 
								editable  : false 
							}, {
								name      : "DIV_NM", 
								fieldName : "DIV_NM", 
								header    : { text : "<spring:message code='DIV_CD'/>" }, 
								styles    : { textAlignment : "near", background : gfn_getArrDimColor(1)},
								mergeRule : { criteria : "values['DIV_CD'] + value" },
								dynamicStyles:[gfn_getDynamicStyle(1, totAr)],
								width     : 150, 
								editable  : false 
							}, {
								name      : "TEAM_NM", 
								fieldName : "TEAM_NM", 
								header    : { text : "<spring:message code='TEAM_CD'/>" }, 
								styles    : { textAlignment : "near", background : gfn_getArrDimColor(2)},
								mergeRule : { criteria : "values['TEAM_CD'] + value" },
								dynamicStyles:[gfn_getDynamicStyle(2, totAr)],
								width     : 130, 
								editable  : false 
							}, {
								name      : "PART_NM", 
								fieldName : "PART_NM", 
								header    : { text : "<spring:message code='PART_CD'/>" }, 
								styles    : { textAlignment : "near", background : gfn_getArrDimColor(3)},
								dynamicStyles:[gfn_getDynamicStyle(3, totAr)],
								mergeRule : { criteria : "values['PART_CD'] + value" },
								width     : 80, 
								editable  : false 
							}
						]
					}, { 
						type      : "group",
						name      : "SALES_PLAN", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.spcr'/>" },
						width     : 320, 
						columns   : [
							{
								name      : "KPI8_WEIGHT_RATE", 
								fieldName : "KPI8_WEIGHT_RATE", 
								header    : { text : "<spring:message code='lbl.weighted'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI8_TARGET_VALUE_01", 
								fieldName : "KPI8_TARGET_VALUE_01", 
								header    : { text : "<spring:message code='lbl.target'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##00", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI8_RESULT_RATE", 
								fieldName : "KPI8_RESULT_RATE", 
								header    : { text : "<spring:message code='lbl.actual'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI8_BSC_VAL", 
								fieldName : "KPI8_BSC_VAL", 
								header    : { text : "<spring:message code='lbl.bscScore'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}
						]
					}, { 
						type      : "group",
						name      : "PRE_MONTH", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.mthr'/>" },
						width     : 320, 
						columns   : [
							{
								name      : "KPI9_WEIGHT_RATE", 
								fieldName : "KPI9_WEIGHT_RATE", 
								header    : { text : "<spring:message code='lbl.weighted'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI9_TARGET_VALUE_01", 
								fieldName : "KPI9_TARGET_VALUE_01", 
								header    : { text : "<spring:message code='lbl.target'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.00", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI9_RESULT_RATE", 
								fieldName : "KPI9_RESULT_RATE", 
								header    : { text : "<spring:message code='lbl.actual'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI9_BSC_VAL", 
								fieldName : "KPI9_BSC_VAL", 
								header    : { text : "<spring:message code='lbl.bscScore'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}
						]
					}, { 
						type      : "group",
						name      : "M3_MONTH", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.mtar'/>" },
						width     : 320, 
						columns   : [
							{
								name      : "KPI10_WEIGHT_RATE", 
								fieldName : "KPI10_WEIGHT_RATE", 
								header    : { text : "<spring:message code='lbl.weighted'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI10_TARGET_VALUE_01", 
								fieldName : "KPI10_TARGET_VALUE_01", 
								header    : { text : "<spring:message code='lbl.target'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.00", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI10_RESULT_RATE", 
								fieldName : "KPI10_RESULT_RATE", 
								header    : { text : "<spring:message code='lbl.actual'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI10_BSC_VAL", 
								fieldName : "KPI10_BSC_VAL", 
								header    : { text : "<spring:message code='lbl.bscScore'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}
						]
					}, { 
						type      : "group",
						name      : "PROD_PLAN", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.ppcr'/>" },
						width     : 320, 
						columns   : [
							{
								name      : "KPI11_WEIGHT_RATE", 
								fieldName : "KPI11_WEIGHT_RATE", 
								header    : { text : "<spring:message code='lbl.weighted'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI11_TARGET_VALUE_01", 
								fieldName : "KPI11_TARGET_VALUE_01", 
								header    : { text : "<spring:message code='lbl.target'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.00", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI11_RESULT_RATE", 
								fieldName : "KPI11_RESULT_RATE", 
								header    : { text : "<spring:message code='lbl.actual'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI11_BSC_VAL", 
								fieldName : "KPI11_BSC_VAL", 
								header    : { text : "<spring:message code='lbl.bscScore'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}
						]
					}, { 
						type      : "group",
						name      : "MAT", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.mpr'/>" },
						width     : 320, 
						columns   : [
							{
								name      : "KPI12_WEIGHT_RATE", 
								fieldName : "KPI12_WEIGHT_RATE", 
								header    : { text : "<spring:message code='lbl.weighted'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI12_TARGET_VALUE_01", 
								fieldName : "KPI12_TARGET_VALUE_01", 
								header    : { text : "<spring:message code='lbl.target'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.00", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI12_RESULT_RATE", 
								fieldName : "KPI12_RESULT_RATE", 
								header    : { text : "<spring:message code='lbl.actual'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI12_BSC_VAL", 
								fieldName : "KPI12_BSC_VAL", 
								header    : { text : "<spring:message code='lbl.bscScore'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}
						]
					}, { 
						type      : "group",
						name      : "PRO_DAY", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.wipt'/>" },
						width     : 320, 
						columns   : [
							{
								name      : "KPI13_WEIGHT_RATE", 
								fieldName : "KPI13_WEIGHT_RATE", 
								header    : { text : "<spring:message code='lbl.weighted'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI13_TARGET_VALUE_01", 
								fieldName : "KPI13_TARGET_VALUE_01", 
								header    : { text : "<spring:message code='lbl.goalDays'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.00", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI13_TARGET_VALUE_02", 
								fieldName : "KPI13_TARGET_VALUE_02", 
								header    : { text : "<spring:message code='lbl.goalRate'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.00", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI13_RESULT_RATE", 
								fieldName : "KPI13_RESULT_RATE", 
								header    : { text : "<spring:message code='lbl.actual'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI13_BSC_VAL", 
								fieldName : "KPI13_BSC_VAL", 
								header    : { text : "<spring:message code='lbl.bscScore'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}
						]
					}, { 
						type      : "group",
						name      : "SNOP_ALL", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.snopTotal'/>" },
						width     : 200, 
						columns   : [
							{
								name      : "SNOP_WEIGHT_RATE", 
								fieldName : "SNOP_WEIGHT_RATE", 
								header    : { text : "<spring:message code='lbl.weighted'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 100, 
								editable  : false 
							}, {
								name      : "SNOP_BSC_VAL", 
								fieldName : "SNOP_BSC_VAL", 
								header    : { text : "<spring:message code='lbl.bscScore'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 100, 
								editable  : false 
							}
						]
					}
				];
				
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols) {
				
				var fields = new Array();
				
				fields = [
					{ fieldName : "YEARMONTH"     , dataType : "text"},
					{ fieldName : "GRP_LVL_ID"    , dataType : "text"},
					{ fieldName : "BU_CD"         , dataType : "text"},
					{ fieldName : "BU_NM"         , dataType : "text"},
					{ fieldName : "DIV_CD"        , dataType : "text"},
					{ fieldName : "DIV_NM"        , dataType : "text"},
					{ fieldName : "TEAM_CD"       , dataType : "text"},
					{ fieldName : "TEAM_NM"       , dataType : "text"},
					{ fieldName : "PART_CD"       , dataType : "text"},
					{ fieldName : "PART_NM"       , dataType : "text"},
					
					{ fieldName : "KPI8_EDIT_YN"  , dataType : "text"},
					{ fieldName : "KPI9_EDIT_YN"  , dataType : "text"},
					{ fieldName : "KPI10_EDIT_YN" , dataType : "text"},
					{ fieldName : "KPI11_EDIT_YN" , dataType : "text"},
					{ fieldName : "KPI12_EDIT_YN" , dataType : "text"},
					{ fieldName : "KPI13_EDIT_YN" , dataType : "text"},
					
					{ fieldName : "KPI8_WEIGHT_RATE"     , dataType : "number"},
					{ fieldName : "KPI8_TARGET_VALUE_01" , dataType : "number"},
					{ fieldName : "KPI8_RESULT_RATE" 	 , dataType : "number"},
					{ fieldName : "KPI8_BSC_VAL"         , dataType : "number"},
					{ fieldName : "KPI8_BILL_RESULT"     , dataType : "number"},
					
					{ fieldName : "KPI9_WEIGHT_RATE"     , dataType : "number"},
					{ fieldName : "KPI9_TARGET_VALUE_01" , dataType : "number"},
					{ fieldName : "KPI9_RESULT_RATE" 	 , dataType : "number"},
					{ fieldName : "KPI9_BSC_VAL"         , dataType : "number"},
					{ fieldName : "KPI9_BILL_RESULT"     , dataType : "number"},
					
					{ fieldName : "KPI10_WEIGHT_RATE"     , dataType : "number"},
					{ fieldName : "KPI10_TARGET_VALUE_01" , dataType : "number"},
					{ fieldName : "KPI10_RESULT_RATE" 	  , dataType : "number"},
					{ fieldName : "KPI10_BSC_VAL"         , dataType : "number"},
					{ fieldName : "KPI10_BILL_RESULT"     , dataType : "number"},
					
					{ fieldName : "KPI11_WEIGHT_RATE"     , dataType : "number"},
					{ fieldName : "KPI11_TARGET_VALUE_01" , dataType : "number"},
					{ fieldName : "KPI11_RESULT_RATE" 	  , dataType : "number"},
					{ fieldName : "KPI11_BSC_VAL"         , dataType : "number"},
					{ fieldName : "KPI11_BILL_RESULT"     , dataType : "number"},
					
					{ fieldName : "KPI12_WEIGHT_RATE"     , dataType : "number"},
					{ fieldName : "KPI12_TARGET_VALUE_01" , dataType : "number"},
					{ fieldName : "KPI12_RESULT_RATE" 	  , dataType : "number"},
					{ fieldName : "KPI12_BSC_VAL"         , dataType : "number"},
					{ fieldName : "KPI12_BILL_RESULT"     , dataType : "number"},
					
					{ fieldName : "KPI13_WEIGHT_RATE"     , dataType : "number"},
					{ fieldName : "KPI13_TARGET_VALUE_01" , dataType : "number"},
					{ fieldName : "KPI13_TARGET_VALUE_02" , dataType : "number"},
					{ fieldName : "KPI13_RESULT_RATE" 	  , dataType : "number"},
					{ fieldName : "KPI13_BSC_VAL"         , dataType : "number"},
					{ fieldName : "KPI13_BILL_RESULT"     , dataType : "number"},
					
					{ fieldName : "SNOP_WEIGHT_RATE"     , dataType : "number"},
					{ fieldName : "SNOP_BSC_VAL"         , dataType : "number"},
				];
				
				this.dataProvider.setFields(fields);
			},
			
			setOptions : function () {
				this.grdMain.setOptions({
					stateBar: { visible      : true  },
					sorting : { enabled      : false },
					display : { columnMovable: false }
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
				
				
				var group = this.grdMain.columnByName("DIV");
				if (group) {
					var hide = !this.grdMain.getColumnProperty(group, "hideChildHeaders");
					this.grdMain.setColumnProperty(group, "hideChildHeaders", hide);
				}
				
				var valArray = ["SALES_PLAN", "KPI8_WEIGHT_RATE", "KPI8_TARGET_VALUE_01", "KPI8_RESULT_RATE", "KPI8_BSC_VAL", "M3_MONTH", "KPI10_WEIGHT_RATE", "KPI10_TARGET_VALUE_01", "KPI10_RESULT_RATE", "KPI10_BSC_VAL", "MAT", "KPI12_WEIGHT_RATE", "KPI12_TARGET_VALUE_01", "KPI12_RESULT_RATE", "KPI12_BSC_VAL", "SNOP_ALL", "SNOP_WEIGHT_RATE", "SNOP_BSC_VAL"];
				var valArrayLen = valArray.length;
				
				for(var i = 0; i < valArrayLen; i++){
					var val = valArray[i];
					
					var setHeader = this.grdMain.getColumnProperty(val, "header");
					setHeader.styles = {background: gv_headerColor};
					this.grdMain.setColumnProperty(val, "header", setHeader);
				}
				
			},
			
			gridCallback : function () {
				
				var baseDt = new Date();
				var yymm = baseDt.getFullYear() + '' + (baseDt.getMonth() + 1 < 10 ? '0' + (baseDt.getMonth() + 1) : baseDt.getMonth() + 1);
				var yymmBefore = baseDt.getFullYear() + '' + (baseDt.getMonth() + 1 < 10 ? '0' + (baseDt.getMonth()) : baseDt.getMonth());
				var tFromMon = FORM_SEARCH.fromMon;
				var tRdoAqType = $('input:radio[name="rdoAqType"]:checked').val();
				var tHiddenFlag = $('input:radio[name="hiddenFlag"]:checked').val();
				
				if (!(yymm == tFromMon || yymmBefore == tFromMon) || tRdoAqType == "ACC") {
					return false;
				}
				
				var cols     = this.grdMain.getColumnNames();
				var targetAr1 = new Array();
				var targetAr2 = new Array();
				var targetAr3 = new Array();
				var targetAr4 = new Array();
				var targetAr5 = new Array();
				var targetAr6 = new Array();
				var targetAr7 = new Array();
				var arrIdx1   = new Array();
				var arrIdx2   = new Array();
				var arrIdx3   = new Array();
				var arrIdx4   = new Array();
				var arrIdx5   = new Array();
				var arrIdx6  = new Array();
				var arrIdx7   = new Array();
				
				var subTotalFlag = "N";
				var hiddenRow = new Array();
				
				for (var i = 0; i < this.dataProvider.getRowCount(); i++) {
					
					var tGrpLvlId = this.dataProvider.getValue(i, "GRP_LVL_ID");
					var tBuCd = this.dataProvider.getValue(i, "BU_CD");
					var tQcBscVal = isNaN(Number(this.dataProvider.getValue(i, "SNOP_BSC_VAL")));
					
					// 조건
					if (this.dataProvider.getValue(i, "GRP_LVL_ID") == '0') {
						arrIdx1.push(i);
						
						if (this.dataProvider.getValue(i, "KPI8_EDIT_YN") != 'N') {
							arrIdx2.push(i);
						}
						if (this.dataProvider.getValue(i, "KPI9_EDIT_YN") != 'N') {
							arrIdx3.push(i);
						}
						if (this.dataProvider.getValue(i, "KPI10_EDIT_YN") != 'N') {
							arrIdx4.push(i);
						}
						if (this.dataProvider.getValue(i, "KPI11_EDIT_YN") != 'N') {
							arrIdx5.push(i);
						}
						if (this.dataProvider.getValue(i, "KPI12_EDIT_YN") != 'N') {
							arrIdx6.push(i);
						}
						if (this.dataProvider.getValue(i, "KPI13_EDIT_YN") != 'N') {
							arrIdx7.push(i);
						}
					} 
					
					if(tHiddenFlag == "Y"){
						//본부 로우 hidden 하기
						if(tBuCd == "QT"){ //사업부가 1개이상인 경우
							if(tGrpLvlId != "7"){
								if(tGrpLvlId == "3"){
									
									subTotalFlag = "N";
									
									if(tQcBscVal == true){
										subTotalFlag = "Y";
										hiddenRow.push(i);
									}
								}else{
									if(subTotalFlag == "Y"){
										hiddenRow.push(i);
									}
								}
							}	
						}else{ //사업부가 1개인 경우
							if(tGrpLvlId == "7"){
								
								subTotalFlag = "N";
								
								if(tQcBscVal == true){
									subTotalFlag = "Y";
									hiddenRow.push(i);
								}
							}else{
								if(subTotalFlag == "Y"){
									hiddenRow.push(i);
								}
							}
						}						
					}
				} 
				
				for (var j = 0; j < cols.length; j++) {
					
					if (cols[j].indexOf("_WEIGHT_RATE") > -1 && cols[j] != "SNOP_WEIGHT_RATE") {
						targetAr1.push(cols[j])
					}
					if (cols[j].indexOf("KPI8_TARGET_VALUE_01") > -1) {
						targetAr2.push(cols[j])
					}
					if (cols[j].indexOf("KPI9_TARGET_VALUE_01") > -1) {
						targetAr3.push(cols[j])
					}
					if (cols[j].indexOf("KPI10_TARGET_VALUE_01") > -1) {
						targetAr4.push(cols[j])
					}
					if (cols[j].indexOf("KPI11_TARGET_VALUE_01") > -1) {
						targetAr5.push(cols[j])
					}
					if (cols[j].indexOf("KPI12_TARGET_VALUE_01") > -1) {
						targetAr6.push(cols[j])
					}
					if (cols[j].indexOf("KPI13_TARGET_VALUE") > -1) {
						targetAr7.push(cols[j])
					}
				}
			
				this.grdMain.setCellStyles(arrIdx1, targetAr1 , "editStyle");
				
				if (arrIdx2.length > 0) {
					this.grdMain.setCellStyles(arrIdx2, targetAr2 , "editStyle");
				}
				if (arrIdx3.length > 0) {
					this.grdMain.setCellStyles(arrIdx3, targetAr3 , "editStyle");
				}
				if (arrIdx4.length > 0) {
					this.grdMain.setCellStyles(arrIdx4, targetAr4 , "editStyle");
				}
				if (arrIdx5.length > 0) {
					this.grdMain.setCellStyles(arrIdx5, targetAr5 , "editStyle");
				}
				if (arrIdx6.length > 0) {
					this.grdMain.setCellStyles(arrIdx6, targetAr6 , "editStyle");
				}
				if (arrIdx7.length > 0) {
					this.grdMain.setCellStyles(arrIdx7, targetAr7 , "editStyle");
				}
				
				if(tHiddenFlag == "Y"){
					this.dataProvider.hideRows(hiddenRow);					
				}
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnSave").on('click', function (e) {
				bscSnop.save();
			});
			
			$("#btnReset").on('click', function (e) {
				bscSnop.bscGrid.grdMain.cancel();
				bscSnop.bscGrid.dataProvider.rollback(bscSnop.bscGrid.dataProvider.getSavePoints()[0]);
				bscSnop.bscGrid.gridCallback();
			});
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
					if(id == "divMonthAcc"){
						var monthAcc = $('input[name="rdoAqType"]:checked').val();
						
						if(monthAcc == "MON"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.thisMonth"/>';
						}else if(monthAcc == "ACC"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.cumulative"/>';
						}
					}else if(id == "divHiddenFlag"){
						var hiddenFlag = $('input[name="hiddenFlag"]:checked').val();
						
						if(hiddenFlag == "Y"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.unMarked"/>';
						}else if(hiddenFlag == "N"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.marked"/>';
						}
					}else if(id == "divMonth"){
						EXCEL_SEARCH_DATA += $("#fromMon").val();			
					}
				}
			});
			
			//console.log(EXCEL_SEARCH_DATA);
		},
		
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						bscSnop.bscGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						bscSnop.bscGrid.grdMain.cancel();
						
						bscSnop.bscGrid.dataProvider.setRows(data.resList);
						bscSnop.bscGrid.dataProvider.clearSavePoints();
						bscSnop.bscGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(bscSnop.bscGrid.dataProvider.getRowCount());
						
						bscSnop.bscGrid.gridInstance.setFocusKeys();
						bscSnop.bscGrid.gridCallback();
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		save : function() {
			
			var grdData = gfn_getGrdSavedataAll(this.bscGrid.grdMain);
			if (grdData.length == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}

				
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
					
				var data = gfn_getGrdSavedataAll(bscSnop.bscGrid.grdMain);
				var jsonData = [];
				$.each(data, function (i, jd) {
					if (jd.GRP_LVL_ID == '0') {
						jsonData.push(jd);
					}
				});
				
				FORM_SAVE = {}; //초기화
				FORM_SAVE._mtd   = "saveUpdate";
				FORM_SAVE.tranData = [{outDs:"saveCnt",_siq : bscSnop._siq, grdData : [{rowList : jsonData}]}];
				
				/* FORM_SAVE._mtd   = "saveAll";
				FORM_SAVE.tranData = [{outDs:"saveCnt",_siq : bscSnop._siq, grdData : jsonData, mergeFlag : "Y"}]; */
				
				gfn_service({
					url    : GV_CONTEXT_PATH + "/biz/obj",
					data   : FORM_SAVE,
					success: function(data) {
						alert('<spring:message code="msg.saveOk"/>');
						fn_apply();
					}
				}, "obj");
				
			});
		},
	};

	//조회
	var fn_apply = function (sqlFlag) {
		
		FORM_SEARCH     = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH.sql = sqlFlag;
		
		bscSnop.search();
		bscSnop.excelSubSearch();
	}
	
	function fn_checkClose() {
		return gfn_getGrdSaveCount(bscSnop.bscGrid.grdMain) == 0;
	}

	// onload 
	$(document).ready(function() {
		bscSnop.init();
	});

	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp"%>
	<!-- contents -->
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%-- <%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%> --%>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divMonthAcc"></div>
					<div class="view_combo" id="divHiddenFlag"></div>
					<div class="view_combo" id="divMonth">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.month" />  </div>
							<input type="text" id="fromMon" name="fromMon" class="iptdate datepicker2 monthpicker" value="">
						</div>
					</div>
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
			<!-- 하단버튼 영역 -->
			<div class="cbt_btn roleWrite">	
				<div class="bright">
					<a id="btnReset"       href="#" class="app1"><spring:message code="lbl.reset" /></a>  
					<a id="btnSave"        href="#" class="app2"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
