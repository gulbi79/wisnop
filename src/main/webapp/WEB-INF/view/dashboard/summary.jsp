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
	
	#cont_chart .col_3 { position:relative;margin:0; width:calc((100% - 4px) / 3) ; height:calc((100% - 4px) / 3); padding:7px;}
	#cont_chart .col_3:nth-child(1) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(2) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(3) {margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(4) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(5) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(6) {margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(7) {margin:0 2px 0 0;}
	#cont_chart .col_3:nth-child(8) {margin:0 2px 0 0;}
	
	
	#cont_chart .col_3 .textwrap { padding : 5px 0 0 0; }
	
	#cont_chart > .col_3_tmp > .titleContainer > h4  
	{
	    margin-bottom: 10px; 
	    float:left;
	}
	

	
	#cont_chart > .col_3_tmp > .titleContainer > div  
    {
        float:right;
    }
	
	#cont_chart3 {
		height: 100%;
	    width: 240px;
	    float: left;
	    margin-left: 10px;
	}
	
	
	#cont_chart .col_3 > .titleContainer > h4
    {
        float:left;
    }
    
    #cont_chart .col_3 > .titleContainer > div
    {
        float:right;
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

	var unitQuery = 0;
	var dMain,dBiz,dDefRate, itemInvData, matInvData;
	var cWeek, pWeek, nWeek, bucket;
    $(function() {
    	var params = {P_MENU_CD : "HOME_CHART_LIST"};
    	gfn_formLoad(); //?????? ??? ?????? ?????? ??????
    	fn_siteMap();
    	fn_init();
    	fn_initEvent();
    	fn_apply();
    	fn_excelSqlAuth();
    	$(".viewfnc4").click("on", function() { 
    		
    		fn_apply(true); 
    		
    		$(".back").click(function() {
    			$(".back").hide();
    		});
    		
    		$(document).on("click",".pClose",function() {
    			
    			$(".back").hide();
    		});
    	});
    	$(".viewfnc8").click("on", function() { gfn_comPopupOpen("CHART_LIST_CONF", params); });
    	
    });
    
    function fn_init() {
    	var userLang = "${sessionScope.GV_LANG}";
    	var cDate = gfn_getCurrentDate();
    	var pDate = gfn_getAddDate(cDate.YYYYMMDD, -7);
    	var nDate = gfn_getAddDate(cDate.YYYYMMDD, 7);
    	cWeek = "W"+cDate.WEEKOFYEAR;
    	pWeek = "W"+pDate.WEEKOFYEAR;
    	nWeek = "W"+nDate.WEEKOFYEAR;
    	
    	if(userLang == "ko"){
    		unitQuery = 100000000;
    	}else if(userLang == "en" || userLang == "cn"){
    		unitQuery = 1000000000;
    	}
    	
    	$.each($(".cweekTxt"), function(n,v) {
    		$(v).text(' ('+cWeek+', <spring:message code="lbl.hMillion"/>)');
    	});

    	$.each($(".pweekTxt"), function(n,v) {
    		$(v).text(' ('+pWeek+')');
    	});
    	
    	fn_quilljsInit();
    	
    	
    	
    }
    
    function fn_initEvent() {
    	
    	$(':radio[name=companyCons]').on('change', function () {
    		companyConsSearch(false);
    	});
    	$(':radio[name=weekMaterialsAvail]').on('change', function () {
    		weekMaterialsAvailSearch(false);
    	});
    	
    	
    	//lass="manuel">                      <a href="#" id="bscGeneral">
    	
    	$(".manuel > a").dblclick("on", function() {
    		
    		
    		
    		
    		var chartId  = this.id;
    		
    		fn_popUpAuthorityHasOrNot();
    		
    		var isSCMTeam = SCM_SEARCH.isSCMTeam;
    		
    		if(isSCMTeam>=1)
    		{
    		
    		
    		//BSC ??????
    		if(chartId == "bscGeneral"){
    			gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
                    rootUrl   : "dashboard",
                    url       : "dashBoardChartInfoPopup",
                    width     : 600,
                    height    : 600,
                    chartId   : chartId,
                    title     : "Dashboard Chart Info"
                });
    		}
    		//?????? ??????
    		else if(chartId == "businessPerformance")
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
    		//?????? ?????? ??????
    		else if(chartId == "productInventoryStatus")
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
    		//?????????
    		else if(chartId == "defectiveRate")
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
    		//?????? ??????
    		else if(chartId == "expectedToShip")
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
    		//?????? ??????
    		else if(chartId == "materialStock")
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
    		//?????? ?????? ?????? ?????????
    		else if(chartId == "weeklyProductionPlanComplianceRate")
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
    		//?????? ?????? ?????? ?????????
    		else if(chartId == "weeklyShippingPlanComplianceRate")
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
    		//?????? ?????? ?????????
    		else if(chartId == "weeklyMaterialAvailabilityRate")
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
            
             //BSC ??????
            if(chartId == "bscGeneral"){
                $('#chartBscScore,#chartBsc').toggle();
                $('#bscGeneralContent').toggle();
                   
            }
            //?????? ??????
            else if(chartId == "businessPerformance")
            {
                $("#businessPerformanceTable").toggle();
                $("#businessPerformanceContent").toggle();
            }
            //?????? ?????? ??????
            else if(chartId == "productInventoryStatus")
            {
              $("#chartInv1").toggle();
              $("#productInventoryStatusContent").toggle();
            }
            //?????????
            else if(chartId == "defectiveRate")
            {
               $("#chartDefRate,#chartDefRateScore").toggle();
               $("#defectiveRateContent").toggle();
            }
            //?????? ??????
            else if(chartId == "expectedToShip")
            {
                   $("#chartSales,#chartSalesScore").toggle();
                   $("#expectedToShipContent").toggle();
            }
            //?????? ??????
            else if(chartId == "materialStock")
            {
                $("#chartInv2").toggle();
                $("#materialStockContent").toggle();
            }
            //?????? ?????? ?????? ?????????
            else if(chartId == "weeklyProductionPlanComplianceRate")
            {
               $("#chartProdComp,#chartProdCompScore1,#chartProdCompScore2").toggle();
               $("#weeklyProductionPlanComplianceRateContent").toggle();
            }
            //?????? ?????? ?????? ?????????
            else if(chartId == "weeklyShippingPlanComplianceRate")
            {
               $("#chartSalesComp,#chartSalesCompScore1,#chartSalesCompScore2").toggle();
               $("#weeklyShippingPlanComplianceRateContent").toggle();
            }
            //?????? ?????? ?????????
            else if(chartId == "weeklyMaterialAvailabilityRate")
            {
               $("#chartMatPrepRate,#chartMatPrepRateScore").toggle();
               $("#weeklyMaterialAvailabilityRateContent").toggle();
            }   
    		
    	});
    	
    	
    	
    	
    	
    	$(".titleContainer > h4").hover(function() {
            
            var chartId  = this.id;
            
            
             //BSC ??????
            if(chartId == "bscGeneralH4"){
                $('#chartBscScore,#chartBsc').toggle();
                $('#bscGeneralContent').toggle();
                   
            }
            //?????? ??????
            else if(chartId == "businessPerformanceH4")
            {
                $("#businessPerformanceTable").toggle();
                $("#businessPerformanceContent").toggle();
            }
            //?????? ?????? ??????
            else if(chartId == "productInventoryStatusH4")
            {
              $("#chartInv1").toggle();
              $("#productInventoryStatusContent").toggle();
            }
            //?????????
            else if(chartId == "defectiveRateH4")
            {
               $("#chartDefRate,#chartDefRateScore").toggle();
               $("#defectiveRateContent").toggle();
            }
            //?????? ??????
            else if(chartId == "expectedToShipH4")
            {
                   $("#chartSales,#chartSalesScore").toggle();
                   $("#expectedToShipContent").toggle();
            }
            //?????? ??????
            else if(chartId == "materialStockH4")
            {
                $("#chartInv2").toggle();
                $("#materialStockContent").toggle();
            }
            //?????? ?????? ?????? ?????????
            else if(chartId == "weeklyProductionPlanComplianceRateH4")
            {
               $("#chartProdComp,#chartProdCompScore1,#chartProdCompScore2").toggle();
               $("#weeklyProductionPlanComplianceRateContent").toggle();
            }
            //?????? ?????? ?????? ?????????
            else if(chartId == "weeklyShippingPlanComplianceRateH4")
            {
               $("#chartSalesComp,#chartSalesCompScore1,#chartSalesCompScore2").toggle();
               $("#weeklyShippingPlanComplianceRateContent").toggle();
            }
            //?????? ?????? ?????????
            else if(chartId == "weeklyMaterialAvailabilityRateH4")
            {
               $("#chartMatPrepRate,#chartMatPrepRateScore").toggle();
               $("#weeklyMaterialAvailabilityRateContent").toggle();
            }
    	});
    	
    	
    	
    	
    	var arrTitle = $(".col_3 > .titleContainer > h4");
    	$.each(arrTitle, function(n,v) {
    		$(v).css("cursor", "pointer");
    		$(v).on("click", function() { 
    			if (n == 0) gfn_newTab("BSC101"); // BSC ??????
    			else if (n == 1) gfn_newTab("SNOP201"); // ????????????
    			else if (n == 2) gfn_newTab("SNOP205"); // ?????? ?????? ??????
    			else if (n == 3) gfn_newTab("QT101");  // ????????? 
    			else if (n == 4) gfn_newTab("DP208");  // ???????????? 
    			else if (n == 5) gfn_newTab("SNOP205");// ?????? ??????
    			else if (n == 6) gfn_newTab("MP104");  // ?????? ?????? ?????? ????????? 
    			else if (n == 7) gfn_newTab("MP104");  // ?????? ?????? ?????? ?????????
    			else if (n == 8) gfn_newTab("SNOP305");// ?????? ?????? ?????????
    		});
    	});
    }
    
    //??????
    function fn_apply(sqlFlag) {
    	
    	FORM_SEARCH = {}
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.tranData = [
    	
    		{ outDs : "month" , _siq : "dashboard.portal.Month" }
    		,{ outDs : "chartList" , _siq : "dashboard.chartInfo.home" }
    	];
    	
    	var sMap = {
    		url	 : "${ctx}/biz/obj",
    		data	: FORM_SEARCH,
    		success : function(data) {
    			bucket = {};
    			bucket.month = data.month;
    			FORM_SEARCH.chartList = data.chartList;
                fn_chartContentInit();
    			fn_getChartData(sqlFlag);
    			
    		}
    	}
    	gfn_service(sMap, "obj");
    	
    	
    }
    
   
    
    
    function fn_getChartData(sqlFlag) {
    	
    	//???????????? ??????
    	FORM_SEARCH = $("#searchForm").serializeObject(); //?????????
    	FORM_SEARCH.unitQuery = unitQuery;
    	FORM_SEARCH.companyCons = $(':radio[name=companyCons]:checked').val();
    	FORM_SEARCH.weekMaterialsAvail = $(':radio[name=weekMaterialsAvail]:checked').val();
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.sql = sqlFlag;
    	FORM_SEARCH.tranData = [{outDs:"dMain",_siq:"dashboard.portal.main"}
    	                      , {outDs:"dBiz" ,_siq:"dashboard.portal.biz"}
    	                      , {outDs:"dDefRate",_siq:"dashboard.portal.defRate"}
    	                      , {outDs : "itemInvList", _siq : "dashboard.portal.itemInvList"}
    	                	  , {outDs : "matInvList", _siq : "dashboard.portal.matInvList"}];
    	
    	
    	var sMap = {
			url: "${ctx}/biz/obj",
            data: FORM_SEARCH,
            success:function(data) {
         	   	
            	dMain    = data.dMain;
             	dBiz     = data.dBiz;
             	dDefRate = data.dDefRate;
             	itemInvData = data.itemInvList;
            	matInvData = data.matInvList;
            	
             	fn_initChart(); //???????????? ?????????.
            }
        }
        gfn_service(sMap,"obj");
    }

    //?????? ?????????
    function fn_initChart() {
    	//????????????	
    	var chartId = "";
    	var chartTxt, chartTxt2, posTxt;
    	var unit = 0;
    	var roundNum = 0;
    	var format = "y:,.0f";
    	var userLang = "${sessionScope.GV_LANG}";
    	var cData1=0, cData2=0, cData3=0, cData4=0, cDataT=0, cDataTT=0, cDataC="green_f";
    	
    	if(userLang == "ko"){
    		unit = 100000000;
    		roundNum = 0;
    		format = "y:,.0f";
    	}else if(userLang == "en" || userLang == "cn"){
    		unit = 1000000000;
    		roundNum = 1;
    		format = "y:,.1f";
    	}
    	
    	//??????????????? ??????
    	var chartMap = {};
    	$.each(dMain, function(n,v) {
    		chartMap[v.MEAS_CD] = v;
    	});
    	
    	//2.????????????
    	if (dBiz.length > 0) {
    		$("#chartBiz").html("");	
    		var inHtml = "";
    		var rAmtY = 0, rAmtM = 0, yRate = 0, mRate = 0;
    		var yRateCls,mRateCls;
    		var tmpAmt1 = "", tmpAmt2 = "";
    		$.each(dBiz, function(n,v) {
				
    			rAmtY    = gfn_getNumberFmt(v.RESULT_AMT_Y / unit, roundNum,'R','Y');
				rAmtM    = gfn_getNumberFmt(v.RESULT_AMT_M / unit, roundNum,'R','Y');
    			
    			yRate    = gfn_getNumberFmt(v.AMT_Y_RATE, 0,'R','Y');
    			mRate    = gfn_getNumberFmt(v.AMT_M_RATE, 0,'R','Y');
    			yRateCls = v.Y_RATE_CLS;
    			mRateCls = v.M_RATE_CLS;
    			
    			<c:if test="${sessionScope.userInfo.dashboardYn == 'Y'}">
    			if (n == 1) {
    				tmpAmt1 = rAmtY+'<spring:message code="lbl.billion"/>';
    				tmpAmt2 = rAmtM+'<spring:message code="lbl.billion"/><sup>1)</sup>';
    				$(".help_txt").show();
    			}
    			</c:if>
    			
    			inHtml += '<tr>';
    			inHtml += '  <td>'+v.MEAS_NM+'</td>';
    		    if (n == 0) inHtml += '  <td>'+rAmtM+'<spring:message code="lbl.billion"/></td>'; 
    		    else inHtml += '  <td>'+tmpAmt2+'</td>';
    		    inHtml += '  <td class="'+mRateCls+'">'+mRate+'%</td>';
    		    if (n == 0) inHtml += '  <td>'+rAmtY+'<spring:message code="lbl.billion"/></td>';
    		    else inHtml += '  <td>'+tmpAmt1+'</td>';
    		    inHtml += '  <td class="'+yRateCls+'">'+yRate+'%</td>';
    		    inHtml += '</tr>';
    		});
    		$("#chartBiz").html(inHtml);
    	}
    	
    	//???????????? ????????????
    	gfn_setHighchartTheme();
    	/*
    	//1.BSC ??????
    	Highcharts.theme.colors[0] = '#133485'; //line ??????
    	cData1=0, cData2=0, cData3=0, cData4=0, cDataT=0, cDataC="green_f";
    	if (!gfn_isNull(chartMap.BSC)) {
    		cData1 = gfn_getNumberFmt(chartMap.BSC.CHART_1, 0,'R');
    		cData2 = gfn_getNumberFmt(chartMap.BSC.CHART_2, 0,'R');
    		cDataT = gfn_getNumberFmt(chartMap.BSC.CHART_T, 0,'R','Y');
    		cDataC = chartMap.BSC.CHART_C;
    	}
    	
    	chartId = "chartBsc";
		$('#chartBscScore_ptag').addClass(cDataC);
		$('#chartBscScore_ptag_strong').html(cDataT)
    	//chartTxt.append('<p class="per_txt '+cDataC+'"><strong>'+cDataT+'</strong></p>');
    	
    	Highcharts.chart(chartId, {
    	    chart: { type: 'line' },
    	    xAxis: { categories: ['<spring:message code="lbl.lastMonth" />', '<spring:message code="lbl.thisMonth" />'] },
    	    plotOptions: {
    	        line: {
    	            dataLabels: { 
    	            	format: '{'+gv_cFormat+'}',
    	            	style: {
    	            		fontSize : "12px",
    	            		fontWeight: ''
    	            	}
    	            },
    	        }
    	    },
    	    series: [{
    	        data: [cData1, cData2]
    	    }]
    	});
    	*/
    	//?????? ?????? ?????? 
    	var arMonth = new Array();
    	var tmpInvData = new Array();

    	$.each (bucket.month, function (i, el) {
    		arMonth.push(el.DISMONTH);
    	});
    	
    	$.each(itemInvData, function(i, val){
    		tmpInvData.push(val.RESULT_VALUE);
    	});
    	
    	chartId = "chartInv1";
    	Highcharts.chart(chartId, {
    	    chart: { type: 'line' },
    	    xAxis: { categories: arMonth },
    	    plotOptions: {
    	        line: {
    	            dataLabels: { 
    	            	format: '{'+gv_cFormat+'}',
    	            	style: {
    	            		fontSize : "12px",
    	            		fontWeight: ''
    	            	}
    	            },
    	        }
    	    },
    	    series: [{
    	        data: tmpInvData
    	    }]
    	});
    	
    	$("#chartInv1").css("overflow", "");
    	
    	//?????? ??????
    	tmpInvData = new Array();
    	
    	$.each(matInvData, function(i, val){
    		tmpInvData.push(val.RESULT_VALUE);
    	});
    	
    	chartId = "chartInv2";
    	Highcharts.chart(chartId, {
    	    chart: { type: 'line' },
    	    xAxis: { categories: arMonth },
    	    plotOptions: {
    	        line: {
    	            dataLabels: { 
    	            	format: '{'+gv_cFormat+'}',
    	            	style: {
    	            		fontSize : "12px",
    	            		fontWeight: ''
    	            	}
    	            },
    	        }
    	    },
    	    series: [{
    	        data: tmpInvData
    	    }]
    	});

    	//4.????????? ??????
    	var columnData = [], lineData = [];
    	var targetDefRate = 0, defDataC="green_f", maxData;
	
		$.each(dDefRate, function(n, v) {
			
			columnData.push({name: v.TEAM_NM, y: gfn_getNumberFmt(v.DEF_RATE, 2, 'R')});
			lineData.push({name: v.TEAM_NM, y: gfn_getNumberFmt(v.TARGET_DEF_RATE, 2, 'R')});
			
			if(n == 0){
				targetDefRate = gfn_getNumberFmt(v.ATTAIN_RATE, 0,'R');
				defDataC = v.CHART_C;
				maxData = v.MAX_DATA;
			}
		});
		
		chartId = "chartDefRate";
		$('#chartDefRateScore_ptag').addClass(defDataC);
		$('#chartDefRateScore_ptag_strong').html(targetDefRate);
		//chartTxt.append('<p class="per_txt '+defDataC+'"><strong>'+targetDefRate+'</strong>%</p>');
		Highcharts.chart(chartId, {
		    xAxis: { type: 'category' },
		    yAxis: [{ // left yAxis
		    	max : maxData
		    }, { // right yAxis
		        opposite: true,
		        max : maxData
		    }],
		    tooltip : {
		    	enabled : false
		    },
		    plotOptions: {
		        column: {
		            dataLabels: {
		                format: '{y:.2f}',
		                style : {
		                	fontSize : "12px",
		                	fontWeight: ''
						}
		            },
	                tooltip: {
	                    pointFormat: '{point.y:.1f}',
	                },
		        },
		        line: {
		            dataLabels: {
		                format: '{y:.2f}',
		                allowOverlap: true,
		                style : {
		                	fontSize : "12px",
		                	fontWeight: ''
						}
		            },
	                tooltip: {
	                	pointFormat: '{point.y:.1f}%',
	                },
		        },
		        series: {
		            lineColor: gv_cColor5
		        }
		    },
		    series: [{
		    	type: 'column',
		        stack: 'A',
		        data: columnData,
		        name:'??????'
		    }, {
		    	type: 'line',
		    	yAxis: 1,
		        data: lineData,
		        name:'??????'
		    }],
		    legend: {
				enabled: true,
				itemStyle : {
					color      : '#000',
					fontSize   : '11px',
					fontWeight : 'normal'
				}
				
			}
		});
    	
    	//5.?????? ??????
		var cData5 = 0, cData6 = 0; 
		cData1=0, cData2=0, cData3=0, cData4=0, cDataT=0, cDataC="green_f";
		if(userLang == "ko"){
			if (!gfn_isNull(chartMap.ACTION_PLAN)) {
	    		cData1 = gfn_getNumberFmt(chartMap.ACTION_PLAN.CHART_1 / unit, 0,'R');  
	    		cData2 = gfn_getNumberFmt(chartMap.ACTION_PLAN.CHART_2 / unit, 0,'R');  
	    		cData3 = gfn_getNumberFmt(chartMap.ACTION_PLAN.CHART_3 / unit, 0,'R');
	    		cData4 = gfn_getNumberFmt(chartMap.ACTION_PLAN.CHART_4 / unit, 0,'R');
	    		cData5 = gfn_getNumberFmt(chartMap.ACTION_PLAN.CHART_5 / unit, 0,'R');
	    		cData6 = gfn_getNumberFmt(chartMap.ACTION_PLAN.CHART_6 / unit, 0,'R');
	    		cDataT = Number(chartMap.ACTION_PLAN.CHART_T.toFixed(0));
	    		cDataC = chartMap.ACTION_PLAN.CHART_C;
	    	}
		}else if(userLang == "en" || userLang == "cn"){
			if (!gfn_isNull(chartMap.ACTION_PLAN)) {
	    		cData1 = gfn_getNumberFmt(chartMap.ACTION_PLAN.CHART_1 / unit, 1,'R');  
	    		cData2 = gfn_getNumberFmt(chartMap.ACTION_PLAN.CHART_2 / unit, 1,'R');  
	    		cData3 = gfn_getNumberFmt(chartMap.ACTION_PLAN.CHART_3 / unit, 1,'R');
	    		cData4 = gfn_getNumberFmt(chartMap.ACTION_PLAN.CHART_4 / unit, 1,'R');
	    		cData5 = gfn_getNumberFmt(chartMap.ACTION_PLAN.CHART_5 / unit, 1,'R');
	    		cData6 = gfn_getNumberFmt(chartMap.ACTION_PLAN.CHART_6 / unit, 1,'R');
	    		cDataT = Number(chartMap.ACTION_PLAN.CHART_T.toFixed(0));
	    		cDataC = chartMap.ACTION_PLAN.CHART_C;
	    	}
		}
		
		// 1 : ?????? ??????, 2 : CPFR ??????, 3 : ?????? ??????, 4 : CPFR ??????, 5 : ?????? ????????????, 6 : CPFR ????????????
		chartId = "chartSales";
		//chartTxt = $("#"+chartId).next();
		$('#chartSalesScore_ptag').addClass(cDataC);
		$('#chartSalesScore_ptag_strong').html(cDataT);
		//chartTxt.append('<p class="per_txt '+cDataC+'"><strong>'+cDataT+'</strong>%</p>');
		
		Highcharts.chart(chartId, {
		    chart: { type: 'column' },
		    xAxis: { categories: ['<spring:message code="lbl.target"/>', '<spring:message code="lbl.salesForecasting"/>'] },
		    yAxis: {
		    	stackLabels: {
		    		allowOverlap : true, //total ???????????? ?????? ?????????
		    		enabled: true,
		    	    style: {
		    	    	fontWeight: '',
		    	        fontSize : "12px"
					}
				}
		    },
		    plotOptions: {
		        column: {
		            dataLabels: {
		                format: '{'+format+'}',
		                style : {
		                	fontSize : "12px",
		                	fontWeight: ''
						}
		            }
		        }
		    },
		    tooltip: {
		    	enabled: false,
		        formatter: function() {
		        	
		        	var x = this.x;
		        	var result = "";
		        	var flag = '<spring:message code="lbl.target"/>';
		        	
		        	if(x == flag){
		        		if(this.colorIndex == 0 || this.colorIndex == 2){
		        			result = '<spring:message code="lbl.cpfrY"/>';
			        	}else{
			        		result = '<spring:message code="lbl.cpfrN"/>';
			        	}
		        	}else{
		        		if(this.colorIndex == 0){
		        			result = '<spring:message code="lbl.cpfrExpResult"/>';
			        	}else if(this.colorIndex == 1){
			        		result = '<spring:message code="lbl.mormalExpResult"/>';
			        	}else if(this.colorIndex == 2){
			        		result = '<spring:message code="lbl.cpfrResult"/>';
			        	}else if(this.colorIndex == 3){
			        		result = '<spring:message code="lbl.normalResult"/>';
			        	}
		        	}
		            return result;
		        }
		    },
		    series: [{
		        data: [{y: cData2, color: gv_cColor6},{y: cData6, color: gv_cColor4}]
		    }, {
		        data: [{y: cData1, color: gv_cColor1},{y: cData5, color: gv_cColor2}]
		    }, {
		        data: [null,{y: cData4, color: gv_cColor3}]
		    },{
		        data: [null,{y: cData3, color: gv_cColor5}]
		    }]
		});
    	
    	//7.?????? ???????????? ?????????
    	//set Data
    	cData1=0, cData2=0, cData3=0, cData4=0, cDataT=0, cDataTT=0, cDataC="green_f";
    	
    	if (!gfn_isNull(chartMap.PROD_COMP)) {
    		cData1  = gfn_getNumberFmt(chartMap.PROD_COMP.CHART_1 / unit, roundNum,'R');  
    		cData2  = gfn_getNumberFmt(chartMap.PROD_COMP.CHART_2 / unit, roundNum,'R');  
    		cDataT  = Number(chartMap.PROD_COMP.CHART_T.toFixed(0));
    		cDataTT = Number(chartMap.PROD_COMP.CHART_TT.toFixed(0));
    		cDataC  = chartMap.PROD_COMP.CHART_C;
    	}
    	
    	chartId   = "chartProdComp";
    	chartTxt  = $("#chartProdCompScore1_ptag");
    	$("#chartProdCompScore1_ptag").addClass(cDataC);
    	$('#chartProdCompScore1_ptag_strong').html(cDataT)
    	
    	chartTxt2 = $("#chartProdCompScore2_ptag");
    	$('#chartProdCompScore2_ptag_strong').html(cDataTT)
    	
    	Highcharts.chart(chartId, {
    	    chart: { type: 'column' },
    	    xAxis: { categories: ['<spring:message code="lbl.target"/>', '<spring:message code="lbl.performance"/>'] },
    	    plotOptions: {
    	        column: {
    	            dataLabels: {
    	                format: '{'+format+'}',
    	                style : {
    	                	fontSize : "12px",
    	                	fontWeight: ''
						}
    	            }
    	        }
    	    },
    	    series: [{
    	    	colorByPoint: true,
    	    	data: [cData1, cData2]
    	    }]
    	});

    	//8.?????? ???????????? ?????????
    	//set Data
    	cData1=0, cData2=0, cData3=0, cData4=0, cDataT=0, cDataTT=0, cDataC="green_f";
    	
    	if (!gfn_isNull(chartMap.SALES_COMP)) {
    		cData1  = gfn_getNumberFmt(chartMap.SALES_COMP.CHART_1 / unit, roundNum,'R');  
    		cData2  = gfn_getNumberFmt(chartMap.SALES_COMP.CHART_2 / unit, roundNum,'R');
    		cData3  = gfn_getNumberFmt(chartMap.SALES_COMP.CHART_3 / unit, roundNum,'R');
    		cData4  = gfn_getNumberFmt(chartMap.SALES_COMP.CHART_4 / unit, roundNum,'R');
    		cDataT  = Number(chartMap.SALES_COMP.CHART_T.toFixed(0));
    		cDataTT = Number(chartMap.SALES_COMP.CHART_TT.toFixed(0));
    		cDataC  = chartMap.SALES_COMP.CHART_C;
    	}
    	
    	chartId   = "chartSalesComp";
    	$('#chartSalesCompScore1_ptag').addClass(cDataC);
    	$('#chartSalesCompScore1_ptag_strong').html(cDataT);
    	//chartTxt.append('<p class="per_txt '+cDataC+'"><strong>'+cDataT+'</strong>%</p>');

    	$('#chartSalesCompScore2_ptag_strong').html(cDataTT);
    	//chartTxt2.append('<p style="color:#a0a0a0;"><strong style="font-size:30px;">'+cDataTT+'</strong>%</p>');
    	
    	Highcharts.chart(chartId, {
    	    chart: { type: 'column' },
    	    xAxis: { categories: ['<spring:message code="lbl.target"/>', '<spring:message code="lbl.performance"/>'] },
    	    yAxis: {
    	    	stackLabels: {
    	    		enabled: true,
    	    	    style: {
    	    	    	fontWeight: '',
    	    	        fontSize : "12px"
    	    	        
					}
				}
    	    },
    	    tooltip: {
    	    	enabled: false,
    	        formatter: function() {
    	        	
    	        	var result = "";
    	        	
    	        	if(this.colorIndex == 0){
    	        		result = '<spring:message code="lbl.cpfrY"/>';
    	        	}else{
    	        		result = '<spring:message code="lbl.cpfrN"/>';
    	        	}
    	        	
    	            return result;
    	        }
    	    },
    	    plotOptions: {
    	        column: {
    	            dataLabels: {
    	                format: '{'+format+'}',
    	                style : {
    	                	fontSize : "12px",
    	                	fontWeight: ''
						}
    	            }
    	        }
    	    },
    	    series: [{
    	        data: [{y: cData3, color: gv_cColor6}, {y: cData4, color: gv_cColor4}]
    	    },{
    	        data: [{y: cData1, color: gv_cColor1}, {y: cData2, color: gv_cColor2}]
    	    }]
    	});

    	//9.?????? ?????? ?????????
    	//set Data
    	cData1=0, cData2=0, cData3=0, cData4=0, cDataT=0, cDataC="green_f";
    	if (!gfn_isNull(chartMap.MAT_PREP_RATE)) {
    		cData1 = chartMap.MAT_PREP_RATE.CHART_1;       
    		cData2 = chartMap.MAT_PREP_RATE.CHART_2;       
    		cDataT = Number(chartMap.MAT_PREP_RATE.CHART_T.toFixed(0));
    		cDataC = chartMap.MAT_PREP_RATE.CHART_C;
    	}
    	
    	chartId = "chartMatPrepRate";
    	$("#chartMatPrepRate_changeRate").addClass(cDataC);
    	$("#chartMatPrepRate_changeRate_strong").html(cDataT);
    	//chartTxt.append('<p class="per_txt '+cDataC+'"><strong>'+cDataT+'</strong>%</p>');
    	Highcharts.chart(chartId, {
    	    chart: { type: 'column' },
    	    xAxis: { categories: ['<spring:message code="lbl.target"/>', '<spring:message code="lbl.actual"/>'] },
    	    plotOptions: {
    	        column: {
    	            dataLabels: {
    	                format: '{'+gv_cFormat+'}%',
    	                style : {
    	                	fontSize : "12px",
    	                	fontWeight: ''
						}
    	            }
    	        }
    	    },
    	    series: [{
    	    	colorByPoint: true,
    	        data: [cData1, cData2]
    	    }]
    	});
    }
    
    function companyConsSearch(sqlFlag){
    	
    	
    	FORM_SEARCH = {}
    	FORM_SEARCH.unitQuery = unitQuery;
    	FORM_SEARCH.PORTAL_YN = "Y";
    	FORM_SEARCH.companyCons = $(':radio[name=companyCons]:checked').val();
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.tranData = [
    		{outDs : "itemInvList", _siq : "dashboard.portal.itemInvList"}
    	];
    	
    	var sMap = {
    		url	 : "${ctx}/biz/obj",
    		data	: FORM_SEARCH,
    		success : function(data) {
    			
    			var arMonth = new Array();
    			var tmpInvData = new Array();

    			$.each (bucket.month, function (i, el) {
    				arMonth.push(el.DISMONTH);
    			});
    			
    			$.each(data.itemInvList, function(i, val){
    				tmpInvData.push(val.RESULT_VALUE);
    			});
    			
    			var chartId = "chartInv1";
    			Highcharts.chart(chartId, {
    			    chart: { type: 'line' },
    			    xAxis: { categories: arMonth },
    			    plotOptions: {
    			        line: {
    			            dataLabels: { 
    			            	format: '{'+gv_cFormat+'}',
    			            	style: {
    			            		fontSize : "12px",
    			            		fontWeight: ''
    			            	}
    			            },
    			        }
    			    },
    			    series: [{
    			        data: tmpInvData
    			    }]
    			});
    			$("#chartInv1").css("overflow", "");
    		}
    	}
    	gfn_service(sMap, "obj");
    }
    
    function weekMaterialsAvailSearch(sqlFlag){
    	
    	FORM_SEARCH = {}
    	FORM_SEARCH.unitQuery = unitQuery;
    	FORM_SEARCH.PORTAL_YN = "Y";
    	FORM_SEARCH.weekMaterialsAvail = $(':radio[name=weekMaterialsAvail]:checked').val();
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.tranData = [
    		{outDs : "weekMaterialsAvail", _siq : "dashboard.portal.weekMaterialsAvail"}
    	];
    	var xAxisCategories = [];
    	if($(':radio[name=weekMaterialsAvail]:checked').val()=='')
    	{
    		xAxisCategories = ['<spring:message code="lbl.target"/>','<spring:message code="lbl.actual"/>'];
    	}
    	else
    	{
    		xAxisCategories = ['<spring:message code="lbl.target"/>','<spring:message code="lbl.actual"/>'];
    	}
    	
    	
    	var sMap = {
    		url	 : "${ctx}/biz/obj",
    		data	: FORM_SEARCH,
    		success : function(data) {
    			
    			
    			chartId = "chartMatPrepRate";
    	    	chartTxt = $("#chartMatPrepRate_changeRate");
    	    	chartTxt.empty();
    	    	chartTxt.append('<p class="per_txt '+data.weekMaterialsAvail[0].CHART_C+'"><strong>'+Number(data.weekMaterialsAvail[0].CHART_T.toFixed(0))+'</strong>%</p>');
    	    	
    	    	Highcharts.chart(chartId, {
    	    	    chart: { type: 'column' },
    	    	    xAxis: { categories: xAxisCategories },
        			plotOptions: {
    	    	        column: {
    	    	            dataLabels: {
    	    	                format: '{'+gv_cFormat+'}%',
    	    	                style : {
    	    	                	fontSize : "12px",
    	    	                	fontWeight: ''
    							}
    	    	            }
    	    	        }
    	    	    },
    	    	    series: [{
    	    	    	colorByPoint: true,
    	    	        data: [data.weekMaterialsAvail[0].CHART_1, data.weekMaterialsAvail[0].CHART_2]
    	    	    }]
    	    	});
    	    	$("#chartMatPrepRate").css("overflow", "");
    			
    		}
    	}
    	gfn_service(sMap, "obj");	
    	
    	
    }
    
  //??????, ?????? ???????????? ?????? ??????
    function fn_excelSqlAuth() {
    	
    	gfn_service({
    	    async   : false,
    	    url     : GV_CONTEXT_PATH + "/biz/obj",
    	    data    : {
       			_mtd : "getList",
       			tranData : [
       				{outDs : "authorityList", _siq : "dashboard.portal.mainExcelSql"}
       			]
    	    },
    	    success :function(data) {
    	    	
    	    	for(i=0;i<data.authorityList.length;i++)
    	    	{
    	    		if(data.authorityList[i].USE_FLAG == "Y")
    	    		{
    	    			$("#sql").show();
    	    		}
    	    		
    	    	}
    	    		
    	    }
    	}, "obj");
    }

    var fn_popupCallback = function () {
    	 location.reload();
    }
    
    
    //??????
