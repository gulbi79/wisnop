<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 가용율 Trend -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var longRiverOrderingPlan = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.grid.initGrid();
		},
			
		_siq    : "supply.purchase.longRiverOrderingPlanList",
		
		initFilter : function() {
			
			var itemTypeEvent = {
				childId   : ["upItemGroup"],  
				childData : [this.comCode.codeMapEx.UPPER_ITEM_GROUP, this.comCode.codeMapEx.ROUTING]
				
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
				{target : 'divPlanId', id : 'planId', title : '<spring:message code="lbl.planId"/>', data : this.comCode.codeMap.PLAN_ID, exData:[''], type : "S" },
				{target : 'divProcurType', id : 'procurType', title : '<spring:message code="lbl.procure"/>', data : this.comCode.codeMap.PROCUR_TYPE, exData:[""], option: {allFlag:"Y"}},
				{target : 'divUpItemGroup', id : 'upItemGroup', title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent },
				{target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"]},
				{target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""], event : itemTypeEvent, option: {allFlag:"Y"}},
				{target : 'divIssue', id : 'issueYn', title : '<spring:message code="lbl.issueYn"/>', data : this.comCode.codeMap.FLAG_YN, exData:['*'], type : "S" },
			]);
			
			$("#purLtFrom,#purLtTo").inputmask("numeric");
			$("#issueYn").val("Y");
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,
			codeMap : null,
			
			initCode  : function () {
				var grpCd = 'ITEM_TYPE,PROCUR_TYPE,FLAG_YN';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["ITEM_GROUP", "UPPER_ITEM_GROUP"], null, {itemType : "20,30"});
				
				this.codeMap.ITEM_TYPE = $.grep(this.codeMap.ITEM_TYPE, function(v, n) {
					return v.CODE_CD == '20' || v.CODE_CD == '30'; 
				});
				
				gfn_service({
					async   : false,
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : {_mtd : "getList", tranData:[
						{outDs : "planList", _siq : longRiverOrderingPlan._siq + "PlanId"},
					]},
					success : function(data) {
						longRiverOrderingPlan.comCode.codeMap.PLAN_ID = data.planList;
					}
				}, "obj");
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
				this.gridInstance.custBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.setOptions();
				
				gfn_setMonthSum(longRiverOrderingPlan.grid.gridInstance, false, false, true);
				
				this.grdMain.onDataCellClicked = function (grid, index) {
					
					var rowId = index.itemIndex;
		       		var field = index.fieldName;
		       		var grpLvlId = grid.getValue(rowId, "GRP_LVL_ID");
		       		var planId = grid.getValue(rowId, "PLAN_ID");
	       			var itemCd = grid.getValue(rowId, "ITEM_CD");
	       			
		       		if(grpLvlId == 0 && field == "TOP_ITEM"){//최상위 품목
		       			
		       			gfn_comPopupOpen("FP_POP", {
		    				rootUrl : "supply/purchase",
		    				url     : "longRiverOrderTopItem",
		    				width   : 1050,
		    				height  : 680,
		    				planId : planId,
		    				itemCd : itemCd,
		    				rowId : rowId,
		    				callback : "",
		    				menuCd	 : "MP207"
		    			});
		       		}else if(grpLvlId == 0 && field == "DETAIL_INFO"){
		       			
		       			gfn_comPopupOpen("FP_POP", {
		    				rootUrl : "supply/purchase",
		    				url     : "longRiverOrderDetailInfo",
		    				width   : 1000,
		    				height  : 680,
		    				planId : planId,
		    				itemCd : itemCd,
		    				rowId : rowId,
		    				callback : "",
		    				menuCd	 : "MP207"
		    			});
		       		}
				};
			},
			
			setOptions : function() {
				
				this.grdMain.setOptions({
					stateBar: { visible : true  }
				});
				
				this.grdMain.addCellStyles([{
					id         : "editNoneStyleTotal",
					editable   : false,
					background : gv_totalColor
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
			
			$("#btnSave").on('click', function (e) {
				longRiverOrderingPlan.save();
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
					
					if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
					}else if(id == "divItem"){
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
					}else if(id == "divOpRate"){
						
						var purLtFrom = $("#purLtFrom").val();
						var purLtTo = $("#purLtTo").val();
						
						if(purLtFrom != "" && purLtTo != ""){
							EXCEL_SEARCH_DATA += $("#purLtFrom").val() + ' <spring:message code="lbl.moreThan" /> ' + $("#purLtTo").val() + ' <spring:message code="lbl.lessThan" />';	
						}else if(purLtFrom != "" && purLtTo == ""){
							EXCEL_SEARCH_DATA += $("#purLtFrom").val() + ' <spring:message code="lbl.moreThan" />';							
						}else if(purLtFrom == "" && purLtTo != ""){
							EXCEL_SEARCH_DATA += $("#purLtTo").val() + ' <spring:message code="lbl.lessThan" />';
						}else{
							EXCEL_SEARCH_DATA += "";
						}
					}else if(id == "divIssue"){
						EXCEL_SEARCH_DATA += $("#issueYn option:selected").text();
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
					
					/* if(data.resList.length == 1){
						data.resList = [];
					} */
					
					if (FORM_SEARCH.sql == 'N') {
						longRiverOrderingPlan.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						longRiverOrderingPlan.grid.grdMain.cancel();
						
						longRiverOrderingPlan.grid.dataProvider.setRows(data.resList);
						longRiverOrderingPlan.grid.dataProvider.clearSavePoints();
						longRiverOrderingPlan.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(longRiverOrderingPlan.grid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(longRiverOrderingPlan.grid.grdMain);
						
						longRiverOrderingPlan.gridCallback(data.resList);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		gridCallback : function(resList){
			
			var iconStyles = [{
		        criteria: "value='Y'",
		        styles: "iconIndex=0"
		    }, {
		        criteria: "value='N'",
		        styles: "iconIndex=-1"
		    }];
			
			//팝업 아이콘
			var imgs = new RealGridJS.ImageList("images1", GV_CONTEXT_PATH + "/statics/images/common/");
		    imgs.addUrls([
		        "ico_srh.png"
		    ]);

		    longRiverOrderingPlan.grid.grdMain.registerImageList(imgs);
		    
		    longRiverOrderingPlan.grid.grdMain.setColumnProperty("TOP_ITEM", "imageList", "images1");
		    longRiverOrderingPlan.grid.grdMain.setColumnProperty("TOP_ITEM", "renderer", {type : "icon"}); 
		    longRiverOrderingPlan.grid.grdMain.setColumnProperty("TOP_ITEM", "styles", {
			    textAlignment: "center",
			    iconIndex: 0,
			    iconLocation: "center",
			    iconAlignment: "center",
			    iconOffset: 4,
			    iconPadding: 2
			});
		    
		    longRiverOrderingPlan.grid.grdMain.setColumnProperty("TOP_ITEM", "dynamicStyles", iconStyles);

		    longRiverOrderingPlan.grid.grdMain.setColumnProperty("DETAIL_INFO", "imageList", "images1");
		    longRiverOrderingPlan.grid.grdMain.setColumnProperty("DETAIL_INFO", "renderer", {type : "icon"}); 
		    longRiverOrderingPlan.grid.grdMain.setColumnProperty("DETAIL_INFO", "styles", {
			    textAlignment: "center",
			    iconIndex: 0,
			    iconLocation: "center",
			    iconAlignment: "center",
			    iconOffset: 4,
			    iconPadding: 2
			});
		    
		    longRiverOrderingPlan.grid.grdMain.setColumnProperty("DETAIL_INFO", "dynamicStyles", iconStyles);
		    
		    
		    //TOTAL 수정 못하게 막기
		    $.each(resList, function(n,v){
		    	
		    	if(resList[n].GRP_LVL_ID != 0)
		    	{
		    		longRiverOrderingPlan.grid.grdMain.setCellStyles(n, "MAT_ISSUE_FLAG", "editNoneStyleTotal");
				    longRiverOrderingPlan.grid.grdMain.setCellStyles(n, "ADJ_PO_PLAN_QTY", "editNoneStyleTotal");
				    longRiverOrderingPlan.grid.grdMain.setCellStyles(n, "REMARK", "editNoneStyleTotal");
				    longRiverOrderingPlan.grid.grdMain.setCellStyles(n, "TOP_ITEM", "editNoneStyleTotal");
				    longRiverOrderingPlan.grid.grdMain.setCellStyles(n, "DETAIL_INFO", "editNoneStyleTotal");
				    			
		    	}
		    	
		    });
		    
		},
		
		save : function() {
			
			var dateChk = 0;
			var grdData = gfn_getGrdSavedataAll(this.grid.grdMain);
			var grdDataLen = grdData.length;
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			if(dateChk > 0){
				alert(dateChk + '<spring:message code="msg.dueDateChk"/>')
				return;
			}
			
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
				
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveUpdate";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : longRiverOrderingPlan._siq, grdData : grdData}
				];
				
				var ajaxOpt = {
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : FORM_SAVE,
					success : function(data) {
						
						alert('<spring:message code="msg.saveOk"/>');
						fn_apply(false);
					},
				};
				
				gfn_service(ajaxOpt, "obj");
			});
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		var purLtFrom = $("#purLtFrom").val();
		var purLtTo = $("#purLtTo").val();
		
		if(purLtFrom != "" && purLtTo != ""){
			if(Number(purLtFrom) >= Number(purLtTo)){
				alert('<spring:message code="msg.purLtMsg"/>');
				return;				
			}
		}
		
		gfn_getMenuInit();
		
		DIMENSION.hidden = [];
		DIMENSION.hidden.push({CD : "PLAN_ID", dataType : "text"});
		
		if (!sqlFlag) {
			longRiverOrderingPlan.grid.gridInstance.setDraw();
			
			var fileds = longRiverOrderingPlan.grid.dataProvider.getFields();
			var filedsLen = fileds.length;
			
			for (var i = 0; i < filedsLen; i++) {
				var fieldName = fileds[i].fieldName;
				if (fieldName == 'ITEM_COST_KRW2_NM' || fieldName == 'ADJ_PO_PLAN_QTY'){
					fileds[i].dataType = "number";
					longRiverOrderingPlan.grid.grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"});	
				}
			}
			longRiverOrderingPlan.grid.dataProvider.setFields(fileds);
		}
    	
    	FORM_SEARCH = $("#searchForm").serializeObject(); 
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.hiddenList = DIMENSION.hidden;
   		FORM_SEARCH.meaList	   = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
		longRiverOrderingPlan.search();
		longRiverOrderingPlan.excelSubSearch();
	}

	function fn_setFieldsBuket() {
    	//필드 배열 객체를  생성합니다.
    	
        var fields = [
            {fieldName : "MAT_ISSUE_FLAG"},
            {fieldName : "DETAIL_INFO"},
            {fieldName : "REMARK"},
            {fieldName : "TOP_ITEM"},
            {fieldName : "GI_QTY_Y1", dataType : "number"},
            {fieldName : "GI_QTY_Y0", dataType : "number"},
            {fieldName : "GI_QTY_M6", dataType : "number"},
            {fieldName : "GI_QTY_M5", dataType : "number"},
            {fieldName : "GI_QTY_M4", dataType : "number"},
            {fieldName : "GI_QTY_M3", dataType : "number"},
            {fieldName : "GI_QTY_M2", dataType : "number"},
            {fieldName : "GI_QTY_M1", dataType : "number"},
            {fieldName : "GI_QTY_M0", dataType : "number"},
            {fieldName : "MOL_QTY", dataType : "number"},
            {fieldName : "GR_SCHED_QTY", dataType : "number"},
            {fieldName : "MRP_QTY_W1", dataType : "number"},
            {fieldName : "MRP_QTY_W2", dataType : "number"},
            {fieldName : "MRP_QTY_W3", dataType : "number"},
            {fieldName : "MRP_QTY_W4", dataType : "number"},
            {fieldName : "MRP_QTY_M0", dataType : "number"},
            {fieldName : "MRP_QTY_M1", dataType : "number"},
            {fieldName : "MRP_QTY_M2", dataType : "number"},
            {fieldName : "MRP_QTY_M3", dataType : "number"},
            {fieldName : "MRP_QTY_M4", dataType : "number"},
            {fieldName : "MRP_QTY_M5", dataType : "number"},
            {fieldName : "MRP_QTY_M6", dataType : "number"},
            {fieldName : "MRP_QTY_M7", dataType : "number"},
            {fieldName : "MRP_QTY_M8", dataType : "number"},
            {fieldName : "MRP_QTY_M9", dataType : "number"},
            {fieldName : "MRP_QTY_M10", dataType : "number"},
            {fieldName : "MRP_QTY_M11", dataType : "number"},
            {fieldName : "MRP_QTY_M12", dataType : "number"},
            {fieldName : "MRP_TOTAL", dataType : "number"},
            {fieldName : "LT_REQ_QTY", dataType : "number"},
            {fieldName : "SS_QTY", dataType : "number"},
            {fieldName : "M3_RATE", dataType : "number"},
            {fieldName : "M6_RATE", dataType : "number"},
            {fieldName : "PO_PLAN_QTY", dataType : "number"},
            {fieldName : "ADJ_PO_PLAN_QTY", dataType : "number"}
        ];
    	return fields;
    }

    function fn_setColumnsBuket() {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
    	
        var columns = 
		[	
			{ //최상위품목
				name : "TOP_ITEM", fieldName: "TOP_ITEM", editable: false, header: {text: '<spring:message code="lbl.topItem" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background: gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-1)],
				width: 35,
				mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
			}, { //Issue 여부
				name: "MAT_ISSUE_FLAG",
                fieldName: "MAT_ISSUE_FLAG",
                editable: true,
                lookupDisplay: true,
                values: gfn_getArrayExceptInDs(longRiverOrderingPlan.comCode.codeMap.FLAG_YN, "CODE_CD", ""),
                labels: gfn_getArrayExceptInDs(longRiverOrderingPlan.comCode.codeMap.FLAG_YN, "CODE_NM", ""),
                editor: {
                    type: "dropDown",
                    domainOnly: true,
                    textReadOnly: true,
                }, 
                header: {text: '<spring:message code="lbl.issueYn"/>'},
                styles: {textAlignment: "center", background: gv_editColor},
                dynamicStyles : [gfn_getDynamicStyle(0)],
                width: 35,
                editButtonVisibility: "visible",
                mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
			}, {//출고 현황
                type: "group",
                name: '<spring:message code="lbl.factoryStatus" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.factoryStatus" javaScriptEscape="true" />' + gv_expand},
                fieldName: "WEEK_GROUP",
                width: 450,
                columns : [
                	{//전년 출고량
						name : "GI_QTY_Y1", fieldName: "GI_QTY_Y1", editable: false, header: {text: '<spring:message code="lbl.shippingLastYear" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50,
		                mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
					}, {//금년 출고량
						name : "GI_QTY_Y0", fieldName: "GI_QTY_Y0", editable: false, header: {text: '<spring:message code="lbl.shippingThisYear" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50,
		                mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
					}, {
						name : "GI_QTY_M6", fieldName: "GI_QTY_M6", editable: false, header: {text: '<spring:message code="lbl.mm6" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50,
		                mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
					}, {
						name : "GI_QTY_M5", fieldName: "GI_QTY_M5", editable: false, header: {text: '<spring:message code="lbl.mm5" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50,
		                mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
					}, {
						name : "GI_QTY_M4", fieldName: "GI_QTY_M4", editable: false, header: {text: '<spring:message code="lbl.mm4" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50,
		                mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
					}, {
						name : "GI_QTY_M3", fieldName: "GI_QTY_M3", editable: false, header: {text: '<spring:message code="lbl.mm3" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50,
		                mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
					}, {
						name : "GI_QTY_M2", fieldName: "GI_QTY_M2", editable: false, header: {text: '<spring:message code="lbl.mm2" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50,
		                mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
					}, {
						name : "GI_QTY_M1", fieldName: "GI_QTY_M1", editable: false, header: {text: '<spring:message code="lbl.mm1" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50,
		                mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
					}, {
						name : "GI_QTY_M0", fieldName: "GI_QTY_M0", editable: false, header: {text: '<spring:message code="lbl.mm0" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50,
		                mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
					}
                ]
            }, {//자재 현황
                type: "group",
                name: '<spring:message code="lbl.materialStatus" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.materialStatus" javaScriptEscape="true" />' + gv_expand},
                fieldName: "WEEK_GROUP2",
                width: 100,
                columns : [
                	{//과부족
						name : "MOL_QTY", fieldName: "MOL_QTY", editable: false, header: {text: '<spring:message code="lbl.overShort" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50,
						mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
					}, {//입고예정
						name : "GR_SCHED_QTY", fieldName: "GR_SCHED_QTY", editable: false, header: {text: '<spring:message code="lbl.expReciept" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50,
						mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
					}
                ]
            }, {//상세정보
            	name : "DETAIL_INFO", fieldName: "DETAIL_INFO", editable: false, header: {text: '<spring:message code="lbl.detailInfo" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background: gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-1)],
				width: 35,
				mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
			}, {
                type: "group",
                name: '<spring:message code="lbl.futureRequire" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.futureRequire" javaScriptEscape="true" />' + gv_expand},
                fieldName: "WEEK_GROUP3",
                width: 920,
                columns : [
                	{
						name : "MRP_QTY_W1", fieldName: "MRP_QTY_W1", editable: false, header: {text: '<spring:message code="lbl.ww01" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50
					}, {
						name : "MRP_QTY_W2", fieldName: "MRP_QTY_W2", editable: false, header: {text: '<spring:message code="lbl.ww02" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50
					}, {
						name : "MRP_QTY_W3", fieldName: "MRP_QTY_W3", editable: false, header: {text: '<spring:message code="lbl.ww03" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50
					}, {
						name : "MRP_QTY_W4", fieldName: "MRP_QTY_W4", editable: false, header: {text: '<spring:message code="lbl.ww04" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50
					}, {
						name : "MRP_QTY_M0", fieldName: "MRP_QTY_M0", editable: false, header: {text: '<spring:message code="lbl.am0" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50
					}, {
						name : "MRP_QTY_M1", fieldName: "MRP_QTY_M1", editable: false, header: {text: '<spring:message code="lbl.am1" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50
					}, {
						name : "MRP_QTY_M2", fieldName: "MRP_QTY_M2", editable: false, header: {text: '<spring:message code="lbl.am2" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50
					}, {
						name : "MRP_QTY_M3", fieldName: "MRP_QTY_M3", editable: false, header: {text: '<spring:message code="lbl.am3" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50
					}, {
						name : "MRP_QTY_M4", fieldName: "MRP_QTY_M4", editable: false, header: {text: '<spring:message code="lbl.am4" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50
					}, {
						name : "MRP_QTY_M5", fieldName: "MRP_QTY_M5", editable: false, header: {text: '<spring:message code="lbl.am5" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50
					}, {
						name : "MRP_QTY_M6", fieldName: "MRP_QTY_M6", editable: false, header: {text: '<spring:message code="lbl.am6" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50
					}, {
						name : "MRP_QTY_M7", fieldName: "MRP_QTY_M7", editable: false, header: {text: '<spring:message code="lbl.am7" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50
					}, {
						name : "MRP_QTY_M8", fieldName: "MRP_QTY_M8", editable: false, header: {text: '<spring:message code="lbl.am8" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50
					}, {
						name : "MRP_QTY_M9", fieldName: "MRP_QTY_M9", editable: false, header: {text: '<spring:message code="lbl.am9" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50
					}, {
						name : "MRP_QTY_M10", fieldName: "MRP_QTY_M10", editable: false, header: {text: '<spring:message code="lbl.am10" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50
					}, {
						name : "MRP_QTY_M11", fieldName: "MRP_QTY_M11", editable: false, header: {text: '<spring:message code="lbl.am11" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50
					}, {
						name : "MRP_QTY_M12", fieldName: "MRP_QTY_M12", editable: false, header: {text: '<spring:message code="lbl.am12" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50
					}, {//1년 투입계획 수량
						name : "MRP_TOTAL", fieldName: "MRP_TOTAL", editable: false, header: {text: '<spring:message code="lbl.1yInputPlanQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 70
					}
                ]
            }, {//발주 근거 자료
                type: "group",
                name: '<spring:message code="lbl.evidenceOfOrder" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.evidenceOfOrder" javaScriptEscape="true" />' + gv_expand},
                fieldName: "WEEK_GROUP4",
                width: 150,
                columns : [
                	{//L/T내 소요량
						name : "LT_REQ_QTY", fieldName: "LT_REQ_QTY", editable: false, header: {text: '<spring:message code="lbl.ltRequire" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50,
						mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
					}, {//안전재고
						name : "SS_QTY", fieldName: "SS_QTY", editable: false, header: {text: '<spring:message code="lbl.safetyInv" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50,
						mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
					}, {//발주 예정량
						name : "PO_PLAN_QTY", fieldName: "PO_PLAN_QTY", editable: false, header: {text: '<spring:message code="lbl.EstOrder" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50,
						mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
					}
                ]
            }, {//증감률
                type: "group",
                name: '<spring:message code="lbl.changeRate" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.changeRate" javaScriptEscape="true" />' + gv_expand},
                fieldName: "WEEK_GROUP5",
                width: 100,
                columns : [
                	{//3개월 기준
						name : "M3_RATE", fieldName: "M3_RATE", editable: false, header: {text: '<spring:message code="lbl.3mStand" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50,
						mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
					}, {//6개월기준
						name : "M6_RATE", fieldName: "M6_RATE", editable: false, header: {text: '<spring:message code="lbl.6mStand" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 50,
						mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
					}
                ]
            }, {//추가발주 협의량
				name : "ADJ_PO_PLAN_QTY", fieldName: "ADJ_PO_PLAN_QTY", editable: true, header: {text: '<spring:message code="lbl.addOrder" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background: gv_editColor},
				dynamicStyles : [gfn_getDynamicStyle(0)],
				dataType : "text",
				width: 100,
				mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
			}, {//비고(SNOP 협의결과)
				name : "REMARK", fieldName: "REMARK", editable: true, header: {text: '<spring:message code="lbl.remarkSnop" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background: gv_editColor},
				dynamicStyles : [gfn_getDynamicStyle(0)],
				dataType : "text",
				width: 200,
				mergeRule    : { criteria: "values['ITEM_CD_NM']+value" }
			}
		];
    	return columns;
    }

	// onload 
	$(document).ready(function() {
		longRiverOrderingPlan.init();
	});
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divPlanId"></div>
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divOpRate">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.purLt" /></div>
							<input type="text" id="purLtFrom" name="purLtFrom" class="ipt" style="width:37px"/><font size="1px"> <spring:message code="lbl.moreThan" /></font>
							<input type="text" id="purLtTo" name="purLtTo" class="ipt" style="width:37px"/><font size="1px"> <spring:message code="lbl.lessThan" /></font>
						</div> 
					</div>
					<div class="view_combo" id="divIssue"></div>
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
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
			<div class="cbt_btn" style="height:25px">
				<div class="bleft">
				</div>
				<div class="bright">
					<a href="javascript:;" id="btnReset" class="app1 roleWrite"><spring:message code="lbl.reset" /></a>
					<a href="javascript:;" id="btnSave" class="app1 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
