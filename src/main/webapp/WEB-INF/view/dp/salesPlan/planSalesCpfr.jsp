<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>

	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var planIdAll = [];
	var planIdSelect = {};
	var authSelect = "";
	var currentWeek = "";
	var btnClickYn = "N";
	var cpfrYnArray, totalArray, EXCEL_GRID_DATA;
	
	var planSalesCpfr = {

		init : function () {
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.salesGrid.initGrid();
		},
			
		_siq    : "dp.planSalesCpfr.planSalesCpfr",
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap   : null,
			codeMapEx : null,
			
			initCode  : function () {
				var grpCd    = 'FLAG_YN';
				this.codeMap = gfn_getComCode(grpCd, "Y"); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["ITEM_GROUP", "ROUTING", "UPPER_ITEM_GROUP"], null, {itemType : ""});
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
				{ target : 'divPlanId', id : 'planId', title : '<spring:message code="lbl.planId"/>', data : [], exData:[""], type : "S"},
				{ target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING, exData:["*"] },
				{ target : 'divUpItemGroup', id : 'upItemGroup', title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent },
				{ target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"] },
				{ target : 'divCpfrYn', id : 'cpfrYn', title : '<spring:message code="lbl.cpfrYn"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"},
			]);
			
			planSalesCpfr.prodPlanId();
		},
		
		prodPlanId : function() {
			FORM_SEARCH          = $("#searchForm").serializeObject(); //초기화
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "versionList", _siq : planSalesCpfr._siq + "Version"}, { outDs : "authList", _siq : planSalesCpfr._siq + "Auth"}];
			
			// 계획버전 
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj.do",
			    data    : FORM_SEARCH,
			    success : function(data) {
			    	
			    	var roleLen = data.authList.length;
			    	
			    	planIdAll = data.versionList;
			    	planIdSelect = data.versionList[0];
			    	currentWeek = data.versionList[0].CURRENT_WEEK;
			    	
			    	if(roleLen >= 1){
			    		authSelect = data.authList[0].ROLE_CD;	
			    	}
			    	
			    	gfn_setMsCombo("planId", planIdAll, [""]);
			    }
			},"obj");
		},
		
		/* 
		* grid  선언
		*/
		salesGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.gridInstanceExcel = new GRID();
				this.gridInstanceExcel.init("realgridExcel");
				
				this.grdMainExcel      = this.gridInstanceExcel.objGrid;
				this.dataProviderExcel = this.gridInstanceExcel.objData;
				
				this.gridInstance.custBeforeBucketFalg = true;
				this.gridInstanceExcel.custBeforeBucketFalg = true;
				
				this.setOptions();
				
				this.grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue){
					
					var fieldName = planSalesCpfr.salesGrid.dataProvider.getFieldName(field);
					var itemCd =  grid.getValue(itemIndex, "ITEM_CD");
					var meaListLen = FORM_SEARCH.meaList.length;
					
					if(fieldName == "CPFR_YN"){
						var totCnt = 0;
						var rows = grid.getDataProvider().getJsonRows();
						
						$.each(rows, function(n, v){
							
							var rowsItemCd = v.ITEM_CD;
							
							if(rowsItemCd == itemCd){
								
								var categoryCd = grid.getValue(n, "CATEGORY_CD");
								grid.getDataProvider().setValue(n, field, newValue);
								
								//CPFR_YN에 따라 수정가능 및 수정 불가능 으로 
								if(categoryCd == "CPFR_SP" || categoryCd == "CPFR_VARY_SP"){
									var fileds = planSalesCpfr.salesGrid.dataProvider.getFields();
									var filedsLen = fileds.length;			
									
									for (var i = 0; i < filedsLen; i++) {
										
										var fieldName = fileds[i].fieldName;
										
										if(fieldName == "M0" || fieldName == "M1" || fieldName == "M2" || fieldName == "M3" || fieldName == "M4"){
											
											if(newValue == "N"){
												planSalesCpfr.salesGrid.grdMain.setCellStyles(n, fieldName, "editNoneStyle2");		
												//planSalesCpfr.salesGrid.grdMain.setValue(n, fieldName, "");
											}else if(newValue == "Y"){
												if(authSelect == "ADMIN" || authSelect == "SCM"){
													planSalesCpfr.salesGrid.grdMain.setCellStyles(n, fieldName, "editStyle");
												}else{
													if(categoryCd == "CPFR_SP"){
														planSalesCpfr.salesGrid.grdMain.setCellStyles(n, fieldName, "editStyle");
													}
												}
											}
										}
									}	
								}
								
								totCnt++;	
								
								if(meaListLen == totCnt){
									return false;	
								}
							}
						});
					}
				};
			},
			
			setOptions : function() {
				
				this.grdMain.setOptions({
					stateBar: { visible : true  }
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
				
				this.grdMain.addCellStyles([{
					id         : "editNoneStyle",
					editable   : false,
					background : gv_totalColor
				}]);
				
				this.grdMain.addCellStyles([{
					id         : "editNoneStyle2",
					editable   : false,
					background : gv_bucketColor
				}]);
				
				this.grdMainExcel.setOptions({
					stateBar: { visible : true  },
					sorting : { enabled      : false },
					display : { columnMovable: false }
				});
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnReset").on ("click", function() { 
				fn_reset(); 
			});
			
			$("#btnSave").on ("click", function() { 
				fn_save(); 
			});
			
			$("#btnConfirmY").on ("click", function() {
				fn_confirm("Y"); 
			});
			$("#btnConfirmN").on ("click", function() { 
				fn_confirm("N"); 
			});
			
			$("#planId").on("change", function(e){
				fn_planIdChange("N");
			});
			
			$("#btnExcelDown").click ("on", function() { 
				fn_excelDown(false); 
			});
			
			$("#btnExcelUpload").click ("on", function() { 
				var flag = $("#btnExcelUpload").hasClass("app1");
				if(flag){
					$("#excelFile").trigger("click");	
				}
			});
			
			$("#excelFile").change("on", function() { 
				fn_excelUpload();	
			});
			
			$("#btnSummary").on('click', function (e) {
				
				gfn_comPopupOpen("CPFR_SUMMARY", {
					rootUrl : "dp/salesPlan",
					url     : "salesPlanCpfrSummary",
					width   : 1200,
					height  : 680,
					planId : $("#planId").val(),
					menuCd : "DP219"
				});
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
					if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
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
					}else if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}else if(id == "divDrawNo"){
						EXCEL_SEARCH_DATA += $("#drawNo").val();
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
					}else if(id == "divCpfrYn"){
						EXCEL_SEARCH_DATA += $("#cpfrYn option:selected").text();
					}
				}
			});
		},
		
		// 조회
		search : function () {
			
			var pastYnFlag = "N";
			var currentYnFlag = "N";
			var futureYnFlag = "N";
			
			$.each(BUCKET.query, function(n, v) {
				
				var pcfFlag = v.FLAG;
				var nm = v.NM;
				
				if(pcfFlag == "P"){
					pastYnFlag = "Y";	
				}else if(pcfFlag == "C"){
					currentYnFlag = "Y";
				}else if(pcfFlag == "F"){
					futureYnFlag == "Y";
				}
			});
			
			FORM_SEARCH.pastYn = pastYnFlag;
			FORM_SEARCH.currentYn = currentYnFlag;
			FORM_SEARCH.futureYn = futureYnFlag;
			FORM_SEARCH.currentWeek = currentWeek;
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.fromMonth = planIdSelect.CPFR_START_MONTH;
			FORM_SEARCH.tranData = [{ outDs : "resList", _siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						planSalesCpfr.salesGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						planSalesCpfr.salesGrid.grdMain.cancel();
						
						planSalesCpfr.salesGrid.dataProvider.setRows(data.resList);
						planSalesCpfr.salesGrid.dataProvider.clearSavePoints();
						planSalesCpfr.salesGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_actionMonthSum(planSalesCpfr.salesGrid.gridInstance);
						gfn_setRowTotalFixed(planSalesCpfr.salesGrid.grdMain);
						
						planSalesCpfr.gridCallback(data.resList);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			var ajaxMap = {
				fromMonth : planIdSelect.CPFR_START_MONTH,
				toMonth   : planIdSelect.CPFR_END_MONTH,
				excelFlag : "N",
				sqlId    : ["dp.planSalesCpfr.bucketAll", "dp.planSalesCpfr.bucketAll2"]
			}
			gfn_getBucket(ajaxMap);
			
			if (!sqlFlag) {
				
				DIMENSION.hidden = [];
				DIMENSION.hidden.push({CD : "CONFIRM_FLAG", dataType : "text"});
				DIMENSION.hidden.push({CD : "PLAN_ID", dataType : "text"});
				
				planSalesCpfr.salesGrid.gridInstance.setDraw();
				
				var fileds = planSalesCpfr.salesGrid.dataProvider.getFields();
				var filedsLen = fileds.length;
				
				for (var i = 0; i < filedsLen; i++) {
					var fieldName = fileds[i].fieldName;
					if (fieldName == 'SALES_PRICE_KRW_NM'){
						fileds[i].dataType = "number";
						planSalesCpfr.salesGrid.grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"});	
					}
				}
				
				planSalesCpfr.salesGrid.dataProvider.setFields(fileds);
			}
		},
		
		getBucketExcel : function (sqlFlag) {
			
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj.do",
			    data    : {
			    	_mtd           : "getList",
			    	SEARCH_MENU_CD : "${menuInfo.menuCd}",
			    	tranData       : [
			    		{outDs : "dimList", _siq : "admin.dimMapMenu"},
			    		{outDs : "meaList", _siq : "common.meaConf"},
			    	]
			    },
			    success :function(data) {
			    	
			    	DIMENSION.user = [];
			    	DIMENSION.user = data.dimList;
			    	
			    	DIMENSION.hidden = [];
					DIMENSION.hidden.push({CD : "CONFIRM_FLAG", dataType : "text"});
					DIMENSION.hidden.push({CD : "PLAN_ID", dataType : "text"});
			    	
			    	MEASURE.user = [];
			    	
			    	$.each(data.meaList, function(idx, mea) {
			    		
			    		var measCd = mea.MEAS_CD;
			    		
			    		if(measCd.indexOf("CPFR_SP") != -1 && measCd.indexOf("_AMT_KRW") == -1){
			    			mea.CD = measCd;
			    			mea.NM = mea.MEAS_NM;
			    			MEASURE.user.push(mea);
			    		}
			    	});
			    	
			    	var ajaxMap = {
						fromMonth : planIdSelect.CPFR_START_MONTH,
						toMonth   : planIdSelect.CPFR_END_MONTH,
						excelFlag : "Y",
						sqlId    : ["dp.planSalesCpfr.bucketAll", "dp.planSalesCpfr.bucketAll2"]
					}
					gfn_getBucket(ajaxMap);
					
					if (!sqlFlag) {
						
						EXCEL_GRID_DATA = {
							DIM : DIMENSION.user,
							DIM_H : DIMENSION.hidden,
							MEA : MEASURE.user,
							BUC : BUCKET.query
						};	
						
						planSalesCpfr.salesGrid.gridInstanceExcel.setDraw();
						
						var fileds = planSalesCpfr.salesGrid.dataProviderExcel.getFields();
						var filedsLen = fileds.length;
						
						for (var i = 0; i < filedsLen; i++) {
							var fieldName = fileds[i].fieldName;
							if (fieldName == 'SALES_PRICE_KRW_NM'){
								fileds[i].dataType = "number";
								//planSalesCpfr.salesGrid.grdMainExcel.setColumnProperty(fieldName, "styles", {"numberFormat" : "###0"});	
							}
						}
						planSalesCpfr.salesGrid.dataProviderExcel.setFields(fileds); 
					}
			    }
			}, "obj");
		},
		
		gridCallback : function(resList){
			
			cpfrYnArray = new Array();
			totalArray = new Array();
			
			var monthRemainQtyNm = "";
			
			$.each(resList, function(n, v){
    			
				var grpLvlId = v.GRP_LVL_ID;
    			var confirmFlag = v.CONFIRM_FLAG2;
    			var itemSelect = v.ITEM_SELECT;
    			
   				if(confirmFlag == "Y" && itemSelect == "Y") {
   					cpfrYnArray.push(n);
   				}
   				
   				if(grpLvlId != 0){
   					totalArray.push(n);
   				}
    		});
			
			planSalesCpfr.salesGrid.grdMain.setCellStyles(cpfrYnArray, "CPFR_YN", "editStyle");
			planSalesCpfr.salesGrid.grdMain.setCellStyles(totalArray, "CPFR_YN", "editNoneStyle");
			
			$.each(BUCKET.query, function(n, v) {
				
				var cd = v.CD;
				var rootCd = v.ROOT_CD;
				var colorFlag = v.FLAG;
				
				if((rootCd == "PLAN_CPFR" && cd != "PLAN_CPFR_TOT") || (rootCd == "OEMS" && cd != "OEMS_TOT")){
					var editStyle = {};
					var val = gfn_getDynamicStyle(-2);
					
					editStyle.background = gv_editColor;
					editStyle.editable = true;
					
					val.criteria.push("(values['CONFIRM_FLAG'] = 'Y')");
					val.styles.push(editStyle);
					
					planSalesCpfr.salesGrid.grdMain.setColumnProperty(planSalesCpfr.salesGrid.grdMain.columnByField(cd), "dynamicStyles", [val]);
					planSalesCpfr.salesGrid.grdMain.setColumnProperty(cd, "editor", {type : "number", positiveOnly : true, integerOnly : true});
				}
				
				//CPFR출하실적 현재주차_C + 미래주갗 색깔변경_F
				if(colorFlag == "C" || colorFlag == "F"){
					planSalesCpfr.salesGrid.grdMain.setColumnProperty(cd, "styles", {"background" : gv_whiteColor});
				}
				
				if(cd == "M0"){
					monthRemainQtyNm = v.NM;
				}else if(cd == "MONTH_REMAIN_QTY"){
					planSalesCpfr.salesGrid.grdMain.setColumnProperty(cd, "header", monthRemainQtyNm + ' <spring:message code="lbl.monthRemainQty"/> ');	
				}
			});
			
			planSalesCpfr.getBucketExcel(false); //2. 버켓정보 조회
			
			planSalesCpfr.salesGrid.grdMain.setColumnProperty("CATEGORY_NM", "width", 150); //Measure 길이 조정
			
			/* if(cpfrYnArray.length > 0){
				fn_saveEditYn("Y");
			} */
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		 		
		$("#realgrid").show();
		$("#realgridExcel").hide();
		 
		// 디멘젼, 메져
		gfn_getMenuInit();
		
		planSalesCpfr.getBucket(sqlFlag); //2. 버켓정보 조회
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.dimPreList = DIMENSION.pre;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		FORM_SEARCH.authSelect = authSelect;
   		FORM_SEARCH.confirmFlag = planIdSelect.CONFIRM_FLAG;
   		
		planSalesCpfr.search();
		planSalesCpfr.excelSubSearch();
		fn_saveEditYn("Y");
	}
	
	function fn_excelDown(sqlFlag){
		
		if(btnClickYn == "Y"){
			
			planSalesCpfr.getBucketExcel(sqlFlag); //2. 버켓정보 조회
			
			var EXCEL_FORM = $("#searchForm").serializeObject();
			
			EXCEL_FORM.dimList	  = EXCEL_GRID_DATA.DIM;
			EXCEL_FORM.meaList	  = EXCEL_GRID_DATA.MEA;
			EXCEL_FORM.bucketList = EXCEL_GRID_DATA.BUC;
			EXCEL_FORM.hiddenList = EXCEL_GRID_DATA.DIM_H;
			EXCEL_FORM.authSelect = authSelect;
			EXCEL_FORM.confirmFlag = planIdSelect.CONFIRM_FLAG;
	   		EXCEL_FORM._mtd       = "getList";
	   		EXCEL_FORM.excelFlag  = "Y";
	   		EXCEL_FORM.tranData   = [{outDs : "gridList", _siq : "dp.planSalesCpfr.planSalesCpfr"}];
	   		
	   		gfn_service({
				url    : GV_CONTEXT_PATH + "/biz/obj.do",
				data   : EXCEL_FORM,
				success: function(data) {
					
					var gridListExcel = [];
					cpfrYnArray = new Array();
					
					$.each(data.gridList, function(idx, item) {
						
						var grpLvlId = item.GRP_LVL_ID;
		    			var confirmFlag = item.CONFIRM_FLAG;
		    			var itemSelect = item.ITEM_SELECT;
						
						if (grpLvlId == "0" && itemSelect == "Y") {
							gridListExcel.push(item);
						}
		    			
		   				if(confirmFlag == "Y" && itemSelect == "Y") {
		   					cpfrYnArray.push(idx);
		   				}
					});
					
					planSalesCpfr.salesGrid.dataProviderExcel.clearRows();
					planSalesCpfr.salesGrid.grdMainExcel.cancel();
					planSalesCpfr.salesGrid.dataProviderExcel.setRows(gridListExcel);
					planSalesCpfr.salesGrid.dataProviderExcel.clearSavePoints();
					planSalesCpfr.salesGrid.dataProviderExcel.savePoint();
					
					planSalesCpfr.salesGrid.grdMainExcel.setCellStyles(cpfrYnArray, "CPFR_YN", "editStyle");
					
					$.each(BUCKET.query, function(n, v) {
						
						var cd = v.CD;
						var rootCd = v.ROOT_CD;
						
						var editStyle = {};
						var val = gfn_getDynamicStyle(-2);
						
						editStyle.background = gv_editColor;
						editStyle.editable = true;
						
						val.criteria.push("(values['CONFIRM_FLAG'] = 'Y')");
						val.styles.push(editStyle);
						
						planSalesCpfr.salesGrid.grdMainExcel.setColumnProperty(planSalesCpfr.salesGrid.grdMainExcel.columnByField(cd), "dynamicStyles", [val]);
						//planSalesCpfr.salesGrid.grdMainExcel.setColumnProperty(cd, "editor", {type : "number", positiveOnly : true, integerOnly : true});
					}); 
					
					gfn_doExportExcel({
						gridIdx            : 1,
						fileNm             : "${menuInfo.menuNm} ("+$("#planId").val()+")",
						formYn             : "Y",
						indicator          : "hidden",
						conFirmFlag        : false,
						applyDynamicStyles : true
					});
				}
			}, "obj"); 
		}
	}
	
	function fn_excelUpload(){
		
		var confirmFlag = planIdSelect.CONFIRM_FLAG; //조회한 ConfirmYn
		
		if(btnClickYn == "N"){
			alert('<spring:message code="msg.excelUpload2"/>');
			return;
		}
		
		if(confirmFlag == "Y"){
			alert('<spring:message code="msg.confirmUpload"/>');
			return;
		}
		
		gfn_importGrid({
			gridIdx  : 1,
			callback : function() {
				
				planSalesCpfr.salesGrid.dataProviderExcel.clearSavePoints(); //그리드 초기화 포인트 저장
				planSalesCpfr.salesGrid.dataProviderExcel.savePoint();
				
				$("#realgridExcel").show(); // 엑셀그리드 보이기
				$("#realgrid").hide(); // 메인그리드 숨기기
				
				planSalesCpfr.salesGrid.grdMainExcel.resetSize();
			}
		});
	}
	
	
	function fn_save() {
		
		var jsonRows;
		var excelFlag = $("#realgrid").is(":visible");
		
		if(btnClickYn == "Y"){
			var confirmFlag = planIdSelect.CONFIRM_FLAG;
			
			if(excelFlag){
				jsonRows = gfn_getGrdSavedataAll(planSalesCpfr.salesGrid.grdMain);	
			}else{
				jsonRows = planSalesCpfr.salesGrid.dataProviderExcel.getJsonRows();
			}
			
			if(confirmFlag == "Y"){
				alert('<spring:message code="msg.confirmYn"/>');
				return;
			}
			
			if(jsonRows.length == 0){
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			confirm('<spring:message code="msg.saveCfm"/>', function() {
				
				var salesPlanDatas = [];
				var salesCpfrYnDatas = [];
				
				$.each(jsonRows, function(i, row) {
					
					var categoryCd = row.CATEGORY_CD;
					var cpfrYn = row.CPFR_YN;
					
					//수량 저장
					if(categoryCd == "CPFR_SP" || categoryCd == "CPFR_VARY_SP" || excelFlag == false){
						
						var planData = {
							ITEM_CD : row.ITEM_CD_NM,
							PLAN_ID : planIdSelect.CODE_CD,
							MEAS_CD : gfn_nvl(categoryCd, "CPFR_SP"),
							CPFR_YN : cpfrYn,
							SALES_PLAN_QTY_M0 : row.M0,
							SALES_PLAN_QTY_M1 : row.M1,
							SALES_PLAN_QTY_M2 : row.M2,
							SALES_PLAN_QTY_M3 : row.M3,
							SALES_PLAN_QTY_M4 : row.M4,
							OEMS_QTY_M0 : row.OEMS_M0,
							OEMS_QTY_M1 : row.OEMS_M1,
							OEMS_QTY_M2 : row.OEMS_M2,
							OEMS_QTY_M3 : row.OEMS_M3,
							OEMS_QTY_M4 : row.OEMS_M4
						};
						salesPlanDatas.push(planData);	
					}
					
					//CPFR_YN 저장
					if(categoryCd == "CPFR_SP" || excelFlag == false){
						var cpfrData = {
							ITEM_CD : row.ITEM_CD_NM,
							CPFR_YN : row.CPFR_YN 
						};
						salesCpfrYnDatas.push(cpfrData);
					}
				});
				
				FORM_SAVE              = {};
				FORM_SAVE._mtd         = "saveUpdate";
				FORM_SAVE.tranData     = [
					{outDs : "saveCnt1", _siq : "dp.planSalesCpfr.salesPlanCpfr", grdData : salesPlanDatas},
					{outDs : "saveCnt2", _siq : "dp.planSalesCpfr.salesPlanCpfrYn", grdData : salesCpfrYnDatas}
				];

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
	}
	
	function fn_confirm(confirm_yn) {
		
		if(btnClickYn == "Y"){
			var msg = "";
			var processYn = "N";
			var confirmFlag = planIdSelect.CONFIRM_FLAG; //조회한 ConfirmYn
			
			if(authSelect == "ADMIN" || authSelect == "SCM"){
				processYn = "Y";
			}else{
				
				if(confirm_yn == "N"){ //버튼에서 선택한 Confirnm Y N
					alert('<spring:message code="msg.scmMsg"/>');
					return;
				}else if(confirm_yn == "Y"){
					if(confirmFlag == "Y"){
						alert('<spring:message code="msg.alreadyConfirm"/>');
						return;	
					}else if(confirmFlag == "N"){
						processYn = "Y";	
					}
				}
			}
			
			if(confirm_yn == "Y"){
				msg = '<spring:message code="msg.wantConfirm"/>';
			}else{
				msg = '<spring:message code="msg.cancelConfirm"/>';
			} 
			
			if(processYn == "Y"){
				confirm(msg, function() {
					
					var jsonRowsNew = [];
					
					var confirmData = {
						CONFIRM_YN : confirm_yn,
						PLAN_ID    : planIdSelect.CODE_CD
					};
					
					jsonRowsNew.push(confirmData);
					
					FORM_SAVE          = {}; //초기화
					FORM_SAVE._mtd     = "saveUpdate";
					FORM_SAVE.tranData = [{outDs : "saveCnt", _siq : "dp.planSalesCpfr.salesPlanConfirmYn", grdData : jsonRowsNew}];
					
					gfn_service({
						url    : GV_CONTEXT_PATH + "/biz/obj.do",
						data   : FORM_SAVE,
						success: function(data) {
							if(confirm_yn == "Y") {
								alert('<spring:message code="msg.confirmed"/>');
							} else {
								alert('<spring:message code="msg.cancelConfirmed"/>');
							}
							
							fn_planIdChange("Y");
							fn_apply();
						}
					}, "obj"); 
				});
			}
		}
	}
	
	function fn_planIdChange(flag){
		
		var planId = $("#planId").val();
		
		FORM_SEARCH          = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.planId   = planId;
		FORM_SEARCH.tranData = [{ outDs : "versionList", _siq : planSalesCpfr._siq + "Version"}];
		
		// 계획버전 
		gfn_service({
		    async   : false,
		    url     : GV_CONTEXT_PATH + "/biz/obj.do",
		    data    : FORM_SEARCH,
		    success : function(data) {
		    	planIdSelect = data.versionList[0];
		    }
		},"obj");
		
		fn_saveEditYn(flag);
	}
	
	function fn_saveEditYn(flag){
		
		if(flag == "Y"){
			$("#btnConfirmY").removeClass("app");
			$("#btnConfirmY").addClass("app1");	
			$("#btnConfirmN").removeClass("app");
			$("#btnConfirmN").addClass("app1");	
			$("#btnSave").removeClass("app");
			$("#btnSave").addClass("app1");	
			$("#btnExcelDown").removeClass("app");
			$("#btnExcelDown").addClass("app1");	
			$("#btnExcelUpload").removeClass("app");
			$("#btnExcelUpload").addClass("app1");	
			btnClickYn = "Y";
		}else if(flag == "N"){
			$("#btnConfirmY").removeClass("app1");
			$("#btnConfirmY").addClass("app");	
			$("#btnConfirmN").removeClass("app1");
			$("#btnConfirmN").addClass("app");	
			$("#btnSave").removeClass("app1");
			$("#btnSave").addClass("app");
			$("#btnExcelDown").removeClass("app1");
			$("#btnExcelDown").addClass("app");
			$("#btnExcelUpload").removeClass("app1");
			$("#btnExcelUpload").addClass("app");
			btnClickYn = "N";
		}
	}
	
	function fn_reset() {
		planSalesCpfr.salesGrid.grdMain.cancel();
		planSalesCpfr.salesGrid.dataProvider.rollback(planSalesCpfr.salesGrid.dataProvider.getSavePoints()[0]);
		//planSalesCpfr.gridCallback();
		planSalesCpfr.salesGrid.grdMain.setCellStyles(cpfrYnArray, "CPFR_YN", "editStyle");
		planSalesCpfr.salesGrid.grdMain.setCellStyles(totalArray, "CPFR_YN", "editNoneStyle");
	}
	
	
	function fn_setBeforeFieldsBuket() {
		var fields = [
			{fieldName: "CPFR_YN", dataType : "text"}
        ];
    	
    	return fields;
	}
	
	function fn_setBeforeColumnsBuket() {
		var columns = [	
			{
				name : "CPFR_YN", fieldName: "CPFR_YN", editable: false, header: {text: '<spring:message code="lbl.cpfrYn" javaScriptEscape="true" />'},
				styles: {textAlignment: "center", background : gv_noneEditColor},
				mergeRule    : { criteria: "prevvalues + value" },
				dataType : "text",
				width: 80,
				editable : false,
				editor   : { type: "dropDown", domainOnly: true },
				values   : gfn_getArrayExceptInDs(planSalesCpfr.comCode.codeMap.FLAG_YN, "CODE_CD", ""),
				labels   : gfn_getArrayExceptInDs(planSalesCpfr.comCode.codeMap.FLAG_YN, "CODE_NM", ""),
				lookupDisplay: true
			}
		];
		return columns;
	}

	// onload 
	$(document).ready(function() {
		planSalesCpfr.init();
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
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divPlanId"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divDrawNo">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.drawNo"/></div>
							<input type="text" id="drawNo" name="drawNo" class="ipt"/>
						</div>
					</div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divCpfrYn"></div>
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
				<div id="realgrid" class="realgrid1"></div>
				<div id="realgridExcel" class="realgrid1" style="display:none;"></div>
			</div>
			<div class="cbt_btn" style="height:25px">
				<div class="bleft">
					<form id="excelForm" method="post" enctype="multipart/form-data">
						<input type="file" name="excelFile" id="excelFile" style="display: none;" />
						<input type="hidden" id="headerLine" name="headerLine" value="2" />
						<input type="hidden" id="columnNames" name="columnNames" />
					</form>
					<a href="javascript:;" id="btnExcelDown" class="app roleWrite"><spring:message code="lbl.excelDownload" /></a>
					<a href="javascript:;" id="btnExcelUpload" class="app roleWrite"><spring:message code="lbl.excelUpload" /></a>
					<a href="javascript:;" id="btnConfirmY" class="app roleWrite"><spring:message code="lbl.confirm" /></a>
					<a href="javascript:;" id="btnConfirmN" class="app roleWrite"><spring:message code="lbl.confirmCancel" /></a>
				</div>
				<div class="bright">
					<a href="javascript:;" id="btnSummary" class="app1"><spring:message code="lbl.summary" /></a>
					<a href="javascript:;" id="btnReset" class="app1 roleWrite"><spring:message code="lbl.reset" /></a>
					<a href="javascript:;" id="btnSave" class="app roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
