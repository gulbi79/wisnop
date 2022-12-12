<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.prodOderNo"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
	var popupWidth, popupHeight;
	var partnerDeliveryRateDetail = {
		init : function() {
			gfn_popresize();
			//this.comCode.initCode();
			//this.initFilter();
			this.grid.initGrid();
			this.events();
			//this.baseData();
			fn_apply();
		},
		
		_siq    : "supply.purchase.partnerDeliveryRateDetailList",
		
		grid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid : function() {
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.setColumn();
				this.setOptions();
			},
			
			setColumn : function() {
				var columns = [
					{
						name : "ITEM_CD", fieldName : "ITEM_CD", editable : false, header: {text: '<spring:message code="lbl.item" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dataType : "text",
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width : 100
					}, {
						name : "BP_NM", fieldName : "BP_NM", editable : false, header: {text: '<spring:message code="lbl.bpNm" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dataType : "text",
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width : 120
					}, {
						name : "CODE_NM", fieldName : "CODE_NM", editable : false, header: {text: '<spring:message code="lbl.expGrQtyInfo" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dataType : "text",
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width : 120
					}, {
						name : "PO_NO", fieldName : "PO_NO", editable : false, header: {text: '<spring:message code="lbl.estNo" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dataType : "text",
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width : 120
					}, {
						name : "PO_SEQ", fieldName : "PO_SEQ", editable : false, header: {text: '<spring:message code="lbl.estSeq" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						dataType : "text",
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width : 80
					}, {
						name : "ORG_DATE", fieldName : "ORG_DATE", editable : false, header: {text: '<spring:message code="lbl.originalData" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						dataType : "text",
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width : 120
					}, {
						name : "SCHED_DATE_PRE_RECV", fieldName : "SCHED_DATE_PRE_RECV", editable : false, header: {text: '<spring:message code="lbl.schedDatePreRecv" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						dataType : "text",
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width : 120
					}, {
						name : "SCHED_QTY", fieldName: "SCHED_QTY", editable: false, header: {text: '<spring:message code="lbl.recvQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "RECV_QTY", fieldName: "RECV_QTY", editable: false, header: {text: '<spring:message code="lbl.stockResult" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "MOL_QTY", fieldName: "MOL_QTY", editable: false, header: {text: '<spring:message code="lbl.overShort" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					} 
				];
				
				this.setFields(columns, []);
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols, hiddenCols) {
				var fields = new Array();
				
				$.each(cols, function(i, v) {
					
					var tFieldName = v.fieldName;
					var tDataType = v.dataType;
					
					fields.push({fieldName : tFieldName, dataType : tDataType});
					
				});
				
				this.dataProvider.setFields(fields); 
			},
			
			setOptions : function() {
				/* this.grdMain.setOptions({
					checkBar: { visible : true },
					stateBar: { visible : true }
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]); */
			}
		},
		
		events : function() {
			/* $("#btnSearch").on("click", function(e) {
				fn_apply(false);
			}); */
			
			$("#btnClose").on("click", function() {
				window.close(); 
			});
		},
		
		search : function() {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						partnerDeliveryRateDetail.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						partnerDeliveryRateDetail.grid.grdMain.cancel();
						
						partnerDeliveryRateDetail.grid.dataProvider.setRows(data.resList);
						//partnerDeliveryRateDetail.grid.dataProvider.clearSavePoints();
						//partnerDeliveryRateDetail.grid.dataProvider.savePoint(); //초기화 포인트 저장z
						gfn_setSearchRow(partnerDeliveryRateDetail.grid.dataProvider.getRowCount());
						//gfn_actionMonthSum(commFacility.grid.gridInstance);
						//gfn_setRowTotalFixed(partnerDeliveryRateDetail.grid.grdMain);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		}
	};
	
	var fn_apply = function (sqlFlag) {
		//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql = sqlFlag;
   		
    	partnerDeliveryRateDetail.search();
	}
	
	// onload 
	$(document).ready(function() {
		partnerDeliveryRateDetail.init();
	});
	
	$(window).resize(function() {
		gfn_popresizeSub();
	}).resize();
</script>
</head>

<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit">${param.popupTitle}</div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
				<input type="hidden" id="yearWeek" name="yearWeek" value="${param.yearWeek }"/>
				<input type="hidden" id="itemCd" name="itemCd" value="${param.itemCd }"/>
				<input type="hidden" id="bpCd" name="bpCd" value="${param.bpCd }"/>
			</div>
			<div id="realgrid" class="realgrid1"></div>
			<div class="pop_btn">
				<%-- <a href="#" id="btnApply" class="pbtn pApply"><spring:message code="lbl.apply"/></a> --%>
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>

</html>