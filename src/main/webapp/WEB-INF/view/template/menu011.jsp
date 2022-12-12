<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="chartYn" value="Y"/>
</jsp:include>
	<script type="text/javascript">
	//전역변수 설정
  	var gridInstance, grdMain, dataProvider;
  	var zTreeObj;
  	var chartStack, chartPie;
    $(function() {
    	//공통 폼 초기 정보 설정
    	gfn_formLoad();
    	fn_init();
    	fn_initCode(); //공통코드 조회
    	fn_initDate(); //달력
    	fn_initGrid(); //그리드를 그린다.
    	fn_initChart(); //그리드를 그린다.
    	fn_initEvent(); //이벤트 정의
    });
    
    function fn_init() {
    	//console.log(gfn_getRoleCd()); //권한목록 조회
    	//console.log(gfn_getRoleCd("AP1")); //권한여부 확인
    }
    
    //공통코드 조회
    function fn_initCode() {
    	var grpCd = "BU_CD";
    	codeMap = gfn_getComCode(grpCd); //공통코드 조회

    	//multi Combo
    	//gfn_setMsCombo("msTest",codeMap.BU_CD,["*"]); //BU //id,data,제외코드
    	var msMap = [{target:"divMs",id:"msTest",title:"MultiCombo",data:codeMap.BU_CD,exData:["*"]},
    	             {target:"divMs2",id:"msTest2",title:"MultiComboaaaaaaaaaaaaaaaaaa",data:codeMap.BU_CD,exData:["*"]}];
    	gfn_setMsComboAll(msMap);
    }
    
    //달력 설정
    function fn_initDate() {
    	DATEPICKET(null,-14,0); //option,from,to
    }
    
    //이벤트 정의
    function fn_initEvent() {
    	$(".fl_app").click("on", function() { fn_apply(); });
    	$("#btnSqlSearch").click("on", function() { fn_apply(true); });
    	$("#btnSave").click("on", function() { fn_save(); });
    	
    	gfn_setMonthSum(gridInstance, true, true, true); //month sum omit0 처리
    }
    
    //그리드를 초기화
    function fn_initGrid() {
    	GV_ARR_CHART.push({divId:"chartStack"});
    	GV_ARR_CHART.push({divId:"chartPie"});
    	
    	GV_ARR_GRID.push({divId:"hchart"});
    	
    	//그리드 설정  -----------------------------------------------------------------------------------------------
    	gridInstance = new GRID();
    	gridInstance.init("realgrid");
    	grdMain = gridInstance.objGrid;
    	dataProvider = gridInstance.objData;
    	gridInstance.totalFlag = true;
    	gridInstance.custBucketFalg = true;
    	
    	grdMain.setHeader({
    	    height: 50,                 // 헤더 높이 지정 
    	    heightFill: "fixed"
    	});

    	//헤더 클릭 이벤트 ----------------------
    	grdMain.onColumnHeaderClicked = function (grid, column) {
    		gfn_setChildColumnResize(gridInstance, grdMain, column.name);
        }
    	
    }

    //차트 초기화
	function fn_initChart() {
    	
    	//테마적용 공통함수
    	gfn_setHighchartTheme();
    	
		chartStack = Highcharts.chart('chartStack', {
		    chart: {
		        type: 'column'
		    },
		    title: {
		        text: 'Stacked column chart'
		    },
		    xAxis: {
		        categories: ['Apples', 'Oranges', 'Pears', 'Grapes', 'Bananas']
		    },
		    yAxis: {
		        min: 0,
		        title: {
		            text: 'Total fruit consumption'
		        }
		    },
		    tooltip: {
		        pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.percentage:.0f}%)<br/>',
		        shared: true
		    },
		    plotOptions: {
		        column: {
		            stacking: 'percent'
		        }
		    },
		    series: [
	    		{name: 'John' ,data: []}, 
	    		{name: 'Jane' ,data: []}, 
	    		{name: 'Joe'  ,data: []}
	    	]
		});
		
		chartPie = Highcharts.chart('chartPie', {
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
    	    }]
    	    
    	});
    }
   
    //조회
    function fn_apply(sqlFlag) {
    	gfn_getMenuInit(); //1. 디멘전 메저 조회
    	fn_getBucket(); //2. 버켓정보 조회
    	fn_drawGrid(sqlFlag); //3. 그리드를 그린다.
    	
		//멀티콤보 데이터 가져오기
    	//console.log($('#msTest').multipleSelect('getSelects'));
		//console.log($('#msTest').multipleSelect('getSelects', 'text'));
    	
    	//조회조건 설정
    	FORM_SEARCH = {
   			sql : sqlFlag,
       		hrcyFlag : true,
       		dimList : DIMENSION.user,
       		meaList : MEASURE.user,
       		bucketList : BUCKET.query
    	}; //초기화
    	
    	//4. 메인 데이터를 조회
    	fn_getGridData();
    }
    
    //그리드 데이터 조회
    function fn_getGridData(sqlFlag) {
    	FORM_SEARCH._mtd   = "getList";
    	FORM_SEARCH.tranData = [{outDs:"gridList",_siq:"common.temp002"}];
    	var sMap = {
   			url: "${ctx}/biz/obj.do",
            data: FORM_SEARCH,
            success:function(data) {
		    	//그리드 데이터 생성
				var grdData = data.gridList;
				dataProvider.setRows(grdData); //LocalDataProvider에 원본 데이터를 입력
				
				gfn_actionMonthSum(gridInstance); //month sum omit0
				//gfn_setSearchRow(grdMain.getItemCount() + " / " +dataProvider.getRowCount());
				
				fn_setChartData();
            }
        }
        gfn_service(sMap, "obj");
    }
    
  	//차트데이터 생성
    function fn_setChartData() {
    	var chartStackData = [
    		{name: 'John' ,data: [5, 3, 4, 7, 2]}, 
    		{name: 'Jane' ,data: [2, 2, 3, 2, 1]}, 
    		{name: 'Joe'  ,data: [3, 4, 4, 2, 5]}
    	]
  		$.each(chartStackData, function(n,v) {
    		chartStack.series[n].setData(v.data);
  		});
  		
    	var chartPieData = [
    		{name: 'IE'      ,y: 56.33}, 
			{name: 'Chrome'  ,y: 24.03, sliced: true, selected: true}, 
			{name: 'Firefox' ,y: 10.38}, 
			{name: 'Safari'  ,y: 4.77}, 
			{name: 'Opera'   ,y: 0.91}, 
			{name: 'Other'   ,y: 0.2}
		]
		chartPie.series[0].setData(chartPieData);
    }
    
    //2. 버켓정보 조회
    function fn_getBucket() {
    	var ajaxMap = {
   			fromDate : $(".datepicker1").val().replace(/-/g, ''),
       		toDate : $(".datepicker2").val().replace(/-/g, ''),
       		year    : {isDown: "Y", isUp:"N", upCal:"" , isMt:"Y", isExp:"Y", expCnt:1},
       		half    : {isDown: "Y", isUp:"Y", upCal:"Y", isMt:"Y", isExp:"Y", expCnt:999},
       		quarter : {isDown: "Y", isUp:"Y", upCal:"H", isMt:"Y", isExp:"Y", expCnt:999},
       		month   : {isDown: "Y", isUp:"N", upCal:"Q", isMt:"Y", isExp:"Y", expCnt:999},
       		week    : {isDown: "N", isUp:"Y", upCal:"M", isMt:"Y", isExp:"N", expCnt:999}, //, isFullNm:"Y"
       		//sqlId : ["bucketYear","bucketHalf","bucketQuarter","bucketMonth","bucketWeek"] //["bucketFullWeek"]
       		sqlId : ["bucketMonth","bucketWeek"]
       		//sqlId : ["bucketFullWeek"]
    	}
    	gfn_getBucket(ajaxMap); 
    }
    
    //그리드를 그린다.
    function fn_drawGrid(sqlFlag) {
		if (sqlFlag) return;
    	
    	MEASURE.pre = []; //초기화
    	MEASURE.pre.push({CD:"PLAN_ID",NM:"Plan ID"});
    	
    	//데이터셋에만 존재하는 컬럼 처리
    	DIMENSION.hidden = [];
    	DIMENSION.hidden.push({CD:"PLAN_WEEK"});
    	
    	gridInstance.setDraw();
    }
    
    function fn_save() {
    	var grdData = gfn_getGrdSavedataAll(grdMain);
    }
    
    function fn_setFieldsBuket() {
    	//필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName: "BU_CD"},
            {fieldName: "GROUP_CD"},
            {fieldName: "GROUP_DESC"},
            {fieldName: "CODE_CD"},
            {fieldName: "CODE_NM"},
        ];
    	
    	return fields;
    }

    function fn_setColumnsBuket() {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = [
            {
                name: "BU_CD",
                fieldName: "BU_CD",
                editable: true,
                header: {text: '<spring:message code="lbl.buName"/>'},
                styles: {textAlignment: "near", background : gv_noneEditColor, lineAlignment: "near", paddingTop:4},
                dynamicStyles: [gfn_getDynamicStyle(-2)],
                width: 100,
                editor: {
                    type: "dropDown",
                    domainOnly: true,
                }, 
                values: gfn_getArrayExceptInDs(codeMap.BU_CD, "CODE_CD", ""),
                labels: gfn_getArrayExceptInDs(codeMap.BU_CD, "CODE_NM", ""),
                lookupDisplay: true,
                nanText : "",
                editButtonVisibility: "visible",
            },
            {
                name: "GROUP_CD",
                fieldName: "GROUP_CD",
                editable: false,
                header: {text: '<spring:message code="lbl.groupCode"/>'},
                styles: {textAlignment: "near", lineAlignment: "near", paddingTop:4},
                dynamicStyles: [gfn_getDynamicStyle(-2)],
                width: 150,
            },
            {
                name: "GROUP_DESC",
                fieldName: "GROUP_DESC",
                header: {text: '<spring:message code="lbl.groupName"/>'},
                styles: {textAlignment: "near", background:gv_requiredColor, lineAlignment: "near", paddingTop:4},
                dynamicStyles: [gfn_getDynamicStyle(-2)],
                width: 150,
            },
            {
                name: "CODE_CD",
                fieldName: "CODE_CD",
                editable: false,
                header: {text: '<spring:message code="lbl.code"/>'},
                styles: {textAlignment: "near"},
                dynamicStyles: [gfn_getDynamicStyle(-2)],
                width: 100
            },
            {
                name: "CODE_NM",
                fieldName: "CODE_NM",
                header: {text: '<spring:message code="english"/>'},
                styles: {textAlignment: "near",background:gv_requiredColor},
                dynamicStyles: [gfn_getDynamicStyle(-2)],
                width: 150
            },
        ];
    	
    	return columns;
    }
    
    </script>
