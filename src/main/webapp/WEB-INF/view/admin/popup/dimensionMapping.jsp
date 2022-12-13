<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
//전역변수 설정
var popupWidth, popupHeight;
var gridInstance, grdMain, dataProvider;
var gridInstanceSub, grdSub, dataProviderSub;
var gridInstance2, grdMain2, dataProvider2;
var gridInstanceSub2, grdSub2, dataProviderSub2;
var lvCompanyCd = "${param.P_COMPANY_CD}";
var lvBuCd      = "${param.P_BU_CD}";
var lvMenuCd    = "${param.P_MENU_CD}";
var lvTmpGubun  = "";

//초기설정
$(function() {
	gfn_popresize();
	fn_init();
	fn_initCode(); //공통코드 조회
	fn_initGrid(); //그리드를 그린다.
	fn_initEvent(); //이벤트 정의
});

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

function fn_init() {
	// 팝업에서 탭을 선택시 화면이 변경됨
	$(".popCont > #treewrap > .treeNav > li > a").click(function() {
		var tab_id = $(this).attr("id");
		for(var i=1; i<=4; i++){
			if($("#tab"+i).hasClass("on")) $("#tab"+i).removeClass("on");
			$("#search_disp"+i).hide();
		}
		$("#" + tab_id).addClass("on");
		$("#search_disp"+tab_id.substr(3)).show();
		
		gfn_popresizeSub();
		
		gfn_setEnterSearch(); //엔터 조회 이벤트 맵핑
		
	});
}

//공통코드 조회
function fn_initCode() {}

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
    
    //그리드 1 ------------------------
	gridInstance2 = new GRID();
	gridInstance2.init("realgrid2");
	grdMain2 = gridInstance2.objGrid;
	dataProvider2 = gridInstance2.objData;
	
    fn_setFields(dataProvider2,"M2"); //set fields
    fn_setColumns(grdMain2,"M2"); // set columns
    fn_setOptions(grdMain2,"M2"); // set options

    //그리드 2 ------------------------
	gridInstanceSub2 = new GRID();
	gridInstanceSub2.init("realgridSub2");
	grdSub2 = gridInstanceSub2.objGrid;
	dataProviderSub2 = gridInstanceSub2.objData;
	
    fn_setFields(dataProviderSub2,"S2"); //set fields
    fn_setColumns(grdSub2,"S2"); // set columns
    fn_setOptions(grdSub2,"S2"); // set options
    
    //셀 더블클릭
   	grdMain.onDataCellDblClicked = function (grid, index) {
   		if(index.fieldName == "DIM_CD") {
   			fn_moveSub("R", index.dataRow, "Y");
   		}
   	};

   	//셀 더블클릭
   	grdSub.onDataCellDblClicked = function (grid, index) {
   		if(index.fieldName == "DIM_CD") {
   			fn_moveSub("L", index.dataRow, "Y");
   		}
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

   	//셀 더블클릭
   	grdMain2.onDataCellDblClicked = function (grid, index) {
   		if(index.fieldName == "MEAS_CD") {
   			fn_moveSub("R2", index.dataRow, "Y");
   		}
   	};

   	//셀 더블클릭
   	grdSub2.onDataCellDblClicked = function (grid, index) {
   		if(index.fieldName == "MEAS_CD") {
   			fn_moveSub("L2", index.dataRow, "Y");
   		}
   	};
   	
    //헤더체크
   	grdSub2.onColumnCheckedChanged = function (grid, column, checked) {
   		var checkedVal =  checked ? "Y":"N";
   		dataProviderSub2.beginUpdate();
    	for (var i=0; i<dataProviderSub2.getRowCount(); i++) {
    		dataProviderSub2.setValue(i, column.name, checkedVal);
    	}
    	dataProviderSub2.endUpdate();
   	};
}

