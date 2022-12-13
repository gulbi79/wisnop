<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
	var enterSearchFlag = "Y";
	var monthCount = 12;
	var matRequirPlan = {
		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.grid.initGrid();
			this.events();
		},
		
		_siq    : "aps.planResult.matRequirPlan",
		
		comCode : {
			codeMapEx : null,
			codeMap   : null,
			initCode  : function() {
				var grpCd      = 'PROCUR_TYPE,FLAG_YN,ITEM_TYPE,MATERIAL_SHORT_TYPE_CD,SALE_QA_TYPE';
				this.codeMap   = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["ITEM_GROUP"]);
				
				this.codeMap.ITEM_TYPE = $.grep(this.codeMap.ITEM_TYPE, function(v,n) {
		           	return $.inArray(v.CODE_CD,["10","50"]) == -1;
		        });
			}
		},
		
		initFilter : function() {
			//Plan ID
	    	fn_getPlanId({picketType : "W", planTypeCd : "MP"});
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.materialsCode"/>' },
				{ target : 'divParentItem', id : 'parentItem', type : 'COM_ITEM', title : '<spring:message code="lbl.parentItemCd"/>' }
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{ target : 'divItemGroup'  , id : 'itemGroup'  , title : '<spring:message code="lbl.itemGroup"/>'   , data : this.comCode.codeMapEx.ITEM_GROUP, exData:[""], option: {allFlag:"Y"}},
				{ target : 'divItemType'   , id : 'itemType'   , title : '<spring:message code="lbl.itemType"/>'    , data : this.comCode.codeMap.ITEM_TYPE, exData:[""], option: {allFlag:"Y"}},
				{ target : 'divProcurType' , id : 'procurType' , title : '<spring:message code="lbl.procureType"/>' , data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{ target : 'divMrpQtyTot'  , id : 'mrpQtyTot' , title : '<spring:message code="lbl.mrpQtyYn"/>'     , data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"},
				{ target : 'divMolQtyTot'  , id : 'molQtyTot' , title : '<spring:message code="lbl.molQtyYn"/>'     , data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"},
				{ target : 'divAmtQty'     , id : 'rdoType' , title : '<spring:message code="lbl.quantityAmountPart"/>' , data : this.comCode.codeMap.SALE_QA_TYPE, exData:[""], type : "R"},
			]);
			
			$("#procurType").multipleSelect("setSelects", ["MH","MM","OH","OP"]);
			$(':radio[name=rdoType]:input[value="QTY"]').attr("checked", true);
		},
		
		grid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid : function() {
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.gridInstance.custBeforeBucketFalg = true;
				this.gridInstance.custBucketFalg       = true;
				
				this.setOptions();
				gfn_setMonthSum(matRequirPlan.grid.gridInstance, false, false, true);  // omit 0 추가
			},
			
			setOptions : function() {
				this.grdMain.setOptions({
					stateBar: { visible : true }
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
			}
		},
		
		events : function () {
			
			
			
			
			
			$('#toMon').on("change",function(event){
				fn_monthCounter();
				
			});
			
			
							
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			this.grid.grdMain.onDataCellClicked = function (grid, index) {
		    	var rowId     = index.itemIndex;
	       		var field     = index.fieldName;
	       		
	       		if(field == "DETAIL_POPUP") {
	       			var companyCd = grid.getValue(rowId, "COMPANY_CD");
	       			var buCd      = grid.getValue(rowId, "BU_CD");
	       			var prodPart  = grid.getValue(rowId, "PROD_PART");
	       			var itemNm    = grid.getValue(rowId, "HID_ITEM_NM");
	       			
	       			var planId = grid.getValue(rowId, "PLAN_ID");
	       			var itemCd = grid.getValue(rowId, "ITEM_CD");
	       			
	       			gfn_comPopupOpen("MAT_REQUIR_PLAN_DETAIL", {
						rootUrl    : "aps/planResult",
						url        : "matRequirPlanDetail",
						width      : 1200,
						height     : 680,
						companyCd  : companyCd,
						buCd       : buCd,
						prodPart   : prodPart,
						itemCd     : itemCd,
						itemNm     : itemNm,
						planId     : planId,
						menuCd     : "APS407"
					});
	       		}
		    };
		},
		
		getBucket : function(sqlFlag) {
			if (!sqlFlag) {
				
				for (var i in DIMENSION.user) {
					if (DIMENSION.user[i].DIM_CD.indexOf("ITEM_COST_KRW") > -1) {
						DIMENSION.user[i].numberFormat = "#,##0";
					}
				}
				
				matRequirPlan.grid.gridInstance.setDraw();
				
				var imgs = new RealGridJS.ImageList("images1", GV_CONTEXT_PATH + "/statics/images/common/");
			    imgs.addUrls([
			        "ico_srh.png"
			    ]);

			    matRequirPlan.grid.grdMain.registerImageList(imgs);
			    
			    matRequirPlan.grid.grdMain.setColumnProperty("DETAIL_POPUP", "imageList", "images1");
			    matRequirPlan.grid.grdMain.setColumnProperty("DETAIL_POPUP", "renderer", {type : "icon"}); 
				
			    matRequirPlan.grid.grdMain.setColumnProperty("DETAIL_POPUP", "styles", {
				    textAlignment: "center",
				    iconIndex: 0,
				    iconLocation: "center",
				    iconAlignment: "center",
				    iconOffset: 4,
				    iconPadding: 2
				}); 
			    
				var fileds = matRequirPlan.grid.dataProvider.getFields();
				
				for (var i in fileds) {
					if (fileds[i].fieldName.indexOf("ITEM_COST_KRW") > -1) {
						fileds[i].dataType = "number";
					}
				}
				
				matRequirPlan.grid.dataProvider.setFields(fileds);
				
				fn_setHeaderColor();
			}
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
					}else if(id == "divMrpQtyTot"){
						EXCEL_SEARCH_DATA += $("#mrpQtyTot option:selected").text();
					}else if(id == "divMolQtyTot"){
						EXCEL_SEARCH_DATA += $("#molQtyTot option:selected").text();
					}else if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}else if(id == "divParentItem"){
						EXCEL_SEARCH_DATA += $("#parentItem_nm").val();
					}else if(id == "divAmtQty"){
						
						var qtyAmt = $('input[name="rdoType"]:checked').val();
						
						if(qtyAmt == "QTY"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.qty"/>';
						}else if(qtyAmt == "AMT"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.amt"/>';
						}
					}
				}
			});
		},
		
		search : function () {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : matRequirPlan._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						matRequirPlan.grid.dataProvider.clearRows(); //데이터 초기화
						
						//그리드 데이터 생성
						matRequirPlan.grid.grdMain.cancel();
						
						matRequirPlan.grid.dataProvider.setRows(data.resList);
						matRequirPlan.grid.dataProvider.clearSavePoints();
						matRequirPlan.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(matRequirPlan.grid.dataProvider.getRowCount());
						gfn_actionMonthSum(matRequirPlan.grid.gridInstance);
						gfn_setRowTotalFixed(matRequirPlan.grid.grdMain);
						
					}
				}
			}
			
			gfn_service(aOption, "obj");
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		DIMENSION.hidden = [];
    	DIMENSION.hidden.push({CD:"COMPANY_CD"  , dataType:"text"});
    	DIMENSION.hidden.push({CD:"BU_CD"       , dataType:"text"});
    	DIMENSION.hidden.push({CD:"PROD_PART"   , dataType:"text"});
    	DIMENSION.hidden.push({CD:"HID_ITEM_NM" , dataType:"text"});
    	
		gfn_getMenuInit();
		matRequirPlan.getBucket(sqlFlag);
		
    	//조회조건 설정
    	FORM_SEARCH            = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList	   = MEASURE.user;
   		
    	matRequirPlan.search();
    	matRequirPlan.excelSubSearch();
	}
	
	function fn_getPlanId(pOption) {
		
		try {
			
			if ($("#planId").length == 0) {
				return;
			}
			
			var params = $.extend({
				_mtd     : "getList",
				tranData : [{outDs : "rtnList", _siq : "common.planId"}]
			}, pOption);
			
			gfn_service({
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : params,
				async   : false,
				success : function(data) {
					
					gfn_setMsCombo("planId",data.rtnList,[""]);
					//fn_monthCounter();
					$("#planId").on("change", function(e) {
						var nowDate = null;
						var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
						
						if (fDs.length > 0) {
							$("#cutOffFlag").val(fDs[0].CUT_OFF_FLAG);
						
							nowDate = fDs[0].SW_START_DATE;
							var DATE_plus_42 = weekdatecal(nowDate,42);
						    var DATE_plus_180 = weekdatecal(nowDate,364);
						    
						    var tStartMon = nowDate.substring(0, 4) + nowDate.substring(4, 6);
							var tCloseMon = gfn_addDate("month", 5, "", tStartMon + "01").substring(0, 6);
							var ttCloseMon = gfn_addDate("month", 11, "", tStartMon + "01").substring(0, 6);
							
							var minMonthStart = gfn_getStringToDate(tStartMon + "01");
							var maxMonthClose = gfn_getStringToDate(tCloseMon + "01");
							var maxMonthEdt =  gfn_getStringToDate(ttCloseMon + "01");
							
							MONTHPICKER(null, tStartMon, tCloseMon);
							$("#fromMon").monthpicker("option", "minDate", minMonthStart);
							$("#toMon").monthpicker("option", "maxDate", maxMonthEdt);
						
						} 
						
						$('#toMon').on("change",function(event){
							
							fn_monthCounter();
							
						});
					
					});
					
					
					$("#planId").trigger("change");
				}
			}, "obj");
			
		} catch(e) {console.log(e);}
	}
	
	function fn_setBeforeFieldsBuket() {
		var fields = [
			{fieldName: "DETAIL_POPUP", dataType : "text"}
	    ];
		return fields;
	}
	
	function fn_setBeforeColumnsBuket() {
		var columns = [	
		{
			name : "DETAIL_POPUP", fieldName : "DETAIL_POPUP", editable : false, header: {text: '<spring:message code="lbl.detailInfo" javaScriptEscape="true" />'},
			styles : {textAlignment: "near", background : gv_noneEditColor},
			mergeRule : { criteria: "values['ITEM_CD']+value" },
			width : 60
		}];
		return columns;
	}
	
	function fn_setFieldsBuket() {
		//필드 배열 객체를  생성합니다.
		
		//monthCount
		
		
        var fields = [
            {fieldName: "MRP_QTY_W1"},
            {fieldName: "MRP_QTY_W2"},
            {fieldName: "MRP_QTY_W3"},
            {fieldName: "MRP_QTY_W4"},
            {fieldName: "MRP_QTY_W5"},
            {fieldName: "MRP_QTY_W6"},
           
            {fieldName: "VENDOR_OUT_QTY", dataType : "number"},
            {fieldName: "EX_PLANT_QTY", dataType : "number"},
            {fieldName: "BL_QTY", dataType : "number"},
            {fieldName: "CC_QTY", dataType : "number"},
            {fieldName: "INSPECT_QTY", dataType : "number"},
            {fieldName: "EXP_GR_QTY_W0", dataType : "number"},
            {fieldName: "EXP_GR_QTY_W1", dataType : "number"},
            {fieldName: "EXP_GR_QTY_W2", dataType : "number"},
            {fieldName: "EXP_GR_QTY_W3", dataType : "number"},
            {fieldName: "EXP_GR_QTY_W4", dataType : "number"},
            {fieldName: "EXP_GR_QTY_W5", dataType : "number"},
            {fieldName: "EXP_GR_QTY_W6", dataType : "number"},
            {fieldName: "EXP_GR_QTY_M0", dataType : "number"},
            {fieldName: "EXP_GR_QTY_M1", dataType : "number"},
            {fieldName: "EXP_GR_QTY_M2", dataType : "number"},
            {fieldName: "EXP_GR_QTY_M3", dataType : "number"},
            {fieldName: "MOL_QTY_W1", dataType : "number"},
            {fieldName: "MOL_QTY_W2", dataType : "number"},
            {fieldName: "WI01_MOL_QTY", dataType : "number"},
            {fieldName: "OUT_MOL_QTY", dataType : "number"},
            {fieldName: "INV_QTY", dataType : "number"},
            {fieldName: "NON_DEPLOY_QTY", dataType : "number"},
            {fieldName: "NON_MOVING_QTY", dataType : "number"}
        ];
		
		/*
			{fieldName: "MRP_QTY_M0"},
            {fieldName: "MRP_QTY_M1"},
            {fieldName: "MRP_QTY_M2"},
            {fieldName: "MRP_QTY_M3"},
            {fieldName: "MRP_QTY_M4"},
            {fieldName: "MRP_QTY_M5"},
            {fieldName: "MRP_QTY_M6"},
            {fieldName: "MRP_QTY_M7"},
            {fieldName: "MRP_QTY_M8"},
            {fieldName: "MRP_QTY_M9"},
            {fieldName: "MRP_QTY_M10"},
            {fieldName: "MRP_QTY_M11"},
		*/
		
        //monthCount
        
       for(i=0;i<monthCount;i++)
		{
	
			fields.push({fieldName:'MRP_QTY_M'+i+''});
			
		}
		
		
		
        return fields;
	}
	
	function fn_setColumnsBuket() {
		//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = [
            {
                name: "GROUP1",
                header: {text: '<spring:message code="lbl.matConsumedQty"/>'},
                width: 480,
                type: "group",
                columns : [{
                	name: "MRP_QTY_W1",
                    fieldName: "MRP_QTY_W1",
                    header: {text: '<spring:message code="lbl.1wk"/>'},
                    styles : {textAlignment: "far", background : gv_noneEditColor},
    				width : 80
                },
                {
                	name: "MRP_QTY_W2",
                    fieldName: "MRP_QTY_W2",
                    header: {text: '<spring:message code="lbl.2wk"/>'},
                    styles : {textAlignment: "far", background : gv_noneEditColor},
    				width : 80
                },
                {
                	name: "MRP_QTY_W3",
                    fieldName: "MRP_QTY_W3",
                    header: {text: '<spring:message code="lbl.3wk"/>'},
                    styles : {textAlignment: "far", background : gv_noneEditColor},
    				width : 80
                },
                {
                	name: "MRP_QTY_W4",
                    fieldName: "MRP_QTY_W4",
                    header: {text: '<spring:message code="lbl.4wk"/>'},
                    styles : {textAlignment: "far", background : gv_noneEditColor},
    				width : 80
                },
                {
                	name: "MRP_QTY_W5",
                    fieldName: "MRP_QTY_W5",
                    header: {text: '<spring:message code="lbl.5wk"/>'},
                    styles : {textAlignment: "far", background : gv_noneEditColor},
    				width : 80
                },
                {
                	name: "MRP_QTY_W6",
                    fieldName: "MRP_QTY_W6",
                    header: {text: '<spring:message code="lbl.6wk"/>'},
                    styles : {textAlignment: "far", background : gv_noneEditColor},
    				width : 80
                }]
            }, {
                name: "GROUP2",
                header: {text: '<spring:message code="lbl.matConsumedQtyM"/>'},
                width: 500,
                type: "group",
                columns : [
              
                
                ]
            }, 
            
            
            
            {
				name : "VENDOR_OUT_QTY", fieldName: "VENDOR_OUT_QTY", editable: false, header: {text: '<spring:message code="lbl.vendorOutQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "EX_PLANT_QTY", fieldName: "EX_PLANT_QTY", editable: false, header: {text: '<spring:message code="lbl.exPlantQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "BL_QTY", fieldName: "BL_QTY", editable: false, header: {text: '<spring:message code="lbl.blQty2" javaScriptEscape="true" />'},
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
				name : "INSPECT_QTY", fieldName: "INSPECT_QTY", editable: false, header: {text: '<spring:message code="lbl.inspectQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "EXP_GR_QTY_W0", fieldName: "EXP_GR_QTY_W0", editable: false, header: {text: '<spring:message code="lbl.expGrQtyW0" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "EXP_GR_QTY_W1", fieldName: "EXP_GR_QTY_W1", editable: false, header: {text: '<spring:message code="lbl.expGrQtyW1" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "EXP_GR_QTY_W2", fieldName: "EXP_GR_QTY_W2", editable: false, header: {text: '<spring:message code="lbl.expGrQtyW2" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "EXP_GR_QTY_W3", fieldName: "EXP_GR_QTY_W3", editable: false, header: {text: '<spring:message code="lbl.expGrQtyW3" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "EXP_GR_QTY_W4", fieldName: "EXP_GR_QTY_W4", editable: false, header: {text: '<spring:message code="lbl.expGrQtyW4" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "EXP_GR_QTY_W5", fieldName: "EXP_GR_QTY_W5", editable: false, header: {text: '<spring:message code="lbl.expGrQtyW5" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "EXP_GR_QTY_W6", fieldName: "EXP_GR_QTY_W6", editable: false, header: {text: '<spring:message code="lbl.expGrQtyW6" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "EXP_GR_QTY_M0", fieldName: "EXP_GR_QTY_M0", editable: false, header: {text: '<spring:message code="lbl.expGrQtyM0" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "EXP_GR_QTY_M1", fieldName: "EXP_GR_QTY_M1", editable: false, header: {text: '<spring:message code="lbl.expGrQtyM1" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "EXP_GR_QTY_M2", fieldName: "EXP_GR_QTY_M2", editable: false, header: {text: '<spring:message code="lbl.expGrQtyM2" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "EXP_GR_QTY_M3", fieldName: "EXP_GR_QTY_M3", editable: false, header: {text: '<spring:message code="lbl.expGrQtyM3" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "MOL_QTY_W1", fieldName: "MOL_QTY_W1", editable: false, header: {text: '<spring:message code="lbl.molGtyW1" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "MOL_QTY_W2", fieldName: "MOL_QTY_W2", editable: false, header: {text: '<spring:message code="lbl.molGtyW2" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "WI01_MOL_QTY", fieldName: "WI01_MOL_QTY", editable: false, header: {text: '<spring:message code="lbl.wi01MolQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "OUT_MOL_QTY", fieldName: "OUT_MOL_QTY", editable: false, header: {text: '<spring:message code="lbl.outMolQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "INV_QTY", fieldName: "INV_QTY", editable: false, header: {text: '<spring:message code="lbl.invQty2" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "NON_DEPLOY_QTY", fieldName: "NON_DEPLOY_QTY", editable: false, header: {text: '<spring:message code="lbl.nonDeployQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "NON_MOVING_QTY", fieldName: "NON_MOVING_QTY", editable: false, header: {text: '<spring:message code="lbl.nonMovingQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}
        ];
	
		
        /*
        {
        	name: "MRP_QTY_M0",
            fieldName: "MRP_QTY_M0",
            header: {text: '<spring:message code="lbl.apsM0"/>'},
            styles : {textAlignment: "far", background : gv_noneEditColor},
			width : 80
        },
        {
        	name: "MRP_QTY_M1",
            fieldName: "MRP_QTY_M1",
            header: {text: '<spring:message code="lbl.apsM1"/>'},
            styles : {textAlignment: "far", background : gv_noneEditColor},
			width : 80
        },
        {
        	name: "MRP_QTY_M2",
            fieldName: "MRP_QTY_M2",
            header: {text: '<spring:message code="lbl.apsM2"/>'},
            styles : {textAlignment: "far", background : gv_noneEditColor},
			width : 80
        },
        {
        	name: "MRP_QTY_M3",
            fieldName: "MRP_QTY_M3",
            header: {text: '<spring:message code="lbl.apsM3"/>'},
            styles : {textAlignment: "far", background : gv_noneEditColor},
			width : 80
        },
        {
        	name: "MRP_QTY_M4",
            fieldName: "MRP_QTY_M4",
            header: {text: '<spring:message code="lbl.apsM4"/>'},
            styles : {textAlignment: "far", background : gv_noneEditColor},
			width : 80
        },
        {
        	name: "MRP_QTY_M5",
            fieldName: "MRP_QTY_M5",
            header: {text: '<spring:message code="lbl.apsM5"/>'},
            styles : {textAlignment: "far", background : gv_noneEditColor},
			width : 80
        },
        {
        	name: "MRP_QTY_M6",
            fieldName: "MRP_QTY_M6",
            header: {text: '<spring:message code="lbl.apsM6"/>'},
            styles : {textAlignment: "far", background : gv_noneEditColor},
			width : 80
        },
        {
        	name: "MRP_QTY_M7",
            fieldName: "MRP_QTY_M7",
            header: {text: '<spring:message code="lbl.apsM7"/>'},
            styles : {textAlignment: "far", background : gv_noneEditColor},
			width : 80
        },
        {
        	name: "MRP_QTY_M8",
            fieldName: "MRP_QTY_M8",
            header: {text: '<spring:message code="lbl.apsM8"/>'},
            styles : {textAlignment: "far", background : gv_noneEditColor},
			width : 80
        },
        {
        	name: "MRP_QTY_M9",
            fieldName: "MRP_QTY_M9",
            header: {text: '<spring:message code="lbl.apsM9"/>'},
            styles : {textAlignment: "far", background : gv_noneEditColor},
			width : 80
        },
        {
        	name: "MRP_QTY_M10",
            fieldName: "MRP_QTY_M10",
            header: {text: '<spring:message code="lbl.apsM10"/>'},
            styles : {textAlignment: "far", background : gv_noneEditColor},
			width : 80
        },
        {
        	name: "MRP_QTY_M11",
            fieldName: "MRP_QTY_M11",
            header: {text: '<spring:message code="lbl.apsM11"/>'},
            styles : {textAlignment: "far", background : gv_noneEditColor},
			width : 80
        }
        */
        //monthCount
        
        for(i=0;i<monthCount;i++)
 		{
 	    	columns[1].columns.push({name:'MRP_QTY_M'+i+'',fieldName:'MRP_QTY_M'+i+'',header:{text:'M'+i+''},styles : {textAlignment: "far", background : gv_noneEditColor},width : 80});
 		}
		//name:'MRP_QTY_M'+i+'',, fieldName:'MRP_QTY_M'+i+'',header:{text: '<spring:message code="lbl.apsM'+i+'"/>',styles : {textAlignment: "far", background : gv_noneEditColor}, width : 80
		
        return columns;
	}
	
	function fn_setHeaderColor() {
		
		var fileds    = matRequirPlan.grid.dataProvider.getFields();
		var filedsLen = fileds.length;
		
		for (var i = 0; i < filedsLen; i++) {
			
			var fieldName = fileds[i].fieldName;
			var param     = fieldName;
			var setHeader = matRequirPlan.grid.grdMain.getColumnProperty(param, "header");
			
			if(fieldName == "EXP_GR_QTY_W0" || fieldName == "EXP_GR_QTY_W1" || fieldName == "EXP_GR_QTY_W2" || fieldName == "EXP_GR_QTY_W3" || fieldName == "EXP_GR_QTY_W4" || fieldName == "EXP_GR_QTY_W5" || fieldName == "EXP_GR_QTY_W6"){
				setHeader.styles = {background: "#FAED7D"};
			} else if(fieldName == "EXP_GR_QTY_M0" || fieldName == "EXP_GR_QTY_M1" || fieldName == "EXP_GR_QTY_M2" || fieldName == "EXP_GR_QTY_M3"){
				setHeader.styles = {background: "#00ce2b"};
			}
			
			matRequirPlan.grid.grdMain.setColumnProperty(param, "header", setHeader);
		}
	}
	
	// onload 
	$(document).ready(function() {
		matRequirPlan.init();
	});
	
	function weekdatecal(dt, days){
		
    	yyyy = dt.substr(0, 4);
    	mm   = dt.substr(4, 2);
    	dd   = dt.substr(6, 2);
    	
    	var date = new Date(yyyy + "/" + mm + "/" + dd);
    	
    	date.setDate(date.getDate() + days);
    	
    	var rdt = date.getFullYear() + '' + ((date.getMonth() + 1)  < 10 ? '0' + (date.getMonth() + 1) : (date.getMonth() + 1) ) + (date.getDate() < 10 ? '0' + date.getDate() : date.getDate());
    	
    	return rdt;
    }
	
	//사용자 toMon 선택에 따른
	//fromMon 부터 toMon까지 몇개월인지 counting 하는 함수
	//이 값을 계산하여 GRID 상에 보여지는 MONTH 컬럼의 개수를 계산하기 위함
	// 
	function fn_monthCounter(){
	
	var fromMon = $('#fromMon').val();
	var fromMonYear = fromMon.substring(0,4);
	var fromMonMonth = parseInt(fromMon.split('-')[1]);
	
	var toMon = $('#toMon').val();
	var toMonYear = toMon.substring(0,4);
	var toMonMonth = parseInt(toMon.split('-')[1]);
	
	
		//fromMon 년도와 toMon 년도가 다를 때
		// ex:   fromMon=>2020-10,   toMon=> 2021-3 
		//monthCount
		if(fromMonYear==toMonYear)
		{
			monthCount = (toMonMonth-fromMonMonth)+1;
		}
		//fromMon 년도와 toMon 년도가  같을 때,
		// ex:   fromMon=>2020-10,   toMon=> 2020-12	
		//monthCount
		else
		{
			monthCount= toMonMonth +(12-fromMonMonth)+1;
		}
		
		
	}
	
	
</script>
</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divPlanId">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.planId"/></div>
							<div class="iptdv borNone">
								<select id="planId" name="planId" class="iptcombo"></select>
							</div>
						</div>
					</div>
					<input type='hidden' id='cutOffFlag' name='cutOffFlag'>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divMrpQtyTot"></div>
					<div class="view_combo" id="divMolQtyTot"></div>
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divParentItem"></div>
					<div class="view_combo" id="divAmtQty"></div>
					
					<div id="filterViewMonth"><jsp:include page="/WEB-INF/view/common/filterViewHorizonMonth.jsp" flush="false" /></div>
					
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
			<%-- 
			<div class="cbt_btn">
				<div class="bright">
					<a href="javascript:;" id="btnReset" class="app1 roleWrite"><spring:message code="lbl.reset" /></a>
					<a href="javascript:;" id="btnSave"  class="app2 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
			--%>
		</div>
    </div>
</body>
</html>