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
	
	#cont_chart.full_chart .col_6 { height:calc((100% - 30px) / 4); }
	#cont_chart.full_chart .col_12 { width: 100%;}
	
	#cont_chart .col_6 { height:calc((100% - 30px) / 4); width:calc((100% - 10px) / 2); padding: 0 1% 0 1%;}
	#cont_chart.full_chart .col_12.middle { height:calc((100% - 30px) / 4); width:100%;}
	
	#cont_chart .col_6:nth-child(1) {margin:0 10px 10px 0;}
	#cont_chart .col_6:nth-child(2) {margin:0 0 10px 0;}
	
	#cont_chart .col_12.middle {margin:0;}
	#cont_chart.full_chart .col_12.middle { margin:0 0 10px 0; }
	#cont_chart.full_chart .col_12.middle:last-child { margin:0}
	
	#cont_chart .col_12 .col_12_25 { height: 100%;}
	
	#cont_chart .col_6 .textwrap {
	    width: calc((100% - 10px) / 2);
		text-align: center;
		padding: 0 0 0 0; 
		height: 100%;
		overflow:auto;
	}
	
	#cont_chart .col_6 .graphwrap {
		height: 100%;
	}
	
	#cont_chart .col_6 .textwrap h4 { text-align: center; margin-top: 10px; margin-bottom: 10px; }
	#cont_chart .col_6 h4 {margin-top: 10px;}
	#cont_chart .col_12 h4 {margin-top: 10px;}
	
	#cont_chart .col_12 .col_12_25 .textwrap { text-align: center; padding: 5% 1% 0 0; width: 100%; height: calc(100% - 33px); overflow:auto;}
	h4 {text-align: center;}
	
	#cont_chart .col_6 .graphwrap div {
	    height: calc(100% - 30px);
	}
	
	.span_padding { display: inline-block;vertical-align: middle; }
	
	#cont_chart3 {
		height: 100%;
	    width: 240px;
	    float: left;
	    margin-left: 10px;
	}
	
	</style>
	
	<script type="text/javascript">
	var chart1List,defectivesChart,chart3List,chart4List,chart4TotalList,chart5List,chart5TotalList;
    $(function() {
    	
    	gfn_formLoad(); //공통 폼 초기 정보 설정
    	fn_siteMap();
    	fn_init();
    	fn_initEvent();
    	fn_apply();
    });
    
    function fn_init() {
    	var cDate = gfn_getCurrentDate();
    	var pDate = gfn_getAddDate(cDate.YYYYMMDD, -7);
    	var nDate = gfn_getAddDate(cDate.YYYYMMDD, 7);
    	cWeek = "W"+cDate.WEEKOFYEAR;
    	pWeek = "W"+pDate.WEEKOFYEAR;
    	nWeek = "W"+nDate.WEEKOFYEAR;
    	
    	$.each($(".cweekTxt"), function(n,v) {
    		$(v).text(' ('+cWeek+')');
    	});

    	$.each($(".pweekTxt"), function(n,v) {
    		$(v).text(' ('+pWeek+')');
    	});
    }
    
    function fn_initEvent() {
    	var arrTitle = $("h4");
    	$.each(arrTitle, function(n,v) {
    		$(v).css("cursor", "pointer");
    		$(v).on("click", function() { 
    			if (n == 0) gfn_newTab("QT102");
    			else if (n == 1) gfn_newTab("QT101");
    			else if (n == 2) gfn_newTab("SNOP305");
    			else if (n == 3) gfn_newTab("MP102");
    			else if (n == 4) gfn_newTab("SNOP205");
    			else if (n == 5) gfn_newTab("SNOP205");
    			else if (n == 6) gfn_newTab("SNOP206");
    			else if (n == 7) gfn_newTab("SNOP206");
    			else if (n == 8) gfn_newTab("DP205");
    			else if (n == 9) gfn_newTab("SNOP301");
    			else if (n == 10) gfn_newTab("SNOP302");
    			else if (n == 11) gfn_newTab("SNOP303");
    			else if (n == 12) gfn_newTab("MP106");
    			else if (n == 13) gfn_newTab("SNOP304");
    			else if (n == 14) gfn_newTab("MP105");
    			else if (n == 15) gfn_newTab("MP105");
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
    	FORM_SEARCH.tranData = [{outDs:"chart1List"     ,_siq:"dashboard.snop.chart1"}
    	                      /* , {outDs:"chart2List"     ,_siq:"dashboard.snop.chart2"} */
    	                      , {outDs:"chart3List"     ,_siq:"dashboard.snop.chart3"}
    	                      , {outDs:"chart4List"     ,_siq:"dashboard.snop.chart4"}
    	                      , {outDs:"chart4TotalList",_siq:"dashboard.snop.chart4Total"}
    	                      , {outDs:"chart5List"     ,_siq:"dashboard.snop.chart5"}
    	                      , {outDs:"chart5TotalList",_siq:"dashboard.snop.chart5Total"}
    	                      , {outDs:"defectivesChart", _siq:"dashboard.scmDash.defectivesChart"}];
    	
    	var sMap = {
            url: "${ctx}/biz/obj",
            data: FORM_SEARCH,
            success:function(data) {
            	chart1List      = data.chart1List;
            	/* chart2List      = data.chart2List; */
            	chart3List      = data.chart3List;
            	chart4List      = data.chart4List;
            	chart4TotalList = data.chart4TotalList;
            	chart5List      = data.chart5List;
            	chart5TotalList = data.chart5TotalList;
            	defectivesChart = data.defectivesChart;
            	
            	fn_initChart();
            }
        }
        gfn_service(sMap,"obj");
    }

    //차트 초기화
    function fn_initChart() {
    	//변수선언	
    	var chartId = "";
    	var chartTxt, posTxt;
    	var unit = 0;
    	var format = "y:,.0f";
    	var roundNum = 0;
    	var userLang = "${sessionScope.GV_LANG}";
    	var cData1=0, cData2=0, cDataC="green_f", cDataP="", cDataCSub="";
    	
    	if(userLang == "ko"){
    		unit = 100000000;
    		roundNum = 0;
    		format = "y:,.0f";
    	}else if(userLang == "en" || userLang == "cn"){
    		unit = 1000000000;
    		roundNum = 1;
    		format = "y:,.1f";
    	}

    	//테마적용 공통함수
    	gfn_setHighchartTheme();
    	
    	//1.Claim
    	if (chart1List.length > 0) {
    		$("#chart1_1").html("<strong>"+gfn_addCommas(chart1List[0].CLAIM_RATE)+"</strong>");
    		$("#chart1_2").text(chart1List[0].CLAIM_QTY_M + "개 / " + chart1List[0].CLAIM_QTY_Y + "개");
    		
    		cDataC = chart1List[0].CHART_C;
    		
    		$("#chart1_1").parent().attr("class","per_txt "+cDataC);
    	}
 
    	//불량률
    	var defectArr = new Array();
    	$.each(defectivesChart, function(i, val){
    		
    		var prodPart = val.PROD_PART;
    		var defRate = val.DEF_RATE;
    		
    		defectArr.push({name : prodPart, y : defRate});
    	})
    	
    	Highcharts.chart('defectivesChart', {
    	    chart: { type: 'column' },
    	    xAxis: { type: 'category' },
    	    yAxis: {
    	    },
    	    plotOptions: {
    	        column: {
    	            dataLabels: {
    	                format: '{y:,.2f}%',
    	                style : {
    	                	fontSize : "12px",
    	                	fontWeight: ''
						}
    	            }
    	        }
    	    },
    	    exporting : {
    	    	enabled: false,
    	    },
    	    series: [{
    	    	colorByPoint: true,
    	        data: defectArr
    	    }]
    	});
    	
    	//3.자재 준비율
    	var chart3;
    	for (var i=1; i<=12; i++) {
	    	cData1=0, cData2=0, cDataC="", cDataP="green_f", cDataCSub="gray_f";
	    	chart3 = gfn_getFindDataDsInDs(chart3List, {MEAS_CD : {VALUE : "CHART"+i, CONDI : "="}});
	    	if (chart3.length > 0) {
	    		
	    		if ($("#chart3_"+i+"_1").parent().text().indexOf('<spring:message code="lbl.billion"/>') > -1) {
	    			cData1 = chart3[0].CHART_1 / unit;
	    			cData2 = chart3[0].CHART_2 / unit;
	    		} else {
	    			cData1 = chart3[0].CHART_1;
	    			cData2 = chart3[0].CHART_2;
	    		}
	    		
	    		if(userLang == "ko"){
	    			cData1    = gfn_getNumberFmt(cData1, 0,'R','Y');       
		    		cData2    = gfn_getNumberFmt(cData2, 0,'R','Y');
	        	}else if(userLang == "en" || userLang == "cn"){
	        		
	        		if(i == 6 || i == 7 || i == 8 || i == 9){
	        			cData1    = gfn_getNumberFmt(cData1, 0,'R','Y');       
			    		cData2    = gfn_getNumberFmt(cData2, 0,'R','Y');	        			
	        		}else{
	        			cData1    = gfn_getNumberFmt(cData1, 1,'R','Y');       
			    		cData2    = gfn_getNumberFmt(cData2, 1,'R','Y');	
	        		}
	        	}
	    		
	    		
	    		cDataC    = chart3[0].CHART_C;
	    		cDataP    = chart3[0].CHART_P;
	    		cDataCSub = chart3[0].CHART_C_SUB;
	    		
	    		if (cData2 == 0) cDataP = "+";
	    		
	    		$("#chart3_"+i+"_1").text(cData1);
	    		$("#chart3_"+i+"_1").parent().attr("class","per_txt "+cDataC);
	    		$("#chart3_"+i+"_2").text(cDataP+cData2);
	    		$("#chart3_"+i+"_2").parent().attr("class","per_txt1 "+cDataCSub);
	    	}
    	}
    	
    	//출하금액
    	//set data
    	var xCategory = [], yCategory = [], cData = [];
    	var preWeek = "";
    	var cIdx = -1, amt, tmpCdata = [];
    	var arrColor = ['#4F81BC', '#8DADD3', '#C0504E'];
    	var y = 0;
    	
    	$.each(chart4List, function(n,v) {
    		
    		if (!gfn_isNull(v.AMT)) {
	    		amt = v.AMT / unit;

	    		if(userLang == "ko"){
	    			amt = gfn_getNumberFmt(amt, 0,'R');
	    			y = -55;
	        	}else if(userLang == "en" || userLang == "cn"){
	        		amt = gfn_getNumberFmt(amt, 1,'R');
	        		y = -115;
	        	}
    		} else {
    			amt = null;
    		}
    		tmpCdata.push({y:amt, color: arrColor[n%3]});
    		
    		//3의 배수
    		if (Math.ceil((n+1) % 3) == 0) {
    			cData.push({name: v.YEARWEEK, data: tmpCdata}); 
    			tmpCdata = [];
    		}
    		
    		if (n < 3) {
    			yCategory.push(v.MEAS_NM);
    		}
    	});
    	
    	
    	
    	Highcharts.chart('chart8_1', {
		    chart: {
		        type: 'bar'
		    },
		    xAxis: {
		        categories: yCategory
		    },
		    yAxis: {
		        labels : { enabled : true}, 
		        min: 0,
		        stackLabels : {
		        	enabled : true,
    	    		style   : {
    	    			fontWeight:'bold',
    	    			fontSize:"15px"
    	    		},
    	    		//y : y,
		        	formatter : function() {
		        		var x = this.x;
		        		
		        		var sum = chart4TotalList[x].TOTAL_AMT / unit;

			    		if(userLang == "ko"){
			    			sum = gfn_getNumberFmt(sum, 0,'R');
			        	}else if(userLang == "en" || userLang == "cn"){
			        		sum = gfn_getNumberFmt(sum, 1,'R');
			        	}
		        		
		        		return sum;
		        	}
		        }
		    },
		    legend: {
		        reversed: true
		    },
		    exporting : {
    	    	enabled: false,
    	    },
		    tooltip : {
		    	enabled : true
		    },
		    plotOptions: {
    	        bar: {
    	            dataLabels: {
    	                format: '{'+format+'}<spring:message code="lbl.billion"/>',
    	                style : {
    	                	fontSize : "12px",
    	                	fontWeight: ''
						}
    	                //format: '{y:0f}<spring:message code="lbl.billion"/>'
    	            }
    	        }
		    },
		    series: cData
		});

    	//생산금액
    	//set data
    	var xCategory = [], yCategory = [], cData = [];
    	var preWeek = "";
    	var cIdx = -1, amt, tmpCdata = [];
    	var y = 0;
    	$.each(chart5List, function(n,v) {
    		if (!gfn_isNull(v.AMT)) {
	    		amt = v.AMT / unit;
	    		
	    		if(userLang == "ko"){
	    			amt = gfn_getNumberFmt(amt, 0,'R');
	    			y = -55;
	        	}else if(userLang == "en" || userLang == "cn"){
	        		amt = gfn_getNumberFmt(amt, 1,'R');
	        		
	        		y = -115;
	        	}
	    		
    		} else {
    			amt = null;
    		}
    		tmpCdata.push({y:amt, color: arrColor[n%3]});
    		
    		//3의 배수
    		if (Math.ceil((n+1) % 3) == 0) {
    			cData.push({name: v.YEARWEEK, data: tmpCdata}); 
    			tmpCdata = [];
    		}
    		
    		if (n < 3) {
    			yCategory.push(v.MEAS_NM);
    		}
    	});
    	
    	
    	Highcharts.chart('chart12_1', {
		    chart: {
		        type: 'bar'
		    },
		    xAxis: {
		        categories: yCategory
		    },
		    yAxis: {
		        labels : { enabled : true}, 
		        min: 0,
		        stackLabels : {
		        	enabled : true,
    	    		style   : {
    	    			fontWeight:'bold',
    	    			fontSize:"15px"
    	    		},
    	    		//y : y,
		        	formatter : function() {
						var x = this.x;
		        		
		        		var sum = chart5TotalList[x].TOTAL_AMT / unit;

			    		if(userLang == "ko"){
			    			sum = gfn_getNumberFmt(sum, 0,'R');
			        	}else if(userLang == "en" || userLang == "cn"){
			        		sum = gfn_getNumberFmt(sum, 1,'R');
			        	}
		        		
		        		return sum;
		        	}
		        }
		    },
		    legend: {
		        reversed: true
		    },
		    exporting : {
    	    	enabled: false,
    	    },
		    tooltip : {
		    	enabled : true
		    },
		    plotOptions: {
    	        bar: {
    	            dataLabels: {
    	                format: '{'+format+'}<spring:message code="lbl.billion"/>',
    	                style : {
    	                	fontSize : "12px",
    	                	fontWeight: ''
						}
    	            }
    	        }
		    },
		    series: cData
		});
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
		  		<div id="cont_chart" class="full_chart">
	        		<div class="col_6">
	                	<div class="textwrap">
	                		<h4 style="padding-bottom: 10px;"><spring:message code="lbl.claimChart"/> (<spring:message code="lbl.yearChart2"/>)</h4>
	                		<span class="span_padding"></span>
	                    	<p class="per_txt green_f"><strong id="chart1_1">0</strong>  ppm</p>
	                    	<p class="per_txt1" id="chart1_2"> / </p>
	                    	<p class="per_txt1" style="font-size:12px;"><spring:message code="lbl.thisMonth"/> / <spring:message code="lbl.cumulativeYear"/></p>
	                	</div>
		                <div class="graphwrap">
		                	<h4><spring:message code="lbl.defectRateChart2"/> (%, <spring:message code="lbl.prodPart3"/>)</h4>
		                	<div id="defectivesChart"></div>
		                </div>
	            	</div>
	            	<div class="col_6">
	                	<div class="textwrap">
		                	<h4 style="padding-bottom: 10px;"><spring:message code="lbl.mprChart"/><span class="pweekTxt"></h4>
		                	<span class="span_padding"></span>
		                    <p class="per_txt green_f"><strong id="chart3_1_1">0</strong> %</p>
		                    <p class="per_txt1"><spring:message code="lbl.lastWeek"/>&nbsp;<span class="per_txt1" id="chart3_1_2">0</span>%</p>
	                	</div>
	                	<div class="textwrap">
	                		<h4 style="padding-bottom: 10px;"><spring:message code="lbl.supplyCapacityRate"/><span class="pweekTxt"></h4>
	                		<span class="span_padding"></span>
	                		<p class="per_txt green_f"><strong id="chart3_12_1">0</strong> %</p>
		                    <p class="per_txt1"><spring:message code="lbl.lastWeek"/>&nbsp;<span class="per_txt1" id="chart3_12_2">0</span>%</p>
	                	</div>
	            	</div>
	        		<div class="col_12 middle">
	                	<div class="col_12_25">
		                	<h4><spring:message code="lbl.prodInv"/> (<spring:message code="lbl.prevDayChart"/>)</h4>
		                	<div class="textwrap">
		                		<span class="span_padding"></span>
		                		<p class="per_txt green_f"><strong id="chart3_2_1">0</strong> <spring:message code="lbl.billion"/></p>
		                    	<p class="per_txt1"><spring:message code="lbl.lastWeek"/>&nbsp;<span class="per_txt1" id="chart3_2_2">0</span><spring:message code="lbl.billion"/></p>
		                	</div>
	                	</div>
		            	<div class="col_12_25">
		                	<h4><spring:message code="lbl.matInv"/> (<spring:message code="lbl.prevDayChart"/>)</h4>
		                	<div class="textwrap">
		                		<span class="span_padding"></span>
		                		<p class="per_txt green_f"><strong id="chart3_3_1">0</strong> <spring:message code="lbl.billion"/></p>
		                    	<p class="per_txt1"><spring:message code="lbl.lastWeek"/>&nbsp;<span class="per_txt1" id="chart3_3_2">0</span><spring:message code="lbl.billion"/></p>
		                	</div>
		                </div>
		                <div class="col_12_25">
		                	<h4><spring:message code="lbl.agingProdChart"/> (<spring:message code="lbl.prevMonthChart"/>)</h4>
		                	<div class="textwrap">
		                		<span class="span_padding"></span>
		                		<p class="per_txt green_f"><strong id="chart3_4_1">0</strong> <spring:message code="lbl.billion"/></p>
		                    	<p class="per_txt1"><spring:message code="lbl.lastMonth"/>&nbsp;<span class="per_txt1" id="chart3_4_2">0</span><spring:message code="lbl.billion"/></p>
		                	</div>
		                </div>
		            	<div class="col_12_25">
		                	<h4><spring:message code="lbl.agingMatChart"/> (<spring:message code="lbl.prevMonthChart"/>)</h4>
		                	<div class="textwrap">
		                		<span class="span_padding"></span>
		                		<p class="per_txt green_f"><strong id="chart3_5_1">0</strong> <spring:message code="lbl.billion"/></p>
		                    	<p class="per_txt1"><spring:message code="lbl.lastMonth"/>&nbsp;<span class="per_txt1" id="chart3_5_2">0</span><spring:message code="lbl.billion"/></p>
		                	</div>
		                </div>
	            	</div>
	            	
	            	
	            	<div class="col_12 middle">
		                <div class="col_12_25">
		                	<h4><spring:message code="lbl.salesAmt"/><span class="cweekTxt"></h4>
		                	<div id="chart8_1" style="height:calc(100% - 30px)"></div>
		                </div>
		            	<div class="col_12_25">
		                	<h4><spring:message code="lbl.salesCmplRateChart1"/><span class="pweekTxt"></h4>
		                	<div class="textwrap">
		                		<span class="span_padding"></span>
		                		<p class="per_txt green_f"><strong id="chart3_6_1">0</strong> %</p>
		                    	<p class="per_txt1"><spring:message code="lbl.lastWeek"/>&nbsp;<span class="per_txt1" id="chart3_6_2">0</span>%</p>
		                	</div>
		                </div>
		                <div class="col_12_25">
		                	<h4><spring:message code="lbl.salesHittingRation"/> (<spring:message code="lbl.prevMonthChart"/>)</h4>
		                	<div class="textwrap">
		                		<span class="span_padding"></span>
		                		<p class="per_txt green_f"><strong id="chart3_7_1">0</strong> %</p>
		                    	<p class="per_txt1"><spring:message code="lbl.lastMonth"/>&nbsp;<span class="per_txt1" id="chart3_7_2">0</span>%</p>
		                	</div>
		                </div>
		            	<div class="col_12_25">
		                	<h4><spring:message code="lbl.achieRateChart4"/> (M+3) (%)</h4>
		                	<div class="textwrap">
		                		<span class="span_padding"></span>
		                		<p class="per_txt green_f"><strong id="chart3_8_1">0</strong> %</p>
		                    	<p class="per_txt1"><spring:message code="lbl.lastMonth"/>&nbsp;<span class="per_txt1" id="chart3_8_2">0</span>%</p>
		                	</div>
		                </div>
	            	</div>
	            	
	            	
	            	
	            	
	            	
	            	
	            	
		            <div class="col_12 middle">
		                <div class="col_12_25">
		                	<h4><spring:message code="lbl.prodAmt"/><span class="cweekTxt"></h4>
		                	<div id="chart12_1" style="height:calc(100% - 30px)"></div>
		                </div>
		            	<div class="col_12_25">
		                	<h4><spring:message code="lbl.prodCmplRateChart1"/><span class="pweekTxt"></h4>
		                	<div class="textwrap">
		                		<span class="span_padding"></span>
		                		<p class="per_txt green_f"><strong id="chart3_9_1">0</strong> %</p>
		                    	<p class="per_txt1"><spring:message code="lbl.lastWeek"/>&nbsp;<span class="per_txt1" id="chart3_9_2">0</span>%</p>
		                	</div>
		                </div>
		                <div class="col_12_25">
		                	<h4><spring:message code="lbl.wipAmt"/> (<spring:message code="lbl.prevDayChart"/>)</h4>
		                	<div class="textwrap">
		                		<span class="span_padding"></span>
		                		<p class="per_txt green_f"><strong id="chart3_10_1">0</strong> <spring:message code="lbl.billion"/></p>
		                    	<p class="per_txt1"><spring:message code="lbl.lastWeek"/>&nbsp;<span class="per_txt1" id="chart3_10_2">0</span><spring:message code="lbl.billion"/></p>
		                	</div>
		                </div>
		            	<div class="col_12_25">
		                	<h4><spring:message code="lbl.agingWipChart"/> (<spring:message code="lbl.prevDayChart"/>)</h4>
		                	<div class="textwrap">
		                		<span class="span_padding"></span>
		                		<p class="per_txt green_f"><strong id="chart3_11_1">0</strong> <spring:message code="lbl.billion"/></p>
		                    	<p class="per_txt1"><spring:message code="lbl.lastWeek"/>&nbsp;<span class="per_txt1" id="chart3_11_2">0</span><spring:message code="lbl.billion"/></p>
		                	</div>
		                </div>
		            </div>
	    			<!-- 20180213 end -->
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
