<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>

	<script type="text/javascript">
  	//전역변수 설정
  	var gridInstance, grdMain, dataProvider;
  	var gridInstanceSub, grdSub, dataProviderSub;
  	var codeMap,codeMapAll;
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
    	var grpCd = "BU_CD";
    	codeMap = gfn_getComCode(grpCd); //공통코드 조회
    	gfn_setMsCombo("SEARCH_BU",codeMap.BU_CD,["ALL"]); //BU //id,data,제외코드
    	
    	codeMapAll = gfn_getComCode("SALES_TEAM,SALES_AUTH","N","Y"); //공통코드 조회
    }
    
  	//그리드를 그린다.
    function fn_initGrid() {
    	//그리드 1 ------------------------
    	gridInstance = new GRID();
    	gridInstance.init("realgrid");
    	grdMain = gridInstance.objGrid;
    	dataProvider = gridInstance.objData;
    	
        fn_setFields(dataProvider,"M"); //set fields
        fn_setColumns(grdMain,"M"); // set columns
        fn_setOptions(grdMain,"M"); // set options

        //그리드 2 ------------------------
    	gridInstanceSub = new GRID();
    	gridInstanceSub.init("realgridSub");
    	grdSub = gridInstanceSub.objGrid;
    	dataProviderSub = gridInstanceSub.objData;
    	
        fn_setFields(dataProviderSub,"S"); //set fields
        fn_setColumns(grdSub,"S"); // set columns
        fn_setOptions(grdSub,"S"); // set options
        
        //row 상태에따른 컬럼 속성정의
        grdMain.onCurrentRowChanged = function (grid, oldRow, newRow) {
        	var editable = (newRow < 0 || dataProvider.getRowState(newRow) === "created");
       		grid.setColumnProperty("USER_ID" ,"editable",editable);

        	fn_getUserRole(); //데이터 체크 처리
       	};
       	
        //헤더체크
       	grdSub.onColumnCheckedChanged = function (grid, column, checked) {
       		var checkedVal = checked ? "Y":"N";
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
    	
    	$("#btnAddUser").click("on", function() {fn_add();});
    	$("#btnDelUser").click("on", function() {fn_del();});
    	$("#btnSaveUser").click("on", function() {fn_saveUser();});
    	$("#btnPwResetUser").click("on", function() {fn_pwResetUser();});
    	
    	$("#SEARCH_BU").change("on", function() { fn_apply(); });
    	
    	fn_apply(); //자동조회
    }
    
    //조회
    function fn_apply(sqlFlag) {
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject();
    	FORM_SEARCH.sql = sqlFlag;
    	
    	fn_getGridData(); //메인 데이터를 조회
    	fn_getExcelData();
    }
    
	//provider 필드 설정
    function fn_setFields(provider,grdType) {
    	//필드 배열 객체를  생성합니다.
    	var fields;
    	if (grdType == "M") {
	        fields = [
	            {fieldName: "USER_ID"},
	            {fieldName: "USER_NM"},
	            {fieldName: "EMAIL"},
	            {fieldName: "DASHBOARD_YN"},
	        ];
    	} else {
    		fields = [
	            {fieldName: "BU_CD"},
	            {fieldName: "ROLE_CD"},
	            {fieldName: "ROLE_NM"},
	            {fieldName: "USER_ID"},
	            {fieldName: "USE_YN"},
	        ];
    	}
        provider.setFields(fields); //DataProvider의 setFields함수로 필드를 입력합니다.
    }
    
	//그리드 컬럼설정
    function fn_setColumns(grd,grdType) {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
    	var columns;
    	if (grdType == "M") {
	        columns = [
	            {
	                name: "USER_ID",
	                fieldName: "USER_ID",
	                header: {text: '<spring:message code="lbl.userId"/>'},
	                styles: {textAlignment: "near"},
	                dynamicStyles: [{
	                    criteria: ["state<>'c'","state='c'"],
	                    styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor]
	                }],
	                width: 100,
	                editable: false,
	            },
	            {
	            	name: "USER_NM",
	                fieldName: "USER_NM",
	                header: {text: '<spring:message code="lbl.userName"/>'},
	                styles: {textAlignment: "near",background:gv_requiredColor},
	                width: 120
	            },
	            {
	            	name: "EMAIL",
	                fieldName: "EMAIL",
	                header: {text: '<spring:message code="lbl.email"/>'},
	                styles: {textAlignment: "near" ,background:gv_editColor},
	                width: 200
	            },
	            {
	                name: "DASHBOARD_YN",
	                fieldName: "DASHBOARD_YN",
	                lookupDisplay: true,
	                values: ["Y", "N"],
	                labels: ["사용", "미사용"],
	                editor: {
	                    type: "dropDown",
	                    domainOnly: true,
	                }, 
	                header: {text: '<spring:message code="lbl.dashboardYn"/>'},
	                styles: {textAlignment: "center",background:gv_requiredColor},
	                width: 60,
	                editButtonVisibility: "visible",
	            },
	        ];
    	} else {
    		columns = [
				{
				    name: "BU_CD",
				    fieldName: "BU_CD",
				    editable: false,
				    header: {text: '<spring:message code="lbl.bu"/>'},
				    styles: {textAlignment: "near", background : gv_noneEditColor},
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
	                styles: {textAlignment: "near",background: gv_noneEditColor},
	                width: 120,
	                //equalBlank: true,
	                editable: false,
	            },
	            {
	                name: "ROLE_NM",
	                fieldName: "ROLE_NM",
	                header: {text: '<spring:message code="lbl.roleName"/>'},
	                styles: {textAlignment: "near",background: gv_noneEditColor},
	                width: 120,
	                //equalBlank: true,
	                editable: false,
	            },
	            {
	            	name: "USE_YN",
	                fieldName: "USE_YN",
	                //header: {text: '사용',checkLocation: "left"},
	                header: {text: '<spring:message code="lbl.useYn"/>'},
	                styles: {textAlignment: "near" ,background:gv_editColor},
	                width: 60,
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
        if (grdType == "M") {
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
    	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"admin.userMng"}];
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

				gfn_setSearchRow(dataProvider.getRowCount());
            }
        }
        gfn_service(sMap,"obj");
    }
    
    //저장
    function fn_save() {
    	//user 데이터가 수정되어있으면 저장후 처리해야한다.
    	var grdMainData = gfn_getGrdSavedataAll(grdMain);
    	if (grdMainData.length > 0) {
    		alert('<spring:message code="msg.checkBeforeSave" arguments="User"/>');  //변경된 데이터가 없습니다.
			return;
    	}
    	
    	//수정된 그리드 데이터만 가져온다.
		var grdData = gfn_getGrdSavedataAll(grdSub);
    	if (grdData.length == 0) {
    		alert('<spring:message code="msg.noChangeData"/>');  //변경된 데이터가 없습니다.
			return;
    	}
    	
    	confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
    		$.each(grdData, function(n,v) {
    			if (v.USE_YN == "Y") {
    				v.state = "inserted";
    			} else {
    				v.state = "deleted";
    			}
    		});
    		
    		//저장
    		FORM_SAVE = {}; //초기화
    		FORM_SAVE._mtd   = "saveAll";
    		FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"admin.userMngRole", grdData : grdData}];
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
    
    //패스워드 초기화
    function fn_pwResetUser() {
    	//체크 데이터 검사
    	var items = grdMain.getCheckedItems();
   		var grdData = [];
   		var jData;
   		$.each(items, function (n,v) {
   			jData = dataProvider.getJsonRow(v);
   			jData.state = "updated";
   			grdData.push(jData);
   		});
   		
    	if (grdData.length == 0) {
    		alert('<spring:message code="msg.noChangeData"/>');  //변경된 데이터가 없습니다.
			return;
    	}
    	
    	confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
    		//저장
    		FORM_SAVE = {}; //초기화
    		FORM_SAVE._mtd   = "saveUpdate";
    		FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"admin.userMngPwReset", grdData : grdData}];
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
    
    //Role 저장
    function fn_saveUser() {
    	//그기드 유효성 검사
    	var arrColumn = ["USER_ID","USER_NM"];
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
    		FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"admin.userMng", grdData : grdData}];
    		var serviceMap = {
    			url: GV_CONTEXT_PATH + "/biz/obj.do",
    	        data: FORM_SAVE,
                success:function(data) {
                	alert('<spring:message code="msg.saveOk"/>');
                	fn_apply();
                }
            }
    		gfn_service(serviceMap, "obj");
    	});
    }
    
    //user에 해당하는 Role 조회
    function fn_getUserRole() {
    	var dIdx = grdMain.getCurrent().dataRow;
    	if (dIdx == -1) {
    		dataProviderSub.clearRows(); //데이터 초기화
    		dataProviderSub.clearSavePoints();
			dataProviderSub.savePoint(); //초기화 포인트 저장
    		return;	
    	}
    	
    	FORM_SEARCH.sql = false;
    	FORM_SEARCH.SEARCH_USER_ID = dataProvider.getValue(dIdx,"USER_ID");
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"admin.userMngRole"}];
    	var sMap = {
    		url: "${ctx}/biz/obj.do",
            data: FORM_SEARCH,
            success:function(data) {
				grdSub.cancel();
				dataProviderSub.setRows(data.rtnList);
				
				dataProviderSub.clearSavePoints();
				dataProviderSub.savePoint(); //초기화 포인트 저장
            }
        }
        gfn_service(sMap,"obj");
    }
    
    //행추가
    function fn_add() {
        dataProvider.insertRow(0,{});
    }

    //삭제
    function fn_del() {
    	var rows = grdMain.getCheckedRows();
    	dataProvider.removeRows(rows, false);
    }

    //그리드 초기화
    function fn_reset() {
    	grdMain.cancel();
        dataProvider.rollback(dataProvider.getSavePoints()[0]);
    }
    
	function fn_getExcelData(){
		
		EXCEL_SEARCH_DATA = "";
		EXCEL_SEARCH_DATA += '<spring:message code="lbl.bu"/> : ';
		EXCEL_SEARCH_DATA += $("#SEARCH_BU option:selected").text();
		
		EXCEL_SEARCH_DATA += '\n<spring:message code="lbl.user"/> : ';
		EXCEL_SEARCH_DATA += $("#SEARCH_USER_ID").val();
		
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
					<strong><spring:message code="lbl.user"/></strong>
					<div class="selectBox">
					<input type="text" id="SEARCH_USER_ID" name="SEARCH_USER_ID" value="" class="ipt">
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
				<div style="width:49%;float:left;">
					<div class="use_tit">
						<h3><spring:message code="lbl.user"/></h3> <!-- <h4>- recently created</h4> -->
					</div>
					<div id="realgrid" class="realgrid1" style="width: 100%; float: left;"></div>
					<div class="grid_btn roleWrite">
					<a id="btnAddUser" href="#" onclick="return false;" class="app1"><spring:message code="lbl.add"/></a>
					<a id="btnDelUser" href="#" onclick="return false;" class="app1"><spring:message code="lbl.delete"/></a>
					<a id="btnSaveUser" href="#" onclick="return false;" class="app2"><spring:message code="lbl.save"/></a>
					<a id="btnPwResetUser" href="#" onclick="return false;" class="app2"><spring:message code="lbl.passwordClear"/></a>
					</div>
				</div>
				
				<!-- 오른쪽 그리드 -->
				<div style="padding-left:10px;width:calc(51% - 15px);float:left;">
					<div class="use_tit">
						<h3><spring:message code="lbl.role"/></h3> <!-- <h4>- recently created</h4> -->
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
