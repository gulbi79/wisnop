<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.basciWcCalendar"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
var popupWidth, popupHeight;
var codeMap, codeMapEx,codeAPMap, codeSalesOrgMap;
var gridInstance, grdMain, dataProvider;
var popUpMenuCd = "${param.menuCd}";

var lv_conFirmFlag = true;
$("document").ready(function (){
	gfn_popresize();
	fn_initData();
	fn_initFilter();
	fn_initGrid();
	fn_initEvent();
	fn_apply();
	fn_excelSqlAuth();
	grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
		if(key == 46){  //Delete Key
			gfn_selBlockDelete(grid,dataProvider);  
		}
	};
	$(".viewfnc5").click("on", function() {
		gfn_doExportExcel({fileNm:"${menuInfo.menuNm}", conFirmFlag: lv_conFirmFlag}); 
		$(".pClose").click(function() {
			$("#divTempLayerPopup").hide();
			$(".back").hide();
		});
	    $(".popClose").click(function() {
	    	$("#divTempLayerPopup").hide();
			$(".back").hide();
		});
	    $(".back").click(function() {
			$(".popup2").hide();
			$(".back").hide();
		});
	});
	
	$(".viewfnc4").click("on", function() {
		fn_apply(true);
		
		$(document).on("click",".popup2 .popClose, .popup2 .pClose",function() {
			$(".popup2").hide();
			$(".back").hide();
		});
		
		$(".back").click(function() {
			$(".popup2").hide();
			$(".back").hide();
		});
	    
	})
});

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

//데이터 초기화
function fn_initData() {
	// 공통코드 조회 
	var grpCd = 'PROD_PART,PLAN_INFO,RESOURCE_TYPE,WC_SHIFT,PROD_OR_QC,WORK_TYPE';
	
	codeMap = gfn_getComCode(grpCd, 'N'); //공통코드 조회
	codeMapEx = gfn_getComCodeEx(["WORK_PLACES_CD"]);
}


//필터 초기화
function fn_initFilter() {
	
	var upperWorkPlaces = {
		childId   : ["workplaces"],
		childData : [codeMapEx.WORK_PLACES_CD]
	};
	 
	gfn_setMsCombo("workType"  ,codeMap.RESOURCE_TYPE    , [""], {});
	gfn_setMsCombo("workplaces",codeMapEx.WORK_PLACES_CD , [""], {});
	gfn_setMsCombo("prodPart"  ,codeMap.PROD_PART        , [""], {},upperWorkPlaces);
	gfn_setMsCombo("prodOrQc"  ,codeMap.PROD_OR_QC, [], {});
	
}

//그리드 초기화
function fn_initGrid() {
	//그리드 설정
	gridInstance = new GRID();
	gridInstance.init("realgrid");
	grdMain      = gridInstance.objGrid;
	dataProvider = gridInstance.objData;
	
	fn_setFields(dataProvider);
	fn_setColumns(grdMain);
	fn_setOptions(grdMain);
	
	grdMain.setOptions({
        indicator: {visible: true},        
        checkBar: {visible: false},
        stateBar: {visible: true},
        edit: {insertable: false, appendable: false, updatable: true, editable: true},
        commitLevel: "info"
    });
	
	grdMain.addCellStyles([{
        id         : "editStyle",
        editable   : true,
        background : gv_editColor
    }]);
	
	grdMain.addCellStyles([{
        id         : "noneEditStyle",
        editable   : false,
        background : gv_noneEditColor
    }]);
	
	grdMain.onValidateColumn = function(grid, column, inserting, value) {
	    var error = {};
	    if(column.name.indexOf("_A") > -1 || column.name.indexOf("_B") > -1 ){  
	       if(value != '' && value != null){
	    	  
	    	   if (value >  24.00) {
		            error.level = RealGridJS.ValidationLevel.ERROR;
		            error.message = "최대 시간은 24시입니다.";
		        }else if(!$.isNumeric(value)){
		        	error.level = RealGridJS.ValidationLevel.ERROR;
		            error.message = "숫자만 입력 가능합니다.";
		        }
            }
	    }
	    return error;
    };
	    
	    
	grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
		if(newValue == 0){
			grid.setValue(dataRow, field, '');
		}
	};    
}

