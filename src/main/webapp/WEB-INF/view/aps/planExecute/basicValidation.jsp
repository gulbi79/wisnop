<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">
	//filter 조건에 해당하는 PLAN_ID에 대해 엔진 CB_STATUS_CD가 Complete이 아닌 개수를 조회
	var VALIDATION_CHECK_SEARCH = {};
	var VALIDATION_CHECK_DAY_SEARCH ={};
	
	var enterSearchFlag = "Y";
	var basicValidation = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.basicValidationGrid.initGrid();
			this.events();
		},
			  
		_siq    : "aps.planExecute.basicValidationList",
		 
		initFilter : function() {
			    
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			gfn_setMsComboAll([
				{ target : 'divPlanId', id : 'planId', title : '<spring:message code="lbl.planId2"/>', data : this.comCode.codeMap.PLAN_ID, exData:[''], type : "S" },  
				{ target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart2"/>', data : this.comCode.codeMap.PROD_PART, exData:[""]},
				{ target : 'divDemandYn', id : 'demandYn', title : '<spring:message code="lbl.demandYn"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"},
				{ target : 'divProdOrderFormatYn', id : 'prodOrderFormatYn', title : '<spring:message code="lbl.prodOrderFormat"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"},
				{ target : 'divInvalidYn', id : 'invalidYn', title : '<spring:message code="lbl.invalidYn"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"},
				{ target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""]},
				{ target : 'divProcurType', id : 'procurType', title : '<spring:message code="lbl.procure"/>', data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{ target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"] },
				{ target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING, exData:["*"] }, 
			]);
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				
				var grpCd = "PROD_PART,FLAG_YN,ITEM_TYPE,PROCUR_TYPE";
				this.codeMap = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["ROUTING", "ITEM_GROUP"], null, {});
				this.codeMap.PROD_PART[0].CODE_NM = "";
				
				gfn_service({
					async   : false,
					url     : GV_CONTEXT_PATH + "/biz/obj.do",
					data    : {_mtd : "getList", tranData:[
						{outDs : "planList", _siq : "aps.planExecute.planIdBasic"},
					]},
					success : function(data) {
						basicValidation.comCode.codeMap.PLAN_ID = data.planList;
					}
				}, "obj"); 
			}
		},
	
		/* 
		* grid  선언
		*/
		basicValidationGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				
				this.grdMain.onShowHeaderTooltip = function (grid, column, value) {
					
					var result = value;
		    		var fname = gfn_nvl(column.fieldName, "");
		    		
		    		//기술개발
		    		if(fname == 'BOM_YN_NM' || fname == 'MAJOR_ROUTING_YN_NM' || fname == 'PROCESS_TIME_YN_NM' || fname == 'MOVE_TIME_YN_NM' || fname == 'TOTAL_PS_YN_NM' 
						|| fname == 'MAIN_PS_YN_NM' || fname == 'ROUTING_NO_NM' || fname == 'FIREWORK_JOB_MAPPING_YN_NM' || fname == 'PROD_GROUP_JOB_MAPPING_YN_NM' || fname == 'ANNEALING_PRE_JOB_YN_NM'){
		    			result = result + '<spring:message code="lbl.toolTip1"/>';
					}else if(fname == 'OS_PROCESS_TIME_YN_NM' || fname == 'OUT_LOT_SIZE_YN_NM' || fname == 'CAMPUS_PRIORITY_YN_NM' || fname == 'FIREWORK_AREA_YN_NM' || fname == 'FIREWORK_ROUTE_YN_NM' || fname == 'MIN_PUR_LT_YN_NM' || fname == 'ROUTING_PRIORITY_YN_NM' ||fname == 'COMM_PORTION_YN_NM'){//생산기획
						result = result + '<spring:message code="lbl.toolTip2"/>';
					}else if(fname == 'PROD_GROUP_YN_NM' || fname == 'WOKER_GROUP_YN_NM' || fname == 'RSC_MAP_DEG_YN_NM' || fname == 'RSC_MAP_DUP_YN_NM' || fname == 'WORKER_MAPPING_YN_NM' || fname == 'AVAIL_MAIN_WORKER_YN_NM'){//생산
						result = result + '<spring:message code="lbl.toolTip3"/>';
					}else if(fname == 'DEMAND_GRADE_YN_NM'){//영업
						result = result + '<spring:message code="lbl.toolTip4"/>';
					}else if(fname == 'FQC_ROUTING_YN_NM'){//품질
						result = result + '<spring:message code="lbl.toolTip5"/>';
					}
		    		
		    		return result;
				}	
			},
			
		},
	
		/*
		* event 정의
		*/
		events : function () {
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#validChk").click ("on", function() { fn_validChk(); });
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
						
					if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
					}else if(id == "divProdPart"){
						$.each($("#prodPart option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divDemandYn"){
						EXCEL_SEARCH_DATA += $("#demandYn option:selected").text();
					}else if(id == "divProdOrderFormatYn"){
						EXCEL_SEARCH_DATA += $("#prodOrderFormatYn option:selected").text();
					}else if(id == "divInvalidYn"){
						EXCEL_SEARCH_DATA += $("#invalidYn option:selected").text();
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
					}else if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
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
					
					if(data.resList.length == 1){
						data.resList = [];
					}
					
					if(FORM_SEARCH.sql == 'N'){
						
						basicValidation.basicValidationGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						basicValidation.basicValidationGrid.grdMain.cancel();
						
						basicValidation.basicValidationGrid.dataProvider.setRows(data.resList);
						basicValidation.basicValidationGrid.dataProvider.clearSavePoints();
						basicValidation.basicValidationGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_actionMonthSum(basicValidation.basicValidationGrid.gridInstance);
						gfn_setRowTotalFixed(basicValidation.basicValidationGrid.grdMain);
						
						basicValidation.gridCallback();
					}
				}
			}
			gfn_service(aOption, "obj");
		},
		
		gridCallback : function (){
			
			$.each(DIMENSION.user, function(i, val){
				
				var dimCd = val.DIM_CD;
				var dimCdNm = dimCd + "_NM";
				
				if(dimCd.indexOf("_YN") != -1 && dimCd != "CPFR_YN"){
					
					var editStyle = {};
					var val = gfn_getDynamicStyle(-2);
					editStyle.background = gv_headerColor;
					editStyle.editable = false;
					
					val.criteria.push("(values['"+ dimCdNm +"'] like '%N%')");
					val.styles.push(editStyle);

					basicValidation.basicValidationGrid.grdMain.setColumnProperty(basicValidation.basicValidationGrid.grdMain.columnByField(dimCdNm), "dynamicStyles", [val]); 
				}
			});
		}
	};
	
	function fn_setNumberFields(provider){
		
		var fileds = provider.getFields();
		var filedsLen = fileds.length;
		
		for (var i = 0; i < filedsLen; i++) {
			
			var fieldName = fileds[i].fieldName;
			
			//number 타입으로 변경
			if (fieldName == 'SALES_PRICE_KRW_NM' || fieldName == 'SS_QTY_NM' || fieldName == 'INVALID_CNT_NM' || fieldName == 'SP_QTY_NM' || fieldName == 'WIP_QTY_NM') {
				fileds[i].dataType = "number";
				basicValidation.basicValidationGrid.grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"});	
			}
			
			//헤더 컬럼 변경
			if(fieldName == 'BOM_YN_NM' || fieldName == 'MAJOR_ROUTING_YN_NM' || fieldName == 'PROCESS_TIME_YN_NM' || fieldName == 'MOVE_TIME_YN_NM' || fieldName == 'TOTAL_PS_YN_NM' 
				|| fieldName == 'MAIN_PS_YN_NM' || fieldName == 'ROUTING_NO_NM' || fieldName == 'FIREWORK_JOB_MAPPING_YN_NM' || fieldName == 'PROD_GROUP_JOB_MAPPING_YN_NM' || fieldName == 'ANNEALING_PRE_JOB_YN_NM'){
				
				var setHeader = basicValidation.basicValidationGrid.grdMain.getColumnProperty(fieldName, "header");
				setHeader.styles = {background: "#FFD8D8"};
				basicValidation.basicValidationGrid.grdMain.setColumnProperty(fieldName, "header", setHeader);
			}
			
			if(fieldName == 'OS_PROCESS_TIME_YN_NM' || fieldName == 'OUT_LOT_SIZE_YN_NM' || fieldName == 'CAMPUS_PRIORITY_YN_NM' || fieldName == 'FIREWORK_AREA_YN_NM' || fieldName == 'FIREWORK_ROUTE_YN_NM' || fieldName == 'MIN_PUR_LT_YN_NM' || fieldName == 'ROUTING_PRIORITY_YN_NM'||fieldName == 'COMM_PORTION_YN_NM'){
				var setHeader = basicValidation.basicValidationGrid.grdMain.getColumnProperty(fieldName, "header");
				setHeader.styles = {background: "#FAF4C0"};
				basicValidation.basicValidationGrid.grdMain.setColumnProperty(fieldName, "header", setHeader);
			}
			
			if(fieldName == 'PROD_GROUP_YN_NM' || fieldName == 'WOKER_GROUP_YN_NM' || fieldName == 'RSC_MAP_DEG_YN_NM' || fieldName == 'RSC_MAP_DUP_YN_NM' || fieldName == 'WORKER_MAPPING_YN_NM' || fieldName == 'AVAIL_MAIN_WORKER_YN_NM'){
				var setHeader = basicValidation.basicValidationGrid.grdMain.getColumnProperty(fieldName, "header");
				setHeader.styles = {background: "#D4F4FA"};
				basicValidation.basicValidationGrid.grdMain.setColumnProperty(fieldName, "header", setHeader);
			}
			
			if(fieldName == 'DEMAND_GRADE_YN_NM'){
				var setHeader = basicValidation.basicValidationGrid.grdMain.getColumnProperty(fieldName, "header");
				setHeader.styles = {background: "#E8D9FF"};
				basicValidation.basicValidationGrid.grdMain.setColumnProperty(fieldName, "header", setHeader);
			}
			
			if(fieldName == 'FQC_ROUTING_YN_NM'){
				var setHeader = basicValidation.basicValidationGrid.grdMain.getColumnProperty(fieldName, "header");
				setHeader.styles = {background: "#EAEAEA"};
				basicValidation.basicValidationGrid.grdMain.setColumnProperty(fieldName, "header", setHeader);
			}
			
		}
		provider.setFields(fileds);
	}

	//조회
	var fn_apply = function (sqlFlag) {
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		
    	if(!sqlFlag){
    		basicValidation.basicValidationGrid.gridInstance.setDraw();
    		fn_setNumberFields(basicValidation.basicValidationGrid.dataProvider);
		}
    	
		//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
    	//FORM_SEARCH.hiddenList = DIMENSION.hidden;
    	
		basicValidation.search();
		basicValidation.excelSubSearch();
	}
	
	
	
	
	
	
	// Validation Check 버튼이 실행될수 있는 조건
    
    //1.1 CB_STATUS_CD == C, Validation Check 가능시간 (수요일 XX:XX ~ 수요일 XX:XX을 제외한 모든 시간) 
    //1.2 CB_STATUS_CD == C, Validation Check 가능시간 (목요일 XX:XX ~ 목요일 XX:XX을 제외한 모든 시간)
    
    //1.1조건을 모두 만족할 경우 Validation Check 버튼 실행
    //1.2조건을 모두 만족할 경우 Validation Check 버튼 실행
