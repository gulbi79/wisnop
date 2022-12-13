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
var codeMap, codeAPMap, codeSalesOrgMap;
var gridInstance, grdMain, dataProvider;
var popUpMenuCd = "${param.menuCd}";

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
		
    grdMain.onEditRowPasted = function(grid, itemIndex, dataRow, fields, oldValues, newValues){
			
		if(newValues.length > 0){

			var newValuesArr = [];
			
			$.each(newValues,function(i,fd){
				if(fd != null && fd != undefined) newValuesArr.push(fd.replace(':',''));
			});
			
			var oldValuesArr = [];
			
			$.each(oldValues,function(i,fd){
				if(fd != null && fd != undefined) oldValuesArr.push(fd);
			});
			
			$.each(fields,function(i,fld){
			
				var field = dataProvider.getFieldName(fld);
				var cols = grid.columnsByField(field);
				var colsName = cols[0].name;
				var fieldName = cols[0].fieldName;
				
				if(newValuesArr[i] != ''){
					if (!$.isNumeric(newValuesArr[i]) || newValuesArr[i] > 2400 ){
				      	 grdMain.setValue(itemIndex, fieldName,oldValuesArr[i]);
				     }else{
				    	 grdMain.setValue(itemIndex, fieldName,newValuesArr[i]);			    	 
				     }
				}
			});
		}
	};			
	
});

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

//데이터 초기화
function fn_initData() {
	// 공통코드 조회 
	var grpCd = 'PROD_PART,PLAN_INFO,WC_SHIFT,PROD_OR_QC,WORK_TYPE';
	
	codeMap = gfn_getComCode(grpCd, 'N'); //공통코드 조회
    codeMapEx = gfn_getComCode('RESOURCE_TYPE,FLAG_YN', 'Y'); //공통코드 조회
}

//필터 초기화
function fn_initFilter() {
	
	gfn_setMsCombo("prodPart",codeMap.PROD_PART, [], {}); 
	gfn_setMsCombo("useYn",codeMapEx.FLAG_YN, [], {});
	gfn_setMsCombo("prodOrQc",codeMap.PROD_OR_QC, [], {}); 
	gfn_setMsCombo("resourceType",codeMapEx.RESOURCE_TYPE, [], {}); 
	
	if($("#useYn").val() == '') $("#useYn").val('Y');
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
	
	grdMain.onValidateColumn = function(grid, column, inserting, value) {
	    var error = {};
        if(value != '' && value != null){
	        value1 = value.substr(0,2);
	        value2 = value.substr(2,2);
	        if (value > 2400 ) {
	            error.level = RealGridJS.ValidationLevel.ERROR;
	            error.message = "24시 이후 시간은 00시로 시작해야 합니다.";
	        } else if (value1 > 24) {
	            error.level = RealGridJS.ValidationLevel.ERROR;
	            error.message = "최대 시간은 24시입니다.";
	        } else if (value2 > 59) {
	            error.level = RealGridJS.ValidationLevel.ERROR;
	            error.message = "최대 분은 59분입니다. ";
	        }
		}
	    return error;
	};
   
	grdMain.setPasteOptions({
		applyNumberFormat: false,
		checkDomainOnly: false,
		checkReadOnly: true,
		commitEdit: true,
		enableAppend: true,
		enabled: true,
		eventEachRow: true, 
		fillColumnDefaults: false,
		fillFieldDefaults: false,
		forceColumnValidation: false,
		forceRowValidation: false,
		noDataEvent: false,
		noEditEvent: false,
		selectBlockPaste: true,
		selectionBase: false,
		singleMode: false,
		startEdit: true,
		stopOnError: true,
		throwValidationError: true,
		numberChars: ","
	});    
}