//그리드필드
function fn_setFields(provider) {
	var fields = [
		
		{ fieldName : "BU_CD" , dataType : 'text' },
		{ fieldName : "PART_CD" , dataType : 'text' },
		{ fieldName : "PART_CD_NM" , dataType : 'text' },
		{ fieldName : "POQ_CD" , dataType : 'text' },
		{ fieldName : "POQ_CD_NM" , dataType : 'text' },
		{ fieldName : "WC_MGR_CD" , dataType : 'text' },
		{ fieldName : "WC_MGR_CD_NM" , dataType : 'text' },
		{ fieldName : "WC_CD" , dataType : 'text' },
		{ fieldName : "WC_CD_NM" , dataType : 'text' },
		{ fieldName : "RESOURCE_CD" , dataType : 'text' },
		{ fieldName : "RESOURCE_CD_NM" , dataType : 'text' },
		{ fieldName : "ROUTING_ID_NM" , dataType : 'text' },
		{ fieldName : "SUN_A" , dataType : 'text' },
		{ fieldName : "SUN_B" , dataType : 'text' },
		{ fieldName : "MON_A" , dataType : 'text' },
		{ fieldName : "MON_B" , dataType : 'text' },
		{ fieldName : "TUE_A" , dataType : 'text' },
		{ fieldName : "TUE_B" , dataType : 'text' },
		{ fieldName : "WED_A" , dataType : 'text' },
		{ fieldName : "WED_B" , dataType : 'text' },
		{ fieldName : "THU_A" , dataType : 'text' },
		{ fieldName : "THU_B" , dataType : 'text' },
		{ fieldName : "FRI_A" , dataType : 'text' },
		{ fieldName : "FRI_B" , dataType : 'text' },
		{ fieldName : "SAT_A" , dataType : 'text' },
		{ fieldName : "SAT_B" , dataType : 'text' }
	];
	dataProvider.setFields(fields);
}

