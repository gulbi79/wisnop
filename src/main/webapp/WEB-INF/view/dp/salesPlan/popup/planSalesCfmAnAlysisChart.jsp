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
	#cont_chart { width: 100%; height: 100%;}
	#cont_chart .col_3 { width: 100%; height: 95%; margin:0 10px 10px 0;}

	.view_combo .rdofl li label{font-size:30px}
</style>	

<script type="text/javascript">
//var resizeFlag = 0;
var codeMapEx;

$(function() {
	fn_init();
	fn_event();
});

function fn_event(){
	$("#btnClose" ).on("click", function() { 
		window.close(); 
	});
	
	$("#btnSearch").on("click", function(e) {
		fn_getChartData();
	});
	
	$(window).resize(function() {
		fn_getChartData();
	}).resize();
}

//조회
function fn_init(sqlFlag) {
	
	codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP"], null, {itemType : ""});
	codeMapEx.REP_CUST_GROUP.unshift({CODE_CD : "", CODE_NM : "ALL"});
	gfn_setMsCombo("reptCustGroup", codeMapEx.REP_CUST_GROUP, ["*"], {width:"122px"});
	
}

function fn_getChartData() {
	
	FORM_SEARCH.planId = $("#planId").val();
	FORM_SEARCH.reptCustGroup = $("#reptCustGroup").val();
	FORM_SEARCH._mtd = "getList";
	FORM_SEARCH.tranData = [{ outDs : "resList", _siq : "dp.salesPlan.planSalesCfmAnAlysisChart"}];
	
	var aOption = {
		url     : GV_CONTEXT_PATH + "/biz/obj",
		data    : FORM_SEARCH,
		success : function (data) {
			
			var resList = data.resList;
			var resListLen = resList.length;
			
			if(resListLen == 0){
				alert('<spring:message code="msg.noDataFound"/>');
				return;
			}
			
			var resData = resList[0];
			fn_initChart(resData);
		}
	}
	gfn_service(aOption, "obj");
}

