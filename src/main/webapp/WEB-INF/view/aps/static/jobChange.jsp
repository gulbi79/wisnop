<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">
	
	var enterSearchFlag = "Y";
	var itemMappingData = new Array();
	var subBucket = new Array();
	var jobChange = {

		init : function () {
			
			$("#comBucketMask").val("#,##0.00");
			gv_meaW = 150;
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.jobChangeGrid.initGrid();
		},
			
		_siq    : "aps.static.jobChangeList",
		 
		initFilter : function() {
			
			gfn_setMsComboAll([
				{target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart"/>', data : this.comCode.codeMap.PROD_PART, exData:["*"], type : "S" },
				{target : 'divProdItemGroupMst', id : 'prodItemGroupMst', title : '<spring:message code="lbl.prodItemGroupMst"/>', data : [], exData:["*"], type : "S"},
			]);
			
			$("#prodPart").change(function() {
				var newData   = [];
				var selectVal = $("#prodPart").val();
				
				$.each(jobChange.comCode.codeMapEx.PROD_ITEM_GROUP_MST, function(idx, item) {
					
					if(selectVal == item.UPPER_CD && item.ATTB_4_CD == "ITEM_GROUP") {
						newData.push(item);
					}
				});
				
				gfn_setMsCombo("prodItemGroupMst", newData, ["*"]);
			});
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'PROD_PART';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["PROD_ITEM_GROUP_MST"]);
				
				this.codeMap.PROD_PART[0].CODE_NM = "";
			}
		},
	
		/* 
		* grid  선언
		*/
		jobChangeGrid : {
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
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : "#EDD200"
				}, {
					id         : "measureStyle",
					editable   : false,
					background : "#edf7fd"
				}]);
				
				this.grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
					if(newValue == 0){
						alert('<spring:message code="msg.zeroMsg"/>');
						grid.setValue(dataRow, field, oldValue);
					}
				};
				
				this.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
					if(key == 46){  //Delete Key
						//gfn_selBlockDelete(grid, facility.facilityGrid.dataProvider); //셀구성  
						gfn_selBlockDelete(grid, jobChange.jobChangeGrid.dataProvider, "cols"); //컬럼구성  
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
				jobChange.jobChangeGrid.grdMain.cancel();
				jobChange.jobChangeGrid.dataProvider.rollback(jobChange.jobChangeGrid.dataProvider.getSavePoints()[0]);
			});
			
			$("#btnSave").on('click', function (e) {
				jobChange.save();
			});
		},
		
		getBucket : function (sqlFlag) {
			
			DIMENSION.hidden = [];
	    	DIMENSION.hidden.push({CD:"COMPANY_CD"  , dataType:"text"});
	    	DIMENSION.hidden.push({CD:"BU_CD"       , dataType:"text"});
	    	DIMENSION.hidden.push({CD:"PROD_PART"   , dataType:"text"});
	    	DIMENSION.hidden.push({CD:"PROD_GROUP"   , dataType:"text"});
			 
			 var ajaxMap = {
				prodPart : $("#prodPart").val(),						
				prodItemGroupMst : $("#prodItemGroupMst").val(),						
				month : {isDown : "N", isUp : "N", upCal : "Q", isMt : "N", isExp : "N", expCnt : 999},
				sqlId : ["aps.static.measureBucketList"]
			}
			
			gfn_getBucket(ajaxMap);
			 
			$.each(BUCKET.query, function(i, val){
				MEASURE.user.push({CD : val.BUCKET_ID, NM : val.NM})
			});
			 
			if(!sqlFlag){
				jobChange.jobChangeGrid.gridInstance.setDraw();
			}
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
					}else if(id == "divProdItemGroupMst"){
						EXCEL_SEARCH_DATA += $("#prodItemGroupMst option:selected").text();
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
						jobChange.jobChangeGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						jobChange.jobChangeGrid.grdMain.cancel();
						
						jobChange.jobChangeGrid.dataProvider.setRows(data.resList);
						jobChange.jobChangeGrid.dataProvider.clearSavePoints();
						jobChange.jobChangeGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(jobChange.jobChangeGrid.dataProvider.getRowCount());
						//gfn_actionMonthSum(jobChange.jobChangeGrid.gridInstance);
						gfn_setRowTotalFixed(jobChange.jobChangeGrid.grdMain);
						
						jobChange.gridCallback(data.resList);
						
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
	    				{outDs : "authorityList", _siq : "aps.static.jobChagneAuthority"}
	    			]
			    },
			    success :function(data) {
			    	
			    	var editYn = false;
			    	var prodPart = $("#prodPart").val();
			    	
			    	$.each(data.authorityList, function(i, val){
			    		
			    		var menuCd = val.MENU_CD;
			    		
			    		if((menuCd == "APS11001" && prodPart == "LAM") || (menuCd == "APS11002" && prodPart == "TEL") || (menuCd == "APS11003" && prodPart == "DIFFUSION") || (menuCd == "APS11004" && prodPart == "MATERIAL")){
				    		editYn = true;
				    		return false;
				    	}
			    	});
			    	
			    	if(editYn){
			    		
			    		$.each(BUCKET.query, function(i, val){
			    			
			    			var cd = val.CD;
			    			jobChange.jobChangeGrid.grdMain.setColumnProperty(cd, "editable", true);
			    			jobChange.jobChangeGrid.grdMain.setColumnProperty(cd, "styles", {"background" : gv_editColor});
			    			jobChange.jobChangeGrid.grdMain.setColumnProperty(cd, "editor",  {type : "number", editFormat : "#,##0.##", positiveOnly : true});
			    			
							//가운데 색상 			    			
			    			$.each(BUCKET.query, function(n, v){
			    				var subCd = v.CD;
			    				if(cd == subCd){
			    					jobChange.jobChangeGrid.grdMain.setCellStyles(i, subCd, "editStyle");
			    					return false;
			    				}
			    			});
			    		});
			    	}
			    	
			    	//Measure 파란색으로 색깔주기
			    	jobChange.jobChangeGrid.grdMain.setColumnProperty("CATEGORY_NM", "dynamicStyles", function(grid, index, value) {
						return {background : gfn_getArrDimColor(0)};
					});
			    	
			    	jobChange.jobChangeGrid.grdMain.setColumnProperty("CATEGORY_NM", "header", "FROM \\ TO");
			    	
		    	}
			}, "obj");
		},
		
		save : function (){
			
			var grdData = gfn_getGrdSavedataAll(this.jobChangeGrid.grdMain);
			
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
					PROD_PART    : val.PROD_PART,
					PROD_GROUP   : val.PROD_GROUP,
					BUCKET_LIST  : []
				};
				
				var fromProdGroupDet = val.CATEGORY_CD;
				
				$.each(BUCKET.query, function(n, v){
					
					var cd = v.CD;
					var bucketId = v.BUCKET_ID;
					var jcTime = eval("val." + cd);
					
					if(jcTime == "" || jcTime == undefined){
						jcTime = "NULL";
					}
					
					planData.BUCKET_LIST.push({
						FROM_PROD_GROUP_DET : fromProdGroupDet,
						TO_PROD_GROUP_DET : bucketId,
						JC_TIME : jcTime
					});
				});
				itemProductData.push(planData);
			});
			
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
					
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveUpdate";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : jobChange._siq, grdData : itemProductData},
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
		jobChange.getBucket(sqlFlag);
		
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
		jobChange.search();
		jobChange.excelSubSearch();
	}
	
	function fn_setBeforeFieldsBuket() {
		var fields = [
			{fieldName: "PROD_PART_NM", dataType : "text"},
			{fieldName: "PROD_GROUP_NM", dataType : "text"},
        ];
    	return fields;
	}
	
	function fn_setBeforeColumnsBuket() {
		var totAr =  ['PROD_PART_NM', 'PROD_GROUP'];
		var columns = 
		[
			{ 
				name : "PROD_PART_NM", fieldName : "PROD_PART_NM", editable : false, header: {text: '<spring:message code="lbl.prodPart2" javaScriptEscape="true" />'},
				styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
				width : 120,
				mergeRule : { criteria: "value" },
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
			}, {
				name : "PROD_GROUP_NM", fieldName : "PROD_GROUP_NM", editable : false, header: {text: '<spring:message code="lbl.prodItemGroupMst2" javaScriptEscape="true" />'},
				styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
				width : 120,
				mergeRule : { criteria: "value" },
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
			}
		];
		
		return columns;
	}

	// onload 
	$(document).ready(function() {
		jobChange.init();
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
					<div class="view_combo" id="divProdItemGroupMst"></div>
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
