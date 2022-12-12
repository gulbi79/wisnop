<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//JSP 캐시 삭제
	response.setHeader("Cache-Control", "no-cache"); 
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
<meta http-equiv="Expires" content="-1" /> 
<meta http-equiv="Pragma" content="no-cache" /> 
<meta http-equiv="Cache-Control" content="No-Cache" />
<sec:csrfMetaTags/>
<title>wonik qnc</title>

<script type="text/javascript">
var GV_DEV_MODE     = "<spring:eval expression="@environment.getProperty('props.devMode')"/>";
var GV_CONTEXT_PATH = "${ctx}";
</script>

<link rel="stylesheet" href="${ctx}/statics/css/jquery-ui.css" type="text/css" />
<link rel="stylesheet" href="${ctx}/statics/css/style.css" type="text/css" />

<script type="text/javascript" src="${ctx}/statics/js/jquery/jquery-3.1.0.min.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/jquery/jquery-ui.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/jquery/jquery.blockUI.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/highcharts/highcharts.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/highcharts/exporting.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/biz/comutil.js?v=${sversion}"></script>
<script type="text/javascript" src="${ctx}/statics/js/biz/objutil.js?v=${sversion}"></script>
<script type="text/javascript" src="${ctx}/statics/js/biz/gridutil.js?v=${sversion}"></script>
<script type="text/javascript" src="${ctx}/statics/js/biz/common.js?v=${sversion}"></script>

<style type="text/css">
#cont_chart .col_3 { margin:0; width:calc((100% - 14px) / 3) ; height:calc((100% - 4px) / 3); }
#cont_chart .col_3:nth-child(1) {margin:0 2px 2px 0;}
#cont_chart .col_3:nth-child(2) {margin:0 2px 2px 0;}
#cont_chart .col_3:nth-child(3) {margin:0 2px 2px 0;}
#cont_chart .col_3:nth-child(4) {margin:0 2px 2px 0;}
#cont_chart .col_3:nth-child(5) {margin:0 2px 2px 0;}
#cont_chart .col_3:nth-child(6) {margin:0 2px 2px 0;}
#cont_chart .col_3:nth-child(7) {margin:0 2px 0 0;}
#cont_chart .col_3:nth-child(8) {margin:0 2px 0 0;}
#cont_chart .col_3:nth-child(9) {margin:0 2px 0 0;}

#cont_chart .col_3 .textwrap { padding : 10px 0 0 0; }
#cont_chart .col_3_tmp h4 { margin-bottom: 10px; }

#cont_chart .col_3 > .titleContainer > h4
{
	float:left;
}

#cont_chart .col_3 > .titleContainer > div
{
	float:right;
}

</style>	