//그리드컬럼
function fn_setColumns(grd) {
	var columns = [
		{
			name         : "PART_CD",
			fieldName    : "PART_CD_NM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.prodPart2"/>' },
			styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
			width        : 70,
			mergeRule    : { criteria: "value"}
		},
		{
			name         : "POQ_CD",
			fieldName    : "POQ_CD_NM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.prodOrQc"/>' },
			styles       : { background : "rgba(237, 247, 253, 1)", textAlignment: "near" },
			width        : 50,
			mergeRule    : { criteria: "prevvalues + value"}
		},
		{
			name         : "WC_MGR_NM",
			fieldName    : "WC_MGR_CD_NM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.wcMgrNm"/>' },
			styles       : { background : "rgba(237, 247, 253, 1)", textAlignment: "near" },
			width        : 60,
			mergeRule    : { criteria: "prevvalues + value"}
		},
		{
			name         : "WC_CD",
			fieldName    : "WC_CD",
			editable     : false,
			header       : { text: '<spring:message code="lbl.wcCd_ALL"/>' },
			styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)"},
			width        : 90,
			mergeRule    : { criteria: "prevvalues + value"}
		},
		{
			name         : "WC_NM",
			fieldName    : "WC_CD_NM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.wcNm_ALL"/>' },
			styles       : { background : "rgba(237, 247, 253, 1)", textAlignment: "near" },
			width        : 130,
			mergeRule    : { criteria: "prevvalues + value"}
		},
		
		{
			name         : "RESOURCE_CD",
			fieldName    : "RESOURCE_CD",
			editable     : false,
			header       : { text: '<spring:message code="lbl.resourceCd_ALL"/>' },
			styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)"},
			width        : 80,
		},
		{
			name         : "RESOURCE_NM",
			fieldName    : "RESOURCE_CD_NM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.resourceNm_ALL"/>' },
			styles       : { background : "rgba(237, 247, 253, 1)", textAlignment: "near" },
			width        : 120,
		},
		{
            name         : "ROUTING_ID_NM",
            fieldName    : "ROUTING_ID_NM",
            editable     : false,
            header       : { text: '<spring:message code="lbl.routing"/>' },
            styles       : { background : "rgba(237, 247, 253, 1)", textAlignment: "near" },
            width        : 50,
        },
        
		{
			type         : "group",
		    name         : "SUN",
		    orientation  : "horizontal",
		    header: { "text": "일" },
		    resizable    : true,
		    movable      : false,
		    hideChildHeaders: false,
		    width: 120,
		    columns: [
				{    name: "SUN_A",
		             fieldName: "SUN_A",
		             width : "46",
		             editable : false,
		             styles: { "textAlignment": "center" ,background : gv_noneEditColor},
		             header: { "text": codeMap.WC_SHIFT[0].CODE_NM },
		             displayRegExp : "([0-9]{2})([0-9]{2})",
		             displayReplace : "$1.$2",
		             editor : {
				            	    type         : "text",
			   						editFormat   : "00.00",
			   						allowEmpty   :  true,
				 				    positiveOnly : true,
			   						textAlignment: "center",
			   						maxLength : 5
				    	      }
		         },
		         {    name: "SUN_B",
		             fieldName: "SUN_B",
		             width : "46",
		             editable : false,
		             styles: { "textAlignment": "center" ,background : gv_noneEditColor},
		             header: { "text": codeMap.WC_SHIFT[1].CODE_NM },
		             displayRegExp : "([0-9]{2})([0-9]{2})",
		             displayReplace : "$1.$2",
		             editor : {
						             type : "text",
					   				 editFormat   : "00.00",
					   				 allowEmpty   :  true,
						 			 positiveOnly : true,
					   				 textAlignment: "center",
					   				 maxLength : 5
				    	      }
		         }]
		 },
		 
		 {
				type         : "group",
			    name         : "MON",
			    orientation  : "horizontal",
			    header: { "text": "월" },
			    resizable    : true,
			    movable      : false,
			    hideChildHeaders: false,
			    width: 120,
			    columns: [
					{    name: "MON_A",
			             fieldName: "MON_A",
			             width : "46",
			             editable : false,
			             styles: { "textAlignment": "center" ,background : gv_noneEditColor},
			             header: { "text": codeMap.WC_SHIFT[0].CODE_NM },
			             displayRegExp : "([0-9]{2})([0-9]{2})",
			             displayReplace : "$1.$2",
			             editor : {
					            	    type         : "text",
				   						editFormat   : "00.00",
				   						allowEmpty   :  true,
					 				    positiveOnly : true,
				   						textAlignment: "center",
				   						maxLength : 5
					    	      }
			         },
			         {    name: "MON_B",
			             fieldName: "MON_B",
			             width : "46",
			             editable : false,
			             styles: { "textAlignment": "center" ,background : gv_noneEditColor},
			             header: { "text": codeMap.WC_SHIFT[1].CODE_NM },
			             displayRegExp : "([0-9]{2})([0-9]{2})",
			             displayReplace : "$1.$2",
			             editor : {
							             type : "text",
						   				 editFormat   : "00.00",
						   				 allowEmpty   :  true,
							 			 positiveOnly : true,
						   				 textAlignment: "center",
						   				 maxLength : 5
					    	      }
			         }]
			 },
			 
			 {
					type         : "group",
				    name         : "TUE",
				    orientation  : "horizontal",
				    header: { "text": "화" },
				    resizable    : true,
				    movable      : false,
				    hideChildHeaders: false,
				    width: 120,
				    columns: [
						{    name: "TUE_A",
				             fieldName: "TUE_A",
				             width : "46",
				             editable : false,
				             styles: { "textAlignment": "center" ,background : gv_noneEditColor},
				             header: { "text": codeMap.WC_SHIFT[0].CODE_NM },
				             displayRegExp : "([0-9]{2})([0-9]{2})",
				             displayReplace : "$1.$2",
				             editor : {
						            	    type         : "text",
					   						editFormat   : "00.00",
					   						allowEmpty   :  true,
						 				    positiveOnly : true,
					   						textAlignment: "center",
					   						maxLength : 5
						    	      }
				         },
				         {    name: "TUE_B",
				             fieldName: "TUE_B",
				             width : "46",
				             editable : false,
				             styles: { "textAlignment": "center" ,background : gv_noneEditColor},
				             header: { "text": codeMap.WC_SHIFT[1].CODE_NM },
				             displayRegExp : "([0-9]{2})([0-9]{2})",
				             displayReplace : "$1.$2",
				             editor : {
								             type : "text",
							   				 editFormat   : "00.00",
							   				 allowEmpty   :  true,
								 			 positiveOnly : true,
							   				 textAlignment: "center",
							   				 maxLength : 5
						    	      }
				         }]
				 },
				 
				 {
						type         : "group",
					    name         : "WED",
					    orientation  : "horizontal",
					    header: { "text": "수" },
					    resizable    : true,
					    movable      : false,
					    hideChildHeaders: false,
					    width: 120,
					    columns: [
							{    name: "WED_A",
					             fieldName: "WED_A",
					             width : "46",
					             editable : false,
					             styles: { "textAlignment": "center" ,background : gv_noneEditColor},
					             header: { "text": codeMap.WC_SHIFT[0].CODE_NM },
					             displayRegExp : "([0-9]{2})([0-9]{2})",
					             displayReplace : "$1.$2",
					             editor : {
							            	    type         : "text",
						   						editFormat   : "00.00",
						   						allowEmpty   :  true,
							 				    positiveOnly : true,
						   						textAlignment: "center",
						   						maxLength : 5
							    	      }
					         },
					         {    name: "WED_B",
					             fieldName: "WED_B",
					             width : "46",
					             editable : false,
					             styles: { "textAlignment": "center" ,background : gv_noneEditColor},
					             header: { "text": codeMap.WC_SHIFT[1].CODE_NM },
					             displayRegExp : "([0-9]{2})([0-9]{2})",
					             displayReplace : "$1.$2",
					             editor : {
									             type : "text",
								   				 editFormat   : "00.00",
								   				 allowEmpty   :  true,
									 			 positiveOnly : true,
								   				 textAlignment: "center",
								   				 maxLength : 5
							    	      }
					         }]
					 },
					 
					 {
							type         : "group",
						    name         : "THU",
						    orientation  : "horizontal",
						    header: { "text": "목" },
						    resizable    : true,
						    movable      : false,
						    hideChildHeaders: false,
						    width: 120,
						    columns: [
								{    name: "THU_A",
						             fieldName: "THU_A",
						             width : "46",
						             editable : false,
						             styles: { "textAlignment": "center" ,background : gv_noneEditColor},
						             header: { "text": codeMap.WC_SHIFT[0].CODE_NM },
						             displayRegExp : "([0-9]{2})([0-9]{2})",
						             displayReplace : "$1.$2",
						             editor : {
								            	    type         : "text",
							   						editFormat   : "00.00",
							   						allowEmpty   :  true,
								 				    positiveOnly : true,
							   						textAlignment: "center",
							   						maxLength : 5
								    	      }
						         },
						         {    name: "THU_B",
						             fieldName: "THU_B",
						             width : "46",
						             editable : false,
						             styles: { "textAlignment": "center" ,background : gv_noneEditColor},
						             header: { "text": codeMap.WC_SHIFT[1].CODE_NM },
						             displayRegExp : "([0-9]{2})([0-9]{2})",
						             displayReplace : "$1.$2",
						             editor : {
										             type : "text",
									   				 editFormat   : "00.00",
									   				 allowEmpty   :  true,
										 			 positiveOnly : true,
									   				 textAlignment: "center",
									   				 maxLength : 5
								    	      }
						         }]
						 },
						 
						 {
								type         : "group",
							    name         : "FRI",
							    orientation  : "horizontal",
							    header: { "text": "금" },
							    resizable    : true,
							    movable      : false,
							    hideChildHeaders: false,
							    width: 120,
							    columns: [
									{    name: "FRI_A",
							             fieldName: "FRI_A",
							             width : "46",
							             editable : false,
							             styles: { "textAlignment": "center" ,background : gv_noneEditColor},
							             header: { "text": codeMap.WC_SHIFT[0].CODE_NM },
							             displayRegExp : "([0-9]{2})([0-9]{2})",
							             displayReplace : "$1.$2",
							             editor : {
									            	    type         : "text",
								   						editFormat   : "00.00",
								   						allowEmpty   :  true,
									 				    positiveOnly : true,
								   						textAlignment: "center",
								   						maxLength : 5
									    	      }
							         },
							         {    name: "FRI_B",
							             fieldName: "FRI_B",
							             width : "46",
							             editable : false,
							             styles: { "textAlignment": "center" ,background : gv_noneEditColor},
							             header: { "text": codeMap.WC_SHIFT[1].CODE_NM },
							             displayRegExp : "([0-9]{2})([0-9]{2})",
							             displayReplace : "$1.$2",
							             editor : {
											             type : "text",
										   				 editFormat   : "00.00",
										   				 allowEmpty   :  true,
											 			 positiveOnly : true,
										   				 textAlignment: "center",
										   				 maxLength : 5
									    	      }
							         }]
							 },
							 
							 {
									type         : "group",
								    name         : "SAT",
								    orientation  : "horizontal",
								    header: { "text": "토" },
								    resizable    : true,
								    movable      : false,
								    hideChildHeaders: false,
								    width: 120,
								    columns: [
										{    name: "SAT_A",
								             fieldName: "SAT_A",
								             width : "46",
								             editable : false,
								             styles: { "textAlignment": "center" ,background : gv_noneEditColor},
								             header: { "text": codeMap.WC_SHIFT[0].CODE_NM },
								             displayRegExp : "([0-9]{2})([0-9]{2})",
								             displayReplace : "$1.$2",
								             editor : {
										            	    type         : "text",
									   						editFormat   : "00.00",
									   						allowEmpty   :  true,
										 				    positiveOnly : true,
									   						textAlignment: "center",
									   						maxLength : 5
										    	      }
								         },
								         {    name: "SAT_B",
								             fieldName: "SAT_B",
								             width : "46",
								             editable : false,
								             styles: { "textAlignment": "center" ,background : gv_noneEditColor},
								             header: { "text": codeMap.WC_SHIFT[1].CODE_NM },
								             displayRegExp : "([0-9]{2})([0-9]{2})",
								             displayReplace : "$1.$2",
								             editor : {
												             type : "text",
											   				 editFormat   : "00.00",
											   				 allowEmpty   :  true,
												 			 positiveOnly : true,
											   				 textAlignment: "center",
											   				 maxLength : 5
										    	      }
								         }]
								 },
        
		
	];
	grdMain.setColumns(columns);
}

