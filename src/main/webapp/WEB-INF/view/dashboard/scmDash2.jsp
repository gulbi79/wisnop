<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="chartYn" value="Y"/>
</jsp:include>
	
	<style type="text/css">
	#container { margin: 0;width: calc(100% - 250px);height: 100%;padding: 0; }
	#cont_chart { width: 100%;height: 100%;}
	
	
	#cont_chart .col_3 { margin:0; width:calc((100% - 4px) / 3) ; height:calc((100% - 4px) / 3); position:relative;}
	
	#cont_chart .col_3:nth-child(1) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(2) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(3) {margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(4) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(5) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(6) {margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(7) {margin:0 2px 0 0;}
	#cont_chart .col_3:nth-child(8) {margin:0 2px 0 0;}
	
	#cont_chart .col_3 > .titleContainer{
	
	}
	
	#cont_chart .col_3 > .titleContainer > .action {
    
      position: absolute;
      top: 5px;
      right: 5px;
      width: 30px;
      height: 30px;
      background: #fff;
      border-radius: 50%;
      cursor: pointer;
      box-shadow: 0 5px 5px rgba(0,0,0,0.1);
      z-index:999;
   }
    
    #cont_chart .col_3 > .titleContainer > .action span {
      
      position: absolute;
      width: 100%;
      height: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
      color: #1f5bb6;
      font-size: 2em;
      transition: .3s ease-in-out;
        
    }
    
    #cont_chart .col_3 > .titleContainer > .action.active span  {
  
     transform: rotate(-135deg);
     position: absolute;
    }
    
    
    #cont_chart .col_3 > .titleContainer > .action ul {
    
      position: relative;
      top: 0px;
      right:33px;
      background: #fff;
      width: 85px;
      height:140px;
      padding: 10px;
      border-radius: 20px;
      opacity: 0;
      visibility: hidden;
      transition: .3s;
      z-index:999;
      display:block;
      box-shadow: 0 5px 5px rgba(0,0,0,0.1);
    }
    
    #cont_chart .col_3 > .titleContainer > .action.active ul {
    
      top: 5px;
      right:33px;
      opacity: 1;
      visibility: visible;
      transition: .3s;
      background: white;
      z-index:999;
      display:block;
      box-shadow: 0 5px 5px rgba(0,0,0,0.1);
    }
    
    
    
    
    
    #cont_chart .col_3 > .titleContainer > .action ul > li {
    
      list-style:none;
       text-decoration: none;
      display: block;
      justify-content: flex-start;
      align-items: center;
      padding: 0;
      position:relative;
    }
    
    #cont_chart .col_3 > .titleContainer > .action ul > li.manuel {
    
      display: block;
    }
    
    
    #cont_chart .col_3 > .titleContainer > .action ul > li:hover {
    
     font-weight: 600;
    
    }
    
    #cont_chart .col_3 > .titleContainer > .action ul > li:not(:last-child) {
    
    /* 
     border-bottom: 1px solid rgba(0,0,0,0.1);
    */
    }
    
    #cont_chart .col_3 > .titleContainer > h4
    {
           display:inline-block;
           
    }

