<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>
<!-- BSC 품질 -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var totAr =  ['BU_NM', 'DIV_NM', 'TEAM_NM', 'PART_NM'];
	var rowsPasteObj = [], changeMap = [];
	
	var scmScoreboard = {

		init : function () {
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.comCode.initCode();
			this.events();
			this.grid.initGrid();
			
			MONTHPICKER(null, 0, 0);
			var baseDt = new Date();
			$("#fromMon").monthpicker("option", "maxDate", new Date(baseDt.getFullYear(), baseDt.getMonth()-1, '01'));
		},
		
		
		comCode : {
			codeMap : null,
			
			initCode  : function () {
				this.codeMap = gfn_getComCode("BSC_GRADE_CD", 'N');
			}
		},
			
		_siq    : "snop.bizKpi.scmScoreboard",
		
		initFilter : function() {
			
			$(':radio[name=rdoAqType]:input[value="MON"]').attr("checked", true);
		},
		
		comCode : {
			codeMap : null,
			codeReptMap : null,
			
			initCode : function () {
				var grpCd = 'MONTH_ACC_TYPE';
				this.codeMap = gfn_getComCode(grpCd, 'N'); //공통코드 조회
			}
		},
		
		/* 
		* grid  선언
		*/
		grid : {
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
				var columns = 
				[
					{ 
						type      : "group",
						name      : "DIV", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.division'/>" },
						width     : 340, 
						columns   : [
							{
								name      : "BU_NM", 
								fieldName : "BU_NM", 
								header    : { text : "<spring:message code='BU_CD'/>" }, 
								styles    : { textAlignment : "near", background : gfn_getArrDimColor(0)},
								mergeRule : { criteria : "values['BU_CD'] + value" },
								dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "DIV_NM", 
								fieldName : "DIV_NM", 
								header    : { text : "<spring:message code='DIV_CD'/>" }, 
								styles    : { textAlignment : "near", background : gfn_getArrDimColor(1)},
								mergeRule : { criteria : "values['DIV_CD'] + value" },
								dynamicStyles:[gfn_getDynamicStyle(1, totAr)],
								width     : 110, 
								editable  : false 
							}, {
								name      : "TEAM_NM", 
								fieldName : "TEAM_NM", 
								header    : { text : "<spring:message code='TEAM_CD'/>" }, 
								styles    : { textAlignment : "near", background : gfn_getArrDimColor(2)},
								mergeRule : { criteria : "values['TEAM_CD'] + value" },
								dynamicStyles:[gfn_getDynamicStyle(2, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "PART_NM", 
								fieldName : "PART_NM", 
								header    : { text : "<spring:message code='PART_CD'/>" }, 
								styles    : { textAlignment : "near", background : gfn_getArrDimColor(3)},
								dynamicStyles:[gfn_getDynamicStyle(3, totAr)],
								mergeRule : { criteria : "values['PART_CD'] + value" },
								width     : 70, 
								editable  : false 
							}
						]
					}, { 
						type      : "group",
						name      : "ALL", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.total'/>" },
						width     : 100, 
						columns   : [
							{
								name      : "TOT_SCORE", 
								fieldName : "TOT_SCORE", 
								header    : { text : "<spring:message code='lbl.score'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 100, 
								editable  : false 
							}
						]
					}, { //계획 지수
						type      : "group",
						name      : "PLAN_INDEX_ALL", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.planIndex'/>" },
						width     : 800, 
						columns   : [
							{ // 계획지수합계
								type      : "group",
								name      : "PLAN_INDEX_SUB1", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.planIndexTotal'/>" },
								width     : 80,
								columns   : [
									{
										name      : "PLAN_SCORE", 
										fieldName : "PLAN_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							}, { // 출하 적중률
								type      : "group",
								name      : "PLAN_INDEX_SUB2", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.salesHittingRation'/>" },
								width     : 240,
								columns   : [
									{
										name      : "SCM01_TARGET", 
										fieldName : "SCM01_TARGET", 
										header    : { text : "<spring:message code='lbl.goal'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM01_RESULT", 
										fieldName : "SCM01_RESULT", 
										header    : { text : "<spring:message code='lbl.actual'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM01_SCORE", 
										fieldName : "SCM01_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							}, { // 공급능력지수
								type      : "group",
								name      : "PLAN_INDEX_SUB3", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.supplyCapacityRate'/>" },
								width     : 240,
								columns   : [
									{
										name      : "SCM02_TARGET", 
										fieldName : "SCM02_TARGET", 
										header    : { text : "<spring:message code='lbl.goal'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM02_RESULT", 
										fieldName : "SCM02_RESULT", 
										header    : { text : "<spring:message code='lbl.actual'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM02_SCORE", 
										fieldName : "SCM02_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							}, { // 자재 가용률
								type      : "group",
								name      : "PLAN_INDEX_SUB3", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.materialAva'/>" },
								width     : 240,
								columns   : [
									{
										name      : "SCM03_TARGET", 
										fieldName : "SCM03_TARGET", 
										header    : { text : "<spring:message code='lbl.goal'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM03_RESULT", 
										fieldName : "SCM03_RESULT", 
										header    : { text : "<spring:message code='lbl.actual'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM03_SCORE", 
										fieldName : "SCM03_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							},
						]
					}, { //실행 지수
						type      : "group",
						name      : "ACTION_INDEX_ALL", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.actionIndex'/>" },
						width     : 1280, 
						columns   : [
							{ // 실행지수합계
								type      : "group",
								name      : "ACTION_INDEX_SUB1", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.actionIndexTotal'/>" },
								width     : 80,
								columns   : [
									{
										name      : "ACTION_SCORE", 
										fieldName : "ACTION_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							}, { // 출하준수율
								type      : "group",
								name      : "ACTION_INDEX_SUB2", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.salesCmplRateChart1'/>" },
								width     : 240,
								columns   : [
									{
										name      : "SCM04_TARGET", 
										fieldName : "SCM04_TARGET", 
										header    : { text : "<spring:message code='lbl.goal'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM04_RESULT", 
										fieldName : "SCM04_RESULT", 
										header    : { text : "<spring:message code='lbl.actual'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM04_SCORE", 
										fieldName : "SCM04_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							}, { //경영성과달성
								type      : "group",
								name      : "ACTION_INDEX_SUB3", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.achMangerPer'/>" },
								width     : 240,
								columns   : [
									{
										name      : "SCM05_TARGET", 
										fieldName : "SCM05_TARGET", 
										header    : { text : "<spring:message code='lbl.goal'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM05_RESULT", 
										fieldName : "SCM05_RESULT", 
										header    : { text : "<spring:message code='lbl.actual'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM05_SCORE", 
										fieldName : "SCM05_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							}, { // CPFR 실행률
								type      : "group",
								name      : "ACTION_INDEX_SUB4", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.cpfrActionRate'/>" },
								width     : 240,
								columns   : [
									{
										name      : "SCM06_TARGET", 
										fieldName : "SCM06_TARGET", 
										header    : { text : "<spring:message code='lbl.goal'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM06_RESULT", 
										fieldName : "SCM06_RESULT", 
										header    : { text : "<spring:message code='lbl.actual'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM06_SCORE", 
										fieldName : "SCM06_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							}, { // 생산 준수율
								type      : "group",
								name      : "ACTION_INDEX_SUB5", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.prodCmplRateChart1'/>" },
								width     : 240,
								columns   : [
									{
										name      : "SCM07_TARGET", 
										fieldName : "SCM07_TARGET", 
										header    : { text : "<spring:message code='lbl.goal'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM07_RESULT", 
										fieldName : "SCM07_RESULT", 
										header    : { text : "<spring:message code='lbl.actual'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM07_SCORE", 
										fieldName : "SCM07_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							}, { // 입고 준수율
								type      : "group",
								name      : "ACTION_INDEX_SUB6", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.warehousRate3'/>" },
								width     : 240,
								columns   : [
									{
										name      : "SCM08_TARGET", 
										fieldName : "SCM08_TARGET", 
										header    : { text : "<spring:message code='lbl.goal'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM08_RESULT", 
										fieldName : "SCM08_RESULT", 
										header    : { text : "<spring:message code='lbl.actual'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM08_SCORE", 
										fieldName : "SCM08_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							},
						]
					}, { //재고 지수
						type      : "group",
						name      : "INV_INDEX_ALL", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.invIndex'/>" },
						width     : 800, 
						columns   : [
							{ // 재고지수합계
								type      : "group",
								name      : "INV_INDEX_SUB1", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.invIndexTotal'/>" },
								width     : 80,
								columns   : [
									{
										name      : "INV_SCORE", 
										fieldName : "INV_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							}, { // 재고 금액
								type      : "group",
								name      : "INV_INDEX_SUB2", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.totalAmount'/>" },
								width     : 240,
								columns   : [
									{
										name      : "SCM09_TARGET", 
										fieldName : "SCM09_TARGET", 
										header    : { text : "<spring:message code='lbl.goal'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM09_RESULT", 
										fieldName : "SCM09_RESULT", 
										header    : { text : "<spring:message code='lbl.actual'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM09_SCORE", 
										fieldName : "SCM09_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							}, { // 재고 Again
								type      : "group",
								name      : "INV_INDEX_SUB3", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.invAgaing2'/>" },
								width     : 240,
								columns   : [
									{
										name      : "SCM10_TARGET", 
										fieldName : "SCM10_TARGET", 
										header    : { text : "<spring:message code='lbl.goal'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM10_RESULT", 
										fieldName : "SCM10_RESULT", 
										header    : { text : "<spring:message code='lbl.actual'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM10_SCORE", 
										fieldName : "SCM10_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							}, { // 재공 Again
								type      : "group",
								name      : "INV_INDEX_SUB4", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.trend22Chart'/>" },
								width     : 240,
								columns   : [
									{
										name      : "SCM11_TARGET", 
										fieldName : "SCM11_TARGET", 
										header    : { text : "<spring:message code='lbl.goal'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM11_RESULT", 
										fieldName : "SCM11_RESULT", 
										header    : { text : "<spring:message code='lbl.actual'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM11_SCORE", 
										fieldName : "SCM11_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							}
						]
					}, { //미래 준비 지수
						type      : "group",
						name      : "FUTURE_INDEX_ALL", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.futureIndex'/>" },
						width     : 1040, 
						columns   : [
							{ // 미래준비지수합계
								type      : "group",
								name      : "FUTURE_INDEX_SUB1", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.futureIndexTotal'/>" },
								width     : 80,
								columns   : [
									{
										name      : "FUTURE_SCORE", 
										fieldName : "FUTURE_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							}, { // 출하달성률
								type      : "group",
								name      : "FUTURE_INDEX_SUB2", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.achieRateChart4'/>" },
								width     : 240,
								columns   : [
									{
										name      : "SCM12_TARGET", 
										fieldName : "SCM12_TARGET", 
										header    : { text : "<spring:message code='lbl.goal'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM12_RESULT", 
										fieldName : "SCM12_RESULT", 
										header    : { text : "<spring:message code='lbl.actual'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM12_SCORE", 
										fieldName : "SCM12_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							}, { // 제조 LT
								type      : "group",
								name      : "FUTURE_INDEX_SUB3", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.lt'/>" },
								width     : 240,
								columns   : [
									{
										name      : "SCM13_TARGET", 
										fieldName : "SCM13_TARGET", 
										header    : { text : "<spring:message code='lbl.goal'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM13_RESULT", 
										fieldName : "SCM13_RESULT", 
										header    : { text : "<spring:message code='lbl.actual'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM13_SCORE", 
										fieldName : "SCM13_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							}, { // 제조 CAPA 준비
								type      : "group",
								name      : "FUTURE_INDEX_SUB4", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.prodCapa'/>" },
								width     : 240,
								columns   : [
									{
										name      : "SCM14_TARGET", 
										fieldName : "SCM14_TARGET", 
										header    : { text : "<spring:message code='lbl.goal'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM14_RESULT", 
										fieldName : "SCM14_RESULT", 
										header    : { text : "<spring:message code='lbl.actual'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM14_SCORE", 
										fieldName : "SCM14_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							}, { // 재고 보유율
								type      : "group",
								name      : "FUTURE_INDEX_SUB5", 
								header    : { fixedHeight : 20, text : "<spring:message code='lbl.invRetentionRate'/>" },
								width     : 240,
								columns   : [
									{
										name      : "SCM15_TARGET", 
										fieldName : "SCM15_TARGET", 
										header    : { text : "<spring:message code='lbl.goal'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM15_RESULT", 
										fieldName : "SCM15_RESULT", 
										header    : { text : "<spring:message code='lbl.actual'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}, {
										name      : "SCM15_SCORE", 
										fieldName : "SCM15_SCORE", 
										header    : { text : "<spring:message code='lbl.score'/>" }, 
										styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
										dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
										width     : 80, 
										editable  : false										
									}
								]
							}
						]
					}
				];
				
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols) {
				
				var fields = new Array();
				
				fields = [
					{ fieldName : "YEARMONTH"    , dataType : "text" },
					{ fieldName : "GRP_LVL_ID"   , dataType : "text" },
					{ fieldName : "BU_CD"        , dataType : "text" },
					{ fieldName : "BU_NM"        , dataType : "text" },
					{ fieldName : "DIV_CD"       , dataType : "text" },
					{ fieldName : "DIV_NM"       , dataType : "text" },
					{ fieldName : "TEAM_CD"      , dataType : "text" },
					{ fieldName : "TEAM_NM"      , dataType : "text" },
					{ fieldName : "PART_CD"      , dataType : "text" },
					{ fieldName : "PART_NM"      , dataType : "text" },
					
					{ fieldName : "TOT_SCORE"    , dataType : "number" },					
					{ fieldName : "PLAN_SCORE"   , dataType : "number" },					
					{ fieldName : "ACTION_SCORE" , dataType : "number" },					
					{ fieldName : "INV_SCORE"    , dataType : "number" },					
					{ fieldName : "FUTURE_SCORE" , dataType : "number" },			
					
					{ fieldName : "SCM01_TARGET"    , dataType : "number" },					
					{ fieldName : "SCM02_TARGET"    , dataType : "number" },					
					{ fieldName : "SCM03_TARGET"    , dataType : "number" },					
					{ fieldName : "SCM04_TARGET"    , dataType : "number" },					
					{ fieldName : "SCM05_TARGET"    , dataType : "number" },					
					{ fieldName : "SCM06_TARGET"    , dataType : "number" },					
					{ fieldName : "SCM07_TARGET"    , dataType : "number" },					
					{ fieldName : "SCM08_TARGET"    , dataType : "number" },					
					{ fieldName : "SCM09_TARGET"    , dataType : "number" },					
					{ fieldName : "SCM10_TARGET"    , dataType : "number" },					
					{ fieldName : "SCM11_TARGET"    , dataType : "number" },					
					{ fieldName : "SCM12_TARGET"    , dataType : "number" },					
					{ fieldName : "SCM13_TARGET"    , dataType : "number" },					
					{ fieldName : "SCM14_TARGET"    , dataType : "number" },					
					{ fieldName : "SCM15_TARGET"    , dataType : "number" },					
					
					{ fieldName : "SCM01_RESULT"    , dataType : "number" },					
					{ fieldName : "SCM02_RESULT"    , dataType : "number" },					
					{ fieldName : "SCM03_RESULT"    , dataType : "number" },					
					{ fieldName : "SCM04_RESULT"    , dataType : "number" },					
					{ fieldName : "SCM05_RESULT"    , dataType : "number" },					
					{ fieldName : "SCM06_RESULT"    , dataType : "number" },					
					{ fieldName : "SCM07_RESULT"    , dataType : "number" },					
					{ fieldName : "SCM08_RESULT"    , dataType : "number" },					
					{ fieldName : "SCM09_RESULT"    , dataType : "number" },					
					{ fieldName : "SCM10_RESULT"    , dataType : "number" },					
					{ fieldName : "SCM11_RESULT"    , dataType : "number" },					
					{ fieldName : "SCM12_RESULT"    , dataType : "number" },					
					{ fieldName : "SCM13_RESULT"    , dataType : "number" },					
					{ fieldName : "SCM14_RESULT"    , dataType : "number" },					
					{ fieldName : "SCM15_RESULT"    , dataType : "number" },
					
					{ fieldName : "SCM01_SCORE"    , dataType : "number" },					
					{ fieldName : "SCM02_SCORE"    , dataType : "number" },					
					{ fieldName : "SCM03_SCORE"    , dataType : "number" },					
					{ fieldName : "SCM04_SCORE"    , dataType : "number" },					
					{ fieldName : "SCM05_SCORE"    , dataType : "number" },					
					{ fieldName : "SCM06_SCORE"    , dataType : "number" },					
					{ fieldName : "SCM07_SCORE"    , dataType : "number" },					
					{ fieldName : "SCM08_SCORE"    , dataType : "number" },					
					{ fieldName : "SCM09_SCORE"    , dataType : "number" },					
					{ fieldName : "SCM10_SCORE"    , dataType : "number" },					
					{ fieldName : "SCM11_SCORE"    , dataType : "number" },					
					{ fieldName : "SCM12_SCORE"    , dataType : "number" },					
					{ fieldName : "SCM13_SCORE"    , dataType : "number" },					
					{ fieldName : "SCM14_SCORE"    , dataType : "number" },					
					{ fieldName : "SCM15_SCORE"    , dataType : "number" },
					
					{ fieldName : "SCM01_USE_FLAG"    , dataType : "text" },					
					{ fieldName : "SCM02_USE_FLAG"    , dataType : "text" },					
					{ fieldName : "SCM03_USE_FLAG"    , dataType : "text" },					
					{ fieldName : "SCM04_USE_FLAG"    , dataType : "text" },					
					{ fieldName : "SCM05_USE_FLAG"    , dataType : "text" },					
					{ fieldName : "SCM06_USE_FLAG"    , dataType : "text" },					
					{ fieldName : "SCM07_USE_FLAG"    , dataType : "text" },					
					{ fieldName : "SCM08_USE_FLAG"    , dataType : "text" },					
					{ fieldName : "SCM09_USE_FLAG"    , dataType : "text" },					
					{ fieldName : "SCM10_USE_FLAG"    , dataType : "text" },					
					{ fieldName : "SCM11_USE_FLAG"    , dataType : "text" },					
					{ fieldName : "SCM12_USE_FLAG"    , dataType : "text" },					
					{ fieldName : "SCM13_USE_FLAG"    , dataType : "text" },					
					{ fieldName : "SCM14_USE_FLAG"    , dataType : "text" },					
					{ fieldName : "SCM15_USE_FLAG"    , dataType : "text" }		
					
					
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
				
				var valArray = ["ALL", "TOT_SCORE", "ACTION_INDEX_ALL", "ACTION_SCORE", "ACTION_INDEX_SUB1", "ACTION_INDEX_SUB2", "ACTION_INDEX_SUB3", "ACTION_INDEX_SUB4", "ACTION_INDEX_SUB5", "ACTION_INDEX_SUB6", "FUTURE_INDEX_ALL", "FUTURE_INDEX_SUB1", "FUTURE_INDEX_SUB2", "FUTURE_INDEX_SUB3", "FUTURE_INDEX_SUB4", "FUTURE_INDEX_SUB5", "FUTURE_SCORE"];
				var forArr = ["_TARGET", "_RESULT", "_SCORE"];
				
				for(var i = 1; i < 16; i++){
					
					var setVal = "";
					
					
					if(i == 4 || i == 5 || i == 6 || i == 7 || i == 8 || i == 12 || i == 13 || i == 14 || i == 15){
						
						if(i < 10){
							i = "0" + i;	
						}
						
						$.each(forArr, function(j, val){
							setVal = "SCM" + i + val;
							valArray.push(setVal);
						});
					}
				}
				
				
				var valArrayLen = valArray.length;
				
				for(var i = 0; i < valArrayLen; i++){
					var val = valArray[i];
					
					var setHeader = this.grdMain.getColumnProperty(val, "header");
					setHeader.styles = {background: gv_headerColor};
					this.grdMain.setColumnProperty(val, "header", setHeader);
				}
			},
			
			gridCallback : function (dataList) {
				
				var beforeChangeWork = "_TARGET";
				var changeWork = "_USE_FLAG";
				var fileds = this.dataProvider.getFields();
				var filedsLen = fileds.length;
				
				if(FORM_SEARCH.rdoAqType==="MONTH")
				{	
					for (var i = 0; i < filedsLen; i++) {
						
						var fieldName = fileds[i].fieldName;
						
						if(fieldName.indexOf(beforeChangeWork) != -1){
							
							var flagName = gfn_replaceAll(fieldName, beforeChangeWork, "") + changeWork;
						
							var editStyle = {};
							var val = gfn_getDynamicStyle(3, totAr);
							
							editStyle.background = gv_editColor;
							editStyle.editable = true;
							
							val.criteria.push("(values['"+ flagName +"'] = 'Y')");
							val.styles.push(editStyle);
						
							var editStyle2 = {};
							
							editStyle2.background = gv_arrDimColor[2];
							editStyle2.editable = false;
							
							val.criteria.push("(values['"+ flagName +"'] = 'N')");
							val.styles.push(editStyle2);
							
							this.grdMain.setColumnProperty(this.grdMain.columnByField(fieldName), "dynamicStyles", [val]);
						
						} 
					} 
				}
				else if(FORM_SEARCH.rdoAqType==="ACC")
				{	
						for (var i = 0; i < filedsLen; i++) {
						
						var fieldName = fileds[i].fieldName;
						
						if(fieldName.indexOf(beforeChangeWork) != -1){
							
							var flagName = gfn_replaceAll(fieldName, beforeChangeWork, "") + changeWork;
						
							var editStyle = {};
							var val = gfn_getDynamicStyle(3, totAr);
							
							editStyle.background = gv_arrDimColor[2];
							editStyle.editable = false;
							
							val.criteria.push("(values['"+ flagName +"'] = 'Y')");
							val.styles.push(editStyle);
						
							var editStyle2 = {};
							
							editStyle2.background = gv_arrDimColor[2];
							editStyle2.editable = false;
							
							val.criteria.push("(values['"+ flagName +"'] = 'N')");
							val.styles.push(editStyle2);
							
							this.grdMain.setColumnProperty(this.grdMain.columnByField(fieldName), "dynamicStyles", [val]);
						
						} 
					} 
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
				scmScoreboard.save();
			});
			
			$("#btnReset").on('click', function (e) {
				scmScoreboard.grid.grdMain.cancel();
				scmScoreboard.grid.dataProvider.rollback(scmScoreboard.grid.dataProvider.getSavePoints()[0]);
				scmScoreboard.grid.gridCallback();
			});
			
			$("input:radio[name=rdoAqType]").click(function(){
				
				var selectVal = $(':radio[name="rdoAqType"]:checked').val();
				
				//버튼 영역 숨김
				if(selectVal == "MONTH" && $('#saveYn ').val()=="Y"){
					$('.cbt_btn').show();
				}
				//버튼 영역 보여짐
				else{
					
					$('.cbt_btn').hide();
						
				}
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
					}else if(id == "divMonth"){
						EXCEL_SEARCH_DATA += $("#fromMon").val();			
					}
				}
			});
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						scmScoreboard.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						scmScoreboard.grid.grdMain.cancel();
						
						scmScoreboard.grid.dataProvider.setRows(data.resList);
						scmScoreboard.grid.dataProvider.clearSavePoints();
						scmScoreboard.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(scmScoreboard.grid.dataProvider.getRowCount());
						
						scmScoreboard.grid.gridInstance.setFocusKeys();
						scmScoreboard.grid.gridCallback(data.resList);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		save : function() {
			
			var monthAcc = $('input[name="rdoAqType"]:checked').val();
			if(monthAcc==="MONTH")
			{
				var grdData = gfn_getGrdSavedataAll(this.grid.grdMain);
				if (grdData.length == 0) {
					alert('<spring:message code="msg.noChangeData"/>');
					return;
				}
				
				confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
					var data = gfn_getGrdSavedataAll(scmScoreboard.grid.grdMain);
					var jsonData = [];
					$.each(data, function (i, jd) {
						if (jd.GRP_LVL_ID == '0') {
							jsonData.push(jd);
						}
					});
					
					FORM_SAVE = {}; //초기화
					FORM_SAVE._mtd   = "saveUpdate";
					FORM_SAVE.tranData = [{outDs:"saveCnt",_siq : scmScoreboard._siq, grdData : [{rowList : jsonData}]}];
					
					gfn_service({
						url    : GV_CONTEXT_PATH + "/biz/obj.do",
						data   : FORM_SAVE,
						success: function(data) {
							alert('<spring:message code="msg.saveOk"/>');
							fn_apply();
						}
					}, "obj");
					
				});
				
			}
			else
			{
				
			}
		},
	};
	
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		FORM_SEARCH     = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH.sql = sqlFlag;
		
		scmScoreboard.search();
		scmScoreboard.excelSubSearch();
	}

	function fn_checkClose() {
		return gfn_getGrdSaveCount(scmScoreboard.grid.grdMain) == 0;
	}
	

	// onload 
	$(document).ready(function() {
		scmScoreboard.init();
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
					
					<div class="view_combo" id="divMonthAcc">
							<strong class="filter_tit"><spring:message code="lbl.prevMonthAcc"/></strong>
							<ul class="rdofl">
								<li><input type="radio" id="MONTH" name="rdoAqType" value="MONTH" checked="checked"><label for="MONTH"><spring:message code="lbl.monthly"/></label></li>
								<li><input type="radio" id="ACC" name="rdoAqType" value="ACC" ><label for="ACC"><spring:message code="lbl.annualAcc"/>(~<spring:message code="lbl.lastMonth"/>)</label></li>
							</ul>
					</div>
					
					
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
				<div class="bright" >
					<a id="btnReset"       href="#" class="app1"><spring:message code="lbl.reset" /></a>  
					<a id="btnSave"        href="#" class="app2"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
