<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>

	<script type="text/javascript">
  	//전역변수 설정
  	var gridInstance, grdMain, dataProvider;
  	var gridInstanceSub, grdSub, dataProviderSub;
  	var enterSearchFlag = "Y";
  	
    //초기설정
    $(function() {
    	gfn_formLoad(); //공통 폼 초기 정보 설정
    	fn_initCode(); //공통코드 조회
    	fn_initGrid(); //그리드를 그린다.
    	fn_initEvent(); //이벤트 정의
    });
    
    function fn_checkClose() {
    	return (gfn_getGrdSaveCount(grdMain) + gfn_getGrdSaveCount(grdSub)) == 0; 
    }
    
    //공통코드 조회
    function fn_initCode() {
    	var grpCd = "BU_CD,COMPANY_CD";
    	codeMap = gfn_getComCode(grpCd); //공통코드 조회
    	gfn_setMsCombo("company",codeMap.COMPANY_CD,["*"]); //COMPANY //id,data,제외코드
    	gfn_setMsCombo("bu",codeMap.BU_CD,["ALL"]); //BU //id,data,제외코드
    }
    
  	//그리드를 그린다.
    function fn_initGrid() {
    	//그리드 1 ------------------------
    	gridInstance = new GRID();
    	gridInstance.init("realgrid");
    	grdMain = gridInstance.objGrid;
    	dataProvider = gridInstance.objData;
    	
        fn_setFields(dataProvider,"R"); //set fields
        fn_setColumns(grdMain,"R"); // set columns
        fn_setOptions(grdMain,"R"); // set options

        //그리드 2 ------------------------
    	gridInstanceSub = new GRID();
    	gridInstanceSub.init("realgridSub");
    	grdSub = gridInstanceSub.objGrid;
    	dataProviderSub = gridInstanceSub.objData;
    	
        fn_setFields(dataProviderSub,"M"); //set fields
        fn_setColumns(grdSub,"M"); // set columns
        fn_setOptions(grdSub,"M"); // set options
        
        //row 상태에따른 컬럼 속성정의
        grdMain.onCurrentRowChanged = function (grid, oldRow, newRow) {
        	var editable = (newRow < 0 || dataProvider.getRowState(newRow) === "created");
       		//grid.setColumnProperty("BU_CD"     ,"editable",editable);
       		grid.setColumnProperty("ROLE_CD"   ,"editable",editable);
        	fn_setMenuChk(); //데이터 체크 처리
       	};
       	
       	//헤더체크
       	grdSub.onColumnCheckedChanged = function (grid, column, checked) {
       		var checkedVal =  checked ? "Y":"N";
       		dataProviderSub.beginUpdate();
        	for (var i=0; i<dataProviderSub.getRowCount(); i++) {
        		dataProviderSub.setValue(i, column.name, checkedVal);
        	}
        	dataProviderSub.endUpdate();
       	};
       	
    }
    
  	//이벤트 정의
    function fn_initEvent() {
    	$("#btnSearch").click("on", function() { fn_apply(); });
    	$("#btnSave").click("on", function() { fn_save(); });
    	$("#btnReset").click(fn_reset);
    	
    	$("#btnAddRole").click(fn_add);
    	$("#btnDelRole").click(fn_del);
    	$("#btnSaveRole").click(fn_saveRole);

    	$("#company,#bu").change("on", function() { fn_apply(); });
    }
    
    //조회
    function fn_apply(sqlFlag) {
    	//조회조건 설정
    	FORM_SEARCH = {}; //초기화
    	FORM_SEARCH.sql = sqlFlag;
    	FORM_SEARCH.SEARCH_COMPANY = $("#company").val();
    	FORM_SEARCH.SEARCH_BU = $("#bu").val();
    	
    	fn_getGridData(); //메인 데이터를 조회
    	fn_getExcelData();
    }
    
	//provider 필드 설정
    function fn_setFields(provider,grdType) {
    	//필드 배열 객체를  생성합니다.
    	var fields;
    	if (grdType == "R") {
	        fields = [
	            {fieldName: "BU_CD"},
	            {fieldName: "ROLE_CD"},
	            {fieldName: "ROLE_NM"},
	            {fieldName: "ROLE_DESC"},
	            {fieldName: "USE_FLAG"}
	        ];
    	} else {
    		fields = [
	            {fieldName: "BU_CD"},
	            {fieldName: "ROLE_CD"},
	            {fieldName: "MENU_CD"},
	            {fieldName: "LEVEL1_CD"},
	            {fieldName: "LEVEL2_CD"},
	            {fieldName: "LEVEL3_CD"},
	            {fieldName: "LEVEL4_CD"},
	            {fieldName: "LEVEL1_NM"},
	            {fieldName: "LEVEL2_NM"},
	            {fieldName: "LEVEL3_NM"},
	            {fieldName: "LEVEL4_NM"},
	            {fieldName: "SEARCH_ACTION"},
	            {fieldName: "SAVE_ACTION"},
	            {fieldName: "SQL_ACTION"},
	            {fieldName: "EXCEL_ACTION"},
	        ];
    	}
        provider.setFields(fields); //DataProvider의 setFields함수로 필드를 입력합니다.
    }
    
	//그리드 컬럼설정
    function fn_setColumns(grd,grdType) {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
    	var columns;
    	if (grdType == "R") {
	        columns = [
				{
				    name: "BU_CD",
				    fieldName: "BU_CD",
				    editable: false,
				    header: {text: '<spring:message code="lbl.bu"/>'},
				    styles: {textAlignment: "near", background : gv_noneEditColor},
				    dynamicStyles: [{
				        criteria: ["state<>'c'","state='c'"],
				        styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor]
				    }],
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
	                name: "ROLE_CD",
	                fieldName: "ROLE_CD",
	                header: {text: '<spring:message code="lbl.role"/>'},
	                styles: {textAlignment: "near"},
	                dynamicStyles: [{
				        criteria: ["state<>'c'","state='c'"],
				        styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor]
				    }],
	                width: 100,
	                editable: false,
	            },
	            {
	            	name: "ROLE_NM",
	                fieldName: "ROLE_NM",
	                header: {text: '<spring:message code="lbl.roleName"/>'},
	                styles: {textAlignment: "near" ,background:gv_editColor},
	                width: 100
	            },
	            {
	            	name: "ROLE_DESC",
	                fieldName: "ROLE_DESC",
	                header: {text: '<spring:message code="lbl.remark"/>'},
	                styles: {textAlignment: "near" ,background:gv_editColor},
	                width: 100
	            }
	        ];
    	} else {
    		columns = [
	            {
	                name: "LEVEL1_NM",
	                fieldName: "LEVEL1_NM",
	                header: {text: '<spring:message code="lbl.level{0}Menu" arguments="1" />'},
	                styles: {textAlignment: "near",background: gv_noneEditColor},
	                width: 120,
	                equalBlank: true,
	                editable: false,
	            },
	            {
	            	name: "LEVEL2_NM",
	                fieldName: "LEVEL2_NM",
	                header: {text: '<spring:message code="lbl.level{0}Menu" arguments="2" />'},
	                styles: {textAlignment: "near",background: gv_noneEditColor},
	                width: 120,
	                equalBlank: true,
	                editable: false,
	            },
	            {
	            	name: "LEVEL3_NM",
	                fieldName: "LEVEL3_NM",
	                header: {text: '<spring:message code="lbl.level{0}Menu" arguments="3" />'},
	                styles: {textAlignment: "near",background: gv_noneEditColor},
	                width: 150,
	                equalBlank: true,
	                editable: false,
	            },
	            {
	            	name: "LEVEL4_NM",
	                fieldName: "LEVEL4_NM",
	                header: {text: '<spring:message code="lbl.level{0}Menu" arguments="4" />'},
	                styles: {textAlignment: "near",background: gv_noneEditColor},
	                width: 150,
	                editable: false,
	            },
	            {
	            	name: "SEARCH_ACTION",
	                fieldName: "SEARCH_ACTION",
	                header: {text: '<spring:message code="lbl.search"/>',checkLocation: "left"},
	                styles: {textAlignment: "near" ,background:gv_editColor},
	                width: 60,
	                editable: false,
	                renderer : gfn_getRenderer("CHECK")
	            },
	            {
	            	name: "SAVE_ACTION",
	                fieldName: "SAVE_ACTION",
	                header: {text: '<spring:message code="lbl.save"/>',checkLocation: "left"},
	                styles: {textAlignment: "near" ,background:gv_editColor},
	                width: 50,
	                editable: false,
	                renderer : gfn_getRenderer("CHECK")
	            },
	            {
	            	name: "SQL_ACTION",
	                fieldName: "SQL_ACTION",
	                header: {text: '<spring:message code="lbl.sql"/>',checkLocation: "left"},
	                styles: {textAlignment: "near" ,background:gv_editColor},
// 	                <c:if test="${sessionScope['GV_DEV_MODE'] eq 'LOCAL'}">
	                width: 50,
// 	                </c:if>
// 	                <c:if test="${sessionScope['GV_DEV_MODE'] ne 'LOCAL'}">
// 	                width: 0,
// 	                </c:if>
	                editable: false,
	                renderer : gfn_getRenderer("CHECK")
	            },
	            {
	            	name: "EXCEL_ACTION",
	                fieldName: "EXCEL_ACTION",
	                header: {text: '<spring:message code="lbl.excel"/>',checkLocation: "left"},
	                styles: {textAlignment: "near" ,background:gv_editColor},
	                width: 50,
	                editable: false,
	                renderer : gfn_getRenderer("CHECK")
	            },
	        ];
    	}
        grd.setColumns(columns); //컬럼을 GridView에 입력 합니다.
    }
	
    //그리드 옵션
    function fn_setOptions(grd,grdType) {
    	var options;
        if (grdType == "R") {
			options = {
   	            checkBar: { visible: true },
   		        stateBar: { visible: true },
   		        edit    : { editable: true}
   	        };
			grd.setOptions(options);
			grd.setSelectOptions({style: "rows"});
        } else {
        	options = {
   	            checkBar: { visible: false },
   		        stateBar: { visible: true },
   		        edit    : { editable: true}
   	        };
        	grd.setOptions(options);
        }
    }
    
    //그리드 데이터 조회
    function fn_getGridData() {
    	FORM_SEARCH._mtd   = "getList";
    	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"admin.roleMng"}];
    	var sMap = {
   			url: "${ctx}/biz/obj.do",
            data: FORM_SEARCH,
            success:function(data) {
            	dataProvider.clearRows(); //데이터 초기화
            	
				//그리드 데이터 생성
		    	grdMain.cancel();
				dataProvider.setRows(data.rtnList);
				
				dataProvider.clearSavePoints();
				dataProvider.savePoint(); //초기화 포인트 저장

				dataProviderSub.clearSavePoints();
				dataProviderSub.savePoint(); //초기화 포인트 저장
				
				gfn_setSearchRow(dataProvider.getRowCount());
            }
        }
        gfn_service(sMap,"obj");
    }
    
    //저장
    function fn_save() {
    	//수정된 그리드 데이터만 가져온다.
		var grdData = gfn_getGrdSavedataAll(grdSub);
    	if (grdData.length == 0) {
    		alert('<spring:message code="msg.noChangeData"/>');  //변경된 데이터가 없습니다.
			return;
    	}
    	
    	confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
    		//저장
    		var FORM_SAVE = {};
    		FORM_SAVE._mtd   = "saveAll";
    		FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"admin.roleMngMenuAction", grdData : grdData, SEARCH_COMPANY_CD : FORM_SEARCH.SEARCH_COMPANY, SEARCH_BU_CD : FORM_SEARCH.SEARCH_BU}];
    		var serviceMap = {
   				url: "${ctx}/biz/obj.do",
                data: FORM_SAVE,
                success:function(data) {
                	alert('<spring:message code="msg.saveOk"/>');
                	fn_setMenuChk(); //데이터 체크 처리
                }
            }
    		gfn_service(serviceMap, "obj");
    	}); 
    }
    
    //행추가
    function fn_add() {
        dataProvider.insertRow(0,{BU_CD: FORM_SEARCH.SEARCH_BU});
    }

    //삭제
    function fn_del() {
    	var rows = grdMain.getCheckedRows();
    	dataProvider.removeRows(rows, false);
    }
    
    //Role 저장
    function fn_saveRole() {
    	//그기드 유효성 검사
    	var arrColumn = ["ROLE_CD","ROLE_NM"];
    	if (!gfn_getValidation(gridInstance,arrColumn)) return;
    	
    	//수정된 그리드 데이터만 가져온다.
		var grdData = gfn_getGrdSavedataAll(grdMain);
    	if (grdData.length == 0) {
    		alert('<spring:message code="msg.noChangeData"/>');  //변경된 데이터가 없습니다.
			return;
    	}
    	
    	confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
    		//저장
    		var FORM_SAVE = {};
    		FORM_SAVE._mtd   = "saveAll";
    		FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"admin.roleMng", grdData : grdData, SEARCH_COMPANY : FORM_SEARCH.SEARCH_COMPANY}];
    		var serviceMap = {
    			url: "${ctx}/biz/obj.do",
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
        fn_setMenuChk(); //데이터 체크 처리
    }
    
    //role에 해당하는 데이터를 체크한다.
    function fn_setMenuChk() {
    	var dIdx = grdMain.getCurrent().dataRow;
    	if (dIdx == -1) {
    		dataProviderSub.clearRows(); //데이터 초기화
    		dataProviderSub.clearSavePoints();
			dataProviderSub.savePoint(); //초기화 포인트 저장
    		return;	
    	}
    	var roleCd = dataProvider.getValue(dIdx,"ROLE_CD");
    	FORM_SEARCH.sql = false;
    	FORM_SEARCH.SEARCH_ROLE_CD = roleCd;
    	FORM_SEARCH._mtd   = "getList";
    	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"admin.roleMngMenu"}];
    	var sMap = {
   			url: "${ctx}/biz/obj.do",
            data: FORM_SEARCH,
            success:function(data) {
				grdSub.cancel();

				//헤더 체크박스 해제
				var proxy = grdSub.columnByName("SEARCH_ACTION");
		        proxy.checked = false;
		        grdSub.setColumn(proxy);
				var proxy = grdSub.columnByName("SAVE_ACTION");
		        proxy.checked = false;
		        grdSub.setColumn(proxy);
				var proxy = grdSub.columnByName("SQL_ACTION");
		        proxy.checked = false;
		        grdSub.setColumn(proxy);
				var proxy = grdSub.columnByName("EXCEL_ACTION");
		        proxy.checked = false;
		        grdSub.setColumn(proxy);
				
		        dataProviderSub.setRows(data.rtnList);
            }
        }
        gfn_service(sMap,"obj");
    }
    
	function fn_getExcelData(){
		
		EXCEL_SEARCH_DATA = "";
		EXCEL_SEARCH_DATA += '<spring:message code="lbl.company"/> : ';
		EXCEL_SEARCH_DATA += $("#company option:selected").text();
		
		EXCEL_SEARCH_DATA += '\n<spring:message code="lbl.bu"/> : ';
		EXCEL_SEARCH_DATA += $("#bu option:selected").text();
		
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
					<strong><spring:message code="lbl.company"/></strong>
					<div class="selectBox">
						<select id="company" name="company"></select>
					</div>
					</li>
					<li>
					<strong><spring:message code="lbl.bu"/></strong>
					<div class="selectBox">
						<select id="bu" name="bu"></select>
					</div>
					</li>
				</ul>
			</div>
			</form>

			<div class="bt_btn">
				<a id="btnSearch" href="#" class="fl_app"><spring:message code="lbl.search"/></a>
			</div>
		</div>
		
		<div class="scroll" style="width:100%">
			<div style="float: left;width:100%;overflow:hidden;">
				<!-- 왼쪽 그리드 -->
				<div style="width:35%;float:left;">
					<div class="use_tit">
						<h3><spring:message code="lbl.role"/></h3>
					</div>
					<div id="realgrid" class="realgrid1" style="width: 100%; float: left;"></div>
					<div class="grid_btn roleWrite">
					<a id="btnAddRole" href="#" onclick="return false;" class="app1"><spring:message code="lbl.add"/></a>
					<a id="btnDelRole" href="#" onclick="return false;" class="app1"><spring:message code="lbl.delete"/></a>
					<a id="btnSaveRole" href="#" onclick="return false;" class="app2"><spring:message code="lbl.save"/></a>
					</div>
				</div>
				
				<!-- 오른쪽 그리드 -->
				<div style="padding-left:10px;width:calc(65% - 15px);float:left;">
					<div class="use_tit">
						<h3><spring:message code="lbl.menu"/></h3>
					</div>
					<div id="realgridSub" class="realgrid1" style="width:100%; float: left;"></div>
					<div class="grid_btn roleWrite">
					<a id="btnReset" href="#" class="app1"><spring:message code="lbl.reset"/></a>
					<a id="btnSave" href="#" class="app2"><spring:message code="lbl.save"/></a>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
