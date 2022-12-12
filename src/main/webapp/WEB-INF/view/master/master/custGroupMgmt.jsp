<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<script type="text/javascript">
	
	//전역변수
	var enterSearchFlag = "Y";
	var codeMap;
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
		//거래처그룹 조회
		fn_getCustGroup();
	}
	
	//거래처그룹 조회
	function fn_getCustGroup() {
		gfn_service({
		    async   : false,
		    url     : GV_CONTEXT_PATH + "/biz/obj.do",
		    data    : {_mtd:"getList",tranData:[{outDs:"rtnList",_siq:"master.master.custGroupMgmtCustGroup"}]},
		    success :function(data) {
		    	codeMap.CUST = data.rtnList;
		    }
		}, "obj");
	}
	
	//필터 초기화
	function fn_initFilter() {
		// 콤보박스
		gfn_setMsComboAll([
			{ target : 'divValidYnErp', id : 'validYnErp', title : '<spring:message code="lbl.validYnErp"/>', data : codeMap.FLAG_YN, exData:[], type : "S" }
		]);
		$("#validYnErp").val("Y");
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
			{ fieldName : "REP_CUST_CD" },
			{ fieldName : "REP_CUST_NM" },
			{ fieldName : "CUST_GROUP_CD" },
			{ fieldName : "CUST_GROUP_NM" },
			{ fieldName : "REP_CUST_GROUP_CD" },
			{ fieldName : "REP_CUST_GROUP_NM" },
			{ fieldName : "VALID_FLAG" },
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
				name         : "REP_CUST_CD",
				fieldName    : "REP_CUST_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.reptCust"/>' },
				styles       : { background : gv_noneEditColor, textAlignment: "near" },
				width        : 80,
			},
			{
				name         : "REP_CUST_NM",
				fieldName    : "REP_CUST_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.reptCustName"/>' },
				styles       : { textAlignment: "near", background : gv_noneEditColor },
				width        : 150,
			},
			{
				name         : "CUST_GROUP_CD",
				fieldName    : "CUST_GROUP_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.custGroup"/>' },
				styles       : { background : gv_noneEditColor, textAlignment: "near" },
				width        : 80,
			},
			{
				name         : "CUST_GROUP_CD",
				fieldName    : "CUST_GROUP_CD",
				tag          : "CUST_GROUP_CD",
				editable     : true,
				header       : { text: '<spring:message code="lbl.custGroupName"/>' },
				styles       : { textAlignment: "near" },
				editor       : { type: "dropDown", domainOnly: true },
				values       : gfn_getArrayInDs(codeMap.CUST, "CODE_CD", true),
				labels       : gfn_getArrayInDs(codeMap.CUST, "CODE_NM", true),
				nanText      : "",
				lookupDisplay: true,
				width        : 150
			},
			{
				name         : "REP_CUST_GROUP_CD",
				fieldName    : "REP_CUST_GROUP_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.reptCustGroup"/>' },
				styles       : { background : gv_noneEditColor, textAlignment: "near" },
				width        : 100,
			},
			{
				name         : "REP_CUST_GROUP_NM",
				fieldName    : "REP_CUST_GROUP_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.reptCustGroupName"/>' },
				styles       : { textAlignment: "near", background : gv_noneEditColor },
				width        : 150,
			},
			{
				name         : "VALID_FLAG",
				fieldName    : "VALID_FLAG",
				editable     : false,
				header       : { text: '<spring:message code="lbl.validYnErp"/>' },
				styles       : { background : gv_noneEditColor },
				renderer     : gfn_getRenderer("CHECK",{editable:false}),
				width        : 100,
			},
			{
				name         : "UPDATE_DTTM",
				fieldName    : "UPDATE_DTTM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.updateDttm"/>' },
				styles       : { background : gv_noneEditColor },
				width        : 120,
			},
			{
				name         : "UPDATE_ID",
				fieldName    : "UPDATE_ID",
				editable     : false,
				header       : { text: '<spring:message code="lbl.updateBy"/>' },
				styles       : { background : gv_noneEditColor, textAlignment: "near" },
				width        : 100,
			},
			{
				name         : "CREATE_DTTM",
				fieldName    : "CREATE_DTTM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.createDttm"/>' },
				styles       : { background : gv_noneEditColor },
				width        : 120,
			},
			{
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
		
		//버튼 이벤트
		$(".fl_app"  ).click("on", function() { fn_apply(); });
		$("#btnOpen1").click("on", function() { fn_openPopup("01"); });
		$("#btnOpen2").click("on", function() { fn_openPopup("02"); });
		$("#btnOpen3").click("on", function() { fn_openPopup("03"); });
		$("#btnReset").click("on", function() { fn_reset(); });
		$("#btnSave" ).click("on", function() { fn_save(); });
		
		//그리드 이벤트
		grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
			fn_changeCustGroup(field, dataRow, newValue);
		};
        
        grdMain.onEditRowPasted = function(grid, itemIndex, dataRow, fields, oldValues, newValues) {
        	if (fields.length == newValues.length) {
        		fn_changeCustGroup(fields, dataRow, newValues);
    	    } else {
    	    	var arrNewVal = [];
	    	    $.each(fields, function(n,v) {
	    	    	arrNewVal.push(newValues[v]);
	    	    });
	    	    fn_changeCustGroup(fields, dataRow, arrNewVal);
    	    }
        };
	}
	
	function fn_changeCustGroup(field, dataRow, newValue) {
		if ($.isArray(field)) {
			$.each(field, function(n,v) {
				if (dataProvider.getFieldName(field[n]) == "CUST_GROUP_CD") {
					fn_setChangeCustGroup(dataRow, newValue[n]);
				}
			});
		} else {
			if (dataProvider.getFieldName(field) == "CUST_GROUP_CD") {
				fn_setChangeCustGroup(dataRow, newValue);
			}
		}
	}
	
	function fn_setChangeCustGroup(dataRow, newValue) {
		
		var isSearch = false;
		$.each(codeMap.CUST, function(idx, item) {
			if (newValue == item.CODE_CD) {
				dataProvider.setValue(dataRow, "CUST_GROUP_NM"    , item.CODE_NM);
				dataProvider.setValue(dataRow, "REP_CUST_GROUP_CD", item.REPT_CD);
				dataProvider.setValue(dataRow, "REP_CUST_GROUP_NM", item.REPT_NM);
				isSearch = true;
				return false;
			}
		});
		if (!isSearch) {
			dataProvider.setValue(dataRow, "CUST_GROUP_NM"    , "");
			dataProvider.setValue(dataRow, "REP_CUST_GROUP_CD", "");
			dataProvider.setValue(dataRow, "REP_CUST_GROUP_NM", "");
		}
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
		FORM_SEARCH.hrcyFlag = true;
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"master.master.custGroupMgmt"}];
		
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
			}
		}, "obj");
	}
	
	//팝업 오픈
	function fn_openPopup(type) {
		if (type == "01") {
			gfn_comPopupOpen("MASTER_CUST_GROUP", {
				rootUrl : "master",
				url     : "custGroup",
				width   : 1150,
				height  : 680,
				menuCd : "MNG10801"
			});
		} else if (type == "02") {
			gfn_comPopupOpen("MASTER_CUST_GROUP_MAPPING", {
				rootUrl : "master",
				url     : "custGroupMapping",
				width   : 1150,
				height  : 680,
				menuCd : "MNG10802"
			});
		} else if (type == "03") {
			gfn_comPopupOpen("MASTER_REPT_CUST_GROUP", {
				rootUrl : "master",
				url     : "reptCustGroupMgmt",
				width   : 1150,
				height  : 680,
				menuCd : "MNG10803"
			});
		}
	}
	
	//팝업 콜백
	function fn_popupSaveCallback(type) {
		
		if (type == "R") {
			//거래처그룹 조회
			fn_getCustGroup();
			// 그리드 재설정
			var column = grdMain.columnByTag("CUST_GROUP_CD");
			column.values = gfn_getArrayInDs(codeMap.CUST, "CODE_CD", true),
			column.labels = gfn_getArrayInDs(codeMap.CUST, "CODE_NM", true),
			grdMain.setColumn(column);
		}
		
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
			FORM_SAVE.tranData = [
				{outDs:"saveCnt1",_siq:"master.master.custGroupMgmt"   ,grdData:grdData},
				{outDs:"saveCnt2",_siq:"master.master.custGroupMgmtPro",grdData:[{state:"updated"}]}
			];
			gfn_service({
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
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
		
		EXCEL_SEARCH_DATA = "";
		EXCEL_SEARCH_DATA += "Customer" + " : ";
		EXCEL_SEARCH_DATA += $("#loc_customer").html();
		
		$.each($(".view_combo"), function(i, val){
			
			var temp = "";
			var id = gfn_nvl($(this).attr("id"), "");
			
			if(id != ""){
				
				var name = $("#" + id + " .ilist .itit").html();
				
				//타이틀
				EXCEL_SEARCH_DATA += "\n" + name + " : ";	
				
				//데이터
				if(id == "divReptCust"){
					EXCEL_SEARCH_DATA += $("#reptCust").val();
				}else if(id == "divValidYnErp"){
					EXCEL_SEARCH_DATA += $("#validYnErp option:selected").text();
				}
			}
		});
	}
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<!-- left -->
	<div id="a" class="split split-horizontal">
		<!-- tree -->
		<div id="c" class="split content">
			<%@ include file="/WEB-INF/view/common/leftTree.jsp" %>
		</div>
		<!-- filter -->
		<div id="d" class="split content">
			<form id="searchForm" name="searchForm">
				<div id="filterDv">
					<div class="inner">
						<h3>Filter</h3>
						<div class="tabMargin"></div>
						<div class="scroll">
							<div class="view_combo" id="divReptCust">
								<div class="ilist">
									<div class="itit"><spring:message code="lbl.reptCust"/></div>
									<input type="text" id="reptCust" name="reptCust" class="ipt">
								</div>
							</div>
							<div class="view_combo" id="divValidYnErp"></div>
						</div>
						<div class="bt_btn">
							<a href="javascript:;" class="fl_app"><spring:message code="lbl.search"/></a>
						</div>
					</div>
				</div>
			</form>
		</div>
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
					<a href="javascript:;" id="btnOpen1" class="app authClass MNG10801"><spring:message code="lbl.custGroup"/></a>
					<a href="javascript:;" id="btnOpen2" class="app authClass MNG10802"><spring:message code="lbl.custGroupMapping"/></a>
					<a href="javascript:;" id="btnOpen3" class="app authClass MNG10803"><spring:message code="lbl.reptCustGroup"/></a>
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
