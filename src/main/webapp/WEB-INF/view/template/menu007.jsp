<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<script type="text/javascript">
  	//전역변수 설정
  	var gridInstance, grdMain, dataProvider;
  	var zTreeObj;
  	$(document).ready(function() {
    	//공통 폼 초기 정보 설정
    	gfn_formLoad();
    	fn_initDate(); //달력
    	//fn_initGrid(); //그리드를 그린다.
    	
    	var title = {
	       text: 'asdfasdfasd'   
		   };
		   var subtitle = {
		        text: 'Source: w3big.com'
		   };
		   var xAxis = {
		       categories: ['一月', '二月', '三月', '四月', '五月', '六月'
		              ,'七月', '八月', '九月', '十月', '十一月', '十二月']
		   };
		   var yAxis = {
		      title: {
		         text: 'Temperature (\xB0C)'
		      },
		      plotLines: [{
		         value: 0,
		         width: 1,
		         color: '#808080'
		      }]
		   };   
		
		   var tooltip = {
		      valueSuffix: '\xB0C'
		   }
		
		   var legend = {
		      layout: 'vertical',
		      align: 'right',
		      verticalAlign: 'middle',
		      borderWidth: 0
		   };
		
		   var series =  [
		      {
		         name: 'Tokyo',
		         data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2,
		            26.5, 23.3, 18.3, 13.9, 9.6]
		      }, 
		      {
		         name: 'New York',
		         data: [-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8,
		            24.1, 20.1, 14.1, 8.6, 2.5]
		      }, 
		      {
		         name: 'Berlin',
		         data: [-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6,
		            17.9, 14.3, 9.0, 3.9, 1.0]
		      }, 
		      {
		         name: 'London',
		         data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 
		            16.6, 14.2, 10.3, 6.6, 4.8]
		      }
		   ];
		
	   var json = {};
	
	   json.title = title;
	   //json.subtitle = subtitle;
	   json.xAxis = xAxis;
	   json.yAxis = yAxis;
	   json.tooltip = tooltip;
	   json.legend = legend;
	   json.series = series;

		$('#chartBar').highcharts(json);
    	    	
    	/* Highcharts.chart('chartBar', {
    	    chart: {
    	        type: 'column'
    	    },
    	    title: {
    	        text: 'Monthly Average Rainfall'
    	    },
    	    subtitle: {
    	        text: 'Source: WorldClimate.com'
    	    },
    	    xAxis: {
    	        categories: [
    	            'Jan',
    	            'Feb',
    	            'Mar',
    	            'Apr',
    	            'May',
    	            'Jun',
    	            'Jul',
    	            'Aug',
    	            'Sep',
    	            'Oct',
    	            'Nov',
    	            'Dec'
    	        ],
    	        crosshair: true
    	    },
    	    yAxis: {
    	        min: 0,
    	        title: {
    	            text: 'Rainfall (mm)'
    	        }
    	    },
    	    tooltip: {
    	        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
    	        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
    	            '<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',
    	        footerFormat: '</table>',
    	        shared: true,
    	        useHTML: true
    	    },
    	    plotOptions: {
    	        column: {
    	            pointPadding: 0.2,
    	            borderWidth: 0
    	        }
    	    },
    	    series: [{
    	        name: 'Tokyo',
    	        data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]

    	    }, {
    	        name: 'New York',
    	        data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]

    	    }, {
    	        name: 'London',
    	        data: [48.9, 38.8, 39.3, 41.4, 47.0, 48.3, 59.0, 59.6, 52.4, 65.2, 59.3, 51.2]

    	    }, {
    	        name: 'Berlin',
    	        data: [42.4, 33.2, 34.5, 39.7, 52.6, 75.5, 57.4, 60.4, 47.6, 39.1, 46.8, 51.1]

    	    }]
    	}); */
    	
    	Highcharts.chart('chartPie', {
    	    chart: {
    	        plotBackgroundColor: null,
    	        plotBorderWidth: null,
    	        plotShadow: false,
    	        type: 'pie'
    	    },
    	    title: {
    	        text: 'Browser market shares January, 2015 to May, 2015'
    	    },
    	    tooltip: {
    	        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    	    },
    	    plotOptions: {
    	        pie: {
    	            allowPointSelect: true,
    	            cursor: 'pointer',
    	            dataLabels: {
    	                enabled: true,
    	                format: '<b>{point.name}</b>: {point.percentage:.1f} %',
    	                style: {
    	                    color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
    	                }
    	            }
    	        }
    	    },
    	    series: [{
    	        name: 'Brands',
    	        colorByPoint: true,
    	        data: [{
    	            name: 'IE',
    	            y: 56.33
    	        }, {
    	            name: 'Chrome',
    	            y: 24.03,
    	            sliced: true,
    	            selected: true
    	        }, {
    	            name: 'Firefox',
    	            y: 10.38
    	        }, {
    	            name: 'Safari',
    	            y: 4.77
    	        }, {
    	            name: 'Opera',
    	            y: 0.91
    	        }, {
    	            name: 'Other',
    	            y: 0.2
    	        }]
    	    }]
    	});
    	
    });
    
    //달력 설정
    function fn_initDate() {
    	DATEPICKET(null,-14,0); //option,from,to
    }
    
    //그리드를 그린다.
    function fn_initGrid() {
    	//변수처리
    	gridInstance = new GRID();
    	gridInstance.init("realgrid");
    	grdMain = gridInstance.objGrid;
    	dataProvider = gridInstance.objData;
    }
  	
    </script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %>
				<div class="tabMargin"></div>
				<div class="scroll">
					<%@ include file="/WEB-INF/view/common/filterViewHorizon.jsp" %>
					<div class="view_combo">
						<div class="ilist">
							<div class="itit">SubTitle</div>
							<div class="iptdv borNone">
								<select class="iptcombo">
									<option value="--">Single Combo</option>
									<option value="01">Single Combo</option>
									<option value="02">Single Combo</option>
									<option value="03">Single Combo</option>
									<option value="04">Single Combo</option>
								</select>
							</div>
						</div>
					</div>
				</div>
				<div class="bt_btn">
					<a href="#" class="fl_app"><spring:message code="lbl.search"/></a>
				</div>
			</div>
		</div>
	</div>
	<!-- contents -->
	<div id="b" class="split split-horizontal">
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
			<div class="use_tit">
				<h3>My Opportunities</h3> <h4>- recently created</h4>
			</div>
			<div class="scroll" style="height: calc(100% - 88px);">
			
				<!-- <div id="realgrid" style="width: 100%;" class="realgrid1"></div> -->
				<div id="chartBar" style="float:left; width: calc(50% - 20px); height: 100%;" ></div>
				<div></div>
				<div id="chartPie" style="float:left; width: calc(50% - 20px); height: 100%;" ></div>
				<!-- 그리드영역 -->
				<!-- <div id="chartBar2" style="width: 100%;" ></div> -->
			
			</div>
			<div class="cbt_btn" style="height: 26px;">
				<div class="bleft">
				<a href="#" class="app">Copy 01</a>
				<a href="#" class="app">Copy 02</a>
				</div>

				<div class="bright">
				<a href="#" class="app1">Reset</a>
				<a href="#" class="app2">Save</a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
