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
		height: 92%;
	    border: 1px solid #444444;
	}
	
	td {
		border: 1px solid #444444;
		padding-right: 5px;
		text-align: right;
		
	}
</style>

<script type="text/javascript">

	var popupChart = {

		init : function () {
			
			this.initSearch();
			this.events();
			
			var userLang = "${sessionScope.GV_LANG}";
			
			if(userLang == "ko") {
	    		unit = 100000000;
	    	} else if(userLang == "en" || userLang == "cn") {
	    		unit = 1000000000;
	    	}
		},
	
		_siq	: "dashboard.purchaseTrend.",
		chart_id : "${popupChartPurchaseTrend.chartId}",
		
		events : function () {
			
			$("#btnClose").on("click", function(){
				window.close(); 
			});
			
			$(':radio[name=materialFlag]').on('change', function () {
				popupChart.materialTrendSearch(false);
			});
			
			$(':radio[name=outSideFlag]').on('change', function () {
				popupChart.outSideTrendSearch(false);
			});
			
			$(':radio[name=inv]').on('change', function () {
				popupChart.invSearch(false);
			});
			
			$(':radio[name=inv_type]').on('change', function () {
				popupChart.invSearch(false);
			});
			
			$(':radio[name=inv_weekMonth_type]').on('change', function () {
				popupChart.invSearch(false);
			});
			
			$(':radio[name=agingTrend]').on('change', function () {
				popupChart.aTrendSearch(false);
			});
			$(':radio[name=agingTrendCostSale]').on('change', function () {
				popupChart.aTrendSearch(false);
			});
			$(':radio[name=agingTrendInv]').on('change', function () {
				popupChart.aTrendSearch(false);
			});
			
			$(':radio[name=weekMonth]').on('change', function () {
				popupChart.trend17Search(false);
			});
			$(':radio[name=proTypeTotal]').on('change', function () {
				popupChart.trend17Search(false);
			});
			
			$(':radio[name=chart18WeekMonth]').on('change', function () {
				popupChart.trend18Search(false);
			});
			$(':radio[name=chart18ProTypeTotal]').on('change', function () {
				popupChart.trend18Search(false);
			});
		},
		
		bucket : null,
		
		initSearch : function () {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [{ outDs : "week"  , _siq : popupChart._siq + "trendBucketWeek" }
			  , { outDs : "month" , _siq : popupChart._siq + "trendBucketMonth" }
			  , { outDs : "month2" , _siq : popupChart._siq + "trendBucketMonth2" }
			  , { outDs : "weekReceiveBucket" , _siq : popupChart._siq + "weekReceiveBucket" }
			];
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					popupChart.bucket = {};
					popupChart.bucket.week  = data.week;
					popupChart.bucket.weekReceive  = data.weekReceiveBucket;
					popupChart.bucket.month  = data.month;
					popupChart.bucket.month2 = data.month2;
					popupChart.search();
				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			FORM_SEARCH            = {};
			FORM_SEARCH            = this.bucket;
			
			if(popupChart.chart_id == "materialTrendChart") {
				FORM_SEARCH.materialFlag = $(':radio[name=materialFlag]:checked').val();	
			} else if(popupChart.chart_id == "outSideTrendChart") {
				FORM_SEARCH.outSideFlag = $(':radio[name=outSideFlag]:checked').val();	
			} else if(popupChart.chart_id == "chart7") {
				FORM_SEARCH.inv        = $(':radio[name=inv]:checked').val();
				FORM_SEARCH.inv_type = $(':radio[name=inv_type]:checked').val();
				FORM_SEARCH.inv_weekMonth_type = $(':radio[name=inv_weekMonth_type]:checked').val();	
			} else if(popupChart.chart_id == "chart22") {
				var agingTrendMeasCd = agingTrendCombo();
				FORM_SEARCH.agingTrendMeasCd = agingTrendMeasCd;
				FORM_SEARCH.agingTrendInv = $(':radio[name=agingTrendInv]:checked').val();
			} else if(popupChart.chart_id == "chart17") {
				FORM_SEARCH.weekMonth  = $(':radio[name=weekMonth]:checked').val();
				FORM_SEARCH.proTypeTotal = $(':radio[name=proTypeTotal]:checked').val();
			} else if(popupChart.chart_id == "chart18") {
				FORM_SEARCH.chart18WeekMonth  = $(':radio[name=chart18WeekMonth]:checked').val();
				FORM_SEARCH.chart18ProTypeTotal = $(':radio[name=chart18ProTypeTotal]:checked').val();
			} 
			
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.unit = unit;
			
			FORM_SEARCH.tranData   = [
				{ outDs : popupChart.chart_id , _siq : popupChart._siq + popupChart.chart_id }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					if(popupChart.chart_id == "materialTrendChart") {
						popupChart.drawMaterialOutSideTrendChart(data.materialTrendChart);	
					}else if(popupChart.chart_id == "outSideTrendChart") {
						popupChart.drawMaterialOutSideTrendChart(data.outSideTrendChart);	
					}else if(popupChart.chart_id == "chart7") {
						popupChart.drawChart(data);
					}else if(popupChart.chart_id == "chart22") {
						popupChart.drawChart(data);
					}else if(popupChart.chart_id == "chart17") {
						popupChart.drawChart(data);
					}else if(popupChart.chart_id == "mainRawMaterialChart") {
						popupChart.drawChart(data);
					}else if(popupChart.chart_id == "chart18") {
						popupChart.drawChart(data);
					}else if(popupChart.chart_id == "weekReceiveRateChart") {
						popupChart.drawChart(data);
					}else if(popupChart.chart_id == "dayReceiveRateChart") {
						popupChart.drawChart(data);
					}else if(popupChart.chart_id == "weekDeliRateChart") {
						popupChart.drawChart(data);
					}else if(popupChart.chart_id == "dayRateChart") {
						popupChart.drawChart(data);
					}
					
					
					
					
					
					
					
				}
			};
			gfn_service(sMap,"obj");
		},
		
		materialTrendSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.materialFlag = $(':radio[name=materialFlag]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.unit = unit;
			FORM_SEARCH.tranData = [
				{ outDs : popupChart.chart_id , _siq : popupChart._siq + popupChart.chart_id }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					popupChart.drawMaterialOutSideTrendChart(data.materialTrendChart);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		outSideTrendSearch  : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.outSideFlag    = $(':radio[name=outSideFlag]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.unit     = unit;
			FORM_SEARCH.tranData = [
				{ outDs : popupChart.chart_id , _siq : popupChart._siq + popupChart.chart_id }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					popupChart.drawMaterialOutSideTrendChart(data.outSideTrendChart);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		invSearch : function (sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.inv      = $(':radio[name=inv]:checked').val();
			FORM_SEARCH.inv_type = $(':radio[name=inv_type]:checked').val();
			FORM_SEARCH.inv_weekMonth_type = $(':radio[name=inv_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart7" , _siq : popupChart._siq + "chart7" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreCate = new Array();
					var chart7 = JSON.parse(data.chart7[0].INVENTORY);
					
					if(FORM_SEARCH.inv_weekMonth_type == "WEEK"){
						$.each (popupChart.bucket.week, function (i, el) {
							arPreCate.push(el.DISWEEK);
						});
					}else{
						$.each (popupChart.bucket.month, function (i, el) {
							arPreCate.push(el.DISMONTH);
						});
					}
					popupChart.chartGen('chart7', 'line', arPreCate, chart7);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		aTrendSearch : function(sqlFlag) {
			
			var agingTrendMeasCd = agingTrendCombo();

			FORM_SEARCH = {}
			FORM_SEARCH = popupChart.bucket;
			FORM_SEARCH.agingTrendInv = $(':radio[name=agingTrendInv]:checked').val();
			FORM_SEARCH.agingTrendMeasCd = agingTrendMeasCd;
			
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart22" , _siq : popupChart._siq + "chart22" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreMonth = new Array();
					$.each (popupChart.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart22  = JSON.parse(data.chart22[0].AGING_TREND);

					popupChart.chartGen('chart22', 'line', arPreMonth, chart22);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		trend17Search : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.weekMonth  = $(':radio[name=weekMonth]:checked').val();
			FORM_SEARCH.proTypeTotal = $(':radio[name=proTypeTotal]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart17" , _siq : popupChart._siq + "chart17" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					var arPreWeek = new Array();
					var arPreMonth = new Array();
			
					$.each (popupChart.bucket.week, function (i, el) {
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					$.each (popupChart.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart17 = JSON.parse(data.chart17[0].ITEM);
					
					if(FORM_SEARCH.weekMonth == "week"){
						popupChart.chartGen('chart17', 'line', arPreWeek, chart17);
					}else{
						popupChart.chartGen('chart17', 'line', arPreMonth, chart17);
					}
				}
			}
			gfn_service(sMap,"obj");
		},
		
		trend18Search : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.chart18WeekMonth  = $(':radio[name=chart18WeekMonth]:checked').val();
			FORM_SEARCH.chart18ProTypeTotal = $(':radio[name=chart18ProTypeTotal]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart18" , _siq : popupChart._siq + "chart18" }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					var arPreWeek = new Array();
					var arPreMonth = new Array();
			
					$.each (popupChart.bucket.week, function (i, el) {
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					$.each (popupChart.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart18 = JSON.parse(data.chart18[0].CAPA);
					
					if(FORM_SEARCH.chart18WeekMonth == "week"){
						popupChart.chartGen('chart18', 'line', arPreWeek, chart18);
					}else{
						popupChart.chartGen('chart18', 'line', arPreMonth, chart18);
					}
				}
			}
			gfn_service(sMap,"obj");
		},
		
		drawMaterialOutSideTrendChart : function(res){
			
			fn_setHighchartTheme();
			
			var chartId = popupChart.chart_id;
			var arMonth = new Array();
			var seriesArr = new Array();
			var seriesArrAmt = new Array();
			var seriesArrRate = new Array();
			var checkBoxFlag = "";
			var materialFlag = $(':radio[name=materialFlag]:checked').val();
			var outSideFlag = $(':radio[name=outSideFlag]:checked').val();
			var firstName = "";
			var secondtName = "";
			
			if(chartId == "materialTrendChart"){
				checkBoxFlag = materialFlag;
				firstName = '<spring:message code="lbl.materialCost" />(<spring:message code="lbl.billion" />)'; 
				secondtName = '<spring:message code="lbl.materialRatio" />';
			}else{
				checkBoxFlag = outSideFlag;
				firstName = '<spring:message code="lbl.outSideCost2" />(<spring:message code="lbl.billion" />)';
				secondtName = '<spring:message code="lbl.outsideRate" />';
			}
			
			$.each (popupChart.bucket.month2, function (i, el) {
				arMonth.push(el.DISMONTH);
			});
			
			$.each(res, function(i, val){
				
				var trendMonth = val.TREND_MONTH;
				var prodPart = val.PROD_PART;
				var measCd = val.MEAS_CD;
				var resultValue = val.RESULT_VALUE;
				var sortFlag = val.SORT_FLAG;
				
				if(checkBoxFlag == "total"){
					
					if(measCd == "AMT"){
						seriesArrAmt.push(resultValue);
						
						if(sortFlag == 7){
							var tmp = {type : "column", name : firstName, data : seriesArrAmt}
							seriesArr.push(tmp);
						}
					}else if(measCd == "RATE"){
						
						seriesArrRate.push(resultValue);
						
						if(sortFlag == 7){
							var tmp = {type : "spline", name : secondtName, data : seriesArrRate, marker: {lineWidth: 2, lineColor: Highcharts.getOptions().colors[3], fillColor: 'white'}}
							seriesArr.push(tmp);
						}
					}
					
				}else{
					
					if(measCd == "AMT"){
						seriesArrAmt.push(resultValue);
						
						if(sortFlag == 7){
							var tmp = {type : "column", name : prodPart, data : seriesArrAmt}
							seriesArr.push(tmp);
							seriesArrAmt = new Array();
						}
					}else if(measCd == "RATE"){
						
						seriesArrRate.push(resultValue);
						
						if(sortFlag == 7){
							var tmp = {type : "spline", name : prodPart, data : seriesArrRate, marker: {lineWidth: 2, lineColor: Highcharts.getOptions().colors[3], fillColor: 'white'}}
							seriesArr.push(tmp);
							seriesArrRate = new Array();
						}
					}
				}
			});
			
			Highcharts.chart(chartId, {
			    title: {
			        text: ''
			    },
			    xAxis: {
			        categories: arMonth
			    },
			    yAxis: {
					//title: { text: null }
			    	labels : { enabled : false}
				},
				
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
			            }
				    }
				},
			    series: seriesArr
			});
		
			$("#" + chartId).css("overflow", "");
		},
		
		
		drawChart : function (res) {
			fn_setHighchartTheme();
			
			var arPreWeek  = new Array();
			var arWeek     = new Array();
			var arMonth    = new Array();
			var arPreMonth = new Array();
			
			$.each (popupChart.bucket.month, function (i, el) {
				arMonth.push(el.DISMONTH);
				arPreMonth.push(el.PRE_DISMONTH);
			});
			
			$.each (popupChart.bucket.week, function (i, el) {
				arWeek.push(el.DISWEEK);
				arPreWeek.push(el.PRE_DISWEEK);
			});
			
			if(popupChart.chart_id == "chart7") {
				var chart7 = JSON.parse(res.chart7[0].INVENTORY);
				this.chartGen('chart7', 'line', arWeek, chart7);
			}else if(popupChart.chart_id == "chart22") {
				var chart22 = JSON.parse(res.chart22[0].AGING_TREND);
				this.chartGen('chart22', 'line', arPreMonth, chart22);
			}else if(popupChart.chart_id == "chart17") {
				
				var weekMonth = $(':radio[name=weekMonth]:checked').val();
				var chart17 = JSON.parse(res.chart17[0].ITEM);
				
				if(weekMonth == "week"){
					this.chartGen('chart17', 'line', arPreWeek, chart17);
				}else{
					this.chartGen('chart17', 'line', arPreMonth, chart17);
				}
			}else if(popupChart.chart_id == "mainRawMaterialChart") {
				
				var tempChart = "<tr><td width=\"20\" style=\"background-color: #bbdefb;text-align: center; \"><spring:message code='lbl.bpNm2' /></td>";
	            var rnArray = [];
	            var rn_max  = null;
	            
	            $.each(res.mainRawMaterialChart, function(i, val){
	                rnArray.push(val.RN)
	            })
	            
	            rn_max = Math.max.apply(null, rnArray);
	            
	            $.each(res.mainRawMaterialChart, function(i, val){
	                
	                var itemGroupNm = val.ITEM_GROUP_NM;
	                
	                if(i <= rn_max){
	                    tempChart += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \">"+ itemGroupNm +"</td>";
	                }
	                
	                if(i == (rn_max+1)){
	                    tempChart += "</tr>";
	                    return false;
	                }
	                
	            });
	            
	            $.each(res.mainRawMaterialChart, function(i, val){
	                
	                var bpNm = val.BP_NM;
	                var purLt = gfn_nvl(val.PUR_LT, -999);
	                var rn = val.RN;
	                
	                if(rn == 0){
	                    
	                    if(bpNm.length > 7)
	                    {
	                        var tempString = bpNm.substr(0,9);
	                       tempChart += "<tr ><td style=\"background-color: #bbdefb;width: 11%;text-align: center; \">"+ tempString +"</td>";
	                    } 
	                    else
	                    {
	                        tempChart += "<tr><td style=\"background-color: #bbdefb;width: 11%;text-align: center; \">"+ bpNm +"</td>";
	                    }
	                
	                    if(purLt == -999){
	                        tempChart += "<td style=\"background-color: #BDBDBD; \"></td>";
	                    }else{
	                        tempChart += "<td>"+ purLt +"</td>"; 
	                    }
	                    
	                }else{
	                    
	                    if(purLt == -999){
	                        tempChart += "<td style=\"background-color: #BDBDBD; \"></td>";
	                    }else{
	                        tempChart += "<td>"+ purLt +"</td>"; 
	                    }
	                    
	                    if(rn == (rn_max+1)){
	                        tempChart += "</tr>";   
	                    }
	                }
	            });
	            
				
				$("#mainRawMaterialChart").html(tempChart);
			}else if(popupChart.chart_id == "chart18") {
				
				var weekMonth = $(':radio[name=chart18WeekMonth]:checked').val();
				var chart18 = JSON.parse(res.chart18[0].CAPA);
				
				if(weekMonth == "week"){
					this.chartGen('chart18', 'line', arPreWeek, chart18);
				}else{
					this.chartGen('chart18', 'line', arPreMonth, chart18);
				}
			}else if(popupChart.chart_id == "weekReceiveRateChart") {
				
				var arWeekReceive = new Array();
				
				$.each (popupChart.bucket.weekReceive, function (i, el) {
					arWeekReceive.push(el.DISWEEK);
				});
				
				var weekReceiveRateChart = JSON.parse(res.weekReceiveRateChart[0].WEEK_RECEIVE);
				this.chartGen('weekReceiveRateChart', 'line', arWeekReceive, weekReceiveRateChart);
				
			}else if(popupChart.chart_id == "dayReceiveRateChart") {
				var columnData1 = [], 
				columnData2 = [], 
				columnData3 = [],
				
				lineData1 = [], 
				lineData2 = [], 
				lineData3 = []
				

				xCate = [];
				
				
				$.each(res.dayReceiveRateChart, function(n, v) {
					
					var rn = v.RN;
					var yyyymmdd = v.DIS_YYYYMMDD;
					var codeCd = v.CODE_CD;
					var codeNm = v.CODE_NM;
					var measCd = v.MEAS_CD;
					var resultValue = gfn_nvl(v.RESULT_VALUE, 0);
					
					if(codeCd == "30"){
						
						if(measCd == "CNT"){
							if(rn == 0){
								xCate.push(codeNm);
							}
							columnData1.push({name : yyyymmdd, y : resultValue, color: gv_cColor1});
						}else if(measCd == "RATE"){
							if(rn == 0){
								xCate.push(codeNm);
							}
							lineData1.push({name: yyyymmdd, y: resultValue, color: gv_cColor4});		
						}
					}
					else if(codeCd == "MM"){
						if(measCd == "CNT"){
							if(rn == 0){
								xCate.push(codeNm);
							}
							columnData2.push({name : yyyymmdd, y : resultValue, color: gv_cColor3});
						}else if(measCd == "RATE"){
							if(rn == 0){
								xCate.push(codeNm);
							}
							lineData2.push({name: yyyymmdd, y: resultValue, color: gv_cColor6});		
						}
					}
					else if(codeCd == "OH"){
						if(measCd == "CNT"){
							if(rn == 0){
								xCate.push(codeNm);
							}
							columnData3.push({name : yyyymmdd, y : resultValue, color: gv_cColor2});
						}else if(measCd == "RATE"){
							if(rn == 0){
								xCate.push(codeNm);
							}
							lineData3.push({name: yyyymmdd, y: resultValue, color: gv_cColor5});
						}
					}
		    	});
				
				var chartId = "dayReceiveRateChart";
				Highcharts.chart(chartId, {
				    
					xAxis: { type: 'category' },
				    plotOptions: {
				    	column: {
				    		stacking: 'normal'
				    	},
				        series: {
				            dataLabels: {
				            	allowOverlap : true,
				                enabled: true
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
				    series: [
				        {
				            data: columnData1,
				            stack: 0,
				            type: 'column',
				            name: xCate[0]
				            
				        }, {
				            data: columnData2,
				            stack: 0,
				            type: 'column',
				            name: xCate[1]
				        }, {
				            data: columnData3,
				            stack: 0,
				            type: 'column',
				            name: xCate[2]
				        }
				        , {
				            data: lineData1,
				            type: 'line',
				            name: xCate[3]
				            //yAxis: 1
				        }, {
				            data: lineData2,
				            type: 'line',
				            name: xCate[4]
				            //yAxis: 1
				        }, {
				            data: lineData3,
				            type: 'line',
				            name: xCate[5]
				            //yAxis: 1
				        }
				    ]
				});
				
			}else if(popupChart.chart_id == "weekDeliRateChart") {
				
				var arWeekReceive = new Array();
				
				$.each (popupChart.bucket.weekReceive, function (i, el) {
					arWeekReceive.push(el.DISWEEK);
				});
				
				var weekDeliRateChart = JSON.parse(res.weekDeliRateChart[0].WEEK_DELIVERY);
				this.chartGen('weekDeliRateChart', 'line', arWeekReceive, weekDeliRateChart);
			}else if(popupChart.chart_id == "dayRateChart") {
				var columnData1 = [], 
				columnData2 = [], 
				columnData3 = [],
				
				lineData1 = [], 
				lineData2 = [], 
				lineData3 = [],
				
				xCate = [];
				
				$.each(res.dayRateChart, function(n, v) {
					
					var rn = v.RN;
					var yyyymmdd = v.DIS_YYYYMMDD;
					var codeCd = v.CODE_CD;
					var codeNm = v.CODE_NM;
					var measCd = v.MEAS_CD;
					var resultValue = gfn_nvl(v.RESULT_VALUE, 0);
					
					if(codeCd == "30"){
						
						if(measCd == "CNT"){
							if(rn == 0){
								xCate.push(codeNm);
							}
							columnData1.push({name : yyyymmdd, y : resultValue, color: gv_cColor1});
						}else if(measCd == "RATE"){
							if(rn == 0){
								xCate.push(codeNm);
							}
							lineData1.push({name: yyyymmdd, y: resultValue, color: gv_cColor4});		
						}
					}
					else if(codeCd == "MM"){
						if(measCd == "CNT"){
							if(rn == 0){
								xCate.push(codeNm);
							}
							columnData2.push({name : yyyymmdd, y : resultValue, color: gv_cColor3});
						}else if(measCd == "RATE"){
							if(rn == 0){
								xCate.push(codeNm);
							}
							lineData2.push({name: yyyymmdd, y: resultValue, color: gv_cColor6});		
						}
					}
					else if(codeCd == "OH"){
						if(measCd == "CNT"){
							if(rn == 0){
								xCate.push(codeNm);
							}
							columnData3.push({name : yyyymmdd, y : resultValue, color: gv_cColor2});
						}else if(measCd == "RATE"){
							if(rn == 0){
								xCate.push(codeNm);
							}
							lineData3.push({name: yyyymmdd, y: resultValue, color: gv_cColor5});
						}
					}
					
		    	});
				
				var chartId = "dayRateChart";
				Highcharts.chart(chartId, {
				    
					xAxis: { type: 'category' },
				    plotOptions: {
				    	column: {
				    		stacking: 'normal'
				    	},
				        series: {
				            dataLabels: {
				            	allowOverlap : true,
				                enabled: true
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
				    series: [
				        {
				            data: columnData1,
				            stack: 0,
				            type: 'column',
				            name: xCate[0]
				            
				        }, {
				            data: columnData2,
				            stack: 0,
				            type: 'column',
				            name: xCate[1]
				        }, {
				            data: columnData3,
				            stack: 0,
				            type: 'column',
				            name: xCate[2]
				        }
				        , {
				            data: lineData1,
				            type: 'line',
				            name: xCate[3]
				            //yAxis: 1
				        }, {
				            data: lineData2,
				            type: 'line',
				            name: xCate[4]
				            //yAxis: 1
				        }, {
				            data: lineData3,
				            type: 'line',
				            name: xCate[5]
				            //yAxis: 1
				        }
				    ]
				});
				
			}
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
						/* events: {
							afterAnimate : function(e){
								
								var chartLen = this.chart.series.length;
								
								if(chartId == "chart9") {
									for(var i = 0; i < chartLen; i++){
			        					
			        					var chartCode = this.chart.series[i].userOptions.code;
			        					
			        					if(chartCode != "1BLB"){
			        						this.chart.series[i].hide();	
			        					}
			        				}
			        			}
								
			        		}
						} */
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
			};
			
			if (!isStack) {
				delete chart.plotOptions.column.stacking;
			}
			Highcharts.chart(chartId, chart);
			
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
		            	align: 'left',
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
				spline: {
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
	
	function getPointCategoryName(point, dimension) {
	    var series = point.series,
	        isY = dimension === 'y',
	        axis = series[isY ? 'yAxis' : 'xAxis'];
	    return axis.categories[point[isY ? 'y' : 'x']];
	}
	
	//조회
	function fn_apply(sqlFlag) {
	
	}
	
	function agingTrendCombo(){
		
 		var agingTrend = $(':radio[name=agingTrend]:checked').val();  //개월 
		var agingTrendCostSale = $(':radio[name=agingTrendCostSale]:checked').val(); //원가,판가
		var agingTrendmeasCd = "";
		
		if(agingTrendCostSale == "cost" && agingTrend == "M3"){ //원가,3개월 :MEAS_CD = 'OVER_M3_AMT_COST' AND ITEM_TYPE별
			agingTrendmeasCd = "OVER_M3_AMT_COST";
		}
		if(agingTrendCostSale == "cost" && agingTrend == "M6"){ //원가,6개월 :MEAS_CD = 'OVER_M6_AMT_COST' AND ITEM_TYPE별
			agingTrendmeasCd = "OVER_M6_AMT_COST";
		}
		if(agingTrendCostSale == "cost" && agingTrend == "Y1"){ //원가,1년 :MEAS_CD = 'OVER_Y1_AMT_COST' AND ITEM_TYPE별
			agingTrendmeasCd = "OVER_Y1_AMT_COST";
		}
		
		if(agingTrendCostSale == "cost_sale" && agingTrend == "M3"){ //판가,3개월 :MEAS_CD = 'OVER_M3_AMT_PRICE' AND ITEM_TYPE별
			agingTrendmeasCd = "OVER_M3_AMT_PRICE";
		}
		if(agingTrendCostSale == "cost_sale" && agingTrend == "M6"){ //판가,6개월 :MEAS_CD = 'OVER_M6_AMT_PRICE' AND ITEM_TYPE별
			agingTrendmeasCd = "OVER_M6_AMT_PRICE";
		}
		if(agingTrendCostSale == "cost_sale" && agingTrend == "Y1"){ //판가,1년 :MEAS_CD = 'OVER_Y1_AMT_PRICE' AND ITEM_TYPE별
			agingTrendmeasCd = "OVER_Y1_AMT_PRICE";
		}
		
		return agingTrendmeasCd;
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
					<c:when test="${popupChartPurchaseTrend.chartId == 'mainRawMaterialChart'}">
					<h4 id="title" style="font-size: 30px;padding-bottom:10px;">${popupChartPurchaseTrend.title} </h4>
					</c:when>
					<c:otherwise>
					<h4 id="title" style="font-size: 30px;">${popupChartPurchaseTrend.title} </h4>
					</c:otherwise>
					</c:choose>
					
					
					<c:choose>
						<c:when test="${popupChartPurchaseTrend.chartId == 'materialTrendChart'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="materialFlag1" name="materialFlag" value="prodPart"/><label for="materialFlag1"><spring:message code="lbl.prodPart3" /></label></li>
								<li><input type="radio" id="materialFlag2" name="materialFlag" value="total" checked="checked"/> <label for="materialFlag2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="materialTrendChart"></div>
						</c:when>
						
						<c:when test="${popupChartPurchaseTrend.chartId == 'outSideTrendChart'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="outSideFlag1" name="outSideFlag" value="prodPart"/><label for="outSideFlag1"><spring:message code="lbl.prodPart3" /></label></li>
								<li><input type="radio" id="outSideFlag2" name="outSideFlag" value="total" checked="checked"/> <label for="outSideFlag2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="outSideTrendChart" ></div>
						</c:when>
						
						<c:when test="${popupChartPurchaseTrend.chartId == 'chart7'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="inv_weekMonth_type1" name="inv_weekMonth_type" value="WEEK" checked="checked"> <label for="inv_weekMonth_type1"><spring:message code="lbl.weekly" /></label></li>
								<li><input type="radio" id="inv_weekMonth_type2" name="inv_weekMonth_type" value="MONTH" > <label for="inv_weekMonth_type2"><spring:message code="lbl.month2" /></label></li>
								<li><input type="radio" id="inv_type1" name="inv_type" value="COST" checked="checked"> <label for="inv_type1"><spring:message code="lbl.costChart" /></label></li>
								<li><input type="radio" id="inv_type2" name="inv_type" value="PRICE" > <label for="inv_type2"><spring:message code="lbl.amtChart" /></label></li>
								<li><input type="radio" id="inv1" name="inv" value="item" > <label for="inv1"><spring:message code="lbl.itemType" /></label></li>
								<li><input type="radio" id="inv2" name="inv" value="total" checked="checked"> <label for="inv2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart7"></div>
						</c:when>
						
						<c:when test="${popupChartPurchaseTrend.chartId == 'chart22'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="agingTrend_cost" name="agingTrendCostSale" value="cost" checked="checked"/> <label for="agingTrend_cost"><spring:message code="lbl.costChart" /></label></li>
								<li><input type="radio" id="agingTrend_sale" name="agingTrendCostSale" value="cost_sale"/> <label for="agingTrend_sale"><spring:message code="lbl.amtChart" /></label></li>
								<li><input type="radio" id="agingTrend_inv1" name="agingTrendInv" value="item"/> <label for="agingTrend_inv1"><spring:message code="lbl.itemType" /></label></li>
								<li><input type="radio" id="agingTrend_inv2" name="agingTrendInv" value="procure"/> <label for="agingTrend_inv2"><spring:message code="lbl.procureType" /></label></li>
								<li><input type="radio" id="agingTrend_inv3" name="agingTrendInv" value="total" checked="checked"/> <label for="agingTrend_inv3"><spring:message code="lbl.total" /> </label></li>
								<li><input type="radio" id="agingTrend1" name="agingTrend" value="M3"/> <label for="agingTrend1"><spring:message code="lbl.3mMore" /></label></li>
								<li><input type="radio" id="agingTrend2" name="agingTrend" value="M6"/> <label for="agingTrend2"><spring:message code="lbl.6mMore" /></label></li>
								<li><input type="radio" id="agingTrend3" name="agingTrend" value="Y1" checked="checked"/> <label for="agingTrend3"><spring:message code="lbl.yearOneMore" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart22"></div>
						</c:when>
						
						<c:when test="${popupChartPurchaseTrend.chartId == 'chart17'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="weekMonth1" name="weekMonth" value="week" checked="checked"/><label for="weekMonth1"><spring:message code="lbl.weekly" /></label></li>
								<li><input type="radio" id="weekMonth2" name="weekMonth" value="month"/><label for="weekMonth2"><spring:message code="lbl.month2" /> </label></li>
								<li><input type="radio" id="proTypeTotal1" name="proTypeTotal" value="proType"/><label for="proTypeTotal1"><spring:message code="lbl.procureType" /></label></li>
								<li><input type="radio" id="proTypeTotal2" name="proTypeTotal" value="total" checked="checked"/><label for="proTypeTotal2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart17" ></div>
						</c:when>
						
						<c:when test="${popupChartPurchaseTrend.chartId == 'mainRawMaterialChart'}">
						<div class="view_combo" style="float: right;">
						</div>
						<table>
							<tbody id="mainRawMaterialChart">
							</tbody>
						</table>
						</c:when>
						
						<c:when test="${popupChartPurchaseTrend.chartId == 'chart18'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="chart18WeekMonth1" name="chart18WeekMonth" value="week" checked="checked"/><label for="chart18WeekMonth1"><spring:message code="lbl.weekly" /></label></li>
								<li><input type="radio" id="chart18WeekMonth2" name="chart18WeekMonth" value="month"/><label for="chart18WeekMonth2"><spring:message code="lbl.month2" /> </label></li>
								<li><input type="radio" id="chart18ProTypeTotal1" name="chart18ProTypeTotal" value="proType"/><label for="chart18ProTypeTotal1"><spring:message code="lbl.procureType" /></label></li>
								<li><input type="radio" id="chart18ProTypeTotal2" name="chart18ProTypeTotal" value="total" checked="checked"/><label for="chart18ProTypeTotal2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart18"></div>
						</c:when>
						
						<c:when test="${popupChartPurchaseTrend.chartId == 'weekReceiveRateChart'}">
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="weekReceiveRateChart" ></div>
						</c:when>
						
						<c:when test="${popupChartPurchaseTrend.chartId == 'dayReceiveRateChart'}">
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="dayReceiveRateChart" ></div>
						</c:when>
						
						
						<c:when test="${popupChartPurchaseTrend.chartId == 'weekDeliRateChart'}">
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="weekDeliRateChart" ></div>
						</c:when>
						
						<c:when test="${popupChartPurchaseTrend.chartId == 'dayRateChart'}">
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="dayRateChart" ></div>
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