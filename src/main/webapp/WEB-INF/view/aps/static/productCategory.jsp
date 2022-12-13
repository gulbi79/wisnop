<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">
	
	var enterSearchFlag = "Y";
	var productCategory = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.productCategoryGrid.initGrid();
			this.events();
		},
			
		_siq    : "aps.static.productCategoryList",
		 
		initFilter : function() {
			
			var itemTypeEvent = {
				childId   : ["upItemGroup"],  
				childData : [this.comCode.codeMapEx.UPPER_ITEM_GROUP, this.comCode.codeMapEx.ROUTING],
				
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
				{ target : 'divProdPart'    , id : 'prodPart', title : '<spring:message code="lbl.prodPart"/>', data : this.comCode.codeMap.PROD_PART, exData:["*"], type : "S"},
				{ target : 'divProcurType'  , id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{ target : 'divUpItemGroup' , id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent},
				{ target : 'divItemGroup'   , id : 'itemGroup'    , title : '<spring:message code="lbl.itemGroup"/>'    , data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"] },
				{ target : 'divRoute'       , id : 'route'        , title : '<spring:message code="lbl.routing"/>'      , data : this.comCode.codeMapEx.ORDER_ROUTING, exData:["*"] },
				{ target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"] },
				{ target : 'divCustGroup'   , id : 'custGroup'    , title : '<spring:message code="lbl.custGroup"/>'    , data : this.comCode.codeMapEx.CUST_GROUP,     exData:["*"] },
				{ target : 'divItemType'    , id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""], event : itemTypeEvent, option: {allFlag:"Y"}},
				{ target : 'divCpfrYn'      , id : 'cpfrYn', title : '<spring:message code="lbl.cpfrItem"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"},
				{ target : 'divSsYn'        , id : 'ssYn', title : '<spring:message code="lbl.ssItem"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"},
				{ target : 'divValidYn'     , id : 'validYn', title : '<spring:message code="lbl.validYn"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"}
			]);
			
			$("#validYn").val("Y");
			
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
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'PROD_PART,ITEM_TYPE,PROCUR_TYPE,FLAG_YN,PROD_ITEM_GROUP_MST';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "ORDER_ROUTING", "ITEM_GROUP", "UPPER_ITEM_GROUP"], null, {itemType : "10,50"});
				this.codeMap.PROD_PART[0].CODE_NM = "";
			}
		},
	
		/* 
		* grid  선언
		*/
		productCategoryGrid : {
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
				
				//카피 START				
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
					throwValidationError: true
				});
				
				var colsArray = new Array();
				
				$.each(productCategory.comCode.codeMap.PROD_ITEM_GROUP_MST, function(i, val){
					var codeCd = val.CODE_CD;
					colsArray.push(codeCd);
				});
				
				gfn_pasteValueToLabel(this.grdMain, this.dataProvider, colsArray);
				//카피 END
				
				this.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
					if(key == 46){  //Delete Key
						//gfn_selBlockDelete(grid, facility.facilityGrid.dataProvider); //셀구성  
						gfn_selBlockDelete(grid, productCategory.productCategoryGrid.dataProvider, "cols"); //컬럼구성  
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
				productCategory.productCategoryGrid.grdMain.cancel();
				productCategory.productCategoryGrid.dataProvider.rollback(productCategory.productCategoryGrid.dataProvider.getSavePoints()[0]);
			});
			
			$("#btnSave").on('click', function (e) {
				productCategory.save();
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
					}else if(id == "divValidYn"){
						EXCEL_SEARCH_DATA += $("#validYn option:selected").text();
					}
				}
			});
			
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList", _siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						productCategory.productCategoryGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						productCategory.productCategoryGrid.grdMain.cancel();
						
						productCategory.productCategoryGrid.dataProvider.setRows(data.resList);
						productCategory.productCategoryGrid.dataProvider.clearSavePoints();
						productCategory.productCategoryGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(productCategory.productCategoryGrid.dataProvider.getRowCount());
						//gfn_actionMonthSum(productCategory.productCategoryGrid.gridInstance);
						gfn_setRowTotalFixed(productCategory.productCategoryGrid.grdMain);
						
						productCategory.gridComboList();
						
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		save : function (){
			
			var grdData = gfn_getGrdSavedataAll(this.productCategoryGrid.grdMain);
			
			var grdDataLen = grdData.length;
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			var salesPlanDatas = [];
			var dataStep = new Array();
			
			$.each(grdData, function(i, row) {
				
				
				var planData = {
					ITEM_CD       : row.ITEM_CD_NM,
					BUCKET_LIST   : []
				};
				
				$.each(row, function(attr, value) {
					
					$.each(MEASURE.next, function(n, v){
						
						var vCd = v.CD;
						
						if(attr == vCd){
							var result = eval("row." + vCd + "_NM");
							
							if(result == "" || result == undefined){
								result = "NULL";
							}
							
							planData.BUCKET_LIST.push({
								PROD_GROUP       : vCd,
								PROD_GROUP_DET   : result
							});
							
							if(result != "NULL"){
								
								var dataStepCnt = 0;
								var dataStepLen = dataStep.length;
								
								if(dataStepLen == 0){
									dataStep.push(result);
								}else{
									$.each(dataStep, function(i, val){
										
										if(val == result){
											dataStepCnt++;
											return false;
										}
									});
									
									if(dataStepCnt == 0){
										dataStep.push(result);	
									}
								}
							}
						}
					});
				});
				salesPlanDatas.push(planData);
			});
			
			//데이터 검증 로직
			FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.dataStep = dataStep;
			FORM_SEARCH.tranData = [{ outDs : "resList", _siq : this._siq + "Step"}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					var dataCnt = data.resList[0].DATA_CNT;
					
					if(dataCnt == dataStep.length){
						confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
							
							FORM_SAVE            = {}; //초기화
							FORM_SAVE._mtd       = "saveUpdate";
							FORM_SAVE.tranData   = [
								{outDs : "saveCnt", _siq : productCategory._siq, grdData : salesPlanDatas},
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
					}else{
						alert('<spring:message code="msg.dataStep"/>');
					}
				}
			}
			gfn_service(aOption, "obj");
		},
		
		gridMeasureData : function (){
			
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj",
			    data    : {
	    			_mtd : "getList",
	    			tranData : [
	    				{outDs : "measureCustList", _siq : "aps.static.measureProductList"}
	    			]
			    },
			    success :function(data) {
			    	
			    	var tmpProdPart = $("#prodPart").val();
			    	
			    	MEASURE.next = []; //초기화
			    	DIMENSION.hidden = [];
			    	DIMENSION.hidden.push({CD : "PROD_LVL2_CD", dataType : "text"  });
			    	
			    	$.each(data.measureCustList, function(n, v){
			    		
			    		var vCd = v.CODE_CD;
			    		var vCdEdit = vCd + "_YN"; 
			    		var vNm = v.CODE_NM;
			    		var vAttb1Cd = v.ATTB_1_CD;
			    		
			    		if(tmpProdPart == vAttb1Cd){
			    			MEASURE.next.push({CD : vCd, NM : vNm, equalBlankYn : "N", width : 200, CD_SUB : vCdEdit });
			    			DIMENSION.hidden.push({CD : vCdEdit, dataType : "text"  });
			    		}
			    	});
		    	}
			    
			}, "obj");
		},
		
		gridComboList : function (){
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj",
			    data    : {
	    			_mtd : "getList",
	    			tranData : [
	    				{outDs : "comboList", _siq : "aps.static.comboProductList"},
	    				{outDs : "authority", _siq : "aps.static.productCategoryAuthority"}
	    			]
			    },
			    success :function(data) {
			    	
			    	var tmp = "";
			    	var state = "";
			    	var codeCdTmp = new Array();
			    	var codeNmTmp = new Array();
			    	var len = data.comboList.length - 1;
			    	var tmpProdPart = $("#prodPart").val();
			    	
			    	codeCdTmp.push("");
			    	codeNmTmp.push("");
			    	
			    	$.each(data.comboList, function(n, v){
			    		var attb2Cd = v.ATTB_2_CD;
			    		var vCd = v.CODE_CD;
			    		var vNm = v.CODE_NM;
			    		var updateFlag = "N";
			    		var thisCd = "";
			    		
			    		
			    		if((tmp != "" && tmp != attb2Cd)){
			    			updateFlag = "Y";
			    			thisCd = tmp;
			    		}
			    		
			    		if(len == n){ //마지막 일때
			    			updateFlag = "Y";
			    			thisCd = tmp;
			    			
			    			codeCdTmp.push(vCd);
				    		codeNmTmp.push(vNm);
			    		} 
			    		
			    		tmp = attb2Cd;
			    		
			    		if(updateFlag == "Y"){
			    			
			    			var col = productCategory.productCategoryGrid.grdMain.columnByName(thisCd);
					    	productCategory.productCategoryGrid.grdMain.setColumnProperty(thisCd, "editor", { type: "dropDown", domainOnly: true});
					    	
					    	if(col != null){
					    		col.values = codeCdTmp;
								col.labels = codeNmTmp;
								productCategory.productCategoryGrid.grdMain.setColumn(col);
								productCategory.productCategoryGrid.grdMain.setColumnProperty(col, 'lookupDisplay', true);
								
								$.each(data.authority, function(nn, vv){
						    		var menuCd = vv.MENU_CD;
						    		if((menuCd == "APS10301" && tmpProdPart == "LAM") || (menuCd == "APS10302" && tmpProdPart == "TEL") || (menuCd == "APS10303" && tmpProdPart == "DIFFUSION") || (menuCd == "APS10304" && tmpProdPart == "MATERIAL")){ 
						    			
						    			productCategory.productCategoryGrid.grdMain.setColumnProperty(thisCd, "editable", true);
						    			productCategory.productCategoryGrid.grdMain.setColumnProperty(thisCd, "styles", {"background" : gv_editColor});
						    			
						    			
						    			var editYn = thisCd + "_YN";
						    			var thisCdNm = thisCd + "_NM";
						    			
						    			var editStyle = {};
				    					var val = gfn_getDynamicStyle(-2);
				    					
				    					editStyle.background = gv_noneEditColor;
				    					editStyle.editable = true;
				    					
				    					val.criteria.push("(values['"+ editYn +"'] = 'N')");
				    					val.styles.push(editStyle);
				    					
				    					productCategory.productCategoryGrid.grdMain.setColumnProperty(productCategory.productCategoryGrid.grdMain.columnByField(thisCdNm), "dynamicStyles", [val]); 
						    		}
						    	});
					    	}
					    	
					    	codeCdTmp = new Array();
					    	codeNmTmp = new Array();
					    	codeCdTmp.push("");
					    	codeNmTmp.push("");
			    		}
			    		
			    		codeCdTmp.push(vCd);
			    		codeNmTmp.push(vNm);
			    	});
		    	}
			}, "obj");
		}
	};
	

	//조회
	var fn_apply = function (sqlFlag) {
		
		productCategory.productCategoryGrid.grdMain.cancel();
		productCategory.productCategoryGrid.dataProvider.rollback(productCategory.productCategoryGrid.dataProvider.getSavePoints()[0]);
		
		var tmpProd = gfn_nvl($("#prodPart").val(), "");
		
		if(tmpProd == ""){
			alert('<spring:message code="msg.prodPartMsg"/>');
			return;
		}
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		
		productCategory.gridMeasureData();
		
    	if(!sqlFlag){
    		productCategory.productCategoryGrid.gridInstance.setDraw();
		}
		
		//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
    	FORM_SEARCH.hiddenList = DIMENSION.hidden;
    	FORM_SEARCH.meaList	   = MEASURE.next;
    	
		if (!sqlFlag) {
			
			var fileds = productCategory.productCategoryGrid.dataProvider.getFields();
			
			for (var i = 0; i < fileds.length; i++) {
				
				var tFiledName = fileds[i].fieldName;
								
				if (tFiledName == 'SS_QTY_NM' || tFiledName == 'MFG_LT_NM' || tFiledName == 'SALES_PRICE_KRW_NM'
					|| tFiledName == 'WIP_QTY2_NM' || tFiledName == 'SP_QTY2_NM') {
					
					fileds[i].dataType = "number";
					fileds[i].numberFormat = "#,##0";
					
					productCategory.productCategoryGrid.grdMain.setColumnProperty(tFiledName, "styles", {"numberFormat" : "#,##0"});	
				}
			}
			productCategory.productCategoryGrid.dataProvider.setFields(fileds);
		}
		productCategory.search();	
		productCategory.excelSubSearch();	
	}

	// onload 
	$(document).ready(function() {
		productCategory.init();
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