<script type="text/javascript">
var unitQuery = 0;
var dMain,dBiz,dDefRate, itemInvData, matInvData;
var cWeek, pWeek, nWeek, bucket;
$(function() {
	fn_init();
	fn_initEvent(); //이벤트 정의
	fn_apply();
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
}

//조회
function fn_apply(sqlFlag) {
	
	FORM_SEARCH = {}
	FORM_SEARCH._mtd = "getList";
	FORM_SEARCH.tranData = [{ outDs : "month" , _siq : "dashboard.portal.Month" }];
	
	var sMap = {
		url	 : "${ctx}/biz/obj.do",
		data	: FORM_SEARCH,
		success : function(data) {
			
			bucket = {};
			bucket.month = data.month;
			
			//메인 데이터를 조회
			fn_getChartData();
		}
	}
	gfn_service(sMap, "obj");
}

function fn_initEvent() {
	$("#btn_logout").on("click",function() {
		confirm("로그아웃 하시겠습니까?", function() {
			fn_goLogOut();
		});
	});
	
	$(':radio[name=companyCons]').on('change', function () {
		companyConsSearch(false);
	});
	
	$(':radio[name=weekMaterialsAvail]').on('change', function () {
		weekMaterialsAvailSearch(false);
	});
	
	
	
}

function fn_getChartData() {
	
	FORM_SEARCH = {}
	FORM_SEARCH.unitQuery = unitQuery;
	FORM_SEARCH.PORTAL_YN = "Y";
	FORM_SEARCH.companyCons = $(':radio[name=companyCons]:checked').val();
	FORM_SEARCH.weekMaterialsAvail = $(':radio[name=weekMaterialsAvail]:checked').val();
	FORM_SEARCH._mtd = "getList";
	FORM_SEARCH.tranData = [
		{outDs : "dMain", _siq : "dashboard.portal.main"}
	  , {outDs : "dBiz" , _siq : "dashboard.portal.biz"}
	  , {outDs : "dDefRate", _siq : "dashboard.portal.defRate"}
	  , {outDs : "itemInvList", _siq : "dashboard.portal.itemInvList"}
	  , {outDs : "matInvList", _siq : "dashboard.portal.matInvList"}
	];
	
	var sMap = {
        headers : {
       		"Accept" : "application/json",
       		"Content-Type" : "application/json",
       		"AJAX" : true
        },
        type: 'post', // POST 로 전송
        async: false,
        url: "${ctx}/biz/obj.do",
        data: JSON.stringify(FORM_SEARCH),
        success:function(data) {
        	
        	gfn_unblockUI();
        	dMain    = data.dMain;
        	dBiz     = data.dBiz;
        	dDefRate = data.dDefRate;
        	itemInvData = data.itemInvList;
        	matInvData = data.matInvList;
        	
        	fn_initChart(); //그리드를 그린다.	
        },
        error : function() {
        	gfn_unblockUI();
        },
        beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX",true);
			gfn_setAjaxCsrf(xhr);
			gfn_blockUI();
		}
    }
	$.ajax(sMap);
}