function fn_search(sqlFlag) {
  
  FORM_SEARCH = {}
  FORM_SEARCH._mtd = "getList";
  FORM_SEARCH.tranData = [
  
    
      
  ];
  
  var sMap = {
      url  : "${ctx}/biz/obj",
      data    : FORM_SEARCH,
      success : function(data) {
          
      
      }
  }
  gfn_service(sMap, "obj");
  
  
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
      0. bscGeneral                         quill_1
      
      1. businessPerformance                quill_2
      5. productInventoryStatus             quill_3
      2. defectiveRate                      quill_4
      3. expectedToShip                     quill_5
      4. materialStock                      quill_6
      7. weeklyProductionPlanComplianceRate quill_7
      8. weeklyShippingPlanComplianceRate   quill_8
      6. weeklyMaterialAvailabilityRate     quill_9
      
      */
      
      
      for(i=0;i<9;i++)
      {
          if(FORM_SEARCH.chartList[i].ID=="bscGeneral")                             FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_1.setContents([{ insert: '\n' }]):quill_1.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
          else if(FORM_SEARCH.chartList[i].ID=="businessPerformance")               FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_2.setContents([{ insert: '\n' }]):quill_2.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
          else if(FORM_SEARCH.chartList[i].ID=="productInventoryStatus")            FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_3.setContents([{ insert: '\n' }]):quill_3.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
          else if(FORM_SEARCH.chartList[i].ID=="defectiveRate")                     FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_4.setContents([{ insert: '\n' }]):quill_4.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
          else if(FORM_SEARCH.chartList[i].ID=="expectedToShip")                    FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_5.setContents([{ insert: '\n' }]):quill_5.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
          else if(FORM_SEARCH.chartList[i].ID=="materialStock")                     FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_6.setContents([{ insert: '\n' }]):quill_6.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
          else if(FORM_SEARCH.chartList[i].ID=="weeklyProductionPlanComplianceRate")FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_7.setContents([{ insert: '\n' }]):quill_7.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
          else if(FORM_SEARCH.chartList[i].ID=="weeklyShippingPlanComplianceRate")  FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_8.setContents([{ insert: '\n' }]):quill_8.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
          else if(FORM_SEARCH.chartList[i].ID=="weeklyMaterialAvailabilityRate")    FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_9.setContents([{ insert: '\n' }]):quill_9.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
                                      
      }
      
      
      
  }

  
  function fn_popUpAuthorityHasOrNot(){
	    
	    SCM_SEARCH = {}; // ?????????
	    
	    SCM_SEARCH.USER_ID = "${sessionScope.userInfo.userId}" ;
	    
	    
	    SCM_SEARCH._mtd     = "getList";
	    SCM_SEARCH.tranData = [
	                           { outDs : "isSCMTeam",_siq : "dashboard.chartInfo.isSCMTeam"}
	                        ];
	    
	    
	    
	    var aOption = {
	        async   : false,
	        url     : GV_CONTEXT_PATH + "/biz/obj",
	        data    : SCM_SEARCH,
	        success : function (data) {
	        
	            if (SCM_SEARCH.sql == 'N') {
	                
	                SCM_SEARCH.isSCMTeam = data.isSCMTeam[0].isSCMTeam;
	            
	            }
	        }
	    }
	    
	    gfn_service(aOption, "obj");
	    
	    
	    
	    
	}
  

    
    </script>