//이벤트 정의
function fn_initEvent() {
	$("#moveR").click("on", function() { fn_move("R"); });
	$("#moveL").click("on", function() { fn_move("L"); });
	$("#moveR2").click("on", function() { fn_move("R2"); });
	$("#moveL2").click("on", function() { fn_move("L2"); });
	
	$("#btnDimSearch").click("on", function() {
		lvTmpGubun = "DIMENSION";
		fn_apply(); 
	});
	$("#btnMeaSearch").click("on", function() {
		lvTmpGubun = "MEASURE";
		fn_apply(); 
	});
	
	$("#btnSave").click("on", function() { fn_save(); });
	$("#btnReset").click(fn_reset);
	$(".pClose").click("on", function() { self.close(); });
	
	fn_apply(false,"Y");
}

//조회
function fn_apply(sqlFlag,initFlag) {
	//조회조건 설정
	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
	FORM_SEARCH.sql = sqlFlag;
	FORM_SEARCH.SEARCH_COMPANY_CD = lvCompanyCd;
	FORM_SEARCH.SEARCH_BU_CD      = lvBuCd;
	FORM_SEARCH.SEARCH_MENU_CD    = lvMenuCd;
	
	fn_getGridData(initFlag); //메인 데이터를 조회
}

//provider 필드 설정
function fn_setFields(provider,grdType) {
	//필드 배열 객체를  생성합니다.
	var fields;
	if (grdType == "M") {
        fields = [
            {fieldName: "COMPANY_CD"},
            {fieldName: "BU_CD"},
            {fieldName: "MENU_CD"},
            {fieldName: "DIM_CD"},
            {fieldName: "DIM_NM"},
            {fieldName: "DIM_DESC"}
        ];
	} else if (grdType == "M2") {
        fields = [
            {fieldName: "COMPANY_CD"},
            {fieldName: "BU_CD"},
            {fieldName: "MENU_CD"},
            {fieldName: "MEAS_CD"},
            {fieldName: "MEAS_NM"},
            {fieldName: "MEAS_DESC"}
        ];
	} else if (grdType == "S") {
		fields = [
            {fieldName: "COMPANY_CD"},
            {fieldName: "BU_CD"},
            {fieldName: "MENU_CD"},
            {fieldName: "DIM_CD"},
            {fieldName: "DIM_NM"},
            {fieldName: "SORT"},
            {fieldName: "WIDTH"},
            {fieldName: "MAND_FLAG"},
            {fieldName: "DEFAULT_FLAG"},
            {fieldName: "TOTAL_FLAG"},
            {fieldName: "LVL"},
        ];
	} else if (grdType == "S2") {
		fields = [
            {fieldName: "COMPANY_CD"},
            {fieldName: "BU_CD"},
            {fieldName: "MENU_CD"},
            {fieldName: "MEAS_CD"},
            {fieldName: "MEAS_NM"},
            {fieldName: "SORT"},
            {fieldName: "MAND_FLAG"},
            {fieldName: "DEFAULT_FLAG"},
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
            { name: "DIM_CD",fieldName: "DIM_CD",header: {text: '<spring:message code="lbl.dimension"/>'    } ,styles: {textAlignment: "near"},width: 100,editable: false,cursor: "pointer", },
            { name: "DIM_NM",fieldName: "DIM_NM",header: {text: '<spring:message code="lbl.dimensionName"/>'} ,styles: {textAlignment: "near"},width: 100 },
        ];
	} else if (grdType == "S") {
		columns = [
            { name: "DIM_CD"      ,fieldName: "DIM_CD"      ,header: {text: '<spring:message code="lbl.dimension"/>'    } ,width: 100 ,editable: false	,styles: {textAlignment: "near"	,background: gv_noneEditColor}	,cursor: "pointer" },
            { name: "DIM_NM"      ,fieldName: "DIM_NM"      ,header: {text: '<spring:message code="lbl.dimensionName"/>'} ,width: 100 ,editable: false	,styles: {textAlignment: "near" ,background: gv_noneEditColor} },
            { name: "SORT"        ,fieldName: "SORT"        ,header: {text: '<spring:message code="lbl.sort"/>'		 } ,width: 30  ,editable: true	,styles: {textAlignment: "far"  ,background: gv_requiredColor}	,editor: {type: "number",maxLength: 3} },
            { name: "WIDTH"       ,fieldName: "WIDTH"       ,header: {text: '<spring:message code="lbl.width"/>'		 } ,width: 40  ,editable: true	,styles: {textAlignment: "far"  ,background: gv_requiredColor}  ,editor: {type: "number",maxLength: 3} },
            { name: "LVL"         ,fieldName: "LVL"         ,header: {text: '<spring:message code="lbl.level"/>'		 } ,width: 35  ,editable: true	,styles: {textAlignment: "far"  ,background: gv_requiredColor}  ,editor: {type: "number",maxLength: 3} },
            { name: "MAND_FLAG"   ,fieldName: "MAND_FLAG"   ,header: {text: '<spring:message code="lbl.required"/>'	 } ,width: 55  ,editable: false	,styles: {textAlignment: "near"}                                ,renderer : gfn_getRenderer("CHECK") },
            { name: "DEFAULT_FLAG",fieldName: "DEFAULT_FLAG",header: {text: '<spring:message code="lbl.default"/>'		 ,checkLocation: "left"} ,width: 60  ,editable: false	,styles: {textAlignment: "near"}                                ,renderer : gfn_getRenderer("CHECK") },
            { name: "TOTAL_FLAG"  ,fieldName: "TOTAL_FLAG"  ,header: {text: '<spring:message code="lbl.totalYn"/>'		 ,checkLocation: "left"} ,width: 60  ,editable: false	,styles: {textAlignment: "near"}                                ,renderer : gfn_getRenderer("CHECK") },
        ];
	} else if (grdType == "M2") {
        columns = [
            { name: "MEAS_CD",fieldName: "MEAS_CD",header: {text: '<spring:message code="lbl.measure"/>'    } ,styles: {textAlignment: "near"} ,width: 100 ,editable: false    ,cursor: "pointer" },
            { name: "MEAS_NM",fieldName: "MEAS_NM",header: {text: '<spring:message code="lbl.measureName"/>'} ,styles: {textAlignment: "near"} ,width: 100 },
        ];
	} else if (grdType == "S2") {
		columns = [
            { name: "MEAS_CD"     ,fieldName: "MEAS_CD"     ,header: {text: '<spring:message code="lbl.measure"/>'		} ,width: 100 ,editable: false	,styles: {textAlignment: "near"	,background: gv_noneEditColor}	,cursor: "pointer"     , },
            { name: "MEAS_NM"     ,fieldName: "MEAS_NM"     ,header: {text: '<spring:message code="lbl.measureName"/>' } ,width: 100 ,editable: false	,styles: {textAlignment: "near" ,background: gv_noneEditColor} },
            { name: "SORT"        ,fieldName: "SORT"        ,header: {text: '<spring:message code="lbl.sort"/>'		} ,width: 50  ,editable: true	,styles: {textAlignment: "far"  ,background:gv_requiredColor}	,editor: {type: "number",maxLength: 3,}, },
            { name: "MAND_FLAG"   ,fieldName: "MAND_FLAG"   ,header: {text: '<spring:message code="lbl.required"/>'	} ,width: 55  ,editable: false	,styles: {textAlignment: "near"}                                ,renderer : gfn_getRenderer("CHECK") },
            { name: "DEFAULT_FLAG",fieldName: "DEFAULT_FLAG",header: {text: '<spring:message code="lbl.default"/>'		,checkLocation: "left"} ,width: 60  ,editable: false	,styles: {textAlignment: "near"}                                ,renderer : gfn_getRenderer("CHECK")},
        ];
	}
    grd.setColumns(columns); //컬럼을 GridView에 입력 합니다.
}

