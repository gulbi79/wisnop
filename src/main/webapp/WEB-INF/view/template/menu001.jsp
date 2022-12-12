<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style>
.pdfobject-container { height: 500px;}
.pdfobject { border: 1px solid #666; }
</style>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">
  	//전역변수 설정
  	var gridInstance, grdMain, dataProvider;
  	var gridInstance2, grdMain2, dataProvider2;
  	var zTreeObj;
  	var filterPlan;
    $(function() {
    	
    	//tree filter set 
    	gv_zTreeFilter.P = {lvl: ["L2","L3"]};
    	
    	//공통 폼 초기 정보 설정
    	gfn_formLoad();
    	fn_init();
    	fn_initCode(); //공통코드 조회
    	fn_initDate(); //달력
    	fn_initGrid(); //그리드를 그린다.
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
    	
    	//keywordPopup add Event
    	var keyMap = [{target:"divKeyCode",id:"test1",type:"CODE",title:"Code"}
    	             ,{target:"divKeyMat",id:"test2",type:"COM_ITEM",title:"Item"}
    	             ,{target:"divKeyMat2",id:"test3",type:"COM_ITEM_PLAN",title:"ItemPlan"}
    	             ,{target:"divKeyRepMat",id:"test2_1",type:"COM_ITEM_REP",title:"Rept. Item"}
    	             ,{target:"divKeyPrmMat",id:"test2_2",type:"COM_ITEM_PRM",title:"Prm. Item"}
    	             ,{target:"divKeyMatPlant",id:"test3",type:"ITEM_PLANT",title:"ItemPlant"}
    	             ,{target:"divKeyPlant",id:"test4",type:"PLANT",title:"Plant"}
    	             ,{target:"divKeyAccount",id:"test5",type:"ACCOUNT",title:"Acount"}
    	             ,{target:"divKeyCustomer",id:"test6",type:"CUSTOMER",title:"Customer"}
    	             ,{target:"divKeyEmp",id:"test7",type:"EMP",title:"Emp"}
    	             ];
    	gfn_keyPopAddEvent(keyMap);
    	
    	$('#msTest').multipleSelect('setSelects', ["BD","BM"]);
    	//$('#msTest').multipleSelect('checkAll');
    	//$('#msTest').multipleSelect('uncheckAll');
    }
    
    //달력 설정
    function fn_initDate() {
    	//DATEPICKET(null,-14,0);
    	var pOption = {planTypeCd: "DP_W", cutOffFlag: "Y"};
    	gfn_getPlanId(pOption);
    }
    
    //이벤트 정의
    function fn_initEvent() {
    	$(".fl_app").click("on", function() { fn_apply(); });
    	$("#btnSqlSearch").click("on", function() { fn_apply(true); });
    	$("#btnSave").click("on", function() { fn_save(); });
    	
    	gfn_setMonthSum(gridInstance, false, true, true); //month sum omit0 처리
    }
    
    //그리드를 초기화
    function fn_initGrid() {
    	//그리드 설정  -----------------------------------------------------------------------------------------------
    	gridInstance = new GRID();
    	gridInstance.init("realgrid");
    	grdMain = gridInstance.objGrid;
    	dataProvider = gridInstance.objData;
    	gridInstance.totalFlag = true;
    	gridInstance.measureHFlag = true;
    	gridInstance.custNextBucketFalg = true;

    	grdMain.setHeader({
    	    height: 50,  // 헤더 높이 지정 
    	    heightFill: "fixed"
    	});
    	
    	//기본설정외 그리드 추가 설정-------------------
    	grdMain.setEditOptions({
    		editable: true
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
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
    	
    	//4. 메인 데이터를 조회
    	fn_getGridData();
    }
    
    //그리드 데이터 조회
    function fn_getGridData(sqlFlag) {
    	FORM_SEARCH._mtd   = "getList";
    	FORM_SEARCH.tranData = [{outDs:"gridList",_siq:"common.temp001"}];
    	var sMap = {
    		url: "${ctx}/biz/obj.do",
            data: FORM_SEARCH,
            success:function(data) {
		    	//그리드 데이터 생성
				var grdData = data.gridList;
				dataProvider.setRows(grdData); //LocalDataProvider에 원본 데이터를 입력
				
				gfn_actionMonthSum(gridInstance); //month sum omit0
				//gfn_setSearchRow(grdMain.getItemCount() + " / " +dataProvider.getRowCount());
            }
        }
        gfn_service(sMap, "obj");
    }
    
    //2. 버켓정보 조회
    function fn_getBucket() {
    	
    	//var preBucket  = [{CD: "PW201801", NM: "201801", BUCKET_ID: "PW201801", BUCKET_VAL: "201801", TYPE: "group"}];
    	//var nextBucket = [{CD: "PW201802", NM: "201802", BUCKET_ID: "PW201802", BUCKET_VAL: "201802", TYPE: "group"}];
    	var ajaxMap = {
   			fromDate : $(".datepicker1").val().replace(/-/g, ''),
       		toDate : $(".datepicker2").val().replace(/-/g, ''),
       		year    : {isDown: "Y", isUp:"N", upCal:"" , isMt:"Y", isExp:"Y", expCnt:999},
       		month   : {isDown: "Y", isUp:"Y", upCal:"Y", isMt:"Y", isExp:"N", expCnt:999},
       		//week    : {isDown: "Y", isUp:"N", upCal:"M", isMt:"Y", isExp:"N", expCnt:999, isFullNm:"Y", preBucket : preBucket, nextBucket : nextBucket}, //, isFullNm:"Y"
       		//sqlId : ["bucketYear","bucketHalf","bucketQuarter","bucketMonth","bucketWeek"] //["bucketFullWeek"]
       		sqlId : ["bucketYear","bucketMonth"]
       		//sqlId : ["bucketFullWeek"]
    	}
    	
    	//MEASURE.user.push({CD:"MEAS_TOT",NM:"Meas Total"});
    	
    	gfn_getBucket(ajaxMap,true,fn_test);
    }
    
    function fn_test() {
    	$.each(BUCKET.all[1], function(n,v) {
    		if (v.TOT_TYPE == "MT") {
    			v.TOT_TYPE = "";
    			v.TYPE = "group";
    		}
    	});
    }
    
    //그리드를 그린다.
    function fn_drawGrid(sqlFlag) {
		if (sqlFlag) return;
    	
    	MEASURE.pre = []; //초기화
    	MEASURE.pre.push({CD:"PLAN_ID",NM:"Plan ID"});
    	
    	//데이터셋에만 존재하는 컬럼 처리
    	DIMENSION.hidden = [];
    	DIMENSION.hidden.push({CD:"PLAN_WEEK"});
    	
//    	MEASURE.user = []; //초기화
    	//MEASURE.user.push({CD:"MEAS_TOT",NM:"Meas Total"});
    	
    	gridInstance.setDraw();
    }
    /*
    function fn_setNextFieldsBuket() {
    	//필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName: "DIM_NM"},
            {fieldName: "DIM_NM_KR"},
            {fieldName: "DIM_NM_CN"},
        ];
    	
    	return fields;
    }
    
    function fn_setNextColumnsBuket() {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = [
        	{
                name: "DIM",
                header: {text: '<spring:message code="lbl.dimensionName"/>'},
                width: 300,
                type: "group",
                columns : [{
                	name: "DIM_NM",
                    fieldName: "DIM_NM",
                    header: {text: '<spring:message code="lbl.english"/>'},
                    styles: {textAlignment: "near",background: gv_noneEditColor},
                    dynamicStyles: [gfn_getDynamicStyle(-2)],
                    width: 100,	
                },
                {
                	name: "DIM_NM_KR",
                    fieldName: "DIM_NM_KR",
                    header: {text: '<spring:message code="lbl.korean"/>'},
                    styles: {textAlignment: "near",background: gv_noneEditColor},
                    dynamicStyles: [gfn_getDynamicStyle(-2)],
                    width: 100,	
                },
                {
                	name: "DIM_NM_CN",
                    fieldName: "DIM_NM_CN",
                    header: {text: '<spring:message code="lbl.chinese"/>'},
                    styles: {textAlignment: "near",background: gv_noneEditColor},
                    dynamicStyles: [gfn_getDynamicStyle(-2)],
                    width: 100,	
                }]
            },
        ];
    	
    	return columns;
    }
    */
    
    function fn_save() {
    	var grdData = gfn_getGrdSavedataAll(grdMain);
    }
    
    /*
    function fn_exportGrid(exParam) {
    	var arrField = ["DIM01_NM","DIM02_NM"];
    	exParam.fieldArr = arrField;
    	exParam.fileNm = "test";
    	gfn_exportGrid(exParam);
    }
    */
    
    /*
    function fn_doNumberFormat(maskVal) {
    	var cStyle;
    	$.each(BUCKET.query, function (n,v) {
    		cStyle = grdMain.getColumnProperty(v.BUCKET_ID,"styles");
    		cStyle.numberFormat = maskVal;
    		grdMain.setColumnProperty(v.BUCKET_ID,"styles",cStyle);
    	});
    }
    */
    
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
			<form id="searchForm" name="searchForm">
			<div id="filterDv">
				<div class="inner">
					<h3>Filter</h3>
					
					<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %>
					<div class="tabMargin"></div>
					<div class="scroll">
						<jsp:include page="/WEB-INF/view/common/filterPlanViewHorizon.jsp" flush="false">
							<jsp:param name="radioYn" value="N"/>
							<jsp:param name="wType" value="PW"/>
						</jsp:include>
						
						<div class="view_combo" id="divMs"></div>
						<div class="view_combo" id="divKeyCode"></div>
						<div class="view_combo" id="divKeyMat"></div>
						<div class="view_combo" id="divKeyMat2"></div>
						<div class="view_combo" id="divMs2"></div>
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
			</form>
		</div>
	</div>
	<!-- contents -->
	<div id="b" class="split split-horizontal">
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
			<div class="use_tit">
				<h3>My Opportunities</h3> <h4>- recently created</h4>
			</div>
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" class="realgrid1" style="display:;"></div>
			</div>
			<div class="cbt_btn">
				<div class="bleft">
				<a href="#" id="copy1" class="app">Copy 01</a>
				<a href="#" class="app">Copy 02</a>
				</div>

				<div class="bright">
				<a href="#" class="app1">Reset</a>
				<a id="btnSave" href="#" class="app2">Save</a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
