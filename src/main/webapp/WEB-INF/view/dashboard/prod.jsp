<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="chartYn" value="Y"/>
</jsp:include>
<!-- 공급 대시보드 -->
<style type="text/css">
	#container1 { margin: 0;width: calc(100% - 250px);height: 100%;padding: 0; }
	#cont_chart { width: 100%;height: 100%;}
	
	#cont_chart.full_chart .col_12 {width: 100%;position:relative;}
	#cont_chart .col_12.end {
		min-height:196px;
		height:calc(40%); 
		margin: 2px 0 0 0;
		padding:5px;
	}
	#cont_chart.full_chart .col_12{position:realtive;}
	#cont_chart.full_chart .col_12.first { height: calc(36% - 2px);  padding: 5px; margin: 0 0 2px 0;}
	
	#cont_chart.full_chart .col_12.first .col_12.middle1.a {height: calc(100% - 2px);position:relative;}
	
	#cont_chart.full_chart .col_12.second { height: calc(24% - 2px); padding: 5px 5px 2px 5px;}
	#cont_chart.full_chart .col_12.second .tablewrap {height: calc(100% - 30px);}
    #cont_chart.full_chart .col_12.second .col_12.middle1.b {height: calc(100% - 3px); width:100%;position:relative;}
	
	#cont_chart .col_12 .graphwrap {height : 100%; width: calc(100% - 120px);}
	#cont_chart .col_12 .col_12_60 .graphwrap {height : 100%;}
	
	#cont_chart .col_12 .textwrap { padding : 0 0 0 0; }
	#cont_chart .col_12 .textwrap1 { 
		width: 100%; 
		text-align: center;
	    padding: 0% 0% 0px 0px;	
	}
	
	.tablewrap { height: calc(100% - 30px); }
	.tablewrap table { height: 100%; }
	
	.tablewrap table tbody th { padding: 10px 0;}
	
	#cont_chart3 {
		height: 100%;
	    width: 240px;
	    float: left;
	    margin-left: 10px;
	}
	
	td {
		font-size:12px;
	}
	
	#cont_chart  .col_12.first  .titleContainer > h4
	{
	   float:left;
	
	}
	
	#cont_chart  .col_12.second .titleContainer > h4
	{
	
	   float:left;
	
	}	
	
    #cont_chart  .col_12.end .titleContainer > h4
	{
	      float:left;
	}
	
	#cont_chart  .col_12.second .tablewrap
	{
	
		  overflow:auto;
		  float:left;
	
	}
	
	#cont_chart  .col_12.end >  .tablewrap 
	{
	      overflow:auto;
	      float:left;
	}
	
	
	#cont_chart  .col_12.first > .titleContainer  >  div
	{
	   float:right;
	}
	#cont_chart  .col_12.second > .titleContainer > div
	{
	   float:right;
	}
	
	#cont_chart  .col_12.end > .titleContainer > div
	{
	      float:right;
	}
	
	
	#cont_chart .col_12.first >.modal
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
    
    #cont_chart .col_12.first > .modal_header
    {
        height:25px;
        
    }
    
    #cont_chart .col_12.first > .modal_content
    {
       
        height:auto;
        overflow-y:scroll;
        padding: 10px 15px 10px 15px;
        flex:1;
        display:flex;
        flex-direction:column
        
    }
	
	#cont_chart .col_12.second > .modal
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
    
    #cont_chart .col_12.second > .modal_header
    {
        height:25px;
        
    }
    
    #cont_chart .col_12.second > .modal_content
    {
       
        height:auto;
        overflow-y:scroll;
        padding: 10px 15px 10px 15px;
        flex:1;
        display:flex;
        flex-direction:column
        
    }
    
    #cont_chart .col_12.end > .modal
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
    
    #cont_chart .col_12.end > .modal_header
    {
        height:25px;
        
    }
    
    #cont_chart .col_12.end > .modal_content
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
	var quill_1,quill_2,quill_3;
	var chart1List,chart2List,chart3List;
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
    	var arrTitle = $("h4");
    	$.each(arrTitle, function(n,v) {
    		$(v).css("cursor", "pointer");
    		$(v).on("click", function() { 
    			if (n == 0) gfn_newTab("SNOP304");
    			else if (n == 1) gfn_newTab("QT101");
    			else if (n == 2) gfn_newTab("SNOP304");
    		});
    	});
    	
    	$(".manuel > a").dblclick("on", function() {
    		
    		var chartId  = this.id;
            
            fn_popUpAuthorityHasOrNot();
            
            var isSCMTeam = SCM_SEARCH.isSCMTeam;
            
            if(isSCMTeam>=1)
            {
            	//월간/주간 진척률
            	if(chartId == "monthlyWeeklyProgressRate")
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
            	//주간 현황
            	else if(chartId == "weeklyStatus")
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
            	//품목 그룹별 생산 현황
            	else if(chartId == "productionStatusByItemGroup")
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
         
            //월간/주간 진척률
            if(chartId == "monthlyWeeklyProgressRate"){
            	   
            	$('#monthlyWeeklyProgressRateChart1Chart2').toggle();
            	$('#monthlyWeeklyProgressRateContent').toggle();
                
            }
            //주간 현황
            else if(chartId == "weeklyStatus")
            {
            	$('#weeklyStatusTable').toggle();
                $('#weeklyStatusContent').toggle();
                
            }
            //품목 그룹별 생산 현황
            else if(chartId == "productionStatusByItemGroup")
            {
            	$('#productionStatusByItemGroupTable').toggle();
                $('#productionStatusByItemGroupContent').toggle();
                
            }
            
            
            
    	});
    	
    	
    	$(".titleContainer > h4").hover(function() {
    	
    		var chartId  = this.id;
            
    		//월간/주간 진척률
            if(chartId == "monthlyWeeklyProgressRateH4"){
                   
                $('#monthlyWeeklyProgressRateChart1Chart2').toggle();
                $('#monthlyWeeklyProgressRateContent').toggle();
                
            }
            //주간 현황
            else if(chartId == "weeklyStatusH4")
            {
                $('#weeklyStatusTable').toggle();
                $('#weeklyStatusContent').toggle();
                
            }
            //품목 그룹별 생산 현황
            else if(chartId == "productionStatusByItemGroupH4")
            {
                $('#productionStatusByItemGroupTable').toggle();
                $('#productionStatusByItemGroupContent').toggle();
                
            }
            
    		
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
    	FORM_SEARCH.tranData = [{outDs:"chart1List",_siq:"dashboard.prod.chart1"}
    	                      , {outDs:"chart2List",_siq:"dashboard.prod.chart2"}
    	                      , {outDs:"chart3List",_siq:"dashboard.prod.chart3"}
    	                      , { outDs : "chartList" , _siq : "dashboard.chartInfo.prod" }
    	                      ];
    	var sMap = {
            url: "${ctx}/biz/obj",
            data: FORM_SEARCH,
            success:function(data) {
            	chart1List = data.chart1List;
            	chart2List = data.chart2List;
            	chart3List = data.chart3List;
            	FORM_SEARCH.chartList = data.chartList;
            	fn_chartContentInit();
            	fn_initChart();
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
    	var roundNum = 0;
    	var format = "y:,.0f";
    	var userLang = "${sessionScope.GV_LANG}";
    	var cData1=0, cData2=0, cData3=0, cData4=0, cDataT=0, cDataTT=0, cDataC1="green_f", cDataC2="green_f";
    	
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
    	$.each(chart1List, function(n,v) {
    		chartMap.chart1 = v;
    		return false;
    	});

    	//테마적용 공통함수
    	gfn_setHighchartTheme();
    	
    	//1.주간 진척률
    	//set Data
    	cData1=0, cData2=0, cData3=0, cData4=0, cDataT=0, cDataTT=0, cDataC1="green_f";
    	
    	if (!gfn_isNull(chartMap.chart1)) {
    		cData1  = gfn_getNumberFmt(chartMap.chart1.CHART_1 / unit, roundNum,'R');       
    		cData2  = gfn_getNumberFmt(chartMap.chart1.CHART_2 / unit, roundNum,'R');
    		cData3  = gfn_getNumberFmt(chartMap.chart1.CHART_3 / unit, roundNum,'R');
    		cData4  = gfn_getNumberFmt(chartMap.chart1.CHART_4 / unit, roundNum,'R');
    	}
    	
    	cDataT  = Number(chartMap.chart1.CHART_T.toFixed(0));
		cDataTT = Number(chartMap.chart1.CHART_TT.toFixed(0));
		cDataC1  = chartMap.chart1.CHART_C1;
		cDataC2  = chartMap.chart1.CHART_C2;
    	
    	
    	chartId   = "chart1";
    	chartTxt  = $("#"+chartId).next();
    	chartTxt2 = $("#"+chartId).next().next();
    	chartTxt.append('<p class="per_txt '+cDataC1+'"><strong>'+cDataT+'</strong>%</p>');
    	chartTxt2.append('<p class="per_txt '+cDataC2+'"><strong>'+cDataTT+'</strong>%</p>');
    	/* chartTxt2.append('<p class="per_txt" style="color:#a0a0a0;"><strong style="font-size:30px;">'+cDataTT+'</strong>%</p>'); */
    	
    	Highcharts.chart(chartId, {
    	    chart: { type: 'column' },
    	    xAxis: { categories: ['<spring:message code="lbl.monthTarget"/>', '<spring:message code="lbl.weekTarget"/>', '<spring:message code="lbl.monthResult"/>', '<spring:message code="lbl.weekResult"/>'] },
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
    	        data: [cData3, cData1, cData4, cData2]
    	    }]
    	});
    	
    	//2.주간실적 chart
    	//set Data
    	var columName = [];
    	var columnData = [];
    	var columnData2 = [];
    	var totData = [];
    	$.each(chart2List, function(n,v) {
    		columName.push(v.ROUTING_ID);
    		columnData.push(v.CHART_T1);
    		columnData2.push(v.CHART_T2);
    	});
    	
    	totData.push({stack: 1, name : '<spring:message code="lbl.monthProgress"/>', data : columnData2});
    	totData.push({stack: 0, name : '<spring:message code="lbl.weekProgress"/>', data : columnData});
    	
    	chartId = "chart2";
    	chartTxt = $("#"+chartId).next();
    	//chartTxt.append('<p class="per_txt '+cDataC1+'"><strong>'+cDataT+'</strong>%</p>');
    	Highcharts.chart(chartId, {
    		chart: { type: 'column' },
    	    xAxis: { categories: columName },
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
    	    tooltip : {
				enabled : false,
				pointFormat: '{series.name} : {point.y:.0f}%'
			},
    	    plotOptions: {
    	        column: {
    	            dataLabels: {
    	                format: '{'+gv_cFormat+'}%',
    	                style : {
    	                	fontSize : "12px",
    	                	fontWeight: ''
						}
    	            }
    	        },
    	    },
    	    series : totData
    	});
    	
    	//3.주간실적 table
    	for (var i=0; i<6; i++) {
    		
    		if (i == 0) {
    			$("#chart2_1_1").text(gfn_getNumberFmt(chart2List[i].CHART_1_SUM, roundNum,'R','Y'));
    			$("#chart2_2_1").text(gfn_getNumberFmt(chart2List[i].CHART_2_SUM, roundNum,'R','Y') + " / " + gfn_getNumberFmt(chart2List[i].CHART_3_SUM, roundNum,'R','Y'));
    			
    			$("#chart2_1_2").text(gfn_getNumberFmt(chart2List[i].CHART_1, roundNum,'R','Y'));
    			$("#chart2_2_2").text(gfn_getNumberFmt(chart2List[i].CHART_2, roundNum,'R','Y') + " / " + gfn_getNumberFmt(chart2List[i].CHART_3, roundNum,'R','Y'));
    		} else {
    			$("#chart2_1_"+(i+2)).text(gfn_getNumberFmt(chart2List[i].CHART_1, roundNum,'R','Y'));
    			$("#chart2_2_"+(i+2)).text(gfn_getNumberFmt(chart2List[i].CHART_2, roundNum,'R','Y') + " / " + gfn_getNumberFmt(chart2List[i].CHART_3, roundNum,'R','Y'));
    		}
    		
    	}
    	
    	//4.품목 그룹별 생산 현황
    	for (var i=0; i<7; i++) {
    		var dataM = "";
    		
    		// 확정실적
    		$("#chart3_11_"+(i+1)).text(gfn_getNumberFmt(chart3List[i].CHART_1_W, roundNum,'R','Y'));
    		$("#chart3_12_"+(i+1)).text(gfn_getNumberFmt(chart3List[i].CHART_1_M, roundNum,'R','Y'));
    		
    		// 생산실적
    		$("#chart3_21_"+(i+1)).text(gfn_getNumberFmt(chart3List[i].CHART_2_W, roundNum,'R','Y'));
    		$("#chart3_22_"+(i+1)).text(gfn_getNumberFmt(chart3List[i].CHART_2_M, roundNum,'R','Y'));
    		
    		// 달성률
    		$("#chart3_31_"+(i+1)).text(gfn_getNumberFmt(chart3List[i].CHART_T_W, roundNum,'R','Y'));
    		$("#chart3_32_"+(i+1)).text(gfn_getNumberFmt(chart3List[i].CHART_T_M, roundNum,'R','Y'));
    		
    		$("#chart3_31_"+(i+1)).attr("class",chart3List[i].CHART_C_W);
    		$("#chart3_32_"+(i+1)).attr("class",chart3List[i].CHART_C_M);
    		
    		// FQC 검사대기
    		dataM = chart3List[i].CHART_3_M==0?"":gfn_getNumberFmt(chart3List[i].CHART_3_M, roundNum,'R','Y');
    		$("#chart3_41_"+(i+1)).text(gfn_getNumberFmt(chart3List[i].CHART_3_W, roundNum,'R','Y'));
    		$("#chart3_42_"+(i+1)).text(dataM);
    	}
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
            
   }
       
    
    function fn_chartContentInit(){
        
        
        /*
        0.    monthlyWeeklyProgressRate
		1.    weeklyStatus
		2.    productionStatusByItemGroup

        */
        
        
        for(i=0;i<3;i++)
        {
            if(FORM_SEARCH.chartList[i].ID=="monthlyWeeklyProgressRate")        FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_1.setContents([{ insert: '\n' }]):quill_1.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="weeklyStatus")                FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_2.setContents([{ insert: '\n' }]):quill_2.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="productionStatusByItemGroup") FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_3.setContents([{ insert: '\n' }]):quill_3.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
                                 
        }
        
        
        
    }
       
       
    </script>