//그리드 옵션
function fn_setOptions(grd) {
	grd.setOptions({
		stateBar: { visible: true }
	});
	
	grd.addCellStyles([{
		id         : "editStyle",
		editable   : true,
		background : gv_editColor
	}]);
	
	grd.addCellStyles([{
		id         : "noneEditStyle",
		editable   : false,
		background : gv_noneEditColor
	}]);
	
	
}

//이벤트 초기화
function fn_initEvent() {
	
	//버튼 이벤트
	$(".fl_app"   ).click("on", function() { fn_apply(); });
	$("#btnReset" ).click("on", function() { fn_reset(); });
	$("#btnSave"  ).click("on", function() { fn_save(); });
	$("#btnClose" ).click("on", function() { window.close(); });
}

//조회
function fn_apply(sqlFlag) {
	
	//조회조건 설정
	FORM_SEARCH = $("#searchForm").serializeObject();
	
	//그리드 데이터 조회
	fn_getGridData(sqlFlag);
	
	document.getElementById("realgrid").style.height = "420px"  
	grdMain.resetSize();
	
}

//그리드 데이터 조회
function fn_getGridData(sqlFlag) {
	
	FORM_SEARCH.sql	     = sqlFlag;
	FORM_SEARCH._mtd     = "getList";
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"aps.static.basicWorkCalendarRsc"}];
	
	gfn_service({
		url    : GV_CONTEXT_PATH + "/biz/obj.do",
		data   : FORM_SEARCH,
		success: function(data) {
			//그리드 데이터 삭제
			dataProvider.clearRows();
			grdMain.cancel();
			//그리드 데이터 생성
			dataProvider.setRows(data.rtnList);
			//그리드 초기화 포인트 저장
			dataProvider.clearSavePoints();
			dataProvider.savePoint();
			// 그리드 데이터 건수 출력
			gfn_setSearchRow(dataProvider.getRowCount());
			
			gridCallback(data.rtnList);
		}
	}, "obj");
	
	
	var cols = grdMain.getColumns();
	var wcType = $("#workType").val() == '' ? 'ALL' : $("#workType").val() ;
	
	for (var i = 2; i < cols.length; i++) {
		
		var colName = cols[i].name;
		if(colName == 'WC_CD' || colName == 'WC_NM' || colName == 'RESOURCE_CD' || colName == 'RESOURCE_NM'  ){
			headerTextChange(wcType ,  colName);
		}
	}
}

