<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<!-- Prod. Plan  Compliance Rate, 생산계획 준수율  -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var currWeekVal = gfn_getCurrentDate();
	var currYearWeek = currWeekVal.YEARWEEK;
	
	var prodPlanCm = {

		init : function () {
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.prodGrid.initGrid();
		},
			
		_siq    : "snop.oprtKpi.prodPalnCmplRt",
		
		initFilter : function() {
			
			var itemTypeEvent = {
				childId   : ["upItemGroup","route"],  
				childData : [this.comCode.codeMapEx.UPPER_ITEM_GROUP , this.comCode.codeMapEx.SUB_ROUTING ]
			
			};
			
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
				{ target : 'divProcurType', id : 'procurType', title : '<spring:message code="lbl.procure"/>', data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{ target : 'divItemType',     id : 'itemType',      title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:["*"], event : itemTypeEvent},
				{ target : 'divUpItemGroup', id : 'upItemGroup', title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent },
				{ target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"] },
				{ target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.SUB_ROUTING, exData:["*"] },
				{ target : 'divCpRt', id : 'cpRt', title : '<spring:message code="lbl.obeyYn"/>', data : this.comCode.codeMap.COMPLIANCE_RATE, exData:["*"], type : "S"},
				/* { target : 'divProdPlan', id : 'prodPlan', title : '<spring:message code="lbl.prodPlanQty"/>', data : this.comCode.codeMap.PROD_PLAN_CD, exData:[""], type : "R"}, */
				{ target : 'divWeek', id : 'week', title : '<spring:message code="lbl.prodPlanQty"/>', data : this.comCode.codeMap.WEEK, exData:[""], type : "R"},
			]);
			
			$("#itemType").multipleSelect("setSelects", ["10"]);
			
			/* $(':radio[name=prodPlan]:input[value="N"]').attr("checked", true); */
			$(':radio[name=week]:input[value="STD"]').attr("checked", true);
			
			var dateParam = {
				arrTarget : [
					{calId : "fromCal", weekId : "fromWeek", defVal : 0}
				]};
			DATEPICKET(dateParam);
			$('#fromCal').datepicker("option", "maxDate", new Date().getWeekDay(0, false));
			
			fnFromCalChange();
			
			setTimeout(function(){
				$("#divWeek ul li").removeAttr("style");
			}, 100);
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap   : null,
			codeMapEx : null,
			
			initCode  : function () {
				var grpCd    = 'COMPLIANCE_RATE,PROCUR_TYPE,PROD_PLAN_CD,ITEM_TYPE,WEEK';
				this.codeMap = gfn_getComCode(grpCd, "Y"); //공통코드 조회

				this.codeMapEx = gfn_getComCodeEx(["ITEM_GROUP", "SUB_ROUTING", "UPPER_ITEM_GROUP"], null, {itemType : "10,20"});
				
				this.codeMap.PROCUR_TYPE = $.grep(this.codeMap.PROCUR_TYPE, function(v,n) {
					return v.CODE_CD == 'MG' || v.CODE_CD == 'MH'; 
				});
				
				this.codeMap.ITEM_TYPE = $.grep(this.codeMap.ITEM_TYPE, function(v,n) {
					return v.CODE_CD == '10' || v.CODE_CD == '20'; 
				});
			}
		},
	
		/* 
		* grid  선언
		*/
		prodGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				gfn_setMonthSum(prodPlanCm.prodGrid.gridInstance, false, false, true);
				
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#fromCal").on("change", function(e){
				fnFromCalChange();
			});
			
			$("#btnSummary").on('click', function (e) {

				FORM_SEARCH = {};
		    	//조회조건 설정
		    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
		    	FORM_SEARCH.sql = false;
				 
				gfn_comPopupOpen("MP_PROD_PLAN_CMPL", {
					rootUrl : "snop/oprtKpi",
					url     : "prodPlanCmplSummary",
					width   : 900,
					height  : 680,
					menuCd  : "SNOP304"
				});
			});
			
			
		},
		
		excelSubSearch : function (){
			
			$.each($(".view_combo"), function(i, val){
				
				var temp = "";
				var id = gfn_nvl($(this).attr("id"), "");
				
				/* if(id == "divProdPlan"){
					return;
				} */
				
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
					}else if(id == "divCpRt"){
						EXCEL_SEARCH_DATA += $("#cpRt option:selected").text();
					}else if(id == "divWeekId"){
						EXCEL_SEARCH_DATA += $("#fromCal").val() + "("+ $("#fromWeek").val() +")";
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
						prodPlanCm.prodGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						prodPlanCm.prodGrid.grdMain.cancel();
						
						prodPlanCm.prodGrid.dataProvider.setRows(data.resList);
						prodPlanCm.prodGrid.dataProvider.clearSavePoints();
						prodPlanCm.prodGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_actionMonthSum(prodPlanCm.prodGrid.gridInstance);
						gfn_setRowTotalFixed(prodPlanCm.prodGrid.grdMain);
						
						prodPlanCm.gridCallback();
					}
				}
			}
			gfn_service(aOption, "obj");
		},
		
		gridCallback : function(){
			var val = $(':radio[name="week"]:checked').val();
			var result = '<spring:message code="lbl.PreproductionW1"/>';
			
			if(val == "SALES"){
				result = '<spring:message code="lbl.precedProd6"/>';
			}
			prodPlanCm.prodGrid.grdMain.setColumnProperty("W1_PREPRODUCTION_QTY", "header", result);			
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {

		// 디멘젼, 메져
		gfn_getMenuInit();
		
		if (!sqlFlag) {
			
			for (var i in DIMENSION.user) {
				if (DIMENSION.user[i].DIM_CD.indexOf("SALES_PRICE_KRW") > -1) {
					DIMENSION.user[i].numberFormat = "#,##0";
				}
			}
			
			prodPlanCm.prodGrid.gridInstance.setDraw();
			//접힘 처리
			gfn_setChildColumnResize(prodPlanCm.prodGrid.gridInstance, prodPlanCm.prodGrid.grdMain, 'WEEK_ACTIVE');
			gfn_setChildColumnResize(prodPlanCm.prodGrid.gridInstance, prodPlanCm.prodGrid.grdMain, 'WEEK_ACTIVE2');
			var fileds = prodPlanCm.prodGrid.dataProvider.getFields();
			
			for (var i in fileds) {
				if (fileds[i].fieldName.indexOf("SALES_PRICE_KRW") > -1) {
					fileds[i].dataType = "number";
				}
			}
			prodPlanCm.prodGrid.dataProvider.setFields(fileds);
		}
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
   		
		prodPlanCm.search();
		prodPlanCm.excelSubSearch();
	}
	
	
	function fn_setFieldsBuket() {
    	//필드 배열 객체를  생성합니다.
        var fields = [
            { fieldName : "W0_PL_QTY"     , dataType : "number" },
            { fieldName : "W0_GOODS_QTY"  , dataType : "number" },
            { fieldName : "W0_DEFECT_QTY" , dataType : "number" },
            { fieldName : "W0_CMPL_QTY"   , dataType : "number" },
            { fieldName : "W0_SPEC_QTY"   , dataType : "number" },
            { fieldName : "W0_ACIV_RATE"  , dataType : "number" },
            { fieldName : "W1_ACIV_RATE"  , dataType : "number" },
            { fieldName : "W2_ACIV_RATE"  , dataType : "number" },
            { fieldName : "W3_ACIV_RATE"  , dataType : "number" },
            { fieldName : "W4_ACIV_RATE"  , dataType : "number" },
            
            //김동현B 요청사항: [준수율2 (%, 수량기준)]
            //*계산식: 달성률 컬럼 그대로 반영하되, 100% 초과일 경우, 100%으로 표기
            { fieldName : "W0_ACIV_RATE2"  , dataType : "number" },
            { fieldName : "W1_ACIV_RATE2"  , dataType : "number" },
            { fieldName : "W2_ACIV_RATE2"  , dataType : "number" },
            { fieldName : "W3_ACIV_RATE2"  , dataType : "number" },
            { fieldName : "W4_ACIV_RATE2"  , dataType : "number" },
            
            
            { fieldName : "UN0_CNT"       , dataType : "number" },
            { fieldName : "OB0_CNT"       , dataType : "number" },
            { fieldName : "CMPL_CNT"      , dataType : "number" },
            { fieldName : "CMPL0_RATE"    , dataType : "number" },
            { fieldName : "CMPL1_RATE"    , dataType : "number" },
            { fieldName : "CMPL2_RATE"    , dataType : "number" },
            { fieldName : "CMPL3_RATE"    , dataType : "number" },
            { fieldName : "CMPL4_RATE"    , dataType : "number" },
            { fieldName : "W0_PL_CNT"     , dataType : "number" },
            { fieldName : "FQC_DATA"      , dataType : "number" },
            { fieldName : "W1_PREPRODUCTION_QTY", dataType : "number" },
        ];
    	
    	return fields;
    }

    function fn_setColumnsBuket() {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = 
		[	
			{   //계획건수
				name      : "W0_PL_CNT", 
				fieldName : "W0_PL_CNT",
				header    : {text: '<spring:message code="lbl.planCnt" javaScriptEscape="true" />'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, { //준수
				name      : "OB0_CNT", 
				fieldName : "OB0_CNT",
				header    : {text: '<spring:message code="lbl.comp" javaScriptEscape="true" />'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {//미달
				name      : "UN0_CNT", 
				fieldName : "UN0_CNT",
				header    : {text: '<spring:message code="lbl.shot" javaScriptEscape="true" />'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {//합계
				name      : "CMPL_CNT", 
				fieldName : "CMPL_CNT",
				header    : {text: '<spring:message code="lbl.total" javaScriptEscape="true" />'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
                type      : "group",
				name      : "CMPL_RATE", 
				header    : { fixedHeight : 20, text : '<spring:message code="lbl.cmplRate"/>' + gv_expand },
				width     : 500, 
				columns   : [
					{
						name      : "CMPL4_RATE", 
						fieldName : "CMPL4_RATE",
						header    : {text: 'W-4'},
						styles    : {textAlignment: "far", numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType  : "number",
						editable  : false,
						width     : 100
					}, {
						name      : "CMPL3_RATE", 
						fieldName : "CMPL3_RATE",
						header    : {text: 'W-3'},
						styles    : {textAlignment: "far", numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType  : "number",
						editable  : false,
						width     : 100
					}, {
						name      : "CMPL2_RATE", 
						fieldName : "CMPL2_RATE",
						header    : {text: 'W-2'},
						styles    : {textAlignment: "far", numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType  : "number",
						editable  : false,
						width     : 100
					}, {
						name      : "CMPL1_RATE", 
						fieldName : "CMPL1_RATE",
						header    : {text: 'W-1'},
						styles    : {textAlignment: "far", numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType  : "number",
						editable  : false,
						width     : 100
					}, {
						name      : "CMPL0_RATE", 
						fieldName : "CMPL0_RATE",
						header    : {text: '<spring:message code="lbl.thisWeek" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType  : "number",
						editable  : false,
						width     : 100
					}
				]
			}, { //계획수량
				name      : "W0_PL_QTY",
				fieldName : "W0_PL_QTY",
				header    : {text : '<spring:message code="lbl.planQty"/>'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, { //W-1 선행생산
				name      : "W1_PREPRODUCTION_QTY",
				fieldName : "W1_PREPRODUCTION_QTY",
				header    : {text : '<spring:message code="lbl.PreproductionW1"/>'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, { //FQC DATA
				name      : "FQC_DATA",
				fieldName : "FQC_DATA",
				header    : {text : '<spring:message code="lbl.fqc2"/>'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, { //합격 + 특채
				name      : "W0_GOODS_QTY", 
				fieldName : "W0_GOODS_QTY", 
				header    : {text: '<spring:message code="lbl.psQty" />'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, { // 합격수량
				name      : "W0_CMPL_QTY",
				fieldName : "W0_CMPL_QTY",
				header    : {text : '<spring:message code="lbl.passedQty"/>'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, { // 불량수
				name      : "W0_DEFECT_QTY", 
				fieldName : "W0_DEFECT_QTY", 
				header    : {text: '<spring:message code="lbl.defectQty" />'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, { // 특채 수량
				name      : "W0_SPEC_QTY",
				fieldName : "W0_SPEC_QTY",
				header    : {text : '<spring:message code="lbl.specialQty"/>'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
                type      : "group",
				name      : "WEEK_ACTIVE", 
				header    : { fixedHeight : 20, text : '<spring:message code="lbl.achieRate"/>' + gv_expand },
				width     : 500, 
				columns   : [
					{
						name      : "W4_ACIV_RATE", 
						fieldName : "W4_ACIV_RATE",
						header    : {text: 'W-4'},
						styles    : {textAlignment: "far", numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType  : "number",
						editable  : false,
						width     : 100
					}, {
						name      : "W3_ACIV_RATE", 
						fieldName : "W3_ACIV_RATE",
						header    : {text: 'W-3'},
						styles    : {textAlignment: "far", numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType  : "number",
						editable  : false,
						width     : 100
					}, {
						name      : "W2_ACIV_RATE", 
						fieldName : "W2_ACIV_RATE",
						header    : {text: 'W-2'},
						styles    : {textAlignment: "far", numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType  : "number",
						editable  : false,
						width     : 100
					}, {
						name      : "W1_ACIV_RATE", 
						fieldName : "W1_ACIV_RATE",
						header    : {text: 'W-1'},
						styles    : {textAlignment: "far", numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType  : "number",
						editable  : false,
						width     : 100
					}, {
						name      : "W0_ACIV_RATE", 
						fieldName : "W0_ACIV_RATE",
						header    : {text: '<spring:message code="lbl.thisWeek" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType  : "number",
						editable  : false,
						width     : 100
					}
				]
			},
			
			//김동현B 요청사항: [준수율2 (%, 수량기준)]
            //*계산식: 달성률 컬럼 그대로 반영하되, 100% 초과일 경우, 100%으로 표기
			{
                type      : "group",
                name      : "WEEK_ACTIVE2", 
                header    : { fixedHeight : 20, text : '준수율2 (%, 수량기준)' + gv_expand },
                width     : 500, 
                columns   : [
                    {
                        name      : "W4_ACIV_RATE2", 
                        fieldName : "W4_ACIV_RATE2",
                        header    : {text: 'W-4'},
                        styles    : {textAlignment: "far", numberFormat : "#,##0"},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        dataType  : "number",
                        editable  : false,
                        width     : 100
                    }, {
                        name      : "W3_ACIV_RATE2", 
                        fieldName : "W3_ACIV_RATE2",
                        header    : {text: 'W-3'},
                        styles    : {textAlignment: "far", numberFormat : "#,##0"},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        dataType  : "number",
                        editable  : false,
                        width     : 100
                    }, {
                        name      : "W2_ACIV_RATE2", 
                        fieldName : "W2_ACIV_RATE2",
                        header    : {text: 'W-2'},
                        styles    : {textAlignment: "far", numberFormat : "#,##0"},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        dataType  : "number",
                        editable  : false,
                        width     : 100
                    }, {
                        name      : "W1_ACIV_RATE2", 
                        fieldName : "W1_ACIV_RATE2",
                        header    : {text: 'W-1'},
                        styles    : {textAlignment: "far", numberFormat : "#,##0"},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        dataType  : "number",
                        editable  : false,
                        width     : 100
                    }, {
                        name      : "W0_ACIV_RATE2", 
                        fieldName : "W0_ACIV_RATE2",
                        header    : {text: '<spring:message code="lbl.thisWeek" javaScriptEscape="true" />'},
                        styles    : {textAlignment: "far", numberFormat : "#,##0"},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        dataType  : "number",
                        editable  : false,
                        width     : 100
                    }
                ]
            }
		];
    	
    	return columns;
    }
    
    function fnFromCalChange(){
    	
    	var fromWeekVal = $("#fromWeek").val();
    	var resultCurrYn = "N";
    	
    	if(currYearWeek == fromWeekVal){//현재 주차
    		resultCurrYn = "Y";
    	}
    	
    	$("#resultCurrYn").val(resultCurrYn);
    }

	// onload 
	$(document).ready(function() {
		prodPlanCm.init();
	});
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<!-- <input type="hidden" id="itemType" name="itemType" value="10,20"/> -->
		<input type="hidden" id="resultCurrYn" name="resultCurrYn" value="N"/>
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divCpRt"></div>
					<!-- <div class="view_combo" id="divProdPlan" style="display:none;"></div> -->
					<div class="view_combo" id="divWeekId">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.weekId" /></div>
							<input type="text" id="fromCal" name="fromCal" class="iptdate datepicker2" />
							<input type="text" id="fromWeek" name="fromWeek" class="iptdateweek" disabled="disabled" value=""/>
							<input type="hidden" id="swFromDate" name="swFromDate"/>
							<input type="hidden" id="swToDate" name="swToDate"/>
						</div>
					</div>
					<div class="view_combo" id="divWeek"></div>
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
			<div class="cbt_btn" style="height:25px">
				
				<div class="bright">
					<a href="javascript:;" id="btnSummary"  class="app1"><spring:message code="lbl.summary" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
