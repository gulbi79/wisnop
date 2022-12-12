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

$("document").ready(function (){
	gfn_popresize();
	fn_initData();
	fn_initFilter();
	fn_initGrid();
	fn_initEvent();
	fn_apply();
});

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

//데이터 초기화
function fn_initData() {
	// 공통코드 조회 
	var grpCd = 'FLAG_YN';
	
	codeMap = gfn_getComCode(grpCd, 'N'); //공통코드 조회
}


//필터 초기화
function fn_initFilter() {
	
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
	
}

//그리드필드
function fn_setFields(provider) {
	var fields = [
		
		{ fieldName : "PROD_PART" , dataType : 'text' },
		{ fieldName : "WC_MGR" , dataType : 'text' },
		{ fieldName : "WC_MGR_NM" , dataType : 'text' },
		{ fieldName : "A" , dataType : 'text' },
		{ fieldName : "B" , dataType : 'text' }
		
	];
	dataProvider.setFields(fields);
}

//그리드컬럼
function fn_setColumns(grd) {
	var columns = [
		{
			name         : "PROD_PART",
			fieldName    : "PROD_PART",
			editable     : false,
			header       : { text: '<spring:message code="lbl.prodPart"/>' },
			styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
			width        : 80,
			mergeRule    : {
                criteria: "value"
             }
		},
		{
			name         : "WC_MGR",
			fieldName    : "WC_MGR",
			editable     : false,
			header       : { text: '<spring:message code="lbl.wcMgrNm"/>' },
			visible      : false,
			styles       : { background : "rgba(237, 247, 253, 1)", textAlignment: "near" },
			width        : 100,
		},
		{
			name         : "WC_MGR_NM",
			fieldName    : "WC_MGR_NM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.wcMgrNm"/>' },
			styles       : { background : "rgba(237, 247, 253, 1)", textAlignment: "near" },
			width        : 100,
		},
		{
			name         : "A",
			fieldName    : "A",
			type         : "data",
			editable     : false,
			header       : { text: 'A' },
			styles       : { background : "rgba(237, 247, 253, 1)", textAlignment: "near" },
			width        : 100,
			lookupDisplay : true,
	        editor: {
	            "type": "dropDown",
	            "dropDownCount": 2,
	            "textAlignment": "center",
	            "domainOnly": true,
	            "values": [
	                "Y",
	                "N"
	            ],
	            "labels": [
	                "Y",
	                "N"
	            ]
	        },
	        "styles": {
	            "textAlignment": "center"
	        }
			
		},
		{
			name         : "B",
			fieldName    : "B",
			editable     : false,
			header       : { text: 'B' },
			styles       : { background : "rgba(237, 247, 253, 1)", textAlignment: "near" },
			width        : 100,
			lookupDisplay : true,
	        editor: {
	            "type": "dropDown",
	            "dropDownCount": 2,
	            "domainOnly": true,
	            "textAlignment": "center",
	            "values": [
	                "Y",
	                "N"
	            ],
	            "labels": [
	                "Y",
	                "N"
	            ]
	        },
	        "styles": {
	            "textAlignment": "center"
	        }
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
	
	document.getElementById("realgrid").style.height = "193px"  
	document.getElementById("realgrid").style.width = "442px"
	grdMain.resetSize();
	
}

//그리드 데이터 조회
function fn_getGridData(sqlFlag) {
	
	FORM_SEARCH.sql	     = sqlFlag;
	FORM_SEARCH._mtd     = "getList";
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"aps.static.workCalendarShift"}];
	
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
				
				if (attr == 'A' || attr == 'B' ){
					if (value !=  undefined && value !=''){
						var planData = {
							PROD_PART : row.PROD_PART,
							WC_MGR : row.WC_MGR,
							WC_SHIFT : attr,
							VALID_FLAG : value, 
						};
						 salesPlanDatas.push(planData);
					}
				} 
			});
		});
		
		FORM_SAVE              = {}; //초기화
		FORM_SAVE._mtd         = "saveUpdate";
		FORM_SAVE.tranData     = [
			{outDs : "saveCnt1", _siq : "aps.static.workCalendarShift", grdData : salesPlanDatas}
		];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj.do",
			data   : FORM_SAVE,
			success: function(data) {
				alert('<spring:message code="msg.saveOk"/>');
				fn_apply();
				
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
   				{outDs : "authorityList", _siq : "aps.static.workCalendarRscAuthority"}
   			]
	    },
	    success :function(data) {
	    	
	    	var dataLen = data.authorityList.length;
	    	var fileds = dataProvider.getFields();
			
	    	for(var i = 0; i < dataLen; i++){
	    		
	    		var menuCd = data.authorityList[i].MENU_CD;
	    		
	    		$.each(resList, function(n, v){
	    			
	    			var prodPart = v.PROD_PART;
	    			
					for (var j = 2; j < fileds.length; j++) {
						
						var fieldName = fileds[j].fieldName;
						var fields_len = fileds[j];
						
						if (fieldName == 'A' || fieldName == 'B'){
							        		
				        	if((menuCd == "APS10402" && prodPart == "LAM") || (menuCd == "APS10403" && prodPart == "TEL") || (menuCd == "APS10404" && prodPart == "DIFFUSION") || (menuCd == "APS10406" && prodPart == "MATERIAL")){ //LAM 생산
				        		grdMain.setCellStyles(n, fieldName, "editStyle");
			    			}
						}
					}
	    		});
	    	}
    	}
	}, "obj");
}

</script>

</head>

<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit"><spring:message code="lbl.btnShiftMgmt"/></div>
		<div class="popCont">
			<div id="realgrid" class="realgrid1" ></div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset"/></a>
				<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save"/></a>
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>