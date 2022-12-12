<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 가용율 Trend -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var confirmFlag = false;
	var materialPlanRate = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.grid.initGrid();
		},
			
		_siq    : "supply.purchase.materialPlanRateList",
		
		initFilter : function() {
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divProcurType', id : 'procurType', title : '<spring:message code="lbl.procure"/>', data : this.comCode.codeMap.PROCUR_TYPE, exData:[""], option: {allFlag:"N"}},
				{target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""], option: {allFlag:"N"}},
				{target : 'divWeekPlanYn', id : 'weekPlanYn', title : '<spring:message code="lbl.weekPlanYn"/>', data : this.comCode.codeMap.Y_N_NULL, exData:[""], option: {allFlag:"N"}},
				{target : 'divDailyPlanYn', id : 'dailyPlanYn', title : '<spring:message code="lbl.dailyPlanYn"/>', data : this.comCode.codeMap.Y_N_NULL, exData:[""], option: {allFlag:"N"}},
				{target : 'divSilinder', id : 'silinder', title : '<spring:message code="lbl.silinder2"/>', data : this.comCode.codeMap.FLAG_YN, exData:[""], type : "S"},
			]);
			
			var dateParam = {
				arrTarget : [
					{calId : "fromCal", weekId : "fromWeek", defVal : 0},
					{calId : "toCal", weekId : "toWeek", defVal : 1}
				]
			};
			DATEPICKET(dateParam);
			$('#fromCal').datepicker("option", "maxDate", new Date().getWeekDay(0, false));
			
			//$("#dailyPlanYn").multipleSelect("setSelects", ["Y", "N"]);
			$("#silinder").val("Y");
			
			dayDate(true);
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,
			codeMap : null,
			
			initCode  : function () {
				var grpCd = 'ITEM_TYPE,PROCUR_TYPE,Y_N_NULL,FLAG_YN';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				//this.codeMapEx = gfn_getComCodeEx(["ITEM_GROUP", "UPPER_ITEM_GROUP", "ROUTING", "REP_CUST_GROUP"], null, {itemType : "20,30"});
				
				this.codeMap.ITEM_TYPE = $.grep(this.codeMap.ITEM_TYPE, function(v,n) {
					return v.CODE_CD == '20' || v.CODE_CD == '30'; 
				});
				
				this.codeMap.PROCUR_TYPE = $.grep(this.codeMap.PROCUR_TYPE, function(v,n) {
					return v.CODE_CD == 'OH' || v.CODE_CD == 'OP'|| v.CODE_CD == 'MM'; 
				});
				
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
				
				this.setOptions();
				
				this.gridInstance.custBeforeBucketFalg = true;
				this.gridInstance.custNextBucketFalg = true;
				
				gfn_setMonthSum(materialPlanRate.grid.gridInstance, false, false, true);
				
				this.grdMain.onDataCellClicked = function (grid, index) {
					
			    	var rowId     = index.itemIndex;
		       		var field     = index.fieldName;
		       		var grpLvlId  = grid.getValue(rowId, "GRP_LVL_ID");
		       		
		       		if(grpLvlId == 0 && field == "POP_UP_MARTER") {
		       			
		       			var yearWeek = grid.getValue(rowId, "YEAR_WEEK");
		       			var itemCd = grid.getValue(rowId, "ITEM_CD");
		       			
		       			gfn_comPopupOpen("POP_UP_MARTER", {
							rootUrl    : "supply/purchase",
							url        : "materialPlanRateDetail",
							width      : 1200,
							height     : 680,
							yearWeek   : yearWeek,
							itemCd     : itemCd,
							menuCd     : "MP209"
						});
		       		}
			    };
			},
			
			setOptions : function() {
				
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
				materialPlanRate.save();
			});
			
			$("#btnConfirmY").on("click", function(e) {
				fn_confirm("Y");
			});
			
			$("#btnConfirmN").on("click", function(e) {
				fn_confirm("N");
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
					}else if(id == "divWeekPlanYn"){
						EXCEL_SEARCH_DATA += $("#weekPlanYn option:selected").text();
					}else if(id == "divDailyPlanYn"){
						EXCEL_SEARCH_DATA += $("#dailyPlanYn option:selected").text();
					}else if(id == "divSilinder"){
						EXCEL_SEARCH_DATA += $("#silinder option:selected").text();
					}else if(id == "divStandDate"){
						EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ")";
					}
				}
			});
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }, { outDs : "authorityList",_siq : this._siq + "Authority"}, { outDs : "tableCnt",_siq : this._siq + "TableCnt"}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						
						if(data.resList.length == 1){
							data.resList = [];
						}
						
						materialPlanRate.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						materialPlanRate.grid.grdMain.cancel();
						
						materialPlanRate.grid.dataProvider.setRows(data.resList);
						materialPlanRate.grid.dataProvider.clearSavePoints();
						materialPlanRate.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(materialPlanRate.grid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(materialPlanRate.grid.grdMain);
						
						materialPlanRate.grid.grdMain.setCellStyles(0, ["POP_UP_MARTER", "AVAIL_GR_DATE"], "editNoneStyleTotal");
						
						materialPlanRate.gridCallback(data);
					}
				}
			}
			gfn_service(aOption, "obj");
		},
		
		gridCallback : function(data){
			
			var auth = data.authorityList[0].CNT;
			var tableCnt = data.tableCnt[0].CNT;
			var editStyleVal = {};
			var val = gfn_getDynamicStyle(-2);
			
			editStyleVal.background = gv_editColor;
			editStyleVal.editable = true;
			
			val.criteria.push("(values['EDIT_YN'] = 'Y')");
			val.styles.push(editStyleVal);
			
			materialPlanRate.grid.grdMain.setColumnProperty(materialPlanRate.grid.grdMain.columnByField("REMARK"), "dynamicStyles", [val]);
			materialPlanRate.grid.grdMain.setColumnProperty(materialPlanRate.grid.grdMain.columnByField("AVAIL_GR_DATE"), "dynamicStyles", [val]);
			
			/* var editStyleVal2 = {};
			var val2 = gfn_getDynamicStyle(-2);
			
			editStyleVal2.background = gv_noneEditColor;
			editStyleVal2.editable = false;
			editStyleVal2.editor = {type : "date", datetimeFormat : "yyyy-MM-dd"};
			
			val2.criteria.push("(values['EDIT_YN'] = 'N')");
			val2.styles.push(editStyleVal2);
			
			materialPlanRate.grid.grdMain.setColumnProperty(materialPlanRate.grid.grdMain.columnByField("AVAIL_GR_DATE"), "dynamicStyles", [val2]); */
			
			if(auth > 0){
				$("#btnConfirmY").show();
				$("#btnConfirmN").show();	
			}
			
			if(tableCnt > 0){
				
				$("#btnConfirmY").addClass("app1");
				$("#btnConfirmN").addClass("app1");
				
				$("#btnConfirmY").removeClass("app");
				$("#btnConfirmN").removeClass("app");
				
				
				confirmFlag = true;
				
			}else{
				
				$("#btnConfirmY").addClass("app");
				$("#btnConfirmN").addClass("app");
				
				$("#btnConfirmY").removeClass("app1");
				$("#btnConfirmN").removeClass("app1");
				
				confirmFlag = false;
			}
			
			$("#planWeek").val($("#fromWeek").val());
			
		},
		
		getBucket : function (sqlFlag) {
			var ajaxMap = {
				fromDate : $("#startDate").val(),
				toDate : $("#endDate").val(),
				day     : {isDown: "Y", isUp:"N", upCal:"W", isMt:"N", isExp:"N", expCnt:999}, //, isFullNm:"Y"
				sqlId : ["bucketDay"]
			}
			
			gfn_getBucket(ajaxMap);
			
			var subBucket = new Array();
			
			subBucket = [
				{CD : "PLAN", NM : '<spring:message code="lbl.plan"/>'},
				{CD : "RST", NM : '<spring:message code="lbl.ware"/>'},
				{CD : "OVER", NM : '<spring:message code="lbl.overShort"/>'},
				{CD : "COMP_QTY", NM : '<spring:message code="lbl.dayResultQty"/>'},
				{CD : "COMP_RATE", NM : '<spring:message code="lbl.dayResultRate"/>'}
			];
			gfn_setCustBucket(subBucket);
			
			if(!sqlFlag){
				
				DIMENSION.hidden = [];
				DIMENSION.hidden.push({DIM_CD : "YEAR_WEEK", CD : "YEAR_WEEK", dataType : "text"});
				
				materialPlanRate.grid.gridInstance.setDraw();
				
				var iconStyles = [{
			        criteria: "value='Y'",
			        styles: "iconIndex=0"
			    }, {
			        criteria: "value='N'",
			        styles: "iconIndex=-1"
			    }];
				
				var imgs = new RealGridJS.ImageList("images1", GV_CONTEXT_PATH + "/statics/images/common/");
			    imgs.addUrls([
			        "ico_srh.png"
			    ]);

			    materialPlanRate.grid.grdMain.registerImageList(imgs);
			    
			    materialPlanRate.grid.grdMain.setColumnProperty("POP_UP_MARTER", "imageList", "images1");
			    materialPlanRate.grid.grdMain.setColumnProperty("POP_UP_MARTER", "renderer", {type : "icon"}); 
				
			    materialPlanRate.grid.grdMain.setColumnProperty("POP_UP_MARTER", "styles", {
				    textAlignment: "center",
				    iconIndex: 0,
				    iconLocation: "center",
				    iconAlignment: "center",
				    iconOffset: 4,
				    iconPadding: 2
				});
			    
			    materialPlanRate.grid.grdMain.setColumnProperty("POP_UP_MARTER", "dynamicStyles", iconStyles);
			} 
		},
		save : function (){
			
			var grdData = gfn_getGrdSavedataAll(materialPlanRate.grid.grdMain);
			
			var grdDataLen = grdData.length;
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
					
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveUpdate";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : "supply.purchase.materialPlanRateList", grdData : grdData},
				];
				
				var ajaxOpt = {
					url     : GV_CONTEXT_PATH + "/biz/obj.do",
					data    : FORM_SAVE,
					success : function(data) {
						
						alert('<spring:message code="msg.saveOk"/>');
						fn_apply(false);
					},
				};
				
				gfn_service(ajaxOpt, "obj");
			});
		},
	};
	
    function fn_confirm(confirm_yn) {
    	
    	if(confirmFlag){
    		var msg = "";
        	
        	if(confirm_yn == "Y"){
    			msg = '<spring:message code="msg.wantConfirm"/>';
    		}else{
    			msg = '<spring:message code="msg.cancelConfirm"/>';
    		}
        	
    		confirm(msg, function() {
    			
    			FORM_SAVE          = {}; //초기화
    			FORM_SAVE._mtd     = "saveUpdate";
    			FORM_SAVE.tranData = [{outDs : "saveCnt", _siq : "supply.purchase.materialPlanRateConfirm", grdData : [{confirmYn : confirm_yn, planWeek : $("#planWeek").val()}]}];
    			
    			gfn_service({
    				url    : GV_CONTEXT_PATH + "/biz/obj.do",
    				data   : FORM_SAVE,
    				success: function(data) {
    					if(confirm_yn == "Y") {
    						alert('<spring:message code="msg.confirmed"/>');
    					} else {
    						alert('<spring:message code="msg.cancelConfirmed"/>');
    					}
    					
    					fn_apply();
    				}
    			}, "obj");
    		});	
    	}
    }
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		gfn_getMenuInit();
		
		materialPlanRate.getBucket(sqlFlag); //2. 버켓정보 조회
		
		$.each(BUCKET.query, function(i, val){
			val.CD_SUB = val.CD + "_ACC";
		});
		
    	FORM_SEARCH = $("#searchForm").serializeObject(); 
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.hiddenList = DIMENSION.hidden;
   		FORM_SEARCH.bucketList = BUCKET.query;
		materialPlanRate.search();
		materialPlanRate.excelSubSearch();
	}

	function dayDate(flag){
		
		var params  = {};
		params.yearWeek = $("#fromWeek").val();
		params._mtd = "getList";
		params.tranData = [{outDs : "resList", _siq : "supply.purchase.dayList"}];
		
		var opt = {
			url     : GV_CONTEXT_PATH + "/biz/obj.do",
			data    : params,
			async   : false,
			success : function(data) {
				
				$("#startDate").val(data.resList[0].YYYYMMDD);
				$("#endDate").val(data.resList[1].YYYYMMDD);
				
				if(flag){
					var dayNm = data.resList[2].YYYYMMDD;
					
					if(dayNm == "FRI" || dayNm == "SAT"){
						$('#fromCal').datepicker("option", "maxDate", new Date().getWeekDay(1, false));	
					}
				}
			}
		};
		gfn_service(opt, "obj");
	}
	
	function fn_setBeforeFieldsBuket() {
		var fields = [
			{fieldName: "POP_UP_MARTER"},
			{fieldName: "DAY_YN"},
			{fieldName: "DAY_PLAN_QTY", dataType : "number"},
			{fieldName: "RST_QTY", dataType : "number"},
			{fieldName: "DAY_MOL_QTY", dataType : "number"},
			{fieldName: "DAY_COMP_QTY", dataType : "number"},
			{fieldName: "DAY_COMP_RATE", dataType : "number"},
        ];
    	
    	return fields;
	}
	
	function fn_setBeforeColumnsBuket() {
		var columns = [	
			{
				name : "POP_UP_MARTER", fieldName : "POP_UP_MARTER", editable : false, header: {text: '<spring:message code="lbl.materialsInfo" javaScriptEscape="true" />'},
				styles : {textAlignment: "near", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-1)],
				width : 80
			}, {
                type: "group",
                name: '<spring:message code="lbl.dailyPlanQtyAccum" javaScriptEscape="true" />',
                header: {text : '<spring:message code="lbl.dailyPlanQtyAccum" javaScriptEscape="true" />'},
                width: 400,
                columns : [
                	{
						name : "DAY_YN", fieldName: "DAY_YN", editable: false, header: {text: '<spring:message code="lbl.dailyAccumYn" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "text",
						width: 80
					}, {
						name : "DAY_PLAN_QTY", fieldName: "DAY_PLAN_QTY", editable: false, header: {text: '<spring:message code="lbl.accumPlan" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "RST_QTY", fieldName: "RST_QTY", editable: false, header: {text: '<spring:message code="lbl.accumWare" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "DAY_MOL_QTY", fieldName: "DAY_MOL_QTY", editable: false, header: {text: '<spring:message code="lbl.overShort" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "DAY_COMP_QTY", fieldName: "DAY_COMP_QTY", editable: false, header: {text: '<spring:message code="lbl.accumRate3" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "DAY_COMP_RATE", fieldName: "DAY_COMP_RATE", editable: false, header: {text: '<spring:message code="lbl.accumRate2" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}
              	]
            }
		];
		return columns;
	}
	
	function fn_setNextFieldsBuket() {
    	//필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName : "WEEK_PLAN_QTY", dataType : "number"},
            {fieldName : "WEEK_RST_QTY", dataType : "number"},
            {fieldName : "WEEK_MOL_QTY", dataType : "number"},
            {fieldName : "WEEK_COMP_QTY", dataType : "number"},
            {fieldName : "WEEK_COMP_RATE", dataType : "number"},
            {fieldName : "OVER_SHORT", dataType : "number"},
            {fieldName : "RECV_INSP_QTY", dataType : "number"},
            {fieldName : "CC_QTY", dataType : "number"},
            {fieldName : "RECV_QC_NG_QTY", dataType : "number"},
            {fieldName : "REMARK"},
            {fieldName : "AVAIL_GR_DATE"},
            {fieldName : "EDIT_YN"}
        ];
    	return fields;
    }

    function fn_setNextColumnsBuket() {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = 
		[	
			{
                type: "group",
                name: '<spring:message code="lbl.weekPlanQty" javaScriptEscape="true" />',
                header: {text : '<spring:message code="lbl.weekPlanQty" javaScriptEscape="true" />'},
                width: 400,
                columns : [
                	{
						name : "WEEK_PLAN_QTY", fieldName: "WEEK_PLAN_QTY", editable: false, header: {text: '<spring:message code="lbl.weekPlanQty" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "WEEK_RST_QTY", fieldName: "WEEK_RST_QTY", editable: false, header: {text: '<spring:message code="lbl.weekWareResult" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "WEEK_MOL_QTY", fieldName: "WEEK_MOL_QTY", editable: false, header: {text: '<spring:message code="lbl.overShort" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "WEEK_COMP_QTY", fieldName: "WEEK_COMP_QTY", editable: false, header: {text: '<spring:message code="lbl.weekResultQty" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "WEEK_COMP_RATE", fieldName: "WEEK_COMP_RATE", editable: false, header: {text: '<spring:message code="lbl.weekProgress" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}
              	]
            }, {
                type: "group",
                name: '<spring:message code="lbl.materialStatus" javaScriptEscape="true" />',
                header: {text : '<spring:message code="lbl.materialStatus" javaScriptEscape="true" />'},
                width: 400,
                columns : [
                	{
						name : "OVER_SHORT", fieldName: "OVER_SHORT", editable: false, header: {text: '<spring:message code="lbl.shortRate" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "RECV_INSP_QTY", fieldName: "RECV_INSP_QTY", editable: false, header: {text: '<spring:message code="lbl.inspection" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "CC_QTY", fieldName: "CC_QTY", editable: false, header: {text: '<spring:message code="lbl.ccQty2" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "RECV_QC_NG_QTY", fieldName: "RECV_QC_NG_QTY", editable: false, header: {text: '<spring:message code="lbl.defect" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}
              	]
            }, {
				name : "REMARK", fieldName: "REMARK", editable: false, header: {text: '<spring:message code="lbl.remark" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
				dynamicStyles : [gfn_getDynamicStyle(-1)],
				dataType : "number",
				width: 240
			}, {
				name : "AVAIL_GR_DATE", fieldName: "AVAIL_GR_DATE", editable: false, header: {text: '<spring:message code="lbl.wareAvaDate" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-1)],
				dataType : "text",
				width: 160
			}
		];
    	return columns;
    }

	// onload 
	$(document).ready(function() {
		materialPlanRate.init();
	});
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<input type="hidden" id="planWeek" name="planWeek"/>
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divWeekPlanYn"></div>
					<div class="view_combo" id="divDailyPlanYn"></div>
					<div class="view_combo" id="divSilinder"></div>
					<div class="view_combo" id="divStandDate">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.weekDim"/></div>
							<input type="text" id="fromCal" name="fromCal" class="iptdate datepicker2" onchange="dayDate();"/>
							<input type="text" id="fromWeek" name="fromWeek" class="iptdateweek" disabled="disabled" value=""/>
							<input type="hidden" id="toCal" name="toCal"/>
							<input type="hidden" id="toWeek" name="toWeek"/>
							<input type="hidden" id="swFromDate" name="swFromDate"/>
							<input type="hidden" id="swToDate" name="swToDate"/>
							<input type="hidden" id="startDate" name="startDate"/>
							<input type="hidden" id="endDate" name="endDate"/>
						</div>
					</div>
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
					<a style="display:none" href="javascript:;" id="btnConfirmY" class="app1 roleWrite"><spring:message code="lbl.confirm" /></a>
					<a style="display:none" href="javascript:;" id="btnConfirmN" class="app1 roleWrite"><spring:message code="lbl.confirmCancel" /></a>
					<a href="javascript:;" id="btnReset" class="app1 roleWrite"><spring:message code="lbl.reset" /></a>
					<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
