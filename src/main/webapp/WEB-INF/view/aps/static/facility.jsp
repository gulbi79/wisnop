<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var resourceEffRateArray;
	var ovenAreaArray;
	var facility = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.facilityGrid.initGrid();
		},
			
		_siq    : "aps.static.facilityList",
		 
		initFilter : function() {
			
			var upperWorkPlaces = {
				childId   : ["workplaces"],
				childData : [this.comCode.codeMapEx.WORK_PLACES_CD],
			};
			
			gfn_setMsComboAll([
				{target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart2"/>', data : this.comCode.codeMap.PROD_PART, exData:[""], event: upperWorkPlaces},
				{target : 'divProdOrQc', id : 'prodOrQc', title : '<spring:message code="lbl.prodOrQc"/>', data : this.comCode.codeMap.PROD_OR_QC, exData:[""]},
				{target : 'divWorkplaces', id : 'workplaces', title : '<spring:message code="lbl.workplaces"/>', data : this.comCode.codeMapEx.WORK_PLACES_CD, exData:[""]},
				{target : 'divCampus', id : 'campus', title : '<spring:message code="lbl.campus"/>', data : this.comCode.codeMap.CAMPUS_CD, exData:[""]},
				{target : 'divOvenFalg', id : 'ovenFlag', title : '<spring:message code="lbl.ovenFlag"/>', data : this.comCode.codeMap.FLAG_YN, exData:[], type : "S"},
				{target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING_FACILITY, exData:["*"]},
			]);
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'PROD_PART,CAMPUS_CD,FLAG_YN,PROD_OR_QC';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["WORK_PLACES_CD","ROUTING_FACILITY"]);
			}
		},
	
		/* 
		* grid  선언
		*/
		facilityGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.setColumn();
				this.setOptions();
			},
			setColumn : function () {
				var totAr =  ['PROD_PART_NM', 'PROD_OR_QC_NM', 'WC_CD', 'WC_NM', 'WC_MGR_NM', 'RESOURCE_CD', 'RESOURCE_NM', 'CAMPUS_NM', 'OVEN_FLAG', 'ETCHING_FLAG', 'CLEANING_FLAG'];
				var columns = 
				[
					{ 
						name : "PROD_PART_NM", fieldName : "PROD_PART_NM", editable : false, header: {text: '<spring:message code="lbl.prodPart2" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
						width : 120,
						mergeRule : { criteria: "value" },
						dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
					}, { 
						name : "PROD_OR_QC_NM", fieldName : "PROD_OR_QC_NM", editable : false, header: {text: '<spring:message code="lbl.prodOrQc" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
						width : 120,
						mergeRule : { criteria: "value" },
						dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
					}, {
						name : "WC_CD", fieldName : "WC_CD", editable : false, header: {text: '<spring:message code="lbl.workplacesCode" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
						width : 120,
						mergeRule : { criteria: "value" },
						dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
					}, {
						name : "WC_NM", fieldName : "WC_NM", editable : false, header: {text: '<spring:message code="lbl.workplacesName" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
						width : 120,
						mergeRule : { criteria: "value" },
						dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
					}, {
						name : "WC_MGR_NM", fieldName : "WC_MGR_NM", editable : false, header: {text: '<spring:message code="lbl.workplacesType" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
						width : 120,
						mergeRule : { criteria: "values['WC_NM'] + value" },
						dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
					}, {
						name : "ROUTING_ID", fieldName : "ROUTING_ID", editable : false, header: {text: '<spring:message code="lbl.routing" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
						width : 120,
						mergeRule : { criteria: "values['WC_NM'] + value" },
						dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
					}, {
						name : "RESOURCE_CD", fieldName : "RESOURCE_CD", editable : false, header: {text: '<spring:message code="lbl.facilityCode" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
						width : 120,
						mergeRule : { criteria: "value" },
						dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
					}, {
						name : "RESOURCE_NM", fieldName : "RESOURCE_NM", editable : false, header: {text: '<spring:message code="lbl.facilityName" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
						width : 120,
						dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
					}, {
						name : "CAMPUS_NM", fieldName : "CAMPUS_NM", editable : false, header: {text: '<spring:message code="lbl.campus" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
						width : 100,
						dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
					}, {
						name : "OVEN_FLAG", fieldName : "OVEN_FLAG", editable : false, header: {text: '<spring:message code="lbl.ovenFlag" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
						width : 70,
						dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
					}, {
						name : "ETCHING_FLAG", fieldName : "ETCHING_FLAG", editable : false, header: {text: '<spring:message code="lbl.etchingFlag" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
						width : 70,
						dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
					}, {
						name : "CLEANING_FLAG", fieldName : "CLEANING_FLAG", editable : false, header: {text: '<spring:message code="lbl.cleaningFlag" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
						width : 70,
						dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
					}, {
						name : "RESOURCE_EFF_RATE", fieldName : "RESOURCE_EFF_RATE", editable : false, header: {text: '<spring:message code="lbl.facilityRate" javaScriptEscape="true" />'},
						editor : { type : "number", textAlignment : "far", editFormat : "#,##0.##", positiveOnly : true},
						styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.##"},
						dataType : "number",
						width : 120,
					}, {
						name : "OVEN_AREA", fieldName : "OVEN_AREA", editable : false, header: {text: '<spring:message code="lbl.ovenArea" javaScriptEscape="true" />'},
						editor : { type : "number", textAlignment : "far", editFormat : "#,##0", integerOnly : true},
						styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dataType : "number",
						width : 120,
					}, {
						name : "OVEN_RUN_TIME", fieldName : "OVEN_RUN_TIME", editable : false, header: {text: '<spring:message code="lbl.ovenRnuTime" javaScriptEscape="true" />'},
						editor : { type : "number", textAlignment : "far", editFormat : "#,##0", integerOnly : true},
						styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dataType : "number",
						width : 120,
					}, {
						name : "OVEN_WIDTH", fieldName : "OVEN_WIDTH", editable : false, header: {text: '<spring:message code="lbl.ovenWidth" javaScriptEscape="true" />'},
						editor : { type : "number", textAlignment : "far", editFormat : "#,##0", integerOnly : true},
						styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dataType : "number",
						width : 120,
					}, {
						name : "OVEN_LENGTH", fieldName : "OVEN_LENGTH", editable : false, header: {text: '<spring:message code="lbl.ovenLength" javaScriptEscape="true" />'},
						editor : { type : "number", textAlignment : "far", editFormat : "#,##0", integerOnly : true},
						styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dataType : "number",
						width : 120,
					}, {
						name : "VALID_TO_DATE", fieldName : "VALID_TO_DATE", editable : false, header: {text: '<spring:message code="lbl.validToDate" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						width : 70,
						dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
					}, {
						name: "USE_FLAG",
		                fieldName: "USE_FLAG",
		                editable: false,
		                lookupDisplay: true,
		                values: gfn_getArrayExceptInDs(facility.comCode.codeMap.FLAG_YN, "CODE_CD", ""),
		                labels: gfn_getArrayExceptInDs(facility.comCode.codeMap.FLAG_YN, "CODE_NM", ""),
		                editor: {
		                    type: "dropDown",
		                    domainOnly: true,
		                    textReadOnly: true,
		                }, 
		                header: {text: '<spring:message code="lbl.useYn"/>'},
		                styles: {textAlignment: "center", background : gv_noneEditColor},
		                width: 80,
		                editButtonVisibility: "visible"
					}
				];
				
				//[""] hidden 할 컬럼 넣는다.
				this.setFields(columns, ["COMPANY_CD", "BU_CD", "PLANT_CD", "CAMPUS_CD", "PROD_PART", "PROD_OR_QC"]);
				
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols, hiddenCols) {
				
				var fields = new Array();
				
				$.each(cols, function(i, v) {
					
					var tFieldName = v.fieldName;
					var tDataType = v.dataType;
					
					fields.push({fieldName : tFieldName, dataType : tDataType});
					
				});
				
				if (hiddenCols !== undefined && hiddenCols.length > 0) {
					for (hid in hiddenCols) {
						fields.push({fieldName : hiddenCols[hid]});
					}
				}
				
				this.dataProvider.setFields(fields);
				
			},
			
			setOptions : function () {
				this.grdMain.setOptions({
					stateBar: { visible : true },
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
				
				
				this.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
					if(key == 46){  //Delete Key
						gfn_selBlockDelete(grid, facility.facilityGrid.dataProvider); //셀구성  
						//gfn_selBlockDelete(grid, facility.facilityGrid.dataProvider, "cols"); //컬럼구성  
					}
				};
				
				this.grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
					
					var fieldNm = facility.facilityGrid.dataProvider.getFieldName(field);
					
					if(fieldNm == "RESOURCE_EFF_RATE"){//설비 효율
						if(newValue > 100){
							grid.setValue(dataRow, field, oldValue);
						}
					}else if(fieldNm == "OVEN_RUN_TIME"){
						if(newValue > 1000){
							grid.setValue(dataRow, field, oldValue);
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
				facility.facilityGrid.grdMain.cancel();
				facility.facilityGrid.dataProvider.rollback(facility.facilityGrid.dataProvider.getSavePoints()[0]);
				
				facility.facilityGrid.grdMain.setCellStyles(resourceEffRateArray, "RESOURCE_EFF_RATE", "editStyle");
				facility.facilityGrid.grdMain.setCellStyles(ovenAreaArray, "OVEN_AREA", "editStyle");
				facility.facilityGrid.grdMain.setCellStyles(ovenAreaArray, "OVEN_RUN_TIME", "editStyle");
				facility.facilityGrid.grdMain.setCellStyles(ovenAreaArray, "OVEN_WIDTH", "editStyle");
				facility.facilityGrid.grdMain.setCellStyles(ovenAreaArray, "OVEN_LENGTH", "editStyle");
				facility.facilityGrid.grdMain.setCellStyles(resourceEffRateArray, "USE_FLAG", "editStyle");
			});
			
			$("#btnSave").on('click', function (e) {
				facility.save();
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
						$.each($("#prodPart option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divProdOrQc"){
						$.each($("#prodOrQc option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divWorkplaces"){
						$.each($("#workplaces option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divCampus"){
						$.each($("#campus option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divOvenFalg"){
						EXCEL_SEARCH_DATA += $("#ovenFlag option:selected").text();
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
					}else if(id == "divFacility"){
						EXCEL_SEARCH_DATA += $("#facility").val();
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
						facility.facilityGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						facility.facilityGrid.grdMain.cancel();
						
						facility.facilityGrid.dataProvider.setRows(data.resList);
						facility.facilityGrid.dataProvider.clearSavePoints();
						facility.facilityGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(facility.facilityGrid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(facility.facilityGrid.grdMain);
						
						facility.gridCallback(data.resList);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		gridCallback : function (resList) {
			
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj",
			    data    : {
			    			_mtd : "getList",
			    			tranData : [
			    				{outDs : "authorityList", _siq : "aps.static.facilityAuthority"},
	                            {outDs : "routingList", _siq : "aps.static.facilityRouting"}
			    			]
			    },
			    success :function(data) {
			    	
			    	if(data.authorityList.length != 0)
                    {
			    		
			    		for(i = 0; i < data.authorityList.length; i++ )
			    		{
			    			// 곹통권한 소유할 경우 Material routing editable 처리
	                        if(data.authorityList[i].ROLE_CD == "PRO0009"||data.authorityList[i].ROLE_CD == "PRO0010"||data.authorityList[i].ROLE_CD == "PRO0011" )
	                        {
	                            data.routingList.push({CODE_CD:"3-R"});
	                            data.routingList.push({CODE_CD:"3-W"});
	                        }	
			    		}
			    		
			    		
                    }
			    	
			    	var dataLen = data.routingList.length;
			    	
			    	
			    	resourceEffRateArray = new Array();
			    	ovenAreaArray = new Array();
			    	
					for(var i = 0; i < dataLen; i++){
			    		
			    		var codeCd = data.routingList[i].CODE_CD;
			    		
			    		$.each(resList, function(n, v){
			    			
			    			var routingId = v.ROUTING_ID;
			    			var ovenFlag = v.OVEN_FLAG;

			    			if(codeCd == routingId){			
			    				resourceEffRateArray.push(n);
			    				if(ovenFlag == "Y"){
			    					ovenAreaArray.push(n);
			    				}
			    			}
			    			
			    			
			    			
			    			
			    		});
			    	}
					
					facility.facilityGrid.grdMain.setCellStyles(resourceEffRateArray, "RESOURCE_EFF_RATE", "editStyle");
					facility.facilityGrid.grdMain.setCellStyles(ovenAreaArray, "OVEN_AREA", "editStyle");
					facility.facilityGrid.grdMain.setCellStyles(ovenAreaArray, "OVEN_RUN_TIME", "editStyle");
					facility.facilityGrid.grdMain.setCellStyles(ovenAreaArray, "OVEN_WIDTH", "editStyle");
					facility.facilityGrid.grdMain.setCellStyles(ovenAreaArray, "OVEN_LENGTH", "editStyle");
					facility.facilityGrid.grdMain.setCellStyles(resourceEffRateArray, "USE_FLAG", "editStyle");
					
		    	}
			}, "obj");
		},
		
		
		save : function (){
			
			var grdData = gfn_getGrdSavedataAll(this.facilityGrid.grdMain);
			
			var grdDataLen = grdData.length;
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
					
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveUpdate";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : facility._siq, grdData : [{rowList : grdData}]},
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
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
		facility.search();
		facility.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		facility.init();
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
					<div class="view_combo" id="divProdOrQc"></div>
					<div class="view_combo" id="divWorkplaces"></div>
					<div class="view_combo" id="divCampus"></div>
					<div class="view_combo" id="divOvenFalg"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divFacility">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.facility"/></div>
							<input type="text" id="facility" name="facility" class="ipt">
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
				<div class="bright">
					<a href="javascript:;" id="btnReset" class="app1 roleWrite"><spring:message code="lbl.reset" /></a>
					<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