//그리드 초기화
function fn_reset() {
	grdMain.cancel();
	dataProvider.rollback(dataProvider.getSavePoints()[0]);
	fn_getGridData('N');
}

//그리드 저장
function fn_save() {
	
	try {
		grdMain.commit(true);
	} catch (e) {
		alert('<spring:message code="msg.saveErrorCheck"/>\n'+e.message);
	}
	
	//수정된 그리드 데이터
	var grdData = gfn_getGrdSavedataAll(grdMain);
	if (grdData.length == 0) {
		alert('<spring:message code="msg.noChangeData"/>');
		return;
	}
	
	// 저장
	confirm('<spring:message code="msg.saveCfm"/>', function() {
		
		
		// 저장할 데이터 정리
		var salesPlanDatas = [];
		
		$.each(grdData, function(i, row) {
			
			$.each(row, function(attr, value) {
				
				if (attr.indexOf("_A") > -1 || attr.indexOf("_B") > -1 ){
					
					var tmp = attr.split("_")[0];
					var spType = attr.split("_")[1];
					var day_nm = tmp;
					
					if (typeof value !=  "undefined"){
						
						if(value == null ) value = '';	
						
						var planData = {
							PROD_PART : row.PART_CD,
							RESOURCE_CD : row.RESOURCE_CD,
							WC_SHIFT  : null,
							DAY_NM  : null,
							OVER_TIME : 'undefined', 
						};
						 
						 planData.WC_SHIFT  = spType;
					     planData.DAY_NM  = day_nm;
					     
					     var find_idx = null;
						 for(i = 0; i < salesPlanDatas.length; i++){
							 if( salesPlanDatas[i].PROD_PART == row.PART_CD 
								 && salesPlanDatas[i].RESOURCE_CD == row.RESOURCE_CDM
								 && salesPlanDatas[i].WC_SHIFT == spType
								 && salesPlanDatas[i].DAY_NM == day_nm
							   ){
								   find_idx = i;
								   break;
							   }
						 }
						 
						 if(find_idx != null){
							  salesPlanDatas[i].OVER_TIME = value;
							 
						 }else{
							   planData.OVER_TIME   = value;
							   salesPlanDatas.push(planData);
						 }
					}
				} 
			});
		});
		
		// 실제저장
		FORM_SAVE              = {}; //초기화
		FORM_SAVE._mtd         = "saveUpdate";
		FORM_SAVE.tranData     = [
			{outDs : "saveCnt1", _siq : "aps.static.basicWorkCalendarRsc", grdData : salesPlanDatas}
		];
		
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj.do",
			data   : FORM_SAVE,
			success: function(data) {
				alert('<spring:message code="msg.saveOk"/>');
				grdMain.cancel();
				
				$.each(grdData, function(i, row) {
					dataProvider.setRowState(row._ROWNUM-1, 'none',true);
				});
			   
				dataProvider.clearSavePoints();
				dataProvider.savePoint(); //초기화 포인트 저장
				
			}
		}, "obj");
	});
}

