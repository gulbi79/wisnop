<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.chart"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
	<jsp:param name="chartYn" value="Y"/>
</jsp:include>

<style type="text/css">
	
	
	#cont_chart { width: 100%; height: 100%;}
	#cont_chart .col_3 { width: 100%; height: 95%; margin:0 10px 10px 0;}

	.view_combo .rdofl li label{font-size:30px}
	
	table {
		width: 100%;
		height: 88%;
	    border: 1px solid #444444;
	}
	
	td {
		border: 1px solid #444444;
		padding-right: 5px;
		text-align: right;
		font-size:30px;
	}
</style>

<script type="text/javascript">

	var popupChart = {

		init : function () {
			
			var userLang = "${sessionScope.GV_LANG}";
			
			if(userLang == "ko") {
	    		unit = 100000000;
	    	} else if(userLang == "en" || userLang == "cn") {
	    		unit = 1000000000;
	    	}
			
			this.initSearch();
			this.events();
			this.search(false);
		},
	
		_siq	: "dashboard.purchase.",
		chart_id : "${popupChartPurchase.chartId}",
		
		events : function () {
			
			$("#btnClose").on("click", function(){
				window.close(); 
			});
			
			$(':radio[name=priceCost]').on('change', function () {
				popupChart.priceCostSearch(false);
			});
			
			$(':radio[name=monthFlag]').on('change', function () {
				popupChart.invAgingSearch(false);
			});
			
			$(':radio[name=invPsiFlag]').on('change', function () {
				popupChart.invPsiSearch(false);
			});
			
			$(':radio[name=materialAvaRateFlag]').on('change', function () {
				popupChart.aterialAvaRateSearch(false);
			});
		},
		
		weekList : null,
		weekDayList: null,
		
		initSearch : function () {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [
				{ outDs : "weekList" , _siq : popupChart._siq + "weekList" },
				{ outDs : "weekDay" , _siq : popupChart._siq + "weekDay" }
				];
			var sMap = {
					
			    async: false,
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					popupChart.weekList = {};
					popupChart.weekDayList = {};
					popupChart.weekList.week  = data.weekList;
					popupChart.weekDayList.weekDay = data.weekDay;
						
					popupChart.search();
				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			
			FORM_SEARCH            = {};
			//FORM_SEARCH            = this.bucket;
			
			if(popupChart.chart_id == "priceCostChart") {
				FORM_SEARCH.priceCost  = $(':radio[name=priceCost]:checked').val();
			} else if(popupChart.chart_id == "invAgingChart") {
				FORM_SEARCH.monthFlag  = $(':radio[name=monthFlag]:checked').val();
			} else if(popupChart.chart_id == "invPsiChart") {
				FORM_SEARCH.invPsiFlag  = $(':radio[name=invPsiFlag]:checked').val();
			} else if(popupChart.chart_id == "materialAvaRateChart") {
				FORM_SEARCH.materialAvaRateFlag  = $(':radio[name=materialAvaRateFlag]:checked').val();
			} 
			
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			
			FORM_SEARCH.tranData   = [
				{ outDs : popupChart.chart_id , _siq : popupChart._siq + popupChart.chart_id }
			];
			
			var sMap = {
					
				async: false,
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					popupChart.drawChart(data);
				}
			};
			gfn_service(sMap,"obj");
		},
		
		priceCostSearch : function(sqlFlag){
			FORM_SEARCH            = {};
			FORM_SEARCH.priceCost  = $(':radio[name=priceCost]:checked').val();
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			
			FORM_SEARCH.tranData   = [
				{ outDs : popupChart.chart_id , _siq : popupChart._siq + popupChart.chart_id }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					popupChart.drawChart(data);
				}
			};
			gfn_service(sMap,"obj");
		},
		
		invAgingSearch : function(sqlFlag){
			FORM_SEARCH            = {};
			FORM_SEARCH.monthFlag  = $(':radio[name=monthFlag]:checked').val();
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			
			FORM_SEARCH.tranData   = [
				{ outDs : popupChart.chart_id , _siq : popupChart._siq + popupChart.chart_id }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					popupChart.drawChart(data);
				}
			};
			gfn_service(sMap,"obj");
		},
		
		invPsiSearch : function(sqlFlag){
			FORM_SEARCH            = {};
			FORM_SEARCH.invPsiFlag  = $(':radio[name=invPsiFlag]:checked').val();
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			
			FORM_SEARCH.tranData   = [
				{ outDs : popupChart.chart_id , _siq : popupChart._siq + popupChart.chart_id }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					popupChart.drawChart(data);
				}
			};
			gfn_service(sMap,"obj");
		},
		
		aterialAvaRateSearch : function(sqlFlag){
			FORM_SEARCH            = {};
			FORM_SEARCH.materialAvaRateFlag  = $(':radio[name=materialAvaRateFlag]:checked').val();
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			
			FORM_SEARCH.tranData   = [
				{ outDs : popupChart.chart_id, _siq : popupChart._siq + popupChart.chart_id }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					popupChart.drawChart(data);
				}
			};
			gfn_service(sMap,"obj");
		},
		
		drawChart : function (res) {
			fn_setHighchartTheme();
			
			if(popupChart.chart_id == "priceCostChart") {
				
				var chartId = popupChart.chart_id;
				var xCate = new Array();
				var seriesArr = new Array();
				
				xCate.push('<spring:message code="lbl.yearStart" />');
				xCate.push('<spring:message code="lbl.3monthAvg" />');
				xCate.push('<spring:message code="lbl.monthStart" />');
				xCate.push('<spring:message code="lbl.today" />');
				
				$.each(res.priceCostChart, function(i, val){
					
					var seriesTmp = {};
					var dataTmp = new Array();
					var itemType = val.ITEM_TYPE;
					var codeNm = val.CODE_NM;
					var bohAmtY = val.BOH_AMT_Y;
					var avgAmtM3 = val.AVG_AMT_M3;
					var bohAmtM = val.BOH_AMT_M;
					var bohAmtD = val.BOH_AMT_D;
					
					dataTmp.push(bohAmtY);
					dataTmp.push(avgAmtM3);
					dataTmp.push(bohAmtM);
					dataTmp.push(bohAmtD);
					
					if(itemType == "DA"){
						seriesTmp = {type : "line", name : codeNm, data : dataTmp, yAxis: 1}
					}else{
						seriesTmp = {type : "column", name : codeNm, data : dataTmp}
					}
					seriesArr.push(seriesTmp);
				});
				
				Highcharts.chart(chartId, {
				    title: {
				        text: ''
				    },
				    xAxis: {
				        categories: xCate
				    },
				    yAxis: [{ // left yAxis
				    	stackLabels: {
				    		//allowOverlap : true, //total 안나올때 옵션 주는거
				    		//enabled: true
						}
		    	    }, { // right yAxis
		    	    	stackLabels: {
				    		//allowOverlap : true, //total 안나올때 옵션 주는거
				    		//enabled: false
						}
		    	    }],
					plotOptions: {
						series: {
					        dataLabels: {
				                enabled: true,
				                format: '{point.y:.1f}'
				            },
				            events:{
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
				            }
					    }
					},
				    series: seriesArr
				});
				
			}else if(popupChart.chart_id == "invAgingChart") {
				
				var chartId = popupChart.chart_id;
				var xCate = new Array();
				var seriesArr = new Array();
				
				xCate.push('<spring:message code="lbl.yearStart" />');
				xCate.push('<spring:message code="lbl.mm3" />');
				xCate.push('<spring:message code="lbl.mm2" />');
				xCate.push('<spring:message code="lbl.mm1" />');
				
				$.each(res.invAgingChart, function(i, val){
					
					var seriesTmp = {};
					var dataTmp = new Array();
					
					var codeNm = val.CODE_NM;
					var yearOver = val.YEAR_OVER;
					var befLastOver = val.BEF_LAST_OVER;
					var lastOver = val.LAST_OVER;
					var curOver = val.CUR_OVER;
					
					dataTmp.push(yearOver);
					dataTmp.push(befLastOver);
					dataTmp.push(lastOver);
					dataTmp.push(curOver);
					
					seriesTmp = {type : "column", name : codeNm, data : dataTmp}
					seriesArr.push(seriesTmp);
				});
				
				$.each(res.invAgingChart, function(i, val){
					
					var seriesTmpLine = {};
					var dataTmpLine = new Array();
					
					var codeLineNm = val.CODE_LINE_NM;
					var yearOverLine = val.YEAR_OVER_LINE;
					var befLastOverLine = val.BEF_LAST_OVER_LINE;
					var lastOverLine = val.LAST_OVER_LINE;
					var curOverLine = val.CUR_OVER_LINE;
					
					dataTmpLine.push(yearOverLine);
					dataTmpLine.push(befLastOverLine);
					dataTmpLine.push(lastOverLine);
					dataTmpLine.push(curOverLine);
					
					seriesTmpLine = {type : "line", name : codeLineNm, data : dataTmpLine, yAxis: 1}
					
					seriesArr.push(seriesTmpLine);
				});
				
				Highcharts.chart(chartId, {
				    title: {
				        text: ''
				    },
				    xAxis: {
				        categories: xCate
				    },
				    yAxis: [{ // left yAxis
				    	stackLabels: {
				    		//allowOverlap : true, //total 안나올때 옵션 주는거
				    		//enabled: true
						}
		    	    }, { // right yAxis
		    	    	stackLabels: {
				    		//allowOverlap : true, //total 안나올때 옵션 주는거
				    		//enabled: false
						}
		    	    }],
					plotOptions: {
						series: {
					        cursor: 'pointer',
					        dataLabels: {
				                enabled: true,
				                format: '{point.y:.1f}'
				            },
				            events:{
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
							point: {
					        	events: {
				                	click: function() {
				                		gfn_comPopupOpen("POPUP_PURCHASE_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartPurchase",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : "<spring:message code='lbl.invAgaing' /> (<spring:message code='lbl.hMillion' />)"
				        				});
					                }
					            }
					        }
					    }
					},
				    series: seriesArr
				});
			}else if(popupChart.chart_id == "invPsiChart") {
				
				var drawTmp = "<tr><td rowspan=\"2\" style=\"background-color: #bbdefb;width: 28%;text-align: center; \"><spring:message code='lbl.divisionChart' /></td>";
				drawTmp += "<td colspan=\"4\" style=\"background-color: #bbdefb;width: 72%;text-align: center; \"><spring:message code='lbl.weekly' /></td></tr>";
				drawTmp += "<tr><td style=\"background-color: #bbdefb;width: 18%;text-align: center; \">W + 1</td>";
				drawTmp += "<td style=\"background-color: #bbdefb;width: 18%;text-align: center; \">W + 2</td>";
				drawTmp += "<td style=\"background-color: #bbdefb;width: 18%;text-align: center; \">W + 3</td>";
				drawTmp += "<td style=\"background-color: #bbdefb;width: 18%;text-align: center; \">W + 4</td></tr>";
				
				$.each(res.invPsiChart, function(i, val){
					
					var measNm = val.MEAS_NM;
					var oneData = val.ONE_DATA;
					var twoData = val.TWO_DATA;
					var threeData = val.THREE_DATA;
					var fourData = val.FOUR_DATA;
					
					if(i == 3){ //월간 을 넣어줘야함
						drawTmp += "<tr><td rowspan=\"2\" style=\"background-color: #bbdefb;width: 28%;text-align: center; \"><spring:message code='lbl.divisionChart' /></td>";
						drawTmp += "<td colspan=\"4\" style=\"background-color: #bbdefb;width: 72%;text-align: center; \"><spring:message code='lbl.month2' /></td></tr>";
						
						drawTmp += "<tr><td style=\"background-color: #bbdefb;width: 18%;text-align: center; \">M0</td>";
						drawTmp += "<td style=\"background-color: #bbdefb;width: 18%;text-align: center; \">M + 1</td>";
						drawTmp += "<td style=\"background-color: #bbdefb;width: 18%;text-align: center; \">M + 2</td>";
						drawTmp += "<td style=\"background-color: #bbdefb;width: 18%;text-align: center; \">M + 3</td></tr>";
					}
					
					drawTmp += "<tr><td style=\"background-color: #bbdefb;width: 18%;text-align: center; \">"+ measNm +"</td>";
					drawTmp += "<td>"+ oneData +"</td>";
					drawTmp += "<td>"+ twoData +"</td>";
					drawTmp += "<td>"+ threeData +"</td>";
					drawTmp += "<td>"+ fourData +"</td></tr>";
				});
				$("#invPsiChart").html(drawTmp);
				
			}else if(popupChart.chart_id == "dueRateChart"){
				
				var firstWeek = popupChart.weekList.week[0].FIRST_WEEK;
				var secondWeek = popupChart.weekList.week[0].SECOND_WEEK;
				
				var weekDay = popupChart.weekDayList.weekDay[0].WEEK_DAY;
				var weekDayArr = weekDay.split('/');
				var WEEKDAY = weekDayArr[1]+'월' +weekDayArr[2]+'일';
				
				var drawTmp = "<tr><td rowspan=\"2\" style=\"background-color: #bbdefb;width: 9%;text-align: center; \"></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \">"+ firstWeek +"</td><td colspan=\"3\" style=\"background-color: #bbdefb;width: 9%;text-align: center; \">"+WEEKDAY+"</td>";
				drawTmp += "<td colspan=\"6\" style=\"background-color: #bbdefb;width: 9%;text-align: center; \">"+ secondWeek +"</td></tr>";
				drawTmp += "<tr><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dueRate2' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.estimatedDailyDeliveryQuantity' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyDeliveryComplianceAmount' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyDeliveryComplianceRate' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyAccumRecvQty' /></td>";
				drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyAccumDueQty' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyAccumDueRate' /></td>";
				drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.weekRecvQty' /></td>";
				drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.weekRecvResultQty' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.weekProgress' /></td></tr>";
				
			
				$.each(res.dueRateChart, function(i, val){
					
					var gubun = val.GUBUN;
					var lastCompRate = val.LAST_COMP_RATE;
					var compRate = val.COMP_RATE;
					var schedQty = gfn_addCommas(val.SCHED_QTY);
					var preRecvQty = gfn_addCommas(val.PRE_RECV_QTY);
					var dayAccSchedQty = gfn_addCommas(val.DAY_ACC_SCHED_QTY);
					var dayAccPreRecvQty = gfn_addCommas(val.DAY_ACC_PRE_RECV_QTY);
					var dayAccCompRate = gfn_addCommas(val.DAY_ACC_COMP_RATE);
					var daySchedQty = gfn_addCommas(val.DAY_SCHED_QTY);
					var	dayPreRecvQty = gfn_addCommas(val.DAY_PRE_RECV_QTY);
					var	dayCompRate	= gfn_addCommas(val.DAY_COMP_RATE);
					
					drawTmp += "<tr>";
					drawTmp += "<td style=\"background-color: #bbdefb;text-align: center; \">"+ gubun +"</td>";
					drawTmp += "<td>"+ lastCompRate +"</td>";
					drawTmp += "<td>"+daySchedQty+"</td>";
					drawTmp += "<td>"+dayPreRecvQty+"</td>";
					drawTmp += "<td>"+dayCompRate+"</td>";
					drawTmp += "<td>"+ dayAccSchedQty +"</td>";
					drawTmp += "<td>"+ dayAccPreRecvQty +"</td>";
					drawTmp += "<td>"+ dayAccCompRate +"</td>";
					drawTmp += "<td>"+ schedQty +"</td>";
					drawTmp += "<td>"+ preRecvQty +"</td>";
					drawTmp += "<td>"+ compRate +"</td>";
					drawTmp += "</tr>";
				
				});
				
				$("#dueRateChart").html(drawTmp);
				
				/* var drawTmp = "<tr><td rowspan=\"2\" style=\"background-color: #bbdefb;width: 20%;text-align: center; \"><spring:message code='lbl.procure2' /></td><td style=\"background-color: #bbdefb;width: 20%;text-align: center; \"><spring:message code='lbl.preWeek' /></td>";
				drawTmp += "<td colspan=\"3\" style=\"background-color: #bbdefb;width: 20%;text-align: center; \"><spring:message code='lbl.thisWeek2' /></td></tr>";
				drawTmp += "<tr><td style=\"background-color: #bbdefb;width: 20%;text-align: center; \"><spring:message code='lbl.dueRate2' /></td><td style=\"background-color: #bbdefb;width: 20%;text-align: center; \"><spring:message code='lbl.dueRate2' /></td>";
				drawTmp += "<td style=\"background-color: #bbdefb;width: 20%;text-align: center; \"><spring:message code='lbl.schedQty2' /></td><td style=\"background-color: #bbdefb;width: 20%;text-align: center; \"><spring:message code='lbl.observe2' /></td></tr>";
				
				$.each(res.dueRateChart, function(i, val){
					
					var gubun = val.GUBUN;
					var lastCompRate = gfn_addCommas(gfn_nvl(val.LAST_COMP_RATE, ""));
					var compRate = gfn_addCommas(gfn_nvl(val.COMP_RATE, ""));
					var schedQty = gfn_addCommas(gfn_nvl(val.SCHED_QTY, ""));
					var preRecvQty = gfn_addCommas(gfn_nvl(val.PRE_RECV_QTY, ""));
					
					drawTmp += "<tr>";
					drawTmp += "<td style=\"background-color: #bbdefb;text-align: center; \">"+ gubun +"</td>";
					drawTmp += "<td>"+ lastCompRate +"</td>";
					drawTmp += "<td>"+ compRate +"</td>";
					drawTmp += "<td>"+ schedQty +"</td>";
					drawTmp += "<td>"+ preRecvQty +"</td>";
					drawTmp += "</tr>";
				});
				
				$("#dueRateChart").html(drawTmp); */
			}else if(popupChart.chart_id == "warehousRateChart"){
				
				var firstWeek = popupChart.weekList.week[0].FIRST_WEEK;
				var secondWeek = popupChart.weekList.week[0].SECOND_WEEK;
				
				var weekDay = popupChart.weekDayList.weekDay[0].WEEK_DAY;
				var weekDayArr = weekDay.split('/');
				var WEEKDAY = weekDayArr[1]+'월' +weekDayArr[2]+'일';
				
				var drawTmp = "<tr><td rowspan=\"2\" style=\"background-color: #bbdefb;width: 9%;text-align: center; \"></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \">"+ firstWeek +"</td><td colspan=\"3\" style=\"background-color: #bbdefb;width: 9%;text-align: center; \">"+WEEKDAY+"</td>";
				drawTmp += "<td colspan=\"6\" style=\"background-color: #bbdefb;width: 9%;text-align: center; \">"+ secondWeek +"</td></tr>";
				drawTmp += "<tr><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.warehousRate2' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.estimatedDailyStockingQuantity' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyWarehousingComplianceAmount' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyWarehousingComplianceRate' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyAccumShipExpQty' /></td>";
				drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyAccumShipQty' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyAccumShipRate' /></td>";
				drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.weekShipQty' /></td>";
				drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.weekShipResultQty' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.weekProgress' /></td></tr>";
				
				
				
				$.each(res.warehousRateChart, function(i, val){
					
					var gubun = val.GUBUN;
					var lastCompRate = val.LAST_COMP_RATE;
					var compRate = val.COMP_RATE;
					var schedQty = gfn_addCommas(val.SCHED_QTY);
					var grQty = gfn_addCommas(val.GR_QTY);
					var dayAccSchedQty = gfn_addCommas(val.DAY_ACC_SCHED_QTY);
					var dayAccGrQty = gfn_addCommas(val.DAY_ACC_GR_QTY);
					var dayAccCompRate = gfn_addCommas(val.DAY_ACC_COMP_RATE);
					var daySchedQty    = gfn_addCommas(val.DAY_SCHED_QTY);
					var	dayGrQty	   = gfn_addCommas(val.DAY_GR_QTY);
					var dayCompRate    = gfn_addCommas(val.DAY_COMP_RATE);
					
					
					drawTmp += "<tr>";
					drawTmp += "<td style=\"background-color: #bbdefb;text-align: center; \">"+ gubun +"</td>";
					drawTmp += "<td>"+ lastCompRate +"</td>";
					drawTmp += "<td>"+daySchedQty +"</td>";
					drawTmp += "<td>"+dayGrQty +"</td>";
					drawTmp += "<td>"+ dayCompRate+"</td>";
					drawTmp += "<td>"+ dayAccSchedQty +"</td>";
					drawTmp += "<td>"+ dayAccGrQty +"</td>";
					drawTmp += "<td>"+ dayAccCompRate +"</td>";
					drawTmp += "<td>"+ schedQty +"</td>";
					drawTmp += "<td>"+ grQty +"</td>";
					drawTmp += "<td>"+ compRate +"</td>";
					drawTmp += "</tr>";
					
					
				});
				
				$("#warehousRateChart").html(drawTmp);
				
				
				/* var drawTmp = "<tr><td rowspan=\"2\" style=\"background-color: #bbdefb;width: 20%;text-align: center; \"><spring:message code='lbl.procure2' /></td><td style=\"background-color: #bbdefb;width: 20%;text-align: center; \"><spring:message code='lbl.preWeek' /></td>";
				drawTmp += "<td colspan=\"3\" style=\"background-color: #bbdefb;width: 20%;text-align: center; \"><spring:message code='lbl.thisWeek2' /></td></tr>";
				drawTmp += "<tr><td style=\"background-color: #bbdefb;width: 20%;text-align: center; \"><spring:message code='lbl.warehousRate2' /></td><td style=\"background-color: #bbdefb;width: 20%;text-align: center; \"><spring:message code='lbl.warehousRate2' /></td>";
				drawTmp += "<td style=\"background-color: #bbdefb;width: 20%;text-align: center; \"><spring:message code='lbl.schedQty2' /></td><td style=\"background-color: #bbdefb;width: 20%;text-align: center; \"><spring:message code='lbl.observe2' /></td></tr>";
				
				$.each(res.warehousRateChart, function(i, val){
					
					var gubun = val.GUBUN;
					var lastCompRate = gfn_addCommas(gfn_nvl(val.LAST_COMP_RATE, ""));
					var compRate = gfn_addCommas(gfn_nvl(val.COMP_RATE, ""));
					var schedQty = gfn_addCommas(gfn_nvl(val.SCHED_QTY, ""));
					var grQty = gfn_addCommas(gfn_nvl(val.GR_QTY, ""));
					
					drawTmp += "<tr>";
					drawTmp += "<td style=\"background-color: #bbdefb;text-align: center; \">"+ gubun +"</td>";
					drawTmp += "<td>"+ lastCompRate +"</td>";
					drawTmp += "<td>"+ compRate +"</td>";
					drawTmp += "<td>"+ schedQty +"</td>";
					drawTmp += "<td>"+ grQty +"</td>";
					drawTmp += "</tr>";
				});
				
				$("#warehousRateChart").html(drawTmp); */
				
			}else if(popupChart.chart_id ==  "materialAvaRateChart"){
				
				var flag = $(':radio[name=materialAvaRateFlag]:checked').val();
				var resultLabel = "";
				var resultLabel2 = "";
				
				if(flag == "ava"){//가용률
					resultLabel = "<spring:message code='lbl.availableRate' />";
					resultLabel2 = " <spring:message code='lbl.comAcount' />";
				}else if(flag == "ready"){//준비율
					resultLabel = "<spring:message code='lbl.rrChart' />(%)";
					resultLabel2 = " <spring:message code='lbl.cnt2' />";
				}
				
				var drawTmp = "<tr><td rowspan=\"2\" style=\"background-color: #bbdefb;width: 20%;text-align: center; \"><spring:message code='lbl.procure2' /></td><td rowspan=\"2\" style=\"background-color: #bbdefb;width: 16%;text-align: center; \"><spring:message code='lbl.goal' />(%)</td><td style=\"background-color: #bbdefb;width: 16%;text-align: center; \"><spring:message code='lbl.preWeek' /></td>";
				drawTmp += "<td colspan=\"3\" style=\"background-color: #bbdefb;width: 16%;text-align: center; \"><spring:message code='lbl.thisWeek2' /></td></tr>";
				drawTmp += "<tr><td style=\"background-color: #bbdefb;width: 16%;text-align: center; \">"+ resultLabel +"</td><td style=\"background-color: #bbdefb;width: 16%;text-align: center; \">"+ resultLabel +"</td>";
				drawTmp += "<td style=\"background-color: #bbdefb;width: 16%;text-align: center; \"><spring:message code='lbl.preparation' />"+ resultLabel2 +"</td><td style=\"background-color: #bbdefb;width: 16%;text-align: center; \"><spring:message code='lbl.unprepared' />"+ resultLabel2 +"</td></tr>";
				
				$.each(res.materialAvaRateChart, function(i, val){
					
					var gubun = val.GUBUN;
					var targetValue = gfn_addCommas(gfn_nvl(val.TARGET_VALUE, ""));
					var lastWeekRate = gfn_addCommas(gfn_nvl(val.LAST_WEEK_RATE, ""));
					var curWeekRate = gfn_addCommas(gfn_nvl(val.CUR_WEEK_RATE, ""));
					var prepQty = gfn_addCommas(gfn_nvl(val.PREP_QTY, ""));
					var noPrepQty = gfn_addCommas(gfn_nvl(val.NO_PREP_QTY, ""));
					
					drawTmp += "<tr>";
					drawTmp += "<td style=\"background-color: #bbdefb;text-align: center; \">"+ gubun +"</td>";
					drawTmp += "<td>"+ targetValue +"</td>";
					drawTmp += "<td>"+ lastWeekRate +"</td>";
					drawTmp += "<td>"+ curWeekRate +"</td>";
					drawTmp += "<td>"+ prepQty +"</td>";
					drawTmp += "<td>"+ noPrepQty +"</td>";
					drawTmp += "</tr>";
				});
				
				$("#materialAvaRateChart").html(drawTmp);
			}
			$("#" + popupChart.chart_id).css("overflow", "");
		},
		
		tagetStyle : function (arData) {
			$.each(arData, function(i, val) {
				if (val.name.indexOf('Target') > -1) {
					val.dashStyle = 'ShortDash';
					val.marker  = { enabled: false }; 
				} 
			});
			
			return arData;
		},
		
		chartGen : function (chartId, type, arCarte, arData, isStack) {
			
			if (chartId == 'chart6') {
				Highcharts.theme.colors[1] = '#f7848d';
				Highcharts.theme.colors[2] = gv_cColor1;
				Highcharts.theme.colors[3] = '#f7848d';
			} else {
				Highcharts.theme.colors[1] = gv_cColor2;
				Highcharts.theme.colors[2] = '#f7848d';
				Highcharts.theme.colors[3] = '#f0a482';
			}
			
			if (arData.length == 0) {
				return false;
			}
			
			isStack = isStack || false;
			
			var chart = {
				chart  : { type : type },
				xAxis  : { categories : arCarte },
				series : arData,
				plotOptions: {
					column: {
						stacking: 'normal',
						dataLabels: {
							enabled: true,
						},
					},
					series: {
						events: {
							afterAnimate : function(e){
			        			var chartLen = this.chart.series.length;
			        			
			        			if(chartId == "chart8")	{
			        				for(var i = 0; i < chartLen; i++){
			        					
			        					var chartCode = this.chart.series[i].userOptions.code;
			        					
			        					if(chartCode != "RCG001"){
			        						this.chart.series[i].hide();	
			        					}
			        				}
			        			}else if(chartId == "chart9") {
									for(var i = 0; i < chartLen; i++){
			        					
			        					var chartCode = this.chart.series[i].userOptions.code;
			        					
			        					if(chartCode != "Long Boat"){
			        						this.chart.series[i].hide();	
			        					}
			        				}
			        			}else if(chartId == "chart23")	{
			        				for(var i = 0; i < chartLen; i++){
			        					
			        					var chartCode = this.chart.series[i].userOptions.code;
			        					
			        					if(chartCode != "RCG001"){
			        						this.chart.series[i].hide();	
			        					}
			        				}
			        			}
			        		},
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
						}
					}
				},
			};
			
			if (!isStack) {
				delete chart.plotOptions.column.stacking;
			}
			
			Highcharts.chart(chartId, chart);
			
			//하이차트 버전 업 후 가려지는 현상 
			$("#" + chartId).css("overflow", "");
		}
	};
	
	
	function fn_setHighchartTheme(isStack) {
		var theme = {
			colors: gv_cColors,
			chart: {
				backgroundColor: {
					linearGradient: [0, 0, 500, 500],
					stops: [
						[0, 'rgb(255, 255, 255)'],
					]
				},
				style: {
					fontFamily: 'Arial'
				}
			},
			title: {
				text: null ,
				style: {
					color: '#000',
					font: 'bold 30px "Arial", Verdana, sans-serif'
				}
			},
			subtitle: {
				style: {
					color: '#666666',
					font: 'bold 30px "Arial", Verdana, sans-serif'
				}
			},
			xAxis : {
				labels : {
					style : {
						fontSize : "30px"
					}
				}
			},
			yAxis: {
				min    : 0,
				labels : { enabled : false}, 
				title: { text: null },
				stackLabels: { enabled: false },
			},
			legend: {
				enabled: true,
				itemStyle : {
					color      : '#000',
					fontSize   : '30px',
					fontWeight : 'normal'
				}
			},
			tooltip : {
				
				headerFormat: '<span style="font-size: 30px">{point.key}</span><br/>',
				enabled : false,
				style : {
					fontSize : "30px"
				}
			},
			credits: {
				enabled: false
			},
			exporting : {
				enabled: true,
				buttons: {
					contextButton: {
		            	align: 'right',
						menuItems: ['printChart','downloadJPEG', 'downloadPDF']
					}
				}
			},
			plotOptions: {
				series: {
					maxPointWidth: 50
				},
				line: {
					dataLabels: {
						enabled: true,
						style : {
							fontSize : "30px"
						}
					},
					enableMouseTracking: true,
				},
				column: {
					dataLabels: {
						enabled: true,
						style : {
							fontSize : "30px"
						}
					},
				},
				area: {
					stacking: 'normal',
					lineColor: '#666666',
					lineWidth: 1,
					marker: {
						lineWidth: 1,
						lineColor: '#666666'
					}
				}
			},
			lang: {
				thousandsSep: ','
			}
		};
		
		//테마변수 set
		Highcharts.theme = theme;
		
		// Apply the theme
		Highcharts.setOptions(Highcharts.theme);
	}
	
	//조회
	function fn_apply(sqlFlag) {
	
	}
	
 	// onload 
	$(document).ready(function() {
		popupChart.init();
	});
	

