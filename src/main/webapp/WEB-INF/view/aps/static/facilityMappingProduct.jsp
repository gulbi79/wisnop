<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var itemMappingData = new Array();
	var subBucket = new Array();
	var facilityMappingProduct = {

		init : function () {
			
			gv_bucketW = 110;
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.facilityMappingGrid.initGrid();
		},
			
		_siq    : "aps.static.facilityMappingProductList",
		 
		initFilter : function() {
			
			gfn_setMsComboAll([
				{target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart"/>', data : this.comCode.codeMap.PROD_PART, exData:["*"], type : "S" },
				{target : 'divProdItemGroupMst', id : 'prodItemGroupMst', title : '<spring:message code="lbl.prodItemGroupMst"/>', data : [], exData:["*"], type : "S"},
				{target : 'divWorkplaces'      , id : 'workplaces'      , title : '<spring:message code="lbl.workplaces"/>'      , data : this.comCode.codeMapEx.WORK_PLACES_CD, exData:[""]},
				{target : 'divCampus', id : 'campus', title : '<spring:message code="lbl.campus"/>', data : this.comCode.codeMap.CAMPUS_CD, exData:[""]}
			]);
			
			$("#prodPart").change(function() {
				var groupMst   = [];
				var workplaces = [];
				
				var selectVal = $("#prodPart").val();
				
				$.each(facilityMappingProduct.comCode.codeMapEx.PROD_ITEM_GROUP_MST, function(idx, item) {
					if(selectVal == item.UPPER_CD) {
						groupMst.push(item);
					}
				});
				
				$.each(facilityMappingProduct.comCode.codeMapEx.WORK_PLACES_CD, function(idx, item) {
					if(selectVal == item.UPPER_CD) {
						workplaces.push(item);
					}
				});
				
				gfn_setMsCombo("prodItemGroupMst", groupMst, ["*"]);
				gfn_setMsCombo("workplaces", workplaces, [""]);
			});
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'PROD_PART,CAMPUS_CD';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["PROD_ITEM_GROUP_MST", "WORK_PLACES_CD"]);
				
				this.codeMap.PROD_PART[0].CODE_NM = "";
			}
		},
	
		/* 
		* grid  선언
		*/
		facilityMappingGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custBeforeBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.grdMain.setOptions({
					stateBar: { visible : true },
				});
				
				this.grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
					if(newValue == 0){
						alert('<spring:message code="msg.zeroMsg"/>');
						grid.setValue(dataRow, field, oldValue);
					}
				};
				
				this.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
					if(key == 46){  //Delete Key
						gfn_selBlockDelete(grid, facilityMappingProduct.facilityMappingGrid.dataProvider, "cols"); //컬럼구성  
					}
				}; 
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnReset").on('click', function (e) {
				facilityMappingProduct.facilityMappingGrid.grdMain.cancel();
				facilityMappingProduct.facilityMappingGrid.dataProvider.rollback(facilityMappingProduct.facilityMappingGrid.dataProvider.getSavePoints()[0]);
			});
			
			$("#btnSave").on('click', function (e) {
				facilityMappingProduct.save();
			});
			
			$("#btnAdd").click ("on", function() { facilityMappingProduct.add(); });
			$("#btnDel").click ("on", function() { facilityMappingProduct.del(); });
			
			$("#prodPart").change(function (e) {
				fnItemMapping();
			});
			
			$("#prodItemGroupMst").change(function (e) {
				fnItemMapping();
			});
		},
		
		getBucket : function (sqlFlag) {
			
			DIMENSION.hidden = [];
	    	DIMENSION.hidden.push({CD:"COMPANY_CD"  , dataType:"text"});
	    	DIMENSION.hidden.push({CD:"BU_CD"       , dataType:"text"});
	    	DIMENSION.hidden.push({CD:"PLANT_CD"    , dataType:"text"});
	    	DIMENSION.hidden.push({CD:"PROD_PART"   , dataType:"text"});
	    	DIMENSION.hidden.push({CD:"PROD_GROUP"  , dataType:"text"});
			
			var ajaxMap = {
				itemMappingData : itemMappingData,						
				month : {isDown : "Y", isUp : "N", upCal : "Q", isMt : "N", isExp : "N", expCnt : 999},
				sqlId : ["aps.static.bucketItem"]
			}
			
			gfn_getBucket(ajaxMap);
			gfn_setCustBucket(subBucket);
			
			$.each(BUCKET.query, function(i, val){
				
				var bucketId = val.BUCKET_ID;
				var bucketIdLen = bucketId.split("_").length - 1;
				var itemSub = bucketId.split("_")[bucketIdLen];
				
				val.TYPE = itemSub;
			});
			
			if(!sqlFlag){
				facilityMappingProduct.facilityMappingGrid.gridInstance.setDraw();
			} 
		},
		
		excelSubSearch : function (){
			
			EXCEL_SEARCH_DATA = "";
			EXCEL_SEARCH_DATA += "Product" + " : ";
			EXCEL_SEARCH_DATA += $("#loc_product").html();
			
			$.each($(".view_combo"), function(i, val){
				
				var temp = "";
				var id = gfn_nvl($(this).attr("id"), "");
				
				if(id != ""){
					
					var name = $("#" + id + " .ilist .itit").html();
					
					//타이틀
					EXCEL_SEARCH_DATA += "\n" + name + " : ";	
					
					//데이터
					if(id == "divProdPart"){
						EXCEL_SEARCH_DATA += $("#prodPart option:selected").text();
					}else if(id == "divProdItemGroupMst"){
						EXCEL_SEARCH_DATA += $("#prodItemGroupMst option:selected").text();
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
					}else if(id == "divFacility"){
						EXCEL_SEARCH_DATA += $("#facility").val();
					}
				}
			});
			
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList", _siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						facilityMappingProduct.facilityMappingGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						facilityMappingProduct.facilityMappingGrid.grdMain.cancel();
						
						facilityMappingProduct.facilityMappingGrid.dataProvider.setRows(data.resList);
						facilityMappingProduct.facilityMappingGrid.dataProvider.clearSavePoints();
						facilityMappingProduct.facilityMappingGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(facilityMappingProduct.facilityMappingGrid.dataProvider.getRowCount());
						//gfn_actionMonthSum(facilityMappingProduct.facilityMappingGrid.gridInstance);
						gfn_setRowTotalFixed(facilityMappingProduct.facilityMappingGrid.grdMain);
						
						facilityMappingProduct.gridCallback(data.resList);
						
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		gridCallback : function (resList) {
			
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj.do",
			    data    : {
	    			_mtd : "getList",
	    			tranData : [
	    				{outDs : "authorityList", _siq : "aps.static.facilityMappingProductAuthority"}
	    			]
			    },
			    success :function(data) {
			    	
			    	var editYn = false;
			    	var prodPart = $("#prodPart").val();
			    	
			    	$.each(data.authorityList, function(i, val){
			    		
			    		var menuCd = val.MENU_CD;
			    		
			    		if((menuCd == "APS10801" && prodPart == "LAM") || (menuCd == "APS10802" && prodPart == "TEL") || (menuCd == "APS10803" && prodPart == "DIFFUSION") || (menuCd == "APS10804" && prodPart == "MATERIAL")){
				    		editYn = true;
				    		return false;
				    	}
			    	});
			    	
			    	if(editYn){
			    		
			    		$.each(BUCKET.all[0], function(i, val){
			    			var cd = val.CD;
			    			facilityMappingProduct.facilityMappingGrid.grdMain.setColumnProperty(cd, "header", {"checkLocation": "left"} );
			    		});
			    		
			    		$.each(BUCKET.query, function(i, val){
			    			
			    			var bucketId = val.BUCKET_ID;
			    			
			    			facilityMappingProduct.facilityMappingGrid.grdMain.setColumnProperty(bucketId, "editable", true);
			    			facilityMappingProduct.facilityMappingGrid.grdMain.setColumnProperty(bucketId, "styles", {"background" : gv_editColor});
			    			facilityMappingProduct.facilityMappingGrid.grdMain.setColumnProperty(bucketId, "editor",  {type : "number", positiveOnly : true});
			    		});
			    	}
		    	}
			}, "obj");
		},
		
		
		save : function (){
			
			var grdData = gfn_getGrdSavedataAll(this.facilityMappingGrid.grdMain);
			
			var grdDataLen = grdData.length;
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			var itemProductData = [];
			
			$.each(grdData, function(i, val){
				
				var planData = {
					COMPANY_CD   : val.COMPANY_CD,
					BU_CD        : val.BU_CD,
					PLANT_CD     : val.PLANT_CD,
					RESOURCE_CD  : val.RESOURCE_CD,
					PROD_GROUP   : val.PROD_GROUP,
					BUCKET_LIST  : []
				};
				
				$.each(BUCKET.query, function(n, v){
					
					var bucketId = v.BUCKET_ID;
					var bucketIdLen = bucketId.split("_").length - 1;
					var itemCd = v.BUCKET_VAL;
					var itemSub = bucketId.split("_")[bucketIdLen];
					var item = itemCd + "_" + itemSub;
					var priority = eval("val." + bucketId);
					
					if(priority == "" || priority == undefined){
						priority = -1;
					}
					
					planData.BUCKET_LIST.push({
						ITEM_CD : itemCd,
						JOB_CD : itemSub,
						PRIORITY : priority
					});
				});
				itemProductData.push(planData);
			});
			
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
					
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveUpdate";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : facilityMappingProduct._siq, grdData : itemProductData},
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
		
		add : function (){
			
			var prodPart = gfn_nvl($("#prodPart").val(), "");
			var prodPartNm = $("#prodPart option:selected").text();
			var prodItemGroupMst = gfn_nvl($("#prodItemGroupMst").val(), "");
			var prodItemGroupMstNm = $("#prodItemGroupMst option:selected").text();
			
			if(prodPart == ""){
				alert('<spring:message code="msg.prodPartMsg"/>');
				return;
			}
			
			if(prodItemGroupMst == ""){
				alert('<spring:message code="msg.productCateMsg"/>');
				return;
			}
			
			gfn_comPopupOpen("FP_POP", {
				rootUrl : "aps/static",
				url     : "faciltyProduct",
				width   : 1000,
				height  : 800,
				part    : prodPart,
				partNm  : prodPartNm,
				product : prodItemGroupMst,
				productNm : prodItemGroupMstNm,
				itemMapping : itemMappingData,
				callback : "fnFaciltyProductPopCallbak"
			});
		},
		
		del : function (){
			
			var itemProductData = [];
			var row = facilityMappingProduct.facilityMappingGrid.dataProvider.getJsonRow(0);
			 
			$.each(BUCKET.all[0], function(i, val){
				
    			var cd = val.CD;
    			var checkColumn = facilityMappingProduct.facilityMappingGrid.grdMain.columnByName(cd);
    			var chkFlag = checkColumn.checked;
    			var itemCd = checkColumn.header.text;
    			
    			if(chkFlag){
        			
        			var planData = {
       					COMPANY_CD   : row.COMPANY_CD,
       					BU_CD        : row.BU_CD,
       					PLANT_CD     : row.PLANT_CD,
       					PROD_GROUP   : row.PROD_GROUP,
       					ITEM_CD      : itemCd
       				}; 
        			
        			itemProductData.push(planData);
    			}
    		});
			
			if (itemProductData.length == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			confirm('<spring:message code="msg.deleteCfm"/>', function() {
				
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveUpdate";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : "aps.static.facilityMappingProductDel", grdData : itemProductData},
				];
				
				var ajaxOpt = {
					url     : GV_CONTEXT_PATH + "/biz/obj.do",
					data    : FORM_SAVE,
					success : function(data) {
						alert('<spring:message code="msg.saveOk"/>');
						fnItemMapping(true);
					},
				};
				gfn_service(ajaxOpt, "obj");
			});
		}
	};
	
	function fnFaciltyProductPopCallbak(returnData){
		
		itemMappingData = [];
		
		$.each(returnData, function(i, val){
			itemMappingData.push(val.ITEM_CD);
		});
		
		fn_apply();
	}

	//조회
	var fn_apply = function (sqlFlag) {
		
		var prodPart = gfn_nvl($("#prodPart").val(), "");
		var prodItemGroupMst = gfn_nvl($("#prodItemGroupMst").val(), "");
		
		if(prodPart == ""){
			alert('<spring:message code="msg.prodPartMsg"/>');
			return;
		}
		
		if(prodItemGroupMst == ""){
			alert('<spring:message code="msg.productCateMsg"/>');
			return;
		}
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		facilityMappingProduct.getBucket(sqlFlag);
		
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
		facilityMappingProduct.search();
		facilityMappingProduct.excelSubSearch();
	}
	
	function fnItemMapping(searchYn){
		
		$("#btnAdd").show();
		$("#btnDel").show();
		
		FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [
			{ outDs : "itemData",_siq : "aps.static.itemDataList"},
			{ outDs : "bucketProduct",_siq : "aps.static.bucketProductList"}
		];
		
		var aOption = {
			url     : GV_CONTEXT_PATH + "/biz/obj.do",
			data    : FORM_SEARCH,
			success : function (data) {
				
				subBucket = [];
				itemMappingData = [];
				
				$.each(data.itemData, function(i, val){
					itemMappingData.push(val.ITEM_CD);
				});
				
				$.each(data.bucketProduct, function(i, val){
					var tmp = {CD : val.CODE_CD, NM : val.CODE_NM};
					subBucket.push(tmp);
				});
				if(searchYn){
					fn_apply(false);
				}
			}
		}
		
		gfn_service(aOption, "obj");
	}
	
	function fn_setBeforeFieldsBuket() {
		var fields = [
			{fieldName: "PROD_PART_NM", dataType : "text"},
			{fieldName: "WC_CD", dataType : "text"},
			{fieldName: "WC_NM", dataType : "text"},
			{fieldName: "WC_MGR_NM", dataType : "text"},
			{fieldName: "RESOURCE_CD", dataType : "text"},
			{fieldName: "RESOURCE_NM", dataType : "text"},
			{fieldName: "CAMPUS_NM", dataType : "text"}
        ];
    	return fields;
	}
	
	function fn_setBeforeColumnsBuket() {
		var totAr =  ['PROD_PART_NM', 'WC_CD', 'WC_NM', 'WC_MGR_NM', 'RESOURCE_CD', 'RESOURCE_NM', 'CAMPUS_NM'];
		var columns = 
		[
			{ 
				name : "PROD_PART_NM", fieldName : "PROD_PART_NM", editable : false, header: {text: '<spring:message code="lbl.prodPart2" javaScriptEscape="true" />'},
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
				name : "RESOURCE_CD", fieldName : "RESOURCE_CD", editable : false, header: {text: '<spring:message code="lbl.facilityCode" javaScriptEscape="true" />'},
				styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
				width : 120,
				mergeRule : { criteria: "value" },
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
			}, {
				name : "RESOURCE_NM", fieldName : "RESOURCE_NM", editable : false, header: {text: '<spring:message code="lbl.facilityName" javaScriptEscape="true" />'},
				styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
				width : 120,
				mergeRule : { criteria: "value" },
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
			}, {
				name : "CAMPUS_NM", fieldName : "CAMPUS_NM", editable : false, header: {text: '<spring:message code="lbl.campus" javaScriptEscape="true" />'},
				styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
				width : 120,
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
			}
		];
		
		return columns;
	}

	// onload 
	$(document).ready(function() {
		facilityMappingProduct.init();
	});
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
	
	
		<div id="c" class="split content">
			<%@ include file="/WEB-INF/view/common/leftTree.jsp"%>
		</div>
	
		<div id="d" class="split content">
			<form id="searchForm" name="searchForm">
			
			<div id="filterDv">
				<div class="inner">
					<h3>Filter</h3>
					<div class="tabMargin"></div>
					<div class="scroll">
						<div class="view_combo" id="divProdPart"></div>
						<div class="view_combo" id="divProdItemGroupMst"></div>
						<div class="view_combo" id="divWorkplaces"></div>
						<div class="view_combo" id="divCampus"></div>
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
					<a href="javascript:;" id="btnAdd" class="app1 roleWrite" style="display:none"><spring:message code="lbl.add" /></a>
					<a href="javascript:;" id="btnDel" class="app1 roleWrite" style="display:none"><spring:message code="lbl.delete" /></a>
				</div>
				
				
				<div class="bright">
					<a href="javascript:;" id="btnReset" class="app1 roleWrite"><spring:message code="lbl.reset" /></a>
					<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
