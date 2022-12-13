<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 적기이동율 -->
	
	<style type="text/css">
	
	#scrollDiv::-webkit-scrollbar-track
	{
	 background-color: transparent;
	}
	
	
	#scrollDiv::-webkit-scrollbar
    {
     width: 3px;
    background-color: transparent;
    }
    
    #scrollDiv::-webkit-scrollbar-thumb
    {
       background-color: #0ae;
    
    background-image: -webkit-gradient(linear, 0 0, 0 100%,
                       color-stop(.5, rgba(255, 255, 255, .2)),
                       color-stop(.5, transparent), to(transparent));
    }
	</style>
	
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var properCrtraMove = {
		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.matGrid.initGrid();
		},
			
		_siq    : "supply.purchase.properCrtraMoveList",
		
		initFilter : function() {
			
			var itemTypeEvent = {
				childId   : ["upItemGroup"],  
				childData : [this.comCode.codeMapEx.UPPER_ITEM_GROUP, this.comCode.codeMapEx.ROUTING],
				callback  : function() {
					//품목그룹 초기화
					gfn_eventChkAllMsCombo("upItemGroup"); //하위오브젝트중 전체체크할 오브젝트 아이디를 파라미터로 던진다.
				}
			};
	    	
	    	//품목대그룹
			var upperItemEvent = {
				childId   : ["itemGroup"],
				childData : [this.comCode.codeMapEx.ITEM_GROUP],
			};
			 
			// 키워드팝업
			gfn_keyPopAddEvent([
				{target : 'divProdOrderNo', id : 'prodOrderNo', type : 'PROD_ORDER_NO', title : '<spring:message code="lbl.prodOrderNo"/>' },
				{target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' },
				//자품목 코드
				{target : 'divMaterialsCode', id : 'materialsCode', type : 'MATERIALS_CODE', title : '<spring:message code="lbl.childItem"/>' }
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divProcurType',   id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				
				// 조달구분 (자품목)
				{target : 'divProcurTypeChild',   id : 'procurTypeChild',    title : '<spring:message code="lbl.procur2Child"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{target : 'divUpItemGroup',  id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent, option: {allFlag:"Y"}},
				{target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:[""]},
				
				//품목그룹 (자품목)
				{target : 'divItemGroupChild', id : 'itemGroupChild', title : '<spring:message code="lbl.itemGroupChild"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:[""]},
				{target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""], event : itemTypeEvent, option: {allFlag:"Y"}},
				
				//품목유형(자품목) 
				{target : 'divItemTypeChild', id : 'itemTypeChild', title : '<spring:message code="lbl.itemTypeChild"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""], event : itemTypeEvent, option: {allFlag:"Y"}},
				
				{target : 'divObeyYn', id : 'obeyYn', title : '<spring:message code="lbl.obeyYn"/>', data : this.comCode.codeMap.OBEY_CD, exData:["*"], type : "S"},
			]);
			
	       	DATEPICKET(null, -5, 0);
	       	
	       	$('#toCal').datepicker("option", "maxDate", 0);
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,
			codeMap : null,
			
			initCode  : function () {
				var grpCd = 'ITEM_TYPE,OBEY_CD,PROCUR_TYPE';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["ITEM_GROUP", "UPPER_ITEM_GROUP"]);
			}
		},
		
		/* 
		* grid  선언
		*/
		matGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custNextBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.grdMain.setOptions({
					stateBar: { visible : true },
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
				
				this.grdMain.addCellStyles([{
					id         : "noneEditStyle",
					editable   : false
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
				properCrtraMove.save();
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
					
					//데이터
					if(id == "divProdOrderNo"){
						EXCEL_SEARCH_DATA += $("#prodOrderNo_nm").val();
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
					}else if(id == "divMaterialsCode"){
						EXCEL_SEARCH_DATA += $("#materialsCode_nm").val();
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
					}else if(id == "divObeyYn"){
						EXCEL_SEARCH_DATA += $("#obeyYn option:selected").text();
					}
				}
			});
			
			EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
			EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ") ~ ";
			EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toWeek").val() + ")"; 
			
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
						properCrtraMove.matGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						properCrtraMove.matGrid.grdMain.cancel();
						
						properCrtraMove.matGrid.dataProvider.setRows(data.resList);
						properCrtraMove.matGrid.dataProvider.clearSavePoints();
						properCrtraMove.matGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(properCrtraMove.matGrid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(properCrtraMove.matGrid.grdMain);
						
						$.each(data.resList, function(n, v){
							var grpLvlId = v.GRP_LVL_ID;
							if(grpLvlId != 0){
								properCrtraMove.matGrid.grdMain.setCellStyles(n, "REMARK", "noneEditStyle");
							}
						});
						
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function(sqlFlag) {
			if (!sqlFlag) {
				properCrtraMove.matGrid.gridInstance.setDraw();
			}
		},
		
		save : function() {
			
			var grdData = gfn_getGrdSavedataAll(this.matGrid.grdMain);
			if (grdData.length == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
				
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
					
				FORM_SAVE          = {}; //초기화
				FORM_SAVE._mtd     = "saveAll";
				FORM_SAVE.tranData = [{outDs : "saveCnt", _siq : "supply.purchase.properCrtraMoveList", grdData : grdData}];	
					
				gfn_service({
					url    : GV_CONTEXT_PATH + "/biz/obj",
					data   : FORM_SAVE,
					success: function(data) {
						alert('<spring:message code="msg.saveOk"/>');
						fn_apply();
					}
				}, "obj");
				
			});
		},
	};
	

	//조회
	var fn_apply = function (sqlFlag) {

		gfn_getMenuInit();
		
    	FORM_SEARCH = $("#searchForm").serializeObject(); 
    	FORM_SEARCH.sql     = sqlFlag;
    	FORM_SEARCH.dimList = DIMENSION.user;
    	
    	properCrtraMove.getBucket(sqlFlag); 
		properCrtraMove.search();
		properCrtraMove.excelSubSearch();
	};
	
	function fn_setNextFieldsBuket() {
		var fields = [
			{fieldName: "REQ_QTY", dataType : "number"},
			{fieldName: "CONFIRM_QTY", dataType : "number"},
			{fieldName: "RELEASE_DATE"},
			{fieldName: "STANDARD_DATE"},
			{fieldName: "MAT_WAIT_DATE"},
			{fieldName: "CONFIRM_DATE"},
			{fieldName: "DIFF"},
			{fieldName: "OBEY", dataType : "number"},
			{fieldName: "EXCEPTION", dataType : "number"},
			{fieldName: "NO_OBEY", dataType : "number"},
			{fieldName: "INV_QTY", dataType : "number"},
			{fieldName: "STK_ON_INSP_QTY", dataType : "number"},
			{fieldName: "CC_QTY", dataType : "number"},
			{fieldName: "PERCENTAGE"},
			{fieldName: "REMARK"}
        ];
    	
    	return fields;
	}
	
	function fn_setNextColumnsBuket() {
		var columns = [
			{
				name : "REQ_QTY", fieldName: "REQ_QTY", editable : false, header: {text: '<spring:message code="lbl.reqQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "CONFIRM_QTY", fieldName: "CONFIRM_QTY", editable : false, header: {text: '<spring:message code="lbl.matReleaseQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "RELEASE_DATE", fieldName: "RELEASE_DATE", editable : false, header: {text: '<spring:message code="lbl.releaseDate" javaScriptEscape="true" />'},
				styles: {textAlignment: "center", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "STANDARD_DATE", fieldName: "STANDARD_DATE", editable : false, header: {text: '<spring:message code="lbl.standardDate" javaScriptEscape="true" />'},
				styles: {textAlignment: "center", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "MAT_WAIT_DATE", fieldName: "MAT_WAIT_DATE", editable : false, header: {text: '<spring:message code="lbl.matReleaseConfirmDate" javaScriptEscape="true" />'},
				styles: {textAlignment: "center", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "CONFIRM_DATE", fieldName: "CONFIRM_DATE", editable : false, header: {text: '<spring:message code="lbl.matReleaseDate" javaScriptEscape="true" />'},
				styles: {textAlignment: "center", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "DIFF", fieldName: "DIFF", editable : false, header: {text: '<spring:message code="lbl.delayDate" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "OBEY", fieldName: "OBEY", editable : false, header: {text: '<spring:message code="lbl.obey" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "EXCEPTION", fieldName: "EXCEPTION", editable : false, header: {text: '<spring:message code="lbl.exception" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "NO_OBEY", fieldName: "NO_OBEY", editable : false, header: {text: '<spring:message code="lbl.noObey" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "PERCENTAGE", fieldName: "PERCENTAGE", editable : false, header: {text: '<spring:message code="lbl.onTimeRate" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "INV_QTY", fieldName: "INV_QTY", editable : false, header: {text: '<spring:message code="lbl.inventoryStatus" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "CC_QTY", fieldName: "CC_QTY", editable : false, header: {text: '<spring:message code="lbl.passCnt" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "STK_ON_INSP_QTY", fieldName: "STK_ON_INSP_QTY", editable : false, header: {text: '<spring:message code="lbl.testCnt" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "REMARK", fieldName: "REMARK", editable : true, header: {text: '<spring:message code="lbl.remark" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background : gv_editColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}
		];
		
		return columns;
	}
	
	// onload 
	$(document).ready(function() {
		properCrtraMove.init();
	});
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<div id="filterDv">
			<div class="inner" ><!--style="padding:4px;"  -->
				<h3>Filter</h3>
				<div class="tabMargin"></div>
				<div class="scroll" id="scrollDiv">
					<div class="view_combo" id="divProdOrderNo"></div>   <!-- 작업지시번호 -->
					<div class="view_combo" id="divItem"></div>          <!-- 품목 -->
					<div class="view_combo" id="divProcurType"></div>    <!-- 조달 -->
					<div class="view_combo" id="divItemType"></div>      <!-- 품목유형  -->
					<div class="view_combo" id="divUpItemGroup"></div>   <!-- 상위 품목그룹  -->
					<div class="view_combo" id="divItemGroup"></div>     <!-- 품목그룹  -->
					
					<div class="view_combo" id="divMaterialsCode"></div> <!-- 자재 코드 -> 자품목 코드(이름 변경)  -->
					<div class="view_combo" id="divProcurTypeChild"></div>    <!-- 조달구분(자품목) -->
					<div class="view_combo" id="divItemTypeChild"></div>      <!-- 품목유형(자품목)  -->
					<div class="view_combo" id="divItemGroupChild"></div>      <!-- 품목그룹(자품목) -->
                    
					
					<div class="view_combo" id="divObeyYn"></div>
					<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
						<jsp:param name="radioYn" value="N"/>
						<jsp:param name="wType" value="SW"/>
					</jsp:include>
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
			<div class="cbt_btn roleWrite">	
				<div class="bright">
					<a id="btnReset"       href="#" class="app1"><spring:message code="lbl.reset" /></a>  
					<a id="btnSave"        href="#" class="app2"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