</head>
<body id="framesb" class="portalFrame">
	<jsp:include page="/WEB-INF/view/layout/commonForm.jsp" flush="false">
		<jsp:param name="siteMapYn" value="Y"/>
	</jsp:include>
	
	<!-- contents -->
	<div id="grid1" class="fconbox">
		<div class="location">
			<img src="${ctx}/statics/images/common/ico_home.gif" alt="">
			<div class="fnc">
				<a href="#" id='chartConfig' class="viewfnc8"><img src="${ctx}/statics/images/common/grid.png" style="margin-top:-3px;" title="CHART Config"></a>
				<a href="#" id='sql' style="display:none"class="viewfnc4"><img src="${ctx}/statics/images/common/btn_gun4.gif" title="SQL View"></a>
			</div>
		</div>
		<div class="scroll" style="height:calc(100% - 35px)">
			<!-- chart -->
			<div id="container" style="float: left">
		    	<div id="cont_chart">
					<!-- 1??? 3?????? ????????? ????????? ?????? col_3 ?????? ???????????? ??????????????? ????????? -->
			       	<!-- BSC ?????? -->
			       	<div class="col_3">
			       	  <div class="titleContainer">
			           	<h4 id="bscGeneralH4"><spring:message code="lbl.bscSummary"/></h4>
			             <div class="view_combo">
			                 <ul class="rdofl">
			                 
			                     <li class="manuel">
                                    <a href="#" id="bscGeneral"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                 </li>
			                 
			                 </ul>
			             </div>
			          </div> 
				      
		              <div class="graphwrap" id="chartBsc" style="clear:both;"></div>
		               
		              <div class="textwrap" id="chartBscScore" >
		            	<!--  <p><spring:message code="lbl.score"/></p> -->
		            	<p class="per_txt" id="chartBscScore_ptag"><strong id="chartBscScore_ptag_strong"></strong></p>
	                  </div>
	                   
	                   <div class="modal" id="bscGeneralContent" style="display:none;">
	                       <div class="modal_header"></div>
	                       <div class="modal_content">
	                           <div id="editor-1"></div>
	                       </div>
	                   </div>
	                   
					</div>
					<!-- ???????????? -->
			        <div class="col_3">
			        	<div class="titleContainer">
			        	    <h4 id="businessPerformanceH4"><spring:message code="lbl.bizActualChart"/></h4>
			        	    <div class="view_combo">
                             <ul class="rdofl">
                             
                                <li class="manuel">
                                    <a href="#" id="businessPerformance"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                 </li>
                             
                             </ul>
                             </div>
			        	    
			            </div>
			            <div class="tablewrap" id="businessPerformanceTable"  style="height:calc(100% - 35px);">
			               	<table style="height:100%">
			                   	<caption><spring:message code="lbl.bizActualChart"/></caption>
								<thead>
								    <tr>
								      <th scope="col" rowspan="2"><spring:message code="lbl.divisionChart"/></th>
								      <th scope="col" colspan="2"><spring:message code="lbl.thisMonth"/></th>
								      <th scope="col" colspan="2"><spring:message code="lbl.yearChart"/></th>
								    </tr>
								    <tr>
								      <th scope="col"><spring:message code="lbl.performance"/></th>
								      <th scope="col"><spring:message code="lbl.achieRateChart2"/></th>
								      <th scope="col"><spring:message code="lbl.performance"/></th>
								      <th scope="col"><spring:message code="lbl.achieRateChart2"/></th>
								    </tr>
								</thead>
							  	<tbody id="chartBiz">
							  		<tr>
								    	<td><spring:message code="lbl.salesChart"/></td>
								      	<td class="red_f">0<spring:message code="lbl.billion"/></td>
								      	<td>0%</td>
								      	<td>0<spring:message code="lbl.billion"/></td>
								      	<td class="green_f">0%</td>
								    </tr>
								    <tr>
								      	<td><spring:message code="lbl.operationProfit"/></td>
								      	<td class="red_f"></td>
								      	<td>0%</td>
								      	<td></td>
								      	<td class="green_f">0%</td>
								    </tr>
							  	</tbody>
							</table>
							<p class="help_txt" style="display:none;">1) <spring:message code="lbl.expActualChart"/></p>
						</div>
						<div class="modal" id="businessPerformanceContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-2"></div>
                           </div>
                       </div>
			        </div>
			        <!-- ?????? ?????? ?????? -->
			        <div class="col_3">
			        	
			        	<div class="titleContainer">	
				            <h4 id="productInventoryStatusH4"><spring:message code="lbl.prodInvStatusChart"/> (<spring:message code="lbl.prevDayChart"/>, <spring:message code="lbl.hMillion"/>)</h4>
				        	<div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="companyCons1" name="companyCons" value="companyCons"/> <label for="companyCons1"><spring:message code="lbl.companyCons" /></label></li>
									<li><input type="radio" id="companyCons2" name="companyCons" value="company" checked="checked"/> <label for="companyCons2"><spring:message code="lbl.company2" /> </label></li>
								    
									    <li class="manuel">
	                                        <a href="#" id="productInventoryStatus"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                    </li>
                                    
								</ul>
								
							</div>
						</div>
			        	<div style="height: 100%;clear:both;" id="chartInv1"></div>
			            <div class="modal" id="productInventoryStatusContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-3"></div>
                           </div>
                       </div>
			            <%-- <div class="graphwrap" id="chartInv1"></div>
			            <div class="textwrap">
			            	<p><spring:message code="lbl.changeRate"/></p>
		                </div> --%>
			        </div>
			       	<!-- ????????? -->
			        <div class="col_3">
			        	<div class="titleContainer">
			        	    <h4 id="defectiveRateH4"><spring:message code="lbl.defectRateChart"/> (<spring:message code="lbl.thisMonth"/>)</h4>
			        	    <div class="view_combo">
                                <ul class="rdofl">
                                    
	                                    <li class="manuel">
	                                        <a href="#" id="defectiveRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                    </li>
                                    
                                </ul>
                            </div>
			        	    
			        	</div>
			        	<!-- <div style="height: 88%" id="chartDefRate"></div> -->
			            <div class="graphwrap" id="chartDefRate" style="clear:both;"></div>
			            <div class="textwrap" id="chartDefRateScore">
		                	<p><spring:message code="lbl.achieRateChart2"/></p>
		                	<p class="per_txt" id="chartDefRateScore_ptag"><strong id="chartDefRateScore_ptag_strong"></strong>%</p>
		                </div>
		                <div class="modal" id="defectiveRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-4"></div>
                           </div>
                       </div>
			        </div>
			        <!-- ?????? ?????? -->
			   		<div class="col_3">
			   		    <div class="titleContainer">
			   		        <h4 id="expectedToShipH4"><spring:message code="lbl.shipmentForecasting"/> (<spring:message code="lbl.thisMonth"/>, <spring:message code="lbl.hMillion"/>)</h4>
			   		        <div class="view_combo">
                                <ul class="rdofl">
                                    
	                                    <li class="manuel">
	                                        <a href="#" id="expectedToShip"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                    </li>
                                    
                                </ul>
                            </div>    
			   		    </div>
			        	
			            <div class="graphwrap" id="chartSales" style="clear:both;"></div>
			            <div class="textwrap" id="chartSalesScore">
			            	<p><spring:message code="lbl.achieRateChart2"/>(<spring:message code="lbl.chartPredict"/>)</p>
			            	<p class="per_txt" id="chartSalesScore_ptag"><strong id="chartSalesScore_ptag_strong"></strong>%</p>
		                </div>
		                <div class="modal" id="expectedToShipContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-5"></div>
                           </div>
                       </div>
			        </div>
			        <!-- ?????? ?????? -->
			        <div class="col_3">
			        	<div class="titleContainer">
			        	    <h4 id="materialStockH4"><spring:message code="lbl.matInv"/> (<spring:message code="lbl.prevDayChart"/>, <spring:message code="lbl.hMillion"/>)</h4>
			        	    <div class="view_combo">
                                <ul class="rdofl">
                                    
	                                    <li class="manuel">
	                                        <a href="#" id="materialStock"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                    </li>
                                    
                                </ul>
                            </div>
			        	</div>
			        	<div style="height: 100%;clear:both;" id="chartInv2"></div>
			            <div class="modal" id="materialStockContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-6"></div>
                           </div>
                       </div>
			            <%-- <div class="graphwrap" id="chartInv2"></div>
			            <div class="textwrap">
			            	<p><spring:message code="lbl.changeRate"/></p>
		                </div> --%>
			        </div>
			        <!-- ?????? ?????? ?????? ????????? -->
			        <div class="col_3">
			            <div class="titleContainer">
			                <h4 id="weeklyProductionPlanComplianceRateH4"><spring:message code="lbl.weekPpcr"/><span class="cweekTxt"></span></h4>
			                <div class="view_combo">
                                <ul class="rdofl">
                                    
	                                    <li class="manuel">
	                                        <a href="#" id="weeklyProductionPlanComplianceRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                    </li>
                                    
                                </ul>
                            </div>
			             </div>
			        	
			            <div class="graphwrap" id="chartProdComp"></div>
			            <div class="textwrap" id="chartProdCompScore1">
			            	<p><spring:message code="lbl.cmplRateChart"/></p>
			            	<p class="per_txt" id="chartProdCompScore1_ptag"><strong id="chartProdCompScore1_ptag_strong"/></strong>%</p>
		                </div>
		                <div class="textwrap" id="chartProdCompScore2">
		                	<p><spring:message code="lbl.targetPrevDay"/></p>
		                	<p style="color:#a0a0a0;"><strong id = "chartProdCompScore2_ptag_strong" style="font-size:30px;"></strong>%</p>
		                </div>
		                <div class="modal" id="weeklyProductionPlanComplianceRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-7"></div>
                           </div>
                       </div>
			        </div>
			        <!-- ?????? ?????? ?????? ????????? -->
			   		<div class="col_3">
			   		    <div class="titleContainer">
			        	    <h4 id="weeklyShippingPlanComplianceRateH4"><spring:message code="lbl.weekSpcr"/><span class="cweekTxt"></span></h4>
			                <div class="view_combo">
                                <ul class="rdofl">
                                    
	                                    <li class="manuel">
	                                        <a href="#" id="weeklyShippingPlanComplianceRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                    </li>
                                    
                                </ul>
                            </div>
			            </div>
			            <div class="graphwrap" id="chartSalesComp"></div>
			            <div class="textwrap" id="chartSalesCompScore1">
			            	<p><spring:message code="lbl.cmplRateChart"/></p>
			            	<p class="per_txt" id = "chartSalesCompScore1_ptag"><strong id = "chartSalesCompScore1_ptag_strong"></strong>%</p>
		                </div>
		                <div class="textwrap" id="chartSalesCompScore2">
		                	<p><spring:message code="lbl.targetPrevDay"/></p>
		                	<p style="color:#a0a0a0;"><strong style="font-size:30px;" id="chartSalesCompScore2_ptag_strong"></strong>%</p>
		                </div>
		                <div class="modal" id="weeklyShippingPlanComplianceRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-8"></div>
                           </div>
                       </div>
			        </div>
			        <!-- ?????? ?????? ????????? -->
			        <div class="col_3">
						<div class="titleContainer">				        
				            <h4 id="weeklyMaterialAvailabilityRateH4"><spring:message code="lbl.weekMpr"/><span class="pweekTxt"></span></h4>
				        	<div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="weekMaterialsAvail1" name="weekMaterialsAvail" value="rawMaterials" checked="checked"/> <label for="weekMaterialsAvail1"><spring:message code="lbl.rawMaterial" /></label></li>
									<li><input type="radio" id="weekMaterialsAvail2" name="weekMaterialsAvail" value="outerHalfProduct" /> <label for="weekMaterialsAvail2"><spring:message code="lbl.osfp" /> </label></li>
								    
									    <li class="manuel">
	                                        <a href="#" id=weeklyMaterialAvailabilityRate><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                    </li>
                                    
								</ul>
								
							</div>
			            </div>
			            <div class="graphwrap" style="clear:both;" id="chartMatPrepRate"></div>
			            <div class="textwrap" id="chartMatPrepRateScore">
			            	<p><spring:message code="lbl.changeRate"/></p>
			            	<p class="per_txt" id="chartMatPrepRate_changeRate"><strong id ="chartMatPrepRate_changeRate_strong"></strong>%</p>
			            </div>
			            <div class="modal" id="weeklyMaterialAvailabilityRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-9"></div>
                           </div>
                       </div>
			        </div>
			  </div>
			</div>
			<div id="cont_chart3">
				<div id="cont_chart">
					<div class="col_3" style="height:100%;width:100%;margin: 0;padding:0">
			            <div id="sitemappop" style="margin: 0; display:block; height:calc(100% - 30px);width:100%;">
							<div class="drag">
<!-- 								<div class="pop_tit">Site Map</div> -->
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
