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
	
	#cont_chart .col_2 { margin:0; width:calc((100% - 4px) / 2) ; height:calc((100% - 4px) / 3);padding:5px; position:relative;}
	#cont_chart .col_2:nth-child(1) {margin:0 2px 2px 0;}
	#cont_chart .col_2:nth-child(2) {margin:0 2px 2px 0;}
	#cont_chart .col_2:nth-child(3) {margin:0 2px 2px 0;}
	#cont_chart .col_2:nth-child(4) {margin:0 2px 2px 0;}
	#cont_chart .col_2:nth-child(5) {margin:0 2px 0 0;}
	
	
	#cont_chart .col_2 > .titleContainer > h4
	{
		float:left;
	} 
	#cont_chart .col_2 > .titleContainer > div
	{	
		float:right;
	}
	
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
		font-size: 11px;
		font-weight:bold;
	}
	
	#cont_chart .col_2 > .modal
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
    
    #cont_chart .col_2 > .modal_header
    {
        height:25px;
        
    }
    
    #cont_chart .col_2 > .modal_content
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
	var unit = 0;
	var purchase = {

		init : function () {
			var userLang = "${sessionScope.GV_LANG}";
			
			if(userLang == "ko"){
	    		unit = 100000000;
	    	}else if(userLang == "en" || userLang == "cn"){
	    		unit = 1000000000;
	    	}
			
			gfn_formLoad();
			fn_siteMap();
			
			fn_quilljsInit();
	        
			
			//this.initSearch();
			this.events();
			this.search();
		},
	
		_siq	: "dashboard.purchase.",
		
		events : function () {
			
			$(':radio[name=priceCost]').on('change', function () {
				purchase.priceCostSearch(false);
			});
			
			$(':radio[name=monthFlag]').on('change', function () {
				purchase.invAgingSearch(false);
			});
			
			$(':radio[name=invPsiFlag]').on('change', function () {
				purchase.invPsiSearch(false);
			});
			
		
			
			// 타이틀 클릭시 메뉴 이동
			var arrTitle = $("h4");
	    	
			$.each(arrTitle, function(n, v) {
	    		$(v).css("cursor", "pointer");
	    		$(v).on("click", function() { 
	    			if (n == 0) gfn_newTab("SNOP205");
	    			else if (n == 1) gfn_newTab("MP210");
	    			else if (n == 2) gfn_newTab("SNOP206");
	    			else if (n == 3) gfn_newTab("MP209");
	    			else if (n == 4) gfn_newTab("APS317");
	    			else if (n == 5) gfn_newTab("SNOP305");
	    		});
	    	});
			
			
			 $(".manuel > a").dblclick("on", function() {
				
				 var chartId  = this.id;
		            
		            fn_popUpAuthorityHasOrNot();
		            
		            var isSCMTeam = SCM_SEARCH.isSCMTeam;
		            
		            if(isSCMTeam>=1)
		            {
		            	//재고현황
		            	if(chartId == "inventoryStatus")
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
		            	//납기준수율(수량)
		            	else if(chartId == "deliveryBasedYield")
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
		            	//재고 Aging 현황
		            	else if(chartId == "stockAging")
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
		            	//입고 준수율(수량)
		            	else if(chartId == "goodsReceiptComplianceRate")
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
		            	//자재 PSI
		            	else if(chartId == "materialPSI")
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
		            	else if(chartId == "materialAvailability")
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
		           
				//재고현황
                 if(chartId == "inventoryStatus")
                 {
                	 $('#priceCostChart').toggle();
                	 $('#inventoryStatusContent').toggle();
                 }
                 //납기준수율(수량)
                 else if(chartId == "deliveryBasedYield")
                 {
                     $('#deliveryBasedYieldTable').toggle();
                     $('#deliveryBasedYieldContent').toggle();
                 }
                 //재고 Aging 현황
                 else if(chartId == "stockAging")
                 {
                     $('#invAgingChart').toggle();
                     $('#stockAgingContent').toggle();
                 }
                 //입고 준수율(수량)
                 else if(chartId == "goodsReceiptComplianceRate")
                 {
                     $('#goodsReceiptComplianceRateTable').toggle();
                     $('#goodsReceiptComplianceRateContent').toggle();
                 }
                 //자재 PSI
                 else if(chartId == "materialPSI")
                 {
                     $('#materialPSITable').toggle();
                     $('#materialPSIContent').toggle();
                 }
                 //자재 가용률
                 else if(chartId == "materialAvailability")
                 {
                     $('#materialAvailabilityTable').toggle();
                     $('#materialAvailabilityContent').toggle();
                 }
			 });
			 
			 
			    $(".titleContainer > h4").hover(function() {
		            
		            var chartId  = this.id;
		           
		          //재고현황
	                 if(chartId == "inventoryStatusH4")
	                 {
	                     $('#priceCostChart').toggle();
	                     $('#inventoryStatusContent').toggle();
	                 }
	                 //납기준수율(수량)
	                 else if(chartId == "deliveryBasedYieldH4")
	                 {
	                     $('#deliveryBasedYieldTable').toggle();
	                     $('#deliveryBasedYieldContent').toggle();
	                 }
	                 //재고 Aging 현황
	                 else if(chartId == "stockAgingH4")
	                 {
	                     $('#invAgingChart').toggle();
	                     $('#stockAgingContent').toggle();
	                 }
	                 //입고 준수율(수량)
	                 else if(chartId == "goodsReceiptComplianceRateH4")
	                 {
	                     $('#goodsReceiptComplianceRateTable').toggle();
	                     $('#goodsReceiptComplianceRateContent').toggle();
	                 }
	                 //자재 PSI
	                 else if(chartId == "materialPSIH4")
	                 {
	                     $('#materialPSITable').toggle();
	                     $('#materialPSIContent').toggle();
	                 }
	                 //자재 가용률
	                 else if(chartId == "materialAvailabilityH4")
	                 {
	                     $('#materialAvailabilityTable').toggle();
	                     $('#materialAvailabilityContent').toggle();
	                 }
		            
			    });
			 
			 
			
		},
		
		bucket : null,
		
		search : function (sqlFlag) {
			
			FORM_SEARCH            = {};
			FORM_SEARCH.priceCost  = $(':radio[name=priceCost]:checked').val();
			FORM_SEARCH.monthFlag  = $(':radio[name=monthFlag]:checked').val();
			FORM_SEARCH.invPsiFlag  = $(':radio[name=invPsiFlag]:checked').val();
			FORM_SEARCH.materialAvaRateFlag  = 'ava';
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			
			FORM_SEARCH.tranData   = [
				{ outDs : "priceCostChart" , _siq : purchase._siq + "priceCostChart" },
				{ outDs : "invAgingChart" , _siq : purchase._siq + "invAgingChart" },
				{ outDs : "invPsiChart" , _siq : purchase._siq + "invPsiChart" },
				{ outDs : "dueRateChart" , _siq : purchase._siq + "dueRateChart" },
				{ outDs : "warehousRateChart" , _siq : purchase._siq + "warehousRateChart" },
				{ outDs : "materialAvaRateChart" , _siq : purchase._siq + "materialAvaRateChart" },
				{ outDs : "weekList" , _siq : purchase._siq + "weekList" },
				{ outDs : "weekDay" , _siq : purchase._siq + "weekDay" },
				{ outDs : "chartList" , _siq : "dashboard.chartInfo.purchase" }
				
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					purchase.drawPriceCostChart(data.priceCostChart);
					purchase.drawInvAgingChart(data.invAgingChart);
					purchase.drawInvPsiChart(data.invPsiChart);
					purchase.drawDueRateChart(data.dueRateChart, data.weekList, data.weekDay);
					purchase.drawWarehousRateChart(data.warehousRateChart, data.weekList, data.weekDay);
					purchase.drawMaterialAvaRateChart(data.materialAvaRateChart, data.weekList);
					FORM_SEARCH.chartList = data.chartList;
					fn_chartContentInit();
					
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
				{ outDs : "priceCostChart" , _siq : purchase._siq + "priceCostChart" }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					purchase.drawPriceCostChart(data.priceCostChart);
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
				{ outDs : "invAgingChart" , _siq : purchase._siq + "invAgingChart" }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					purchase.drawInvAgingChart(data.invAgingChart);
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
				{ outDs : "invPsiChart" , _siq : purchase._siq + "invPsiChart" }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					purchase.drawInvPsiChart(data.invPsiChart);
				}
			};
			gfn_service(sMap,"obj");
		},
		
		
		drawInvPsiChart : function(data){
			
			var drawTmp = "<tr><td rowspan=\"2\" style=\"background-color: #bbdefb;width: 28%;text-align: center; \"><spring:message code='lbl.divisionChart' /></td>";
			drawTmp += "<td colspan=\"4\" style=\"background-color: #bbdefb;width: 72%;text-align: center; \"><spring:message code='lbl.weekly' /></td><td colspan=\"4\" style=\"background-color: #bbdefb;width: 72%;text-align: center; \"><spring:message code='lbl.month2' /></td></tr>";
			drawTmp += "<tr><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \">W + 1</td>";
			drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \">W + 2</td>";
			drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \">W + 3</td>";
			drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \">W + 4</td>";
			drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \">M0</td>";
			drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \">M + 1</td>";
			drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \">M + 2</td>";
			drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \">M + 3</td></tr>";
			drawTmp += "</tr>"
			
			var line1_4;
			var line2_5;
			var line3_6;
			// DB 1,4 ROW(0,3)
			// DB 2,5 ROW(1,4)
			// DB 3,6 ROW(2,5) 데이터가 테이블 차트 데이트 에서 각 라인을 구성해야 함
			for(i=0;i<data.length;i++)	
			{
				var measNm_i = data[i].MEAS_NM;
				var oneData_i = gfn_nvl(data[i].ONE_DATA, 0);
				var twoData_i = gfn_nvl(data[i].TWO_DATA, 0);
				var threeData_i = gfn_nvl(data[i].THREE_DATA, 0);
				var fourData_i = gfn_nvl(data[i].FOUR_DATA, 0);
				
				for(j=0;j<data.length;j++)
				{	
					var measNm_j = data[j].MEAS_NM;
					var oneData_j = gfn_nvl(data[j].ONE_DATA, 0);
					var twoData_j = gfn_nvl(data[j].TWO_DATA, 0);
					var threeData_j = gfn_nvl(data[j].THREE_DATA, 0);
					var fourData_j = gfn_nvl(data[j].FOUR_DATA, 0);
					
					
					// DB 1,4 ROW(0,3)
					if(i == 0 && j==3)
					{ 
						line1_4 += "<tr><td style=\"background-color: #bbdefb;text-align: center; \">"+ measNm_i +"</td>";
						line1_4 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ oneData_i +"</td>";
						line1_4 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ twoData_i +"</td>";
						line1_4 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ threeData_i +"</td>";
						line1_4 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ fourData_i +"</td>"; 
						line1_4 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ oneData_j +"</td>";
						line1_4 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ twoData_j +"</td>";
						line1_4 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ threeData_j +"</td>";
						line1_4 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ fourData_j +"</td></tr>";
					}
					// DB 2,5 ROW(1,4)
					else if(i == 1 && j==4)
					{ 
						line2_5 += "<tr><td style=\"background-color: #bbdefb;text-align: center; \">"+ measNm_i +"</td>";
						line2_5 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ oneData_i +"</td>";
						line2_5 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ twoData_i +"</td>";
						line2_5 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ threeData_i +"</td>";
						line2_5 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ fourData_i +"</td>"; 
						line2_5 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ oneData_j +"</td>";
						line2_5 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ twoData_j +"</td>";
						line2_5 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ threeData_j +"</td>";
						line2_5 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ fourData_j +"</td></tr>";
					}
					// DB 3,6 ROW(2,5)
					else if(i == 2 && j==5)
					{ 
						line3_6 += "<tr><td style=\"background-color: #bbdefb;text-align: center; \">"+ measNm_i +"</td>";
						line3_6 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ oneData_i +"</td>";
						line3_6 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ twoData_i +"</td>";
						line3_6 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ threeData_i +"</td>";
						line3_6 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ fourData_i +"</td>"; 
						line3_6 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ oneData_j +"</td>";
						line3_6 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ twoData_j +"</td>";
						line3_6 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ threeData_j +"</td>";
						line3_6 += "<td onclick=\"invPsiPopup()\" style=\"cursor:pointer;font-size:13px;\">"+ fourData_j +"</td></tr>";
					}
					
				}
			}
			$("#invPsiChart").html(drawTmp + line1_4 + line2_5 + line3_6);
		},
		
		drawDueRateChart : function(data, weekData, weekDay){
			
			var firstWeek = weekData[0].FIRST_WEEK;
			var secondWeek = weekData[0].SECOND_WEEK;
			var weekDay = weekDay[0].WEEK_DAY;
			var weekDayArr = weekDay.split('/');
			var WEEKDAY = weekDayArr[1]+'월' +weekDayArr[2]+'일';
			
			var drawTmp = "<tr><td rowspan=\"2\" style=\"background-color: #bbdefb;width: 9%;text-align: center; \"></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \">"+ firstWeek +"</td><td colspan=\"3\" style=\"background-color: #bbdefb;width: 9%;text-align: center; \">"+WEEKDAY+"</td>";
			drawTmp += "<td colspan=\"6\" style=\"background-color: #bbdefb;width: 9%;text-align: center; \">"+ secondWeek +"</td></tr>";
			drawTmp += "<tr><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dueRate2' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.estimatedDailyDeliveryQuantity' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyDeliveryComplianceAmount' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyDeliveryComplianceRate' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyAccumRecvQty' /></td>";
			drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyAccumDueQty' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyAccumDueRate' /></td>";
			drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.weekRecvQty' /></td>";
			drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.weekRecvResultQty' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.weekProgress' /></td></tr>";
			
			$.each(data, function(i, val){
				
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
				drawTmp += "<td onclick=\"dueRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ lastCompRate +"</td>";
				drawTmp += "<td onclick=\"dueRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+daySchedQty+"</td>";
				drawTmp += "<td onclick=\"dueRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+dayPreRecvQty+"</td>";
				drawTmp += "<td onclick=\"dueRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+dayCompRate+"</td>";
				drawTmp += "<td onclick=\"dueRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ dayAccSchedQty +"</td>";
				drawTmp += "<td onclick=\"dueRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ dayAccPreRecvQty +"</td>";
				drawTmp += "<td onclick=\"dueRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ dayAccCompRate +"</td>";
				drawTmp += "<td onclick=\"dueRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ schedQty +"</td>";
				drawTmp += "<td onclick=\"dueRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ preRecvQty +"</td>";
				drawTmp += "<td onclick=\"dueRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ compRate +"</td>";
				drawTmp += "</tr>";
			});
			
			$("#dueRateChart").html(drawTmp);
		},
		
		drawWarehousRateChart : function(data, weekData, weekDay){
			
			var firstWeek = weekData[0].FIRST_WEEK;
			var secondWeek = weekData[0].SECOND_WEEK;
			var weekDay = weekDay[0].WEEK_DAY;
			var weekDayArr = weekDay.split('/');
			var WEEKDAY = weekDayArr[1]+'월' +weekDayArr[2]+'일';
			
			var drawTmp = "<tr><td rowspan=\"2\" style=\"background-color: #bbdefb;width: 9%;text-align: center; \"></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \">"+ firstWeek +"</td><td colspan=\"3\" style=\"background-color: #bbdefb;width: 9%;text-align: center; \">"+WEEKDAY+"</td>";
			drawTmp += "<td colspan=\"6\" style=\"background-color: #bbdefb;width: 9%;text-align: center; \">"+ secondWeek +"</td></tr>";
			drawTmp += "<tr><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.warehousRate2' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.estimatedDailyStockingQuantity' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyWarehousingComplianceAmount' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyWarehousingComplianceRate' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyAccumShipExpQty' /></td>";
			drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyAccumShipQty' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.dailyAccumShipRate' /></td>";
			drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.weekShipQty' /></td>";
			drawTmp += "<td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.weekShipResultQty' /></td><td style=\"background-color: #bbdefb;width: 9%;text-align: center; \"><spring:message code='lbl.weekProgress' /></td></tr>";
			
			$.each(data, function(i, val){
				
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
				drawTmp += "<td onclick=\"warehousRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ lastCompRate +"</td>";
				drawTmp += "<td onclick=\"warehousRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+daySchedQty +"</td>";
				drawTmp += "<td onclick=\"warehousRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+dayGrQty +"</td>";
				drawTmp += "<td onclick=\"warehousRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ dayCompRate+"</td>";
				drawTmp += "<td onclick=\"warehousRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ dayAccSchedQty +"</td>";
				drawTmp += "<td onclick=\"warehousRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ dayAccGrQty +"</td>";
				drawTmp += "<td onclick=\"warehousRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ dayAccCompRate +"</td>";
				drawTmp += "<td onclick=\"warehousRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ schedQty +"</td>";
				drawTmp += "<td onclick=\"warehousRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ grQty +"</td>";
				drawTmp += "<td onclick=\"warehousRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ compRate +"</td>";
				drawTmp += "</tr>";
			});
			
			$("#warehousRateChart").html(drawTmp);
			
		},
		
		drawMaterialAvaRateChart : function(data, weekData){
			
			var firstWeek = weekData[0].FIRST_WEEK;
			var secondWeek = weekData[0].SECOND_WEEK;
			
			var flag = 'ava';
			var resultLabel = "";
			var resultLabel2 = "";
			
			if(flag == "ava"){//가용률
				resultLabel = "<spring:message code='lbl.availableRate' />";
				resultLabel2 = " <spring:message code='lbl.cnt2' />";
			}else if(flag == "ready"){//준비율
				resultLabel = "<spring:message code='lbl.rrChart' />(%)";
				resultLabel2 = " <spring:message code='lbl.cnt2' />";
			}
			
			var drawTmp = "<tr><td rowspan=\"2\" style=\"background-color: #bbdefb;width: 20%;text-align: center; \"><spring:message code='lbl.procure2' /></td><td rowspan=\"2\" style=\"background-color: #bbdefb;width: 16%;text-align: center; \"><spring:message code='lbl.goal' />(%)</td></td><td style=\"background-color: #bbdefb;width: 12%;text-align: center; \">"+ firstWeek +"</td>";
			drawTmp += "<td colspan=\"3\" style=\"background-color: #bbdefb;width: 16%;text-align: center; \">"+ secondWeek +"</td></tr>";
			drawTmp += "<tr><td style=\"background-color: #bbdefb;width: 16%;text-align: center; \">"+ resultLabel +"</td><td style=\"background-color: #bbdefb;width: 16%;text-align: center; \">"+ resultLabel +"</td>";
			drawTmp += "<td style=\"background-color: #bbdefb;width: 16%;text-align: center; \"><spring:message code='lbl.preparation' />"+ resultLabel2 +"</td><td style=\"background-color: #bbdefb;width: 16%;text-align: center; \"><spring:message code='lbl.unprepared' />"+ resultLabel2 +"</td></tr>";
			
			$.each(data, function(i, val){
				
				var gubun = val.GUBUN;
				var targetValue = val.TARGET_VALUE
				var lastWeekRate = val.LAST_WEEK_RATE
				var curWeekRate = gfn_addCommas(val.CUR_WEEK_RATE);
				var prepQty = gfn_addCommas(val.PREP_QTY);
				var noPrepQty = gfn_addCommas(val.NO_PREP_QTY);
				
				drawTmp += "<tr>";
				drawTmp += "<td style=\"background-color: #bbdefb;text-align: center; \">"+ gubun +"</td>";
				drawTmp += "<td onclick=\"materialAvaRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ targetValue +"</td>";
				drawTmp += "<td onclick=\"materialAvaRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ lastWeekRate +"</td>";
				drawTmp += "<td onclick=\"materialAvaRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ curWeekRate +"</td>";
				drawTmp += "<td onclick=\"materialAvaRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ prepQty +"</td>";
				drawTmp += "<td onclick=\"materialAvaRatePop()\" style=\"cursor:pointer;font-size:13px;\">"+ noPrepQty +"</td>";
				drawTmp += "</tr>";
			});
			
			$("#materialAvaRateChart").html(drawTmp);
			
			
			
			
			
		},
		
		drawInvAgingChart : function(data){
			
			fn_setHighchartTheme();
			
			var chartId = "invAgingChart";
			var xCate = new Array();
			var seriesArr = new Array();
			
			xCate.push('<spring:message code="lbl.yearStart" />');
			xCate.push('<spring:message code="lbl.mm3" />');
			xCate.push('<spring:message code="lbl.mm2" />');
			xCate.push('<spring:message code="lbl.mm1" />');
			
			$.each(data, function(i, val){
				
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
			
			$.each(data, function(i, val){
				
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
			    /* yAxis: {
			    	stackLabels: {
			    		enabled: true,
			    	    style: {
			    	    	fontWeight: 'bold',
			    	        color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
						}
					}
				}, */
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
			$("#" + chartId).css("overflow", "");
		},
		
		drawPriceCostChart : function(data){
			
			fn_setHighchartTheme();
			
			var chartId = "priceCostChart";
			var xCate = new Array();
			var seriesArr = new Array();
			
			xCate.push('<spring:message code="lbl.yearStart" />');
			xCate.push('<spring:message code="lbl.3monthAvg" />');
			xCate.push('<spring:message code="lbl.monthStart" />');
			xCate.push('<spring:message code="lbl.today" />');
			
			$.each(data, function(i, val){
				
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
			    /* yAxis: {
			    	labels : { enabled : true}
				}, */
				
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
			        					title     : "<spring:message code='lbl.inventoryStatus' /> (<spring:message code='lbl.hMillion' />)"
			        				});
				                }
				            }
				        }
				    }
				},
			    series: seriesArr
			});
			$("#" + chartId).css("overflow", "");
		},
		
		drawChart : function (res) {
			
		},
	};
	
	function invPsiPopup(){
		gfn_comPopupOpen("POPUP_PURCHASE_CHART", {
			rootUrl   : "dashboard",
			url       : "popupChartPurchase",
			width     : 1920,
			height    : 1060,
			menuCd    : "SNOP100",
			chartId   : "invPsiChart",
			title     : "<spring:message code='lbl.invPsi' /> (<spring:message code='lbl.hMillion' />)"
		});
	}
	
	function warehousRatePop(){
		gfn_comPopupOpen("POPUP_PURCHASE_CHART", {
			rootUrl   : "dashboard",
			url       : "popupChartPurchase",
			width     : 1920,
			height    : 1060,
			menuCd    : "SNOP100",
			chartId   : "warehousRateChart",
			title     : "<spring:message code='lbl.warehousRate' />"
		});
	}
	
	function materialAvaRatePop(){
		gfn_comPopupOpen("POPUP_PURCHASE_CHART", {
			rootUrl   : "dashboard",
			url       : "popupChartPurchase",
			width     : 1920,
			height    : 1060,
			menuCd    : "SNOP100",
			chartId   : "materialAvaRateChart",
			title     : "<spring:message code='lbl.materialAva' />"
		});
	}
	
	function dueRatePop(){
		gfn_comPopupOpen("POPUP_PURCHASE_CHART", {
			rootUrl   : "dashboard",
			url       : "popupChartPurchase",
			width     : 1920,
			height    : 1060,
			menuCd    : "SNOP100",
			chartId   : "dueRateChart",
			title     : "<spring:message code='lbl.dueRate' />"
		});
	}
	
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
		purchase.search(sqlFlag);
	}
	
	function fn_openPopup(type) {
		
	}
	
 	// onload 
	$(document).ready(function() {
		fn_displaySize_check();
		purchase.init();
		
	});
	
	function fn_displaySize_check(){
		
		$( window ).resize(function() {
	
			var y = screen.height;
			//모니터
			if(y> 900)
			{
				global_Page_FontSize = 15;
			}
			//노트북
			else
			{
				global_Page_FontSize = 10;
			}
		});
		
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

}