//차트 초기화
function fn_initChart() {
	//변수선언	
	var chartId = "";
	var chartTxt, chartTxt2, posTxt;
	var unit = 0;
	var roundNum = 0;
	var format = "y:,.0f";
	var userLang = $("#userLang").val();
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
	$.each(dMain, function(n,v) {
		chartMap[v.MEAS_CD] = v;
	});
	
	//경영실적
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
	
	gfn_setHighchartTheme();
	
	/*
	//1.BSC 종합
	Highcharts.theme.colors[0] = '#133485'; //line 적용
	cData1=0, cData2=0, cData3=0, cData4=0, cDataT=0, cDataC="green_f";
	if (!gfn_isNull(chartMap.BSC)) {
		cData1 = gfn_getNumberFmt(chartMap.BSC.CHART_1, 0,'R');
		cData2 = gfn_getNumberFmt(chartMap.BSC.CHART_2, 0,'R');
		cDataT = gfn_getNumberFmt(chartMap.BSC.CHART_T, 0,'R','Y');
		cDataC = chartMap.BSC.CHART_C;
	}
	
	chartId = "chartBsc";
	chartTxt = $("#"+chartId).next();
	chartTxt.append('<p class="per_txt '+cDataC+'"><strong>'+cDataT+'</strong></p>');
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
	//제품 재고 현황 
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
	
	//자재 재고
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
	
	//4.불량률 현황
	var columnData = [], lineData = [];
	var targetDefRate = 0, defDataC = "green_f", maxData;
	
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
	chartTxt = $("#"+chartId).next();
	chartTxt.append('<p class="per_txt '+defDataC+'"><strong>'+targetDefRate+'</strong>%</p>');
	Highcharts.chart(chartId, {
	    xAxis: { type: 'category' },
	    yAxis: [{ // left yAxis
	    	max  : maxData
	    }, { // right yAxis
	        opposite: true, 
	        max  : maxData
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
	        name:'실적'
	    }, {
	    	type: 'line',
	    	yAxis: 1,
	        data: lineData,
	        name:'목표'
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
	
	
	//5.출하 예상
	//set Data
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
	
	// 1 : 일반 목표, 2 : CPFR 목표, 3 : 일반 실적, 4 : CPFR 실적, 5 : 일반 예상실적, 6 : CPFR 예상실적
	chartId = "chartSales";
	chartTxt = $("#"+chartId).next();
	chartTxt.append('<p class="per_txt '+cDataC+'"><strong>'+cDataT+'</strong>%</p>');
	Highcharts.chart(chartId, {
	    chart: { type: 'column' },
	    xAxis: { categories: ['<spring:message code="lbl.target"/>', '<spring:message code="lbl.salesForecasting"/>'] },
	    yAxis: {
	    	stackLabels: {
	    		allowOverlap : true, //total 안나올때 옵션 주는거
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
	
	//7.주간 생산계획 준수율
	//set Data
	cData1=0, cData2=0, cData3=0, cData4=0, cDataT=0, cDataTT=0, cDataC="green_f";
	if(userLang == "ko"){
		if (!gfn_isNull(chartMap.PROD_COMP)) {
    		cData1  = gfn_getNumberFmt(chartMap.PROD_COMP.CHART_1 / unit, 0,'R');  
    		cData2  = gfn_getNumberFmt(chartMap.PROD_COMP.CHART_2 / unit, 0,'R');  
    		cDataT  = Number(chartMap.PROD_COMP.CHART_T.toFixed(0));
    		cDataTT = Number(chartMap.PROD_COMP.CHART_TT.toFixed(0));
    		cDataC  = chartMap.PROD_COMP.CHART_C;
    	}
	}else if(userLang == "en" || userLang == "cn"){
		if (!gfn_isNull(chartMap.PROD_COMP)) {
    		cData1  = gfn_getNumberFmt(chartMap.PROD_COMP.CHART_1 / unit, 1,'R');  
    		cData2  = gfn_getNumberFmt(chartMap.PROD_COMP.CHART_2 / unit, 1,'R');  
    		cDataT  = Number(chartMap.PROD_COMP.CHART_T.toFixed(0));
    		cDataTT = Number(chartMap.PROD_COMP.CHART_TT.toFixed(0));
    		cDataC  = chartMap.PROD_COMP.CHART_C;
    	}
	}
	
	chartId   = "chartProdComp";
	chartTxt  = $("#"+chartId).next();
	chartTxt2 = $("#"+chartId).next().next();
	chartTxt.append('<p class="per_txt '+cDataC+'"><strong>'+cDataT+'</strong>%</p>');
	chartTxt2.append('<p class="per_txt" style="color:#a0a0a0;"><strong style="font-size:30px;">'+cDataTT+'</strong>%</p>');
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
	        data: [{y:cData1}, {y:cData2}]
	    }]
	});

	//8.주간 출하계획 준수율
	cData1=0, cData2=0, cData3=0, cData4=0, cDataT=0, cDataTT=0, cDataC="green_f";
	if(userLang == "ko"){
		if (!gfn_isNull(chartMap.SALES_COMP)) {
    		cData1  = gfn_getNumberFmt(chartMap.SALES_COMP.CHART_1 / unit, 0,'R');  
    		cData2  = gfn_getNumberFmt(chartMap.SALES_COMP.CHART_2 / unit, 0,'R');
    		cData3  = gfn_getNumberFmt(chartMap.SALES_COMP.CHART_3 / unit, 0,'R');
    		cData4  = gfn_getNumberFmt(chartMap.SALES_COMP.CHART_4 / unit, 1,'R');
    		cDataT  = Number(chartMap.SALES_COMP.CHART_T.toFixed(0));
    		cDataTT = Number(chartMap.SALES_COMP.CHART_TT.toFixed(0));
    		cDataC  = chartMap.SALES_COMP.CHART_C;
    	}
		
		
	}else if(userLang == "en" || userLang == "cn"){
		
		if (!gfn_isNull(chartMap.SALES_COMP)) {
    		cData1  = gfn_getNumberFmt(chartMap.SALES_COMP.CHART_1 / unit, 1,'R');
    		cData2  = gfn_getNumberFmt(chartMap.SALES_COMP.CHART_2 / unit, 1,'R');
    		cData3  = gfn_getNumberFmt(chartMap.SALES_COMP.CHART_3 / unit, 1,'R');
    		cData4  = gfn_getNumberFmt(chartMap.SALES_COMP.CHART_4 / unit, 1,'R');
    		cDataT  = Number(chartMap.SALES_COMP.CHART_T.toFixed(0));
    		cDataTT = Number(chartMap.SALES_COMP.CHART_TT.toFixed(0));
    		cDataC  = chartMap.SALES_COMP.CHART_C;
    	}
	}
	
	chartId   = "chartSalesComp";
	chartTxt  = $("#"+chartId).next();
	chartTxt2 = $("#"+chartId).next().next();
	chartTxt.append('<p class="per_txt '+cDataC+'"><strong>'+cDataT+'</strong>%</p>');
	chartTxt2.append('<p class="per_txt" style="color:#a0a0a0;"><strong style="font-size:30px;">'+cDataTT+'</strong>%</p>');
	Highcharts.chart(chartId, {
	    chart: { type: 'column' },
	    xAxis: { categories: ['<spring:message code="lbl.target"/>', '<spring:message code="lbl.performance"/>'] },
	    yAxis: {
	    	stackLabels:{
	    		enabled : true,
	    		style   : {
	    			fontWeight:'',
	    			fontSize : "12px"
	    		},
	    		formatter : function() {
	    			
	    			var tot = "";
	    			var x = this.x;
	    			var valData = "";
	    			
	    			if(x == 0){
	    				valData = cData1 + cData3;
	    			}else if(x == 1){
	    				valData = cData2 + cData4;
	    			}
    				
    				if(userLang == "ko") {
    					tot = gfn_getNumberFmt((valData), 0,'R','Y');
    				} else if(userLang == "en" || userLang == "cn") {
    					tot = parseFloatWithCommas(parseFloat(valData).toFixed(1), 1);
    				}
    				
    				return tot;
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

	//8.주간 자재 준비율
	cData1=0, cData2=0, cData3=0, cData4=0, cDataT=0, cDataC="green_f";
	if (!gfn_isNull(chartMap.MAT_PREP_RATE)) {
		cData1 = chartMap.MAT_PREP_RATE.CHART_1;       
		cData2 = chartMap.MAT_PREP_RATE.CHART_2;       
		cDataT = Number(chartMap.MAT_PREP_RATE.CHART_T.toFixed(0));
		cDataC = chartMap.MAT_PREP_RATE.CHART_C;
	}
	
	chartId = "chartMatPrepRate";
	chartTxt = $("#chartMatPrepRate_changeRate");
	chartTxt.append('<p class="per_txt '+cDataC+'"><strong>'+cDataT+'</strong>%</p>');
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
		url	 : "${ctx}/biz/obj.do",
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
		url	 : "${ctx}/biz/obj.do",
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



function fn_goDashboard(gubun) {
	if (gubun == undefined || gubun == null) return false;

	$("#bu").val(gubun);
    $("#mainForm2").attr("onSubmit","return true");
    $("#mainForm2").attr("action","${ctx}/common/godashboard");
    $("#mainForm2").submit().attr("onSubmit","return false");
}

function fn_goLogOut() {
    $("#mainForm2").attr("onSubmit","return true");
    $("#mainForm2").attr("action","${ctx}/login/logout");
    $("#mainForm2").submit().attr("onSubmit","return false");
}

</script>
</head>
<body class="portalFrame bg" style="min-height:768px;">
	<div id="portal">
		<header>
  			<div class="hd">
				<h1><img src="${ctx}/statics/images/common/logo.png" alt="WonIk"></h1>
			</div>
  		</header>
  	<div id="container" class="bg">
    	<div id="cont_chart">
			<!-- 1줄 3개씩 뿌리길 원하실 경우 col_3 으로 클래스명 변경하시면 됩니다 -->
	       	<div class="col_3">
	           	<h4><spring:message code="lbl.bscSummary"/></h4>
	            <div class="graphwrap" id="chartBsc"></div>
	            <!-- 
	            <div class="textwrap">
	            	<p><spring:message code="lbl.score"/></p>
                </div>
                 -->
			</div>
	        <div class="col_3 col_3_tmp">
	        	<h4><spring:message code="lbl.bizActualChart"/></h4>
	            <div class="tablewrap" style="height:calc(100% - 40px);">
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
						      	<td>0<spring:message code="lbl.billion"/></td>
						      	<td class="red_f">0%</td>
						      	<td>0<spring:message code="lbl.billion"/></td>
						      	<td class="red_f">0%</td>
						    </tr>
						    <tr>
						      	<td><spring:message code="lbl.operationProfit"/></td>
						      	<td></td>
						      	<td class="red_f">0%</td>
						      	<td></td>
						      	<td class="red_f">0%</td>
						    </tr>
					  	</tbody>
					</table>
					<p class="help_txt" style="display:none;">1) <spring:message code="lbl.expActualChart"/></p>
				</div>
	        </div>
	        <div class="col_3">
		        <div class="titleContainer">
		        	<h4><spring:message code="lbl.prodInvStatusChart"/> (<spring:message code="lbl.prevDayChart"/>, <spring:message code="lbl.hMillion"/>)</h4>
		        	<div class="view_combo">
						<ul class="rdofl">
							<li><input type="radio" id="companyCons1" name="companyCons" value="companyCons"/> <label for="companyCons1"><spring:message code="lbl.companyCons" /></label></li>
							<li><input type="radio" id="companyCons2" name="companyCons" value="company" checked="checked"/> <label for="companyCons2"><spring:message code="lbl.company2" /> </label></li>
						</ul>
					</div>
				</div>
	            <div style="height: 100%" id="chartInv1"></div>
	        </div>
	        <div class="col_3">
	        	<h4><spring:message code="lbl.defectRateChart"/> (<spring:message code="lbl.thisMonth"/>)</h4>
	        	<!-- <div style="height: 88%" id="chartDefRate"></div> -->
	            <div class="graphwrap" id="chartDefRate"></div>
	            <div class="textwrap">
                	<p><spring:message code="lbl.achieRateChart2"/></p>
                </div>
	        </div>
	   		<div class="col_3">
	        	<h4><spring:message code="lbl.shipmentForecasting"/> (<spring:message code="lbl.thisMonth"/>, <spring:message code="lbl.hMillion"/>)</h4>
	            <div class="graphwrap" id="chartSales"></div>
	            <div class="textwrap">
	            	<p><spring:message code="lbl.achieRateChart2"/>(<spring:message code="lbl.chartPredict"/>)</p>
                </div>
	        </div>
	        <div class="col_3">
	        	<h4><spring:message code="lbl.matInv"/> (<spring:message code="lbl.prevDayChart"/>, <spring:message code="lbl.hMillion"/>)</h4>
	            <!-- <div class="graphwrap" id="chartInv2"></div> -->
	            <div style="height: 100%" id="chartInv2"></div>
	            <%-- <div class="textwrap">
	            	<p><spring:message code="lbl.changeRate"/></p>
                </div> --%>
	        </div> 
	        <div class="col_3">
	        	<h4><spring:message code="lbl.weekPpcr"/><span class="cweekTxt"></span></h4>
	            <div class="graphwrap" id="chartProdComp"></div>
	            <div class="textwrap">
	            	<p><spring:message code="lbl.cmplRateChart"/></p>
                </div>
                <div class="textwrap">
                	<p><spring:message code="lbl.targetPrevDay"/></p>
                </div>
	        </div>
	   		<div class="col_3">
	        	<h4><spring:message code="lbl.weekSpcr"/><span class="cweekTxt"></h4>
	            <div class="graphwrap" id="chartSalesComp"></div>
	            <div class="textwrap">
	            	<p><spring:message code="lbl.cmplRateChart"/></p>
                </div>
                <div class="textwrap">
                	<p><spring:message code="lbl.targetPrevDay"/></p>
                </div>
	        </div>
	        <div class="col_3">
		        <div class="titleContainer">
		        	<h4><spring:message code="lbl.weekMpr"/><span class="pweekTxt"></h4>
		            <div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="weekMaterialsAvail1" name="weekMaterialsAvail" value="rawMaterials" checked="checked"/> <label for="weekMaterialsAvail1"><spring:message code="lbl.rawMaterial" /></label></li>
									<li><input type="radio" id="weekMaterialsAvail2" name="weekMaterialsAvail" value="outerHalfProduct" /> <label for="weekMaterialsAvail2"><spring:message code="lbl.osfp" /> </label></li>
								</ul>
							</div>
				</div>
		            <div class="graphwrap" id="chartMatPrepRate"></div>
		            <div class="textwrap">
		            	<p><spring:message code="lbl.changeRate"/></p>
	                	<div id="chartMatPrepRate_changeRate"></div>
	                </div>
	            
	        </div>
	  	
		  	<c:set var="userLang">${sessionScope.GV_LANG}</c:set>
			<c:if test="${empty sessionScope.GV_LANG}">
		  	<c:set var="userLang">en</c:set>
			</c:if>
	  </div>
	  <div id="cont_right">
		<div class="sel_tit">
		<Strong>${sessionScope.userInfo.userNm}님</Strong> 환영합니다.
		&nbsp;<img id="btn_logout" style="cursor:pointer;" src="${ctx}/statics/images/portal/btn_logout.png" alt="">
		</div>
	    <form id="mainForm2" name="mainForm2" method="POST" onSubmit="return false;">
		<sec:csrfInput />
		<input type="hidden" id="bu" name="bu" value="">
	  	<div class="sel">
	  		<select name="company" title="company" style="margin-bottom:4px;">
				<c:forEach var="item" items="${sessionScope.GV_COMPANY_LIST}">
	            <option value="${item.CODE_CD}">${item.CODE_NM}</option>
	    		</c:forEach>
			</select>
			<select id="userLang" name="userLang" title="언어설정">
				<option value="en" <c:if test="${sessionScope.GV_LANG == 'en'}">selected</c:if>>영문(English)</option>
	            <option value="ko" <c:if test="${sessionScope.GV_LANG == 'ko'}">selected</c:if>>국문(Korean)</option>
	            <option value="cn" <c:if test="${sessionScope.GV_LANG == 'cn'}">selected</c:if>>중문(Chinese)</option>
	        </select>
    	</div>
	    </form>
	    <form id="commonPopForm" name="commonPopForm" method="POST" onSubmit="return false;">
	    </form>

    	<div class="btn">
			<c:set var="gubun_1"></c:set>
			<c:set var="gubun_2"></c:set>
			<c:set var="gubun_3"></c:set>
			<c:set var="class_1">off</c:set>
			<c:set var="class_2">off</c:set>
			<c:set var="class_3">off</c:set>
			<c:forEach var="item" items="${sessionScope.GV_BU_LIST}">
				<c:if test="${item.CODE_CD eq 'QT'}">
					<c:set var="gubun_1">onClick=fn_goDashboard('QT');</c:set>
					<c:set var="class_1">on</c:set>
				</c:if>
				<c:if test="${item.CODE_CD eq 'CR'}">
					<c:set var="gubun_2">onClick=fn_goDashboard('CR');</c:set>
					<c:set var="class_2">on</c:set>
				</c:if>
				<c:if test="${item.CODE_CD eq 'CL'}">
					<c:set var="gubun_3">onClick=fn_goDashboard('CL');</c:set>
					<c:set var="class_3">on</c:set>
				</c:if>
			</c:forEach>
    		<a href="javascript:${gubun_1}" class="${class_1}"><img src="${ctx}/statics/images/portal/rbtn_1.gif"></a>
    		<a href="javascript:${gubun_2}" class="${class_2}"><img src="${ctx}/statics/images/portal/rbtn_2.gif"></a>
    		<a href="javascript:${gubun_3}" class="${class_3}"><img src="${ctx}/statics/images/portal/rbtn_4.gif"></a>
    	</div>
	  </div>
	</div>
</div>
</body>
</html>
