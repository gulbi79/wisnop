<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>
	<!-- 경영계획 업로드 -->
	<script type="text/javascript">
	
	var enterSearchFlag = "Y";
	var trnaslateMng = {

		init : function () {
			gfn_formLoad();
			this.events();
			this.comCode.initCode();
			this.transGrid.initGrid();
		},
		
		_siq : "dp.targetMgmt.bizPlanList",
		
		/********************************************************************************************************
		** common Code  
		********************************************************************************************************/
		comCode : {
			codeMap : null,
			
			initCode : function () {
				var grpCd = "BU_CD,BIZ_PLAN";
		    	this.codeMap = gfn_getComCode(grpCd); //공통코드 조회
			}
		},
		
		/********************************************************************************************************
		** grid  선언  
		********************************************************************************************************/
		transGrid : {
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
				this.gridEvents();
				
				var baseDt = new Date();
				$("#year").val(baseDt.getFullYear());
				$("#year").inputmask("mask", "9999");
			},
			
			setColumn : function () {
				var columns = 
				[
					{ 
						name : "BU_CD", fieldName: "BU_CD", editable: false, header: {text: '<spring:message code="lbl.bu" javaScriptEscape="true" />'},
						editor: {
		                    type: "dropDown",
		                    domainOnly: true,
		                }, 
		                values: gfn_getArrayExceptInDs(trnaslateMng.comCode.codeMap.BU_CD, "CODE_CD", ""),
		                labels: gfn_getArrayExceptInDs(trnaslateMng.comCode.codeMap.BU_CD, "CODE_NM", ""),
		                lookupDisplay: true,
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 150,
						mergeRule : { criteria: "value" }
					}, {
						name : "MEAS_CD", fieldName: "MEAS_CD", editable: false, header: {text: '<spring:message code="lbl.measure" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						values: gfn_getArrayExceptInDs(trnaslateMng.comCode.codeMap.BIZ_PLAN, "CODE_CD", ""),
		                labels: gfn_getArrayExceptInDs(trnaslateMng.comCode.codeMap.BIZ_PLAN, "CODE_NM", ""),
		                lookupDisplay: true,
						width : 150,
					}, {
						name : "M01", fieldName : "M01", header: {text: '<spring:message code="lbl.january" javaScriptEscape="true" />'},
						styles : {textAlignment: "far", background : gv_requiredColor, numberFormat : "#,##0"},
						dataType : "number",
						width : 100
					}, {
						name : "M02", fieldName : "M02", header : {text: '<spring:message code="lbl.february" javaScriptEscape="true" />'},
						styles : {textAlignment : "far", background : gv_requiredColor, numberFormat : "#,##0"},
						dataType : "number",
						width : 100
					}, {
						name : "M03", fieldName: "M03",  header: {text: '<spring:message code="lbl.march" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_requiredColor, numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "M04", fieldName : "M04", header: {text: '<spring:message code="lbl.april" javaScriptEscape="true" />'},
						styles : {textAlignment: "far",background:gv_requiredColor, numberFormat : "#,##0"},
						dataType : "number",
						width : 100
					}, {
						name : "M05", fieldName : "M05", header : {text: '<spring:message code="lbl.may" javaScriptEscape="true" />'},
						styles : {textAlignment : "far", background : gv_requiredColor, numberFormat : "#,##0"},
						dataType : "number",
						width : 100
					}, {
						name : "M06", fieldName: "M06",  header: {text: '<spring:message code="lbl.june" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_requiredColor, numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "M07", fieldName : "M07", header: {text: '<spring:message code="lbl.july" javaScriptEscape="true" />'},
						styles : {textAlignment: "far", background:gv_requiredColor, numberFormat : "#,##0"},
						dataType : "number",
						width : 100
					}, {
						name : "M08", fieldName : "M08", header : {text: '<spring:message code="lbl.august" javaScriptEscape="true" />'},
						styles : {textAlignment : "far", background : gv_requiredColor, numberFormat : "#,##0"},
						dataType : "number",
						width : 100
					}, {
						name : "M09", fieldName: "M09",  header: {text: '<spring:message code="lbl.september" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_requiredColor, numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "M10", fieldName: "M10",  header: {text: '<spring:message code="lbl.october" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_requiredColor, numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "M11", fieldName: "M11",  header: {text: '<spring:message code="lbl.november" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_requiredColor, numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "M12", fieldName: "M12",  header: {text: '<spring:message code="lbl.december" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_requiredColor, numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}
				];
				
				//[""] hidden 할 컬럼 넣는다.
				this.setFields(columns, ["BU_CD", "MEAS_CD"]);
				
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols, hiddenCols) {
				
				var fields = new Array();
				
				$.each(cols, function(i, v) {
					fields.push({fieldName : v.fieldName, dataType : v.dataType});							
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
					//checkBar: { visible : true },
					stateBar: { visible : true },
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
				
				this.grdMain.setPasteOptions({
					applyNumberFormat: false,
					checkDomainOnly: false,
					checkReadOnly: false,
					commitEdit: true,
					enableAppend: false,
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
			},
			
			gridEvents : function() {
				/* this.grdMain.onEditRowChanged = function(grid, itemIndex, dataRow, field, oldValue, newValue) {
					var flag = isNaN(newValue);
					
					if (newValue == undefined || newValue == null || newValue == "" || newValue == 'undefined' || newValue == "NaN" || flag){
						newValue = 0;
						trnaslateMng.transGrid.dataProvider.setValue(dataRow, field, newValue);
					}
				}; */
			},
		},
	
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnSave").on('click', function (e) {
				trnaslateMng.save();
			});

			$("#btnReset").on('click', function (e) {
				trnaslateMng.transGrid.grdMain.cancel();
				trnaslateMng.transGrid.dataProvider.rollback(trnaslateMng.transGrid.dataProvider.getSavePoints()[0]);
			});
			
			$('#excelFile').on('change', function(){
				gfn_importGrid({noYn : "N", fieldFlag: "N", callback : excelUploadCallback});
			});
	  		
	    	$("#btnExcelDownload").click("on", function() {
	    		gfn_doExportExcel({fileNm : "${menuInfo.menuNm}", formYn : "Y", lookupDisplay : false, indicator : "hidden", conFirmFlag : false}); 
	    	});
	    	
	    	$("#btnExcelUpload").click("on", function(){
	    		
	    		var grdData = gfn_getGrdSavedataAll(trnaslateMng.transGrid.grdMain);
				var grdDataLen = grdData.length;
				var flag = true;
				
				if(grdDataLen == 0){
					flag = fn_apply();
				}
				
				if(flag != false){
					$("#excelFile").trigger("click");
		    		fn_getBucket();	
				}
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
					if(id == "divYear"){
						EXCEL_SEARCH_DATA += $("#year").val();
					}
				}
			});
		},
		
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{outDs : "resList", _siq : trnaslateMng._siq}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						trnaslateMng.transGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						trnaslateMng.transGrid.grdMain.cancel();
						trnaslateMng.transGrid.dataProvider.setRows(data.resList);
						trnaslateMng.transGrid.dataProvider.clearSavePoints();
						trnaslateMng.transGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(trnaslateMng.transGrid.dataProvider.getRowCount());
						
						trnaslateMng.transGrid.gridInstance.setFocusKeys();
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		save : function() {
			var grdData = gfn_getGrdSavedataAll(this.transGrid.grdMain);
			var grdDataLen = grdData.length;
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			var flagCnt = 0;
			
			for(var i = 0; i < grdDataLen; i++){
				
				var buCd = grdData[i].BU_CD;
				var measCd = grdData[i].MEAS_CD;
				var m01 = fnNvl(grdData[i].M01);
				var m02 = fnNvl(grdData[i].M02);
				var m03 = fnNvl(grdData[i].M03);
				var m04 = fnNvl(grdData[i].M04);
				var m05 = fnNvl(grdData[i].M05);
				var m06 = fnNvl(grdData[i].M06);
				var m07 = fnNvl(grdData[i].M07);
				var m08 = fnNvl(grdData[i].M08);
				var m09 = fnNvl(grdData[i].M09);
				var m10 = fnNvl(grdData[i].M10);
				var m11 = fnNvl(grdData[i].M11);
				var m12 = fnNvl(grdData[i].M12);
				
				if(m01){
					flagCnt++;
				}else if(m02){
					flagCnt++;
				}else if(m03){
					flagCnt++;
				}else if(m04){
					flagCnt++;
				}else if(m05){
					flagCnt++;
				}else if(m06){
					flagCnt++;
				}else if(m07){
					flagCnt++;
				}else if(m08){
					flagCnt++;
				}else if(m09){
					flagCnt++;
				}else if(m10){
					flagCnt++;
				}else if(m11){
					flagCnt++;
				}else if(m12){
					flagCnt++;
				}
				
				if(flagCnt > 0){
					alert((i + 1) + " " + '<spring:message code="msg.lineMsg" javaScriptEscape="true" />');
					return;
				}
				
				if(buCd != "CL" && buCd != "CR" && buCd != "LP"){
					alert('<spring:message code="msg.excelBu" javaScriptEscape="true" />')
					trnaslateMng.transGrid.grdMain.cancel();
					trnaslateMng.transGrid.dataProvider.rollback(trnaslateMng.transGrid.dataProvider.getSavePoints()[0]);
					return;
				}
				
				if(measCd != "AMT" && measCd != "PROFIT"){
					alert('<spring:message code="msg.excelMeasure" javaScriptEscape="true" />')
					trnaslateMng.transGrid.grdMain.cancel();
					trnaslateMng.transGrid.dataProvider.rollback(trnaslateMng.transGrid.dataProvider.getSavePoints()[0]);
					return;
				}
			}
			
			
			var dt = new Date();
			var year = dt.getFullYear();
			var month = addZero(dt.getMonth() + 1);
			var ym = year + month;
			var bucketLen = BUCKET.query.length;
			var firstChk = 0;
			
			for(var i = 0; i < bucketLen; i++){
				var pCd = BUCKET.query[i].CD;
				var pBucketVal = BUCKET.query[i].BUCKET_VAL;
				
				pCd = "M" + pCd.substring(5, 7);
				BUCKET.query[i].CD_SUB = pCd;
				
				if(pBucketVal >= ym){
					if(firstChk == 0){
						BUCKET.query[i].INSERT_YN = "YY";	
					}else{
						BUCKET.query[i].INSERT_YN = "Y";
					}
					firstChk++;
				}else{
					BUCKET.query[i].INSERT_YN = "N";
				}
			}
			
			if(firstChk == 0){
				alert('<spring:message code="msg.beforeSave"/>');
			}else{
				confirm('<spring:message code="msg.beforeSaveConfirm"/>', function() {  // 저장하시겠습니까?
						
		    		FORM_SAVE = {}; //초기화
		    		FORM_SAVE.bucketList = BUCKET.query;
		    		FORM_SAVE._mtd = "saveAll";
		    		FORM_SAVE.tranData = [{outDs : "saveCnt", _siq : trnaslateMng._siq, grdData : grdData, mergeFlag : "Y"}];
		    		
			    	var sMap = {
			            url: GV_CONTEXT_PATH + "/biz/obj",
			            data: FORM_SAVE,
			            success:function(data) {
			            	alert('<spring:message code="msg.saveOk"/>');
				            fn_apply();
			            }
			        }
			        gfn_service(sMap, "obj");
		    	});
			}
			
		},
	};
	
	/********************************************************************************************************
	** 조회 
	********************************************************************************************************/
	function fn_apply(sqlFlag) {
		fn_getBucket();
		var paramYear = gfn_replaceAll($("#year").val(), "_", "");
		var paramYearLen = paramYear.length;
		
		if(paramYearLen != 4){
			alert('<spring:message code="msg.fourMst"/>');
			return false;
		}
		
		FORM_SEARCH     = $("#searchForm").serializeObject(); 
		FORM_SEARCH.sql = sqlFlag;
		
		trnaslateMng.search();
		trnaslateMng.excelSubSearch();
	}
	
	/********************************************************************************************************
	** 버켓정보 조회 
	********************************************************************************************************/
    function fn_getBucket() {
		var paramYear = $("#year").val();
    	var ajaxMap = {
       		fromDate: paramYear + "0101",
       		toDate  : paramYear + "1231",
       		month   : {isDown: "N", isUp:"N", upCal:"Q", isMt:"N", isExp:"N", expCnt:999},
       		sqlId : ["bucketMonth"]
    	}
    	gfn_getBucket(ajaxMap);
    }
	
	/****************************************************************************
	** 0을 붙여 두자리수로 만들어주는 함수 (날짜형식에 사용)
	*****************************************************************************/
	function addZero(target) {
		var num = Number(target);
	    var str = num > 9 ? num : "0" + num;
	    return str.toString();
	}
	
	function excelUploadCallback(){
		
	}
	
	function fn_checkClose() {
    	return gfn_getGrdSaveCount(trnaslateMng.transGrid.grdMain) == 0; 
    }
	
	function fnNvl(val){
		
		var flag = isNaN(val);
		var result = false;
		
		if (val == undefined || val == 'undefined' || val == "NaN" || flag){
			result = true;
		}
		return result;
	}

	/********************************************************************************************************
	** onload  
	********************************************************************************************************/
	$(document).ready(function() {
		trnaslateMng.init();
		
		var colsArray = ["M01", "M02", "M03", "M04", "M05", "M06", "M07", "M08", "M09", "M10", "M11", "M12"];
		gfn_pasteValueToLabel(trnaslateMng.transGrid.grdMain, trnaslateMng.transGrid.dataProvider, colsArray);
	});

	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp"%>
	
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%-- <%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%> --%>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divYear">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.year" /></div>
							<input type="text" id="year" name="year" class="ipt" maxlength="4"/>
						</div>
					</div>
				</div>
				<div class="bt_btn">
					<a href="#" class="fl_app" id="btnSearch"><spring:message code="lbl.search" /></a>
				</div>
			</div>
		</div>
		</form>
	</div>
	
	<div id="b" class="split split-horizontal">
		<!-- contents -->
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp"%>
			
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" class="realgrid1"></div>
			</div>
			<!-- 하단버튼 영역 -->
			<div class="cbt_btn roleWrite">
			
				<div class="bleft">
				<form id="excelForm" method="post" enctype="multipart/form-data">
					<input type="file" name="excelFile" id="excelFile" style="display:none;"/>
					<input type="hidden" name="columnNames" id="columnNames" />
					
				</form>
				<a href="javascript:void(null)" id="btnExcelDownload" class="app1"><spring:message code="lbl.excelDownload"/></a>
				<a href="javascript:void(null)" id="btnExcelUpload" class="app1"><spring:message code="lbl.excelUpload"/></a>
				</div>
				
				<div class="bright">
					<a id="btnReset" href="#" class="app1"><spring:message code="lbl.reset" /></a> 
					<a id="btnSave" href="#" class="app2"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
	</div>
	
</body>
</html>
