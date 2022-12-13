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
    	fn_init();
    	fn_initGrid(); //그리드를 그린다.
    	fn_initEvent(); //이벤트 정의
    });
    
    function fn_checkClose() {
    	return gfn_getGrdSaveCount(grdMain) == 0; 
    }
    
    //공통코드 조회
    function fn_init() {
    	var grpCd = "COMPANY_CD,BU_CD,DIV_CD,TEAM_CD";
    	codeMap = gfn_getComCode(grpCd,'N','Y'); //공통코드 조회
    }
    
    //이벤트 정의
    function fn_initEvent() {
    	$("#btnSearch").click("on", function() { fn_apply(); });
    	/* $("#btnSave").click(fn_save); */
    	/* $("#btnAdd").click(fn_add);
    	$("#btnDel").click(fn_del); */
    	/* $("#btnReset").click(fn_reset); */
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
       		grid.setColumnProperty("COMPANY_CD", "editable", editable);
       		grid.setColumnProperty("BU_CD"     , "editable", editable);
       		grid.setColumnProperty("DIV_CD"    , "editable", editable);
       		grid.setColumnProperty("TEAM_CD"   , "editable", editable);
       		grid.setColumnProperty("PART_CD"   , "editable", editable);
       	};
       	
       	grdMain.onCellButtonClicked = function (grid, itemIndex, column) {
       		
       		var cName = column.name;
       		
			if (cName == "DATA_SCOPE_ID" || cName == "KPI_ID") {
				var rowState = dataProvider.getRowState(itemIndex);
				if (rowState != "none" && rowState != "updated") {
					alert('<spring:message code="msg.dataSave"/>');
					return;
				}
			}
			
			//팝업
			if (cName == "DATA_SCOPE_ID") {
				if(gfn_isNull(dataProvider.getValue(itemIndex, "DATA_SCOPE_TYPE"))) return;
				
	       		var params = {
	       			popupTitle : "Data Scope",
	       			rootUrl : "master",
	       			url : "dataScope",
	       		};
	       		$.extend(params, dataProvider.getJsonRow(itemIndex));
	       		
	       		gfn_comPopupOpen("DATA_SCOPE", params);
	       		
			} else if (cName == "KPI_ID") {
	       		var params = {
	       			popupTitle : "BSC KPI",
	       			rootUrl : "master",
	       			url : "bscKpi",
	       		};
	       		$.extend(params, dataProvider.getJsonRow(itemIndex));
	       		
	       		gfn_comPopupOpen("BSC_KPI", params);
			} else if (cName == "SCM_SCORE_ID") {
				
				var params = {
	       			popupTitle : "SCM_SCORE_ID",
	       			rootUrl : "master",
	       			url : "scmScore",
	       		};
	       		$.extend(params, dataProvider.getJsonRow(itemIndex));
	       		
	       		gfn_comPopupOpen("SCM_SCORE_ID", params);
			}
       	}
	}
	
	//provider 필드 설정
    function fn_setFields(provider) {
    	//필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName: "COMPANY_CD"},
            {fieldName: "BU_CD"},
            {fieldName: "DIV_CD"},
            {fieldName: "TEAM_CD"},
            {fieldName: "PART_CD"},
            {fieldName: "PART_NM"},
            {fieldName: "DATA_SCOPE_TYPE"},
            {fieldName: "DATA_SCOPE_TYPE_NM"},
            {fieldName: "DATA_SCOPE_ID"},
            {fieldName: "KPI_ID"},
            {fieldName: "SCM_SCORE_ID"},
        ];
        dataProvider.setFields(fields); //DataProvider의 setFields함수로 필드를 입력합니다.
    }
    
	//그리드 컬럼설정
    function fn_setColumns(grd) {

		var dropEditor    = {type: "dropDown" ,domainOnly: true, textReadOnly: true}
		var dynamicStyles = [{
            criteria: ["state<>'c'","state='c'"],
            styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor]
        }];
		
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = [
            {	name: "COMPANY_CD" ,fieldName: "COMPANY_CD" ,width: 100 ,editable: false,
            	header: {text: '<spring:message code="lbl.company"/>'},
            	styles: {textAlignment: "near", background : gv_noneEditColor},
                dynamicStyles: dynamicStyles,
                editor: dropEditor, 
                values: gfn_getArrayExceptInDs(codeMap.COMPANY_CD, "CODE_CD", ""),
                labels: gfn_getArrayExceptInDs(codeMap.COMPANY_CD, "CODE_NM", ""),
                lookupDisplay: true,
            },
            {	name: "BU_CD" ,fieldName: "BU_CD" ,width: 100 ,editable: false,
            	header: {text: '<spring:message code="lbl.bu"/>'},
            	styles: {textAlignment: "near", background : gv_noneEditColor},
                dynamicStyles: dynamicStyles,
                editor: dropEditor, 
                lookupDisplay: true,
                lookupSourceId :"BU_CD_DATA", 
				lookupKeyFields:["BU_CD"]
            },
            {   name: "DIV_CD" ,fieldName: "DIV_CD" ,width: 200 ,editable: false,
                header: {text: '<spring:message code="lbl.division"/>'},
                styles: {textAlignment: "near", background : gv_noneEditColor},
                dynamicStyles: dynamicStyles,
                editor: dropEditor, 
                lookupDisplay: true,
                lookupSourceId :"DIV_CD_DATA", 
				lookupKeyFields:["BU_CD","DIV_CD"]
            },
            {	name: "TEAM_CD" ,fieldName: "TEAM_CD" ,width: 100 ,editable: false,
                header: {text: '<spring:message code="lbl.team"/>'},
                styles: {textAlignment: "near", background : gv_noneEditColor},
                dynamicStyles: dynamicStyles,
                editor: dropEditor,
                lookupDisplay: true,
                lookupSourceId :"TEAM_CD_DATA", 
				lookupKeyFields:["BU_CD","TEAM_CD"]
            },
            { 	name: "PART_CD" ,fieldName: "PART_CD" ,width: 80,
            	header: {text: '<spring:message code="lbl.part"/>'},
            	styles: {textAlignment: "near"},
            	dynamicStyles: dynamicStyles,
            	editor: {maxLength: 100},
            },
            { 	name: "PART_NM" ,fieldName: "PART_NM" ,width: 200, editable: false,
            	header: {text: '<spring:message code="lbl.partNm"/>'},
            	styles: {textAlignment: "near", background : gv_noneEditColor},
            	editor: {maxLength: 100},
            },
            {	name : "DATA_SCOPE_ID", fieldName : "DATA_SCOPE_ID", editable: false, width : 100,
            	header : {text: '<spring:message code="lbl.dataScope" />'},
				cursor: "pointer",
				button: "action",
				styles: {background:gv_editColor},
			},
            {	name : "KPI_ID", fieldName : "KPI_ID", editable: false, width : 100,
            	header : {text: '<spring:message code="lbl.kPI" />'},
            	styles: {background:gv_editColor},
				cursor: "pointer",
				button: "action",
			},
			{	name : "SCM_SCORE_ID", fieldName : "SCM_SCORE_ID", editable: false, width : 100,
            	header : {text: '<spring:message code="lbl.scmScoreId" />'},
            	styles: {background:gv_editColor},
				cursor: "pointer",
				button: "action",
			}
        ];
        grd.setColumns(columns); //컬럼을 GridView에 입력 합니다.
        
        //동적콤보 설정
        grd.setLookups([
		    { id:"BU_CD_DATA",
		      levels  :1,
		      ordered : true,
		      keys    : gfn_getArrayExceptInDs(codeMap.BU_CD, "CODE_CD", ""),
		      values  : gfn_getArrayExceptInDs(codeMap.BU_CD, "CODE_NM", ""),
		    },
		    { id:"DIV_CD_DATA",
		      levels:2,
		      ordered: true,
		      keys   : fn_getLookupData(0, codeMap.DIV_CD),
		      values : fn_getLookupData(1, codeMap.DIV_CD),
		    },
		    { id:"TEAM_CD_DATA",
		      levels:2,
		      ordered: true,
		      keys   : fn_getLookupData(0, codeMap.TEAM_CD),
		      values : fn_getLookupData(1, codeMap.TEAM_CD),
		    },
		]);
    }
	
    function fn_getLookupData(type, map) {
		var tmpMainOrg = [];
		var tmpArrOrg;
		$.each(map, function(n,v) {
			tmpArrOrg = [];
			
			if (type == 0) {
				tmpArrOrg.push(v.BU_CD);
				tmpArrOrg.push(v.CODE_CD);
			} else {
				tmpArrOrg.push(v.CODE_NM);
			}
			
			tmpMainOrg.push(tmpArrOrg);
		});
		
		return tmpMainOrg;
	}
	
    //그리드 옵션
    function fn_setOptions(grd) {
        grd.setOptions({
            /* checkBar: { visible: true }, */
	        /* stateBar: { visible: true }, */
	        sorting : { enabled: false},
        });
        
        grd.setDisplayOptions({
    		editItemMerging : false,
    	});
    }
    
    //행추가
    /* function fn_add() {
    	grdMain.commit();
        var setCols = {}
       	dataProvider.addRow(setCols);
        
        //포커스 이동
        grdMain.setCurrent({dataRow : dataProvider.getRowCount()-1, column : "COMPANY_CD" });
    } */

    //삭제
    /* function fn_del() {
    	var rows = grdMain.getCheckedRows();
    	dataProvider.removeRows(rows, false);
    } */
    
    //그리드 데이터 조회
    function fn_getGridData() {
    	
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"master.master.bscOrgMgmt"}];
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
    
    //저장
    /* function fn_save() {
    	//수정된 그리드 데이터만 가져온다.
		var grdData = gfn_getGrdSavedataAll(grdMain);
    	if (grdData.length == 0) {
			alert('<spring:message code="msg.noChangeData"/>');
			return;
    	}

    	//그리드 유효성 검사
    	var arrColumn = ["COMPANY_CD","BU_CD","DIV_CD","TEAM_CD","PART_CD","PART_NM"];
    	if (!gfn_getValidation(gridInstance,arrColumn)) return;
    	
    	// PK 중복 체크 
        if (gfn_dupCheck(grdMain, "COMPANY_CD|BU_CD|DIV_CD|TEAM_CD|PART_CD")) return;

    	confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
    			
    		//저장위치 처리
    		//gridInstance.saveTopUpdKeys("BU_CD|GROUP_CD|CODE_CD");
    			
    		//저장
    		FORM_SAVE = {}; //초기화
    		FORM_SAVE._mtd   = "saveAll";
    		FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"master.master.bscOrgMgmt", mergeFlag: "Y", grdData : grdData, custDupChkYn : {"insert":"N"}}];
	    	var sMap = {
	            url: GV_CONTEXT_PATH + "/biz/obj",
	            data: FORM_SAVE,
	            success:function(data) {
	            	if ( data.errCode == -10 ) {
	            		alert(gfn_getDomainMsg("msg.dupData",data.errLine));
	            		grdMain.setCurrent({dataRow : data.errLine - 1, column : "PART_CD"});
	            	} else {
		            	alert('<spring:message code="msg.saveOk"/>');
		            	fn_apply();
	            	}
	            }
	        }
	        gfn_service(sMap,"obj");
    	});
    } */
    
    //그리드 초기화
    /* function fn_reset() {
    	grdMain.cancel();
        dataProvider.rollback(dataProvider.getSavePoints()[0]);
    } */
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
		<%-- <div class="cbt_btn roleWrite">
			<div class="bright">
			<a id="btnReset" href="#" class="app1"><spring:message code="lbl.reset"/></a>
			<a id="btnAdd" href="#" class="app1"><spring:message code="lbl.add"/></a>
			<a id="btnDel" href="#" class="app1"><spring:message code="lbl.delete"/></a>
			<a id="btnSave" href="#" class="app2"><spring:message code="lbl.save"/></a>
			</div>
		</div> --%>
	</div>
</body>
</html>