</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<!-- left -->
	<div id="a" class="split split-horizontal">
		<!-- tree -->
		<div id="c" class="split content">
			<%@ include file="/WEB-INF/view/common/leftTree.jsp" %>
		</div>
		<!-- filter -->
		<div id="d" class="split content">
			<div id="filterDv">
				<div class="inner">
					<h3>Filter</h3>
					
					<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %>
					<div class="tabMargin"></div>
					<div class="scroll">
						<%@ include file="/WEB-INF/view/common/filterViewHorizon.jsp" %>
						
						<div class="view_combo" id="divMs"></div>
						
						<div class="view_combo">
							<div class="ilist">
								<div class="itit" style="width:59px;">SubTitle</div>
								<input type="text" id="" name="" class="iptdate datepicker2" value="2016-08-23"> <span class="ihpen">~</span>
								<input type="text" id="" name="" class="iptdate datepicker2" value="2016-08-23">
							</div> 
						</div>

						<div class="view_combo">
							<strong class="filter_tit">Title (Radio Box)</strong>
							<ul class="rdofl">
								<li><input type="radio" id="radiotitle1" name="radiotitle"> <label for="radiotitle1">Item</label></li>
								<li><input type="radio" id="radiotitle2" name="radiotitle"> <label for="radiotitle2">Line</label></li>
							</ul>
						</div>

						<div class="view_combo">
							<strong class="filter_tit">Title (Check Box)</strong>
							<ul class="rdofl">
								<li><input type="checkbox" id="item2" name="item2"> <label for="item2">Item</label></li>
								<li><input type="checkbox" id="line2" name="line2"> <label for="line2">Line</label></li>
							</ul>
							<ul class="rdofl">
								<li><input type="checkbox" id="item2" name="item2"> <label for="item2">Item</label></li>
								<li><input type="checkbox" id="line2" name="line2"> <label for="line2">Line</label></li>
							</ul>
						</div>
						
					</div>
					<div class="bt_btn">
						<a href="#;return false;" class="fl_app"><spring:message code="lbl.search"/></a>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- contents -->
	<div id="b" class="split split-horizontal">
		<!-- contents 상 -->
		<div id="e" class="split content" style="border:0;background:transparent;">
			<div id="grid1" class="fconbox">
				<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
				<div class="use_tit">
					<h3>Chart</h3> <h4>- recently created</h4>
				</div>
				<div class="scroll">
					<!-- chart -->
					<div id="hchart" class="realgrid1">
						<div id="chartStack" style="float:left; width:calc(50% - 10px)"></div>
						<div id="chartPie" style="float:right; width:calc(50% - 10px)"></div>
					</div>
				</div>
			</div>
		</div>
		<!-- contents 하 -->
		<div id="f" class="split content" style="border:0;background:transparent;">
			<div id="grid2" class="fconbox">
				<div class="use_tit">
					<h3>Grid</h3> <h4>- Next 7 days</h4>
				</div>
				<div class="scroll">
					<!-- 그리드영역 -->
					<div id="realgrid" class="realgrid1"></div>
				</div>
				<div class="cbt_btn">
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
	</div>
</body>
</html>