/*
    #cont_chart .col_3 > .rdoContainer
    {
        display:block;
    }
*/

    #cont_chart .col_3 > .titleContainer > div
    {
        float:right;
    }
	
	
	#cont_chart3 {
		height: 100%;
	    width: 240px;
	    float: left;
	    margin-left: 10px;
	}
	
	#cont_chart .col_3 > .modal
    {
        height: 100%;
        left: 0;
        position: relative;
        top: 0;
        width: 100%;
        display:flex;
        flex-direction:column;
        overflow:auto;
        
    }
    
    #cont_chart .col_3 > .modal_header
    {
        height:25px;
        
    }
    
    #cont_chart .col_3 > .modal_content
    {
       
        height:auto;
        overflow-y:scroll;
        padding: 10px 15px 10px 15px;
        flex:1;
        display:flex;
        flex-direction:column
        
    }
	
	
	</style>
	
	<script type="text/javascript">
	var quill_1,quill_2,quill_3,quill_4,quill_5,quill_6,quill_7,quill_8,quill_9;
	var pastFlag = "Y";
	var materialChart,materialsRateChart,chart3List,basicReqChart;
	var userLang = "${sessionScope.GV_LANG}";
	var unit = 0;
	var unit2 = 0;
	var format = "y:,.0f";
	var roundNum = 0;
	var bucket;
	
    $(function() {
    	
    	gfn_formLoad(); //공통 폼 초기 정보 설정
    	fn_siteMap();
    	fn_init();
    	fn_initEvent();
    	//fn_apply();
    });
    
    function fn_init() {
    	fn_quilljsInit();
    	var selectDate = "";
    	var cDate = gfn_getCurrentDate();
    	var pDate = gfn_getAddDate(cDate.YYYYMMDD, -7);
    	var nDate = gfn_getAddDate(cDate.YYYYMMDD, 7);
    	var dayNm = cDate.DAY_NM;
    	cWeek = "W" + cDate.WEEKOFYEAR;
    	pWeek = "W" + pDate.WEEKOFYEAR;
    	nWeek = "W" + nDate.WEEKOFYEAR;
    	
    	if(dayNm == "MON" || dayNm == "TUE" || dayNm == "WED" || dayNm == "SUN"){//일월화수
    		selectDate = pWeek;
    	}else{
    		selectDate = cWeek;
    		pastFlag = "N";
    	} 
    	
    	$.each($(".cweekTxt"), function(n,v) {
    		$(v).text(' ('+cWeek+')');
    	});

    	$.each($(".pweekTxt"), function(n,v) {
    		$(v).text(' ('+pWeek+')');
    	});
    	
    	$.each($(".selectWeekTxt"), function(n,v) {
    		$(v).text(' ('+selectDate+')');
    	});
    	
    	FORM_SEARCH = {}
		FORM_SEARCH._mtd = "getList";
		FORM_SEARCH.tranData = [{ outDs : "month" , _siq : "dashboard.scmDash.trendBucketMonth" }
							  , { outDs : "apsStartWeek" , _siq : "dashboard.scmDash.trendWeek" }
							  , { outDs : "chartList" , _siq : "dashboard.chartInfo.scmDash2" }
		];
		var sMap = {
			url	 : "${ctx}/biz/obj.do",
			data	: FORM_SEARCH,
			success : function(data) {
				
				bucket = {};
				bucket.month = data.month;
				bucket.apsStartWeek = data.apsStartWeek[0];
				FORM_SEARCH.chartList = data.chartList;
				fn_chartContentInit();
				fn_apply();
			}
		}
		gfn_service(sMap, "obj");
		
    }
    
    function fn_initEvent() {
    	
		//		자재 가용룰				scmDash222 
		$(':radio[name=weekMaterialsAvail]').on('change', function () {
			materialChartSearch(false);
		});
		
		// 		자재입고 준수율 			scmDash222 
		$(':radio[name=materialRate]').on('change', function () {
			materialRateChartSearch(false);
		});
		
    	var arrTitle = $("h4");
    	$.each(arrTitle, function(n,v) {
    		$(v).css("cursor", "pointer");
    		$(v).on("click", function() { 
    			if (n == 0) gfn_newTab("SNOP305");        // 자재 가용률
    			else if (n == 1) gfn_newTab("MP209");   // 자재입고 준수율 
    			else if (n == 2) gfn_newTab("SNOP205"); // 자재 재고
    			else if (n == 3) gfn_newTab("SNOP301"); // 출하 준수율
    			else if (n == 4) gfn_newTab("SNOP302");	// 출하 적중률
    			else if (n == 5) gfn_newTab("SNOP303");	// 출하 달성률
    			else if (n == 6) gfn_newTab("APS308");	// 기준정보 등록률
    			else if (n == 7) gfn_newTab("DP219");	// CPFR 출하 현황
    			else if (n == 8) gfn_newTab("SNOP207");	// 평균 출하단가
    		
    		});
    	});
    	
        $('.titleContainer > .action').hover(function(){
            
            var chartId = this.id;
            
            
            if(chartId == 'materialAvailabilityScmAction')
            {
            	materialAvailabilityScmActionToggle();
                
            }
            
            else if(chartId == 'materialReceiptComplianceRateAction')
            {
            	materialReceiptComplianceRateActionToggle();  
            
            }
            
            
            
            
        });
    	
        
        $(".manuel > a").dblclick("on", function() {
            
            var chartId  = this.id;
            
            fn_popUpAuthorityHasOrNot();
            
            var isSCMTeam = SCM_SEARCH.isSCMTeam;
            
            if(isSCMTeam>=1)
            {
            	//자재 가용률
            	if(chartId == "materialAvailabilityScm")
            	{
            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
                        rootUrl   : "dashboard",
                        url       : "dashBoardChartInfoPopup",
                        width     : 600,
                        height    : 600,
                        chartId   : chartId,
                        title     : "Dashboard Chart Info"
                    });
            	}
            	//자재입고 준수율
            	else if(chartId == "materialReceiptComplianceRate")
                {
            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
                        rootUrl   : "dashboard",
                        url       : "dashBoardChartInfoPopup",
                        width     : 600,
                        height    : 600,
                        chartId   : chartId,
                        title     : "Dashboard Chart Info"
                    });
                }
            	//자재 재고
            	else if(chartId == "materialStockScm")
                {
            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
                        rootUrl   : "dashboard",
                        url       : "dashBoardChartInfoPopup",
                        width     : 600,
                        height    : 600,
                        chartId   : chartId,
                        title     : "Dashboard Chart Info"
                    });
                }
            	//출하 준수율
            	else if(chartId == "shipmentComplianceRateScm")
                {
            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
                        rootUrl   : "dashboard",
                        url       : "dashBoardChartInfoPopup",
                        width     : 600,
                        height    : 600,
                        chartId   : chartId,
                        title     : "Dashboard Chart Info"
                    });
                }
            	//출하 적중률
            	else if(chartId == "shipmentHitRateScm")
                {
            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
                        rootUrl   : "dashboard",
                        url       : "dashBoardChartInfoPopup",
                        width     : 600,
                        height    : 600,
                        chartId   : chartId,
                        title     : "Dashboard Chart Info"
                    });
                }
            	//출하 달성률
            	else if(chartId == "shipmentAchievementRateScm")
                {
            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
                        rootUrl   : "dashboard",
                        url       : "dashBoardChartInfoPopup",
                        width     : 600,
                        height    : 600,
                        chartId   : chartId,
                        title     : "Dashboard Chart Info"
                    });
                }
            	//기준정보 등록률
            	else if(chartId == "standardInformationRegistrationRate")
                {
            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
                        rootUrl   : "dashboard",
                        url       : "dashBoardChartInfoPopup",
                        width     : 600,
                        height    : 600,
                        chartId   : chartId,
                        title     : "Dashboard Chart Info"
                    });
                }
            	//CPFR 출하 현황
            	else if(chartId == "CPFRshipmentStatus")
                {
            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
                        rootUrl   : "dashboard",
                        url       : "dashBoardChartInfoPopup",
                        width     : 600,
                        height    : 600,
                        chartId   : chartId,
                        title     : "Dashboard Chart Info"
                    });
                }
            	//평균 출하단가(ASP) TREND
            	else if(chartId == "averageShippingUnitASPTREND")
                {
            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
                        rootUrl   : "dashboard",
                        url       : "dashBoardChartInfoPopup",
                        width     : 600,
                        height    : 600,
                        chartId   : chartId,
                        title     : "Dashboard Chart Info"
                    });
                }
            	
            }
            
        });
        
        $(".manuel > a").click("on", function() {
            
            var chartId  = this.id;
            
          //자재 가용률
            if(chartId == "materialAvailabilityScm")
            {
            	 $('#materialAvailabilityScmDatawrap').toggle();
                 $('#materialAvailabilityScmContent').toggle();
            }
            //자재입고 준수율
            else if(chartId == "materialReceiptComplianceRate")
            {
                $('#materialReceiptComplianceRateDatawrap').toggle();
                $('#materialReceiptComplianceRateContent').toggle();
            }
            //자재 재고
            else if(chartId == "materialStockScm")
            {
                $('#materialStockScmDatawrap').toggle();
                $('#materialStockScmContent').toggle();
            }
            //출하 준수율
            else if(chartId == "shipmentComplianceRateScm")
            {
                $('#shipmentComplianceRateScmDatawrap').toggle();
                $('#shipmentComplianceRateScmContent').toggle();
            }
            //출하 적중률
            else if(chartId == "shipmentHitRateScm")
            {
                $('#shipmentHitRateScmDatawrap').toggle();
                $('#shipmentHitRateScmContent').toggle();
            }
            //출하 달성률
            else if(chartId == "shipmentAchievementRateScm")
            {
                $('#shipmentAchievementRateScmDatawrap').toggle();
                $('#shipmentAchievementRateScmContent').toggle();
            }
            //기준정보 등록률
            else if(chartId == "standardInformationRegistrationRate")
            {
                $('#standardInformationRegistrationRateDatawrap').toggle();
                $('#standardInformationRegistrationRateContent').toggle();
            }
            //CPFR 출하 현황
            else if(chartId == "CPFRshipmentStatus")
            {
                $('#CPFRshipmentStatusDatawrap').toggle();
                $('#CPFRshipmentStatusContent').toggle();
            }
            //평균 출하단가(ASP) TREND
            else if(chartId == "averageShippingUnitASPTREND")
            {
                $('#avgShipPriceChart').toggle();
                $('#averageShippingUnitASPTRENDContent').toggle();
            }
            
            
        });
        

        $(".titleContainer > h4").hover(function() {
            
            var chartId  = this.id;
        
            //자재 가용률
            if(chartId == "materialAvailabilityScmH4")
            {
                 $('#materialAvailabilityScmDatawrap').toggle();
                 $('#materialAvailabilityScmContent').toggle();
            }
            //자재입고 준수율
            else if(chartId == "materialReceiptComplianceRateH4")
            {
                $('#materialReceiptComplianceRateDatawrap').toggle();
                $('#materialReceiptComplianceRateContent').toggle();
            }
            //자재 재고
            else if(chartId == "materialStockScmH4")
            {
                $('#materialStockScmDatawrap').toggle();
                $('#materialStockScmContent').toggle();
            }
            //출하 준수율
            else if(chartId == "shipmentComplianceRateScmH4")
            {
                $('#shipmentComplianceRateScmDatawrap').toggle();
                $('#shipmentComplianceRateScmContent').toggle();
            }
            //출하 적중률
            else if(chartId == "shipmentHitRateScmH4")
            {
                $('#shipmentHitRateScmDatawrap').toggle();
                $('#shipmentHitRateScmContent').toggle();
            }
            //출하 달성률
            else if(chartId == "shipmentAchievementRateScmH4")
            {
                $('#shipmentAchievementRateScmDatawrap').toggle();
                $('#shipmentAchievementRateScmContent').toggle();
            }
            //기준정보 등록률
            else if(chartId == "standardInformationRegistrationRateH4")
            {
                $('#standardInformationRegistrationRateDatawrap').toggle();
                $('#standardInformationRegistrationRateContent').toggle();
            }
            //CPFR 출하 현황
            else if(chartId == "cpfrShipInfo_1")
            {
                $('#CPFRshipmentStatusDatawrap').toggle();
                $('#CPFRshipmentStatusContent').toggle();
            }
            //평균 출하단가(ASP) TREND
            else if(chartId == "averageShippingUnitASPTRENDH4")
            {
                $('#avgShipPriceChart').toggle();
                $('#averageShippingUnitASPTRENDContent').toggle();
            }
            
            
            
        });
        
    	
    }
    
    //조회
    function fn_apply(sqlFlag) {
    	
    	if(userLang == "ko"){
    		unit = 100000000;
    		unit2 = 10000;
    		roundNum = 0;
    		format = "y:,.0f";
    	}else if(userLang == "en" || userLang == "cn"){
    		unit = 1000000000;
    		unit2 = 1000;
    		roundNum = 1;
    		format = "y:,.1f";
    	}
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	
    	//메인 데이터를 조회
    	fn_getChartData(sqlFlag);
    }
    
    function fn_getChartData(sqlFlag) {
    	
    	FORM_SEARCH = bucket;
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.unit = unit;
    	FORM_SEARCH.unit2 = unit2;
    	FORM_SEARCH.sql = sqlFlag;
    	FORM_SEARCH.weekMaterialsAvail = $(':radio[name=weekMaterialsAvail]:checked').val();
    	FORM_SEARCH.materialRate = $(':radio[name=materialRate]:checked').val();
    	FORM_SEARCH.pastFlag = pastFlag;
    	FORM_SEARCH.tranData = [
								{ outDs : "cpfrInvInfo2", _siq:"dashboard.scmDash.cpfrInvInfo2" }
							 // , { outDs : "cpfrShipInfo1", _siq:"dashboard.scmDash.cpfrShipInfo1" }
							  , { outDs : "avgShipPriceChart", _siq : "dashboard.scmDash.avgShipPriceChart" }
							  , { outDs : "materialChart", _siq:"dashboard.scmDash.materialChart"}			 // 자재 가용룰 	 scmDash222  
							  , { outDs : "materialsRateChart", _siq:"dashboard.scmDash.materialsRateChart"} // 자재입고 준수율    scmDash222 
							  , { outDs : "chart3List", _siq:"dashboard.scmDash.chart3"}					 // 자재재고, 출하준수율, 출하 적중률, 출하 달성률
							  , { outDs:"basicReqChart", _siq:"dashboard.scmDash.basicReqChart"}				 // 기준정보 등록률    scmDash222 
							  ]; 
    	
    	var sMap = {
            url: "${ctx}/biz/obj.do",
            data: FORM_SEARCH,
            success:function(data) {
            	
            	materialChart   = data.materialChart; 		 //<!-- 자재 가용룰-->		<!-- scmDash222  -->
            	materialsRateChart = data.materialsRateChart;//<!-- 자재입고 준수율 -->	<!-- scmDash222  -->
            	chart3List = data.chart3List;			     //<!-- 자재재고, 출하 준수율, 출하 적중률, 출하 달성률-->
            	basicReqChart = data.basicReqChart;			 //<!-- 기준정보 등록률 -->	<!-- scmDash222  -->
            	fn_initChart(data);
            	
            }
        }
        gfn_service(sMap,"obj");
    }

    //차트 초기화
    function fn_initChart(res) {
    	
    	//테마적용 공통함수
    	gfn_setHighchartTheme();
    	
    	
    	/*
    	var cpfrMonth = res.cpfrInvInfo2[0].MONTH;
    	var cpfrInv = '<spring:message code="lbl.cpfrPre" /> ' + res.cpfrInvInfo2[0].PRE_PROD_WEEK + "WK";
    	
		//CPFR 출하 현황(월)
		tmpRetent = 0, tmpInvAmt = 0;
		colorRetent = "green_f";
		colorInvAmt = "green_f";
		$.each(res.cpfrShipInfo1, function(n, v){
			
			var achieRate = gfn_nvl(v.ACHIE_RATE, 0);
			var variationAmt = gfn_nvl(v.VARIATION_AMT, 0);
			var rstAmt = gfn_nvl(v.RST_AMT, 0);
			
			if(variationAmt < 0){
				colorRetent = "red_f";
			}
			
			$("#cpfrShipInfo_1").append(cpfrMonth);
			$("#cpfrShipInfo_2").html('(<spring:message code="lbl.achieRateChart4" /> ' + achieRate + '%)');
			$("#cpfrShipInfo_3").html(variationAmt);
			$("#cpfrClass_3").attr("class", "per_txt1 " + colorRetent);
			$("#cpfrShipInfo_4").html(rstAmt);
			$("#cpfrShipInfo_5").html(cpfrInv);
		});
		
		*/
		//1. 자재 가용률 
		$.each(materialChart, function(i, val){
    		
    		var cDataP = "";
    		var chart1 = val.CHART_1;
    		var chart2 = val.CHART_2;
    		var chartC = val.CHART_C;
    		var chartCSub = val.CHART_C_SUB;
    		
    		if(userLang == "ko"){
    			chart1    = gfn_getNumberFmt(chart1, 0, 'R', 'Y');       
    			chart2    = gfn_getNumberFmt(chart2, 0, 'R', 'Y');
        	}else if(userLang == "en" || userLang == "cn"){
        		chart1    = gfn_getNumberFmt(chart1, 1, 'R', 'Y');       
    			chart2    = gfn_getNumberFmt(chart2, 1, 'R', 'Y');
        	}
    		
    		if (chart2 > 0){
    			cDataP = "+";
    		}

    		$("#materialChart_1").text(chart1);
    		$("#materialChart_1").parent().attr("class", "per_txt " + chartC);
    		$("#materialChart_2").text(cDataP + chart2);
    		$("#materialChart_2").parent().attr("class", "per_txt1 " + chartCSub);
    	});
		
		//8.CPFR 출하 현황
		var arMonth    = new Array();
		var arPreMonth = new Array();
		
		$.each (bucket.month, function (i, el) {
			arMonth.push(el.DISMONTH);
			arPreMonth.push(el.PRE_DISMONTH);
		});
		
		var avgShipPriceChart = JSON.parse(res.avgShipPriceChart[0].AVG_SHIP);
		chartGen('avgShipPriceChart', 'line', arPreMonth, avgShipPriceChart);
		
		// 2. 자재입고 준수율
		var beforeResultValue = 0;
    	$.each(materialsRateChart, function(i, val){
    		
    		var cnt = i + 1;
    		var cDataP = "";
    		var trendWeek = val.TREND_WEEK;
    		var resultValue = val.RESULT_VALUE;
    		var chartC = val.CHART_C;
    		
    		if(userLang == "ko"){
    			resultValue    = gfn_getNumberFmt(resultValue, 0, 'R', 'Y');       
        	}else if(userLang == "en" || userLang == "cn"){
        		resultValue    = gfn_getNumberFmt(resultValue, 1, 'R', 'Y');       
        	}
    		
    		if(i == 0){
    			$("#materialsRateH4").html("(W" + trendWeek + ")");
    		}
    		
    		if (i == 1 || i == 3){
    			
    			var tmpValue = beforeResultValue - resultValue; 
    			
    			if(tmpValue > 0){
    				cDataP = "+";	
    			}
    			$("#materialsRateChart_" + cnt).text(cDataP + tmpValue);
        		$("#materialsRateChart_" + cnt).parent().attr("class","per_txt1 " + chartC);	
    		}else{
        		$("#materialsRateChart_" + cnt).text(resultValue);
        		$("#materialsRateChart_" + cnt).parent().attr("class","per_txt " + chartC);	
    		}
    		
    		beforeResultValue = resultValue;
    	});
		
    	// 자재재고, 출하 준수율, 출하 적중률, 출하 달성률
    	var chart3; 
    	var chart3ListLen = chart3List.length + 1;
    	
    	for (var i = 1; i <= chart3ListLen; i++) {
    		
	    	
    		cData1 = 0, cData2 = 0, cDataC = "", cDataP = "green_f", cDataCSub = "gray_f";
	    	chart3 = gfn_getFindDataDsInDs(chart3List, {MEAS_CD : {VALUE : "CHART" + i, CONDI : "="}});
	    	
	    	if (chart3.length > 0) {
	    		
	    		if ($("#chart3_"+ i +"_1").parent().text().indexOf('<spring:message code="lbl.billion"/>') > -1) {
	    			cData1 = chart3[0].CHART_1 / unit;
	    			cData2 = chart3[0].CHART_2 / unit;
	    		} else {
	    			cData1 = chart3[0].CHART_1;
	    			cData2 = chart3[0].CHART_2;
	    		}
	    		
	    		if(userLang == "ko"){
	    			cData1    = gfn_getNumberFmt(cData1, 0, 'R','Y');       
		    		cData2    = gfn_getNumberFmt(cData2, 0, 'R','Y');
	        	}else if(userLang == "en" || userLang == "cn"){
	        		
	        		if(i == 3 || i == 4 || i == 5 || i == 6){
	        			cData1 = gfn_getNumberFmt(cData1, 0, 'R','Y');       
			    		cData2 = gfn_getNumberFmt(cData2, 0, 'R','Y');	        			
	        		}else{
	        			cData1 = gfn_getNumberFmt(cData1, 1, 'R','Y');       
			    		cData2= gfn_getNumberFmt(cData2, 1, 'R','Y');
	        		}
	        	}
	    		
	    		cDataC    = chart3[0].CHART_C;
	    		cDataP    = chart3[0].CHART_P;
	    		cDataCSub = chart3[0].CHART_C_SUB;
	    		
	    		if (cData2 > 0) {
	    			cDataP = "+";
	    		}
	    		
	    		$("#chart3_"+ i +"_1").text(cData1);
	    		$("#chart3_"+ i +"_1").parent().attr("class","per_txt "+cDataC);
	    		$("#chart3_"+ i +"_2").text(cDataP+cData2);
	    		$("#chart3_"+ i +"_2").parent().attr("class","per_txt1 "+cDataCSub);
	    	}
    	}
    	
    	
    	//기준정보 등록률		<!-- 기준정보 등록률 -->			<!-- scmDash222  -->
    	$.each(basicReqChart, function(i, val){
    		
    		var rate = val.RATE;
    		var cnt = val.CNT;
    		var chartC = val.CHART_C;
    		
    		$("#basicReqChart_1").text(rate);
    		$("#basicReqChart_1").parent().attr("class","per_txt " + chartC);
    		$("#basicReqChart_2").text(cnt);
    		$("#basicReqChart_2").parent().attr("class","per_txt1 red_f");
    	});
    	
    }
    
    
	function materialChartSearch(){
    	
    	FORM_SEARCH = {};
    	FORM_SEARCH.weekMaterialsAvail = $(':radio[name=weekMaterialsAvail]:checked').val();
    	FORM_SEARCH.pastFlag = pastFlag;
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.tranData = [{outDs:"materialChart", _siq:"dashboard.scmDash.materialChart"}];
    	
    	var sMap = {
            url: "${ctx}/biz/obj.do",
            data: FORM_SEARCH,
            success:function(data) {
            	
            	$.each(data.materialChart, function(i, val){
            		
            		var cDataP = "";
            		var chart1 = val.CHART_1;
            		var chart2 = val.CHART_2;
            		var chartC = val.CHART_C;
            		var chartCSub = val.CHART_C_SUB;
            		
            		
            		if(userLang == "ko"){
            			chart1    = gfn_getNumberFmt(chart1, 0, 'R', 'Y');       
            			chart2    = gfn_getNumberFmt(chart2, 0, 'R', 'Y');
                	}else if(userLang == "en" || userLang == "cn"){
                		chart1    = gfn_getNumberFmt(chart1, 1, 'R', 'Y');       
            			chart2    = gfn_getNumberFmt(chart2, 1, 'R', 'Y');
                	}
            		
            		if (chart2 > 0){
            			cDataP = "+";
            		}
            		
            		$("#materialChart_1").text(chart1);
            		$("#materialChart_1").parent().attr("class","per_txt " + chartC);
            		$("#materialChart_2").text(cDataP + chart2);
            		$("#materialChart_2").parent().attr("class","per_txt1 " + chartCSub);
            	});
            }
        }
        gfn_service(sMap,"obj");
    }
    
    function materialRateChartSearch(){
    	
    	FORM_SEARCH = {};
    	FORM_SEARCH.materialRate = $(':radio[name=materialRate]:checked').val();
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.tranData = [{outDs:"materialsRateChart", _siq:"dashboard.scmDash.materialsRateChart"}];
    	
    	var sMap = {
            url: "${ctx}/biz/obj.do",
            data: FORM_SEARCH,
            success:function(data) {
            	
            	var beforeResultValue = 0;
            	$.each(data.materialsRateChart, function(i, val){
            		
            		var cnt = i + 1;
            		var cDataP = "";
            		var trendWeek = val.TREND_WEEK;
            		var resultValue = val.RESULT_VALUE;
            		var chartC = val.CHART_C;
            		
            		if(userLang == "ko"){
            			resultValue    = gfn_getNumberFmt(resultValue, 0, 'R', 'Y');       
                	}else if(userLang == "en" || userLang == "cn"){
                		resultValue    = gfn_getNumberFmt(resultValue, 1, 'R', 'Y');       
                	}
            		
            		if(i == 0){
            			$("#materialsRateH4").html("(W" + trendWeek + ")");
            		}
            		
            		if (i == 1 || i == 3){
            			
            			var tmpValue = beforeResultValue - resultValue; 
            			
            			if(tmpValue > 0){
            				cDataP = "+";	
            			}
            			$("#materialsRateChart_" + cnt).text(cDataP + tmpValue);
                		$("#materialsRateChart_" + cnt).parent().attr("class", "per_txt " + chartC);	
            		}else{
                		$("#materialsRateChart_" + cnt).text(resultValue);
                		$("#materialsRateChart_" + cnt).parent().attr("class", "per_txt " + chartC);	
            		}
            		
            		beforeResultValue = resultValue;
            	});
            }
        }
        gfn_service(sMap,"obj");
    }
    
    
    
    function chartGen(chartId, type, arCarte, arData){
    	
    	var chart = {
			chart  : { type : type },
			xAxis  : { categories : arCarte },
		    legend: {
		    	enabled: true
		    },
			series : arData,
			plotOptions: {
				line: {
		            dataLabels: {
		                style : {
		                	fontSize : "12px",
		                	fontWeight: ''
						}
		            },
		        },
				series: {
					events: {
						/* afterAnimate : function(e){
		        			var chartLen = this.chart.series.length;
		        			var chart23RadioData = $(':radio[name=chart23Radio]:checked').val();
		        			
		        			if(chartId == "chart23") {
		        				if(chart23RadioData == "cust"){
		        					for(var i = 0; i < chartLen; i++){
			        					
			        					var chartCode = this.chart.series[i].userOptions.code;
			        					
			        					if(chartCode != "RCG001"){
			        						this.chart.series[i].hide();	
			        					}
			        				}	
		        				}
		        			}
		        		} */
		        		legendItemClick: function() {
							
		                    var seriesIndex = this.index;
		                    var series = this.chart.series;
		                   	
		                	if(this.chart.isFirstClick!= true)
		                	{
					        	for (var i = 0; i < series.length; i++) {
		                    	   
					                if(series[i].index != seriesIndex) {
					                    series[i].hide();
				                    }
					                else if(series[i].index == seriesIndex)
					                {
					                	series[i].show();
					                }
				                   
		                    	}
		                    	this.show()
		                    	this.chart.isFirstClick = true;
		                		
		                    	
			            		return false;
		                	}
		                			    	
		            	}// end of legendItemClick
					},							
					cursor: 'pointer',
					point: {
						events: {
							click: function() {
								if(chartId == "avgShipPriceChart") {
									gfn_comPopupOpen("POPUP_CHART_SCM_DASH", {
										rootUrl   : "dashboard",
										url       : "popupChartScmDash",
										width     : 1920,
										height    : 1060,
										menuCd    : "SNOP100",
										chartId   : chartId,
										title     : "<spring:message code='lbl.avgShipPrice' /> "
									});
								}
							}
						}
					}
				}
			}
		};
		
		Highcharts.chart(chartId, chart);
		
		//하이차트 버전 업 후 가려지는 현상 
		$("#" + chartId).css("overflow", "");
    }
    
    
    function materialAvailabilityScmActionToggle() {
        const action = $('#materialAvailabilityScmAction');
        
        action.toggleClass('active')
 }
  
  

  function materialReceiptComplianceRateActionToggle() {
        const action = $('#materialReceiptComplianceRateAction');
        
        action.toggleClass('active')
 }
    
    
  function fn_popUpAuthorityHasOrNot(){
      
      SCM_SEARCH = {}; // 초기화
      
      SCM_SEARCH.USER_ID = "${sessionScope.userInfo.userId}" ;
      
      
      SCM_SEARCH._mtd     = "getList";
      SCM_SEARCH.tranData = [
                             { outDs : "isSCMTeam",_siq : "dashboard.chartInfo.isSCMTeam"}
                          ];
      
      
      
      var aOption = {
          async   : false,
          url     : GV_CONTEXT_PATH + "/biz/obj.do",
          data    : SCM_SEARCH,
          success : function (data) {
          
              if (SCM_SEARCH.sql == 'N') {
                  
                  SCM_SEARCH.isSCMTeam = data.isSCMTeam[0].isSCMTeam;
              
              }
          }
      }
      
      gfn_service(aOption, "obj");
      
      
      
      
  }
  
  
  var fn_popupCallback = function () {
      location.reload();
  }
  
  function fn_quilljsInit(){
      

      quill_1 =  new Quill('#editor-1', {
                    
                    modules: {
                        "toolbar": false
                    } ,            
                    theme: 'snow'  // or 'bubble'
                  })
      quill_1.enable(false);
      
      
      quill_2 =  new Quill('#editor-2', {
          
          modules: {
              "toolbar": false
          } ,            
          theme: 'snow'  // or 'bubble'
        })
      quill_2.enable(false);
      
      
      quill_3 =  new Quill('#editor-3', {
          
          modules: {
              "toolbar": false
          } ,            
          theme: 'snow'  // or 'bubble'
        })
      quill_3.enable(false);
      
      
      
      quill_4 =  new Quill('#editor-4', {
          
          modules: {
              "toolbar": false
          } ,            
          theme: 'snow'  // or 'bubble'
        })
      quill_4.enable(false);
      
      
      
      quill_5 =  new Quill('#editor-5', {
          
          modules: {
              "toolbar": false
          } ,            
          theme: 'snow'  // or 'bubble'
        })
      quill_5.enable(false);
      
      
      
      quill_6 =  new Quill('#editor-6', {
          
          modules: {
              "toolbar": false
          } ,            
          theme: 'snow'  // or 'bubble'
        })
      quill_6.enable(false);
      
      
      
      quill_7 =  new Quill('#editor-7', {
          
          modules: {
              "toolbar": false
          } ,            
          theme: 'snow'  // or 'bubble'
        })
      quill_7.enable(false);
      
      
      
      quill_8 =  new Quill('#editor-8', {
          
          modules: {
              "toolbar": false
          } ,            
          theme: 'snow'  // or 'bubble'
        })
      quill_8.enable(false);
      
      
      
      quill_9 =  new Quill('#editor-9', {
          
          modules: {
              "toolbar": false
          } ,            
          theme: 'snow'  // or 'bubble'
        })
      quill_9.enable(false);
  
  
}
  function fn_chartContentInit(){
      
      
      /*
  
      0.    materialAvailabilityScm
	  1.	materialReceiptComplianceRate
	  2.	materialStockScm
	  3.	shipmentComplianceRateScm
	  4. 	shipmentHitRateScm
	  5. 	shipmentAchievementRateScm
	  6. 	standardInformationRegistrationRate
	  7. 	CPFRshipmentStatus
	  8.	averageShippingUnitASPTREND

      */
      
      
      for(i=0;i<9;i++)
      {
          if(FORM_SEARCH.chartList[i].ID=="materialAvailabilityScm")                      FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_1.setContents([{ insert: '\n' }]):quill_1.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
          else if(FORM_SEARCH.chartList[i].ID=="materialReceiptComplianceRate")             FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_2.setContents([{ insert: '\n' }]):quill_2.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
          else if(FORM_SEARCH.chartList[i].ID=="materialStockScm")       FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_3.setContents([{ insert: '\n' }]):quill_3.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
          else if(FORM_SEARCH.chartList[i].ID=="shipmentComplianceRateScm")             FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_4.setContents([{ insert: '\n' }]):quill_4.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
          else if(FORM_SEARCH.chartList[i].ID=="shipmentHitRateScm")  FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_5.setContents([{ insert: '\n' }]):quill_5.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
          else if(FORM_SEARCH.chartList[i].ID=="shipmentAchievementRateScm")          FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_6.setContents([{ insert: '\n' }]):quill_6.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
          else if(FORM_SEARCH.chartList[i].ID=="standardInformationRegistrationRate")               FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_7.setContents([{ insert: '\n' }]):quill_7.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
          else if(FORM_SEARCH.chartList[i].ID=="CPFRshipmentStatus")          FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_8.setContents([{ insert: '\n' }]):quill_8.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
          else if(FORM_SEARCH.chartList[i].ID=="averageShippingUnitASPTREND")            FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_9.setContents([{ insert: '\n' }]):quill_9.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
                                      
      }
      
      
      
  }
  
  
    </script>