//차트 초기화
function fn_initChart(resData) {
	
	var unit = 0;
	var totalCnt = 0;
	var chartId = "chartSales";
	var userLang = $("#userLang").val();
	var preProdQty = gfn_nvl(resData.PRE_PROD_QTY, 0) * -1; //선행생산 (일반)
	var preProdQtyCpfr = gfn_nvl(resData.PRE_PROD_QTY_CPFR, 0) * -1; //선행생산 (CPFR)
	var prodQty = gfn_nvl(resData.PROD_QTY2, 0); //생산 필요 반영
	var invSalesQty = gfn_nvl(resData.INV_SALES_QTY, 0); //재고출하가능
	var noProdQty = gfn_nvl(resData.NO_PROD_QTY, 0); //생산 미반영
	var availCfmSp = gfn_nvl(resData.AVAIL_CFM_SP, 0); //출하확정 가능
	var noCfmSp = gfn_nvl(resData.NO_CFM_SP, 0); //출하 미반영 (일반)
	var noCfmSpCpfr = gfn_nvl(resData.NO_CFM_SP_CPFR, 0); //출하 미반영 (CPFR)
	var totNoCfmSp = noCfmSp + noCfmSpCpfr; //출하 미반영
	var availQty = gfn_nvl(resData.AVAIL_QTY, 0); //가용 금액
	/* var noAvaQtyAddConfirm = gfn_nvl(resData.NO_AVA_QTY_ADD_CONFIRM, 0); //비가용수량 추가확정 (AP2 대비) */
	var avaQtyAddConfirm = gfn_nvl(resData.AVA_QTY_ADD_CONFIRM, 0) * -1; //가용수량 추가확정 (AP2 대비)
	var overCfmSp = gfn_nvl(resData.OVER_CFM_SP, 0); //비가용수량 초과확정
	
	if(userLang == "ko"){
		unit = 100000000;
	}else if(userLang == "en" || userLang == "cn"){
		unit = 1000000000;
	}

	if(userLang == "ko"){
		preProdQty = gfn_getNumberFmt(preProdQty / unit, 1, 'R');
		preProdQtyCpfr = gfn_getNumberFmt(preProdQtyCpfr / unit, 1, 'R');
		prodQty = gfn_getNumberFmt(prodQty / unit, 1, 'R');
		invSalesQty = gfn_getNumberFmt(invSalesQty / unit, 1, 'R');
		noProdQty = gfn_getNumberFmt(noProdQty / unit, 1, 'R');
		availCfmSp = gfn_getNumberFmt(availCfmSp / unit, 1, 'R');
		noCfmSp = gfn_getNumberFmt(noCfmSp / unit, 1, 'R');
		noCfmSpCpfr = gfn_getNumberFmt(noCfmSpCpfr / unit, 1, 'R');
		totNoCfmSp = gfn_getNumberFmt(totNoCfmSp / unit, 1, 'R');
		availQty = gfn_getNumberFmt(availQty / unit, 1, 'R');
		avaQtyAddConfirm = gfn_getNumberFmt(avaQtyAddConfirm / unit, 1, 'R');
		overCfmSp = gfn_getNumberFmt(overCfmSp / unit, 1, 'R');
	}else if(userLang == "en" || userLang == "cn"){
		preProdQty = gfn_getNumberFmt(preProdQty / unit, 2, 'R');
		preProdQtyCpfr = gfn_getNumberFmt(preProdQtyCpfr / unit, 2, 'R');
		prodQty = gfn_getNumberFmt(prodQty / unit, 2, 'R');
		invSalesQty = gfn_getNumberFmt(invSalesQty / unit, 2, 'R');
		noProdQty = gfn_getNumberFmt(noProdQty / unit, 2, 'R');
		availCfmSp = gfn_getNumberFmt(availCfmSp / unit, 2, 'R');
		noCfmSp = gfn_getNumberFmt(noCfmSp / unit, 2, 'R');
		noCfmSpCpfr = gfn_getNumberFmt(noCfmSpCpfr / unit, 2, 'R');
		totNoCfmSp = gfn_getNumberFmt(totNoCfmSp / unit, 2, 'R');
		availQty = gfn_getNumberFmt(availQty / unit, 2, 'R');
		avaQtyAddConfirm = gfn_getNumberFmt(avaQtyAddConfirm / unit, 2, 'R');
		overCfmSp = gfn_getNumberFmt(overCfmSp / unit, 2, 'R');
	}
	
	Highcharts.chart(chartId, {
		colors: ['#2f7ed8', '#0d233a', '#8bbc21', '#910000', '#1aadce', '#492970', '#f28f43', '#77a1e5', '#c42525', '#a6c96a', '#4B0000', '#F361A6'],
		title: {text : null},
		chart: {type: 'column' },
		xAxis: {
			categories: ['<spring:message code="lbl.prodplan3"/>', '<spring:message code="lbl.ap2Cnt"/>', '<spring:message code="lbl.availCfmSp2"/>', '<spring:message code="lbl.shipPlanConfirm"/>', '<spring:message code="lbl.shipNoDetail"/>'],
			labels: {
	            style: {
	                fontSize : '15px'
	            }
	        }	
		},
	    yAxis: {
	    	//visible : true,	    	
	    	labels : { enabled : false},
	    	title: { text: null },
	    	stackLabels : {
	    		allowOverlap : true, //total 안나올때 옵션 주는거
	    		enabled: true,
	    	    style: {
	    	    	fontWeight: 'bold',
	    	    	fontSize : '15px',
	    	        color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
				},
				formatter : function (){
					
                	var total = this.total;
                	var result = "";
                	var isNegative = this.isNegative;
                	
                	if(!isNegative){
                		if(totalCnt == 0){
                    		result = total + Math.abs(preProdQty) + Math.abs(preProdQtyCpfr);
                    	}else if(totalCnt == 1 || totalCnt == 2 || totalCnt == 4){
                    		result = total;
                    	}else if(totalCnt == 3){
                    		result = total - totNoCfmSp + Math.abs(avaQtyAddConfirm);
                    	}
                    	
                    	if(userLang == "ko"){
                			result = gfn_getNumberFmt(result, 1, 'R');
                		}else if(userLang == "en" || userLang == "cn"){
                			result = gfn_getNumberFmt(result, 2, 'R');
                		}
                    	
                    	if(result != ""){
                    		result = result + ' <spring:message code="lbl.hMillion"/>'
                    	}
                    	totalCnt++;
                	}
                	return result;
				}
			}
	    },
	    plotOptions: {
	        column: {
	        	stacking: 'normal',
	        	dataLabels: {
	                enabled : true,
	                style: {
	                	fontSize : '15px'
	                },
	                formatter : function (){
	                	var y = Math.abs(this.y);
	                	var colorIndex = this.colorIndex;
	                	var name = this.series.userOptions.name;
	                	var result = name + " ["+ y + ' <spring:message code="lbl.hMillion"/>]';
	                	return result;
	                }
	            }
	        }
	    },
	    tooltip : {
	    	formatter : function (){
	    		var y = Math.abs(this.y);
            	var colorIndex = this.colorIndex;
            	var name = this.series.userOptions.name;
            	var result = name + " ["+ y + ' <spring:message code="lbl.hMillion"/>]';
            	return result;
             }
		},
	    
		legend: {
	    	enabled: false
	    },
	    
	    series: [{
	    	name : '<spring:message code="lbl.noProd"/>', //생산 미반영
	        data: [null, {y: noProdQty}, null, null]
	    }, {
	    	name : '<spring:message code="lbl.precedProd4"/>', //선행 생산(일반)
	        data: [{y: preProdQty}, null, null, null]
	    }, {
	    	name : '<spring:message code="lbl.precedProd5"/>', //선행 생산(CPFR)
	        data: [{y: preProdQtyCpfr}, null, null, null]
	    }, {
	    	name : '<spring:message code="lbl.salesQtyInv"/>', //재고 출하 가능
	        data: [null, {y: invSalesQty}, null, null]
	    }, {
	    	name : '<spring:message code="lbl.prodPlan2"/>', //생산 계획 반영
	        data: [{y: prodQty}, {y: prodQty}, null, null]
	    }, {
	    	name : '<spring:message code="lbl.availCfmSp2"/>', //출하 확정 가능
	        data: [null, null, {y: availCfmSp}, null]
	    }, {
	    	name : '<spring:message code="lbl.overCfmSp"/>', //비가용 수량 추가 확정(AP2대비) -> 비가용수량 초과확정
	        data: [null, null, null, {y: overCfmSp}]
	    }, {
	    	name : '<spring:message code="lbl.shipAmt"/>', //가용 금액
	        data: [null, null, null, {y: availQty}]
	    }, {
	    	name : '<spring:message code="lbl.totNoCfmSp"/>', //출하 미반영
	        data: [null, null, null, {y: totNoCfmSp}]
	    }, {
	    	name : '<spring:message code="lbl.avaQtyAddConfirm2"/>', //가용수량 추가 확정(AP2대비)
	        data: [null, null, null, {y: avaQtyAddConfirm}]
	    }, {
	    	name : '<spring:message code="lbl.noCfmSpCpfr"/>', //출하 미반영(CPFR)
	        data: [null, null, null, null, {y: noCfmSpCpfr}]
	    }, {
	    	name : '<spring:message code="lbl.noCfmSp"/>', //출하 미반영(일반)
	        data: [null, null, null, null, {y: noCfmSp}]
	    }]
	});
}



</script>
</head>
<body>
	<%-- <%@ include file="/WEB-INF/view/layout/commonForm.jsp" %> --%>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit">${param.popupTitle}</div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
				<input type="hidden" id="userLang" name="userLang" value="${sessionScope.GV_LANG}"/>
				<input type="hidden" id="planId" name="planId" value="${param.planId}"/>
				
				<div class="srhcondi">
				<c:set var="lvWidth" value="115px" />
				<ul>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.reptCustGroup"/></strong>
						<div class="selectBox">
							<select id="reptCustGroup" name="reptCustGroup"></select>
						</div>
					</li>
				</ul>
				</div>
				</form>
 				<div class="bt_btn">
					<a href="javascript:;" id="btnSearch" class="fl_app"><spring:message code="lbl.search"/></a>
				</div>
			</div>
		</div>
	</div>
	<div style="height: 77%" id="chartSales"></div>
	<div class="pop_btn">
		<%-- <a href="#" id="btnApply" class="pbtn pApply"><spring:message code="lbl.apply"/></a> --%>
		<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
	</div>
	
</body>
</html>
