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
	
	
	#container1 { margin: 0;width: calc(100% - 250px);height: 100%;padding: 0; }
	#cont_chart { width: 100%;height: 100%;}
	
	#cont_chart.full_chart {margin-bottom : 10px;}
	#cont_chart.full_chart .col_12 {width: 100%;}
	#cont_chart .col_12.end {
		min-height:196px;
		height:33.333%; 
		margin: 10px 0 0 0;
	}
	#cont_chart.full_chart .col_12.first { height: calc(100% - 33.333% - 10px); padding: 10px;}
	
	#cont_chart.full_chart .col_12.first .col_12.middle1.a {height: calc(60% - 30px);}
	#cont_chart.full_chart .col_12.first .col_12.middle1.b {height: calc(100% - (60% - 30px) - 30px); width:100%;margin-top:20px;}
	
	#cont_chart .col_12 .graphwrap {height : 100%; width: 70%;}
	#cont_chart .col_12 .col_12_60 .graphwrap {height : 100%;}
	
	#cont_chart .col_12 .textwrap { padding : 10px 0 0 0; }
	#cont_chart .col_12 .textwrap1 { 
		width: 100%; 
		text-align: center;
	    padding: 0% 0% 0px 0px;	
	}
	
	.tablewrap { height: calc(100% - 30px); }
	
	.tablewrap table { height: 100%; }
	
	.tablewrap table tbody th { padding: 10px 0;}
</style>

<script type="text/javascript">
	var typeChart = {
			init : function() {
				//this.comCode.initCode();
				this.initSearch();
				this.events();
			},
			
			_siq	: "dp.salesPerformNew.",
			
			events : function() {
				$("#btnClose").on("click", function(){
					window.close(); 
				});
			},
			
			/*
			comCode : {
				codeMap     : null,
				
				initCode    : function() {
					var grpCd      = 'PTSP_TYPE';
					this.codeMap   = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				}
			},
			*/
			
			bucket : null,
			
			initSearch : function() {
				FORM_SEARCH          = {};
				FORM_SEARCH._mtd     = "getList";
				FORM_SEARCH.fromWeek = "${param.fromWeek}";
				FORM_SEARCH.toWeek   = "${param.toWeek}";
				FORM_SEARCH.grpCd    = "PTSP_TYPE";
				
				FORM_SEARCH.tranData = [
					{ outDs : "week"     , _siq : typeChart._siq + "chartBucket" },
					{ outDs : "ptspType" , _siq : "common.comCode" }
				];
				
				var sMap = {
					url	 : "${ctx}/biz/obj.do",
					data	: FORM_SEARCH,
					success : function(data) {
						
						typeChart.bucket = {};
						typeChart.bucket = data.week;
						
						
						var temp = "";
						
						temp += "<li><input type=\"radio\" id=\"key_all\" name=\"key\" value=\"\" > <label for=\"key_all\">All</label></li>";
						$.each(data.ptspType, function(n, v){
							temp += "<li><input type=\"radio\" id=\"key"+ n +"\" name=\"key\" value=\""+ v.CODE_CD +"\" > <label for=\"key"+ n +"\">"+ v.CODE_NM +"</label></li>";
						});
						$("#radioSelect").html(temp);
						$(':radio[name=key]:input[value="${param.type}"]').attr("checked", true);
						
						$(':radio[name=key]').on('change', function () {
							typeChart.search(false);
						});
						
						$(':radio[name=type1]').on('change', function () {
							typeChart.search(false);
						});
						
						typeChart.search();
					}
				}
				gfn_service(sMap, "obj");
			},
			
			search : function(sqlFlag) {
				var ptspType = $(':radio[name=key]:checked').val();
				var type1    = $(':radio[name=type1]:checked').val();
				
				FORM_SEARCH            = {};
				FORM_SEARCH.bucketList = this.bucket;
				FORM_SEARCH._mtd       = "getList";
				FORM_SEARCH.sql        = sqlFlag;
				FORM_SEARCH.fromWeek   = "${param.fromWeek}";
				FORM_SEARCH.toWeek     = "${param.toWeek}";
				FORM_SEARCH.ptspType   = ptspType;
				FORM_SEARCH.type1      = type1;
				FORM_SEARCH.tranData   = [
					{ outDs : "chart1" , _siq : typeChart._siq + "chart1" },
					{ outDs : "chart2" , _siq : typeChart._siq + "chart2" }
				]; 
				
				var sMap = {
					url	 : "${ctx}/biz/obj.do",
					data	: FORM_SEARCH,
					success : function(data) {
						var list1 = data.chart1;
						var list2 = data.chart2;
						
						typeChart.drawChart(list1);
						typeChart.drawTable(list2);
					}
				};
				gfn_service(sMap,"obj");
			},
			
			drawTable : function(list2) {
				var html     = "";
				var list2Cnt = list2.length;
				
				if(list2Cnt > 0) {
					for(var i=0; i < list2Cnt; i++) {
						html += "<tr>";
						html += "<td>"+list2[i].CUST_LVL2_NM+"</td>";
						html += "<td>"+list2[i].PTSP_TYPE_1_CNT+"</td>";
						html += "<td>"+list2[i].PTSP_TYPE_1_RT+"</td>";
						html += "<td>"+list2[i].PTSP_TYPE_2_CNT+"</td>";
						html += "<td>"+list2[i].PTSP_TYPE_2_RT+"</td>";
						html += "<td>"+list2[i].PTSP_TYPE_3_CNT+"</td>";
						html += "<td>"+list2[i].PTSP_TYPE_3_RT+"</td>";
						html += "<td>"+list2[i].TOTAL+"</td>";
						html += "</tr>";
					}
				} else {
					html += "<tr><td colspan=\"8\"><spring:message code='msg.noDataFound'/></td></tr>";
				}
				
				$("#tableData").html(html);
			},
			
			drawChart : function(list1) {
				//테마적용 공통함수
		    	fn_setHighchartTheme();
				
		    	// cartegory
				var arWeek = new Array();
				
				$.each (typeChart.bucket, function (i, el) {
					arWeek.push(el.DISWEEK);
				});
				
				var defect = JSON.parse(list1[0].STATUS_CHART);
				
				//this.tagetStyle(defect);
				
				this.chartGen('chart0', 'line', arWeek, defect);
			},
			
			chartGen : function (chartId, type, arCarte, arData, isStack) {
				
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
						}
					},
				};
				
				if (!isStack) {
					delete chart.plotOptions.column.stacking;
				}
				
				Highcharts.chart(chartId, chart);
				
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
				enabled : true
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
					dataLabels: { enabled: true },
					enableMouseTracking: true,
					/* marker: { enabled: false }, */
				},
				/* column: {
					stacking: 'normal',
					dataLabels: {
						enabled: true,
					},
				}, */
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
	
	$(document).ready(function() {
		typeChart.init();
	});
