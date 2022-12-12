<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<script type="text/javascript">
  	//전역변수 설정
  	var gridInstance, grdMain, dataProvider;
  	var gridInstance2, grdMain2, dataProvider2;
  	var zTreeObj;
    $(function() {
    	//공통 폼 초기 정보 설정
    	gfn_formLoad();
    	fn_init();
    	fn_initCode(); //공통코드 조회
    	fn_initDate(); //달력
    	fn_initGrid(); //그리드를 그린다.
    	fn_initEvent(); //이벤트 정의
    	
    	//var dt = new Date('2017-12-31');
    	//var weekno = dt.getWeek();
    	//console.log("weekno0000:"+dt.getWeek());

    });
    
    function fn_init() {
    	
    	//tree tab chage --> P : Product, C : Customer, S : Sales Org
    	gfn_treeTabChange("C");
    	
    	//console.log(gfn_getRoleCd()); //권한목록 조회
    	//console.log(gfn_getRoleCd("AP1")); //권한여부 확인
    }

    //공통코드 조회
    function fn_initCode() {
    	var grpCd = "BU_CD,REP_ITEM_GROUP,ITEM_TYPE";
    	codeMap = gfn_getComCode(grpCd); //공통코드 조회
    	
    	codeMap.ITEM_TYPE = $.grep(codeMap.ITEM_TYPE, function(v,n) {
           	return $.inArray(v.CODE_CD,["10","50"]) > -1;
        });
    	
    	codeMapEx = gfn_getComCodeEx(["UPPER_ITEM_GROUP","ITEM_GROUP","ROUTING"], null, {itemType:"10,50"});
    	
    	//var repItemGroupList = gfn_getRepItemGroup("Y");
    	
    	//multi Combo
    	//gfn_setMsCombo("msTest",codeMap.BU_CD,["*"]); //BU //id,data,제외코드
    	
    	//item type 
    	var itemTypeEvent = {
			childId: ["upItemGroup","route"],  
			childData: [codeMapEx.UPPER_ITEM_GROUP,codeMapEx.ROUTING],
			callback: function() {
                gfn_setMsCombo("itemGroup",[],["*"]); //품목그룹 초기화
				gfn_eventChkAllMsCombo("upItemGroup"); //하위오브젝트중 전체체크할 오브젝트 아이디를 파라미터로 던진다.
			}
       	};
    	
    	//품목대그룹
    	var upperItemEvent = {
       		childId: ["itemGroup"],  
			childData: [codeMapEx.ITEM_GROUP],
       	};
    	
    	var msMap = [
    		{target:"divMs"          ,id:"msTest"      ,data: codeMap.BU_CD              ,exData:["*"] ,title:"MultiCombo"},
			{target:"divMs2"         ,id:"msTest2"     ,data: codeMap.BU_CD              ,exData:["*"] ,title:"MultiComboaaaa",type:"S"},
			{target:"divItemType"    ,id:"itemType"    ,data: codeMap.ITEM_TYPE          ,exData:["*"] ,title:"품목유형"  ,option: {allFlag:"Y"} ,event: itemTypeEvent},
			{target:"divUpItemGroup" ,id:"upItemGroup" ,data: codeMapEx.UPPER_ITEM_GROUP ,exData:["*"] ,title:"품목대그룹" ,option: {allFlag:"Y"} ,event: upperItemEvent},
			{target:"divItemGroup"   ,id:"itemGroup"   ,data: codeMapEx.ITEM_GROUP       ,exData:["*"] ,title:"품목그룹"},
			{target:"divRoute"       ,id:"route"       ,data: codeMapEx.ROUTING          ,exData:["*"] ,title:"routing"},
		];
    	gfn_setMsComboAll(msMap);

    	//keywordPopup add Event
    	var keyMap = [
    		{target:"divKeyCode"     ,id:"test1"   ,type:"CODE"         ,title:"Code"},
    	    {target:"divKeyMat"      ,id:"test2"   ,type:"COM_ITEM"     ,title:"Item"},
    	    {target:"divKeyRepMat"   ,id:"test2_1" ,type:"COM_ITEM_REP" ,title:"Rept. Item"},
    	    {target:"divKeyCustomer" ,id:"test6"   ,type:"CUSTOMER"     ,title:"Customer"},
    	    {target:"divKeyEmp"      ,id:"test7"   ,type:"EMP"          ,title:"Emp"},
		];
    	gfn_keyPopAddEvent(keyMap);
    }

    //달력 설정
    function fn_initDate() {
    	//1. 공통 viewhorizon
    	DATEPICKET(null,-14,0); //option,from,to

    	//2. calendar2
    	var dateParam = {
     		arrTarget : [
   				{calId : "fromCal2" ,validType : "from" ,validId : "toCal2"   ,defVal : 0},
   				{calId : "toCal2"   ,validType : "to"   ,validId : "fromCal2" ,defVal : 0},
   			]
     	};
       	DATEPICKET(dateParam);

    	//3. calendar3
    	dateParam = {
     		arrTarget : [
   				{calId : "fromCal3" ,validType : "from" ,validId : "toCal3"   ,defVal : 0},
   				{calId : "toCal3"   ,validType : "to"   ,validId : "fromCal3" ,defVal : 0},
   			]
     	};
       	DATEPICKET(dateParam);

    	//4. searchCal4 - 달력1개, 주차1개
    	dateParam = {
   			arrTarget : [
 				{calId : "searchCal4" ,weekId : "searchWeek4" ,defVal : 0}
   			]
     	};
       	DATEPICKET(dateParam);
       	
       	//1. month picker
        MONTHPICKER("#cal5");
       	
      	//2. month picker
        MONTHPICKER(null,-2,5);
      	
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
    	//그리드 설정  -----------------------------------------------------------------------------------------------
    	gridInstance = new GRID();
    	gridInstance.init("realgrid");
    	grdMain = gridInstance.objGrid;
    	dataProvider = gridInstance.objData;
    	
    	//그리드 옵션 추가 
    	gridInstance.totalFlag = true;
    	//gv_multiTxt = false;

    	//measure icon 처리
    	gridInstance.measureAlign = "far";
    	gridInstance.arrIcon.push("CATEGORY_NM");

    	/*
    	// 헤더 옵션 추가------
    	grdMain.setHeader({
    	    height: 50,                 
    	    heightFill: "fixed"
    	});
    	*/

    	//기본설정외 그리드 추가 설정-------------------
    	grdMain.setEditOptions({
    		editable: true
		});

    	//이미지 등록
   	    var imgs = new RealGridJS.ImageList("images1",GV_CONTEXT_PATH + "/statics/images/common/");
   	    imgs.addUrls([
   	        "bg_red_circle.png",
   	        "bg_orange_circle.png",
   	     	"bg_yellow_circle.png"
   	    ]);
   	 	grdMain.registerImageList(imgs);
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
				gfn_setRowTotalFixed(grdMain);
            }
        }
        gfn_service(sMap, "obj");
    }

    //2. 버켓정보 조회
    function fn_getBucket() {
    	var ajaxMap = {
   			fromDate: gfn_replaceAll($("#fromCal").val(),"-",""),
       		toDate  : gfn_replaceAll($("#toCal").val(),"-",""),
       		//year    : {isDown: "Y", isUp:"N", upCal:"" , isMt:"Y", isExp:"Y", expCnt:1},
       		//half    : {isDown: "Y", isUp:"Y", upCal:"Y", isMt:"Y", isExp:"Y", expCnt:999},
       		//quarter : {isDown: "Y", isUp:"Y", upCal:"H", isMt:"Y", isExp:"Y", expCnt:999},
       		month   : {isDown: "Y", isUp:"N", upCal:"Q", isMt:"N", isExp:"Y", expCnt:1},
       		week    : {isDown: "N", isUp:"Y", upCal:"M", isMt:"Y", isExp:"Y", expCnt:999}, //, isFullNm:"Y"
       		//day     : {isDown: "N", isUp:"Y", upCal:"W", isMt:"Y", isExp:"N", expCnt:999}, //, isFullNm:"Y"
       		//sqlId : ["bucketYear","bucketHalf","bucketQuarter","bucketMonth","bucketWeek"] //["bucketFullWeek"]
       		sqlId : ["bucketMonth","bucketWeek"]
       		//sqlId : ["bucketFullWeek","bucketDay"]
    	}
    	gfn_getBucket(ajaxMap);
    }

    //그리드를 그린다.
    function fn_drawGrid(sqlFlag) {
		if (sqlFlag) return;

    	MEASURE.pre = []; //초기화
    	MEASURE.pre.push({CD:"PLAN_ID",NM:"Plan ID",mergeYn:"Y"});

    	MEASURE.next = []; //초기화
    	MEASURE.next.push({CD:"PLAN_WEEK",NM:"Plan Week",equalBlankYn:"N"});

    	//데이터셋에만 존재하는 컬럼 처리
    	DIMENSION.hidden = [];
    	DIMENSION.hidden.push({CD:"PLAN_WEEK"});

    	//카테고리 처리
		gv_cellDefaultStyles.push({criteria: "values['CATEGORY_CD'] = 'MEASURE1'",styles: "iconIndex=0;numberFormat=00.00"});
		gv_cellDefaultStyles.push({criteria: "values['CATEGORY_CD'] = 'MEASURE2'",styles: "iconIndex=1"});
		gv_cellDefaultStyles.push({criteria: "values['CATEGORY_CD'] = 'MEASURE5'",styles: "iconIndex=2"});

		gv_cellDefaultStyles.push({criteria: "(values['CATEGORY_CD'] <> 'MEASURE1') and (values['CATEGORY_CD'] <> 'MEASURE2') and (values['CATEGORY_CD'] <> 'MEASURE5')",styles: "iconIndex=-1"});

		gridInstance.setDraw();

    }

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
					
						<!-- calendar case 1 -->
						<%//@ include file="/WEB-INF/view/common/filterViewHorizon.jsp" %>
						<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
							<jsp:param name="radioYn" value="Y"/>
							<jsp:param name="wType" value="PW"/>
						</jsp:include>

						<!-- calendar case 2 -->
						<div id="view_Her">
							<strong class="filter_tit">View Horizon2</strong>
							<div class="tlist">
								<div class="tit">date</div>
								<input type="text" id="fromCal2" name="fromCal2" class="iptdate datepicker2" value="2016-08-23"> <span class="ihpen">~</span>
								<input type="text" id="toCal2" name="toCal2" class="iptdate datepicker2" value="2016-08-23">
							</div>
						</div>

						<!-- calendar case 3 -->
						<div class="view_combo">
							<div class="ilist">
								<div class="itit" style="width:59px;">Horizon3</div>
								<input type="text" id="fromCal3" name="fromCal3" class="iptdate datepicker2" value="2016-08-23"> <span class="ihpen">~</span>
								<input type="text" id="toCal3" name="toCal3" class="iptdate datepicker2" value="2016-08-23">
							</div>
						</div>

						<!-- calendar case 4 -->
						<div class="view_combo">
							<div class="ilist">
								<div class="itit">SubTitle1</div>
								<input type="text" id="searchCal4" name="searchCal4" class="iptdate datepicker2" value="2016-08-23">
								<input type="text" id="searchWeek4" name="searchWeek4" class="iptdateweek" disabled="disabled" value="">
							</div>
						</div>
						
						<!-- month date case 1 -->
						<div class="view_combo">
							<div class="ilist">
								<div class="itit">Month</div>
								<input type="text" id="cal5" name="cal5" class="iptdate datepicker2 monthpicker" value="">
							</div>
						</div>
						
						<!-- month date case 1 -->
						<jsp:include page="/WEB-INF/view/common/filterViewHorizonMonth.jsp" flush="false" />
						
						<!-- combo case -->
						<div class="view_combo" id="divMs"></div>
						<div class="view_combo" id="divMs2"></div>
						<div class="view_combo" id="divItemType"></div>
						<div class="view_combo" id="divUpItemGroup"></div>
						<div class="view_combo" id="divItemGroup"></div>
						<div class="view_combo" id="divRoute"></div>
						
						<!-- keyword popup case -->
						<div class="view_combo" id="divKeyCode"></div>
						<div class="view_combo" id="divKeyMat"></div>
						<div class="view_combo" id="divKeyRepMat"></div>
						<div class="view_combo" id="divKeyCustomer"></div>
						<div class="view_combo" id="divKeyEmp"></div>

						<!-- input case -->
						<div class="view_combo">
							<div class="ilist">
								<div class="itit">Input</div>
								<input type="text" id="" name="" class="ipt">
							</div>
						</div>

						<!-- radio box case -->
						<div class="view_combo">
						<strong class="filter_tit">Title (Radio Box)</strong>
						<ul class="rdofl">
							<li><input type="radio" id="radiotitle1" name="radiotitle"> <label for="radiotitle1">Standard Week</label></li>
							<li><input type="radio" id="radiotitle2" name="radiotitle"> <label for="radiotitle2">Partial Week</label></li>
						</ul>
						</div>

						<!-- check box case -->
						<div class="view_combo">
						<strong class="filter_tit">Title (Check Box)</strong>
						<ul class="rdofl">
							<li><input type="checkbox" id="item1" name="item1"> <label for="item1">Item</label></li>
							<li><input type="checkbox" id="line1" name="line1"> <label for="line1">Line</label></li>
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
				<div id="realgrid" class="realgrid1"></div> <!-- class="realgrid1" class="realgrid2" -->
			</div>
			<div class="cbt_btn">
				<div class="bleft">
				<a href="#" class="app">Copy 01</a>
				<a href="#" class="app">Copy 02</a>
				</div>

				<div class="bright">
				<a href="#" class="app1 authClass">Reset</a>
				<a id="btnSave" href="#" class="app2 authClass TEMPLATEMS001">Save</a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