</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv" style="height:1000px;">
		<div class="popCont">
			<!-- chart -->
			<div id="cont_chart">
				<div class="col_3">
					<c:choose>
						<c:when test="${popupChartPurchase.chartId == 'dueRateChart' or popupChartPurchase.chartId == 'warehousRateChart'}">
						<h4 id="title" style="font-size: 30px;">${popupChartPurchase.title} <div style="text-align: right;color:red;font-size:20px;"><spring:message code="lbl.silinder" /></div> </h4>
						</c:when>
						<c:otherwise>
						<h4 id="title" style="font-size: 30px;">${popupChartPurchase.title} </h4>	
						</c:otherwise>
					</c:choose>
					<c:choose>
						
						<c:when test="${popupChartPurchase.chartId == 'priceCostChart'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="priceCost1" name="priceCost" value="price" checked="checked"/> <label for="priceCost1"><spring:message code="lbl.amtChart" /></label></li>
								<li><input type="radio" id="priceCost2" name="priceCost" value="cost"/><label for="priceCost2"><spring:message code="lbl.costChart" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="priceCostChart"></div>
						</c:when>
						
						
						<c:when test="${popupChartPurchase.chartId == 'invAgingChart'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="monthFlag3" name="monthFlag" value="M3" checked="checked"/> <label for="monthFlag3"><spring:message code="lbl.3mMore" /></label></li>
								<li><input type="radio" id="monthFlag6" name="monthFlag" value="M6"/><label for="monthFlag6"><spring:message code="lbl.6mMore" /> </label></li>
								<li><input type="radio" id="monthFlag12" name="monthFlag" value="M12"/><label for="monthFlag12"><spring:message code="lbl.yearOneMore" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="invAgingChart"></div>
						</c:when>
						
						<c:when test="${popupChartPurchase.chartId == 'invPsiChart'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="invPsiFlag2" name="invPsiFlag" value="osfp"/><label for="invPsiFlag2"><spring:message code="lbl.osfp" /> </label></li>
								<li><input type="radio" id="invPsiFlag3" name="invPsiFlag" value="rawMaterial"/><label for="invPsiFlag3"><spring:message code="lbl.rawMaterial" /> </label></li>
								<li><input type="radio" id="invPsiFlag1" name="invPsiFlag" value="total" checked="checked"/> <label for="invPsiFlag1"><spring:message code="lbl.total" /></label></li>
							</ul>
						</div>
						<table>
							<tbody id="invPsiChart">
							</tbody>
						</table>
						</c:when>
						
						<c:when test="${popupChartPurchase.chartId == 'warehousRateChart'}">
						<div class="view_combo" style="float: right;">
						</div>
						<table>
							<tbody id="warehousRateChart">
							</tbody>
						</table>
						</c:when>
						
						<c:when test="${popupChartPurchase.chartId == 'materialAvaRateChart'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="materialAvaRateFlag1" name="materialAvaRateFlag" value="ava" checked="checked"/> <label for="materialAvaRateFlag1"><spring:message code="lbl.availableRate3" /></label></li>
								<li><input type="radio" id="materialAvaRateFlag2" name="materialAvaRateFlag" value="ready"/><label for="materialAvaRateFlag2"><spring:message code="lbl.rrChart" /> </label></li>
							</ul> 
						</div>
						<table>
							<tbody id="materialAvaRateChart">
							</tbody>
						</table>
						</c:when>
						
						<c:when test="${popupChartPurchase.chartId == 'dueRateChart'}">
						<div class="view_combo" style="float: right;">
							<%-- <ul class="rdofl">
								<li><input type="radio" id="materialAvaRateFlag1" name="materialAvaRateFlag" value="ava" checked="checked"/> <label for="materialAvaRateFlag1"><spring:message code="lbl.availableRate3" /></label></li>
								<li><input type="radio" id="materialAvaRateFlag2" name="materialAvaRateFlag" value="ready"/><label for="materialAvaRateFlag2"><spring:message code="lbl.rrChart" /> </label></li>
							</ul>  --%>
						</div>
						<table>
							<tbody id="dueRateChart">
							</tbody>
						</table>
						</c:when>
						
						
						
						
						
					</c:choose>

				</div>
			</div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>