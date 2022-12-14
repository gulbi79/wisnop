<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>

	<script type="text/javascript">
	var periodNumPlus = 455; //  SCM > 운영 KPI > 출하 계획 준수율 XML QUERY에서 LIMIT 초과하지 않는 최대 일수 65주(455일)
	var enterSearchFlag = "Y";
	var datePickerOption;
	var maxLimitToWeek;
	var maxLimitToPWeek;
	var maxLimitToDate;
	var salesPlanCm = {

		init : function () {
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.salesGrid.initGrid();
		},
			
		_siq    : "snop.oprtKpi.salesPalnCmplRt",
		
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
				{ target : 'divProcurType',   id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{ target : 'divUpItemGroup',  id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent },
				{ target : 'divItemGroup'   , id : 'itemGroup'    , title : '<spring:message code="lbl.itemGroup"/>'    , data : this.comCode.codeMapEx.ITEM_GROUP,     exData:["*"] },
				{ target : 'divRoute'       , id : 'route'        , title : '<spring:message code="lbl.routing"/>'      , data : this.comCode.codeMapEx.ROUTING,        exData:["*"] },
				{ target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"] },
				{ target : 'divCustGroup'   , id : 'custGroup'    , title : '<spring:message code="lbl.custGroup"/>'    , data : this.comCode.codeMapEx.CUST_GROUP,     exData:["*"] },
				{ target : 'divAmtQty'      , id : 'rdoAqType'    , title : '<spring:message code="lbl.quantityAmountPart"/>'     , data : this.comCode.codeMap.SALE_QA_TYPE, exData:[""], type : "R"},
				{ target : 'divCutOff'      , id : 'cutOff'       , title : '<spring:message code="lbl.cutOff"/>'     , data : this.comCode.codeMap.CUT_OFF_CD, exData:[""], type : "R"},
				{ target : 'divCpfrCd'      , id : 'cpfrCd'       , title : '<spring:message code="lbl.cpfrYn"/>'     , data : this.comCode.codeMap.CUT_OFF_CD, exData:[""], type : "R"},
				{ target : 'divInvCd'       , id : 'invCd'        , title : '<spring:message code="lbl.invCd"/>'     , data : this.comCode.codeMap.CUT_OFF_CD, exData:[""], type : "R"},
			]);
			
			$(':radio[name=rdoCsType]:input[value="A"]')  .attr("checked", true);
			$(':radio[name=rdoAqType]:input[value="AMT"]').attr("checked", true);
			$(':radio[name=cutOff]:input[value="Y"]').attr("checked", true);
			$(':radio[name=cpfrCd]:input[value="Y"]').attr("checked", true);
			$(':radio[name=invCd]:input[value="Y"]').attr("checked", true);
			// 달력
			datePickerOption = DATEPICKET(null,-65, -1);
			
			maxLimitToWeek = $('#toWeek').val();
			maxLimitToPWeek = $('#toPWeek').val();
			maxLimitToDate  = $('#toCal').val();
			
			$('#fromCal').datepicker("option", "minDate", "2019-01-01");
			$('#toCal').datepicker("option", "maxDate", new Date().getWeekDay(-1, false));
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap   : null,
			codeMapEx : null,
			
			initCode  : function () {
				var grpCd    = 'SALE_QA_TYPE,PROCUR_TYPE,CUT_OFF_CD';
				this.codeMap = gfn_getComCode(grpCd); //공통코드 조회

				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "ITEM_GROUP", "ROUTING", "UPPER_ITEM_GROUP"], null, {itemType : "10,50"});
			}
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
				
				gfn_setMonthSum(salesPlanCm.salesGrid.gridInstance, false, false, true);
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			//달력 이벤트
	        $("#fromCal").change("on", function(event) {
	        	event.preventDefault();
	            //$(this).val($("#swFromDate").val());
	            var tmpV = gfn_getFindDataDsInDs(datePickerOption.arrTarget, {calId : {VALUE : "fromCal", CONDI : "="}});
	            
	            gfn_onSelectFn_customized(tmpV[0], $(this).val());
	            
	            setDayDate(tmpV[0].calId, periodNumPlus);
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
					if(id == "divItem"){
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
					}else if(id == "divAmtQty"){
						
						var qtyAmt = $('input[name="rdoAqType"]:checked').val();
						
						if(qtyAmt == "QTY"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.qty"/>';
						}else if(qtyAmt == "AMT"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.amt"/>';
						}
					}else if(id == "divCutOff"){
						EXCEL_SEARCH_DATA += $('input[name="cutOff"]:checked').val();
					}else if(id == "divCpfrCd"){
						EXCEL_SEARCH_DATA += $('input[name="cpfrCd"]:checked').val();
					}else if(id == "divInvCd"){
						EXCEL_SEARCH_DATA += $('input[name="invCd"]:checked').val();
					}
				}
			});
			
			var weekType = $('input[name="vhWeekType"]:checked').val();
			
			if(weekType == "SW"){
				EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.stdWeek" /> ' +'<spring:message code="lbl.period"/>' + " : ";
				EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ") ~ ";
				EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toWeek").val() + ")";
			}else if(weekType == "PW"){
				EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.partialWeek" /> ' + '<spring:message code="lbl.period"/>' + " : ";
				EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromPWeek").val() + ") ~ ";
				EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toPWeek").val() + ")";	
			}
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
						salesPlanCm.salesGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						salesPlanCm.salesGrid.grdMain.cancel();
						
						salesPlanCm.salesGrid.dataProvider.setRows(data.resList);
						salesPlanCm.salesGrid.dataProvider.clearSavePoints();
						salesPlanCm.salesGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_actionMonthSum(salesPlanCm.salesGrid.gridInstance);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			var ajaxMap = {
				fromDate : gfn_replaceAll($("#fromCal").val(),"-",""),
				toDate   : gfn_replaceAll($("#toCal").val(),"-",""),
				vhWeekType : $(':radio[name=vhWeekType]:checked').val(),
				sqlId    : ["snop.oprtKpi.bucketWeekProd"]
			}
			gfn_getBucket(ajaxMap);
			
			subBucket = [
				{CD : "INV",  NM : '<spring:message code="lbl.avaiableInventory"/>' },
				{CD : "PLAN",  NM : '<spring:message code="lbl.salesPlan"/>' },
				{CD : "RES",   NM : '<spring:message code="lbl.salesPerform"/>' },
				{CD : "RATE",  NM : '<spring:message code="lbl.cmplRate"/>' } 
			];
			gfn_setCustBucket(subBucket);

			if (!sqlFlag) {
				
				for (var i in DIMENSION.user) {
					if (DIMENSION.user[i].DIM_CD.indexOf("SALES_PRICE_KRW") > -1) {
						DIMENSION.user[i].numberFormat = "#,##0";
					}
				}
				
				salesPlanCm.salesGrid.gridInstance.setDraw();
				
				var fileds = salesPlanCm.salesGrid.dataProvider.getFields();
				
				for (var i in fileds) {
					if (fileds[i].fieldName.indexOf("SALES_PRICE_KRW") > -1) {
						fileds[i].dataType = "number";
					}
				}
				salesPlanCm.salesGrid.dataProvider.setFields(fileds);
				
				$.grep(BUCKET.query, function(v, n) {
					
					var rootVal = v.ROOT_CD;
					var val = v.CD;
					
					if(rootVal.indexOf("WM") > -1){
						
						var setHeader = salesPlanCm.salesGrid.grdMain.getColumnProperty(rootVal, "header");
						setHeader.styles = {background: gv_headerColor};
						salesPlanCm.salesGrid.grdMain.setColumnProperty(rootVal, "header", setHeader);
					}
					
					if(val.indexOf("WM") > -1){
						
						var setHeader = salesPlanCm.salesGrid.grdMain.getColumnProperty(val, "header");
						setHeader.styles = {background: gv_headerColor};
						salesPlanCm.salesGrid.grdMain.setColumnProperty(val, "header", setHeader);
						salesPlanCm.salesGrid.grdMain.setColumnProperty(val, "styles", {"background" : gv_headerColor});
						
						if(val.indexOf("_INV") != -1){
							salesPlanCm.salesGrid.grdMain.setColumnProperty(val, "visible", false);
						}
					}
				}); 
			}
		}
	};
	

	//조회
	var fn_apply = function (sqlFlag) {

		// 디멘젼, 메져
		gfn_getMenuInit();
		
		salesPlanCm.getBucket(sqlFlag); //2. 버켓정보 조회
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
   		var vhT = FORM_SEARCH.vhWeekType;
   		if(vhT == "PW"){
   			
   			var resultFrom = "";
			var resultTo = "";
			var tmpFromPweek = $("#fromPWeek").val();   				
			var tmptoPweek = $("#toPWeek").val();
			
			if(tmpFromPweek.indexOf("A") != -1){
				resultFrom = "A";
			}else if(tmpFromPweek.indexOf("B") != -1){ 
				resultFrom = "B";
			}else{
				resultFrom = "C";
			}
			
			if(tmptoPweek.indexOf("A") != -1){
				resultTo = "A";
			}else if(tmptoPweek.indexOf("B") != -1){ 
				resultTo = "B";
			}else{
				resultTo = "C";
			}
			
			FORM_SEARCH.resultFrom = resultFrom;
			FORM_SEARCH.resultTo = resultTo;
			
   		}
		
		salesPlanCm.search();
		salesPlanCm.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		salesPlanCm.init();
	});
	
	function gfn_onSelectFn_customized(params,selected) {
	    var tmpSelDate = gfn_getDate(selected);
	    		
	    //week 처리

		if(params.calId == "fromCal")
		{
			if (!gfn_isNull(params.weekId))
            {
			    $("#"+params.weekId).val(tmpSelDate.YEARWEEK);
            }
            
            if (!gfn_isNull(params.weekPId))
            {
                $("#"+params.weekPId).val(tmpSelDate.YEARPWEEK);
            }
            
            if (!gfn_isNull(params.dayNm))
            {
                $("#"+params.dayNm).val(tmpSelDate.DAY_NM);
            }
		}
	    //toCal
		else
		{
			if (!gfn_isNull(params.weekId))
            {   
				
				if(parseInt(tmpSelDate.YEARWEEK) > parseInt(maxLimitToWeek))
				{
					$("#"+params.weekId).val(maxLimitToWeek);
				}
				else
				{
					$("#"+params.weekId).val(tmpSelDate.YEARWEEK);	
				}
				
            }
            
            if (!gfn_isNull(params.weekPId))
            {
            	if(parseInt(tmpSelDate.YEARPWEEK.replace(/A/g,"").replace(/B/g,"")) > parseInt(maxLimitToPWeek.replace(/A/g,"").replace(/B/g,""))  )
            	{
            		$("#"+params.weekPId).val(maxLimitToPWeek);
            	}
            	else
            	{
            		$("#"+params.weekPId).val(tmpSelDate.YEARPWEEK);	
            	}
                
            }
            
            if (!gfn_isNull(params.dayNm))
            {
                $("#"+params.dayNm).val(tmpSelDate.DAY_NM);
            }
		}
	       
	    
	    gfn_setVhSEDate_customized(params,tmpSelDate);
	    
	 
	}
	
	function gfn_setVhSEDate_customized(params,tmpSelDate) {
	    if (params.calId == "fromCal") {
	        $.each($("#fromCal").siblings(), function(n,v) {
	            if (v.id == "swFromDate") {
	                $(v).val(tmpSelDate.SW_START_DATE);
	            } else if (v.id == "pwFromDate") {
	                $(v).val(tmpSelDate.PW_START_DATE);
	            } else if (v.id == "swToDate") {
	                $(v).val(tmpSelDate.SW_END_DATE);
	            }
	        });
	      
	    } else if (params.calId == "toCal") {
	        $.each($("#toCal").siblings(), function(n,v) {
	            if (v.id == "swToDate") {
	                $(v).val(tmpSelDate.SW_END_DATE);
	            } else if (v.id == "pwToDate") {
	                $(v).val(tmpSelDate.PW_END_DATE);
	            } 
	        });
	        
	        if(parseInt(tmpSelDate.SW_END_DATE) > parseInt(maxLimitToDate.replace(/-/g,"")))
            {
	        	$("#toCal").val(maxLimitToDate);
	        	$("#toCal").datepicker("option","maxDate",maxLimitToDate);
            }
	        else
	        {
	        	$("#toCal").val(tmpSelDate.SW_END_DATE);
	        	$("#toCal").datepicker("option","maxDate",to_date(tmpSelDate.SW_END_DATE));
	        }
	        
	        
	        
	      
	    }
	}
	
	
    function setDayDate(calId, val){
        
        var calIdData = $("#" + calId).val();
        var paramVal = gfn_replaceAll(calIdData, "-", "");
        var dateVal = paramVal.substring(0, 4) + "/" + paramVal.substring(4, 6) + "/" + paramVal.substring(6, 8);
        
        var date = new Date(dateVal);
        
        date.setDate(date.getDate() + Number(val));
        
        var year = date.getFullYear();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        
        if(month < 10){
            month = "0" + month;
        }
        
        if(day < 10){
            day = "0" + day;
        }
        
        var resultData = year + "-" + month + "-" + day;
        
        if(calId == "fromCal"){
            //$("#fromCal").datepicker("option", "minDate", calIdData);
            //$("#toCal").datepicker("option", "maxDate", resultData);
            
            //처음로딩시나, Measure 선택후 올경우 toWeek이 변경이 되지 않아 로직 추가
            //if($("#swToDate").val() >= resultData.split("-").join("")){
                var tmpV = gfn_getFindDataDsInDs(datePickerOption.arrTarget, {calId : {VALUE : "toCal", CONDI : "="}});
                
                gfn_onSelectFn_customized(tmpV[0], resultData);
            //}
        }
        /*
        else if(calId == "toCal"){
            $("#fromCal").datepicker("option", "minDate", resultData);
            $("#toCal").datepicker("option", "maxDate", calIdData);
        }
        */
    }
	
    function to_date(date_str)
    {
        var yyyyMMdd = String(date_str);
        var sYear = yyyyMMdd.substring(0,4);
        var sMonth = yyyyMMdd.substring(4,6);
        var sDate = yyyyMMdd.substring(6,8);

        return new Date(Number(sYear), Number(sMonth)-1, Number(sDate));
    }
    
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<input type="hidden" id="itemType" name="itemType" value="10,50"/>
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divCustGroup"></div>
					<div class="view_combo" id="divAmtQty"></div>
					<div class="view_combo" id="divCutOff"></div>
					<div class="view_combo" id="divCpfrCd"></div>
					<div class="view_combo" id="divInvCd"></div>
					<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
						<jsp:param name="radioYn" value="Y"/>
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
		</div>
    </div>
</body>
</html>
