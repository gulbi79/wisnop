<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 적자제품현황-->
	<script type="text/javascript">
	
	var enterSearchFlag = "Y";
	var deficitProdPresent = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.deficitProdPresentGrid.initGrid();
		},
			
		_siq    : "dp.salesPerform.deficitProdPresentList2",
		
		initFilter : function() { 
			
			var itemTypeEvent = {
				childId   : ["upItemGroup","route"],  
				childData : [this.comCode.codeMapEx.UPPER_ITEM_GROUP, this.comCode.codeMapEx.ROUTING],
				callback  : function() {
					//품목그룹 초기화
					gfn_setMsCombo("itemGroup", [], ["*"]);
				}
			};
	    	
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
				{target : 'divProcurType',   id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{target : 'divUpItemGroup',  id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent },
				{target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"]},
				{target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING, exData:["*"]},
				{target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"]},
				{target : 'divCustGroup', id : 'custGroup', title : '<spring:message code="lbl.custGroup"/>', data : this.comCode.codeMapEx.CUST_GROUP, exData:["*"]},
				{target : 'divContinueDeficit', id : 'continueDeficit', title : '<spring:message code="lbl.deficit"/>', data : this.comCode.codeMap.DEFICIT_CD, exData:["*"], type : "S"},
				{target : 'divCount', id : 'count', title : '<spring:message code="lbl.occurrenceCnt"/>', data : this.comCode.codeMap.DEFICIT_CD, exData:["*"], type : "S"}
			]);
			
			//숫자만입력
			$("#amountFrom,#amountTo").inputmask("numeric");
			
			MONTHPICKER(null, -1, -1);
			
			$('#fromMon').monthpicker("option", "minDate", -24);
			$('#toMon').monthpicker("option", "maxDate", -1);
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap : null,			
			codeMapEx : null,
			
			initCode : function () {
				var grpCd = 'DEFICIT_CD,PROCUR_TYPE';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "UPPER_ITEM_GROUP", "ITEM_GROUP", "ROUTING"], null, {itemType : "10,50"});
			}
		},
		
		deficitProdPresentGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custNextBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.grdMain.addCellStyles([
					{ id : "editStyleRow", editable : true, background : gv_editColor }
				]);
				
				
				this.grdMain.addCellRenderers([{
		            id: "check1",
		           	type: "check",
		            shape: "box",
		            editable: true,
		            startEditOnClick: true,
		            trueValues: "Y",
		            falseValues: "N"
		        },{
		            id: "check2",
		           	type: "check",
		            shape: "box",
		            editable: false,
		            startEditOnClick: true,
		            trueValues: "Y",
		            falseValues: "N"
		        }]);
			}
		},
		
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#continueDeficit").change(function(e){
				var val = $(this).val();
				
				if(val == "") {
					$("#count").attr("disabled", false);
				} else {
					$("#count").val("");
					$("#count").attr("disabled", true);
				}
			});
			
			$("#btnSave").on('click', function (e) {
				deficitProdPresent.save();
			});
			
			$("#btnReset").on('click', function (e) {
				deficitProdPresent.deficitProdPresentGrid.grdMain.cancel();
				deficitProdPresent.deficitProdPresentGrid.dataProvider.rollback(deficitProdPresent.deficitProdPresentGrid.dataProvider.getSavePoints()[0]);
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
					}else if(id == "divRepCustGroup"){
						$.each($("#reptCustGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divCustGroup"){
						$.each($("#custGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divContinueDeficit"){
						EXCEL_SEARCH_DATA += $("#continueDeficit option:selected").text();
					}else if(id == "divCount"){
						EXCEL_SEARCH_DATA += $("#count option:selected").text();
					}else if(id == "divAmount"){
						EXCEL_SEARCH_DATA += $("#amountFrom").val() + " ~ " + $("#amountTo").val();
					}
				}
			});
			
			EXCEL_SEARCH_DATA += "\n" + $("#view_Her .tlist .tit").html() + " : ";
			EXCEL_SEARCH_DATA += $("#fromMon").val() + " ~ " + $("#toMon").val();
			
		},
		
		save : function() {
			
			var grdData = gfn_getGrdSavedataAll(this.deficitProdPresentGrid.grdMain);
			var grdDataLen = grdData.length;
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
					
	    		FORM_SAVE = {}; //초기화
	    		FORM_SAVE._mtd = "saveAll";
	    		FORM_SAVE.tranData = [{outDs : "saveCnt", _siq : deficitProdPresent._siq, grdData : grdData, mergeFlag : "Y"}];
	    		
		    	var sMap = {
		            url: GV_CONTEXT_PATH + "/biz/obj",
		            data: FORM_SAVE,
		            success:function(data) {
		            	alert('<spring:message code="msg.saveOk"/>');
			            //fn_apply();
		            }
		        }
		        gfn_service(sMap, "obj");
	    	});
			
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
						deficitProdPresent.deficitProdPresentGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						deficitProdPresent.deficitProdPresentGrid.grdMain.cancel();
						
						deficitProdPresent.deficitProdPresentGrid.dataProvider.setRows(data.resList);
						deficitProdPresent.deficitProdPresentGrid.dataProvider.clearSavePoints();
						deficitProdPresent.deficitProdPresentGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(deficitProdPresent.deficitProdPresentGrid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(deficitProdPresent.deficitProdPresentGrid.grdMain);
						fn_authority(data.resList);
						
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			if (!sqlFlag) {
				deficitProdPresent.deficitProdPresentGrid.gridInstance.setDraw();
			}
		}
	};

	//조회
	var fn_apply = function (sqlFlag) {
		
		gfn_getMenuInit();
		
		deficitProdPresent.getBucket(sqlFlag);
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject();
    	FORM_SEARCH.sql     = sqlFlag;
    	FORM_SEARCH.dimList = DIMENSION.user;
   		
   		
		deficitProdPresent.search();
		deficitProdPresent.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		deficitProdPresent.init();
	});
	
	function fn_authority(gridData) {
		
		gfn_service({
		    async   : false,
		    url     : GV_CONTEXT_PATH + "/biz/obj",
		    data    : {
		    			_mtd : "getList",
		    			tranData : [
		    				{outDs : "authorityList", _siq : "dp.salesPerform.authority2"}
		    			]
		    },
		    success :function(data) {
		    	
		    	var dataLen = data.authorityList.length;
		    	for(var i = 0; i < dataLen; i++){
		    		var menuCd = data.authorityList[i].MENU_CD;
		    		
		    		$.each(gridData, function(n, v){
		    			var tGrpLvlId = v.GRP_LVL_ID;
		    			
		    			if(tGrpLvlId == 0){
		    				if(menuCd == "DP31001"){ //생산
				    			deficitProdPresent.deficitProdPresentGrid.grdMain.setCellStyles(n, "ENG_COMMENT", "editStyleRow");
				    			deficitProdPresent.deficitProdPresentGrid.grdMain.setCellStyles(n, "PROD_COMMENT", "editStyleRow");
				    		}else if(menuCd == "DP31002"){ //재경
				    			deficitProdPresent.deficitProdPresentGrid.grdMain.setCellStyles(n, "FINANCE_COMMENT", "editStyleRow");
				    		}else if(menuCd == "DP31003"){ //영업
				    			deficitProdPresent.deficitProdPresentGrid.grdMain.setCellStyles(n, "ANALYZE_BAND", "editStyleRow");
				    			deficitProdPresent.deficitProdPresentGrid.grdMain.setCellStyles(n, "SALES_COMMNET", "editStyleRow");
				    			deficitProdPresent.deficitProdPresentGrid.grdMain.setCellStyles(n, "ANALYZE_REASON", "editStyleRow");
				    		}else if(menuCd == "DP31004"){ //구매
				    			deficitProdPresent.deficitProdPresentGrid.grdMain.setCellStyles(n, "PURCHASE_COMMENT", "editStyleRow");
				    		}
		    			}
		    		});
		    	}
		    }
		}, "obj");
	}
	
	function fn_checkClose() {
    	return gfn_getGrdSaveCount(deficitProdPresent.deficitProdPresentGrid.grdMain) == 0; 
    }
	
	function fn_setNextFieldsBuket() {
		var fields = [
			{fieldName: "GRP_LVL_ID"},
			{fieldName: "OPEN_YN"},
			{fieldName: "QTY", dataType : "number"},
			{fieldName: "AMT_KRW", dataType : "number"},
			{fieldName: "AMT_COST", dataType : "number"},
			{fieldName: "MAT_KRW", dataType : "number"},
			{fieldName: "LABOR_KRW", dataType : "number"},
			{fieldName: "EXP_KRW", dataType : "number"},
			{fieldName: "OUT_SRC_KRW", dataType : "number"},
			{fieldName: "PUR_PRICE_KRW", dataType : "number"},
			{fieldName: "AMT_SALES_TOTAL_PROFIT", dataType : "number"},
			{fieldName: "SGNA_KRW", dataType : "number"},
			{fieldName: "SALES_PROFIT", dataType : "number"},
			{fieldName: "FINANCE_COMMENT", dataType : "text"},
			{fieldName: "ANALYZE_BAND", dataType : "text"},
			{fieldName: "SALES_COMMNET", dataType : "text"},
			{fieldName: "ANALYZE_REASON", dataType : "text"},
			{fieldName: "ENG_COMMENT", dataType : "text"},
			{fieldName: "PROD_COMMENT", dataType : "text"},
			{fieldName: "PURCHASE_COMMENT", dataType : "text"},
			{fieldName: "MAT_KRW_RATE", dataType : "text"},
			{fieldName: "LABOR_KRW_RATE", dataType : "text"},
			{fieldName: "EXP_KRW_RATE", dataType : "text"},
			{fieldName: "OUT_SRC_KRW_RATE", dataType : "text"},
			{fieldName: "COMPANY_CD", dataType : "text"},
			{fieldName: "BU_CD", dataType : "text"}
        ];
    	
    	return fields;
	}
	
	function fn_setNextColumnsBuket() {
		var columns = [	
			{
                name: "OPEN_YN",
                fieldName: "OPEN_YN",
                header: {text: '<spring:message code="lbl.openYn"/>'},
                styles: {textAlignment: "near" ,background:gv_editColor},
                //dynamicStyles : [gfn_getDynamicStyle(-2)],
                width: 50,
                editable: false,
                dynamicStyles: [{
                    criteria: ["values['GRP_LVL_ID'] = 0","values['GRP_LVL_ID'] != 0"],
                    styles: ["renderer=check1","renderer=check2"]
                }]
                
                //renderer : gfn_getRenderer("CHECK")
            },
			{
				name : "QTY", fieldName: "QTY", editable: false, header: {text: '<spring:message code="lbl.salesQty." javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 50
			}, {
				name : "AMT_KRW", fieldName: "AMT_KRW", editable: false, header: {text: '<spring:message code="lbl.salesAmount" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "AMT_COST", fieldName: "AMT_COST", editable: false, header: {text: '<spring:message code="lbl.salesCost" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "MAT_KRW", fieldName: "MAT_KRW", editable: false, header: {text: '<spring:message code="lbl.materialCost" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "LABOR_KRW", fieldName: "LABOR_KRW", editable: false, header: {text: '<spring:message code="lbl.labor" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "EXP_KRW", fieldName: "EXP_KRW", editable: false, header: {text: '<spring:message code="lbl.cost" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "OUT_SRC_KRW", fieldName: "OUT_SRC_KRW", editable: false, header: {text: '<spring:message code="lbl.outsideOrderCost" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "PUR_PRICE_KRW", fieldName: "PUR_PRICE_KRW", editable: false, header: {text: '<spring:message code="lbl.goodsCost" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "AMT_SALES_TOTAL_PROFIT", fieldName: "AMT_SALES_TOTAL_PROFIT", editable: false, header: {text: '<spring:message code="lbl.grossMargin" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "SGNA_KRW", fieldName: "SGNA_KRW", editable: false, header: {text: '<spring:message code="lbl.sellingAndAdminist" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "SALES_PROFIT", fieldName: "SALES_PROFIT", editable: false, header: {text: '<spring:message code="lbl.operationProfit" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "FINANCE_COMMENT", fieldName: "FINANCE_COMMENT", editable: false, header: {text: '<spring:message code="lbl.financeNote" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "ANALYZE_BAND", fieldName: "ANALYZE_BAND", editable: false, header: {text: '<spring:message code="lbl.salesAnalysis" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "SALES_COMMNET", fieldName: "SALES_COMMNET", editable: false, header: {text: '<spring:message code="lbl.salesNote" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "ANALYZE_REASON", fieldName: "ANALYZE_REASON", editable: false, header: {text: '<spring:message code="lbl.salesAnalysisReason" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "ENG_COMMENT", fieldName: "ENG_COMMENT", editable: false, header: {text: '<spring:message code="lbl.techNote" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "PROD_COMMENT", fieldName: "PROD_COMMENT", editable: false, header: {text: '<spring:message code="lbl.manufacturingNote" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "PURCHASE_COMMENT", fieldName: "PURCHASE_COMMENT", editable: false, header: {text: '<spring:message code="lbl.purchaseNote" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "MAT_KRW_RATE", fieldName: "MAT_KRW_RATE", editable: false, header: {text: '<spring:message code="lbl.materialRatio" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 70
			}, {
				name : "LABOR_KRW_RATE", fieldName: "LABOR_KRW_RATE", editable: false, header: {text: '<spring:message code="lbl.laborRatio" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 70
			}, {
				name : "EXP_KRW_RATE", fieldName: "EXP_KRW_RATE", editable: false, header: {text: '<spring:message code="lbl.expenseRatio" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 70
			}, {
				name : "OUT_SRC_KRW_RATE", fieldName: "OUT_SRC_KRW_RATE", editable: false, header: {text: '<spring:message code="lbl.outsourcingRatio" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 70
			}, {
				name : "COMPANY_CD", fieldName: "COMPANY_CD", editable: false, header: {text: '<spring:message code="lbl.outsourcingRatio" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				visible : false,
				width: 70
			}, {
				name : "BU_CD", fieldName: "BU_CD", editable: false, header: {text: '<spring:message code="lbl.outsourcingRatio" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				visible : false,
				width: 70
			}
		];
		
		return columns;
	}
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<input type="hidden" id="itemType" name="itemType" value="10,50"/>
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divCustGroup"></div>
					<div class="view_combo" id="divContinueDeficit"></div>
					<div class="view_combo" id="divCount"></div>
					<div class="view_combo" id="divAmount">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.amount" /></div>
							<input type="text" id="amountFrom" name="amountFrom" class="ipt" style="width:55px"> <span class="ihpen">~</span>
							<input type="text" id="amountTo" name="amountTo" class="ipt" style="width:55px">
						</div> 
					</div>
					<jsp:include page="/WEB-INF/view/common/filterViewHorizonMonth.jsp" flush="false" />
					
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
			<div class="cbt_btn roleWrite">
			
				<div class="bright">
					<a id="btnReset" href="#" class="app1"><spring:message code="lbl.reset" /></a> 
					<a id="btnSave" href="#" class="app2"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