function gridCallback(resList) {
	
	
	gfn_service({
	    async   : false,
	    url     : GV_CONTEXT_PATH + "/biz/obj.do",
	    data    : {
   			_mtd : "getList",
   			tranData : [
   				{outDs : "authorityList", _siq : "aps.static.workCalendarRscAuthority"},
                {outDs : "routingList", _siq : "aps.static.workCalendarRsRouting"}
   			]
	    },
	    success :function(data) {
	    	
	    	if(data.authorityList.length != 0)
            {
                
                for(i = 0; i < data.authorityList.length; i++ )
                {
                    // 곹통권한 소유할 경우 Material routing editable 처리
                    if(data.authorityList[i].ROLE_CD == "PRO0009"||data.authorityList[i].ROLE_CD == "PRO0010"||data.authorityList[i].ROLE_CD == "PRO0011" )
                    {
                        data.routingList.push({CODE_CD:"3-R"});
                        data.routingList.push({CODE_CD:"3-W"});
                    }   
                }
                
                
            }
	    	
	    	var dataLen = data.routingList.length;
	    	var fileds = dataProvider.getFields();
			
	    	for(var i = 0; i < dataLen; i++){
	    		
	    		var codeCd = data.routingList[i].CODE_CD;
	    		
	    		$.each(resList, function(n, v){
	    			
                    var routingCd = v.ROUTING_ID;
					for (var j = 2; j < fileds.length; j++) {
						
						var fieldName = fileds[j].fieldName;
						var fields_len = fileds[j];
						
						if (fieldName.indexOf("_A") > -1 || fieldName.indexOf("_B") > -1 ){
							        		
							if(codeCd == routingCd){

								grdMain.setCellStyles(n, fieldName, "editStyle");
							}
							
						}
					}
	    		});
	    	}
    	}
	}, "obj");
}


