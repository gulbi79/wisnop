<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">
  	//전역변수 설정
  	var gridInstance, grdMain, dataProvider;
  	var codeMap;
  	var enterSearchFlag = "Y";
    //초기설정
    $(function() {
    	gfn_formLoad(); //공통 폼 초기 정보 설정
    	fn_initCode(); //공통코드 조회
    	fn_initDate(); //달력
    	fn_initGrid(); //그리드를 그린다.
    	fn_initEvent(); //이벤트 정의
    });
    
    //이벤트 정의
    function fn_initEvent() {
    	$("#btnSearch").click("on", function() { fn_apply(); });
    }
    
    //공통코드 조회
    function fn_initCode() {
    	var grpCd = "COMPANY_CD,BU_CD";
    	codeMap = gfn_getComCode(grpCd,"Y"); //공통코드 조회
    	gfn_setMsCombo("SEARCH_BU",codeMap.BU_CD,["ALL"]); //BU //id,data,제외코드
    }
    
  	//달력 설정
    function fn_initDate() {
  		DATEPICKET();
    }
    
    //조회
    function fn_apply(sqlFlag) {
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql = sqlFlag;
    	
    	//메인 데이터를 조회
    	fn_getGridData();
    	fn_getExcelData();
    }
    
	//그리드를 그린다.
    function fn_initGrid() {
    	//변수처리
    	gridInstance = new GRID();
    	gridInstance.init("realgrid");
    	grdMain = gridInstance.objGrid;
    	dataProvider = gridInstance.objData;
    	
        fn_setFields(dataProvider); //set fields
        fn_setColumns(grdMain); // set columns
        fn_setOptions(grdMain); // set options
    }
	
	//provider 필드 설정
    function fn_setFields(provider) {
    	//필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName: "USER_ID"},
            {fieldName: "USER_NM"},
            {fieldName: "DEPT_ID"},
            {fieldName: "DEPT_NM"},
            {fieldName: "COMPANY_CD"},
            {fieldName: "BU_CD"},
            {fieldName: "MENU_CD"},
            {fieldName: "MENU_NM"},
//             {fieldName: "MENU_NM_KR"},
            {fieldName: "URL"},
            {fieldName: "ACCESS_DTTM"},
            {fieldName: "ACCESS_TYPE_CD"},
            {fieldName: "ACCESS_ETC"},
        ];
        dataProvider.setFields(fields); //DataProvider의 setFields함수로 필드를 입력합니다.
    }
    
	//그리드 컬럼설정
    function fn_setColumns(grd) {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = [
            {name: "USER_ID"        ,fieldName: "USER_ID"        ,editable: false ,header: {text: '<spring:message code="lbl.user"/>'        } ,styles: {textAlignment: "near"} ,width: 80},
            {name: "USER_NM"        ,fieldName: "USER_NM"        ,editable: false ,header: {text: '<spring:message code="lbl.userName"/>'    } ,styles: {textAlignment: "near"} ,width: 100},
            {name: "DEPT_NM"        ,fieldName: "DEPT_NM"        ,editable: false ,header: {text: '<spring:message code="lbl.dept"/>'        } ,styles: {textAlignment: "near"} ,width: 100},
            {name: "COMPANY_CD"     ,fieldName: "COMPANY_CD"     ,editable: false ,header: {text: '<spring:message code="lbl.company"/>'     } ,styles: {textAlignment: "near"} ,width: 100,
            	editor: {type: "dropDown",domainOnly: true,}, 
                values: gfn_getArrayExceptInDs(codeMap.COMPANY_CD, "CODE_CD", ""),
                labels: gfn_getArrayExceptInDs(codeMap.COMPANY_CD, "CODE_NM", ""),
                lookupDisplay: true,},
            {name: "BU_CD"          ,fieldName: "BU_CD"          ,editable: false ,header: {text: '<spring:message code="lbl.bu"/>'          } ,styles: {textAlignment: "near"} ,width: 100,
             	editor: {type: "dropDown",domainOnly: true,}, 
                values: gfn_getArrayExceptInDs(codeMap.BU_CD, "CODE_CD", ""),
                labels: gfn_getArrayExceptInDs(codeMap.BU_CD, "CODE_NM", ""),
                lookupDisplay: true,},
            {name: "MENU_NM"        ,fieldName: "MENU_NM"        ,editable: false ,header: {text: '<spring:message code="lbl.menuName"/>'   	} ,styles: {textAlignment: "near"} ,width: 150},
//             {name: "MENU_NM_KR"     ,fieldName: "MENU_NM_KR"     ,editable: false ,header: {text: '<spring:message code="lbl.koreaMenuName"/>' } ,styles: {textAlignment: "near"} ,width: 150},
            {name: "URL"            ,fieldName: "URL"            ,editable: false ,header: {text: '<spring:message code="lbl.url"/>'        	} ,styles: {textAlignment: "near"} ,width: 150},
            {name: "ACCESS_DTTM"    ,fieldName: "ACCESS_DTTM"    ,editable: false ,header: {text: '<spring:message code="lbl.accessDttm"/>' 	} ,styles: {textAlignment: "near"} ,width: 120},
            {name: "ACCESS_ETC"     ,fieldName: "ACCESS_ETC"     ,editable: false ,header: {text: '<spring:message code="lbl.accessEtc"/>'  	} ,styles: {textAlignment: "near"} ,width: 150},
        ];
        grdMain.setColumns(columns); //컬럼을 GridView에 입력 합니다.
    }
	
    //그리드 옵션
    function fn_setOptions(grd) {
    }
    
    //그리드 데이터 조회
    function fn_getGridData() {
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"admin.userLog"}];
    	var sMap = {
            url: "${ctx}/biz/obj",
            data: FORM_SEARCH,
            success:function(data) {
            	dataProvider.clearRows(); //데이터 초기화
            	
		    	//그리드 데이터 생성
		    	grdMain.cancel();
				var grdData = data.rtnList;
				dataProvider.setRows(grdData);
				dataProvider.clearSavePoints();
				dataProvider.savePoint(); //초기화 포인트 저장
				
				gfn_setSearchRow(dataProvider.getRowCount());
            }
        }
        gfn_service(sMap,"obj");
    }
    
	function fn_getExcelData(){
		
		EXCEL_SEARCH_DATA = "";
		EXCEL_SEARCH_DATA += '<spring:message code="lbl.bu"/> : ';
		EXCEL_SEARCH_DATA += $("#SEARCH_BU option:selected").text();
		
		EXCEL_SEARCH_DATA += '\n<spring:message code="lbl.date"/> : ';
		EXCEL_SEARCH_DATA += $("#fromCal").val() + " ~ " + $("#toCal").val();
		
		EXCEL_SEARCH_DATA += '\n<spring:message code="lbl.user"/> : ';
		EXCEL_SEARCH_DATA += $("#SEARCH_USER_ID").val();
		
		EXCEL_SEARCH_DATA += '\n<spring:message code="lbl.menu"/> : ';
		EXCEL_SEARCH_DATA += $("#SEARCH_MENU_ID").val();
		
	}
    </script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	
	<!-- contents -->
	<div id="grid1" class="fconbox">
		<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
		<!-- 조회조건 -->
		<div class="srhwrap">
			<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
			<div class="srhcondi">
				<ul>
					<li>
					<strong><spring:message code="lbl.bu"/></strong>
					<div class="selectBox">
						<select id="SEARCH_BU" name="SEARCH_BU"></select>
					</div>
					</li>
					<li>
					<strong><spring:message code="lbl.date"/></strong>
					<input type="text" id="fromCal" name="SEARCH_FROM_CAL" class="iptdate datepicker1" maxLength="10"> <span class="ihpen">~</span>
					<input type="text" id="toCal" name="SEARCH_TO_CAL" class="iptdate datepicker2"  maxLength="10">
					</li>
					<li>
					<strong><spring:message code="lbl.user"/></strong>
					<input type="text" id="SEARCH_USER_ID" name="SEARCH_USER_ID" class="ipt">
					</li>
					<li>
					<strong><spring:message code="lbl.menu"/></strong>
					<input type="text" id="SEARCH_MENU_ID" name="SEARCH_MENU_ID" class="ipt">
					</li>
				</ul>
			</div>
			</form>

			<div class="bt_btn">
				<a id="btnSearch" href="#" class="fl_app"><spring:message code="lbl.search"/></a>
			</div>
		</div>
		
		<div class="scroll">
			<!-- 그리드영역 -->
			<div id="realgrid" class="realgrid1"></div>
		</div>
	</div>
</body>
</html>