</head>
<body id="framesb" class="portalFrame bg">
	<jsp:include page="/WEB-INF/view/layout/commonForm.jsp" flush="false">
		<jsp:param name="siteMapYn" value="Y"/>
	</jsp:include>
	
	<!-- contents -->
	<div id="grid1" class="fconbox">
		<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
		
		<div class="scroll" style="height:calc(100% - 35px)">
			<!-- 대쉬보드 화면 시작 -->
	        <div id="container1" style="float: left">
				<div id="cont_chart" class="full_chart">
	      			<!-- 20180213 start -->
	    			<div class="col_12 first">
	           	 		<div class="titleContainer">
	           	 		    <h4 id="monthlyWeeklyProgressRateH4"><spring:message code="lbl.weekMonthProgress"/> (<spring:message code="lbl.hMillion"/>)</h4>
	            		    <div class="view_combo">
                             <ul class="rdofl">
                                 <li class="manuel">
                                    <a href="#" id="monthlyWeeklyProgressRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                 </li>
                             </ul>
                            </div>
	            		</div>
	            		<div class="col_12 middle1 a" id="monthlyWeeklyProgressRateChart1Chart2">
	                		<div class="col_12_40">
	                			<div class="graphwrap" id="chart1"></div>
	                			<div class="textwrap">
	                				<p><spring:message code="lbl.weekProgress"/></p>
	                			</div>
	                			<div class="textwrap" style="padding:10px 0 0 0;">
	                				<p><spring:message code="lbl.monthProgress"/></p>
	                			</div>
	                		</div>
	                		<div class="col_12_60">
	                			<div class="graphwrap" id="chart2"></div>
	                		</div>
	                		
	                	</div>
	                	<div class="modal" id="monthlyWeeklyProgressRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-1"></div>
                           </div>
                       </div>
                    </div>
                    <div class="col_12 second">
	                	<div class="titleContainer">
                                 <h4 id="weeklyStatusH4"><spring:message code="lbl.weekStatus"/></h4>
                                 <div class="view_combo">
                                 <ul class="rdofl">
                                     <li class="manuel">
                                        <a href="#" id="weeklyStatus"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
                                 </ul>
                                </div>
                            </div>
	                	<div class="col_12 middle1 b" >
	                		
	                		<div class="tablewrap" id="weeklyStatusTable">
	                			<table id="chart2T">
	                    			<caption>주간 실적</caption>
	  								<thead>
								    	<tr>
								    		<th id="test1" style="width:30.5%;" scope="col"></th>
								      		<th scope="col">1-L</th>
									      	<th scope="col">1-S</th>
									      	<th scope="col">1-B</th>
									      	<th scope="col">2-L</th>
									      	<th scope="col">2-T</th>
									      	<th scope="col">2-M</th>
								    	</tr>
								  	</thead>
								  	<tbody>
								    	<tr>
								    		<td>
								    			<div class="textwrap1">
								                	<p class="per_txt blue_f"><strong id="chart2_1_1"></strong></p>
								                	<p><spring:message code="lbl.nonCommChart"/></p>
	                							</div>
	                						</td>
									      	<td id="chart2_1_2">0</td>
									      	<td id="chart2_1_3">0</td>
									      	<td id="chart2_1_4">0</td>
									      	<td id="chart2_1_5">0</td>
									      	<td id="chart2_1_6">0</td>
									      	<td id="chart2_1_7">0</td>
	    								</tr>
	    								<tr>
										    <td>
										    	<div class="textwrap1">
						                    		<p class="per_txt blue_f"><strong id="chart2_2_1">/</strong></p>
						                        	<p><spring:message code="lbl.defectChart"/></p>
										        </div>
										    </td>
	      									<td id="chart2_2_2">0/0</td>
	      									<td id="chart2_2_3">0/0</td>
	      									<td id="chart2_2_4">0/0</td>
	      									<td id="chart2_2_5">0/0</td>
	      									<td id="chart2_2_6">0/0</td>
	      									<td id="chart2_2_7">0/0</td>
	    								</tr>
	 			 					</tbody>
								</table>
	                		</div>
		                	<div class="modal" id="weeklyStatusContent" style="display:none;">
                                   <div class="modal_header"></div>
                                   <div class="modal_content">
                                       <div id="editor-2"></div>
                                   </div>
                            </div>
	                	</div>
	                	
	            	</div>
	            	<div class="col_12 end">
	            		<div class="titleContainer">
	            		     <h4 id="productionStatusByItemGroupH4"><spring:message code="lbl.itemGroupChart"/></h4>
	               		     <div class="view_combo">
                                 <ul class="rdofl">
                                     <li class="manuel">
                                        <a href="#" id="productionStatusByItemGroup"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
                                 </ul>
                             </div>
	               		</div>
	               		
	               		<div class="tablewrap"  id="productionStatusByItemGroupTable">
	                		<table >
	                    		<caption><spring:message code="lbl.itemGroupChart"/></caption>
	  							<thead>
	    							<tr>
							      		<th scope="col" rowspan="2"></th>
								      	<th scope="col" colspan="2">Outer Tube</th>
								      	<th scope="col" colspan="2">Inner Tube</th>
								      	<th scope="col" colspan="2">Process Tube</th>
								      	<th scope="col" colspan="2">Long Boat</th>
								      	<th scope="col" colspan="2">Ring Boat</th>
								      	<th scope="col" colspan="2">LAM</th>
								      	<th scope="col" colspan="2">TEL</th>
							    	</tr>
							    	<tr>
								      	<th scope="col">주</th>
								      	<th scope="col">월</th>
								      	<th scope="col">주</th>
								      	<th scope="col">월</th>
								      	<th scope="col">주</th>
								      	<th scope="col">월</th>
								      	<th scope="col">주</th>
								      	<th scope="col">월</th>
								      	<th scope="col">주</th>
								      	<th scope="col">월</th>
								      	<th scope="col">주</th>
								      	<th scope="col">월</th>
								      	<th scope="col">주</th>
								      	<th scope="col">월</th>
							    	</tr>
							  	</thead>
							  	<tbody>
							    	<tr>
							    		<th><spring:message code="lbl.confirmPlan"/> (EA)</th>
						      			<td id="chart3_11_1"></td>
						      			<td id="chart3_12_1"></td>
								      	<td id="chart3_11_2"></td>
								      	<td id="chart3_12_2"></td>
								      	<td id="chart3_11_3"></td>
								      	<td id="chart3_12_3"></td>
								      	<td id="chart3_11_4"></td>
								      	<td id="chart3_12_4"></td>
								      	<td id="chart3_11_5"></td>
								      	<td id="chart3_12_5"></td>
								      	<td id="chart3_11_6"></td>
								      	<td id="chart3_12_6"></td>
								      	<td id="chart3_11_7"></td>
								      	<td id="chart3_12_7"></td>
							    	</tr>
							    	<tr>
							    		<th><spring:message code="lbl.prodPerformanceChart"/> (EA)</th>
							      		<td id="chart3_21_1"></td>
							      		<td id="chart3_22_1"></td>
							      		<td id="chart3_21_2"></td>
							      		<td id="chart3_22_2"></td>
							      		<td id="chart3_21_3"></td>
							      		<td id="chart3_22_3"></td>
							      		<td id="chart3_21_4"></td>
							      		<td id="chart3_22_4"></td>
							      		<td id="chart3_21_5"></td>
							      		<td id="chart3_22_5"></td>
							      		<td id="chart3_21_6"></td>
							      		<td id="chart3_22_6"></td>
							      		<td id="chart3_21_7"></td>
							      		<td id="chart3_22_7"></td>
							    	</tr>
							    	
							    	<tr>
							     		<th>FQC 검사대기</th>
							      		<td id="chart3_41_1"></td>
							      		<td id="chart3_42_1"></td>
								      	<td id="chart3_41_2"></td>
								      	<td id="chart3_42_2"></td>
								      	<td id="chart3_41_3"></td>
								      	<td id="chart3_42_3"></td>
								      	<td id="chart3_41_4"></td>
								      	<td id="chart3_42_4"></td>
								      	<td id="chart3_41_5"></td>
								      	<td id="chart3_42_5"></td>
								      	<td id="chart3_41_6"></td>
								      	<td id="chart3_42_6"></td>
								      	<td id="chart3_41_7"></td>
								      	<td id="chart3_42_7"></td>
							    	</tr>
							    	
							    	
							     	<tr>
							     		<th><spring:message code="lbl.achieRateChart2"/> (%)</th>
							      		<td id="chart3_31_1" class="red_f" style="font-weight: bold;"></td>
							      		<td id="chart3_32_1" class="red_f" style="font-weight: bold;"></td>
								      	<td id="chart3_31_2" class="red_f" style="font-weight: bold;"></td>
								      	<td id="chart3_32_2" class="red_f" style="font-weight: bold;"></td>
								      	<td id="chart3_31_3" class="red_f" style="font-weight: bold;"></td>
								      	<td id="chart3_32_3" class="red_f" style="font-weight: bold;"></td>
								      	<td id="chart3_31_4" class="red_f" style="font-weight: bold;"></td>
								      	<td id="chart3_32_4" class="red_f" style="font-weight: bold;"></td>
								      	<td id="chart3_31_5" class="red_f" style="font-weight: bold;"></td>
								      	<td id="chart3_32_5" class="red_f" style="font-weight: bold;"></td>
								      	<td id="chart3_31_6" class="red_f" style="font-weight: bold;"></td>
								      	<td id="chart3_32_6" class="red_f" style="font-weight: bold;"></td>
								      	<td id="chart3_31_7" class="red_f" style="font-weight: bold;"></td>
								      	<td id="chart3_32_7" class="red_f" style="font-weight: bold;"></td>
							    	</tr>
							  	</tbody>
							</table>
	                	</div>
	                	<div class="modal" id="productionStatusByItemGroupContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-3"></div>
                           </div>
                       </div>
	            	</div>
	    			<!-- 20180213 end -->
		  		</div>
			</div>
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
	        <!-- 대쉬보드 화면 끝 -->
        </div>
	</div>
</body>
</html>