//그리드 옵션
function fn_setOptions(grd,grdType) {
	var options;
    if (grdType == "M" || grdType == "M2") {
		options = {
            checkBar: { visible: true },
	        stateBar: { visible: false },
	        edit    : { editable: false},
	        hideDeletedRows : true
        };
		grd.setOptions(options);
		grd.setSelectOptions({style: "rows"});
    } else {
    	options = {
            checkBar: { visible: true },
	        stateBar: { visible: true },
	        edit    : { editable: true},
	        hideDeletedRows : true
        };
    	grd.setOptions(options);
    }
}

//그리드 데이터 조회
function fn_getGridData(initFlag) {
	FORM_SEARCH._mtd = "getList";
	FORM_SEARCH.tranData = [{outDs:"rtnList"   ,_siq:"common.dimMap"}
	                      , {outDs:"mapList"   ,_siq:"admin.dimMapMenu"}
	                      , {outDs:"meaList"   ,_siq:"common.meaMap"}
	                      , {outDs:"meaMapList",_siq:"admin.meaMapMenu"}];
	var sMap = {
		url: GV_CONTEXT_PATH + "/biz/obj",
        data: FORM_SEARCH,
        success:function(data) {
			//그리드 데이터 생성
			if (gfn_isNull(lvTmpGubun) || lvTmpGubun == "DIMENSION") {
		    	grdMain.cancel();
				dataProvider.setRows(data.rtnList);
				
				if (initFlag == "Y") {
					grdSub.cancel();
					dataProviderSub.setRows(data.mapList);
				}
			}

			//그리드 데이터 생성
			if (gfn_isNull(lvTmpGubun) || lvTmpGubun == "MEASURE") {
		    	grdMain2.cancel();
				dataProvider2.setRows(data.meaList);
				
				if (initFlag == "Y") {
					grdSub2.cancel();
					dataProviderSub2.setRows(data.meaMapList);
				}
			}
        }
    }
    gfn_service(sMap,"obj");
}

