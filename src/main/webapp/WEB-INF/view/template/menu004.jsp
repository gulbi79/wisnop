<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>

	<script type="text/javascript">
  	//전역변수 설정
  	var gridInstance, grdMain, dataProvider;
  	var zTreeObj;
  	var arrBucket;
  	var enterSearchFlag = "Y";
    $(function() {
    	//공통 폼 초기 정보 설정
    	gfn_formLoad();
    	fn_init(); 
    	fn_initCode();
    	fn_initGrid(); //그리드를 그린다.
    	fn_initEvent(); //이벤트 정의
    });
    
    //초기화 함수
    function fn_init() {
    	//달력
    	DATEPICKET(null,-14,-1); //option,from,to
    }
    
	//공통코드 조회
	function fn_initCode() {
		var grpCd = "CS_TYPE";
    	codeMap = gfn_getComCode(grpCd); //공통코드 조회
    	var msMap = [{target:"divMs",id:"rdoTest",title:codeMap.CS_TYPE[0].GROUP_DESC,data:codeMap.CS_TYPE,exData:["*"],type:"R"}];
    	gfn_setMsComboAll(msMap);
    	//gfn_setRadio({target:"divMs",id:"rdoTest",title:codeMap.CS_TYPE[0].GROUP_DESC,data:codeMap.CS_TYPE,exData:["*"]});
	}
    
    //그리드를 그린다.
    function fn_initGrid() {
    	//변수처리
    	gridInstance = new GRID();
    	gridInstance.init("realgrid");
    	grdMain = gridInstance.objGrid;
    	dataProvider = gridInstance.objData;
    	
    	//그리드 옵션처리 --------------------
        dataProvider.setOptions({
        	softDeleting:true //삭제시 상태값만 바꾼다.
        });
    	
    	grdMain.setOptions({
    		stateBar: { visible: true }
        });
    	
    }
    
  	//이벤트 정의
    function fn_initEvent() {
    	$(".fl_app").click("on", function() { fn_apply(); });
    	$("#btnSqlSearch").click("on", function() { fn_apply(true); });
    	$("#btnSave").click("on", function() { fn_save(); });

    	gfn_setMonthSum(gridInstance, true, true, true); //month sum omit0 처리
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
  
  	//2. 버켓정보 조회
    function fn_getBucket() {
    	var ajaxMap = {
   			fromDate: gfn_replaceAll($("#fromCal").val(),"-",""),
       		toDate  : gfn_replaceAll($("#toCal").val(),"-",""),
       		week    : {isDown: "Y", isUp:"N", upCal:"M", isMt:"N", isExp:"N", expCnt:999},
       		sqlId : ["bucketWeek"]
    	}
    	gfn_getBucket(ajaxMap);
    	
    	var subBucket = [{TYPE:"group",CD:"C",NM:"Consignment"},{TYPE:"group",CD:"N",NM:"Normal"},{TYPE:"group",CD:"T",NM:"Total"}];
    	gfn_setCustBucket(subBucket);
    	
    	subBucket = [{CD:"SALES_PLAN",NM:"판매계획"},{CD:"SALES_ACTUAL",NM:"판매실적"},{CD:"SALES_RATE",NM:"준수율"}];
    	gfn_setCustBucket(subBucket);
    }

    //그리드를 그린다.
    function fn_drawGrid(sqlFlag) {
		if (sqlFlag) return;

		gridInstance.setDraw();
    }
    
    //그리드 데이터 조회
    function fn_getGridData(sqlFlag) {
    	
    	FORM_SEARCH._mtd   = "getList";
    	FORM_SEARCH.tranData = [{outDs:"gridList",_siq:"common.temp002"}];
    	var sMap = {
            url: "${ctx}/biz/obj",
            data: FORM_SEARCH,
            success: function(data){
            	//그리드 데이터 생성
				var grdData = data.gridList;
				dataProvider.setRows(grdData); //LocalDataProvider에 원본 데이터를 입력
				gfn_actionMonthSum(gridInstance); //month sum omit0
            }
        }
        gfn_service(sMap, "obj");
    }
    
    </script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<div class="tabMargin"></div>
				<div class="scroll">
					<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
						<jsp:param name="radioYn" value="Y"/>
						<jsp:param name="wType" value="SW"/>
					</jsp:include>
					<div class="view_combo" id="divMs"></div>
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
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
			<div class="cbt_btn">
				<div class="bright">
				<a href="#" class="app1">Reset</a>
				<a href="#" class="app2">Save</a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