//리소스 타입 별로 헤더의 TEXT를 변경 처리
function headerTextChange(wcType,columnName){
	
	var header = grdMain.getColumnProperty(columnName, "header" );
	var txt = null;
	
	if(wcType == 'M' ){
		
		switch (columnName) {
	        case "WC_CD"       : txt = '<spring:message code="lbl.wcCd_MACHINE" />';       break;
			case "WC_NM"       : txt = '<spring:message code="lbl.wcNm_MACHINE" />';       break;
			case "RESOURCE_CD" : txt = '<spring:message code="lbl.resourceCd_MACHINE" />'; break;
			case "RESOURCE_NM" : txt = '<spring:message code="lbl.resourceNm_MACHINE" />'; break;	
        }	
		
	}else if(wcType == "L" ){
		
		switch (columnName) {
	        case "WC_CD"       : txt = '<spring:message code="lbl.wcCd_LABOR" />';       break;
			case "WC_NM"       : txt = '<spring:message code="lbl.wcNm_LABOR" />';       break;
			case "RESOURCE_CD" : txt = '<spring:message code="lbl.resourceCd_LABOR" />'; break;
			case "RESOURCE_NM" : txt = '<spring:message code="lbl.resourceNm_LABOR" />'; break;	
        }	
		
	}else{
		
		switch (columnName) {
	        case "WC_CD"       : txt = '<spring:message code="lbl.wcCd_ALL" />';       break;
			case "WC_NM"       : txt = '<spring:message code="lbl.wcNm_ALL" />';       break;
			case "RESOURCE_CD" : txt = '<spring:message code="lbl.resourceCd_ALL" />'; break;
			case "RESOURCE_NM" : txt = '<spring:message code="lbl.resourceNm_ALL" />'; break;	
		}	
	}
	
	header.text = txt;
	grdMain.setColumnProperty(columnName, "header", header);
}