</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="popCont">
			<!-- chart -->
			<div id="cont_chart" class="full_chart">
				<div class="col_12 first">
					<!-- 1Depth -->
					<h4><spring:message code='lbl.type2'/>&nbsp;&nbsp;<spring:message code='lbl.trendChart'/></h4>
            		<div class="col_12 middle1 a">
                		<div class="col_12" style="height:300px;">
                			<div class="view_combo" style="margin-left: 500px;">
                				<ul class="rdofl">
                					<li><input type="radio" id="type1_cnt" name="type1" value="cnt" checked="checked"> <label for="type1_cnt"><spring:message code="lbl.cnt"/></label></li>
                					<li><input type="radio" id="type1_rate" name="type1" value="rate" > <label for="type1_rate"><spring:message code="lbl.rate"/></label></li>
                				</ul>
                			</div>
                			<div class="view_combo" style="float: right;">
                				<ul class="rdofl" id="radioSelect">
								</ul>
                			</div>
                			<div style="height: 88%;width:100%" id="chart0" ></div>
                		</div>
                	</div>
                	<!-- 2Depth -->
                	<div class="col_12 middle1 b">
                		<h4><spring:message code="lbl.typeRepCustChart"/></h4>
                		<div class="tablewrap" style="overflow:auto;">
                			<table id="chart2T">
  								<caption><spring:message code="lbl.typeRepCustChart"/></caption>
  								<thead>
							    	<tr>
							    		<th scope="col"><spring:message code="lbl.reptCustGroupName"/></th>
							      		<th scope="col"><spring:message code='lbl.ptspType1'/></th>
								      	<th scope="col">%</th>
								      	<th scope="col"><spring:message code='lbl.ptspType2'/></th>
								      	<th scope="col">%</th>
								      	<th scope="col"><spring:message code='lbl.ptspType3'/></th>
								      	<th scope="col">%</th>
								      	<th scope="col"><spring:message code='lbl.total'/></th>
							    	</tr>
							  	</thead>
							  	<tbody id="tableData">
 			 					</tbody>
							</table>
                		</div>
                	</div>
				</div>
			</div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>