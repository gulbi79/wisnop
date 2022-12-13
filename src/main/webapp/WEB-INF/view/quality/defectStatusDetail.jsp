<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>

	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var defectStatus = {

		init : function () {
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.defectStatusGrid.initGrid();
			
		},
			
		_siq : "quality.defectStatusDetail",
		
		/*
		* common Code 
		*/
		comCode : {
			
			codeMap : null,
			codeMapEx : null,
			
			initCode  : function () {
				var grpCd      = 'KEY_GROUP_YN,FLAG_YN,PROCUR_TYPE,ITEM_CATE,ITEM_TYPE';
				this.codeMap   = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["REP_ITEM_GROUP", "UPPER_ITEM_GROUP", "ITEM_GROUP", "ROUTING"], null, {itemType : "10"});
				
				this.codeMap.ITEM_TYPE = $.grep(this.codeMap.ITEM_TYPE, function(val, i){
					return val.CODE_CD == '10' || val.CODE_CD == '20' || val.CODE_CD == '30' || val.CODE_CD == '50';
				});
				
				gfn_service({
					async   : false,
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : {_mtd:"getList",tranData:[{outDs:"dateList",_siq:"quality.defectStatusDetailDate"}]},
					success : function(data) {
						defectStatus.comCode.codeMap.DATE_INFO = data.dateList[0];
					}
				}, "obj");
			}
		},
		
		initFilter : function() {

			//품목대그룹
			var upperItemEvent = {
				childId   : ["itemGroup"],
				childData : [this.comCode.codeMapEx.ITEM_GROUP],
			};
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divProcurType',    id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{target : 'divUpItemGroup',   id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent},
				{target : 'divItemGroup',     id : 'itemGroup',     title : '<spring:message code="lbl.itemGroup"/>',      data : this.comCode.codeMapEx.ITEM_GROUP,     exData:["*"]},
				{target : 'divRoute',         id : 'route',         title : '<spring:message code="Routing"/>',            data : this.comCode.codeMapEx.ROUTING,        exData:["*"]},
				{target : 'divReptItemGroup', id : 'reptItemGroup', title : '<spring:message code="lbl.reptItemGroup"/>',  data : this.comCode.codeMapEx.REP_ITEM_GROUP, exData:["*"]},
				{target : 'divKey',           id : 'keyGroupYn',    title : '<spring:message code="lbl.keyProd"/>',        data : this.comCode.codeMap.KEY_GROUP_YN,     exData:["*"], type : "S"},
				{target : 'divFirst',         id : 'firstYn',       title : '<spring:message code="lbl.fristModulator"/>', data : this.comCode.codeMap.ITEM_CATE,        exData:[""]},
				{target : 'divItemType',      id : 'itemType',      title : '<spring:message code="lbl.itemType"/>',       data : this.comCode.codeMap.ITEM_TYPE, exData:[""], option: {allFlag:"Y"}},
			]);
			
			DATEPICKET(null,this.comCode.codeMap.DATE_INFO.FROM_DATE, this.comCode.codeMap.DATE_INFO.TO_DATE);
			$("#toCal").datepicker("option", "maxDate", this.comCode.codeMap.DATE_INFO.MAX_DATE);
			$("#txtIspW, #txtDefectW, #txtRateW").inputmask("numeric");
			$("#filter_tit").html('<spring:message code="lbl.defectDvh"/>');
			
			var itemCateArr = new Array();
			$.each(this.comCode.codeMap.ITEM_CATE, function(i, val){
				
				var attb1Cd = val.ATTB_1_CD;
				var codeCd = val.CODE_CD;
				
				if(attb1Cd == "Y"){
					itemCateArr.push(codeCd);
				}
			});
			$("#firstYn").multipleSelect("setSelects", itemCateArr);
		},
	
		/* 
		* grid  선언
		*/
		defectStatusGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");

				this.gridInstance.custNextBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;

				gfn_setMonthSum(defectStatus.defectStatusGrid.gridInstance, false, false, true);
			}
		},
	
		/*
		* event 정의
		*/
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
					if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}else if(id == "divProcurType"){
						
						$.each($("#procurType option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divUpItemGroup"){
						$.each($("#upItemGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divItemGroup"){
						$.each($("#itemGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divRoute"){
						$.each($("#route option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divReptItemGroup"){
						$.each($("#reptItemGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divKey"){
						EXCEL_SEARCH_DATA += $("#keyGroupYn option:selected").text();
					}else if(id == "divFirst"){
						EXCEL_SEARCH_DATA += $("#firstYn option:selected").text();
					}else if(id == "divItemType"){
						$.each($("#itemType option:selected"), function(i2, val2){
							
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
			
			EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
			EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ") ~ ";
			EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toWeek").val() + ")";
			
			//console.log("EXCEL_SEARCH_DATA : " , EXCEL_SEARCH_DATA);
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
						defectStatus.defectStatusGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						defectStatus.defectStatusGrid.grdMain.cancel();
						
						defectStatus.defectStatusGrid.dataProvider.setRows(data.resList);
						defectStatus.defectStatusGrid.dataProvider.clearSavePoints();
						defectStatus.defectStatusGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_actionMonthSum(defectStatus.defectStatusGrid.gridInstance);
						gfn_setRowTotalFixed(defectStatus.defectStatusGrid.grdMain);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function(sqlFlag) {
			if (!sqlFlag) {
				
				for (var i in DIMENSION.user) {
					if (DIMENSION.user[i].DIM_CD.indexOf("PRICE") > -1) {
						DIMENSION.user[i].numberFormat = "#,##0";
					}
				}
				
				defectStatus.defectStatusGrid.gridInstance.setDraw();
				
				var fileds = defectStatus.defectStatusGrid.dataProvider.getFields();
				
				for (var i in fileds) {
					if (fileds[i].fieldName.indexOf("PRICE") > -1) {
						fileds[i].dataType = "number";
					}
				}
				defectStatus.defectStatusGrid.dataProvider.setFields(fileds);
			}
		}
	};

	//조회
	var fn_apply = function (sqlFlag) {
		
		$("#firstYn1").val("");
		$("#firstYn2").val("");
		$("#firstYn3").val("");
		
		var temp = gfn_nvl($("#firstYn").val(), "");
		
		if(temp != ""){
			$.each(temp, function(i, val){
				
				if(val == "AS"){
					$("#firstYn1").val(val);
				}else if(val == "FIRST"){
					$("#firstYn2").val(val);
				}else if(val == "NORMAL"){
					$("#firstYn3").val(val);
				}
			});	
		}

		// 디멘젼, 메져
		gfn_getMenuInit();
		
		defectStatus.getBucket(sqlFlag);
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		
		defectStatus.search();
		defectStatus.excelSubSearch();
	}
	
	function fn_setNextFieldsBuket() {
		var fields = [
			{fieldName: "LOT_SIZE"     , dataType : "number"},
			{fieldName: "GOODS_QTY"    , dataType : "number"},
			{fieldName: "DEFECT_QTY"   , dataType : "number"},
			{fieldName: "SPEC_QTY"     , dataType : "number"},
			{fieldName: "NOT_EXAM_QTY" , dataType : "number"},
			{fieldName: "PASS_AMT"     , dataType : "number"},
			{fieldName: "NOT_EXAM_AMT" , dataType : "number"},
			{fieldName: "INSP_USER_ID"},
			{fieldName: "REMARK"},
			{fieldName: "UPDATE_DTTM"}
        ];
    	
    	return fields;
	}
	
	function fn_setNextColumnsBuket() {
		var columns = [
			{
				name : "LOT_SIZE", fieldName: "LOT_SIZE", editable : false, header: {text: '<spring:message code="lbl.lotSize2" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "GOODS_QTY", fieldName: "GOODS_QTY", editable : false, header: {text: '<spring:message code="lbl.passedQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "DEFECT_QTY", fieldName: "DEFECT_QTY", editable : false, header: {text: '<spring:message code="lbl.defectQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "SPEC_QTY", fieldName: "SPEC_QTY", editable : false, header: {text: '<spring:message code="lbl.specialQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "NOT_EXAM_QTY", fieldName: "NOT_EXAM_QTY", editable : false, header: {text: '<spring:message code="lbl.notExamQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "PASS_AMT", fieldName: "PASS_AMT", editable : false, header: {text: '<spring:message code="lbl.passedAmt" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "NOT_EXAM_AMT", fieldName: "NOT_EXAM_AMT", editable : false, header: {text: '<spring:message code="lbl.notExamAmt" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "INSP_USER_ID", fieldName: "INSP_USER_ID", editable : false, header: {text: '<spring:message code="lbl.inspUser" javaScriptEscape="true" />'},
				styles: {textAlignment: "center", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "REMARK", fieldName: "REMARK", editable : false, header: {text: '<spring:message code="lbl.defectRemark" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "UPDATE_DTTM", fieldName: "UPDATE_DTTM", editable : false, header: {text: '<spring:message code="lbl.updateDttm" javaScriptEscape="true" />'},
				styles: {textAlignment: "center", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 120
			}
		];
		
		return columns;
	}
	

	// onload 
	$(document).ready(function() {
		defectStatus.init();
	});
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<input type="hidden" id="firstYn1" name="firstYn1" value=""/>
		<input type="hidden" id="firstYn2" name="firstYn2" value=""/>
		<input type="hidden" id="firstYn3" name="firstYn3" value=""/>
		<!-- <input type="hidden" id="itemType" name="itemType" value="10"/>  -->
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divReptItemGroup"></div>
					<div class="view_combo" id="divKey"></div>
					<div class="view_combo" id="divFirst"></div>
					<div class="view_combo" id="divItemType"></div>
					
					<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
						<jsp:param name="radioYn" value="N" />
						<jsp:param name="wType" value="PW" />
					</jsp:include>
				</div>
				<div class="bt_btn">
					<a href="#" class="fl_app" id="btnSearch"><spring:message code="lbl.search"/></a>
				</div>
			</div>
		</div>
		</form>
	</div>
	
	<!-- contents -->
	<div id="b" class="split split-horizontal">
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
			<!-- <div class="use_tit">
				<h3>My Opportunities</h3> <h4>- recently created</h4>
			</div> -->
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
		</div>
    </div>
</body>
</html>