//그리드필드
function fn_setFields(provider) {
	var fields = [
		{ fieldName : "BU_CD" , dataType : 'text' },
		{ fieldName : "PART_CD" , dataType : 'text' },
		{ fieldName : "PART_CD_NM" , dataType : 'text' },
		{ fieldName : "TIME_TYPE_CD" , dataType : 'text' },
		{ fieldName : "TIME_TYPE_CD_NM" , dataType : 'text' },
		{ fieldName : "POQ_CD" , dataType : 'text' },
		{ fieldName : "POQ_CD_NM" , dataType : 'text' },
		{ fieldName : "RESOURCE_TYPE_CD" , dataType : 'text' },
		{ fieldName : "RESOURCE_TYPE_CD_NM" , dataType : 'text' },
		{ fieldName : "CODE_NM" , dataType : 'text' },
		{ fieldName : "CODE_NM_NM" , dataType : 'text' },
		{ fieldName : "USE_YN_NM" , dataType : 'text' },
		{ fieldName : "START_END_TYPE" , dataType : 'text' },
		{ fieldName : "WORK_A" , dataType : 'text' },
		{ fieldName : "WORK_B" , dataType : 'text' },
		{ fieldName : "HWORK_A" , dataType : 'text' },
		{ fieldName : "HWORK_B" , dataType : 'text' },
	];
	dataProvider.setFields(fields);
}

function fn_setColumns(grd) {
	var columns = [
		{
			name         : "PART_CD",
			fieldName    : "PART_CD_NM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.prodPart2"/>' },
			styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
			width        : 80,
			mergeRule    : { criteria: "value" }
		},
		{
			name         : "POQ_CD",
			fieldName    : "POQ_CD_NM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.prodOrQc"/>' },
			styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
			width        : 80,
			mergeRule    : { criteria: "prevvalues + value" }
		},
		{
			name         : "WC_MGR",
			fieldName    : "RESOURCE_TYPE_CD_NM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.wcMgrNm"/>' },
			styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
			width        : 80,
			mergeRule    : { criteria: "prevvalues + value" }
		},
		{
			name         : "CODE_NM",
			fieldName    : "CODE_NM_NM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.timeName"/>' },
			styles       : { background : "rgba(237, 247, 253, 1)", textAlignment: "near" },
			width        : 100,
			mergeRule    : { criteria: "prevvalues + value" }
		},
		{
			name         : "TIME_TYPE",
			fieldName    : "TIME_TYPE_CD",
			visible      : false,
			header       : { text: '<spring:message code="lbl.timeType"/>' },
			styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)"},
			width        : 100,
			mergeRule    : { criteria: "prevvalues + value" }
		},
		{
			name         : "TIME_TYPE_CD",
			fieldName    : "TIME_TYPE_CD_NM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.timeType"/>' },
			styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)"},
			width        : 100,
			mergeRule    : { criteria: "prevvalues + value" }
		},
		{
			name         : "USE_YN_NM",
			fieldName    : "USE_YN_NM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.useYn"/>' },
			styles       : { textAlignment: "center", background : "rgba(237, 247, 253, 1)"},
			width        : 60,
			//mergeRule    : { criteria: "value" }
		},
		{
			name         : "START_END_TYPE",
			fieldName    : "START_END_TYPE",
			editable     : false,
			header       : { text: '<spring:message code="lbl.startEnd"/>' },
			styles       : { background : "rgba(237, 247, 253, 1)", textAlignment: "near" },
			width        : 80,
		},
		{
			type         : "group",
		    name         : "WORK",
		    orientation  : "horizontal",
		    header       : { text: codeMap.WORK_TYPE[2].CODE_NM },
		    resizable    : true,
		    movable      : false,
		    hideChildHeaders: false,
		    width: 120,
		    columns: [{
			        type: "data",
			        name: "WORK_A",
		            fieldName: "WORK_A",
		            width : "60",
		            editable : false,
		            styles: { "textAlignment": "center" ,background : gv_noneEditColor},
		            header: { "text": codeMap.WC_SHIFT[0].CODE_NM },
		            displayRegExp : "([0-9]{2})([0-9]{2})",
		            displayReplace : "$1:$2",
		            editor : {
		 						type         : "text",
		 						mask:{
		 				            editMask: "00:00",  
		 				            allowEmpty:true
		 				        }, 
		 						integerOnly  : true,
		 						textAlignment: "center"
   				    	    }
		            },
		               {
            	    type: "data",
			        name: "WORK_B",
		            fieldName: "WORK_B",
		            editable : false,
		            width : "60",
		            styles: { "textAlignment": "center" ,background : gv_noneEditColor},
		            header: { "text": codeMap.WC_SHIFT[1].CODE_NM },
		            displayRegExp : "([0-9]{2})([0-9]{2})",
		            displayReplace : "$1:$2",
		            editor : {
		 						type         : "text",
		 						mask:{
		 				            editMask: "00:00",  
		 				            allowEmpty:true
		 				        }, 
		 						integerOnly  : true,
		 						textAlignment: "center"
   				    	    }
		            }]
		    },
		    {
				type         : "group",
			    name         : "HWORK",
			    orientation  : "horizontal",
			    header       : { text: codeMap.WORK_TYPE[1].CODE_NM },
			    resizable    : true,
			    movable      : false,
			    hideChildHeaders: false,
			    width: 120,
			    columns: [{
				        type: "data",
				        name: "HWORK_A",
			            fieldName: "HWORK_A",
			            width : "60",
			            editable : false,
			            styles: { "textAlignment": "center" ,background : gv_noneEditColor},
			            header: { "text": codeMap.WC_SHIFT[0].CODE_NM },
			            displayRegExp : "([0-9]{2})([0-9]{2})",
			            displayReplace : "$1:$2",
			            editor : {
			 						type         : "text",
			 						mask:{
			 				            editMask: "00:00",  
			 				            allowEmpty:true
			 				        }, 
			 						integerOnly  : true,
			 						textAlignment: "center"
	   				    	    }
			            },
			               {
	            	    type: "data",
				        name: "HWORK_B",
			            fieldName: "HWORK_B",
			            editable : false,
			            width : "60",
			            styles: { "textAlignment": "center" ,background : gv_noneEditColor},
			            header: { "text": codeMap.WC_SHIFT[1].CODE_NM },
			            displayRegExp : "([0-9]{2})([0-9]{2})",
			            displayReplace : "$1:$2",
			            editor : {
			 						type         : "text",
			 						mask:{
			 				            editMask: "00:00",  
			 				            allowEmpty:true
			 				        }, 
			 						integerOnly  : true,
			 						textAlignment: "center"
	   				    	    }
			            }]
			    }
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
	
	FORM_SEARCH = $("#searchForm").serializeObject();
	fn_getGridData(sqlFlag);
}