//엑셀, 쿼리 다운로드 권한 확인
function fn_excelSqlAuth() {
	
	gfn_service({
	    async   : false,
	    url     : GV_CONTEXT_PATH + "/biz/obj.do",
	    data    : {
   			_mtd : "getList",
   			popUpMenuCd : popUpMenuCd,
   			tranData : [
   				{outDs : "authorityList", _siq : "aps.static.basicWorkCalendarRscExcelSql"}
   			]
	    },
	    success :function(data) {
	    	
	    	for(i=0;i<data.authorityList.length;i++)
	    	{
	    		if(data.authorityList[i].USE_FLAG == "Y"&&data.authorityList[i].ACTION_CD=="EXCEL")
	    		{
	    			$('#excelSqlContainer').show();
	    			$("#excel").show();
	    		}
	    		else if(data.authorityList[i].USE_FLAG == "Y"&&data.authorityList[i].ACTION_CD=="SQL")
	    		{
	    			$('#excelSqlContainer').show();
	    			$("#sql").show();
	    		}
	    	}
	    		
	    }
	}, "obj");
}


</script>

<style type="text/css">
.locationext .fnc a {display:inline-block;overflow:hidden;height:27px;margin-left:4px;}
.li_none {list-style-type:none;background:white}
</style>
</head>

<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit"><spring:message code="lbl.btnWcCalendarRsc"/></div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
					<div class="srhcondi">
						<ul>
							<li>
								<strong><spring:message code="lbl.prodPart2"/></strong>
								<div class="selectBox">
									<select id="prodPart" name="prodPart" multiple="multiple"></select>
								</div>
							</li>
							<li>
								<strong><spring:message code="lbl.wcMgrNm"/></strong>
								<div class="selectBox">
									<select id="workType" name="workType" multiple="multiple"></select>
								</div>
							</li>
							<li>
								<strong><spring:message code="lbl.prodOrQc"/></strong>
								<div class="selectBox">
									<select id="prodOrQc" name="prodOrQc" multiple="multiple"></select>
								</div>
							</li>
							<li>
								<strong><spring:message code="lbl.resourceGroup"/></strong>
								<div class="selectBox">
									<select id="workplaces" name="workplaces" multiple="multiple"></select>
								</div>
							</li>
							<li id="excelSqlContainer" style="display:none;">
								<div class="locationext">
									<div class="fnc">
										<a href="#" id='excel' style="display:none" class="viewfnc5"><img src="${ctx}/statics/images/common/btn_gun5.gif" title="Excel Download"></a>
							    		<a href="#" id='sql' style="display:none"class="viewfnc4"><img src="${ctx}/statics/images/common/btn_gun4.gif" title="SQL View"></a>
							    		
							    	</div>
								</div>
							</li>
						</ul>
					</div>
				</form>
				<div class="bt_btn">
					<a href="javascript:;" class="fl_app"><spring:message code="lbl.search"/></a>
				</div>
			</div>
			<div id="realgrid" class="realgrid1" height=600></div>
			
		</div>
		<div class="pop_btm">
			<div class="pop_btn_info">
				<strong >Sum  :</strong> <span id="bottom_userSum"></span>
			</div>
			<div class="pop_btn_info">
				<strong >Avg  :</strong> <span id="bottom_userAvg"></span>
			</div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset"/></a>
				<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save"/></a>
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>