//저장
function fn_save() {
	//수정된 그리드 데이터만 가져온다.
	var grdData = gfn_getGrdSavedataAll(grdSub);
	var grdData2 = gfn_getGrdSavedataAll(grdSub2);
	if (grdData.length == 0 && grdData2.length == 0) {
		alert('<spring:message code="msg.noChangeData"/>');  //변경된 데이터가 없습니다.
		return;
	}
	
	//그리드 유효성 검사
	var arrColumn = ["DIM_CD","DIM_NM","SORT","WIDTH","LVL"];
	if (!gfn_getValidation(gridInstanceSub,arrColumn)) return;

	//그리드 유효성 검사
	var arrColumn = ["MEAS_CD","MEAS_NM","SORT"];
	if (!gfn_getValidation(gridInstanceSub2,arrColumn)) return;
	
	confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
		//저장
		FORM_SAVE = {}; //초기화
		FORM_SAVE._mtd = "saveAll";
		FORM_SAVE.tranData = [{outDs:"saveCnt1",_siq:"admin.dimMapMenu", grdData : grdData , mergeFlag : "Y"}
		                    , {outDs:"saveCnt2",_siq:"admin.meaMapMenu", grdData : grdData2, mergeFlag : "Y"}];
		var serviceMap = {
			url: GV_CONTEXT_PATH + "/biz/obj",
            data: FORM_SAVE,
            success:function(data) {
            	alert('<spring:message code="msg.saveOk"/>');
            	fn_apply(false,"Y");
            }
        }
		gfn_service(serviceMap, "obj");
	}); 
}

//그리드 초기화
function fn_reset() {
	fn_apply();
}

function fn_move(type) {
	var rows;
	if (type == "R") {
		rows = grdMain.getCheckedRows(true);
    	$.each(rows,function (n,v) {
    		fn_moveSub(type, v, "N");
    	});
    	
    	//이동후 삭제
    	dataProvider.removeRows(rows, false);
	} else if (type == "L") {
		rows = grdSub.getCheckedRows(true);
    	$.each(rows,function (n,v) {
    		fn_moveSub(type, v, "N");
    	});
    	
    	//이동후 삭제
    	dataProviderSub.removeRows(rows, false);
	} else if (type == "R2") {
		rows = grdMain2.getCheckedRows(true);
    	$.each(rows,function (n,v) {
    		fn_moveSub(type, v, "N");
    	});
    	
    	//이동후 삭제
    	dataProvider2.removeRows(rows, false);
	} else if (type == "L2") {
		rows = grdSub2.getCheckedRows(true);
    	$.each(rows,function (n,v) {
    		fn_moveSub(type, v, "N");
    	});
    	
    	//이동후 삭제
    	dataProviderSub2.removeRows(rows, false);
	}
}

