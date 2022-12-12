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
	
	#cont_chart .col_3 .textwrap { padding : 10px 0 0 0; }
	
	#cont_chart .col_3 > .titleContainer > h4{
		float:left;
	}
	
	#cont_chart .col_3 > .titleContainer > div{
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
      top: -5px;
      right:125px;
      background: #fff;
      width: 100px;
      height:140px;
      padding: 10px;
      border-radius: 20px;
      opacity: 0;
      visibility: hidden;
      transition: .3s;
      z-index:999;
      display:block;
      box-shadow: 0 5px 5px rgba(0,0,0,0.1);
      overflow-y:scroll;
      overflow-x:hidden;
    }
    
    #cont_chart .col_3 > .titleContainer > .action.active ul {
    
      top: 0px;
      right:125px;
      width: 100px;
      padding: 10px;
      opacity: 1;
      visibility: visible;
      transition: .3s;
      background: white;
      z-index:999;
      display:block;
      box-shadow: 0 5px 5px rgba(0,0,0,0.1);
      overflow-y:scroll;
      overflow-x:hidden;
    }
    
    
      #cont_chart .col_3 > .titleContainer > .action ul::-webkit-scrollbar-track
     {
        background-color: white;
       border-radius: 10px;
     }
    
    #cont_chart .col_3 > .titleContainer > .action ul::-webkit-scrollbar
     {
     width: 10px;
     background-color: white;
     }
     
     #cont_chart .col_3 > .titleContainer > .action ul::-webkit-scrollbar-thumb
     {
      border-radius: 10px;
    background-color: white;
    
   
     }
    
    
    
    
    
    
     #cont_chart .col_3 > .titleContainer > .action.active ul::-webkit-scrollbar-track
     {
        background-color: transparent;
     
     }
    
    #cont_chart .col_3 > .titleContainer > .action.active ul::-webkit-scrollbar
     {
     width: 10px;
    background-color: transparent;
     
     }
     
     #cont_chart .col_3 > .titleContainer > .action.active ul::-webkit-scrollbar-thumb
     {
    background-color: #0ae;
    
    background-image: -webkit-gradient(linear, 0 0, 0 100%,
                       color-stop(.5, rgba(255, 255, 255, .2)),
                       color-stop(.5, transparent), to(transparent));
     
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
    
	
	
	</style>	
	
	<script type="text/javascript">
	var unit = 0;
	var quill_1,quill_2,quill_3,quill_4,quill_5,quill_6,quill_7,quill_8,quill_9;
	var supplyTrend1 = {

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
	
		_siq	: "dashboard.supplyTrend.",
		
		events : function () {
			
			//불량률
			$(':radio[name=key]').on('change', function () {
				supplyTrend1.defactSearch(false);
			});
			//불량률
			$(':radio[name=firstAs]').on('change', function () {
				supplyTrend1.defactSearch(false);
			});
			
			//SCRAP
			$(':radio[name=chart22_type]').on('change', function () {
				supplyTrend1.chart22Search(false);
			});
			
			//SCRAP
			$(':radio[name=chart22_weekMonth_type]').on('change', function () {
				supplyTrend1.chart22Search(false);
			});
			
			//생산 TREND
			$(':radio[name=prod]').on('change', function () {
				supplyTrend1.prodSearch(false);
			});
			//생산 준수율
			$(':radio[name=prodRate]').on('change', function () {
				supplyTrend1.prodRateSearch(false);
			});
			//생산 준수율
			$(':radio[name=prodRateWeek]').on('change', function () {
				supplyTrend1.prodRateSearch(false);
			});
			
			/* $(':radio[name=salesFcst]').on('change', function () {
				supplyTrend1.salesFcstSearch(false);
			}); */
			
			//공급능력지수
			$(':radio[name=agingTrend]').on('change', function () {
				supplyTrend1.agingTrendSearch(false);
			});
			//재공
			$(':radio[name=wip]').on('change', function () {
				supplyTrend1.wipSearch(false);
			});
			//재공
			$(':radio[name=amtRate]').on('change', function () {
				supplyTrend1.wipSearch(false);
			});
			//재공 Aging
			$(':radio[name=trend22]').on('change', function () {
				supplyTrend1.trend22Search(false);
			});
			//주요 품목 그룹별 생산 실적
			$(':radio[name=weekMonthChart9]').on('change', function () {
				supplyTrend1.chart9Search(false);
			});
			
			// 타이틀 클릭시 메뉴 이동
			var arrTitle = $("h4");
	    	
			$.each(arrTitle, function(n, v) {
	    		$(v).css("cursor", "pointer");
	    		$(v).on("click", function() {
	    			if (n == 0) gfn_newTab("QT102");
	    			else if (n == 1) gfn_newTab("QT101");
	    			else if (n == 2) return;
	    			else if (n == 3) gfn_newTab("MP101");
	    			else if (n == 4) gfn_newTab("MP101");
	    			else if (n == 5) gfn_newTab("SNOP304");
	    			else if (n == 6) gfn_newTab("MP102");
	    			else if (n == 7) gfn_newTab("MP105");
	    			else if (n == 8) gfn_newTab("MP105");
	    		});
	    	});
			
			
			$(".manuel > a").dblclick("on", function() {
				
				var chartId  = this.id;
	            
	            fn_popUpAuthorityHasOrNot();
	            
	            var isSCMTeam = SCM_SEARCH.isSCMTeam;
	            
	            if(isSCMTeam>=1)
	            {
	            	//Claim Rate
	            	if(chartId == "claimRate")
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
	            	//불량률
	            	else if(chartId == "defectiveRateSupply")
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
	            	//SCRAP
	            	else if(chartId == "scrap")
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
	            	//생산 TREND
	            	else if(chartId == "productionTrend")
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
	            	//주요 품목 그룹별 생산 실적
	            	else if(chartId == "productionPerformanceByMajorItemGroup")
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
	            	//생산 준수율
	            	else if(chartId == "productionComplianceRate")
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
	            	//공급능력지수
	            	else if(chartId == "supplyCapacityIndex")
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
	            	//재공
	            	else if(chartId == "stockInWork")
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
	            	//재공 Aging
	            	else if(chartId == "stockInWorkAging")
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
				
				//Claim Rate
				if(chartId == "claimRate")
				{
					 $('#chart3').toggle();
					 $('#claimRateContent').toggle();
				}
				//불량률
				else if(chartId == "defectiveRateSupply")
				{
	                 $('#chart6').toggle();
                     $('#defectiveRateSupplyContent').toggle();				
				}
				//SCRAP
				else if(chartId == "scrap")
                {
	                 $('#chart22').toggle();
                     $('#scrapContent').toggle();
                }
				//생산 TREND
				else if(chartId == "productionTrend")
                {
	                 $('#chart4').toggle();
                     $('#productionTrendContent').toggle();
                }
				//주요 품목 그룹별 생산 실적
				else if(chartId == "productionPerformanceByMajorItemGroup")
                {
	                 $('#chart9').toggle();
                     $('#productionPerformanceByMajorItemGroupContent').toggle();
                }
				//생산 준수율
				else if(chartId == "productionComplianceRate")
                {
	                 $('#chart13').toggle();
                     $('#productionComplianceRateContent').toggle();
                }
				//공급능력지수
				else if(chartId == "supplyCapacityIndex")
                {
	                 $('#chart5').toggle();
                     $('#supplyCapacityIndexContent').toggle();
                }
				//재공
				else if(chartId == "stockInWork")
                {
	                 $('#chart19').toggle();
                     $('#stockInWorkContent').toggle();
                }
				//재공 Aging
				else if(chartId == "stockInWorkAging")
                {               
					$('#chart21').toggle();
				    $('#stockInWorkAgingContent').toggle();
                }
				
			});
			
			
			$(".titleContainer > h4").hover(function() {
	            
	            var chartId  = this.id;
			
	          //Claim Rate
                if(chartId == "claimRateH4")
                {
                     $('#chart3').toggle();
                     $('#claimRateContent').toggle();
                }
                //불량률
                else if(chartId == "defectiveRateSupplyH4")
                {
                     $('#chart6').toggle();
                     $('#defectiveRateSupplyContent').toggle();             
                }
                //SCRAP
                else if(chartId == "scrapH4")
                {
                     $('#chart22').toggle();
                     $('#scrapContent').toggle();
                }
                //생산 TREND
                else if(chartId == "productionTrendH4")
                {
                     $('#chart4').toggle();
                     $('#productionTrendContent').toggle();
                }
                //주요 품목 그룹별 생산 실적
                else if(chartId == "productionPerformanceByMajorItemGroupH4")
                {
                     $('#chart9').toggle();
                     $('#productionPerformanceByMajorItemGroupContent').toggle();
                }
                //생산 준수율
                else if(chartId == "productionComplianceRateH4")
                {
                     $('#chart13').toggle();
                     $('#productionComplianceRateContent').toggle();
                }
                //공급능력지수
                else if(chartId == "supplyCapacityIndexH4")
                {
                     $('#chart5').toggle();
                     $('#supplyCapacityIndexContent').toggle();
                }
                //재공
                else if(chartId == "stockInWorkH4")
                {
                     $('#chart19').toggle();
                     $('#stockInWorkContent').toggle();
                }
                //재공 Aging
                else if(chartId == "stockInWorkAgingH4")
                {               
                    $('#chart21').toggle();
                    $('#stockInWorkAgingContent').toggle();
                }
	            
			});
			
			
			 $('.titleContainer > .action').hover(function(){
                 
                 var chartId = this.id;
                 
                 
                 if(chartId == 'defectiveRateSupplyAction')
                 {
                	 defectiveRateSupplyActionToggle();
                     
                 }
                 
                 else if(chartId == 'productionComplianceRateAction')
                 {
                	 productionComplianceRateActionToggle();  
                 
                 }
                 
             });
			
			
		},
		
		bucket : null,
		
		initSearch : function (sqlFlag) {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [{ outDs : "week"  , _siq : supplyTrend1._siq + "trendBucketWeek" }
								  , { outDs : "month" , _siq : supplyTrend1._siq + "trendBucketMonth" }
								  , { outDs : "chartList" , _siq : "dashboard.chartInfo.supplyTrend1" }
			];
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					supplyTrend1.bucket = {};
					supplyTrend1.bucket.week  = data.week;
					supplyTrend1.bucket.month = data.month;
					FORM_SEARCH.chartList = data.chartList;
					fn_chartContentInit();
					
					supplyTrend1.search();
				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			
			FORM_SEARCH            = {};
			FORM_SEARCH            = this.bucket;
			FORM_SEARCH.key        = $(':radio[name=key]:checked').val();          //불량률
			FORM_SEARCH.firstAs    = $(':radio[name=firstAs]:checked').val();      //불량률
			FORM_SEARCH.chart22_type = $(':radio[name=chart22_type]:checked').val();//SCRAP
			FORM_SEARCH.chart22_weekMonth_type = $(':radio[name=chart22_weekMonth_type]:checked').val();//SCRAP
			FORM_SEARCH.prod       = $(':radio[name=prod]:checked').val();		   //생산TREND
			FORM_SEARCH.prodRate   = $(':radio[name=prodRate]:checked').val();	   //생산준수율
			FORM_SEARCH.prodRateWeek   = $(':radio[name=prodRateWeek]:checked').val();//생산준수율
			FORM_SEARCH.agingTrend = $(':radio[name=agingTrend]:checked').val();   //공급능력지수
			FORM_SEARCH.amtRate    = $(':radio[name=amtRate]:checked').val();      //재공
			FORM_SEARCH.wip        = $(':radio[name=wip]:checked').val();    	   //재공
			FORM_SEARCH.trend22    = $(':radio[name=trend22]:checked').val();	   //재공 Aging
			FORM_SEARCH.weekMonthChart9    = $(':radio[name=weekMonthChart9]:checked').val();
																	//주요 품목 그룹별 생산 실적
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			
			FORM_SEARCH.tranData   = [
				{ outDs : "chart3", _siq : supplyTrend1._siq + "chart3" },//Claim Rate (ppm, 월)
				{ outDs : "chart6", _siq : supplyTrend1._siq + "chart6" },//불량률 
				{ outDs : "chart22",_siq : supplyTrend1._siq + "chart22"},//SCRAP
				{ outDs : "chart4", _siq : supplyTrend1._siq + "chart4" },//생산 TREND
				{ outDs : "chart9", _siq : supplyTrend1._siq + "chart9" },//주요 품목 그룹별 생산 실적 
				{ outDs : "chart13", _siq : supplyTrend1._siq + "chart13" },//생산 준수율
				{ outDs : "chart5", _siq : supplyTrend1._siq + "chart5" },  //공급능력지수
				{ outDs : "chart19", _siq : supplyTrend1._siq + "chart19" },//재공
				{ outDs : "chart21", _siq : supplyTrend1._siq + "chart21" },//재공 Aging
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					supplyTrend1.drawChart(data);
					
				}
			}
			gfn_service(sMap,"obj");
		},
		//불량률 
		defactSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = supplyTrend1.bucket;
			FORM_SEARCH.key      = $(':radio[name=key]:checked').val();
			FORM_SEARCH.firstAs  = $(':radio[name=firstAs]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart6" , _siq : supplyTrend1._siq + "chart6" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					// cartegory
					var arPreMonth = new Array();
					var arMonth = new Array();
			
					$.each (supplyTrend1.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
						arMonth.push(el.DISMONTH);
					});
					
					var chart6 = JSON.parse(data.chart6[0].DEFECT);
					//supplyTrend1.tagetStyle(chart6);
					supplyTrend1.chartGen('chart6', 'line', arMonth, chart6);
				}
			}
			gfn_service(sMap,"obj");
		},
		//SCRAP
		chart22Search : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = supplyTrend1.bucket;
			FORM_SEARCH.chart22_type   = $(':radio[name=chart22_type]:checked').val();
			FORM_SEARCH.chart22_weekMonth_type   = $(':radio[name=chart22_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart22" , _siq : supplyTrend1._siq + "chart22" } ,
			];
			
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					
					
					
					
					var weekMonth = $(':radio[name=chart22_weekMonth_type]:checked').val();
					
					if(weekMonth == "WEEK"){
						
						
						
						var arWeek = new Array();
						
						$.each (supplyTrend1.bucket.week, function (i, el) {
							arWeek.push(el.DISWEEK);
						});
						
						var chart22 = JSON.parse(data.chart22[0].SCRAP);

						supplyTrend1.chartGen('chart22', 'line', arWeek, chart22);
					}else{
						
						
						
						var arMonth = new Array();
						
						$.each (supplyTrend1.bucket.month, function (i, el) {
							arMonth.push(el.DISMONTH);
						});
						
						
						
						var chart22 = JSON.parse(data.chart22[0].SCRAP);
						
						
						
						supplyTrend1.chartGen('chart22', 'line', arMonth, chart22);						
					}
				}
			}
			gfn_service(sMap,"obj");
		},
		
		
		
		
		
		//생산 TREND
		prodSearch : function (sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = supplyTrend1.bucket;
			FORM_SEARCH.prod     = $(':radio[name=prod]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart4" , _siq : supplyTrend1._siq + "chart4" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					var arMonth = new Array();
			
					$.each (supplyTrend1.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
						arMonth.push(el.DISMONTH);
					});
					var chart4 = JSON.parse(data.chart4[0].PROD_TREND);

					supplyTrend1.chartGen('chart4', 'line', arMonth, chart4);
				}
			}
			gfn_service(sMap,"obj");
		},
		//생산 준수율
		prodRateSearch : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = supplyTrend1.bucket;
			FORM_SEARCH.prodRate = $(':radio[name=prodRate]:checked').val();
			FORM_SEARCH.prodRateWeek = $(':radio[name=prodRateWeek]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart13" , _siq : supplyTrend1._siq + "chart13" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arWeek = new Array();
			
					$.each (supplyTrend1.bucket.week, function (i, el) {
						arWeek.push(el.DISWEEK);
					});
					
					var chart13 = JSON.parse(data.chart13[0].PROD_CML);

					supplyTrend1.chartGen('chart13', 'line', arWeek, chart13);
				}
			}
			gfn_service(sMap,"obj");
		},
		//공급능력지수
		agingTrendSearch : function(sqlFlag) {
			FORM_SEARCH            = {};
			FORM_SEARCH            = supplyTrend1.bucket;
			FORM_SEARCH.agingTrend = $(':radio[name=agingTrend]:checked').val();
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.tranData   = [
				{ outDs : "chart5" , _siq : supplyTrend1._siq + "chart5" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					var arMonth = new Array();
			
					$.each (supplyTrend1.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
						arMonth.push(el.DISMONTH);
					});
					
					var chart5 = JSON.parse(data.chart5[0].CAPA);

					supplyTrend1.chartGen('chart5', 'line', arMonth, chart5); 
				}
			}
			gfn_service(sMap,"obj");
		},
		//재공
		wipSearch : function(sqlFlag) {
			FORM_SEARCH = {};
			FORM_SEARCH = supplyTrend1.bucket;
			FORM_SEARCH.amtRate = $(':radio[name=amtRate]:checked').val();
			FORM_SEARCH.wip  = $(':radio[name=wip]:checked').val();
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart19" , _siq : supplyTrend1._siq + "chart19" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arMonth = new Array();
					var arPreMonth = new Array();
					
					$.each (supplyTrend1.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
						arPreMonth.push(el.PRE_DISMONTH);
					});
					var chart19 = JSON.parse(data.chart19[0].WIP);
					
					if(FORM_SEARCH.amtRate == "amt"){
						supplyTrend1.chartGen('chart19', 'line', arMonth, chart19);	
					}else{
						supplyTrend1.chartGen('chart19', 'line', arPreMonth, chart19);
					}
				}
			}
			gfn_service(sMap,"obj");
		},
		//재공 Aging
		trend22Search : function(sqlFlag) {
			FORM_SEARCH = {}
			FORM_SEARCH = supplyTrend1.bucket;
			FORM_SEARCH.trend22 = $(':radio[name=trend22]:checked').val();
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart21" , _siq : supplyTrend1._siq + "chart21" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arMonth = new Array();
					$.each (supplyTrend1.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					
					var chart21 = JSON.parse(data.chart21[0].TREND22);

					supplyTrend1.chartGen('chart21', 'line', arMonth, chart21);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		//주요 품목 그룹별 생산 실적 
		chart9Search : function(sqlFlag) {
			FORM_SEARCH = {};
			FORM_SEARCH = supplyTrend1.bucket;
			FORM_SEARCH.weekMonthChart9    = $(':radio[name=weekMonthChart9]:checked').val();
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart9" , _siq : supplyTrend1._siq + "chart9" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arWeek = new Array();
					var arMonth = new Array();
					
					
					$.each (supplyTrend1.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					
					$.each (supplyTrend1.bucket.week, function (i, el) {
						arWeek.push(el.DISWEEK);
					});
					
					
					var chart9 = JSON.parse(data.chart9[0].CAPA);
					
					if(FORM_SEARCH.weekMonthChart9 == "month"){
						supplyTrend1.chartGen('chart9', 'line', arMonth, chart9);	
					}else{
						supplyTrend1.chartGen('chart9', 'line', arWeek, chart9);
					}
				}
			}
			gfn_service(sMap,"obj");
		},
		
		
		
		
		
		
		drawChart : function (res) {
			
			fn_setHighchartTheme();
			
			var amtRateFlag = $(':radio[name=amtRate]:checked').val();//재공
			var arPreWeek  = new Array();
			var arWeek     = new Array();
			var arMonth    = new Array();
			var arPreMonth = new Array();
			
			$.each (supplyTrend1.bucket.month, function (i, el) {
				arMonth.push(el.DISMONTH);
				arPreMonth.push(el.PRE_DISMONTH);
			});
			
			$.each (supplyTrend1.bucket.week, function (i, el) {
				arWeek.push(el.DISWEEK);
				arPreWeek.push(el.PRE_DISWEEK);
			});
			
			var chart3 = JSON.parse(res.chart3[0].CLAIM);//Claim Rate (ppm, 월)
			var chart6 = JSON.parse(res.chart6[0].DEFECT);//불량률
			var chart22 =JSON.parse(res.chart22[0].SCRAP);//SCRAP
			var chart4 = JSON.parse(res.chart4[0].PROD_TREND);//생산 TREND
			var chart9 = JSON.parse(res.chart9[0].CAPA);//주요 품목 그룹별 생산 실적 
			var chart13 = JSON.parse(res.chart13[0].PROD_CML);//생산 준수율
			var chart5 = JSON.parse(res.chart5[0].CAPA);//공급능력지수
			var chart19 = JSON.parse(res.chart19[0].WIP);//재공
			var chart21 = JSON.parse(res.chart21[0].TREND22);//재공 Aging
			
			this.tagetStyle(chart3);
			this.tagetStyle(chart6);
			
			this.chartGen('chart3', 'line', arMonth, chart3);//Claim Rate (ppm, 월)
			this.chartGen('chart6', 'line', arMonth, chart6);//불량률
			this.chartGen('chart22', 'line', arMonth, chart22);//SCRAP
			this.chartGen('chart4', 'line', arMonth, chart4);//생산 TREND
			this.chartGen('chart9', 'line', arMonth, chart9);//주요 품목 그룹별 생산 실적 
			this.chartGen('chart13', 'line', arWeek, chart13);//생산 준수율
			this.chartGen('chart5', 'line', arMonth, chart5);//공급능력지수
			if(amtRateFlag == "amt"){
				this.chartGen('chart19', 'line', arMonth, chart19);	//재공
			}else{
				this.chartGen('chart19', 'line', arPreMonth, chart19);//재공
			}
			this.chartGen('chart21', 'line', arMonth, chart21);//재공 Aging
			
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
						events: {
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
						},							
						cursor: 'pointer',
						point: {
							events: {
								click: function() {
									//Claim Rate (ppm, 월)
									if(chartId == "chart3") {
										gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
											rootUrl   : "dashboard",
											url       : "popupChartSupplyTrend",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart3",
											title     : "<spring:message code='lbl.claimChart2' /> (%)"
										});
										
									} 
									//불량률
									else if(chartId == "chart6")	{
				                		gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartSupplyTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart6",
				        					title     : "<spring:message code='lbl.defectRateChart' />"
				        				});
				                	} 
									//SCRAP
									else if(chartId == "chart22")	{
										
				                		  
										gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartSupplyTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart22",
				        					title     : "<spring:message code='lbl.scrap' />(<spring:message code='lbl.unit' />:<spring:message code='lbl.thousand' /><spring:message code='lbl.won' />)"
				        				});
				                		
				                		
				                		
				                	}
									
									
									//생산 TREND
									else if(chartId == "chart4")	{
				                		gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartSupplyTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart4",
				        					title     : "<spring:message code='lbl.prodTend' /> (<spring:message code='lbl.hMillion' />)"
				        				});
				                	} 
									//주요 품목 그룹별 생산 실적 
									else if(chartId == "chart9")	{
				                		gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartSupplyTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart9",
				        					title     : "<spring:message code='lbl.itemGroupChart2' /> (EA)"
				        				});
				                	} 
									//생산 준수율
									else if(chartId == "chart13")	{
				                		gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartSupplyTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart13",
				        					title     : "<spring:message code='lbl.prodCmplRateChart2' /> (%)"
				        				});
				                	} 
									//공급능력지수
									else if(chartId == "chart5")	{
				                		gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartSupplyTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart5",
				        					title     : "<spring:message code='lbl.supplyCapacityRate' /> (%)"
				        				});
				                	} 
									//재공
									else if(chartId == "chart19")	{
				                		gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartSupplyTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart19",
				        					title     : "<spring:message code='lbl.wip2' /> "
				        				});
				                	} 
									//재공 Aging
									else if(chartId == "chart21")	{
				                		gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartSupplyTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart21",
				        					title     : "<spring:message code='lbl.trend22Chart' /> (<spring:message code='lbl.hMillion' />)"
				        				});
				                	}
								}
							}
						}
					}
				}
			};
			
			if(chartId == "chart6" && FORM_SEARCH.key == "prodPart"){
				chart.colors = [gv_cColor1, gv_cColor2, '#009933', '#82d8b5', '#f0a482', '#f1e584', '#9ead59', '#5d9980', '#b986c2', '#d1afdd'];	
			}else if(chartId == "chart4" && FORM_SEARCH.prod == "item"){
				chart.colors = [gv_cColor1, gv_cColor2, '#f7848d', '#82d8b5', '#009933', '#f1e584', '#9ead59', '#5d9980', '#b986c2', '#d1afdd'];
			}else if(chartId == "chart5" && FORM_SEARCH.agingTrend == "cust"){
				chart.colors = [gv_cColor1, gv_cColor2, '#f7848d', '#82d8b5', '#663300', '#f1e584', '#9ead59', '#5d9980', '#b986c2', '#d1afdd'];
			}else if(chartId == "chart9"){
				chart.colors = [gv_cColor1, gv_cColor2, '#f7848d', '#82d8b5', '#663300', '#f1e584', '#9ead59', '#5d9980', '#b986c2', '#d1afdd'];
			}else if(chartId == "chart13" && FORM_SEARCH.prodRate == "item"){
				chart.colors = [gv_cColor1, gv_cColor2, '#f7848d', '#663300', '#f0a482', '#f1e584', '#9ead59', '#5d9980', '#666666', '#d1afdd'];
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
		supplyTrend1.search(sqlFlag);
	}
	
 	// onload 
	$(document).ready(function() {
		supplyTrend1.init();
	});
	
    
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
        0. claimRate
		1. defectiveRateSupply
		2. scrap
		3. productionTrend
		4. productionPerformanceByMajorItemGroup
		5. productionComplianceRate
		6. supplyCapacityIndex
		7. stockInWork
		8. stockInWorkAging

        */
        
        
        for(i=0;i<9;i++)
        {
            if(FORM_SEARCH.chartList[i].ID=="claimRate")                                    FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_1.setContents([{ insert: '\n' }]):quill_1.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="defectiveRateSupply")                     FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_2.setContents([{ insert: '\n' }]):quill_2.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="scrap")                                   FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_3.setContents([{ insert: '\n' }]):quill_3.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="productionTrend")                         FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_4.setContents([{ insert: '\n' }]):quill_4.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="productionPerformanceByMajorItemGroup")   FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_5.setContents([{ insert: '\n' }]):quill_5.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="productionComplianceRate")                FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_6.setContents([{ insert: '\n' }]):quill_6.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
            else if(FORM_SEARCH.chartList[i].ID=="supplyCapacityIndex")                     FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_7.setContents([{ insert: '\n' }]):quill_7.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
            else if(FORM_SEARCH.chartList[i].ID=="stockInWork")                             FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_8.setContents([{ insert: '\n' }]):quill_8.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
            else if(FORM_SEARCH.chartList[i].ID=="stockInWorkAging")                        FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_9.setContents([{ insert: '\n' }]):quill_9.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
                                        
        }
        
        
        
    }
    
    function defectiveRateSupplyActionToggle()
    {
    	const action = $('#defectiveRateSupplyAction');
        
        action.toggleClass('active')
    }
    
    
    function productionComplianceRateActionToggle()
    {
    	const action = $('#productionComplianceRateAction');
        
        action.toggleClass('active')
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
				
					<!-- Claim Rate (ppm, 월)-->
					<div class="col_3" >
					    <div class="titleContainer">
					   	     <h4 id="claimRateH4"><spring:message code="lbl.claimChart2" /></h4>
                             <div class="view_combo">
	                             <ul class="rdofl">
	                                 <li class="manuel">
	                                    <a href="#" id="claimRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                 </li>
	                             </ul>
                             </div> 					   	   
					   	</div>
						<div style="height: 100%" id="chart3" ></div>
						<div class="modal" id="claimRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-1"></div>
                           </div>
                        </div>
                       
					</div>
					
					<!-- 불량률 -->
					<div class="col_3">
					    <div class="titleContainer">
							<h4 id="defectiveRateSupplyH4"><spring:message code="lbl.defectRateChart" /></h4>
							<div class="view_combo" > <!-- class="action" id="defectiveRateSupplyAction" -->
								<!--<span>+</span> -->
								<ul class="rdofl">
									<li><input type="radio" id="firstAs1" name="firstAs" value="all" checked="checked"/> <label for="firstAs1"><spring:message code="lbl.firstAsInclude" /></label></li>
									<li><input type="radio" id="firstAs2" name="firstAs" value="exc"/> <label for="firstAs2"><spring:message code="lbl.firstAsExc" /></label></li>
									<li><input type="radio" id="key3" name="key" value="part"/> <label for="key3"><spring:message code="lbl.part" /></label></li>
									<li><input type="radio" id="key2" name="key" value="key"/> <label for="key2"><spring:message code="lbl.reptItemGroup" /></label></li>
									<li><input type="radio" id="key4" name="key" value="mainItem"/> <label for="key4"><spring:message code="lbl.kpdr2" /></label></li>
									<li><input type="radio" id="key1" name="key" value="prodPart" checked="checked"/> <label for="key1"><spring:message code="lbl.prodPart3" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="defectiveRateSupply"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
								</ul>
							</div>
                        </div>					
						<div style="height: 78%;width:100%;clear:both;" id="chart6" ></div>
						<div class="modal" id="defectiveRateSupplyContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-2"></div>
                           </div>
                        </div>
					</div>
					
					<!-- SCRAP  -->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="scrapH4"><spring:message code='lbl.scrap' />(<spring:message code='lbl.unit' />:<spring:message code='lbl.thousand' /><spring:message code='lbl.won' />)</h4>
							<div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="chart22_weekMonth_type1" name="chart22_weekMonth_type" value="WEEK"/> <label for="chart22_weekMonth_type1"><spring:message code="lbl.weekly" /></label></li>
									<li><input type="radio" id="chart22_weekMonth_type2" name="chart22_weekMonth_type" value="MONTH" checked="checked"/> <label for="chart22_weekMonth_type2"><spring:message code="lbl.month2" /></label></li>
									<li><input type="radio" id="chart22_type1" name="chart22_type" value="part" /> <label for="chart22_type1"><spring:message code="lbl.part" /></label></li>
									<li><input type="radio" id="chart22_type2" name="chart22_type" value="total" checked="checked"/> <label for="chart22_type2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="scrap"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="chart22" ></div>
						<div class="modal" id="scrapContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-3"></div>
                           </div>
                        </div>
					</div>
					
					<!-- 생산 TREND -->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="productionTrendH4"><spring:message code="lbl.prodTend" /> (<spring:message code="lbl.hMillion" />)</h4>
							<div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="prod1" name="prod" value="item"/> <label for="prod1"><spring:message code="lbl.part" /></label></li>
									<li><input type="radio" id="prod2" name="prod" value="total" checked="checked"/> <label for="prod2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="productionTrend"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="chart4"></div>
						<div class="modal" id="productionTrendContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-4"></div>
                           </div>
                        </div>
					</div>
					
					<!-- 주요 품목 그룹별 생산 실적 -->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="productionPerformanceByMajorItemGroupH4"><spring:message code="lbl.itemGroupChart2" /> (EA)</h4>
							<div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="weekMonthChart1" name="weekMonthChart9" value="week"/><label for="weekMonthChart1"><spring:message code="lbl.weekly" /></label></li>
									<li><input type="radio" id="weekMonthChart2" name="weekMonthChart9" value="month" checked="checked"/><label for="weekMonthChart2"><spring:message code="lbl.month2" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="productionPerformanceByMajorItemGroup"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="chart9"></div>
						<div class="modal" id="productionPerformanceByMajorItemGroupContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-5"></div>
                           </div>
                        </div>
					</div>
					
					
					<!-- 생산 준수율 -->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="productionComplianceRateH4"><spring:message code="lbl.prodCmplRateChart2" /> (%)</h4>
							
							<div class="view_combo" > <!-- class="action" id="productionComplianceRateAction" -->
								<!--  <span>+</span> -->
								<ul class="rdofl" > <!-- style="height:130px;width:115px;" -->
									<li><input type="radio" id="prodRateWeek1" name="prodRateWeek" value="std" checked="checked"/> <label for="prodRateWeek1"><spring:message code="lbl.stdWeek" /></label></li>
									<li><input type="radio" id="prodRateWeek2" name="prodRateWeek" value="sales"/> <label for="prodRateWeek2"><spring:message code="lbl.salesWeek" /> </label></li>
									<li><input type="radio" id="prodRate1" name="prodRate" value="item"/> <label for="prodRate1"><spring:message code="lbl.part" /></label></li>
									<li><input type="radio" id="prodRate2" name="prodRate" value="total" checked="checked"/> <label for="prodRate2"><spring:message code="lbl.itemTotal" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="productionComplianceRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>    
								</ul>
							</div>
							
						</div>
						<div style="height: 88%;clear:both;" id="chart13" ></div>
						<div class="modal" id="productionComplianceRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-6"></div>
                           </div>
                        </div>
					</div>
					
					<!-- 공급능력지수 -->
					<div class="col_3">
						<div class="titleContainer">	
							<h4 id="supplyCapacityIndexH4"><spring:message code="lbl.supplyCapacityRate" /> (%)</h4>
							<div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="agingTrend1" name="agingTrend" value="cust"/> <label for="agingTrend1"><spring:message code="lbl.reptCust" /></label></li>
									<li><input type="radio" id="agingTrend2" name="agingTrend" value="total" checked="checked"/> <label for="agingTrend2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="supplyCapacityIndex"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="chart5"></div>
						<div class="modal" id="supplyCapacityIndexContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-7"></div>
                           </div>
                        </div>
					</div>
					
					<!-- 재공 -->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="stockInWorkH4"><spring:message code="lbl.wip2" /></h4>
							<div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="amtRate1" name="amtRate" value="amt" checked="checked"/> <label for="amtRate1"><spring:message code="lbl.amount" />(<spring:message code="lbl.hMillion" />)</label></li>
									<li><input type="radio" id="amtRate2" name="amtRate" value="rate"/> <label for="amtRate2"><spring:message code="lbl.wipRt" /> (%)</label></li>
									<li><input type="radio" id="wip1" name="wip" value="item"/> <label for="wip1"><spring:message code="lbl.part" /></label></li>
									<li><input type="radio" id="wip2" name="wip" value="total" checked="checked"/> <label for="wip2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="stockInWork"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="chart19" ></div>
						<div class="modal" id="stockInWorkContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-8"></div>
                           </div>
                        </div>
					</div>

					<!-- 재공 Aging -->					
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="stockInWorkAgingH4"><spring:message code="lbl.trend22Chart" /> (<spring:message code="lbl.hMillion" />)</h4>
							<div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="trend22_m2" name="trend22" value="M2" checked="checked"/> <label for="trend22_m2"><spring:message code="lbl.2mMore" /></label></li>
									<li><input type="radio" id="trend22_m6" name="trend22" value="M6"/> <label for="trend22_m6"><spring:message code="lbl.6mMore" /></label></li>
									<li><input type="radio" id="trend22_y1" name="trend22" value="Y1"/> <label for="trend22_y1"><spring:message code="lbl.yearOneMore" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="stockInWorkAging"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="chart21"></div>
						<div class="modal" id="stockInWorkAgingContent" style="display:none;">
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
