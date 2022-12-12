<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.summary"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
var popupHeight;
var gridInstance, grdMain, dataProvider;

$("document").ready(function (){
	gfn_popresize();
	fn_init();
	fn_initGrid();
});

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

//데이터 초기화
function fn_init() {
	
	$("#btnClose").click("on", function() { window.close(); });
	
	fn_getGridData();
}

//그리드 초기화
function fn_initGrid() {
	
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
	
	grdMain.addCellStyles([{
		id         : "totalStyles",
		editable   : false,
		background : gv_totalColor
	}]);

	var columns = 
		[
			{
				name	  : "CUST_GROUP_NM",
				fieldName : "CUST_GROUP_NM",
				header    : {text : '<spring:message code="lbl.custGroupName"/>'},
				styles    : {textAlignment : "near", background : gfn_getArrDimColor(0)},
				mergeRule : { criteria : "values['CUST_GROUP_NM'] + value" },
				dynamicStyles:[gfn_getDynamicStyle(0)],
				editable  : false,
				width     : 100
			}, {
                type: "group",
                name: "W_1",
                header: {text: ''},
                fieldName: "W_1",
                width: 2080,
                columns : [
                	{
						name : "AP2_DMD1_SP", fieldName: "AP2_DMD1_SP",  editable: false, header: {text: '<spring:message code="lbl.ap2dmd1sp" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "AP2_DMD2_SP", fieldName: "AP2_DMD2_SP",  editable: false, header: {text: '<spring:message code="lbl.ap2dmd2sp" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "AP2_DMD3_SP", fieldName: "AP2_DMD3_SP",  editable: false, header: {text: '<spring:message code="lbl.ap2dmd3sp" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "AP2_SP", fieldName: "AP2_SP",  editable: false, header: {text: '<spring:message code="lbl.ap2sp2" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "AP2_SP_AMT_KRW", fieldName: "AP2_SP_AMT_KRW",  editable: false, header: {text: '<spring:message code="lbl.ap2Amt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "CFM_DMD1_SP", fieldName: "CFM_DMD1_SP",  editable: false, header: {text: '<spring:message code="lbl.cfmDmd1Sp" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "CFM_DMD2_SP", fieldName: "CFM_DMD2_SP",  editable: false, header: {text: '<spring:message code="lbl.cfmDmd2Sp" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "CFM_DMD3_SP", fieldName: "CFM_DMD3_SP",  editable: false, header: {text: '<spring:message code="lbl.cfmDmd3Sp" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "AVAIL_QTY", fieldName: "AVAIL_QTY",  editable: false, header: {text: '<spring:message code="lbl.availQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "CFM_SP", fieldName: "CFM_SP",  editable: false, header: {text: '<spring:message code="lbl.cfmSp" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "CFM_SP_AMT_KRW", fieldName: "CFM_SP_AMT_KRW",  editable: false, header: {text: '<spring:message code="lbl.cfmAmt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "WEEK_INV_QTY", fieldName: "WEEK_INV_QTY",  editable: false, header: {text: '<spring:message code="lbl.weekInvQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "INV_SALES_QTY", fieldName: "INV_SALES_QTY",  editable: false, header: {text: '<spring:message code="lbl.invSalesQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "INV_SALES_AMT_KRW", fieldName: "INV_SALES_AMT_KRW",  editable: false, header: {text: '<spring:message code="lbl.invSalesAmt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PROD_NEED_QTY", fieldName: "PROD_NEED_QTY",  editable: false, header: {text: '<spring:message code="lbl.prodNeedQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PROD_NEED_AMT_KRW", fieldName: "PROD_NEED_AMT_KRW",  editable: false, header: {text: '<spring:message code="lbl.prodNeedAmt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					},
					{
						name : "PROD_AVAIL_QTY", fieldName: "PROD_AVAIL_QTY",  editable: false, header: {text: '<spring:message code="lbl.prodAvailQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PROD_AVAIL_AMT_KRW", fieldName: "PROD_AVAIL_AMT_KRW",  editable: false, header: {text: '<spring:message code="lbl.prodAvailAmt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PROD_PLAN_QTY", fieldName: "PROD_PLAN_QTY",  editable: false, header: {text: '<spring:message code="lbl.prodPlanQty3" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PROD_PLAN_AMT_KRW", fieldName: "PROD_PLAN_AMT_KRW",  editable: false, header: {text: '<spring:message code="lbl.prodPlanAmt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					},   {
						name : "PRE_PROD_QTY", fieldName: "PRE_PROD_QTY",  editable: false, header: {text: '<spring:message code="lbl.preProdQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PRE_PROD_AMT_KRW", fieldName: "PRE_PROD_AMT_KRW",  editable: false, header: {text: '<spring:message code="lbl.preProdAmt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "ADD_CFM_AVAIL_QTY", fieldName: "ADD_CFM_AVAIL_QTY",  editable: false, header: {text: '<spring:message code="lbl.addCfmAvailQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "ADD_CFM_AVAIL_AMT_KRW", fieldName: "ADD_CFM_AVAIL_AMT_KRW",  editable: false, header: {text: '<spring:message code="lbl.addCfmAvailAmt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PROD_NO_REF_QTY", fieldName: "PROD_NO_REF_QTY",  editable: false, header: {text: '<spring:message code="lbl.prodNoRefQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PROD_NO_REF_AMT_KRW", fieldName: "PROD_NO_REF_AMT_KRW",  editable: false, header: {text: '<spring:message code="lbl.prodNoRefAmt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}
                ]
            }, {
                type: "group",
                name: "W_2",
                header: {text: ''},
                fieldName: "W_2",
                width: 2080,
                columns : [
                	{
						name : "AP2_DMD1_SP_2", fieldName: "AP2_DMD1_SP_2",  editable: false, header: {text: '<spring:message code="lbl.ap2dmd1sp" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "AP2_DMD2_SP_2", fieldName: "AP2_DMD2_SP_2",  editable: false, header: {text: '<spring:message code="lbl.ap2dmd2sp" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "AP2_DMD3_SP_2", fieldName: "AP2_DMD3_SP_2",  editable: false, header: {text: '<spring:message code="lbl.ap2dmd3sp" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "AP2_SP_2", fieldName: "AP2_SP_2",  editable: false, header: {text: '<spring:message code="lbl.ap2sp2" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "AP2_SP_AMT_KRW_2", fieldName: "AP2_SP_AMT_KRW_2",  editable: false, header: {text: '<spring:message code="lbl.ap2Amt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "CFM_DMD1_SP_2", fieldName: "CFM_DMD1_SP_2",  editable: false, header: {text: '<spring:message code="lbl.cfmDmd1Sp" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "CFM_DMD2_SP_2", fieldName: "CFM_DMD2_SP_2",  editable: false, header: {text: '<spring:message code="lbl.cfmDmd2Sp" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "CFM_DMD3_SP_2", fieldName: "CFM_DMD3_SP_2",  editable: false, header: {text: '<spring:message code="lbl.cfmDmd3Sp" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "AVAIL_QTY_2", fieldName: "AVAIL_QTY_2",  editable: false, header: {text: '<spring:message code="lbl.availQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "CFM_SP_2", fieldName: "CFM_SP_2",  editable: false, header: {text: '<spring:message code="lbl.cfmSp" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "CFM_SP_AMT_KRW_2", fieldName: "CFM_SP_AMT_KRW_2",  editable: false, header: {text: '<spring:message code="lbl.cfmAmt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "WEEK_INV_QTY_2", fieldName: "WEEK_INV_QTY_2",  editable: false, header: {text: '<spring:message code="lbl.weekInvQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "INV_SALES_QTY_2", fieldName: "INV_SALES_QTY_2",  editable: false, header: {text: '<spring:message code="lbl.invSalesQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "INV_SALES_AMT_KRW_2", fieldName: "INV_SALES_AMT_KRW_2",  editable: false, header: {text: '<spring:message code="lbl.invSalesAmt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PROD_NEED_QTY_2", fieldName: "PROD_NEED_QTY_2",  editable: false, header: {text: '<spring:message code="lbl.prodNeedQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PROD_NEED_AMT_KRW_2", fieldName: "PROD_NEED_AMT_KRW_2",  editable: false, header: {text: '<spring:message code="lbl.prodNeedAmt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					},
					{
						name : "PROD_AVAIL_QTY_2", fieldName: "PROD_AVAIL_QTY_2",  editable: false, header: {text: '<spring:message code="lbl.prodAvailQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PROD_AVAIL_AMT_KRW_2", fieldName: "PROD_AVAIL_AMT_KRW_2",  editable: false, header: {text: '<spring:message code="lbl.prodAvailAmt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PROD_PLAN_QTY_2", fieldName: "PROD_PLAN_QTY_2",  editable: false, header: {text: '<spring:message code="lbl.prodPlanQty3" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PROD_PLAN_AMT_KRW_2", fieldName: "PROD_PLAN_AMT_KRW_2",  editable: false, header: {text: '<spring:message code="lbl.prodPlanAmt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					},   {
						name : "PRE_PROD_QTY_2", fieldName: "PRE_PROD_QTY_2",  editable: false, header: {text: '<spring:message code="lbl.preProdQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PRE_PROD_AMT_KRW_2", fieldName: "PRE_PROD_AMT_KRW_2",  editable: false, header: {text: '<spring:message code="lbl.preProdAmt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "ADD_CFM_AVAIL_QTY_2", fieldName: "ADD_CFM_AVAIL_QTY_2",  editable: false, header: {text: '<spring:message code="lbl.addCfmAvailQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "ADD_CFM_AVAIL_AMT_KRW_2", fieldName: "ADD_CFM_AVAIL_AMT_KRW_2",  editable: false, header: {text: '<spring:message code="lbl.addCfmAvailAmt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PROD_NO_REF_QTY_2", fieldName: "PROD_NO_REF_QTY_2",  editable: false, header: {text: '<spring:message code="lbl.prodNoRefQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PROD_NO_REF_AMT_KRW_2", fieldName: "PROD_NO_REF_AMT_KRW_2",  editable: false, header: {text: '<spring:message code="lbl.prodNoRefAmt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}
                ]
            }
		];

	grdMain.setColumns(columns);
	
	var fields = new Array();
	fields = [
		{ fieldName : "CUST_GROUP_NM"},
		{ fieldName : "W_1"},
		{ fieldName : "W_2"},
		{ fieldName : "AP2_DMD1_SP", dataType : 'number'},
		{ fieldName : "AP2_DMD2_SP", dataType : 'number'},
		{ fieldName : "AP2_DMD3_SP", dataType : 'number'},
		{ fieldName : "AP2_SP", dataType : 'number'},
		{ fieldName : "AP2_SP_AMT_KRW", dataType : 'number'},
		{ fieldName : "CFM_DMD1_SP", dataType : 'number'},
		{ fieldName : "CFM_DMD2_SP", dataType : 'number'},
		{ fieldName : "CFM_DMD3_SP", dataType : 'number'},
		{ fieldName : "AVAIL_QTY", dataType : 'number'},
		{ fieldName : "AVAIL_AMT_KRW", dataType : 'number'},
		{ fieldName : "CFM_SP", dataType : 'number'},
		{ fieldName : "CFM_SP_AMT_KRW", dataType : 'number'},
		{ fieldName : "WEEK_INV_QTY", dataType : 'number'},
		{ fieldName : "WEEK_INV_AMT_KRW", dataType : 'number'},
		{ fieldName : "PROD_PLAN_QTY", dataType : 'number'},
		{ fieldName : "PROD_PLAN_AMT_KRW", dataType : 'number'},
		{ fieldName : "INV_SALES_QTY", dataType : 'number'},
		{ fieldName : "INV_SALES_AMT_KRW", dataType : 'number'},
		{ fieldName : "PROD_AVAIL_QTY", dataType : 'number'},
		{ fieldName : "PROD_AVAIL_AMT_KRW", dataType : 'number'},
		{ fieldName : "PRE_PROD_QTY", dataType : 'number'},
		{ fieldName : "PRE_PROD_AMT_KRW", dataType : 'number'},
		{ fieldName : "ADD_CFM_AVAIL_QTY", dataType : 'number'},
		{ fieldName : "ADD_CFM_AVAIL_AMT_KRW", dataType : 'number'},
		{ fieldName : "PROD_NO_REF_QTY", dataType : 'number'},
		{ fieldName : "PROD_NO_REF_AMT_KRW", dataType : 'number'},
		{ fieldName : "PROD_NEED_QTY", dataType : 'number'},
		{ fieldName : "PROD_NEED_AMT_KRW", dataType : 'number'},
		
		{ fieldName : "AP2_DMD1_SP_2", dataType : 'number'},
		{ fieldName : "AP2_DMD2_SP_2", dataType : 'number'},
		{ fieldName : "AP2_DMD3_SP_2", dataType : 'number'},
		{ fieldName : "AP2_SP_2", dataType : 'number'},
		{ fieldName : "AP2_SP_AMT_KRW_2", dataType : 'number'},
		{ fieldName : "CFM_DMD1_SP_2", dataType : 'number'},
		{ fieldName : "CFM_DMD2_SP_2", dataType : 'number'},
		{ fieldName : "CFM_DMD3_SP_2", dataType : 'number'},
		{ fieldName : "AVAIL_QTY_2", dataType : 'number'},
		{ fieldName : "AVAIL_AMT_KRW_2", dataType : 'number'},
		{ fieldName : "CFM_SP_2", dataType : 'number'},
		{ fieldName : "CFM_SP_AMT_KRW_2", dataType : 'number'},
		{ fieldName : "WEEK_INV_QTY_2", dataType : 'number'},
		{ fieldName : "WEEK_INV_AMT_KRW_2", dataType : 'number'},
		{ fieldName : "PROD_PLAN_QTY_2", dataType : 'number'},
		{ fieldName : "PROD_PLAN_AMT_KRW_2", dataType : 'number'},
		{ fieldName : "INV_SALES_QTY_2", dataType : 'number'},
		{ fieldName : "INV_SALES_AMT_KRW_2", dataType : 'number'},
		{ fieldName : "PROD_AVAIL_QTY_2", dataType : 'number'},
		{ fieldName : "PROD_AVAIL_AMT_KRW_2", dataType : 'number'},
		{ fieldName : "PRE_PROD_QTY_2", dataType : 'number'},
		{ fieldName : "PRE_PROD_AMT_KRW_2", dataType : 'number'},
		{ fieldName : "ADD_CFM_AVAIL_QTY_2", dataType : 'number'},
		{ fieldName : "ADD_CFM_AVAIL_AMT_KRW_2", dataType : 'number'},
		{ fieldName : "PROD_NO_REF_QTY_2", dataType : 'number'},
		{ fieldName : "PROD_NO_REF_AMT_KRW_2", dataType : 'number'},
		{ fieldName : "PROD_NEED_QTY_2", dataType : 'number'},
		{ fieldName : "PROD_NEED_AMT_KRW_2", dataType : 'number'}
	];
	
	dataProvider.setFields(fields);
}

//그리드 데이터 조회
function fn_getGridData(flag) {
	
	var planWeek = "${param.planStartWeek}";
	var planWeek_1 = "${param.planStartWeek_1}";
	var planWeek_2 = "${param.planStartWeek_2}";
	
	FORM_SEARCH.sql      = false;
	FORM_SEARCH._mtd	 = "getList";
	FORM_SEARCH.planId	= "${param.planId}";
	FORM_SEARCH.planStartWeek	= planWeek;
	FORM_SEARCH.planStartWeek_1	= planWeek_1;
	FORM_SEARCH.planStartWeek_2	= planWeek_2;
	FORM_SEARCH.planStartWeekMonday	= "${param.planStartWeekMonday}";
	FORM_SEARCH.tranData = [{ outDs : "rtnList", _siq : "dp.planSalesCfm.salesPlanListCfmSummary"}];
	
	gfn_service({
		url    : GV_CONTEXT_PATH + "/biz/obj.do",
		data   : FORM_SEARCH,
		success: function(data) {
			
			//그리드 데이터 삭제
			dataProvider.clearRows();
			grdMain.cancel();
			//그리드 데이터 생성
			dataProvider.setRows(data.rtnList);
			
			
			var fileds = dataProvider.getFields();
			
			$.each(fileds, function(i, val){
				
				var fname = val.fieldName;
				
				if(fname.indexOf("_2") != -1){
					var aColumn = grdMain.columnByField(val.fieldName); 
					grdMain.setColumnProperty(aColumn, 'header',{styles : {background : "#FFB4B4"}});	
				}
				
				grdMain.setCellStyles(0, fname, "totalStyles");
			});
			
			grdMain.setColumnProperty("W_1", "header", planWeek_1 + gv_expand);
			grdMain.setColumnProperty("W_2", "header", planWeek_2 + gv_expand);
			grdMain.setColumnProperty("W_2", "header", {styles : {background : "#FFB4B4"}});	
		}
	}, "obj");
	
}

</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit"><spring:message code="lbl.summary"/>
		</div>
		<div class="popCont">
			<div id="realgrid" class="realgrid1"></div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>