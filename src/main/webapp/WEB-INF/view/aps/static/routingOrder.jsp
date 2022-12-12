<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var routingOrder = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.routingOrderGrid.initGrid();
			this.events();
		},
			
		_siq    : "aps.static.routingOrderList",
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'PROD_PART,ITEM_TYPE,PROCUR_TYPE,FLAG_YN';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "ORDER_ROUTING", "ITEM_GROUP", "UPPER_ITEM_GROUP"], null, {itemType : "10,50"});
				this.codeMap.PROD_PART[0].CODE_NM = "";
			}
		},
		
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
			
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			gfn_setMsComboAll([
				{ target : 'divProdPart'    , id : 'prodPart', title : '<spring:message code="lbl.prodPart2"/>', data : this.comCode.codeMap.PROD_PART, exData:["*"], type : "S"},
				{ target : 'divProcurType'  , id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{ target : 'divUpItemGroup' , id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent},
				{ target : 'divItemGroup'   , id : 'itemGroup'    , title : '<spring:message code="lbl.itemGroup"/>'    , data : this.comCode.codeMapEx.ITEM_GROUP,     exData:["*"] },
				{ target : 'divRoute'       , id : 'route'        , title : '<spring:message code="lbl.routing"/>'      , data : this.comCode.codeMapEx.ORDER_ROUTING,        exData:["*"] },
				{ target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"] },
				{ target : 'divCustGroup'   , id : 'custGroup'    , title : '<spring:message code="lbl.custGroup"/>'    , data : this.comCode.codeMapEx.CUST_GROUP,     exData:["*"] },
				{ target : 'divItemType'    , id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""], event : itemTypeEvent, option: {allFlag:"Y"}},
				{ target : 'divCpfrYn'      , id : 'cpfrYn', title : '<spring:message code="lbl.cpfrItem"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"},
				{ target : 'divSsYn'        , id : 'ssYn', title : '<spring:message code="lbl.ssItem"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"},
				{ target : 'divMajorFlag'   , id : 'majorFlag', title : '<spring:message code="lbl.majorFlag"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"},
				{ target : 'divValidYn'     , id : 'flagYn', title : '<spring:message code="lbl.useYn"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"}
			]);
			
			$("#prodPart").change(function() {
				
				var paramProdPart = $("#prodPart").val();
				
				if(paramProdPart == "TEL" || paramProdPart == "LAM"){
					$("#itemType").multipleSelect("open");
					$("#itemType").multipleSelect("setSelects", ["10"]);
					$("#itemType").multipleSelect("close");
				}else if(paramProdPart == "DIFFUSION" || paramProdPart == "MATERIAL"){
					$("#itemType").multipleSelect("open");
					$("#itemType").multipleSelect("checkAll");
					$("#itemType").multipleSelect("close");
				}
			}); 
		},
		
		/* 
		* grid  선언
		*/
		routingOrderGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.grdMain.setOptions({
					stateBar: { visible : true },
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
				
				this.grdMain.addCellStyles([{
					id         : "noneEditStyle",
					editable   : false,
					background : gv_noneEditColor
				}]);
				
				
				this.grdMain.setPasteOptions({
					applyNumberFormat: false,
					checkDomainOnly: false,
					checkReadOnly: true,
					commitEdit: true,
					enableAppend: true,
					enabled: true,
					eventEachRow: true, 
					fillColumnDefaults: false,
					fillFieldDefaults: false,
					forceColumnValidation: false,
					forceRowValidation: false,
					noDataEvent: false,
					noEditEvent: false,
					selectBlockPaste: true,
					selectionBase: false,
					singleMode: false,
					startEdit: true,
					stopOnError: true,
					throwValidationError: true,
					numberChars: ","
				});
				
				
				this.grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
					
					var fieldName = routingOrder.routingOrderGrid.dataProvider.getFieldName(field);
					
					if(newValue == 0 && fieldName =='PRIORITY_NM'){
					    
						alert('<spring:message code="msg.zeroMsg"/>');
						grid.setValue(dataRow, field, '');
					}else if(fieldName == 'PRIORITY_NM' && oldValue != newValue){
						item_cd = grid.getValue(dataRow, 'ITEM_CD_NM');
					
						var options = {
							parentId: 0,
							startIndex: 0,
						    fields: ['ITEM_CD_NM', 'PRIORITY_NM'],
						    values: [item_cd, newValue]
						}
						
						var chk_flag = routingOrder.routingOrderGrid.dataProvider.searchDataRow(options);
						if(chk_flag > -1){
							alert(gfn_getDomainMsg("msg.dupData",itemIndex+1));
							grid.setValue(dataRow, field, null);
						}
					}
				};
			},
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnReset").on('click', function (e) {
				routingOrder.routingOrderGrid.grdMain.cancel();
				routingOrder.routingOrderGrid.dataProvider.rollback(routingOrder.routingOrderGrid.dataProvider.getSavePoints()[0]);
			});
			
			$("#btnSave").on('click', function (e) {
				routingOrder.save();
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
					if(id == "divProdPart"){
						EXCEL_SEARCH_DATA += $("#prodPart option:selected").text();
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
					}else if(id == "divCpfrYn"){
						EXCEL_SEARCH_DATA += $("#cpfrYn option:selected").text();
					}else if(id == "divSsYn"){
						EXCEL_SEARCH_DATA += $("#ssYn option:selected").text();
					}else if(id == "divMajorFlag"){
						EXCEL_SEARCH_DATA += $("#majorFlag option:selected").text();
					}else if(id == "divValidYn"){
						EXCEL_SEARCH_DATA += $("#flagYn option:selected").text();
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
						routingOrder.routingOrderGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						routingOrder.routingOrderGrid.grdMain.cancel();
						
						routingOrder.routingOrderGrid.dataProvider.setRows(data.resList);
						routingOrder.routingOrderGrid.dataProvider.clearSavePoints();
						routingOrder.routingOrderGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(routingOrder.routingOrderGrid.dataProvider.getRowCount());
						//gfn_actionMonthSum(routingOrder.routingOrderGrid.gridInstance);
						gfn_setRowTotalFixed(routingOrder.routingOrderGrid.grdMain);
						
						routingOrder.gridCallback(data.resList);
					}
				}
			}
			gfn_service(aOption, "obj");
		},
		
		save : function (){
			
			try {
				this.routingOrderGrid.grdMain.commit(true);
			} catch (e) {
				alert('<spring:message code="msg.saveErrorCheck"/>\n'+e.message);
			}
			
			var grdData = gfn_getGrdSavedataAll(this.routingOrderGrid.grdMain);
			var grdDataLen = grdData.length;
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			var salesPlanDatas = [];
			var grdDataLastLen = grdData.length - 1;
			
			$.each(grdData, function(i, row) {
				
				row.PRIORITY_NM = $.trim(row.PRIORITY_NM);
				
				var lastFlag = "N";
				
				if(i == grdDataLastLen){
					lastFlag = "Y";
				}
				
				var planData = {
					ITEM_CD     : row.ITEM_CD_NM,
					ROUTING_NO  : row.ROUTING_NO_NM,
					PRIORITY    : row.PRIORITY_NM,
					USE_FLAG    : row.USE_YN_NM,
					LAST_FALG   : lastFlag
				};
				
				if(row.USE_YN_NM == 'Y' && (row.PRIORITY_NM == null || row.PRIORITY_NM ==  undefined || row.PRIORITY_NM =="" )){
					
					alert('<spring:message code="msg.dataCheck1"/>'); 
					var idex = {
					    itemIndex: row._ROWNUM-1,
					    fieldName: 'PRIORITY_NM',
					};
				    routingOrder.routingOrderGrid.grdMain.setCurrent(idex);
					return false;
				}
				
				
				if(row.PRIORITY_NM != null && row.PRIORITY_NM != "undefined" && $.trim(row.PRIORITY_NM) != "" ){
					
					var options = {
						parentId: 0,
						startIndex: 0,
					    fields: ['ITEM_CD_NM', 'PRIORITY_NM'],
					    values: [row.ITEM_CD_NM, row.PRIORITY_NM]
					}
					
					var chk_flag = routingOrder.routingOrderGrid.dataProvider.searchDataRow(options);
					if(chk_flag !=  row._ROWNUM-1){
					   	alert(gfn_getDomainMsg("msg.dupData",row._ROWNUM-1));
					   	var idex = {
						    itemIndex: row._ROWNUM-1,
						    fieldName: 'PRIORITY_NM',
						};
					   	routingOrder.routingOrderGrid.grdMain.setCurrent(idex);
					    return false;
					}
				}
				salesPlanDatas.push(planData);
			});
			
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
					
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveUpdate";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : routingOrder._siq, grdData : salesPlanDatas},
				];
				
				var ajaxOpt = {
					url     : GV_CONTEXT_PATH + "/biz/obj.do",
					data    : FORM_SAVE,
					success : function(data) {
						
						alert('<spring:message code="msg.saveOk"/>');
						
						routingOrder.routingOrderGrid.grdMain.cancel();
						
						$.each(grdData, function(i, row) {
							routingOrder.routingOrderGrid.dataProvider.setRowState(row._ROWNUM-1, 'none',true);
						});
						
						routingOrder.routingOrderGrid.dataProvider.clearSavePoints();
						routingOrder.routingOrderGrid.dataProvider.savePoint(); //초기화 포인트 저장
						fn_apply(false);
					},
				};
				
				gfn_service(ajaxOpt, "obj");
			});
		},
		
		gridMeasureData : function (){
			
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj.do",
			    data    : {
	    			_mtd : "getList",
	    			tranData : [
	    				{outDs : "measureCustList", _siq : "aps.static.measureProductList"}
	    			]
			    },
			    success :function(data) {
			    	
			    	var tmpProdPart = $("#prodPart").val();
			    	
			    	MEASURE.next = []; //초기화
			    	$.each(data.measureCustList, function(n, v){
			    		
			    		var vCd = v.CODE_CD;
			    		var vNm = v.CODE_NM;
			    		var vAttb1Cd = v.ATTB_1_CD;
			    		
			    		if(tmpProdPart == vAttb1Cd){
			    			MEASURE.next.push({CD : vCd, NM : vNm, equalBlankYn : "N", width : 200});	
			    		}
			    	});
		    	}
			    
			}, "obj");
		},
		
		gridCallback : function (resList){
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj.do",
			    data    : {
	    			_mtd : "getList",
	    			tranData : [
	    				{outDs : "authority", _siq : "aps.static.routingOrderAuthority"}
	    			]
			    },
			    success :function(data) {
			    	
			    	var dataLen = data.authority.length;
			    	var cols = routingOrder.routingOrderGrid.grdMain.getColumns();
					
			    	for (var i = 2; i < cols.length; i++) {
			    		var colsNm = cols[i].name;
							if(colsNm != 'PART_CD_NM' && colsNm != 'ITEM_CD_NM' && colsNm != 'ITEM_NM_NM' ){
								routingOrder.routingOrderGrid.grdMain.setColumnProperty(colsNm, "mergeRule",{});
							}
							
							if (colsNm == 'USE_YN_NM' ){
								routingOrder.routingOrderGrid.grdMain.setColumnProperty(colsNm,"styles",{background:gv_noneEditColor});
								routingOrder.routingOrderGrid.grdMain.setColumnProperty(colsNm,"lookupDisplay",true);
								var xcol = routingOrder.routingOrderGrid.grdMain.columnByName(colsNm);
								xcol.values = ["Y","N"];
								xcol.labels = ["Y","N"];
								
				        		routingOrder.routingOrderGrid.grdMain.setColumnProperty(colsNm,"editor", {
								            "type": "dropDown",
								            "dropDownCount": 2,
								            "textAlignment": "center",
								            	
										            "values": [
										            	"Y",
										                "N"
										            ],
										            "labels": [
										            	"Y",
										                "N"
										            ]
								            
								        });
							}
							
							if(colsNm == "PRIORITY_NM"){
								routingOrder.routingOrderGrid.grdMain.setColumnProperty(colsNm,"styles",{background:gv_noneEditColor});
								routingOrder.routingOrderGrid.grdMain.setColumnProperty(colsNm,"zeroText",'');
								routingOrder.routingOrderGrid.grdMain.setColumnProperty(colsNm, "editor", {
			   						type         : "number",
			   						allowEmpty   :  true,
				 				    positiveOnly : true,
			   						textAlignment: "center",
			   						maxLength : 2,
			   						integerOnly  : true
			   					});
							}
			    	}
			        
			    	for(var i = 0; i < dataLen; i++){
			    		
			    		var menuCd = data.authority[i].MENU_CD;
			    		
			    		$.each(resList, function(n, v){
			    			
			    			var prodPart = v.PART_CD;
			    			var useValue = v.USE_YN;
			    			
							for (var j = 2; j < cols.length; j++) {
								
								var colsName = cols[j].name;
								if (colsName == 'USE_YN_NM' || colsName == 'PRIORITY_NM' ){
									        		
						        	if(
						        		   (menuCd == "APS11301" && prodPart == "LAM"      )
								        || (menuCd == "APS11302" && prodPart == "TEL"      ) 
								        || (menuCd == "APS11303" && prodPart == "DIFFUSION")
								        || (menuCd == "APS11304" && prodPart == "MATERIAL" )
								        	  	
						        	  ){ //LAM 생산
						        	      if(useValue == 'N' && colsName == 'PRIORITY_NM'){
						        	    	  routingOrder.routingOrderGrid.grdMain.setCellStyles(n, colsName, "noneEditStyle");
						        	      }else{
						        	    	  routingOrder.routingOrderGrid.grdMain.setCellStyles(n, colsName, "editStyle");  
						        	      }
					    			}
								}
							}
			    		});
			    	}
			    	
			    	
			    	
			    }	
			    	
			}, "obj");
		}
	};
	

	//조회
	var fn_apply = function (sqlFlag) {
		
		var tmpProd = gfn_nvl($("#prodPart").val(), "");
		
		gfn_getMenuInit();
    	
    	if(!sqlFlag){
    		routingOrder.routingOrderGrid.gridInstance.setDraw();
		}		
		//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
    	FORM_SEARCH.hiddenList = DIMENSION.hidden;
    	FORM_SEARCH.meaList	   = MEASURE.next;
    	
		if (!sqlFlag) {
			
			var fileds = routingOrder.routingOrderGrid.dataProvider.getFields();
			for (var i = 0; i < fileds.length; i++) {
				if (fileds[i].fieldName == 'SS_QTY_NM' ||
					fileds[i].fieldName == 'MFG_LT_NM'||
					fileds[i].fieldName == 'SALES_PRICE_KRW_NM' || fileds[i].fieldName == 'RESULT_QTY_NM') {
					fileds[i].dataType = "number";
					fileds[i].numberFormat = "#,##0";
					
					routingOrder.routingOrderGrid.grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"numberFormat" : "#,##0"});	
				}
			}
			routingOrder.routingOrderGrid.dataProvider.setFields(fileds);
		}
		routingOrder.search();	
		routingOrder.excelSubSearch();	
	}

	// onload 
	$(document).ready(function() {
		routingOrder.init();
		routingOrder.routingOrderGrid.grdMain.onCellEdited =  function (grid, itemIndex, dataRow, field) {
			var fieldName = routingOrder.routingOrderGrid.dataProvider.getFieldName(field);
			
			if (fieldName == 'USE_YN_NM') { // 2 == "Age"
		        
				var v = routingOrder.routingOrderGrid.grdMain.getValue(itemIndex, field);
		        if(v == 'N'){
		        	routingOrder.routingOrderGrid.grdMain.setValue(itemIndex, 'PRIORITY_NM',null);
		        	 routingOrder.routingOrderGrid.grdMain.setCellStyles(dataRow, 'PRIORITY_NM', "noneEditStyle");
		        }else if(v =='Y'){
		        	 routingOrder.routingOrderGrid.grdMain.setCellStyles(dataRow, 'PRIORITY_NM', "editStyle");
		        }
		    }
		};
		
		routingOrder.routingOrderGrid.grdMain.onEditRowPasted = function(grid, itemIndex, dataRow, fields, oldValues, newValues){
			
			
			if(newValues.length > 0){

				var newValuesArr = [];
				
				$.each(newValues,function(i,fd){
					if(fd != null && fd != undefined) newValuesArr.push(fd);
				});
				
				$.each(fields,function(i,fld){
				
					var field = routingOrder.routingOrderGrid.dataProvider.getFieldName(fld);
					var cols = grid.columnsByField(field);
					var colsName = cols[0].name;
					
					var fieldName = cols[0].fieldName;
					
					if (fieldName == 'USE_YN_NM') { // 2 == "Age"
						   
						var v = routingOrder.routingOrderGrid.grdMain.getValue(itemIndex, field);
				        if(v == 'N'){
							routingOrder.routingOrderGrid.grdMain.setValue(itemIndex, 'PRIORITY_NM',null);
				        	routingOrder.routingOrderGrid.grdMain.setCellStyles(dataRow, 'PRIORITY_NM', "noneEditStyle");
				        }else if(v =='Y'){
				        	routingOrder.routingOrderGrid.grdMain.setCellStyles(dataRow, 'PRIORITY_NM', "editStyle");
				        }
				    }
				});
			}
		};	
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
					<div class="view_combo" id="divProdPart"></div>
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divCustGroup"></div>
					<div class="view_combo" id="divCpfrYn"></div>
					<div class="view_combo" id="divSsYn"></div>
					<div class="view_combo" id="divMajorFlag"></div>
					<div class="view_combo" id="divValidYn"></div>
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
				<div class="bright">
					<a href="javascript:;" id="btnReset" class="app1 roleWrite"><spring:message code="lbl.reset" /></a>
					<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