</head>
<body id="framesb" class="portalFrame">
	<jsp:include page="/WEB-INF/view/layout/commonForm.jsp" flush="false">
		<jsp:param name="siteMapYn" value="Y"/>
	</jsp:include>
	
	<!-- contents -->
	<div id="grid1" class="fconbox">
		<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
		
		<div class="scroll" style="height:calc(100% - 35px)">
			<!-- 대쉬보드 화면 시작 -->
	        <div id="container" style="float: left">
		  		<div id="cont_chart">
	        		
	        		<!-- 자재 가용룰-->				<!-- scmDash222  -->	
	        		<div class="col_3">
	        			<div class="titleContainer">
	        			    <!-- style="left: calc(50% - 55px);" -->
	        				<h4  id="materialAvailabilityScmH4"><spring:message code="lbl.materialAva"/><span class="selectWeekTxt"></h4>
	        			    <div class="view_combo"> <!-- class="action" id="materialAvailabilityScmAction" -->
                                 <!-- <span>+</span> -->
                                
	        			        <ul class="rdofl" > <!-- style="float:right;height:80px;" -->
                                    <li><input type="radio" id="weekMaterialsAvail1" name="weekMaterialsAvail" value="rawMaterials" checked="checked" /> <label for="weekMaterialsAvail1"><spring:message code="lbl.rawMaterial" /></label></li>
                                    <li><input type="radio" id="weekMaterialsAvail2" name="weekMaterialsAvail" value="outerHalfProduct"  /> <label for="weekMaterialsAvail2"><spring:message code="lbl.osfp" /> </label></li>
                                    <li class="manuel"><a href="#" id="materialAvailabilityScm"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a></li>
                                </ul>
                            </div>
	        			    
	        			</div>
	
				            	
			            <div class="datawrap" id="materialAvailabilityScmDatawrap">
			                	<span class="span_padding"></span>
			                    <p class="per_txt green_f"><strong id="materialChart_1">0</strong> %</p>
			                    <p class="per_txt1"><spring:message code="lbl.lastWeek"/>&nbsp;<span class="per_txt1" id="materialChart_2">0</span>%</p>
	                	</div>
	                	<div class="modal" id="materialAvailabilityScmContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-1"></div>
                           </div>
                        </div>		
	        	    </div>
	          		<!--자재 입고 준수율  -->
	            	<div class="col_3">
	           			<div class="titleContainer">
	           				<!-- style="left: calc(50% - 67px);" -->
	           				<h4  id="materialReceiptComplianceRateH4"><spring:message code="lbl.materialsRate"/><span id="materialsRateH4" class="cweekTxt"></h4>
	           			    <div class="view_combo"> <!-- class="action" id="materialReceiptComplianceRateAction" -->
                                 <!--  <span>+</span>-->                                   
	           			        <ul class="rdofl" > <!-- style="float: right;height:80px;" -->
                                    <li><input type="radio" id="materialRate1" name="materialRate" value="raw" checked="checked"/> <label for="materialRate1"><spring:message code="lbl.rawMaterial" /></label></li>
                                    <li><input type="radio" id="materialRate2" name="materialRate" value="osfp"/> <label for="materialRate2"><spring:message code="lbl.osfp" /> </label></li>
                                    <li class="manuel"><a href="#" id="materialReceiptComplianceRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a></li>
                                </ul>
                            </div>
	           			</div>
		       	
		       
		                <div class="datawrap" id="materialReceiptComplianceRateDatawrap">
		                    	<p class="per_txt green_f"><strong id="materialsRateChart_1">0</strong> %</p>
		                    	<p class="per_txt1"><spring:message code="lbl.lastWeek"/>&nbsp;<span class="per_txt1" id="materialsRateChart_2">0</span>%</p>
		            	</div>
		            	<div class="modal" id="materialReceiptComplianceRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-2"></div>
                           </div>
                        </div>
		            </div>
	            	<!-- 자재 재고 -->
	            	<div class="col_3">
	            		<div class="titleContainer">
	            		    <!-- style="left: calc(50% - 27px);" -->
	            			<h4  id="materialStockScmH4"><spring:message code="lbl.matInv"/></h4>
	            		    <div class="view_combo">
                             <ul class="rdofl">
                                 <li class="manuel">
                                    <a href="#" id="materialStockScm"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                 </li>
                             </ul>
                            </div>
	            		</div>
	            		
	            		<div class="datawrap" id="materialStockScmDatawrap">
                			<p class="per_txt green_f"><strong id="chart3_1_1">0</strong> <spring:message code="lbl.billion"/></p>
	                    	<p class="per_txt1"><spring:message code="lbl.lastWeek"/>&nbsp;<span class="per_txt1" id="chart3_1_2">0</span><spring:message code="lbl.billion"/></p>
	                	</div>
	            	    <div class="modal" id="materialStockScmContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-3"></div>
                           </div>
                        </div>
	            	</div>
	            	<!-- 출하 준수율 -->
	            	<div class="col_3">
	            		<div class="titleContainer">
	            			<!-- style="left: calc(50% - 55px);" -->
	            			<h4  id="shipmentComplianceRateScmH4"><spring:message code="lbl.salesCmplRateChart1"/><span class="pweekTxt"></h4>
	            		    <div class="view_combo">
                             <ul class="rdofl">
                                 <li class="manuel">
                                    <a href="#" id="shipmentComplianceRateScm"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                 </li>
                             </ul>
                            </div>
	            		</div>
	 
	            		<div class="datawrap" id="shipmentComplianceRateScmDatawrap">
		                		<p class="per_txt green_f"><strong id="chart3_3_1">0</strong> %</p>
		                    	<p class="per_txt1"><spring:message code="lbl.lastWeek"/>&nbsp;<span class="per_txt1" id="chart3_3_2">0</span>%</p>
		                </div>
		                <div class="modal" id="shipmentComplianceRateScmContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-4"></div>
                           </div>
                        </div>
	            	</div>
	            	<!--출하 적중률  -->
	            	<div class="col_3">
	            		<div class="titleContainer">
	            			<!-- style="left: calc(50% - 54px);" -->
	            			<h4  id="shipmentHitRateScmH4"><spring:message code="lbl.salesHittingRation"/> (<spring:message code="lbl.prevMonthChart"/>)</h4>
	            		    <div class="view_combo">
                             <ul class="rdofl">
                                 <li class="manuel">
                                    <a href="#" id="shipmentHitRateScm"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                 </li>
                             </ul>
                            </div>
	            		</div>  
		
	            		<div class="datawrap" id="shipmentHitRateScmDatawrap">
		                		<p class="per_txt green_f"><strong id="chart3_4_1">0</strong> %</p>
		                    	<p class="per_txt1"><spring:message code="lbl.lastMonth"/>&nbsp;<span class="per_txt1" id="chart3_4_2">0</span>%</p>
		                </div>
		                <div class="modal" id="shipmentHitRateScmContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-5"></div>
                           </div>
                        </div>
	            	</div>
	            	<!-- 출하 달성률 -->
	            	<div class="col_3">
	            		<div class="titleContainer">
	            		    <!-- style="left: calc(50% - 68px);" -->
	            			<h4  id="shipmentAchievementRateScmH4"><spring:message code="lbl.achieRateChart4"/> (M+3) (%)</h4>
	            		    <div class="view_combo">
                             <ul class="rdofl">
                                 <li class="manuel">
                                    <a href="#" id="shipmentAchievementRateScm"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                 </li>
                             </ul>
                            </div>
	            		</div>
	 
	            		<div class="datawrap" id="shipmentAchievementRateScmDatawrap">
		                		<p class="per_txt green_f"><strong id="chart3_5_1">0</strong> %</p>
		                    	<p class="per_txt1"><spring:message code="lbl.lastMonth"/>&nbsp;<span class="per_txt1" id="chart3_5_2">0</span>%</p>
		                </div>
		                <div class="modal" id="shipmentAchievementRateScmContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-6"></div>
                           </div>
                        </div>
	            	</div>
	            	<!-- 기준정보 등록률 -->
	            	<div class="col_3">
	            		<div class="titleContainer">
	            			<!-- style="left: calc(50% - 47px);" -->
	            			<h4  id="standardInformationRegistrationRateH4"><spring:message code="lbl.basicReq"/></h4>
	            		    <div class="view_combo">
                             <ul class="rdofl">
                                 <li class="manuel">
                                    <a href="#" id="standardInformationRegistrationRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                 </li>
                             </ul>
                            </div>
	            		</div>
	 
	            		<div class="datawrap" id="standardInformationRegistrationRateDatawrap">
		                		<p class="per_txt green_f"><strong id="basicReqChart_1">0</strong> %</p>
			                    <p class="per_txt1">(<spring:message code="lbl.noEnd"/>&nbsp;<span class="per_txt1" id="basicReqChart_2">0</span><spring:message code="lbl.cnt3"/>)</p>
		                </div>
		                <div class="modal" id="standardInformationRegistrationRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-7"></div>
                           </div>
                        </div>
	            	</div>
	            	<!-- CPFR 출하 현황(월) -->
	            	<div class="col_3">
	            		<div class="titleContainer">
	            			<!-- style="left: calc(50% - 88px);" -->
	            			<h4 id="cpfrShipInfo_1" ><spring:message code="lbl.cpfrShipInfo" /></h4>
	            		    <div class="view_combo">
                             <ul class="rdofl">
                                 <li class="manuel">
                                    <a href="#" id="CPFRshipmentStatus"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                 </li>
                             </ul>
                            </div>
	            		</div>
	                       <!-- 
	            		<div class="datawrap" style="top:calc(40% - 70px)" id="CPFRshipmentStatusDatawrap">
								<p class="per_txt"><strong id="cpfrShipInfo_4">0 </strong><spring:message code="lbl.hMillion" /></p>
								<p id="cpfrClass_3"><spring:message code="lbl.thisMonthPlan"/>&nbsp;<span class="per_txt1" id="cpfrShipInfo_3">0</span><spring:message code="lbl.hMillion" /></p>
								<p style="font-size:20px;"><strong id="cpfrShipInfo_2">0</strong></p>
								<p><strong id="cpfrShipInfo_5"></strong></p>
	                    </div>
	                     -->
	                    <div class="modal" id="CPFRshipmentStatusContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-8"></div>
                           </div>
                        </div>
	            	</div>
	            	<!-- 평균 출하단가(ASP) TREND -->
	            	<div class="col_3">
	            		<div class="titleContainer">
	            			<!-- style="left: calc(50% - 135px);" -->
	            			<h4  id="averageShippingUnitASPTRENDH4"><spring:message code="lbl.avgShipPrice"/><span class="cweekTxt"></span></h4>
	                	    <div class="view_combo">
                             <ul class="rdofl">
                                 <li class="manuel">
                                    <a href="#" id="averageShippingUnitASPTREND"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                 </li>
                             </ul>
                            </div>
	                	</div>
	                	<div id="avgShipPriceChart" style="height:100%;"></div>
	                	<div class="modal" id="averageShippingUnitASPTRENDContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-9"></div>
                           </div>
                        </div>
	            	</div>
	            
		  		</div>
			</div>
	        <!-- 대쉬보드 화면 끝 -->
	        <div id="cont_chart3">
				<div id="cont_chart">
					<div class="col_3" style="height:100%;width:100%;margin: 0;padding:0">
			            <div id="sitemappop" style="margin: 0; display:block; height:calc(100% - 30px);width:100%;">
							<div class="drag">
								<div style="height: 100%;padding: 15px 0px 15px 10px;">
									<div class="scroll"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
        </div>
	</div>
	
</body>
</html>