//그리드 데이터 조회
function fn_getGridData(sqlFlag) {
	
	FORM_SEARCH.sql	     = sqlFlag;
	FORM_SEARCH._mtd     = "getList";
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"aps.static.basicWorkCalendar"}];
	
	gfn_service({
		url    : GV_CONTEXT_PATH + "/biz/obj",
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
}

//엑셀, 쿼리 다운로드 권한 확인
function fn_excelSqlAuth() {
	
	gfn_service({
	    async   : false,
	    url     : GV_CONTEXT_PATH + "/biz/obj",
	    data    : {
   			_mtd : "getList",
   			popUpMenuCd : popUpMenuCd,
   			tranData : [
   				{outDs : "authorityList", _siq : "aps.static.basicWorkCalendarExcelSql"}
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
	
	confirm('<spring:message code="msg.saveCfm"/>', function() {
		
		
		// 저장할 데이터 정리
		var salesPlanDatas = [];
		
		$.each(grdData, function(i, row) {
			
			$.each(row, function(attr, value) {
				
				if (attr.indexOf("_A") > -1 || attr.indexOf("_B") > -1 ){
					
					var tmp = attr.split("_")[0];
					var spType = attr.split("_")[1];
					var day_nm = tmp;
					
					if (typeof value !=  "undefined" ){
						
						if(value == null ) value ='';
						
						var planData = {
							PROD_PART : row.PART_CD,
							WC_TIME_CD : row.CODE_NM,
							TIME_TYPE_CD  : row.TIME_TYPE_CD,
							POQ_CD : row.POQ_CD,
							RESOURCE_TYPE_CD : row.RESOURCE_TYPE_CD,
							WC_SHIFT  : null,
							DAY_OFF_FLAG  : null,
							START_TIME : 'undefined', 
							END_TIME  : 'undefined'
						};
						 
						planData.WC_SHIFT  = spType;
						 
						if(tmp == "WORK"){
							planData.DAY_OFF_FLAG  = codeMap.WORK_TYPE[2].CODE_CD;
						}else{
					    	planData.DAY_OFF_FLAG  = codeMap.WORK_TYPE[1].CODE_CD;
					    }
					    						
						var find_idx = null;
						for(i=0;i<salesPlanDatas.length;i++){
							 
							 if( salesPlanDatas[i].PROD_PART == planData.PROD_PART 
								 && salesPlanDatas[i].WC_TIME_CD == planData.WC_TIME_CD	 
								 && salesPlanDatas[i].TIME_TYPE_CD == planData.TIME_TYPE_CD
								 && salesPlanDatas[i].POQ_CD == planData.POQ_CD
								 && salesPlanDatas[i].RESOURCE_TYPE_CD == planData.RESOURCE_TYPE_CD
								 && salesPlanDatas[i].WC_SHIFT == planData.WC_SHIFT
								 && salesPlanDatas[i].DAY_OFF_FLAG == planData.DAY_OFF_FLAG
								 
							   ){
								   find_idx = i;
								   break;
							   }
						 }
						 
						 if(find_idx != null){
							 if(row.START_END_TYPE == 'Start' )    salesPlanDatas[i].START_TIME = value;
							 else if(row.START_END_TYPE == 'End' ) salesPlanDatas[i].END_TIME = value;
						 }else{
							 if(row.START_END_TYPE == 'Start' ) planData.START_TIME = value;
							 else if(row.START_END_TYPE == 'End' ) planData.END_TIME   = value;
						     
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
			{outDs : "saveCnt1", _siq : "aps.static.basicWorkCalendar", grdData : salesPlanDatas}
		];
		
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj",
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
	    url     : GV_CONTEXT_PATH + "/biz/obj",
	    data    : {
   			_mtd : "getList",
   			tranData : [
   				{outDs : "authorityList", _siq : "aps.static.workCalendarAuthority"}
   			]
	    },
	    success :function(data) {
	    	
	    	var dataLen = data.authorityList.length;
	    	var fileds = dataProvider.getFields();
			
	    	for(var i = 0; i < dataLen; i++){
	    		
	    		var menuCd = data.authorityList[i].MENU_CD;
	    		
	    		$.each(resList, function(n, v){
	    			
	    			var prodPart = v.PART_CD;
	    			var poqCd = v.POQ_CD;
	    			
					for (var j = 2; j < fileds.length; j++) {
						
						var fieldName = fileds[j].fieldName;
						var fields_len = fileds[j];
						
						if (fieldName != 'PART_CD_NM' && fieldName != 'POQ_CD_NM' && fieldName != 'TIME_TYPE' && fieldName != 'RESOURCE_TYPE_CD_NM' && fieldName != 'TIME_TYPE_CD_NM'  && fieldName != 'CODE_NM_NM' && fieldName != 'CODE_CD' && fieldName != 'USE_YN_NM' && fieldName != 'TIME_TYPE_CD' && fieldName != 'START_END_TYPE' ){
							            
							if((menuCd == "APS10102" && prodPart == "DIFFUSION")
                                    || (menuCd == "APS10102" && prodPart == "MATERIAL")
                                    || (menuCd == "APS10103" && prodPart == "LAM")
                                    || (menuCd == "APS10103" && prodPart == "MATERIAL")
                                    || (menuCd == "APS10104" && prodPart == "TEL")
                                    || (menuCd == "APS10104" && prodPart == "MATERIAL")                                             
                            ){
				        		grdMain.setCellStyles(n, fieldName, "editStyle");
			    			}
						}
					}
	    		});
	    	}
    	}
	}, "obj");
}

var lv_conFirmFlag = true;
$("document").ready(function () {

	$(".viewfnc5").click("on", function() {
		gfn_doExportExcel({fileNm:"${menuInfo.menuNm}", conFirmFlag: lv_conFirmFlag}); 
		$(".pClose").click(function() {
			console.log(".pClose clicked");
			$("#divTempLayerPopup").hide();
			$(".back").hide();
		});
	    $(".popClose").click(function() {
	    	console.log(".popClose clicked");
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


</script>

<style type="text/css">
.locationext .fnc a {display:inline-block;overflow:hidden;height:27px;margin-left:4px;}
.li_none {list-style-type:none;background:white}
</style>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit"><spring:message code="lbl.btnWcCalendar"/></div>
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
									<select id="resourceType" name="resourceType" ></select>
								</div>
							</li>
							<li>
								<strong><spring:message code="lbl.prodOrQc"/></strong>
								<div class="selectBox">
									<select id="prodOrQc" name="prodOrQc" multiple="multiple"></select>
								</div>
							</li>
							<li>
								<strong><spring:message code="lbl.useYn"/></strong>
								<div class="selectBox">
									<select id="useYn" name="useYn" ></select>
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
			<div id="realgrid" class="realgrid1" height="600"></div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset"/></a>
				<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save"/></a>
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>