async   function fn_validChk(){
		
		
		var date = new Date();
	    var dayoftheweek = date.getDay();
	    
		
		//planId_validationCheck 값이   1 이상일 경우, Validation Check 버튼 실행안됨
        var planId_validationCheck = await fn_validationChk();
		var validationDayResult = await fn_validationDayChk(getDay(dayoftheweek));
		
		
		//0(일요일), 1(월요일), 2(화요일), 3(수요일), 4(목요일), 5(금요일), 6(토요일)
		
		//planId_validationCheck 값이 0보다 클 경우: CB_STATUS_CD 값이 모두 C 일 경우
		if(planId_validationCheck == 0)
		{
			
			//코드관리:VALIDATION_CHECK_CD에 지정해 놓은 시간이 존재할 경우,
			if(validationDayResult.TIME_EXIST == 1)
			{
				
				var today = new Date();
				var year = today.getFullYear();
				var month = today.getMonth();
				var date = today.getDate();
				 
		        var dateStartFrom = new Date(year, month, date, validationDayResult.START_FROM.split(':')[0], validationDayResult.START_FROM.split(':')[1], 00);
				var dateEndTo     = new Date(year, month, date, validationDayResult.END_TO.split(':')[0], validationDayResult.END_TO.split(':')[1], 00);
				
				
				//현재시간이 코드관리:VALIDATION_CHECK_CD에 지정해 놓은 시간에 포함될 경우, Validation Check 버튼 실행되면 안됨
			    if(dateStartFrom <= today && today <= dateEndTo)
			    {
			    	alert(validationDayResult.START_FROM+' ~ '+validationDayResult.END_TO+'까지 Validation Check를 실행할 수 없습니다.');
			    }
			  //현재시간이 코드관리:VALIDATION_CHECK_CD에 지정해 놓은 시간에 포함되지 않을 경우 또는 PLAN_ID에 대한 엔진 상태 데이터가 없을 경우, Validation Check 버튼 실행
			    else
			    {
			    	 var data = [{call : "call"}];
	                 
	                 FORM_SAVE          = {}; //초기화  
	                 FORM_SAVE._mtd     = "saveUpdate";
	                 FORM_SAVE.tranData = [
	                     {outDs : "saveCnt", _siq : "aps.planExecute.validChk", grdData : data}
	                 ];
	                 gfn_service({
	                     url     : GV_CONTEXT_PATH + "/biz/obj.do",
	                     data    : FORM_SAVE,
	                     success : function(data) {
	                         alert('<spring:message code="msg.validMsg"/>');
	                         fn_apply(false);
	                     }
	                 }, "obj");
			    }
				
			}
			//코드관리:VALIDATION_CHECK_CD에 지정해 놓은 시간이 없거나, 관리자가  요일별 VALIDATION_CHECK_CD 마스터코드에 시간을 입력하지 않은 경우, Validation Check 버튼 실행
			else
			{
				 var data = [{call : "call"}];
                 
                 FORM_SAVE          = {}; //초기화  
                 FORM_SAVE._mtd     = "saveUpdate";
                 FORM_SAVE.tranData = [
                     {outDs : "saveCnt", _siq : "aps.planExecute.validChk", grdData : data}
                 ];
                 gfn_service({
                     url     : GV_CONTEXT_PATH + "/biz/obj.do",
                     data    : FORM_SAVE,
                     success : function(data) {
                         alert('<spring:message code="msg.validMsg"/>');
                         fn_apply(false);
                     }
                 }, "obj");
			}
				
		
		}
		//planId_validationCheck 값이 0보다 클 경우: CB_STATUS_CD 값이 모두 C가 아닌 경우 
		else
		{
			
			alert('Validation Check 실행조건을 만족하지 않습니다.CB_STATUS_CD 값이 모두 Complete가 아닙니다.');
		}
		
				
		
		
	}
	
	
	
	//filter 조건에 해당하는 PLAN_ID에 대해 엔진 CB_STATUS_CD가 Complete이 아닌 개수를 조회
	function fn_validationChk(){
		
		VALIDATION_CHECK_SEARCH = {};
		
		VALIDATION_CHECK_SEARCH.planId = $('#planId').val();
		VALIDATION_CHECK_SEARCH.sql = 'N';
		VALIDATION_CHECK_SEARCH._mtd     = "getList";
		VALIDATION_CHECK_SEARCH.tranData = [{outDs:"rtnList",_siq:"aps.planExecute.validationChk"}];
		
	    return new Promise(function(resolve,reject){    
	    	
	    	gfn_service({
	            
	            
	            url    : GV_CONTEXT_PATH + "/biz/obj.do",
	            data   : VALIDATION_CHECK_SEARCH,
	            success: function(data) {
	            	
	            	if(data.rtnList.length > 0)
                    {
	            		   VALIDATION_CHECK_SEARCH.QTY_IN_P_R_E_S = data.rtnList[0].QTY_IN_P_R_E_S          
	                       resolve(VALIDATION_CHECK_SEARCH.QTY_IN_P_R_E_S);	
                    }
	            	else
	            	{
	            		//해당 planId에 대한 엔진데이터가 없을 경우, 0 으로 처리하여 validation check 버튼 실행되게 처리
	            	     VALIDATION_CHECK_SEARCH.QTY_IN_P_R_E_S = 0;          
	                     resolve(VALIDATION_CHECK_SEARCH.QTY_IN_P_R_E_S);
	            	}
		           
	                           
	            }  
	            
	        }, "obj")
	     });
	          

		
		
	}
	
	function fn_validationDayChk(day){
		
		
		VALIDATION_CHECK_DAY_SEARCH = {};
		
		VALIDATION_CHECK_DAY_SEARCH.day = day;
		VALIDATION_CHECK_DAY_SEARCH.sql = 'N';
		VALIDATION_CHECK_DAY_SEARCH._mtd  = "getList";
		VALIDATION_CHECK_DAY_SEARCH.tranData = [{outDs:"rtnList",_siq:"aps.planExecute.validationTime"}];
		
	    return new Promise(function(resolve,reject){    
            
            gfn_service({
                
                
                url    : GV_CONTEXT_PATH + "/biz/obj.do",
                data   : VALIDATION_CHECK_DAY_SEARCH,
                success: function(data) {
                	
                	if(data.rtnList.length > 0)
                	{
                		if(data.rtnList[0] == null)
                		{
                            VALIDATION_CHECK_DAY_SEARCH.TIME_EXIST = 0;
                            resolve(VALIDATION_CHECK_DAY_SEARCH);                  			
                		}
                		else
                		{
                            VALIDATION_CHECK_DAY_SEARCH.TIME_EXIST = 1;
                            VALIDATION_CHECK_DAY_SEARCH.START_FROM = data.rtnList[0].START_FROM
                            VALIDATION_CHECK_DAY_SEARCH.END_TO     = data.rtnList[0].END_TO
                            

                            resolve(VALIDATION_CHECK_DAY_SEARCH);                			
                		}

                            
                	}
                	else
                	{
                			
                		VALIDATION_CHECK_DAY_SEARCH.TIME_EXIST = 0;
                        resolve(VALIDATION_CHECK_DAY_SEARCH);
                            
                	}
	                     
                }  
                
            }, "obj")
         });
	
	}
	
	
	$(document).ready(function() {
		basicValidation.init();
	});
	

    function getDay(idx) {
    
        var day = "";
      
        switch (idx) {
        
            case 0:
                day = "SUN";
            break;
            case 1: 
            	day = "MON";
            break;
            case 2: 
            	day = "TUE";
            break;
            case 3: 
            	day = "WED";
            break;
            case 4: 
            	day = "THU";
            break;
            case 5: 
            	day = "FRI";
            break;
            case 6: 
            	day = "SAT";
            break;
        }
            
        return day;
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
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divPlanId"></div>
					<div class="view_combo" id="divProdPart"></div>
					<div class="view_combo" id="divDemandYn"></div>
					<div class="view_combo" id="divProdOrderFormatYn"></div>
					<div class="view_combo" id="divInvalidYn"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divItem"></div>
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
					<a href="javascript:;" id="validChk" class="app1 roleWrite"><spring:message code="lbl.validChk" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