function fn_moveSub(type, idx, gubun) {
	var setCols = {};
	if (type == "R") {
		
		//없는 경우에만 처리
		if (gfn_getFindRow(dataProviderSub,"DIM_CD",dataProvider.getValue(idx,"DIM_CD"),null,"N") == -1) {
			setCols.COMPANY_CD = dataProvider.getValue(idx,"COMPANY_CD");
			setCols.BU_CD      = dataProvider.getValue(idx,"BU_CD");
			setCols.MENU_CD    = dataProvider.getValue(idx,"MENU_CD");
			setCols.DIM_CD     = dataProvider.getValue(idx,"DIM_CD");
			setCols.DIM_NM     = dataProvider.getValue(idx,"DIM_NM");
			setCols.SORT       = dataProviderSub.getRowCount()+1;
			setCols.WIDTH      = 80;
			dataProviderSub.addRow(setCols);
			
			//이동데이터 체크
			grdSub.checkRow(dataProviderSub.getRowCount()-1,true,false);
		}
		
		//이동후 삭제
		if (gubun == "Y") dataProvider.removeRow(idx, false);
	} else if (type == "L") {
		//없는 경우에만 처리
		if (gfn_getFindRow(dataProvider,"DIM_CD",dataProviderSub.getValue(idx,"DIM_CD"),null,"N") == -1) {
			setCols.COMPANY_CD = dataProviderSub.getValue(idx,"COMPANY_CD");
			setCols.BU_CD      = dataProviderSub.getValue(idx,"BU_CD");
			setCols.MENU_CD    = dataProviderSub.getValue(idx,"MENU_CD");
			setCols.DIM_CD     = dataProviderSub.getValue(idx,"DIM_CD");
			setCols.DIM_NM     = dataProviderSub.getValue(idx,"DIM_NM");
			dataProvider.addRow(setCols);
			
			//이동데이터 체크
			grdMain.checkRow(dataProvider.getRowCount()-1,true,false);
		}
		
		//이동후 삭제
    	if (gubun == "Y") dataProviderSub.removeRow(idx, false);
	} else if (type == "R2") {
		//없는 경우에만 처리
		if (gfn_getFindRow(dataProviderSub2,"MEAS_CD",dataProvider2.getValue(idx,"MEAS_CD"),null,"N") == -1) {
			setCols.COMPANY_CD = dataProvider2.getValue(idx,"COMPANY_CD");
			setCols.BU_CD      = dataProvider2.getValue(idx,"BU_CD");
			setCols.MENU_CD    = dataProvider2.getValue(idx,"MENU_CD");
			setCols.MEAS_CD    = dataProvider2.getValue(idx,"MEAS_CD");
			setCols.MEAS_NM    = dataProvider2.getValue(idx,"MEAS_NM");
			setCols.SORT       = dataProviderSub2.getRowCount()+1;
			dataProviderSub2.addRow(setCols);
			
			//이동데이터 체크
			grdSub2.checkRow(dataProviderSub2.getRowCount()-1,true,false);
		}
		
		//이동후 삭제
		if (gubun == "Y") dataProvider2.removeRow(idx, false);
	} else if (type == "L2") {
		//없는 경우에만 처리
		if (gfn_getFindRow(dataProvider2,"MEAS_CD",dataProviderSub2.getValue(idx,"MEAS_CD"),null,"N") == -1) {
			setCols.COMPANY_CD = dataProviderSub2.getValue(idx,"COMPANY_CD");
			setCols.BU_CD      = dataProviderSub2.getValue(idx,"BU_CD");
			setCols.MENU_CD    = dataProviderSub2.getValue(idx,"MENU_CD");
			setCols.MEAS_CD    = dataProviderSub2.getValue(idx,"MEAS_CD");
			setCols.MEAS_NM    = dataProviderSub2.getValue(idx,"MEAS_NM");
			dataProvider2.addRow(setCols);
			
			//이동데이터 체크
			grdMain2.checkRow(dataProvider2.getRowCount()-1,true,false);
		}
		
		//이동후 삭제
    	if (gubun == "Y") dataProviderSub2.removeRow(idx, false);
	}
}

