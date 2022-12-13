<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<script type="text/javascript">
	
	//전역변수
	var enterSearchFlag = "Y";
	var codeMap, codeReptMap, upperCodeMap;
	var gridInstance, grdMain, dataProvider;
	
	$(function() {
		gfn_formLoad();		//공통 초기화
		fn_initData();		//데이터 초기화
		fn_initFilter();	//필터 초기화
		fn_initGrid();		//그리드 초기화
		fn_initEvent();		//이벤트 초기화
	});
	
	//데이터 초기화
	function fn_initData() {
		// 공통코드 조회 
		codeMap = gfn_getComCode('FLAG_YN', "Y");
		// 대표 품목그룹코드 조회
		codeReptMap = gfn_getComCodeEx(["REP_ITEM_GROUP"]).REP_ITEM_GROUP;
		// 상위 아이템코드 조회
		upperCodeMap = fn_getUpperItemCode();
	}
	
	//상위 아이템코드 조회
	function fn_getUpperItemCode() {
		var rtnMap = [];
		gfn_service({
		    async   : false,
		    url     : GV_CONTEXT_PATH + "/biz/obj",
		    data    : {_mtd:"getList",tranData:[{outDs:"rtnList",_siq:"master.master.reptItemGroupUpperItemCode"}]},
		    success :function(data) {
		    	rtnMap = data.rtnList;
		    }
		}, "obj");
		return rtnMap;
	}
	
	//필터 초기화
	function fn_initFilter() {
		// 콤보박스
		gfn_setMsComboAll([
			{ target : 'divReptItemGroup' , id : 'reptItemGroup' , title : '<spring:message code="lbl.reptItemGroup"/>' , data : codeReptMap    , exData:[] },
			{ target : 'divUpItemGroup', id : 'upperItemGroup', title : '<spring:message code="lbl.upperItemGroup"/>', data : upperCodeMap   , exData:[] },
			{ target : 'divNewItemGroup'  , id : 'newItemGroup'  , title : '<spring:message code="lbl.newItemGroup"/>'  , data : codeMap.FLAG_YN, exData:[], type : "S" }
		]);
	}
	
	//그리드 초기화
	function fn_initGrid() {
		//그리드 설정
		gridInstance = new GRID();
		gridInstance.init("realgrid");
		grdMain	     = gridInstance.objGrid;
		dataProvider = gridInstance.objData;
		
		fn_setFields(dataProvider);
		fn_setColumns(grdMain);
		fn_setOptions(grdMain);
	}
	
	//그리드필드
	function fn_setFields(provider) {
		var fields = [
			{ fieldName : "COMPANY_CD" },
			{ fieldName : "BU_CD" },
			{ fieldName : "UPPER_ITEM_GROUP_CD" },
			{ fieldName : "UPPER_ITEM_GROUP_NM" },
			{ fieldName : "ITEM_GROUP_CD" },
			{ fieldName : "ITEM_GROUP_NM" },
			{ fieldName : "KEY_GROUP_YN" },
			{ fieldName : "REP_ITEM_GROUP_CD" },
			{ fieldName : "MAJOR_GROUP_YN" },
			{ fieldName : "MAJOR_GROUP_NM" },
			{ fieldName : "DEF_RATE_TARGET", dataType : "number" },
			{ fieldName : "MFG_LT_TARGET", dataType : "number" },
			
			{ fieldName : "OTD_YN" },
			{ fieldName : "GR_COMP_YN" },
			
			
			
			
			{ fieldName : "UPDATE_DTTM" },
			{ fieldName : "UPDATE_ID" },
			{ fieldName : "CREATE_DTTM" },
			{ fieldName : "CREATE_ID" },
		];
		dataProvider.setFields(fields);
	}
	
	//그리드컬럼
	function fn_setColumns(grd) {
		var columns = [
			{
				name         : "UPPER_ITEM_GROUP_NM",
				fieldName    : "UPPER_ITEM_GROUP_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.upperItemGroupName"/>' },
				styles       : { textAlignment: "near", background : gv_noneEditColor },
				width        : 150,
			}, {
				name         : "ITEM_GROUP_CD",
				fieldName    : "ITEM_GROUP_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.itemGroup"/>' },
				styles       : { background : gv_noneEditColor, textAlignment: "near" },
				width        : 80,
			}, {
				name         : "ITEM_GROUP_NM",
				fieldName    : "ITEM_GROUP_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.itemGroupName"/>' },
				styles       : { textAlignment: "near", background : gv_noneEditColor },
				width        : 200,
			}, {
				name         : "KEY_GROUP_YN",
				fieldName    : "KEY_GROUP_YN",
				editable     : true,
				header       : { text: '<spring:message code="lbl.key"/>' },
				editor       : { type: "dropDown", domainOnly: true },
				values       : gfn_getArrayExceptInDs(codeMap.FLAG_YN, "CODE_CD", ""),
				labels       : gfn_getArrayExceptInDs(codeMap.FLAG_YN, "CODE_NM", ""),
				nanText      : "",
				lookupDisplay: true,
				width        : 100
			}, {
				name         : "REP_ITEM_GROUP_CD",
				fieldName    : "REP_ITEM_GROUP_CD",
				editable     : true,
				header       : { text: '<spring:message code="lbl.reptItemGroupName"/>' },
				styles       : { textAlignment: "near" },
				editor       : { type: "dropDown", domainOnly: true },
				values       : gfn_getArrayInDs(codeReptMap, "CODE_CD", true),
				labels       : gfn_getArrayInDs(codeReptMap, "CODE_NM", true),
				nanText      : "",
				lookupDisplay: true,
				width        : 150
			}, {
				name         : "MAJOR_GROUP_YN",
				fieldName    : "MAJOR_GROUP_YN",
				editable     : true,
				header       : { text: '<spring:message code="lbl.mainItemGroupYn"/>' },
				editor       : { type: "dropDown", domainOnly: true },
				values       : gfn_getArrayExceptInDs(codeMap.FLAG_YN, "CODE_CD", ""),
				labels       : gfn_getArrayExceptInDs(codeMap.FLAG_YN, "CODE_NM", ""),
				nanText      : "",
				lookupDisplay: true,
				width        : 100
			}, {
				name         : "MAJOR_GROUP_NM",
				fieldName    : "MAJOR_GROUP_NM",
				editable     : true,
				header       : { text: '<spring:message code="lbl.mainItemGroupNm"/>' },
				styles       : { textAlignment: "near" },
				width        : 150
			}, {
				name         : "DEF_RATE_TARGET",
				fieldName    : "DEF_RATE_TARGET",
				editable     : true,
				header       : { text: '<spring:message code="lbl.fqcDef"/>' },
				styles       : { textAlignment: "far", numberFormat: "#,###.0" },
				editor       : { type: "number", positiveOnly: true, editFormat: "#,###.0" },
				width        : 100
			}, {
				name         : "MFG_LT_TARGET",
				fieldName    : "MFG_LT_TARGET",
				editable     : true,
				header       : { text: '<spring:message code="lbl.prodLeadTimeDef"/>' },
				styles       : { textAlignment: "far", numberFormat: "#,###" },
				editor       : { type: "number", positiveOnly: true, editFormat: "#,###" },
				width        : 150
			}, {
				name         : "OTD_YN",
				fieldName    : "OTD_YN",
				editable     : true,
				header       : { text: '<spring:message code="lbl.otdYn"/>' },
				editor       : { type: "dropDown", domainOnly: true },
				values       : gfn_getArrayExceptInDs(codeMap.FLAG_YN, "CODE_CD", ""),
				labels       : gfn_getArrayExceptInDs(codeMap.FLAG_YN, "CODE_NM", ""),
				nanText      : "",
				lookupDisplay: true,
				width        : 100
			}, {
				name         : "GR_COMP_YN",
				fieldName    : "GR_COMP_YN",
				editable     : true,
				header       : { text: '<spring:message code="lbl.grCompYn"/>' },
				editor       : { type: "dropDown", domainOnly: true },
				values       : gfn_getArrayExceptInDs(codeMap.FLAG_YN, "CODE_CD", ""),
				labels       : gfn_getArrayExceptInDs(codeMap.FLAG_YN, "CODE_NM", ""),
				nanText      : "",
				lookupDisplay: true,
				width        : 100
			}, {
				name         : "UPDATE_DTTM",
				fieldName    : "UPDATE_DTTM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.updateDttm"/>' },
				styles       : { background : gv_noneEditColor },
				width        : 120,
			}, {
				name         : "UPDATE_ID",
				fieldName    : "UPDATE_ID",
				editable     : false,
				header       : { text: '<spring:message code="lbl.updateBy"/>' },
				styles       : { background : gv_noneEditColor, textAlignment: "near" },
				width        : 100,
			}, {
				name         : "CREATE_DTTM",
				fieldName    : "CREATE_DTTM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.createDttm"/>' },
				styles       : { background : gv_noneEditColor },
				width        : 120,
			}, {
				name         : "CREATE_ID",
				fieldName    : "CREATE_ID",
				editable     : false,
				header       : { text: '<spring:message code="lbl.createBy"/>' },
				styles       : { background : gv_noneEditColor, textAlignment: "near" },
				width        : 100,
			},
		];
		grdMain.setColumns(columns);
	}
	
	//그리드 옵션
	function fn_setOptions(grd) {
		grd.setOptions({
			stateBar: { visible: true }
		});
	}
	
	//이벤트 초기화
	function fn_initEvent() {
		$(".fl_app"      ).click("on", function() { fn_apply(); });
		$("#btnOpenPopup").click("on", function() { fn_openPopup(); });
		$("#btnOpenMenu" ).click("on", function() { gfn_newTab("MNG101"); });
		$("#btnReset"    ).click("on", function() { fn_reset(); });
		$("#btnSave"     ).click("on", function() { fn_save(); });
	}
	
	//조회
	function fn_apply(sqlFlag) {
		
		//조회조건 설정
		FORM_SEARCH = $("#searchForm").serializeObject();
		
		//그리드 데이터 조회
		fn_getGridData(sqlFlag);
		fn_getExcelData();
	}
	
	//그리드 데이터 조회
	function fn_getGridData(sqlFlag) {
		
		FORM_SEARCH.sql	     = sqlFlag;
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"master.master.reptItemGroup"}];
		
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
			}
		}, "obj");
	}
	
	//팝업 오픈
	function fn_openPopup() {
		gfn_comPopupOpen("MASTER_REPT_ITEM_GROUP_MGMT", {
			rootUrl : "master",
			url     : "reptItemGroupMgmt",
			width   : 800,
			height  : 400,
		});
	}
	
	//팝업 콜백 - 대표 품목그룹코드 재설정
	function fn_popupSaveCallback() {
		
		// 코드 재조회
		codeReptMap = gfn_getComCodeEx(["REP_ITEM_GROUP"]).REP_ITEM_GROUP;
		
		// 콤보박스 재생성
		var reptItemGroupSelects = $('#reptItemGroup').multipleSelect('getSelects');
		gfn_setMsComboAll([
			{ target : 'divReptItemGroup', id : 'reptItemGroup', title : '<spring:message code="lbl.reptItemGroup"/>', data : codeReptMap, exData:[]}
		]);
		$('#reptItemGroup').multipleSelect('setSelects', reptItemGroupSelects);
		
		// 그리드 재설정
		var column = grdMain.columnByName("REP_ITEM_GROUP_CD");
		column.values = gfn_getArrayInDs(codeReptMap, "CODE_CD", ""),
		column.labels = gfn_getArrayInDs(codeReptMap, "CODE_NM", ""),
		grdMain.setColumn(column);
		
		//
		fn_apply();
	}
	
	//그리드 초기화
	function fn_reset() {
		grdMain.cancel();
		dataProvider.rollback(dataProvider.getSavePoints()[0]);
	}
	
	//그리드 저장
	function fn_save() {
		
		//수정된 그리드 데이터
		var grdData = gfn_getGrdSavedataAll(grdMain);
		if (grdData.length == 0) {
			alert('<spring:message code="msg.noChangeData"/>');
			return;
		}
		
		confirm('<spring:message code="msg.saveCfm"/>', function() {
			//저장
			FORM_SAVE          = {}; //초기화
			FORM_SAVE._mtd     = "saveUpdate";
			FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"master.master.reptItemGroup",grdData:grdData}];
			gfn_service({
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SAVE,
				success : function(data) {
					alert('<spring:message code="msg.saveOk"/>');
					fn_apply();
				}
			}, "obj");
		
		});
	}
	
	function fn_checkClose() {
		return gfn_getGrdSaveCount(grdMain) == 0;
	}
	
	function fn_getExcelData(){
		$.each($(".view_combo"), function(i, val){
			
			var temp = "";
			var id = gfn_nvl($(this).attr("id"), "");
			
			if(id != ""){
				
				var name = $("#" + id + " .ilist .itit").html();
				
				//타이틀
				if(i == 0){
					EXCEL_SEARCH_DATA = name + " : ";	
				}else{
					EXCEL_SEARCH_DATA += "\n" + name + " : ";	
				}
				
				//데이터
				if(id == "divReptItemGroup"){
					$.each($("#reptItemGroup option:selected"), function(i2, val2){
						
						var txt = gfn_nvl($(this).text(), "");
						
						if(i2 == 0){
							temp = txt;								
						}else{
							temp += ", " + txt;
						}
					});		
					EXCEL_SEARCH_DATA += temp;
				}else if(id == "divUpItemGroup"){
					$.each($("#upperItemGroup option:selected"), function(i2, val2){
						
						var txt = gfn_nvl($(this).text(), "");
						
						if(i2 == 0){
							temp = txt;								
						}else{
							temp += ", " + txt;
						}
					});		
					EXCEL_SEARCH_DATA += temp;
				}else if(id == "divItemGroup"){
					EXCEL_SEARCH_DATA += $("#itemGroup").val();
				}else if(id == "divNewItemGroup"){
					EXCEL_SEARCH_DATA += $("#newItemGroup option:selected").text();
				}
			}
		});
	}
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<!-- left -->
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
			<div id="filterDv">
				<div class="inner">
					<h3>Filter</h3>
					<div class="tabMargin"></div>
					<div class="scroll">
						<div class="view_combo" id="divReptItemGroup"></div>
						<div class="view_combo" id="divUpItemGroup"></div>
						<div class="view_combo" id="divItemGroup">
							<div class="ilist">
								<div class="itit"><spring:message code="lbl.itemGroup"/></div>
								<input type="text" id="itemGroup" name="itemGroup" class="ipt">
							</div>
						</div>
						<div class="view_combo" id="divNewItemGroup"></div>
					</div>
					<div class="bt_btn">
						<a href="javascript:;" class="fl_app"><spring:message code="lbl.search"/></a>
					</div>
				</div>
			</div>
		</form>
	</div>
	<!-- contents -->
	<div id="b" class="split split-horizontal">
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" class="realgrid1"></div>
			</div>
			<div class="cbt_btn">
				<div class="bleft">
					<a href="javascript:;" id="btnOpenPopup" class="app authClass MNG10501"><spring:message code="lbl.reptItemGroupMgmt"/></a>
					<a href="javascript:;" id="btnOpenMenu" class="app"><spring:message code="lbl.itemMaster"/></a>
				</div>
				<div class="bright">
					<a href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset"/></a>
					<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save"/></a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
