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
	
	#cont_chart .col_3 { margin:0; width:calc((100% - 4px) / 3) ; height:calc((100% - 4px) / 3); padding:5px;position:relative;}
	#cont_chart .col_3:nth-child(1) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(2) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(3) {margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(4) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(5) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(6) {margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(7) {margin:0 2px 0 0;}
	#cont_chart .col_3:nth-child(8) {margin:0 2px 0 0;}
	#cont_chart .col_3:nth-child(9)	{margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(10){margin:0 2px 0 0;}
	#cont_chart .col_3:nth-child(11){margin:0 2px 0 0;}
	#cont_chart .col_3:nth-child(12){margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(13){margin:0 2px 0 0;}
	#cont_chart .col_3:nth-child(14){margin:0 2px 0 0;}
	
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
	
	#cont_chart3.hide{
		display:none;
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
		font-size:12px;
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
	var quill_1,quill_2,quill_3,quill_4,quill_5,quill_6,quill_7,quill_8,quill_9,quill_10,quill_11,quill_12,quill_13,quill_14,quill_15;
	var unit = 0;
	var unit2 = 0;
	var snopMeeting = {

		init : function () {
			gfn_formLoad();
			fn_siteMap();
			fn_quilljsInit();
			this.initSearch();
			this.events();
			
			var userLang = "${sessionScope.GV_LANG}";
			
			if(userLang == "ko"){
	    		unit = 100000000;
	    		unit2 = 10000;
	    	}else if(userLang == "en" || userLang == "cn"){
	    		unit = 1000000000;
	    		unit2 = 1000;
	    	}
		},
	
		_siq_demand	: "dashboard.demendTrend.",
		
		_siq_supply : "dashboard.supplyTrend.",
		
		_siq_purchase : "dashboard.purchaseTrend.",
		
		events : function () {
			//출하 준수율
			$(':radio[name=sales]').on('change', function () {
				snopMeeting.salesSearch(false);
			});
			//출하 준수율
			$(':radio[name=salesInv]').on('change', function () {
				snopMeeting.salesSearch(false);
			});
			//출하 TREND
			$(':radio[name=chart24_type]').on('change', function () {
				snopMeeting.chart24Search(false);
			});
			//출하 TREND
			$(':radio[name=chart24_weekMonth_type]').on('change', function () {
				snopMeeting.chart24Search(false);
			});
			//출하 TREND
			$(':radio[name=chart23Radio]').on('change', function () {
				snopMeeting.chart23RadioSearch(false);
			});
			//출하 TREND
			$(':radio[name=chart2_type]').on('change', function () {
				snopMeeting.chart2Search(false);
			});
			//출하 TREND
			$(':radio[name=chart2_weekMonth_type]').on('change', function () {
				snopMeeting.chart2Search(false);
			});
			//영업이익
			$(':radio[name=operProfitType]').on('change', function () {
				snopMeeting.operProfitSearch(false);
			});
			//제품 재고
			$(':radio[name=trend5]').on('change', function () {
				var str = '<spring:message code="lbl.pitChart" />(<spring:message code="lbl.hMillion" />, <spring:message code="lbl.dayChart" />)';
				
				if($(this).val() == "amt") {
					str = '<spring:message code="lbl.pitChart" />(<spring:message code="lbl.hMillion" />)';
				}
				
				$("#chart8_title").html(str);
				
				snopMeeting.trend5Search(false);
			});
			$(':radio[name=trend5_type]').on('change', function () {
				snopMeeting.trend5Search(false);
			});
			
			$(':radio[name=companyCons]').on('change', function () {
				snopMeeting.trend5Search(false);
			});
			
			$(':radio[name=trend5_weekMonth_type]').on('change', function () {
				snopMeeting.trend5Search(false);
			});
			//불량률
			$(':radio[name=key]').on('change', function () {
				snopMeeting.defactSearch(false);
			});
			//불량률
			$(':radio[name=firstAs]').on('change', function () {
				snopMeeting.defactSearch(false);
			});
			//생산 TREND
			$(':radio[name=prod]').on('change', function () {
				snopMeeting.prodSearch(false);
			});
			//주요 품목 그룹별 생산 실적
			$(':radio[name=weekMonthChart9]').on('change', function () {
				snopMeeting.chart9Search(false);
			});
			//재공
			$(':radio[name=wip]').on('change', function () {
				snopMeeting.wipSearch(false);
			});
			//재공
			$(':radio[name=amtRate]').on('change', function () {
				snopMeeting.wipSearch(false);
			});
			//생산 준수율
			$(':radio[name=prodRate]').on('change', function () {
				snopMeeting.prodRateSearch(false);
			});
			//생산 준수율
			$(':radio[name=prodRateWeek]').on('change', function () {
				snopMeeting.prodRateSearch(false);
			});
			//공급능력지수
			$(':radio[name=agingTrend]').on('change', function () {
				snopMeeting.agingTrendSearch(false);
			});
			//재고 TREND
			$(':radio[name=inv]').on('change', function () {
				snopMeeting.invSearch(false);
			});
			//재고 TREND
			$(':radio[name=inv_type]').on('change', function () {
				snopMeeting.invSearch(false);
			});
			//재고 TREND
			$(':radio[name=inv_weekMonth_type]').on('change', function () {
				snopMeeting.invSearch(false);
			});
			//자재 가용률
			$(':radio[name=weekMonth]').on('change', function () {
				snopMeeting.trend17Search(false);
			});
			//자재 가용률
			$(':radio[name=proTypeTotal]').on('change', function () {
				snopMeeting.trend17Search(false);
			});
			
			
			
			// 타이틀 클릭시 메뉴 이동
			var arrTitle = $("h4");
	    	
			$.each(arrTitle, function(n, v) {
	    		$(v).css("cursor", "pointer");
	    		$(v).on("click", function() {
	    			if (n == 0) gfn_newTab("SNOP207");//매출 TREND
	    			else if (n == 1) gfn_newTab("SNOP301");//출하 TREND
	    			else if (n == 2) gfn_newTab("SNOP207");//영업이익
	    			else if (n == 3) gfn_newTab("SNOP205");//출하 준수율
	    			else if (n == 4) gfn_newTab("SNOP301");//제품 재고 
	    			else if (n == 5) gfn_newTab("QT101");//불량률
	    			else if (n == 6) gfn_newTab("QT102");//Claim Rate
	    			else if (n == 7) gfn_newTab("MP101");//생산 Trend
	    			else if (n == 8) gfn_newTab("MP101");//주요 품목 그룹별  생산 실적
	    			else if (n == 9) gfn_newTab("MP105");//재공
	    			else if (n == 10) gfn_newTab("SNOP304");//생산 준수율(주)
	    			else if (n == 11) gfn_newTab("MP102");//공급능력지수(%)
	    			else if (n == 12) gfn_newTab("SNOP205");//재고 Trend
	    			else if (n == 13) gfn_newTab("SNOP305");//자재 가용률
	    			else if (n == 14) gfn_newTab("MP209");// 주간 입고 준수율
	    			
	    		});
	    	});
			
			
			 $('.titleContainer > .action').hover(function(){
	                
	                var chartId = this.id;
	                
	                // 매출  TREND
	                if(chartId == 'salesTrendAction')
	                {
	                	salesTrendActionToggle();
	                    
	                }
	                //출하 TREND
	                else if(chartId == 'shipmentTrendAction')
	                {
	                	shipmentTrendActionToggle();  
	                
	                }
	                //제품 재고
                    else if(chartId == 'productInventoryAction')
                    {
                    	productInventoryActionToggle();  
                    
                    }
	                //출하 준수율
                    else if(chartId == 'shipmentComplianceRateAction')
                    {
                    	shipmentComplianceRateActionToggle();  
                    
                    }
	                //불량률
                    else if(chartId == 'defectiveRateSupplyAction')
                    {
                    	defectiveRateSupplyActionToggle();  
                    
                    }
	                //생산 준수율
                    else if(chartId == 'productionComplianceRateAction')
                    {
                    	productionComplianceRateActionToggle();  
                    
                    }
	                 //재고 TREND
                    else if(chartId == 'stockTrendAction')
                    {
                    	stockTrendActionToggle();  
                    
                    }
                    
	                
	                
	            });
			 
			 
			 $(".manuel > a").dblclick("on", function() {
	                
	                var chartId  = this.id;
	        
	                fn_popUpAuthorityHasOrNot();
	                
	                var isSCMTeam = SCM_SEARCH.isSCMTeam;
	                
	                if(isSCMTeam>=1)
	                {
	                	//매출 TREND
	                	if(chartId == "salesTrend")
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
	                	//출하 TREND
	                	else if(chartId == "shipmentTrend")
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
	                	//영업이익
	                	else if(chartId == "operatingProfit")
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
	                	//제품 재고
	                	else if(chartId == "productInventory")
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
	                	//출하 준수율
	                	else if(chartId == "shipmentComplianceRate")
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
	                	//Claim Rate
	                	else if(chartId == "claimRate")
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
	                	//생산 Trend
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
	                	//재고 Trend
	                	else if(chartId == "stockTrend")
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
	                	//자재 가용률
	                	else if(chartId == "materialAvailability2")
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
	                	//주간 입고 준수율
	                	else if(chartId == "weeklyGoodsReceiptComplianceRate")
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
	                
	                //매출 TREND
                    if(chartId == "salesTrend")
                    {
                    	$('#chart2').toggle();
                    	$('#salesTrendContent').toggle();
                    }
                    //출하 TREND
                    else if(chartId == "shipmentTrend")
                    {
                        $('#chart24').toggle();
                        $('#shipmentTrendContent').toggle();
                    }
                    //영업이익
                    else if(chartId == "operatingProfit")
                    {
                        $('#operProfit').toggle();
                        $('#operatingProfitContent').toggle();
                    }
                    //제품 재고
                    else if(chartId == "productInventory")
                    {
                        $('#chart8').toggle();
                        $('#productInventoryContent').toggle();
                    }
                    //출하 준수율
                    else if(chartId == "shipmentComplianceRate")
                    {
                        $('#chart10').toggle();
                        $('#shipmentComplianceRateContent').toggle();
                    }
                    //불량률
                    else if(chartId == "defectiveRateSupply")
                    {
                        $('#chart6').toggle();
                        $('#defectiveRateSupplyContent').toggle();
                    }
                    //Claim Rate
                    else if(chartId == "claimRate")
                    {
                        $('#chart3').toggle();
                        $('#claimRateContent').toggle();
                    }
                    //생산 Trend
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
                    //재공
                    else if(chartId == "stockInWork")
                    {
                        $('#chart19').toggle();
                        $('#stockInWorkContent').toggle();
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
                    //재고 Trend
                    else if(chartId == "stockTrend")
                    {
                        $('#chart7').toggle();
                        $('#stockTrendContent').toggle();
                    }
                    //자재 가용률
                    else if(chartId == "materialAvailability2")
                    {
                        $('#chart17').toggle();
                        $('#materialAvailability2Content').toggle();
                    }
                    //주간 입고 준수율
                    else if(chartId == "weeklyGoodsReceiptComplianceRate")
                    {
                        $('#weekReceiveRateChart').toggle();
                        $('#weeklyGoodsReceiptComplianceRateContent').toggle();
                    }
	                
			 });
			 
			 $(".titleContainer > h4").hover(function() {
	                
	                var chartId  = this.id;
			 
	                //매출 TREND
                    if(chartId == "salesTrendH4")
                    {
                        $('#chart2').toggle();
                        $('#salesTrendContent').toggle();
                    }
                    //출하 TREND
                    else if(chartId == "shipmentTrendH4")
                    {
                        $('#chart24').toggle();
                        $('#shipmentTrendContent').toggle();
                    }
                    //영업이익
                    else if(chartId == "operatingProfitH4")
                    {
                        $('#operProfit').toggle();
                        $('#operatingProfitContent').toggle();
                    }
                    //제품 재고
                    else if(chartId == "chart8_title")
                    {
                        $('#chart8').toggle();
                        $('#productInventoryContent').toggle();
                    }
                    //출하 준수율
                    else if(chartId == "shipmentComplianceRateH4")
                    {
                        $('#chart10').toggle();
                        $('#shipmentComplianceRateContent').toggle();
                    }
                    //불량률
                    else if(chartId == "defectiveRateSupplyH4")
                    {
                        $('#chart6').toggle();
                        $('#defectiveRateSupplyContent').toggle();
                    }
                    //Claim Rate
                    else if(chartId == "claimRateH4")
                    {
                        $('#chart3').toggle();
                        $('#claimRateContent').toggle();
                    }
                    //생산 Trend
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
                    //재공
                    else if(chartId == "stockInWorkH4")
                    {
                        $('#chart19').toggle();
                        $('#stockInWorkContent').toggle();
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
                    //재고 Trend
                    else if(chartId == "stockTrendH4")
                    {
                        $('#chart7').toggle();
                        $('#stockTrendContent').toggle();
                    }
                    //자재 가용률
                    else if(chartId == "materialAvailability2H4")
                    {
                        $('#chart17').toggle();
                        $('#materialAvailability2Content').toggle();
                    }
                    //주간 입고 준수율
                    else if(chartId == "weeklyGoodsReceiptComplianceRateH4")
                    {
                        $('#weekReceiveRateChart').toggle();
                        $('#weeklyGoodsReceiptComplianceRateContent').toggle();
                    }
                    
			 
			 });
			 
		},
		
		bucket : null,
		
		initSearch : function (sqlFlag) {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [
									{ outDs : "week"  , _siq : snopMeeting._siq_demand + "trendBucketWeek" }
    			  	     		  , { outDs : "month" , _siq : snopMeeting._siq_demand + "trendBucketMonth" }
    			  	     		  , { outDs : "weekReceiveBucket" , _siq : snopMeeting._siq_purchase + "weekReceiveBucket" }
    			  	     		  , { outDs : "chartList" , _siq : "dashboard.chartInfo.snopMeeting" }  
    			  	     		  ];
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					snopMeeting.bucket = {};
					
					//수요,공급 => week, month 동일 
					snopMeeting.bucket.week  = data.week;
					snopMeeting.bucket.month = data.month;
					snopMeeting.bucket.weekReceive = data.weekReceiveBucket;
					
					FORM_SEARCH.chartList = data.chartList;
					fn_chartContentInit();
					snopMeeting.search();
				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			
			FORM_SEARCH            = {};
			FORM_SEARCH            = this.bucket;
			FORM_SEARCH.sales      = $(':radio[name=sales]:checked').val();
			FORM_SEARCH.salesInv = $(':radio[name=salesInv]:checked').val();
			FORM_SEARCH.trend5     = $(':radio[name=trend5]:checked').val();
			FORM_SEARCH.trend5_type = $(':radio[name=trend5_type]:checked').val();
			FORM_SEARCH.chart24_type   = $(':radio[name=chart24_type]:checked').val();
			FORM_SEARCH.chart24_weekMonth_type   = $(':radio[name=chart24_weekMonth_type]:checked').val();
			FORM_SEARCH.trend5_weekMonth_type = $(':radio[name=trend5_weekMonth_type]:checked').val();
			FORM_SEARCH.chart2_type = $(':radio[name=chart2_type]:checked').val();
			FORM_SEARCH.chart2_weekMonth_type = $(':radio[name=chart2_weekMonth_type]:checked').val();
			FORM_SEARCH.operProfitType = $(':radio[name=operProfitType]:checked').val();
			FORM_SEARCH.key        = $(':radio[name=key]:checked').val();          //불량률
			FORM_SEARCH.firstAs    = $(':radio[name=firstAs]:checked').val();      //불량률
			FORM_SEARCH.prod       = $(':radio[name=prod]:checked').val();		   //생산TREND
			FORM_SEARCH.prodRate   = $(':radio[name=prodRate]:checked').val();	   //생산준수율
			FORM_SEARCH.prodRateWeek   = $(':radio[name=prodRateWeek]:checked').val();//생산준수율
			FORM_SEARCH.agingTrend = $(':radio[name=agingTrend]:checked').val();   //공급능력지수
			FORM_SEARCH.amtRate    = $(':radio[name=amtRate]:checked').val();      //재공
			FORM_SEARCH.wip        = $(':radio[name=wip]:checked').val();    	   //재공
			FORM_SEARCH.weekMonthChart9    = $(':radio[name=weekMonthChart9]:checked').val();//주요 품목 그룹별 생산 실적
			
			FORM_SEARCH.inv        = $(':radio[name=inv]:checked').val();
			FORM_SEARCH.inv_type = $(':radio[name=inv_type]:checked').val();
			FORM_SEARCH.inv_weekMonth_type = $(':radio[name=inv_weekMonth_type]:checked').val();
			
			FORM_SEARCH.weekMonth  = $(':radio[name=weekMonth]:checked').val();
			FORM_SEARCH.proTypeTotal = $(':radio[name=proTypeTotal]:checked').val();
			
			
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			FORM_SEARCH.unit2      = unit2;
			FORM_SEARCH.tranData   = [
				{ outDs : "chart10", _siq : snopMeeting._siq_demand + "chart10" },
				{ outDs : "chart24", _siq : snopMeeting._siq_demand + "chart24" },
				{ outDs : "chart2", _siq : snopMeeting._siq_demand + "chart2" },
				<c:if test="${sessionScope.userInfo.dashboardYn == 'Y'}">
				{ outDs : "operProfit", _siq : snopMeeting._siq_demand + "operProfit" },
				</c:if>
				{ outDs : "chart8", _siq : snopMeeting._siq_demand + "chart8" },
				{ outDs : "chart6", _siq : snopMeeting._siq_supply + "chart6" },//불량률
				{ outDs : "chart3", _siq : snopMeeting._siq_supply + "chart3" },//Claim Rate (ppm, 월)
				{ outDs : "chart4", _siq : snopMeeting._siq_supply + "chart4" },//생산 TREND
				{ outDs : "chart9", _siq : snopMeeting._siq_supply + "chart9" },//주요 품목 그룹별 생산 실적
				{ outDs : "chart19", _siq : snopMeeting._siq_supply + "chart19" },//재공
				{ outDs : "chart13", _siq : snopMeeting._siq_supply + "chart13" },//생산 준수율
				{ outDs : "chart5", _siq : snopMeeting._siq_supply + "chart5" },  //공급능력지수
				{ outDs : "chart7" , _siq : snopMeeting._siq_purchase + "chart7" }, //재고 TREND
				{ outDs : "chart17" , _siq : snopMeeting._siq_purchase + "chart17" },//자재 가용률
				{ outDs : "weekReceiveRateChart", _siq : snopMeeting._siq_purchase + "weekReceiveRateChart" },//주간 입고 준수율(%)
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					snopMeeting.drawChart(data);
				}
			}
			gfn_service(sMap,"obj");
		},
		//출하 준수율
		salesSearch : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = snopMeeting.bucket;
			FORM_SEARCH.sales    = $(':radio[name=sales]:checked').val();
			FORM_SEARCH.salesInv = $(':radio[name=salesInv]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart10" , _siq : snopMeeting._siq_demand + "chart10" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreWeek = new Array();
			
					$.each (snopMeeting.bucket.week, function (i, el) {
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					var chart10 = JSON.parse(data.chart10[0].SALES_CML);
					
					snopMeeting.chartGen('chart10', 'line', arPreWeek, chart10);
				}
			}
			gfn_service(sMap,"obj");
		},
		//출하 TREND
		chart24Search : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = snopMeeting.bucket;
			FORM_SEARCH.chart24_type = $(':radio[name=chart24_type]:checked').val();
			FORM_SEARCH.chart24_weekMonth_type = $(':radio[name=chart24_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart24" , _siq : snopMeeting._siq_demand + "chart24" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var weekMonth = $(':radio[name=chart24_weekMonth_type]:checked').val();
					
					if(weekMonth == "WEEK"){
						var arWeek = new Array();
						
						$.each (snopMeeting.bucket.week, function (i, el) {
							arWeek.push(el.DISWEEK);
						});
						
						var chart24 = JSON.parse(data.chart24[0].SALES);
						snopMeeting.chartGen('chart24', 'line', arWeek, chart24);
						
					}else{
						var arMonth = new Array();
						
						$.each (snopMeeting.bucket.month, function (i, el) {
							arMonth.push(el.DISMONTH);
						});
						var chart24 = JSON.parse(data.chart24[0].SALES);
						snopMeeting.chartGen('chart24', 'line', arMonth, chart24);	
					}
				}
			}
			gfn_service(sMap,"obj");
		},
		//매출 TREND
		chart2Search : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = snopMeeting.bucket;
			FORM_SEARCH.chart2_type   = $(':radio[name=chart2_type]:checked').val();
			FORM_SEARCH.chart2_weekMonth_type   = $(':radio[name=chart2_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart2" , _siq : snopMeeting._siq_demand + "chart2" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var weekMonth = $(':radio[name=chart2_weekMonth_type]:checked').val();
					
					if(weekMonth == "WEEK"){
						var arWeek = new Array();
						
						$.each (snopMeeting.bucket.week, function (i, el) {
							arWeek.push(el.DISWEEK);
						});
						
						var chart2 = JSON.parse(data.chart2[0].CUST);

						snopMeeting.chartGen('chart2', 'line', arWeek, chart2);
					}else{
						var arMonth = new Array();
						
						$.each (snopMeeting.bucket.month, function (i, el) {
							arMonth.push(el.DISMONTH);
						});
						var chart2 = JSON.parse(data.chart2[0].CUST);
						snopMeeting.chartGen('chart2', 'line', arMonth, chart2);						
					}
				}
			}
			gfn_service(sMap,"obj");
		},
		//영업 이익
		operProfitSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = snopMeeting.bucket;
			FORM_SEARCH.operProfitType   = $(':radio[name=operProfitType]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "operProfit" , _siq : snopMeeting._siq_demand + "operProfit" },
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreMonth = new Array();
					
					$.each (snopMeeting.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var operProfit = JSON.parse(data.operProfit[0].OPER_PROFIT);
					snopMeeting.chartGen('operProfit', 'line', arPreMonth, operProfit);
					
				}
			}
			gfn_service(sMap,"obj");
		},
		//제품 재고
		trend5Search : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = snopMeeting.bucket;
			FORM_SEARCH.trend5   = $(':radio[name=trend5]:checked').val();
			FORM_SEARCH.trend5_type = $(':radio[name=trend5_type]:checked').val();
			FORM_SEARCH.companyCons = $(':radio[name=companyCons]:checked').val();
			FORM_SEARCH.trend5_weekMonth_type = $(':radio[name=trend5_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart8" , _siq : snopMeeting._siq_demand + "chart8" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreCate = new Array();
					var chart8 = JSON.parse(data.chart8[0].ITEM_INV);

					if(FORM_SEARCH.trend5_weekMonth_type == "WEEK"){
						$.each (snopMeeting.bucket.week, function (i, el) {
							arPreCate.push(el.DISWEEK);
						});
					}else{
						$.each (snopMeeting.bucket.month, function (i, el) {
							arPreCate.push(el.DISMONTH);
						});
					}

					snopMeeting.chartGen('chart8', 'line', arPreCate, chart8);
				}
			}
			gfn_service(sMap,"obj");
		},
		//불량률 
		defactSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = snopMeeting.bucket;
			FORM_SEARCH.key      = $(':radio[name=key]:checked').val();
			FORM_SEARCH.firstAs  = $(':radio[name=firstAs]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart6" , _siq : snopMeeting._siq_supply + "chart6" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					// cartegory
					var arPreMonth = new Array();
					var arMonth = new Array();
			
					$.each (snopMeeting.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
						arMonth.push(el.DISMONTH);
					});
					
					var chart6 = JSON.parse(data.chart6[0].DEFECT);
					//supplyTrend1.tagetStyle(chart6);
					snopMeeting.chartGen('chart6', 'line', arMonth, chart6);
				}
			}
			gfn_service(sMap,"obj");
		},
		//생산 TREND
		prodSearch : function (sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = snopMeeting.bucket;
			FORM_SEARCH.prod     = $(':radio[name=prod]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart4" , _siq : snopMeeting._siq_supply + "chart4" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					var arMonth = new Array();
			
					$.each (snopMeeting.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
						arMonth.push(el.DISMONTH);
					});
					var chart4 = JSON.parse(data.chart4[0].PROD_TREND);

					snopMeeting.chartGen('chart4', 'line', arMonth, chart4);
				}
			}
			gfn_service(sMap,"obj");
		},
		//주요 품목 그룹별 생산 실적 
		chart9Search : function(sqlFlag) {
			FORM_SEARCH = {};
			FORM_SEARCH = snopMeeting.bucket;
			FORM_SEARCH.weekMonthChart9    = $(':radio[name=weekMonthChart9]:checked').val();
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart9" , _siq : snopMeeting._siq_supply + "chart9" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arWeek = new Array();
					var arMonth = new Array();
					
					
					$.each (snopMeeting.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					
					$.each (snopMeeting.bucket.week, function (i, el) {
						arWeek.push(el.DISWEEK);
					});
					
					
					var chart9 = JSON.parse(data.chart9[0].CAPA);
					
					if(FORM_SEARCH.weekMonthChart9 == "month"){
						snopMeeting.chartGen('chart9', 'line', arMonth, chart9);	
					}else{
						snopMeeting.chartGen('chart9', 'line', arWeek, chart9);
					}
				}
			}
			gfn_service(sMap,"obj");
		},
		//재공
		wipSearch : function(sqlFlag) {
			FORM_SEARCH = {};
			FORM_SEARCH = snopMeeting.bucket;
			FORM_SEARCH.amtRate = $(':radio[name=amtRate]:checked').val();
			FORM_SEARCH.wip  = $(':radio[name=wip]:checked').val();
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart19" , _siq : snopMeeting._siq_supply + "chart19" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arMonth = new Array();
					var arPreMonth = new Array();
					
					$.each (snopMeeting.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
						arPreMonth.push(el.PRE_DISMONTH);
					});
					var chart19 = JSON.parse(data.chart19[0].WIP);
					
					if(FORM_SEARCH.amtRate == "amt"){
						snopMeeting.chartGen('chart19', 'line', arMonth, chart19);	
					}else{
						snopMeeting.chartGen('chart19', 'line', arPreMonth, chart19);
					}
				}
			}
			gfn_service(sMap,"obj");
		},
		//생산 준수율
		prodRateSearch : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = snopMeeting.bucket;
			FORM_SEARCH.prodRate = $(':radio[name=prodRate]:checked').val();
			FORM_SEARCH.prodRateWeek = $(':radio[name=prodRateWeek]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart13" , _siq : snopMeeting._siq_supply + "chart13" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arWeek = new Array();
			
					$.each (snopMeeting.bucket.week, function (i, el) {
						arWeek.push(el.DISWEEK);
					});
					
					var chart13 = JSON.parse(data.chart13[0].PROD_CML);

					snopMeeting.chartGen('chart13', 'line', arWeek, chart13);
				}
			}
			gfn_service(sMap,"obj");
		},
		//공급능력지수
		agingTrendSearch : function(sqlFlag) {
			FORM_SEARCH            = {};
			FORM_SEARCH            = snopMeeting.bucket;
			FORM_SEARCH.agingTrend = $(':radio[name=agingTrend]:checked').val();
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.tranData   = [
				{ outDs : "chart5" , _siq : snopMeeting._siq_supply + "chart5" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					var arMonth = new Array();
			
					$.each (snopMeeting.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
						arMonth.push(el.DISMONTH);
					});
					
					var chart5 = JSON.parse(data.chart5[0].CAPA);

					snopMeeting.chartGen('chart5', 'line', arMonth, chart5); 
				}
			}
			gfn_service(sMap,"obj");
		},
		//재고 TREND
		invSearch : function (sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = snopMeeting.bucket;
			FORM_SEARCH.inv      = $(':radio[name=inv]:checked').val();
			FORM_SEARCH.inv_type = $(':radio[name=inv_type]:checked').val();
			FORM_SEARCH.inv_weekMonth_type = $(':radio[name=inv_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart7" , _siq : snopMeeting._siq_purchase + "chart7" }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreCate = new Array();
					var chart7 = JSON.parse(data.chart7[0].INVENTORY);
					
					if(FORM_SEARCH.inv_weekMonth_type == "WEEK"){
						$.each (snopMeeting.bucket.week, function (i, el) {
							arPreCate.push(el.DISWEEK);
						});
					}else{
						$.each (snopMeeting.bucket.month, function (i, el) {
							arPreCate.push(el.DISMONTH);
						});
					}
					snopMeeting.chartGen('chart7', 'line', arPreCate, chart7);
				}
			}
			gfn_service(sMap,"obj");
		},
		//자재 가용률 (%)
		trend17Search : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = snopMeeting.bucket;
			FORM_SEARCH.weekMonth  = $(':radio[name=weekMonth]:checked').val();
			FORM_SEARCH.proTypeTotal = $(':radio[name=proTypeTotal]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart17" , _siq : snopMeeting._siq_purchase + "chart17" }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					var arPreWeek = new Array();
					var arPreMonth = new Array();
			
					$.each (snopMeeting.bucket.week, function (i, el) {
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					$.each (snopMeeting.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart17 = JSON.parse(data.chart17[0].ITEM);
					
					if(FORM_SEARCH.weekMonth == "week"){
						snopMeeting.chartGen('chart17', 'line', arPreWeek, chart17);
					}else{
						snopMeeting.chartGen('chart17', 'line', arPreMonth, chart17);
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
			var arWeekReceive = new Array();
			
			$.each (snopMeeting.bucket.month, function (i, el) {
				arMonth.push(el.DISMONTH);
				arPreMonth.push(el.PRE_DISMONTH);
			});
			
			$.each (snopMeeting.bucket.week, function (i, el) {
				arWeek.push(el.DISWEEK);
				arPreWeek.push(el.PRE_DISWEEK);
			});
			
			$.each (snopMeeting.bucket.weekReceive, function (i, el) {
				arWeekReceive.push(el.DISWEEK);
			});
			
			
			
			var chart10 = JSON.parse(res.chart10[0].SALES_CML);
			var chart24 = JSON.parse(res.chart24[0].SALES);
			var chart2 = JSON.parse(res.chart2[0].CUST);
			var chart8 = JSON.parse(res.chart8[0].ITEM_INV);
			<c:if test="${sessionScope.userInfo.dashboardYn == 'Y'}">
			var operProfit = JSON.parse(res.operProfit[0].OPER_PROFIT);
			this.chartGen('operProfit', 'line', arPreMonth, operProfit);
			</c:if>
			
			
			var chart6 = JSON.parse(res.chart6[0].DEFECT);//불량률
			var chart3 = JSON.parse(res.chart3[0].CLAIM);//Claim Rate (ppm, 월)
			var chart4 = JSON.parse(res.chart4[0].PROD_TREND);//생산 TREND
			var chart9 = JSON.parse(res.chart9[0].CAPA);//주요 품목 그룹별 생산 실적
			var chart19 = JSON.parse(res.chart19[0].WIP);//재공
			var chart13 = JSON.parse(res.chart13[0].PROD_CML);//생산 준수율
			var chart5 = JSON.parse(res.chart5[0].CAPA);//공급능력지수
			
			var chart7 = JSON.parse(res.chart7[0].INVENTORY);//재고 TREND
			var chart17 = JSON.parse(res.chart17[0].ITEM);//자재 가용률(%)
			
			var weekReceiveRateChart = JSON.parse(res.weekReceiveRateChart[0].WEEK_RECEIVE);//주간입고 준수율
			
			this.chartGen('chart10', 'line', arPreWeek, chart10);
			this.chartGen('chart24', 'line', arMonth , chart24);
			this.chartGen('chart2', 'line', arMonth, chart2);
			this.chartGen('chart8', 'line', arWeek, chart8);
			
			
			this.chartGen('chart6', 'line', arMonth, chart6);//불량률
			this.chartGen('chart3', 'line', arMonth, chart3);//Claim Rate (ppm, 월)
			this.chartGen('chart4', 'line', arMonth, chart4);//생산 TREND
			this.chartGen('chart9', 'line', arMonth, chart9);//주요 품목 그룹별 생산 실적
			if(amtRateFlag == "amt"){
				this.chartGen('chart19', 'line', arMonth, chart19);	//재공
			}else{
				this.chartGen('chart19', 'line', arPreMonth, chart19);//재공
			}
			this.chartGen('chart13', 'line', arWeek, chart13);//생산 준수율
			this.chartGen('chart5', 'line', arMonth, chart5);//공급능력지수
			this.chartGen('chart7', 'line', arWeek, chart7);//자재 TREND
			this.chartGen('chart17', 'line', arPreWeek , chart17);//자재 가용률
			
			this.chartGen('weekReceiveRateChart', 'line', arWeekReceive, weekReceiveRateChart);//주간입고 준수율
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
			        			var chart23RadioData = $(':radio[name=chart23Radio]:checked').val();
			        			
			        			if(chartId == "chart23" && chart23RadioData == "cust") {
		        					for(var i = 0; i < chartLen; i++){
			        					
			        					var chartCode = this.chart.series[i].userOptions.code;
			        					
			        					if(chartCode != "RCG001"){
			        						this.chart.series[i].hide();	
			        					}
			        				}	
			        			}
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
									if(chartId == "chart10") {
										gfn_comPopupOpen("POPUP_CHART_DEMEND", {
											rootUrl   : "dashboard",
											url       : "popupChartDemend",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart10",
											title     : "<spring:message code='lbl.salesCmplRateChart2' /> (%)"
										});
									}
									else if(chartId == "chart24") {
										gfn_comPopupOpen("POPUP_CHART_DEMEND", {
											rootUrl   : "dashboard",
											url       : "popupChartDemend",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart24",
											title     : "<spring:message code='lbl.chart24' /> (<spring:message code='lbl.hMillion' />)"
										});	
									}
									else if(chartId == "chart2")	{
				                		gfn_comPopupOpen("POPUP_CHART_DEMEND", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartDemend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart2",
				        					title     : "<spring:message code='lbl.custSalesTrend' /> (<spring:message code='lbl.hMillion' />)"
				        				});
				                	}
									else if(chartId == "operProfit")	{
				                		gfn_comPopupOpen("POPUP_CHART_DEMEND", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartDemend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "operProfit",
				        					title     : "<spring:message code='lbl.operationProfit' /> (<spring:message code='lbl.hMillion' />)"
				        				});
				                	}
				                	else if(chartId == "chart8") {
										gfn_comPopupOpen("POPUP_CHART_DEMEND", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartDemend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />)'
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
									//Claim Rate (ppm, 월)
									else if(chartId == "chart3") {
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
									//재고 TREND
									else if(chartId == "chart7") {
										gfn_comPopupOpen("POPUP_PURCHASE_TREND_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartPurchaseTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : "<spring:message code='lbl.prodInvStatusChart2' /> (<spring:message code='lbl.hMillion' />)"
				        				});	
									}
									
									//자재 가용률(%)
									else if(chartId == "chart17")	{
			                			gfn_comPopupOpen("POPUP_PURCHASE_TREND_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartPurchaseTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : "<spring:message code='lbl.materialAva2' />"
				        				});	
			                		}
									
									//자재 입고 준수율(%)
									else if(chartId == "weekReceiveRateChart") {
										gfn_comPopupOpen("POPUP_PURCHASE_TREND_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartPurchaseTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : "<spring:message code='lbl.weekReceiveRate' /> (%)"
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
				minRange: 1,
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
				enabled: false,
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
		snopMeeting.search(sqlFlag);
	}
	
 	// onload 
	$(document).ready(function() {
		//var chartArray = ["chart10","chart11","chart12","cpfrShipPlanResultChart","chart23","chart24","chart2","operProfit"];
		
		snopMeeting.init();
		
		
	});

 	
 	
    function salesTrendActionToggle()
    {
    	 const action = $('#salesTrendAction');
         
         action.toggleClass('active')
    	
    }

    function shipmentTrendActionToggle()
    {
    	
            const action = $('#shipmentTrendAction');
            
            action.toggleClass('active')
           
       
    }

    function productInventoryActionToggle()
    {
    	
            const action = $('#productInventoryAction');
            
            action.toggleClass('active')
           
       
    }

    function shipmentComplianceRateActionToggle()
    {
        const action = $('#shipmentComplianceRateAction');
        
        action.toggleClass('active')
       
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
    
    function stockTrendActionToggle()
    {
        const action = $('#stockTrendAction');
        
        action.toggleClass('active')
       
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
        
        quill_10 =  new Quill('#editor-10', {
            
            modules: {
                "toolbar": false
            } ,            
            theme: 'snow'  // or 'bubble'
          })
        quill_10.enable(false);
        
        quill_11 =  new Quill('#editor-11', {
            
            modules: {
                "toolbar": false
            } ,            
            theme: 'snow'  // or 'bubble'
          })
        quill_11.enable(false);
        
        quill_12 =  new Quill('#editor-12', {
            
            modules: {
                "toolbar": false
            } ,            
            theme: 'snow'  // or 'bubble'
          })
        quill_12.enable(false);
        
        quill_13 =  new Quill('#editor-13', {
            
            modules: {
                "toolbar": false
            } ,            
            theme: 'snow'  // or 'bubble'
          })
        quill_13.enable(false);
        
        quill_14 =  new Quill('#editor-14', {
            
            modules: {
                "toolbar": false
            } ,            
            theme: 'snow'  // or 'bubble'
          })
        quill_14.enable(false);
        
        quill_15 =  new Quill('#editor-15', {
            
            modules: {
                "toolbar": false
            } ,            
            theme: 'snow'  // or 'bubble'
          })
        quill_15.enable(false);
}
    
    
    function fn_chartContentInit(){
        
        
        /*
        0. salesTrend
	    1. shipmentTrend
	    2. operatingProfit
		3. productInventory
		4. shipmentComplianceRate
		5. defectiveRateSupply
		6. claimRate
		7. productionTrend
		8. productionPerformanceByMajorItemGroup
		9. stockInWork
		10. productionComplianceRate
		11. supplyCapacityIndex
		12. stockTrend
		13. materialAvailability2
		14. weeklyGoodsReceiptComplianceRate

        */
        
        
        
        for(i=0;i<15;i++)
        {
            if(FORM_SEARCH.chartList[i].ID=="salesTrend")                                 FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_1.setContents([{ insert: '\n' }]):quill_1.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="shipmentTrend")                         FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_2.setContents([{ insert: '\n' }]):quill_2.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="operatingProfit")                       FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_3.setContents([{ insert: '\n' }]):quill_3.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="productInventory")                      FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_4.setContents([{ insert: '\n' }]):quill_4.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="shipmentComplianceRate")                FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_5.setContents([{ insert: '\n' }]):quill_5.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="defectiveRateSupply")                   FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_6.setContents([{ insert: '\n' }]):quill_6.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="claimRate")                             FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_7.setContents([{ insert: '\n' }]):quill_7.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="productionTrend")                       FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_8.setContents([{ insert: '\n' }]):quill_8.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="productionPerformanceByMajorItemGroup") FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_9.setContents([{ insert: '\n' }]):quill_9.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="stockInWork")                           FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_10.setContents([{ insert: '\n' }]):quill_10.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="productionComplianceRate")              FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_11.setContents([{ insert: '\n' }]):quill_11.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="supplyCapacityIndex")                   FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_12.setContents([{ insert: '\n' }]):quill_12.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="stockTrend")                            FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_13.setContents([{ insert: '\n' }]):quill_13.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="materialAvailability2")                 FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_14.setContents([{ insert: '\n' }]):quill_14.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="weeklyGoodsReceiptComplianceRate")      FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_15.setContents([{ insert: '\n' }]):quill_15.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
                                        
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
				
					<!-- 매출 TREND 8-->
					<div class="col_3">
						<div class="titleContainer">		
							<h4 id="salesTrendH4"><spring:message code="lbl.custSalesTrend" /> (<spring:message code="lbl.hMillion" />)</h4>
							<div class="view_combo"> <!-- class="action" id="salesTrendAction" -->
							    <!-- <span>+</span> -->
								<ul class="rdofl" > <!-- style="height:153px;" -->
									<li><input type="radio" id="chart2_weekMonth_type1" name="chart2_weekMonth_type" value="WEEK"/> <label for="chart2_weekMonth_type1"><spring:message code="lbl.weekly" /></label></li>
									<li><input type="radio" id="chart2_weekMonth_type2" name="chart2_weekMonth_type" value="MONTH" checked="checked"/> <label for="chart2_weekMonth_type2"><spring:message code="lbl.month2" /></label></li>
									<li><input type="radio" id="chart2_type1" name="chart2_type" value="cust"/> <label for="chart2_type1"><spring:message code="lbl.reptCust" /></label></li>
									<li><input type="radio" id="chart2_type3" name="chart2_type" value="prod" /> <label for="chart2_type3"><spring:message code="lbl.prodCate" /></label></li>
									<li><input type="radio" id="chart2_type2" name="chart2_type" value="total" checked="checked"/> <label for="chart2_type2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="salesTrend"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
								</ul>
							</div>
						</div>
						<div style="height: 88%" id="chart2"></div>
						<div class="modal" id="salesTrendContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-1"></div>
                           </div>
                       </div>
					</div>
					
					
					<!-- 출하 TREND 7-->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="shipmentTrendH4"><spring:message code="lbl.chart24" /> (<spring:message code="lbl.hMillion" />)</h4>
							<div class="view_combo"> <!-- class="action" id="shipmentTrendAction" -->
							    <!-- <span>+</span> -->
								<ul class="rdofl" > <!-- style="height:153px;" -->
									<li><input type="radio" id="chart24_weekMonth_type1" name="chart24_weekMonth_type" value="WEEK"/> <label for="chart24_weekMonth_type1"><spring:message code="lbl.weekly" /></label></li>
									<li><input type="radio" id="chart24_weekMonth_type2" name="chart24_weekMonth_type" value="MONTH" checked="checked"/> <label for="chart24_weekMonth_type2"><spring:message code="lbl.month2" /></label></li>
									<li><input type="radio" id="chart24_type1" name="chart24_type" value="cust"/> <label for="chart24_type1"><spring:message code="lbl.reptCust" /></label></li>
									<li><input type="radio" id="chart24_type3" name="chart24_type" value="prod" /> <label for="chart24_type3"><spring:message code="lbl.prodCate" /></label></li>
									<li><input type="radio" id="chart24_type2" name="chart24_type" value="total" checked="checked"/> <label for="chart24_type2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="shipmentTrend"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
								</ul>
							</div>
						</div>	
						<div style="height: 88%" id="chart24"></div>
						<div class="modal" id="shipmentTrendContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-2"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 영업 이익 9-->
					
					<div class="col_3">
						<c:if test="${sessionScope.userInfo.dashboardYn == 'Y'}">
						<div class="titleContainer">
							<h4 id="operatingProfitH4"><spring:message code="lbl.operationProfit" /> (<spring:message code="lbl.hMillion" />)</h4>
							<div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="operProfitCust" name="operProfitType" value="cust" /> <label for="operProfitCust"><spring:message code="lbl.reptCust" /></label></li>
									<li><input type="radio" id="operProfitProd" name="operProfitType" value="prod" /> <label for="operProfitProd"><spring:message code="lbl.prodCate" /></label></li>
									<li><input type="radio" id="operProfitTotal" name="operProfitType" value="total" checked="checked"/> <label for="operProfitTotal"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="operatingProfit"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%" id="operProfit"></div>
						<div class="modal" id="operatingProfitContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-3"></div>
                           </div>
                        </div>
						</c:if>
						<c:if test="${sessionScope.userInfo.dashboardYn != 'Y'}">
						<h4></h4>
						<div style="height: 100%;display:none;" id="operProfit"></div>
						<div class="modal" id="operatingProfitContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-3"></div>
                           </div>
                        </div>
						</c:if>
						
					</div>
					
						
					
					<!-- 제품 재고 -->
					<div class="col_3">
						<div class=	"titleContainer">
							<h4 id="chart8_title"><spring:message code="lbl.pitChart" />(<spring:message code="lbl.hMillion" />)</h4>
							<div class="view_combo"> <!-- class="action" id="productInventoryAction" -->
							    <!--  <span>+</span> -->
								<ul class="rdofl">
									<li><input type="radio" id="companyCons1" name="companyCons" value="companyCons"/> <label for="companyCons1"><spring:message code="lbl.companyCons" /></label></li>
									<li><input type="radio" id="companyCons2" name="companyCons" value="company" checked="checked"/> <label for="companyCons2"><spring:message code="lbl.company2" /> </label></li>
									<li><input type="radio" id="trend5_weekMonth_type1" name="trend5_weekMonth_type" value="WEEK" checked="checked"/> <label for="trend5_weekMonth_type1"><spring:message code="lbl.weekly" /></label></li>
									<li><input type="radio" id="trend5_weekMonth_type2" name="trend5_weekMonth_type" value="MONTH"/> <label for="trend5_weekMonth_type2"><spring:message code="lbl.month2" /></label></li>
									<li><input type="radio" id="trend5_type1" name="trend5_type" value="COST"> <label for="trend5_type1"><spring:message code="lbl.costChart" /></label></li>
									<li><input type="radio" id="trend5_type2" name="trend5_type" value="PRICE" checked="checked"/><label for="trend5_type2"><spring:message code="lbl.amtChart" /></label></li>
									<li><input type="radio" id="trend5_amt" name="trend5" value="amt" checked="checked"/><label for="trend5_amt"><spring:message code="lbl.amt" /></label></li>
									<li><input type="radio" id="trend5_day" name="trend5" value="day"/><label for="trend5_day"><spring:message code="lbl.days" /></label></li>
								    <li class="manuel">
                                        <a href="#" id="productInventory"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
								</ul>
							</div>
						</div>
						<div style="height: 77%;" id="chart8"></div>
					    <div class="modal" id="productInventoryContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-4"></div>
                           </div>
                        </div>
					</div>
					
					<!-- 출하 준수율 1-->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="shipmentComplianceRateH4"><spring:message code="lbl.salesCmplRateChart2" /> (%)</h4>
							<div class="view_combo"> <!-- class="action" id="shipmentComplianceRateAction" -->
								<!-- <span>+</span> -->
								<ul class="rdofl" > <!-- style="height:130px;" -->
									<li><input type="radio" id="salesInv1" name="salesInv" value="inv" checked="checked"/><label for="salesInv1"><spring:message code="lbl.salesInvY" /></label></li>
									<li><input type="radio" id="salesInv2" name="salesInv" value="noInv"/> <label for="salesInv2"><spring:message code="lbl.salesInvN" /> </label></li>
									<li><input type="radio" id="sales1" name="sales" value="cust"/> <label for="sales1"><spring:message code="lbl.reptCust" /></label></li>
									<li><input type="radio" id="sales2" name="sales" value="total" checked="checked"/> <label for="sales2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="shipmentComplianceRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
								</ul>
							</div>
						</div>
						<div style="height: 88%;width:100%;" id="chart10" ></div>
						<div class="modal" id="shipmentComplianceRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-5"></div>
                           </div>
                        </div>
					</div>
					
					
					
					<!-- 불량률 -->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="defectiveRateSupplyH4"><spring:message code="lbl.defectRateChart" /></h4>
							<div class="view_combo"> <!-- class="action" id="defectiveRateSupplyAction" -->
							    <!--  <span>+</span> -->
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
						<div style="height: 77%" id="chart6" ></div>
						<div class="modal" id="defectiveRateSupplyContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-6"></div>
                           </div>
                        </div>
					</div>
					
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
                               <div id="editor-7"></div>
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
						<div style="height: 100%" id="chart4"></div>
						<div class="modal" id="productionTrendContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-8"></div>
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
						<div style="height: 100%" id="chart9"></div>
						<div class="modal" id="productionPerformanceByMajorItemGroupContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-9"></div>
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
						<div style="height: 100%" id="chart19" ></div>
						<div class="modal" id="stockInWorkContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-10"></div>
                           </div>
                        </div>
					</div>
					
					<!-- 생산 준수율 -->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="productionComplianceRateH4"><spring:message code="lbl.prodCmplRateChart2" /> (%)</h4>
							<div class="view_combo"> <!-- class="action" id="productionComplianceRateAction" -->
							    <!-- <span>+</span> -->
								<ul class="rdofl" > <!-- style="width:115px;" -->
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
						<div style="height: 88%" id="chart13" ></div>
						<div class="modal" id="productionComplianceRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-11"></div>
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
						<div style="height: 100%" id="chart5"></div>
						<div class="modal" id="supplyCapacityIndexContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-12"></div>
                           </div>
                        </div>
					</div>
					
					<!-- 재고 TREND -->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="stockTrendH4"><spring:message code="lbl.prodInvStatusChart2" /> (<spring:message code="lbl.hMillion" />)</h4>
							<div class="view_combo"> <!-- class="action" id="stockTrendAction" -->
							    <!-- <span>+</span> -->
								<ul class="rdofl">
									<li><input type="radio" id="inv_weekMonth_type1" name="inv_weekMonth_type" value="WEEK" checked="checked"> <label for="inv_weekMonth_type1"><spring:message code="lbl.weekly" /></label></li>
									<li><input type="radio" id="inv_weekMonth_type2" name="inv_weekMonth_type" value="MONTH" > <label for="inv_weekMonth_type2"><spring:message code="lbl.month2" /></label></li>
									<li><input type="radio" id="inv_type1" name="inv_type" value="COST" checked="checked"> <label for="inv_type1"><spring:message code="lbl.costChart" /></label></li>
									<li><input type="radio" id="inv_type2" name="inv_type" value="PRICE" > <label for="inv_type2"><spring:message code="lbl.amtChart" /></label></li>
									<li><input type="radio" id="inv1" name="inv" value="item" > <label for="inv1"><spring:message code="lbl.itemType" /></label></li>
									<li><input type="radio" id="inv2" name="inv" value="total" checked="checked"> <label for="inv2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="stockTrend"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
								</ul>
							</div>
						</div>
						<div style="height: 88%" id="chart7"></div>
						<div class="modal" id="stockTrendContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-13"></div>
                           </div>
                        </div>
					</div>
					
					<!-- 자재 가용률 (%)-->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="materialAvailability2H4"><spring:message code="lbl.materialAva2" /></h4>
							<div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="weekMonth1" name="weekMonth" value="week" checked="checked"/><label for="weekMonth1"><spring:message code="lbl.weekly" /></label></li>
									<li><input type="radio" id="weekMonth2" name="weekMonth" value="month"/><label for="weekMonth2"><spring:message code="lbl.month2" /> </label></li>
									<li><input type="radio" id="proTypeTotal1" name="proTypeTotal" value="proType"/><label for="proTypeTotal1"><spring:message code="lbl.type2" /></label></li>
									<li><input type="radio" id="proTypeTotal2" name="proTypeTotal" value="total" checked="checked"/><label for="proTypeTotal2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="materialAvailability2"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%" id="chart17" ></div>
						<div class="modal" id="materialAvailability2Content" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-14"></div>
                           </div>
                        </div>
					</div>
					
					<!-- 주간 입고 준수율 -->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="weeklyGoodsReceiptComplianceRateH4"><spring:message code="lbl.weekReceiveRate" /> (%)</h4>
							<div class="view_combo">
								<ul class="rdofl">
									<li style="text-align: right;color:red;font-size:12px;padding:3px;margin:0;"><spring:message code="lbl.silinder" /></li>
								    <li class="manuel">
	                                        <a href="#" id="weeklyGoodsReceiptComplianceRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                </li>
                                </ul>
							</div>
						</div>
						<div style="height: 100%" id="weekReceiveRateChart" ></div>
						<div class="modal" id="weeklyGoodsReceiptComplianceRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-15"></div>
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
									<div class="scroll">
										
									
									
									</div> <!-- end of scroll div  -->
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
