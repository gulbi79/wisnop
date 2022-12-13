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
	
	#cont_chart .col_3 { margin:0; width:calc((100% - 4px) / 3) ; height:calc((100% - 4px) / 3); position:relative; }
	#cont_chart .col_3:nth-child(1) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(2) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(3) {margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(4) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(5) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(6) {margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(7) {margin:0 2px 0 0;}
	#cont_chart .col_3:nth-child(8) {margin:0 2px 0 0;}
	
	#cont_chart .col_3 .textwrap { padding : 10px 0 0 0; }
	
	#cont_chart .col_3 > .titleContainer > h4
	{
		float:left
	}
	#cont_chart .col_3 > .titleContainer > div
	{
		float:right;
	}
	
	
	#cont_chart .col_3_tmp h4 { margin-bottom: 10px; }
	
	#cont_chart3 {
		height: 100%;
		width: 240px;
		float: left;
		margin-left: 10px;
	}
	
	table {
		width: 100%;
		height: 88%;
	    border: 1px solid #444444;
	}
	
	td {
		border: 1px solid #444444;
		padding-right: 5px;
		text-align: right;
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
	var quill_1,quill_2,quill_3,quill_4;
	var unit = 0;
	var purchaseTrend2 = {

		init : function () {
			gfn_formLoad();
			fn_siteMap();
			fn_quilljsInit();
			
			this.initSearch();
			this.events();
			
			var userLang = "${sessionScope.GV_LANG}";
			
			if(userLang == "ko"){
	    		unit = 100000000;
	    	}else if(userLang == "en" || userLang == "cn"){
	    		unit = 1000000000;
	    	}
		},
	
		_siq	: "dashboard.purchaseTrend.",
		
		events : function () {
			/* 
			$(':radio[name=materialFlag]').on('change', function () {
				purchaseTrend2.materialTrendSearch(false);
			}); */
			
			// 타이틀 클릭시 메뉴 이동
			var arrTitle = $("h4");
	    	
			$.each(arrTitle, function(n, v) {
	    		$(v).css("cursor", "pointer");
	    		$(v).on("click", function() {
	    			if (n == 0) gfn_newTab("MP209");
	    			else if (n == 1) gfn_newTab("MP209");
	    			else if (n == 2) gfn_newTab("MP209");
	    			else if (n == 3) gfn_newTab("MP210");
	    			else if (n == 4) return;
	    			else if (n == 5) return;
	    			else if (n == 6) return;
	    			else if (n == 7) return;
	    			else if (n == 8) return;
	    		});
	    	});
			
			
			$(".manuel > a").dblclick("on", function() {
	            
	            
	            var chartId  = this.id;
	            
	            fn_popUpAuthorityHasOrNot();
	            
	            var isSCMTeam = SCM_SEARCH.isSCMTeam;
	            
	            if(isSCMTeam>=1)
	            {
	            	//주간 입고 준수율
	            	if(chartId == "weeklyGoodsReceiptComplianceRate")
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
	            	//일간 누적 입고 준수율
	            	else if(chartId == "dailyCumulativeWarehousingComplianceRate")
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
	            	//일간 입고 준수율
	            	else if(chartId == "dailyWarehousingComplianceRate")
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
	            	//주간 납기 준수율
	            	else if(chartId == "weeklyDeliveryComplianceRate")
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
		           
		          //주간 입고 준수율
                    if(chartId == "weeklyGoodsReceiptComplianceRate")
                    {
                    	$('#weekReceiveRateChart').toggle();
                    	$('#weeklyGoodsReceiptComplianceRateContent').toggle();
                    }
                    //일간 누적 입고 준수율
                    else if(chartId == "dailyCumulativeWarehousingComplianceRate")
                    {
                        $('#dayReceiveRateChart').toggle();
                        $('#dailyCumulativeWarehousingComplianceRateContent').toggle();
                    }
                    //일간 입고 준수율
                    else if(chartId == "dailyWarehousingComplianceRate")
                    {
                        $('#dayRateChart').toggle();
                        $('#dailyWarehousingComplianceRateContent').toggle();
                    }
                    //주간 납기 준수율
                    else if(chartId == "weeklyDeliveryComplianceRate")
                    {
                        $('#weekDeliRateChart').toggle();
                        $('#weeklyDeliveryComplianceRateContent').toggle();
                    }
		            
		            
			 });
			
			 $(".titleContainer > h4").hover(function() {
		            
		            var chartId  = this.id;
		        
		            //주간 입고 준수율
                    if(chartId == "weeklyGoodsReceiptComplianceRateH4")
                    {
                        $('#weekReceiveRateChart').toggle();
                        $('#weeklyGoodsReceiptComplianceRateContent').toggle();
                    }
                    //일간 누적 입고 준수율
                    else if(chartId == "dailyCumulativeWarehousingComplianceRateH4")
                    {
                        $('#dayReceiveRateChart').toggle();
                        $('#dailyCumulativeWarehousingComplianceRateContent').toggle();
                    }
                    //일간 입고 준수율
                    else if(chartId == "dailyWarehousingComplianceRateH4")
                    {
                        $('#dayRateChart').toggle();
                        $('#dailyWarehousingComplianceRateContent').toggle();
                    }
                    //주간 납기 준수율
                    else if(chartId == "weeklyDeliveryComplianceRateH4")
                    {
                        $('#weekDeliRateChart').toggle();
                        $('#weeklyDeliveryComplianceRateContent').toggle();
                    }
		            
			 });
			 
			 
		},
		
		bucket : null,
		
		initSearch : function (sqlFlag) {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [/* { outDs : "week"  , _siq : purchaseTrend2._siq + "trendBucketWeek" }
								  , { outDs : "month" , _siq : purchaseTrend2._siq + "trendBucketMonth" }
								  , { outDs : "month2" , _siq : purchaseTrend2._siq + "trendBucketMonth2" } */
								  { outDs : "weekReceiveBucket" , _siq : purchaseTrend2._siq + "weekReceiveBucket" }
								  ,{ outDs : "chartList" , _siq : "dashboard.chartInfo.purchaseTrend2" }
								  ];
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					purchaseTrend2.bucket = {};
					purchaseTrend2.bucket.weekReceive  = data.weekReceiveBucket;
		            FORM_SEARCH.chartList = data.chartList;
		            fn_chartContentInit();   
		            
					/* purchaseTrend2.bucket.week  = data.week;
					purchaseTrend2.bucket.month = data.month;
					purchaseTrend2.bucket.month2 = data.month2; */
					
					purchaseTrend2.search();
				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			
			//var agingTrendMeasCd = agingTrendCombo();
			
			FORM_SEARCH            = {};
			FORM_SEARCH            = this.bucket;
			/* FORM_SEARCH.materialFlag = $(':radio[name=materialFlag]:checked').val();
			FORM_SEARCH.chart18ProTypeTotal = $(':radio[name=chart18ProTypeTotal]:checked').val(); */
			
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			FORM_SEARCH.tranData   = [
				{ outDs : "weekReceiveRateChart", _siq : purchaseTrend2._siq + "weekReceiveRateChart" },
				{ outDs : "dayReceiveRateChart", _siq : purchaseTrend2._siq + "dayReceiveRateChart" },
				{ outDs : "dayRateChart", _siq : purchaseTrend2._siq + "dayRateChart" },
				{ outDs : "weekDeliRateChart" , _siq : purchaseTrend2._siq + "weekDeliRateChart" }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					purchaseTrend2.drawChart(data);
					purchaseTrend2.drawTwoChart(data.dayReceiveRateChart, "dayReceiveRateChart");
					purchaseTrend2.drawTwoChart(data.dayRateChart, "dayRateChart");
				}
			}
			gfn_service(sMap,"obj");
		},
		
		drawTwoChart : function(data, chartId){
			
			var columnData1 = [], 
			columnData2 = [], 
			columnData3 = [],
			
			lineData1 = [], 
			lineData2 = [], 
			lineData3 = [],
			
			xCate = [];
			
			$.each(data, function(n, v) {
				
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
			
			
			Highcharts.chart(chartId, {
			    
				xAxis: { type: 'category' },
				title: {
					text: null ,
					style: {
						color: '#000',
						font: 'bold 16px "Arial", Verdana, sans-serif'
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
			    	column: {
			    		stacking: 'normal'
			    	},
			        series: {
			            dataLabels: {
			            	allowOverlap : true,
			                enabled: true
			            },
			            cursor: 'pointer',
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
									if(chartId == "dayReceiveRateChart") {
										gfn_comPopupOpen("POPUP_PURCHASE_TREND_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartPurchaseTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : "<spring:message code='lbl.dayReceiveRate' /> (%)"
				        				});	
									} else if(chartId == "dayRateChart") {
										gfn_comPopupOpen("POPUP_PURCHASE_TREND_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartPurchaseTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : "<spring:message code='lbl.dayRate' /> (%)"
				        				});	
									}
								}
							}
						}
			        }
			    },
			    
			    yAxis: [{ // left yAxis
			    	labels : { enabled : false}, 
					title: { text: null },
			    	stackLabels: {
					}
	    	    }, { // right yAxis
	    	    	labels : { enabled : false}, 
					title: { text: null },
	    	    	stackLabels: {
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
			
		},
		
		
		drawChart : function (res) {
			
			fn_setHighchartTheme();
			
			var arWeekReceive = new Array();
			
			$.each (purchaseTrend2.bucket.weekReceive, function (i, el) {
				arWeekReceive.push(el.DISWEEK);
			});
			
			var weekReceiveRateChart = JSON.parse(res.weekReceiveRateChart[0].WEEK_RECEIVE);
			var weekDeliRateChart = JSON.parse(res.weekDeliRateChart[0].WEEK_DELIVERY);
			
			this.chartGen('weekReceiveRateChart', 'line', arWeekReceive, weekReceiveRateChart);
			this.chartGen('weekDeliRateChart', 'line', arWeekReceive , weekDeliRateChart);
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
		
		chartGen : function (chartId, type, arCarte, arData) {
			
			var chart = {
				chart  : { type : type },
				xAxis  : { categories : arCarte },
				series : arData,
				plotOptions: {
					series: {
						cursor: 'pointer',
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
									if(chartId == "weekReceiveRateChart") {
										gfn_comPopupOpen("POPUP_PURCHASE_TREND_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartPurchaseTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : "<spring:message code='lbl.weekReceiveRate' /> (%)"
				        				});	
									} else if(chartId == "weekDeliRateChart")	{
			                			gfn_comPopupOpen("POPUP_PURCHASE_TREND_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartPurchaseTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : "<spring:message code='lbl.weekDeliRate' />"
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
					font: 'bold 16px "Arial", Verdana, sans-serif'
				}
			},
			subtitle: {
				style: {
					color: '#666666',
					font: 'bold 12px "Arial", Verdana, sans-serif'
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
					fontSize   : '11px',
					fontWeight : 'normal'
				}
			},
			tooltip : {
				enabled : false
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
							fontSize : "12px",
							fontWeight: ''
						}
					},
					enableMouseTracking: true,
				},
				column: {
					dataLabels: {
						enabled: true,
						style : {
							fontSize : "12px",
							fontWeight: ''
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
		purchaseTrend2.search(sqlFlag);
	}
	
 	// onload 
	$(document).ready(function() {
		purchaseTrend2.init();
	});
	
 	
	var fn_popupCallback = function () {
        location.reload();
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
        
	}
	
	 function fn_chartContentInit(){
	      
         
	      /*
    	   0. weeklyGoodsReceiptComplianceRate
		1.	dailyCumulativeWarehousingComplianceRate
		2.	dailyWarehousingComplianceRate
		3.	weeklyDeliveryComplianceRate

	      */
	      
	      
	      for(i=0;i<4;i++)
	      {
	          if(FORM_SEARCH.chartList[i].ID=="weeklyGoodsReceiptComplianceRate")               FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_1.setContents([{ insert: '\n' }]):quill_1.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="dailyCumulativeWarehousingComplianceRate")  FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_2.setContents([{ insert: '\n' }]):quill_2.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="dailyWarehousingComplianceRate")            FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_3.setContents([{ insert: '\n' }]):quill_3.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="weeklyDeliveryComplianceRate")              FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_4.setContents([{ insert: '\n' }]):quill_4.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	                                      
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
		<%@ include file="/WEB-INF/view/common/commonLocation.jsp"%>

		<div class="scroll" style="height:calc(100% - 35px)">
			<!-- chart -->
			<div id="container" style="float: left">
				<div id="cont_chart">
					<!-- 주간 입고 준수율 -->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="weeklyGoodsReceiptComplianceRateH4"><spring:message code="lbl.weekReceiveRate" /> (%)</h4>
							<div class="view_combo" >
								
							     <ul class="rdofl">
                                     <li style="text-align: right;color:red;font-size:12px;padding:3px;margin:0;"><spring:message code="lbl.silinder" /></li>
	                                 <li class="manuel">
	                                    <a href="#" id="weeklyGoodsReceiptComplianceRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                 </li>
	                                      
                                 </ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="weekReceiveRateChart" ></div>
					    <div class="modal" id="weeklyGoodsReceiptComplianceRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-1"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 일간 누적 입고 준수율 -->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="dailyCumulativeWarehousingComplianceRateH4"><spring:message code="lbl.dayReceiveRate" /> (%)</h4>
							<div class="view_combo">
								  
							      <ul class="rdofl">
							         <li style="text-align: right;color:red;font-size:12px;padding:3px;margin:0;"><spring:message code="lbl.silinder" /></li>
							         <li class="manuel">
                                        <a href="#" id="dailyCumulativeWarehousingComplianceRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
							      </ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="dayReceiveRateChart" ></div>
						<div class="modal" id="dailyCumulativeWarehousingComplianceRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-2"></div>
                           </div>
                       </div>
					</div>
					<!-- 일간 입고 준수율 -->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="dailyWarehousingComplianceRateH4"><spring:message code="lbl.dayRate" /> (%)</h4>
							<div class="view_combo" >
								
							     <ul class="rdofl">
                                     <li style="text-align: right;color:red;font-size:12px;padding:3px;margin:0;"><spring:message code="lbl.silinder" /></li>     
                                     <li class="manuel">
                                        <a href="#" id="dailyWarehousingComplianceRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
                                  </ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="dayRateChart" ></div>
						<div class="modal" id="dailyWarehousingComplianceRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-3"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 주간 납기 준수율(%) -->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="weeklyDeliveryComplianceRateH4"><spring:message code="lbl.weekDeliRate" /></h4>
							<div class="view_combo">
								 
							     <ul class="rdofl">
                                     <li style="text-align: right;color:red;font-size:12px;padding:3px;margin:0;"><spring:message code="lbl.silinder" /></li>
                                     <li class="manuel">
                                        <a href="#" id="weeklyDeliveryComplianceRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
                                  </ul>
							</div>
						</div>
						<div style="height: 100%" id="weekDeliRateChart" ></div>
						<div class="modal" id="weeklyDeliveryComplianceRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-4"></div>
                           </div>
                       </div>
					</div>
					
					
					<div class="col_3" >
						<h4></h4>
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="aaaaa" ></div>
					</div>
					<div class="col_3" >
						<h4></h4>
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="aaaaa" ></div>
					</div>
					<div class="col_3" >
						<h4></h4>
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="aaaaa" ></div>
					</div>
					<div class="col_3" >
						<h4></h4>
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="aaaaa" ></div>
					</div>
					<div class="col_3" >
						<h4></h4>
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="aaaaa" ></div>
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
