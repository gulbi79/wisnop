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
    	fn_initGrid(); //그리드를 그린다.
    	fn_initEvent(); //이벤트 정의
    });
    
    //이벤트 정의
    function fn_initEvent() {
    	$("#btnSearch").click("on", function() { fn_apply(); });
    	$("#btnSave").click("on", function() { fn_save(); });
    	$("#btnAddChild").click(fn_add);
    	$("#btnDeleteRows").click(fn_del);
    	$("#btnReset").click(fn_reset);
    	
    	//자동조회
    	fn_apply();
    }
    
    //공통코드 조회
    function fn_initCode() {
    	var grpCd = "BOARD_TYPE,COMPANY_CD,BU_CD";
    	codeMap = gfn_getComCode(grpCd,"Y"); //공통코드 조회
    }
    
    //조회
    function fn_apply(sqlFlag) {
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql = sqlFlag;
    	
    	//메인 데이터를 조회
    	fn_getGridData();
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
        
        //row 상태에따른 컬럼 속성정의
        grdMain.onCurrentRowChanged = function (grid, oldRow, newRow) {
       		var editable = (newRow < 0 || dataProvider.getRowState(newRow) === "created");
       		grid.setColumnProperty("DIM_CD"     ,"editable",editable);
       	};
    }
	
	//provider 필드 설정
    function fn_setFields(provider) {
    	//필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName: "BOARD_NO"},
            {fieldName: "BOARD_TYPE"},
            {fieldName: "TITLE"},
            {fieldName: "COMPANY_CD"},
            {fieldName: "BU_CD"},
            {fieldName: "CONTENT"},
            {fieldName: "FILE_NO"},
            {fieldName: "START_DATE"},
            {fieldName: "END_DATE"},
            {fieldName: "USE_FLAG"},
            {fieldName: "CREATE_ID"},
            {fieldName: "CREATE_DTTM"},
            {fieldName: "UPDATE_ID"},
            {fieldName: "UPDATE_DTTM"},
        ];
        dataProvider.setFields(fields); //DataProvider의 setFields함수로 필드를 입력합니다.
    }
    
	//그리드 컬럼설정
    function fn_setColumns(grd) {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
    	var cellDynamicStyles = [{criteria: ["state<>'c'","state='c'"],styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor]}];
        var columns = [
            {name: "BOARD_TYPE"	 ,fieldName: "BOARD_TYPE"  ,editable: true  ,width: 100 ,header: {text: '<spring:message code="lbl.type"/>'	   } ,styles: {textAlignment: "near"   ,background: gv_requiredColor} 
            ,editor: {type: "dropDown",domainOnly: true},values: gfn_getArrayExceptInDs(codeMap.BOARD_TYPE, "CODE_CD", ""),labels: gfn_getArrayExceptInDs(codeMap.BOARD_TYPE, "CODE_NM", ""),lookupDisplay: true,nanText : ""},
            {name: "TITLE"	     ,fieldName: "TITLE"  	   ,editable: true  ,width: 200 ,header: {text: '<spring:message code="lbl.title"/>'	   } ,styles: {textAlignment: "near"   ,background: gv_requiredColor}},
            /*
            {name: "COMPANY_CD"	 ,fieldName: "COMPANY_CD"  ,editable: true  ,width: 100 ,header: {text: '<spring:message code="lbl.companyName"/>'} ,styles: {textAlignment: "near"}
            ,editor: {type: "dropDown",domainOnly: true},values: gfn_getArrayInDs(codeMap.COMPANY_CD, "CODE_CD"),labels: gfn_getArrayInDs(codeMap.COMPANY_CD, "CODE_NM"),lookupDisplay: true,nanText : ""},
            {name: "BU_CD"	 	 ,fieldName: "BU_CD"  	   ,editable: true  ,width: 100 ,header: {text: '<spring:message code="lbl.buName"/>'	   } ,styles: {textAlignment: "near"}
            ,editor: {type: "dropDown",domainOnly: true},values: gfn_getArrayInDs(codeMap.BU_CD, "CODE_CD"),labels: gfn_getArrayInDs(codeMap.BU_CD, "CODE_NM"),lookupDisplay: true,nanText : ""},
            */
            {name: "START_DATE"	 ,fieldName: "START_DATE"  ,editable: true  ,width: 100 ,header: {text: '<spring:message code="lbl.startDate"/>'  } ,styles: {textAlignment: "center"   ,background: gv_requiredColor}
            ,editor: {type: "date" ,datetimeFormat: "yyyy-MM-dd"}},
            {name: "END_DATE"	 ,fieldName: "END_DATE"    ,editable: true  ,width: 100 ,header: {text: '<spring:message code="lbl.endDate"/>'    } ,styles: {textAlignment: "center"   ,background: gv_requiredColor}
            ,editor: {type: "date" ,datetimeFormat: "yyyy-MM-dd"}},
            {name: "USE_FLAG"    ,fieldName: "USE_FLAG"    ,editable: false ,width: 100 ,header: {text: '<spring:message code="lbl.useYn"/>'      } ,styles: {textAlignment: "near"}  ,renderer : gfn_getRenderer("CHECK")},
            {name: "CREATE_ID"   ,fieldName: "CREATE_ID"   ,editable: false ,width: 100 ,header: {text: '<spring:message code="lbl.createBy"/>'   } ,styles: {textAlignment: "near"   ,background:gv_noneEditColor}},
            {name: "CREATE_DTTM" ,fieldName: "CREATE_DTTM" ,editable: false ,width: 120 ,header: {text: '<spring:message code="lbl.createDttm"/>' } ,styles: {textAlignment: "center" ,background:gv_noneEditColor}},
            {name: "UPDATE_ID"   ,fieldName: "UPDATE_ID"   ,editable: false ,width: 100 ,header: {text: '<spring:message code="lbl.updateBy"/>'   } ,styles: {textAlignment: "near"   ,background:gv_noneEditColor}},
            {name: "UPDATE_DTTM" ,fieldName: "UPDATE_DTTM" ,editable: false ,width: 120 ,header: {text: '<spring:message code="lbl.updateDttm"/>' } ,styles: {textAlignment: "center" ,background:gv_noneEditColor}},
        ];
        grdMain.setColumns(columns); //컬럼을 GridView에 입력 합니다.
    }
	
    //그리드 옵션
    function fn_setOptions(grd) {
        grd.setOptions({
            checkBar: { visible: true },
	        stateBar: { visible: true },
	        edit    : { insertable: true, appendable: true, updatable: true, editable: true, deletable: true},
	        //hideDeletedRows : true
        });
        
        dataProvider.setOptions({
        	softDeleting:true //삭제시 상태값만 바꾼다.
        });
    }
    
    //행추가
    function fn_add() {
    	grdMain.commit();
        var setCols = {USE_FLAG:"Y"}
        dataProvider.insertRow(0,setCols);
    }

    //삭제
    function fn_del() {
    	var rows = grdMain.getCheckedRows();
    	dataProvider.removeRows(rows, false);
    }
    
    //그리드 데이터 조회
    function fn_getGridData() {
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"admin.boardMng"}];
    	var sMap = {
    		url: "${ctx}/biz/obj",
            data: FORM_SEARCH,
            success:function(data) {
		    	//그리드 데이터 생성
		    	grdMain.cancel();
				var grdData = data.rtnList;
				dataProvider.setRows(grdData);
				dataProvider.clearSavePoints();
				dataProvider.savePoint(); //초기화 포인트 저장
				gfn_setSearchRow(dataProvider.getRowCount());
            }
        }
        gfn_service(sMap);
    }
    
    //저장
    function fn_save() {
    	//그기드 유효성 검사
    	var arrColumn = ["BOARD_TYPE","TITLE","START_DATE","END_DATE"];
    	if (!gfn_getValidation(gridInstance,arrColumn)) return;
    	
    	//수정된 그리드 데이터만 가져온다.
		var grdData = gfn_getGrdSavedataAll(grdMain);
    	if (grdData.length == 0) {
    		alert('<spring:message code="msg.noChangeData"/>');  //변경된 데이터가 없습니다.
			return;
    	}
    	
    	confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
    		//저장
    		FORM_SAVE = {}; //초기화
    		FORM_SAVE._mtd   = "saveAll";
    		FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"admin.boardMng", grdData : grdData}];
    		var serviceMap = {
   				url: "${ctx}/biz/obj",
   	            data: FORM_SAVE,
                success:function(data) {
                	alert('<spring:message code="msg.saveOk"/>');
                	fn_apply();
                }
            }
    		gfn_service(serviceMap, "obj");
    	});
    }
    
    //그리드 초기화
    function fn_reset() {
    	grdMain.cancel();
        dataProvider.rollback(dataProvider.getSavePoints()[0]);
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
				<strong><spring:message code="lbl.title"/></strong>
				<div class="selectBox">
				<input type="text" id="SEARCH_TITLE" name="SEARCH_TITLE" class="ipt" style="width:400px">
				</div>
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
		<!-- 하단버튼 영역 -->
		<div class="cbt_btn roleWrite">
			<div class="bright">
			<a id="btnReset" href="#" class="app1"><spring:message code="lbl.reset"/></a>
			<a id="btnAddChild" href="#" class="app1"><spring:message code="lbl.add"/></a>
			<a id="btnDeleteRows" href="#" class="app1"><spring:message code="lbl.delete"/></a>
			<a id="btnSave" href="#" class="app2"><spring:message code="lbl.save"/></a>
			</div>
		</div>
	</div>
</body>
</html>
