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
	
	#cont_chart .col_3:nth-child(odd) { margin:0; width:calc(33.333% - 1px); height:calc((100% - 4px) / 3);padding:8px; position:relative;}
	#cont_chart .col_3:nth-child(even) { margin:0; width:calc(66.667% - 1px); height:calc((100% - 4px) / 3);padding:8px; position:relative;}

	#cont_chart .col_3:nth-child(1) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(2) {margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(3) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(4) {margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(5) {margin:0 2px 0 0;}
	#cont_chart .col_3 .textwrap { padding : 5px 0 0 0; }
	
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
	var quill_1,quill_2,quill_3,quill_4,quill_5,quill_6;
	var mainList,subList;
    $(function() {
    	gfn_formLoad(); //공통 폼 초기 정보 설정
    	fn_siteMap();
    	fn_init();
    	fn_initEvent();
    	fn_apply();
    });
    
    function fn_init() {
    	
    	fn_quilljsInit();
    	
    }
    
    
    function fn_initEvent() {
    
        $(".manuel > a").dblclick("on", function() {
            
            var chartId  = this.id;
        
            fn_popUpAuthorityHasOrNot();
            
            var isSCMTeam = SCM_SEARCH.isSCMTeam;
            
            if(isSCMTeam>=1)
            {
            
            //금주 출하 진척률
            if(chartId == "shipmentProgressThisWeek")
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
            //대표 거래처 그룹별 금주 출하 진척률
            else if(chartId == "shipmentProgressRateThisWeekByRepresentativeCustomerGroup")
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
            //대표 거래처 그룹별 당월 출하 예상
            else if(chartId == "expectedMonthlyShipmentsByRepresentativeCustomerGroup1")
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
            //대표 거래처 그룹별 당월 출하 예상
            else if(chartId == "expectedMonthlyShipmentsByRepresentativeCustomerGroup2")
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
            //연간 출하 예상
            else if(chartId == "estimatedAnnualShipments")
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
            //대표 거래처 그룹별 연간 출하 예상
            else if(chartId == "annualShipmentForecastByRepresentativeCustomerGroup")
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
         
            
          //금주 출하 진척률
            if(chartId == "shipmentProgressThisWeek")
            {
                $('#chart1,#shipmentProgressThisWeekScore1,#shipmentProgressThisWeekScore2').toggle();
                $('#shipmentProgressThisWeekContent').toggle();
 
            }
            
            //대표 거래처 그룹별 금주 출하 진척률
            else if(chartId == "shipmentProgressRateThisWeekByRepresentativeCustomerGroup")
            {
                $('#chart2').toggle();
                $('#shipmentProgressRateThisWeekByRepresentativeCustomerGroupContent').toggle();
            }
            //대표 거래처 그룹별 당월 출하 예상
            else if(chartId == "expectedMonthlyShipmentsByRepresentativeCustomerGroup1")
            {
                $('#chart3,#expectedMonthlyShipmentsByRepresentativeCustomerGroup1Score').toggle();
                $('#expectedMonthlyShipmentsByRepresentativeCustomerGroup1Content').toggle();
            }
            //대표 거래처 그룹별 당월 출하 예상
            else if(chartId == "expectedMonthlyShipmentsByRepresentativeCustomerGroup2")
            {
                $('#chart4').toggle();
                $('#expectedMonthlyShipmentsByRepresentativeCustomerGroup2Content').toggle();
            }
            //연간 출하 예상
            else if(chartId == "estimatedAnnualShipments")
            {
                $('#chart5,#estimatedAnnualShipmentsScore').toggle();
                $('#estimatedAnnualShipmentsContent').toggle();
            }
            //대표 거래처 그룹별 연간 출하 예상
            else if(chartId == "annualShipmentForecastByRepresentativeCustomerGroup")
            {
                $('#chart6').toggle();
                $('#annualShipmentForecastByRepresentativeCustomerGroupContent').toggle();
            }
            
        });
        
        
        
        
        $(".titleContainer > h4").hover(function() {
            
            var chartId  = this.id;
            
            //금주 출하 진척률
            if(chartId == "shipmentProgressThisWeekH4")
            {
            	$('#chart1,#shipmentProgressThisWeekScore1,#shipmentProgressThisWeekScore2').toggle();
            	$('#shipmentProgressThisWeekContent').toggle();
 
            }
            
            //대표 거래처 그룹별 금주 출하 진척률
            else if(chartId == "shipmentProgressRateThisWeekByRepresentativeCustomerGroupH4")
            {
            	$('#chart2').toggle();
                $('#shipmentProgressRateThisWeekByRepresentativeCustomerGroupContent').toggle();
            }
            //대표 거래처 그룹별 당월 출하 예상
            else if(chartId == "expectedMonthlyShipmentsByRepresentativeCustomerGroup1H4")
            {
            	$('#chart3,#expectedMonthlyShipmentsByRepresentativeCustomerGroup1Score').toggle();
                $('#expectedMonthlyShipmentsByRepresentativeCustomerGroup1Content').toggle();
            }
            //대표 거래처 그룹별 당월 출하 예상
            else if(chartId == "expectedMonthlyShipmentsByRepresentativeCustomerGroup2H4")
            {
            	$('#chart4').toggle();
                $('#expectedMonthlyShipmentsByRepresentativeCustomerGroup2Content').toggle();
            }
            //연간 출하 예상
            else if(chartId == "estimatedAnnualShipmentsH4")
            {
            	$('#chart5,#estimatedAnnualShipmentsScore').toggle();
                $('#estimatedAnnualShipmentsContent').toggle();
            }
            //대표 거래처 그룹별 연간 출하 예상
            else if(chartId == "annualShipmentForecastByRepresentativeCustomerGroupH4")
            {
            	$('#chart6').toggle();
                $('#annualShipmentForecastByRepresentativeCustomerGroupContent').toggle();
            }
            
        });
        
    	var arrTitle = $(".col_3 > .titleContainer > h4");
    	$.each(arrTitle, function(n,v) {
    		$(v).css("cursor", "pointer");
    		$(v).on("click", function() { 
    			if (n == 0) gfn_newTab("MP104");
    			else if (n == 1) gfn_newTab("MP104");
    			else if (n == 2) gfn_newTab("SNOP203");
    			else if (n == 3) gfn_newTab("SNOP203");
    			else if (n == 4) gfn_newTab("SNOP202");
    			else if (n == 5) gfn_newTab("SNOP202");
    		});
    	});
    }
    
    //조회
    function fn_apply(sqlFlag) {
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql = sqlFlag;
    	
    	//메인 데이터를 조회
    	fn_getChartData();
    }
    
    function fn_getChartData() {
    	
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.tranData = [
    		                    {outDs:"mainList",_siq:"dashboard.sales.main"}
    	                      , {outDs:"subList",_siq:"dashboard.sales.sub"}
    	                      , {outDs: "chartList" , _siq : "dashboard.chartInfo.demandDashboard" }
    	                   ];
    	var sMap = {
            url: "${ctx}/biz/obj",
            data: FORM_SEARCH,
            success:function(data) {
            	mainList = data.mainList;
            	subList  = data.subList;
            	FORM_SEARCH.chartList = data.chartList
            	fn_initChart();
            	fn_chartContentInit();
            }
        }
        gfn_service(sMap,"obj");
    }

    //차트 초기화
    function fn_initChart() {
    	//변수선언	
    	var chartId = "";
    	var chartTxt, chartTxt2, posTxt;
    	var unit = 0;
    	var format = "y:,.0f";
    	var roundNum = 0;
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
    	
    	//차트데이터 설정
    	var chartMap = {};
    	$.each(mainList, function(n,v) {
    		chartMap[v.MEAS_CD] = v;
    	});

    	//테마적용 공통함수
    	gfn_setHighchartTheme();
    	
    	//1.금주 판매 진척률
    	//set Data
    	cData1=0, cData2=0, cData3=0, cData4=0, cDataT=0, cDataTT=0, cDataC="green_f";
    	
    	if (!gfn_isNull(chartMap.SALES_PLAN)) {
    		cData1  = gfn_getNumberFmt(chartMap.SALES_PLAN.CHART_1 / unit, roundNum, 'R');
    		cData2  = gfn_getNumberFmt(chartMap.SALES_PLAN.CHART_2 / unit, roundNum, 'R');  
    		cData3  = gfn_getNumberFmt(chartMap.SALES_PLAN.CHART_3 / unit, roundNum, 'R');
    		cData4  = gfn_getNumberFmt(chartMap.SALES_PLAN.CHART_4 / unit, roundNum, 'R');
    	}
    	
    	cDataT  = Number((chartMap.SALES_PLAN.CHART_T).toFixed(0));
		cDataTT = Number((chartMap.SALES_PLAN.CHART_TT).toFixed(0));
		cDataC  = chartMap.SALES_PLAN.CHART_C;
		
    	chartId   = "chart1";
    	chartTxt  = $("#"+chartId).next();
    	chartTxt2 = $("#"+chartId).next().next();
    	chartTxt.append('<p class="per_txt '+cDataC+'"><strong>'+cDataT+'</strong>%</p>');
    	chartTxt2.append('<p class="per_txt" style="color:#a0a0a0;"><strong style="font-size:30px;">'+cDataTT+'</strong>%</p>');
    	Highcharts.chart(chartId, {
    	    chart: { type: 'column' },
    	    xAxis: { categories: ['<spring:message code="lbl.target"/>', '<spring:message code="lbl.performance"/>'] },
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
    	    /* series: [{
    	    	colorByPoint: true,
    	        data: [cData1, cData2]
    	    }] */
    	});
    	
    	//2.대표 거래처 그룹별 당월 판매 예상
    	//set Data
    	cData1=0, cData2=0, cData3=0, cData4=0, cDataT=0, cDataC="green_f";
    	if (!gfn_isNull(chartMap.ACTION_PLAN)) {
    		
    		cData1 = gfn_getNumberFmt(chartMap.ACTION_PLAN.CHART_1 / unit, roundNum, 'R');  
    		cData2 = gfn_getNumberFmt(chartMap.ACTION_PLAN.CHART_2 / unit, roundNum, 'R');  
    		cData3 = gfn_getNumberFmt(chartMap.ACTION_PLAN.CHART_3 / unit, roundNum, 'R');
    		cData4 = gfn_getNumberFmt(chartMap.ACTION_PLAN.CHART_4 / unit, roundNum, 'R');
    		
    		cDataT = Number((chartMap.ACTION_PLAN.CHART_T).toFixed(0));
    		cDataC = chartMap.ACTION_PLAN.CHART_C;
    	}
    	
    	chartId = "chart3";
    	chartTxt = $("#"+chartId).next();
    	chartTxt.append('<p class="per_txt '+cDataC+'"><strong>'+cDataT+'</strong>%</p>');
    	Highcharts.chart(chartId, {
    	    chart: { type: 'column' },
    	    xAxis: { categories: ['<spring:message code="lbl.bizGoal"/>','<spring:message code="lbl.curMonthGoal"/>', '<spring:message code="lbl.salesForecasting"/>'] },
    	    yAxis: {
    	    	stackLabels:{
    	    		enabled : true,
    	    		style   : {
    	    			fontWeight:'bold'
    	    		},
    	    		formatter : function() {
    	    			var x = this.x;
    	    			
    	    			if(x == 2) {
    	    				var tot      = "";

    	    				if(userLang == "ko") {
    	    					tot = gfn_getNumberFmt((cData2 + cData3), 0,'R','Y');
    	    				} else if(userLang == "en" || userLang == "cn") {
    	    					tot = parseFloatWithCommas(parseFloat(cData2 + cData3).toFixed(1), 1);
    	    				}

    	    				return tot;
    	    			}
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
    	    series: [{
    	        data: [{y : cData4, color : gv_cColor4},{y: cData1, color: gv_cColor1},{y: cData3, color: gv_cColor3}]
    	    },{
    	        data: [null,null,{y: cData2, color: gv_cColor2}]
    	    }]
    	});

    	//3.연간 출하 예상
    	//set Data
    	cData1=0, cData2=0, cData3=0, cData4=0, cDataT=0, cDataC="green_f";
    	if (!gfn_isNull(chartMap.BIZ_PLAN)) {
    		
    		cData1 = gfn_getNumberFmt(chartMap.BIZ_PLAN.CHART_1 / unit, roundNum, 'R');  
    		cData2 = gfn_getNumberFmt(chartMap.BIZ_PLAN.CHART_2 / unit, roundNum, 'R');  
    		cData3 = gfn_getNumberFmt(chartMap.BIZ_PLAN.CHART_3 / unit, roundNum, 'R');
    		cData4 = gfn_getNumberFmt(chartMap.BIZ_PLAN.CHART_4 / unit, roundNum, 'R');
    		
    		cDataT = Number((chartMap.BIZ_PLAN.CHART_T).toFixed(0));
    		cDataC = chartMap.BIZ_PLAN.CHART_C;
    	}
    	
    	chartId = "chart5";
    	chartTxt = $("#"+chartId).next();
    	chartTxt.append('<p class="per_txt '+cDataC+'"><strong>'+cDataT+'</strong>%</p>');
    	Highcharts.chart(chartId, {
    	    chart: { type: 'column' },
    	    xAxis: { categories: ['<spring:message code="lbl.yearTarget"/>', '<spring:message code="lbl.salesForecasting"/>'] },
    	    yAxis: {
    	    	stackLabels:{
    	    		enabled : true,
    	    		style   : {
    	    			fontWeight:'bold'
    	    		},
    	    		formatter : function() {
    	    			var x = this.x;
    	    			
    	    			if(x == 1) {
    	    				var tot = "";

    	    				if(userLang == "ko") {
    	    					tot = gfn_getNumberFmt((cData2 + cData3 + cData4), 0, 'R', 'Y');
    	    				} else if(userLang == "en" || userLang == "cn") {
    	    					tot = parseFloatWithCommas(parseFloat(cData2 + cData3 + cData4).toFixed(1), 1);
    	    				}
    	    				return tot;
    	    			}
    	    		}
    	    	}
    	    },
    	    tooltip:{
    	    	enabled: true
    	    	,
    	    	formatter: function() {
    	    	  	    return parseFloatWithCommas(this.y);
    	    	},
    	    	 positioner: function(boxWidth, boxHeight, point) {         
    	    	        return {x:point.plotX + 40,y:point.plotY};         
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
    	        data: [cData1,{y:cData4, color: gv_cColor4}]
    	    },{
    	        data: [null,{y:cData3, color: gv_cColor3}]
    	    },{
    	        data: [null,{y:cData2, color: gv_cColor2}]
    	    }]
    	});
    	
    	//2.대표 거래처 그룹별 금주 판매 진척률 (100% 기준)
    	//set Data
    	var columnData = [], lineData = [];
    	var filterObj = $.grep(subList, function(v,n) {
    		return v.MEAS_CD == "SALES_PLAN";
    	});
    	$.each(filterObj, function(n,v) {
    		columnData.push({name: v.REP_CUST_GROUP_NM, y: v.CHART_T});
    	});
    	
    	chartId = "chart2";
    	chartTxt = $("#"+chartId).next();
    	Highcharts.chart(chartId, {
    	    xAxis: { type: 'category' },
    	    yAxis: [{ // left yAxis
    	    	//max: 101,
    	    	plotLines: [{
    	            value: 100,
    	            color: 'red',
    	            width: 2,
    	            dashStyle: 'dot',
    	            label : {
    	            	text: '100%',
    	                align: 'left',
    	            }
    	        }]
    	    }],
    	    plotOptions: {
    	        column: {
    	            dataLabels: {
    	                format: '{'+gv_cFormat+'}',
    	                style : {
    	                	fontSize : "12px",
    	                	fontWeight: ''
						}
    	            }
    	        },
    	    },
    	    series: [{
    	    	type: 'column',
    	        data: columnData
    	    }]
    	});

    	//4.대표 거래처 그룹별 당월 판매 예상
    	//set Data
    	var columnData1 = [], columnData2 = [], columnData3 = [], columnData4 = [], lineData = [];
    	var filterObj = $.grep(subList, function(v, n) {
    		return v.MEAS_CD == "ACTION_PLAN";
    	});
    	$.each(filterObj, function(n,v) {
    		
    		columnData1.push({name: v.REP_CUST_GROUP_NM, y: gfn_getNumberFmt(v.CHART_1 / unit, roundNum, 'R'), color: gv_cColor1});
    		columnData2.push({name: v.REP_CUST_GROUP_NM, y: gfn_getNumberFmt(v.CHART_2 / unit, roundNum, 'R'), color: gv_cColor2});
    		columnData3.push({name: v.REP_CUST_GROUP_NM, y: gfn_getNumberFmt(v.CHART_3 / unit, roundNum, 'R'), color: gv_cColor3});
    		columnData4.push({name: v.REP_CUST_GROUP_NM, y: gfn_getNumberFmt(v.CHART_4 / unit, roundNum, 'R'), color: gv_cColor4});
    		lineData.push({name: v.REP_CUST_GROUP_NM, y: gfn_getNumberFmt(v.CHART_T, 0, 'R'), color: gv_cColor5});
    	});
    	
    	chartId = "chart4";
    	chartTxt = $("#"+chartId).next();
    	Highcharts.chart(chartId, {
    	    xAxis: { type: 'category' },
    	    yAxis: [{ // left yAxis
    	    }, { // right yAxis
    	        opposite: true
    	    }],
    	    tooltip : {
    	    	enabled : false
    	    },
    	    plotOptions: {
    	        column: {
    	            dataLabels: {
    	                format: '{'+format+'}',
    	                style : {
    	                	fontSize : "12px",
    	                	fontWeight: ''
						}
    	                //format: '{y:0f}%',
    	                //allowOverlap: true
    	            },
   	                tooltip: {
   	                    pointFormat: '{point.'+format+'}<spring:message code="lbl.billion"/>',
   	                    //pointFormat: '{point.y:0f}<spring:message code="lbl.billion"/>',
   	                },
    	        },
    	        line: {
    	            dataLabels: {
    	                //format: '{'+gv_cFormat+'}%',
    	                format: '{y:0f}%',
    	                allowOverlap: true,
    	                style : {
							fontSize : "12px",
							fontWeight: ''
						}
    	            },
   	                tooltip: {
   	                    //pointFormat: '{point.'+gv_cFormat+'}%',
   	                	pointFormat: '{point.y:0f}%',
   	                },
    	        },
    	        series: {
    	            lineColor: gv_cColor5
    	        }
    	    },
    	    series: [{
    	    	type: 'column',
    	        stack: 'C',
    	        data: columnData4,
    	    },{
    	    	type: 'column',
    	        stack: 'A',
    	        data: columnData1,
    	    },{
    	    	type: 'column',
    	        stack: 'B',
    	        data: columnData3,
    	    },{
    	    	type: 'column',
    	        stack: 'B',
    	        data: columnData2,
    	    },{
    	    	type: 'line',
    	    	yAxis: 1,
    	        data: lineData,
    	    }]
    	});
    	
    	//6.대표 거래처 그룹별 연간 판매 예상
    	//set Data
    	var columnData1 = [], columnData2 = [], columnData3 = [], columnData4 = [], lineData = [];
    	var filterObj = $.grep(subList, function(v,n) {
    		return v.MEAS_CD == "BIZ_PLAN";
    	});
    	$.each(filterObj, function(n,v) {
    		
    		
    		columnData1.push({name: v.REP_CUST_GROUP_NM, y: gfn_getNumberFmt(v.CHART_1 / unit, roundNum, 'R'), color: gv_cColor1});
    		columnData2.push({name: v.REP_CUST_GROUP_NM, y: gfn_getNumberFmt(v.CHART_2 / unit, roundNum, 'R'), color: gv_cColor2});
    		columnData3.push({name: v.REP_CUST_GROUP_NM, y: gfn_getNumberFmt(v.CHART_3 / unit, roundNum, 'R'), color: gv_cColor3});
    		columnData4.push({name: v.REP_CUST_GROUP_NM, y: gfn_getNumberFmt(v.CHART_4 / unit, roundNum, 'R'), color: gv_cColor4});
    		lineData.push({name: v.REP_CUST_GROUP_NM, y: gfn_getNumberFmt(v.CHART_T, 1, 'R'), color: gv_cColor5});
    		
    		
    	});
    	
    	chartId = "chart6";
    	chartTxt = $("#"+chartId).next();
    	Highcharts.chart(chartId, {
    	    xAxis: { type: 'category' },
    	    yAxis: [{ // left yAxis
    	    	//reversedStacks: true,
    	    }, { // right yAxis
    	        opposite: true
    	    }],
    	    tooltip : {
    	    	enabled : false
    	    },
    	    plotOptions: {
    	        column: {
    	            dataLabels: {
    	                format: '{'+format+'}',
    	                style : {
    	                	fontSize : "12px",
    	                	fontWeight: ''
						}
    	                //format: '{y:0f}%',
    	                //allowOverlap: true
    	            },
   	                tooltip: {
   	                    pointFormat: '{point.'+format+'}<spring:message code="lbl.billion"/>',
   	                	//pointFormat: '{point.y:0f}<spring:message code="lbl.billion"/>',
   	                },
    	        },
    	        line: {
    	            dataLabels: {
    	                //format: '{y:.1f}%',
    	                format: '{y:0f}%',
    	                allowOverlap: true,
    	                style : {
    	                	fontSize : "12px",
    	                	fontWeight: ''
						}
    	            },
   	                tooltip: {
   	                    //pointFormat: '{point.'+gv_cFormat+'}%',
   	                	pointFormat: '{point.y:0f}%',
   	                },
    	        },
    	        series: {
    	            lineColor: gv_cColor5
    	        }
    	    },
    	    series: [{
    	    	type: 'column',
    	        stack: 'A',
    	        data: columnData1,
    	    },{
    	    	type: 'column',
    	        stack: 'B',
    	        data: columnData4,
    	    },{
    	    	type: 'column',
    	        stack: 'B',
    	        data: columnData3,
    	    },{
    	    	type: 'column',
    	        stack: 'B',
    	        data: columnData2,
    	    },{
    	    	type: 'line',
    	    	yAxis: 1,
    	        data: lineData,
    	    }]
    	});
    	
    }
    
    var fn_popupCallback = function () {
        location.reload();
    }
    
    function fn_chartContentInit(){
        
        
        /*
        0. shipmentProgressThisWeek                                  quill_1
		1. shipmentProgressRateThisWeekByRepresentativeCustomerGroup quill_2
		2. expectedMonthlyShipmentsByRepresentativeCustomerGroup1    quill_3
		3. expectedMonthlyShipmentsByRepresentativeCustomerGroup2    quill_4
		4. estimatedAnnualShipments                                  quill_5
		5. annualShipmentForecastByRepresentativeCustomerGroup       quill_6

        */
        
        
        for(i=0;i<6;i++)
        {
            if(FORM_SEARCH.chartList[i].ID=="shipmentProgressThisWeek")                                           FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_1.setContents([{ insert: '\n' }]):quill_1.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="shipmentProgressRateThisWeekByRepresentativeCustomerGroup")     FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_2.setContents([{ insert: '\n' }]):quill_2.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="expectedMonthlyShipmentsByRepresentativeCustomerGroup1")        FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_3.setContents([{ insert: '\n' }]):quill_3.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="expectedMonthlyShipmentsByRepresentativeCustomerGroup2")        FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_4.setContents([{ insert: '\n' }]):quill_4.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="estimatedAnnualShipments")                                      FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_5.setContents([{ insert: '\n' }]):quill_5.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="annualShipmentForecastByRepresentativeCustomerGroup")           FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_6.setContents([{ insert: '\n' }]):quill_6.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
                                        
        }
        
        
        
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
		<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
		
		<div class="scroll" style="height:calc(100% - 35px)">
			<!-- chart -->
			<div id="container" style="float: left">
		    	<div id="cont_chart">
					<!-- 1줄 3개씩 뿌리길 원하실 경우 col_3 으로 클래스명 변경하시면 됩니다 -->
			       	<!-- 금주 출하 진척률  -->
			       	<div class="col_3">
			       	    <div class="titleContainer">
			           	     <h4 id="shipmentProgressThisWeekH4"><spring:message code="lbl.weekProgressChart1"/> (<spring:message code="lbl.hMillion"/>)</h4>
			                 <div class="view_combo">
                                <ul class="rdofl">
                                    
	                                    <li class="manuel">
	                                        <a href="#" id="shipmentProgressThisWeek"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                    </li>
                                    
                                </ul>
                            </div>
			            </div>
			            <div class="graphwrap" id="chart1"></div>
			            <div class="textwrap" id="shipmentProgressThisWeekScore1">
			            	<p><spring:message code="lbl.progressChart"/></p>
		                </div>
		                <div class="textwrap" id="shipmentProgressThisWeekScore2">
		                	<p><spring:message code="lbl.targetPrevDay"/></p>
		                </div>
		                <div class="modal" id="shipmentProgressThisWeekContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-1"></div>
                           </div>
                        </div>
					</div>
					<!-- 대표 거래처 그룹별 금주 출하 진척률 -->
			        <div class="col_3">
			        	<div class="titleContainer">
			        	      <h4 id="shipmentProgressRateThisWeekByRepresentativeCustomerGroupH4"><spring:message code="lbl.weekProgressChart2"/> (%)</h4>
			                  <div class="view_combo">
                                <ul class="rdofl">
                                    
	                                    <li class="manuel">
	                                        <a href="#" id="shipmentProgressRateThisWeekByRepresentativeCustomerGroup"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                    </li>
                                    
                                </ul>
                            </div>   
			            </div>
			            <div id="chart2" style="height:100%;width:100%"></div>
			            <div class="modal" id="shipmentProgressRateThisWeekByRepresentativeCustomerGroupContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-2"></div>
                           </div>
                        </div>
			            
			        </div>
			        <!--당월 출하 예상  -->
			        <div class="col_3">
			        	<%-- <h4><spring:message code="lbl.shipmentForecasting"/> (<spring:message code="lbl.thisMonth"/>, <spring:message code="lbl.hMillion"/>)</h4> --%>
			        	<div class="titleContainer">
			        	      <h4 id="expectedMonthlyShipmentsByRepresentativeCustomerGroup1H4"><spring:message code="lbl.monthSalesExpChart"/> (<spring:message code="lbl.hMillion"/>)</h4>
			                  <div class="view_combo">
                                <ul class="rdofl">
                                   
	                                    <li class="manuel">
	                                        <a href="#" id="expectedMonthlyShipmentsByRepresentativeCustomerGroup1"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                    </li>
                                   
                                </ul>
                            </div>   
			            </div>
			            <div class="graphwrap" id="chart3"></div>
			            <div class="textwrap" id="expectedMonthlyShipmentsByRepresentativeCustomerGroup1Score">
			            	<p><spring:message code="lbl.achieRateChart2"/>(<spring:message code="lbl.chartPredict"/>)</p>
		                </div>
		                <div class="modal" id="expectedMonthlyShipmentsByRepresentativeCustomerGroup1Content" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-3"></div>
                           </div>
                        </div>
			        </div>
			        <!-- 대표 거래처 그룹별 당월 출하 예상 -->
			   		<div class="col_3">
			        	<div class="titleContainer"> 
			        	    <h4 id="expectedMonthlyShipmentsByRepresentativeCustomerGroup2H4"><spring:message code="lbl.monthSalesExpChart2"/> (<spring:message code="lbl.hMillion"/>)</h4>
			                <div class="view_combo">
                                <ul class="rdofl">
                                    
	                                    <li class="manuel">
	                                        <a href="#" id="expectedMonthlyShipmentsByRepresentativeCustomerGroup2"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                    </li>
                                    
                                </ul>
                            </div>
			            </div>
			            <div id="chart4" style="height:100%;width:100%"></div>
			            <div class="modal" id="expectedMonthlyShipmentsByRepresentativeCustomerGroup2Content" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-4"></div>
                           </div>
                        </div>
			        </div>
			        <!-- 연간 출하 예상 -->
			        <div class="col_3">
			        	<div class="titleContainer">
			        	    <h4 id="estimatedAnnualShipmentsH4"><spring:message code="lbl.yearSalesChart1"/> (<spring:message code="lbl.hMillion"/>)</h4>
			                <div class="view_combo">
                                <ul class="rdofl">
                                    
	                                    <li class="manuel">
	                                        <a href="#" id="estimatedAnnualShipments"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                    </li>
                                    
                                </ul>
                            </div>
			            </div>
			            <div class="graphwrap" id="chart5"></div>
			            <div class="textwrap" id="estimatedAnnualShipmentsScore">
			            	<p><spring:message code="lbl.achieRateChart2"/>(<spring:message code="lbl.chartPredict"/>)</p>
		                </div>
		                <div class="modal" id="estimatedAnnualShipmentsContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-5"></div>
                           </div>
                        </div>
			        </div>
			        <!-- 대표 거래처 그룹별 연간 출하 예상  -->
			   		<div class="col_3">
			        	<div class="titleContainer">
			        	    <h4 id="annualShipmentForecastByRepresentativeCustomerGroupH4"><spring:message code="lbl.yearSalesChart2"/> (<spring:message code="lbl.hMillion"/>)</h4>
			                <div class="view_combo">
                                <ul class="rdofl">
                                    
	                                    <li class="manuel">
	                                        <a href="#" id="annualShipmentForecastByRepresentativeCustomerGroup"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                    </li>
                                    
                                </ul>
                            </div>
			            </div>
			            <div id="chart6" style="height:100%;width:100%"></div>
			            <div class="modal" id="annualShipmentForecastByRepresentativeCustomerGroupContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-6"></div>
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