</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div class="popupDv">
		<div class="pop_tit">${param.P_MENU_NM}</div>
		<div class="popCont">
			
			<!-- 상단 탭기능 추가 -->
			<div id="treewrap">
				<ul class="treeNav" style="margin:0 0 8px 0">
					<li><a id="tab1" href="#" class="on">Dimension</a></li><!-- 클릭시 1번 탭 보임-->
					<li><a id="tab2" href="#">Measure</a></li><!-- 클릭시 2번 탭 보임-->
				</ul>
			</div>
			<!-- 상단 탭기능 추가 마지막-->
			
			<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
			<!-- 1번 탭 -->
			<div id="search_disp1">
				<div class="srhwrap">
					<div class="srhcondi">
						<ul>
							<li>
							<strong>Code</strong>
							<div class="selectBox">
							<input type="text" id="SEARCH_DIM_CD" name="SEARCH_DIM_CD" class="ipt">
							</div>
							</li>
							<li>
							<strong>Name</strong>
							<div class="selectBox">
							<input type="text" id="SEARCH_DIM_NM" name="SEARCH_DIM_NM" class="ipt">
							</div>
							</li>
						</ul>
					</div>
					<div class="bt_btn">
						<a id="btnDimSearch" href="#" class="fl_app"><spring:message code="lbl.search"/></a>
					</div>
				</div>
	
				<div class="ovselect_tr">
					<div class="lf_tbl" style="width:280px;padding:0px 0 0 0;">
						<div id="realgrid" class="realgrid1"></div>
					</div>
					<div class="movBtn">
						<span><a href="#" id="moveR"><img src="${ctx}/statics/images/common/pop_mov1.gif" alt=""></a></span>
						<span><a href="#" id="moveL"><img src="${ctx}/statics/images/common/pop_mov2.gif" alt=""></a></span>
					</div>
					<div class="rf_tbl" style="width:calc(100% - 330px);">
						<div id="realgridSub" class="realgrid1"></div>
					</div>
				</div>
			</div>
			<!-- 1번 탭 마지막 -->
			
			<!-- 2번 탭 -->
			<div id="search_disp2" style="display:none">
				<div class="srhwrap">
					<div class="srhcondi">
						<ul>
							<li>
							<strong>Code</strong>
							<div class="selectBox">
							<input type="text" id="SEARCH_MEA_CD" name="SEARCH_MEA_CD" class="ipt">
							</div>
							</li>
							<li>
							<strong>Name</strong>
							<div class="selectBox">
							<input type="text" id="SEARCH_MEA_NM" name="SEARCH_MEA_NM" class="ipt">
							</div>
							</li>
						</ul>
					</div>
					
					<div class="bt_btn">
						<a id="btnMeaSearch" href="#" class="fl_app"><spring:message code="lbl.search"/></a>
					</div>
				</div>
				
				<div class="ovselect_tr">
					<div class="lf_tbl" style="width:280px;padding:0px 0 0 0;">
						<div id="realgrid2" class="realgrid1"></div>
					</div>
					<div class="movBtn">
						<span><a href="#" id="moveR2"><img src="${ctx}/statics/images/common/pop_mov1.gif" alt=""></a></span>
						<span><a href="#" id="moveL2"><img src="${ctx}/statics/images/common/pop_mov2.gif" alt=""></a></span>
					</div>
					<div class="rf_tbl" style="width:calc(100% - 330px);">
						<div id="realgridSub2" class="realgrid1"></div>
					</div>
				</div>
				
			</div>
			<!-- 2번 탭 마지막 -->
			</form>
			
			<!-- 하단 버튼 / 탭과 상관없이 계속 보임 -->
			<div class="pop_btn">
				<a id="btnReset" href="#" class="app1 roleWrite"><spring:message code="lbl.reset"/></a>
				<a id="btnSave" href="#" class="pbtn pApply roleWrite"><spring:message code="lbl.save"/></a>
				<a id="btnClose" href="#" class="pbtn pClose">Close</a>
			</div>
		</div>
	</div>
</body>
</html>