function fn_chartContentInit(){
    
    
    /*
     0.   inventoryStatus
	 1.   deliveryBasedYield 
	 2.   stockAging
	 3.   goodsReceiptComplianceRate
	 4.   materialPSI
	 5.   materialAvailability

    */
    
    
    for(i=0;i<6;i++)
    {
        if(FORM_SEARCH.chartList[i].ID=="inventoryStatus")                  FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_1.setContents([{ insert: '\n' }]):quill_1.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
        else if(FORM_SEARCH.chartList[i].ID=="deliveryBasedYield")          FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_2.setContents([{ insert: '\n' }]):quill_2.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
        else if(FORM_SEARCH.chartList[i].ID=="stockAging")                  FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_3.setContents([{ insert: '\n' }]):quill_3.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
        else if(FORM_SEARCH.chartList[i].ID=="goodsReceiptComplianceRate")  FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_4.setContents([{ insert: '\n' }]):quill_4.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
        else if(FORM_SEARCH.chartList[i].ID=="materialPSI")                 FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_5.setContents([{ insert: '\n' }]):quill_5.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
        else if(FORM_SEARCH.chartList[i].ID=="materialAvailability")        FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_6.setContents([{ insert: '\n' }]):quill_6.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
                                    
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
					
					<!-- 재고 현황 -->
					<div class="col_2">
						<div class="titleContainer">			
							<h4 id="inventoryStatusH4"><spring:message code="lbl.inventoryStatus" /> (<spring:message code="lbl.hMillion" />)</h4>
							<div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="priceCost1" name="priceCost" value="price" checked="checked"/> <label for="priceCost1"><spring:message code="lbl.amtChart" /></label></li>
									<li><input type="radio" id="priceCost2" name="priceCost" value="cost"/><label for="priceCost2"><spring:message code="lbl.costChart" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="inventoryStatus"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 98%;clear:both;" id="priceCostChart" ></div>
						<div class="modal" id="inventoryStatusContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-1"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 납기 준수율 -->
					<div class="col_2">
						<div class="titleContainer">
						    <h4 id="deliveryBasedYieldH4"><spring:message code="lbl.dueRate" /></h4>
							<div class="view_combo">
							      <ul class="rdofl">
							          <li style="text-align: right;color:red;font-size:10px;font-weight:bold;padding:3px;margin:0;"><spring:message code="lbl.silinder" /></li>
							          <li class="manuel">
	                                       
	                                        <a href="#" id="deliveryBasedYield"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                  </li>
							      </ul>
							</div>
						</div>
						<table id="deliveryBasedYieldTable">
							<tbody id="dueRateChart">
							</tbody>
						</table>
						<div class="modal" id="deliveryBasedYieldContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-2"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 재고 Aging 현황 -->
					<div class="col_2">
						<div class="titleContainer">
							<h4 id="stockAgingH4"><spring:message code="lbl.invAgaing" /> (<spring:message code="lbl.hMillion" />)</h4>
							<div class="view_combo" >
								<ul class="rdofl">
									<li><input type="radio" id="monthFlag3" name="monthFlag" value="M3" checked="checked"/> <label for="monthFlag3"><spring:message code="lbl.3mMore" /></label></li>
									<li><input type="radio" id="monthFlag6" name="monthFlag" value="M6"/><label for="monthFlag6"><spring:message code="lbl.6mMore" /> </label></li>
									<li><input type="radio" id="monthFlag12" name="monthFlag" value="M12"/><label for="monthFlag12"><spring:message code="lbl.yearOneMore" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="stockAging"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 98%;clear:both;" id="invAgingChart"></div>
						<div class="modal" id="stockAgingContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-3"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 입고 준수율 -->
					<div class="col_2">
						<div class="titleContainer">
							<h4 id="goodsReceiptComplianceRateH4"><spring:message code="lbl.warehousRate" /></h4>
							<div class="view_combo">
							     <ul class="rdofl">
							         <li style="text-align: right;color:red;font-size:10px;font-weight:bold;padding:3px;margin:0;"><spring:message code="lbl.silinder" /></li>
							         <li class="manuel">
                                        <a href="#" id="goodsReceiptComplianceRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
							     </ul>
								<%-- <ul class="rdofl">
									<li><input type="radio" id="priceCost1" name="priceCost" value="price" checked="checked"/> <label for="priceCost1"><spring:message code="lbl.amtChart" /></label></li>
									<li><input type="radio" id="priceCost2" name="priceCost" value="cost"/><label for="priceCost2"><spring:message code="lbl.costChart" /> </label></li>
								</ul> --%>
							</div>
						</div>
						<table id="goodsReceiptComplianceRateTable">
							<tbody id="warehousRateChart">
							</tbody>
						</table>
						<div class="modal" id="goodsReceiptComplianceRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-4"></div>
                           </div>
                       </div>
						
					</div>
					
					<!-- 자재 PSI -->
					<div class="col_2">
						<div class="titleContainer">
							<h4 id="materialPSIH4"><spring:message code="lbl.invPsi" /> (<spring:message code="lbl.hMillion" />)</h4>
							<div class="view_combo" >
								<ul class="rdofl">
									<li><input type="radio" id="invPsiFlag2" name="invPsiFlag" value="osfp"/><label for="invPsiFlag2"><spring:message code="lbl.osfp" /> </label></li>
									<li><input type="radio" id="invPsiFlag3" name="invPsiFlag" value="rawMaterial"/><label for="invPsiFlag3"><spring:message code="lbl.rawMaterial" /> </label></li>
									<li><input type="radio" id="invPsiFlag1" name="invPsiFlag" value="total" checked="checked"/> <label for="invPsiFlag1"><spring:message code="lbl.total" /></label></li>
								    <li class="manuel">
                                        <a href="#" id="materialPSI"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<table id="materialPSITable">
							<tbody id="invPsiChart">
							</tbody>
						</table>
						<div class="modal" id="materialPSIContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-5"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 자재 가용률 -->
					<div class="col_2">
						<div class="titleContainer">
							<h4 id="materialAvailabilityH4"><spring:message code="lbl.materialAva" /></h4>
							<div class="view_combo" style="float: right;">
								 <ul class="rdofl">
								    <li class="manuel">
                                        <a href="#" id="materialAvailability"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								 </ul>
							</div>
						</div>
						<table id="materialAvailabilityTable">
							<tbody id="materialAvaRateChart">
							</tbody>
						</table>
						<div class="modal" id="materialAvailabilityContent" style="display:none;">
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
					<div class="col_2" style="height:100%;width:100%;margin: 0;padding:0">
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
