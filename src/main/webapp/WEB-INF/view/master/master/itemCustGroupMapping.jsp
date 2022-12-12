<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<script type="text/javascript">
	
	//전역변수
	var enterSearchFlag = "Y";
	var codeMap, codeAPMap, codeSalesOrgMap, userRoleMap;
	var gridInstance, grdMain, dataProvider;
	
	
	$(document).ready(function(){
		fn_predData();
		gfn_formLoad();		//공통 초기화
		fn_initData();		//데이터 초기화
		fn_initFilter();	//필터 초기화
		fn_initGrid();		//그리드 초기화
		fn_initEvent();		//이벤트 초기화
	});
	
	// 사용자 롤체크 (해당 함수가 선행되어야 함)
	function fn_predData() {
		gfn_service({
		    async   : false,
		    url     : GV_CONTEXT_PATH + "/biz/obj.do",
		    data    : {
		    	_mtd:"getList",
		    	tranData:[
		    		{outDs:"roleList",_siq:"master.master.itemCustGroupMappingUserRole"}
		    	]
		    },
		    success :function(data) {
		    	userRoleMap = data;
		    	
		    	
		    	var list     = data.roleList;
				var roleCnt  = list.length;
				var checkStr = "";
				
				for(var i=0; i < roleCnt; i++) {
					var roleCd = list[i].ROLE_CD;
					
					if(list[i].ROLE_CD == "AP1QT0001") {
						// AP1
						checkStr += "A";
					} else if(list[i].ROLE_CD == "AP2QT0001") {
						// AP2
						checkStr += "B";
					} else {
						// 기존로직 태움
						checkStr += "C";
					}
				}
				
				if(checkStr.indexOf("C") > -1) {
					userRoleMap.CHECK_ROLE = "OTH";
				} else {
					if(checkStr.indexOf("B") > -1) {
						userRoleMap.CHECK_ROLE = "AP2";
					} else {
						if(checkStr.indexOf("A") > -1) {
							userRoleMap.CHECK_ROLE = "AP1";
						}
					}
				}
		    	
		    }
		}, "obj");
	}
	
	//데이터 초기화
	function fn_initData() {
		// 공통코드 조회 
		codeMap = gfn_getComCode('FLAG_YN', "Y");
		// AP1 & AP2 담당자 조회
		codeAPMap = fn_getAuthList();
		// Sales Org 조회
		codeSalesOrgMap = fn_getSalesOrg();
	}
	
	//AP1 & AP2 담당자 조회
	function fn_getAuthList() {
		var rtnMap = {};
		gfn_service({
		    async   : false,
		    url     : GV_CONTEXT_PATH + "/biz/obj.do",
		    data    : {
		    	_mtd:"getList",
		    	CHECK_ROLE : userRoleMap.CHECK_ROLE,
		    	tranData:[
		    		{outDs:"ap1List",_siq:"master.master.itemCustGroupMappingAuthAp1"},
		    		{outDs:"ap2List",_siq:"master.master.itemCustGroupMappingAuthAp2"}
		    	]
		    },
		    success :function(data) {
		    	rtnMap.AP1 = data.ap1List;
		    	rtnMap.AP2 = data.ap2List;
		    }
		}, "obj");
		return rtnMap;
	}
	
	function fn_getSalesOrg() {
		var rtnMap = {};
		gfn_service({
		    async   : false,
		    url     : GV_CONTEXT_PATH + "/biz/obj.do",
		    data    : {
		    	_mtd:"getList",
		    	tranData:[
		    		{outDs:"orgList",_siq:"master.master.itemCustGroupMappingSalesOrg"}
		    	]
		    },
		    success :function(data) {
		    	rtnMap.ORG = data.orgList;
		    }
		}, "obj");
		return rtnMap;
	}
	
	//필터 초기화
	function fn_initFilter() {
		
		// 키워드팝업
		gfn_keyPopAddEvent([
			{ target : 'divItem', id : 'item', type : 'COM_ITEM_PLAN', title : '<spring:message code="lbl.item"/>' }
		]);
		
		if(userRoleMap.CHECK_ROLE == "OTH" || userRoleMap.CHECK_ROLE == undefined) {
			// 콤보박스
			gfn_setMsComboAll([
				{ target : 'divAp1Pic'      , id : 'ap1Pic'      , title : '<spring:message code="lbl.ap1Pic"/>'      , data : codeAPMap.AP1  , exData:[] },
				{ target : 'divAp2Pic'      , id : 'ap2Pic'      , title : '<spring:message code="lbl.ap2Pic"/>'      , data : codeAPMap.AP2  , exData:[] },
				{ target : 'divSalesPlanYn' , id : 'salesPlanYn' , title : '<spring:message code="lbl.salesPlanYn"/>' , data : codeMap.FLAG_YN, exData:[], type : "S" },
				{ target : 'divSalesPriceYn', id : 'salesPriceYn', title : '<spring:message code="lbl.salesPriceYn"/>', data : codeMap.FLAG_YN, exData:[], type : "S" },
				{ target : 'divValidYnErp'  , id : 'validYnErp'  , title : '<spring:message code="lbl.validYnErp"/>'  , data : codeMap.FLAG_YN, exData:[], type : "S" },
			]);
		} else if(userRoleMap.CHECK_ROLE == "AP1") {
			// 콤보박스
			gfn_setMsComboAll([
				{ target : 'divSalesPlanYn' , id : 'salesPlanYn' , title : '<spring:message code="lbl.salesPlanYn"/>' , data : codeMap.FLAG_YN, exData:[], type : "S" },
				{ target : 'divSalesPriceYn', id : 'salesPriceYn', title : '<spring:message code="lbl.salesPriceYn"/>', data : codeMap.FLAG_YN, exData:[], type : "S" },
				{ target : 'divValidYnErp'  , id : 'validYnErp'  , title : '<spring:message code="lbl.validYnErp"/>'  , data : codeMap.FLAG_YN, exData:[], type : "S" },
			]);
		} else if(userRoleMap.CHECK_ROLE == "AP2") {
			// 콤보박스
			gfn_setMsComboAll([
				{ target : 'divAp1Pic'      , id : 'ap1Pic'      , title : '<spring:message code="lbl.ap1Pic"/>'      , data : codeAPMap.AP1  , exData:[] },
				{ target : 'divSalesPlanYn' , id : 'salesPlanYn' , title : '<spring:message code="lbl.salesPlanYn"/>' , data : codeMap.FLAG_YN, exData:[], type : "S" },
				{ target : 'divSalesPriceYn', id : 'salesPriceYn', title : '<spring:message code="lbl.salesPriceYn"/>', data : codeMap.FLAG_YN, exData:[], type : "S" },
				{ target : 'divValidYnErp'  , id : 'validYnErp'  , title : '<spring:message code="lbl.validYnErp"/>'  , data : codeMap.FLAG_YN, exData:[], type : "S" },
			]);
		}
		
		
		// 초기값
		$("#salesPlanYn,#validYnErp").val("Y");
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
			{ fieldName : "ITEM_CD" },
			{ fieldName : "ITEM_NM" },
			{ fieldName : "SPEC" },
			{ fieldName : "DRAW_NO" },
			{ fieldName : "CUST_GROUP_CD" },
			{ fieldName : "CUST_GROUP_NM" },
			{ fieldName : "SALES_ORG_CD" },
			{ fieldName : "AP1_PIC_CNT" },
			{ fieldName : "AP1_PIC" },
			{ fieldName : "AP1_PIC_BAK" },
			{ fieldName : "AP2_PIC" },
			{ fieldName : "SALES_PLAN_YN" },
			{ fieldName : "REMARK" },
			{ fieldName : "SALES_PRICE_CURRENCY" },
			{ fieldName : "SALES_PRICE", dataType : "number" },
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
				name         : "ITEM_CD",
				fieldName    : "ITEM_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.item"/>' },
				styles       : { background : gv_noneEditColor, textAlignment: "near" },
				width        : 80,
			},
			{
				name         : "ITEM_NM",
				fieldName    : "ITEM_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.itemName"/>' },
				styles       : { textAlignment: "near", background : gv_noneEditColor },
				width        : 150,
			},
			{
				name         : "SPEC",
				fieldName    : "SPEC",
				editable     : false,
				header       : { text: '<spring:message code="lbl.spec"/>' },
				styles       : { textAlignment: "near", background : gv_noneEditColor },
				width        : 150,
			},
			{
				name         : "DRAW_NO",
				fieldName    : "DRAW_NO",
				editable     : false,
				header       : { text: '<spring:message code="lbl.drawNo"/>' },
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
				name         : "CUST_GROUP_NM",
				fieldName    : "CUST_GROUP_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.custGroupName"/>' },
				styles       : { textAlignment: "near", background : gv_noneEditColor },
				width        : 150,
			},
			{
				name         : "SALES_ORG_CD",
				fieldName    : "SALES_ORG_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.salesOrgL5Name"/>' },
				styles       : { textAlignment: "near", background : gv_noneEditColor },
				editor       : { type: "dropDown", domainOnly: true },
				values       : gfn_getArrayExceptInDs(codeSalesOrgMap.ORG, "CODE_CD", ""),
				labels       : gfn_getArrayExceptInDs(codeSalesOrgMap.ORG, "CODE_NM", ""),
				nanText      : "",
				lookupDisplay: true,
				width        : 150
			},
			{
				name         : "AP1_PIC_CNT",
				fieldName    : "AP1_PIC_CNT",
				editable     : false,
				header       : { text: '<spring:message code="lbl.ap1PicCnt"/>' },
				styles       : { textAlignment: "far", background : gv_noneEditColor },
				width        : 80,
			},
			{
				name         : "AP1_PIC",
				fieldName    : "AP1_PIC",
				editable     : true,
				header       : { text: '<spring:message code="lbl.ap1PicName"/>' },
				styles       : { textAlignment: "near" },
				editor       : {
					type         : "multicheck",
					showAllCheck : false,
					showButtons  : false,
					domainOnly   : true
				},
				values       : gfn_getArrayExceptInDs(codeAPMap.AP1, "CODE_CD", ""),
				labels       : gfn_getArrayExceptInDs(codeAPMap.AP1, "CODE_NM", ""),
				nanText      : "",
				valueSeparator: ",",
				lookupDisplay: true,
				width        : 150
			},
			{
				name         : "AP2_PIC",
				fieldName    : "AP2_PIC",
				editable     : false,
				header       : { text: '<spring:message code="lbl.ap2PicName"/>' },
				styles       : { textAlignment: "near", background : gv_noneEditColor },
				editor       : {
					type         : "multicheck",
					showAllCheck : false,
					showButtons  : false,
					domainOnly   : true
				},
				values       : gfn_getArrayExceptInDs(codeAPMap.AP2, "CODE_CD", ""),
				labels       : gfn_getArrayExceptInDs(codeAPMap.AP2, "CODE_NM", ""),
				nanText      : "",
				valueSeparator: ",",
				lookupDisplay: true,
				width        : 150
			},
			{
				name         : "SALES_PLAN_YN",
				fieldName    : "SALES_PLAN_YN",
				editable     : false,
				header       : { text: '<spring:message code="lbl.salesPlanYn"/>', checkLocation: "left" },
				styles       : { textAlignment: "near" },
				renderer     : gfn_getRenderer("CHECK"),
				width        : 100,
			},
			{
				name         : "REMARK",
				fieldName    : "REMARK",
				editable     : true,
				header       : { text: '<spring:message code="lbl.remark"/>' },
				styles       : { textAlignment: "near" },
				width        : 150,
			},
			{
				name         : "SALES_PRICE_CURRENCY",
				fieldName    : "SALES_PRICE_CURRENCY",
				editable     : false,
				header       : { text: '<spring:message code="lbl.salesPriceCurrency"/>' },
				styles       : { background : gv_noneEditColor },
				width        : 80,
			},
			{
				name         : "SALES_PRICE",
				fieldName    : "SALES_PRICE",
				editable     : false,
				header       : { text: '<spring:message code="lbl.salesPrice"/>' },
				styles       : { textAlignment: "far", background : gv_noneEditColor, numberFormat : $("#comBucketMask").val() },
				width        : 80,
			},
			{
				name         : "VALID_FLAG",
				fieldName    : "VALID_FLAG",
				editable     : false,
				header       : { text: '<spring:message code="lbl.validYnErp"/>' },
				styles       : { textAlignment: "near", background : gv_noneEditColor },
				renderer     : gfn_getRenderer("CHECK",{editable:false}),
				width        : 80,
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
		$(".fl_app"         ).click("on", function() { fn_apply(); });
		$("#btnOpenPopupAP2").click("on", function() { fn_openPopup("AP2"); });
		$("#btnOpenPopupAP1").click("on", function() { fn_openPopup("AP1"); });
		$("#btnReset"       ).click("on", function() { fn_reset(); });
		$("#btnSave"        ).click("on", function() { fn_save(); });
		
		//그리드 이벤트
		grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
			if (dataProvider.getFieldName(field) === "AP1_PIC") {
				fn_setGridAPInfo(dataRow, newValue);
			}
        };
        
		grdMain.onEditRowPasted  = function (grid, itemIndex, dataRow, fields, oldValues, newValues) {
			$.each(fields, function(n,v) {
				if (dataProvider.getFieldName(v) === "AP1_PIC") {
					fn_setGridAPInfo(dataRow, grid.getValue(itemIndex, "AP1_PIC"));
				}
			});
		};
		
		//헤더체크
       	grdMain.onColumnCheckedChanged = function (grid, column, checked) {
       		var checkedVal =  checked ? "Y":"N";
       		dataProvider.beginUpdate();
        	for (var i = 0; i < dataProvider.getRowCount(); i++) {
        		dataProvider.setValue(i, column.name, checkedVal);
        	}
        	dataProvider.endUpdate();
       	};
	}
	
	function fn_setGridAPInfo(dataRow, newValue) {
		
		var newAp1Pic = [];
		var selAp2Pic = [];
		
		if (!gfn_isNull(newValue)) {
			newAp1Pic = newValue.split(",");
			for (var i = 0; i < newAp1Pic.length; i++) {
				for (var j = 0; j < codeAPMap.AP1.length; j++) {
					if (newAp1Pic[i] == codeAPMap.AP1[j].CODE_CD) {
						if (!gfn_isNull(codeAPMap.AP1[j].AP2_USER_ID)) {
							if (selAp2Pic.indexOf(codeAPMap.AP1[j].AP2_USER_ID) == -1) {
								selAp2Pic.push(codeAPMap.AP1[j].AP2_USER_ID);
							}
						}
						break;
					}
				}
			}
		}
		
		dataProvider.setValue(dataRow, "AP1_PIC_CNT", newAp1Pic.length);
		dataProvider.setValue(dataRow, "AP2_PIC"    , selAp2Pic.join(","));
	}
	
	//조회
	function fn_apply(sqlFlag) {
		
		//조회조건 설정
		FORM_SEARCH = $("#searchForm").serializeObject();
		
		if(userRoleMap.CHECK_ROLE == "AP1") {
			FORM_SEARCH.ap1Pic = "${sessionScope.userInfo.userId}";
		} else if(userRoleMap.CHECK_ROLE == "AP2") {
			FORM_SEARCH.ap2Pic = "${sessionScope.userInfo.userId}";
		}
		
		//그리드 데이터 조회
		fn_getGridData(sqlFlag);
		fn_getExcelData();
	}
	
	//그리드 데이터 조회
	function fn_getGridData(sqlFlag) {
		
		FORM_SEARCH.sql	     = sqlFlag;
		FORM_SEARCH.hrcyFlag = true;
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"master.master.itemCustGroupMapping"}];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj.do",
			data   : FORM_SEARCH,
			success: function(data) {
				fn_initCheckbox();
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
				
				if(userRoleMap.CHECK_ROLE == "AP1" || userRoleMap.CHECK_ROLE == "AP2") {
					grdMain.setColumnProperty("SALES_ORG_CD", "editable", false);
					grdMain.setColumnProperty("AP1_PIC"     , "editable", false);
					
					grdMain.setColumnProperty("SALES_ORG_CD", "styles", {"background" : gv_noneEditColor});
					grdMain.setColumnProperty("AP1_PIC"     , "styles", {"background" : gv_noneEditColor});
					
				}
			}
		}, "obj");
	}
	
	function fn_initCheckbox() {
		var proxy = grdMain.columnByName("SALES_PLAN_YN");
		proxy.checked = false;
		grdMain.setColumn(proxy);
	}
	
	//그리드 초기화
	function fn_reset() {
		fn_initCheckbox();
		grdMain.cancel();
		dataProvider.rollback(dataProvider.getSavePoints()[0]);
	}
	
	//팝업 오픈
	function fn_openPopup(type) {
		if (type == "AP2") {
			gfn_comPopupOpen("MASTER_AP2_PIC_MGMT", {
				rootUrl : "master",
				url     : "ap2PicMgmt",
				width   : 1150,
				height  : 680,
				menuCd : "MNG10301"
			});
		} else if (type == "AP1") {
			gfn_comPopupOpen("MASTER_AP1_AUTH_CHANGE", {
				rootUrl : "master",
				url     : "ap1AuthChange",
				width   : 1150,
				height  : 680,
				menuCd : "MNG10302"
			});
		}
	}
	
	//팝업 콜백
	function fn_popupSaveCallback(type) {
		
		if (type == "AP2") {
			// AP1 & AP2 담당자 조회
			codeAPMap = fn_getAuthList();
			
			// 콤보박스 재생성
			var ap1PicSelects = $('#ap1Pic').multipleSelect('getSelects');
			var ap2PicSelects = $('#ap2Pic').multipleSelect('getSelects');
			gfn_setMsComboAll([
				{ target : 'divAp1Pic', id : 'ap1Pic', title : '<spring:message code="lbl.ap1Pic"/>', data : codeAPMap.AP1, exData:[] },
				{ target : 'divAp2Pic', id : 'ap2Pic', title : '<spring:message code="lbl.ap2Pic"/>', data : codeAPMap.AP2, exData:[] },
			]);
			$('#ap1Pic').multipleSelect('setSelects', ap1PicSelects);
			$('#ap2Pic').multipleSelect('setSelects', ap2PicSelects);
			
			// 그리드 재설정
			var columnAp1 = grdMain.columnByName("AP1_PIC");
			columnAp1.values = gfn_getArrayExceptInDs(codeAPMap.AP1, "CODE_CD", ""),
			columnAp1.labels = gfn_getArrayExceptInDs(codeAPMap.AP1, "CODE_NM", ""),
			grdMain.setColumn(columnAp1);
			
			var columnAp2 = grdMain.columnByName("AP2_PIC");
			columnAp2.values = gfn_getArrayExceptInDs(codeAPMap.AP2, "CODE_CD", ""),
			columnAp2.labels = gfn_getArrayExceptInDs(codeAPMap.AP2, "CODE_NM", ""),
			grdMain.setColumn(columnAp2);
		}
		
		fn_apply();
	}
	
	//그리드 저장
	function fn_save() {
		
		//수정된 그리드 데이터
		var grdData = gfn_getGrdSavedataAll(grdMain);
		if (grdData.length == 0) {
			alert('<spring:message code="msg.noChangeData"/>');
			return;
		}
		
		// 저장
		confirm('<spring:message code="msg.saveCfm"/>', function() {
			
			// AP1 데이터 정리
			var ap1Data = fn_getGrdSavedataAP1();
			
			FORM_SAVE          = {}; //초기화
			FORM_SAVE._mtd     = "saveAll";
			
			FORM_SAVE.USER_ID = "${sessionScope.userInfo.userId}";
            
			FORM_SAVE.tranData = [
				{outDs:"saveCnt1",_siq:"master.master.itemCustGroupMapping"   , grdData : grdData},
				{outDs:"saveCnt2",_siq:"master.master.itemCustGroupMappingAp1", grdData : ap1Data}
				
		    ];
			
			gfn_service({
				url    : GV_CONTEXT_PATH + "/biz/obj.do",
				data   : FORM_SAVE,
				success: function(data) {
				    
					FORM_SAVE._mtd     = "getList";
					FORM_SAVE.tranData = [
                        {outDs : "saveCnt3", _siq : "master.master.executeACall"}
                    ];
					gfn_service({
                        url     : GV_CONTEXT_PATH + "/biz/obj.do",
                        data    : FORM_SAVE,
                        success : function(data) {
                        	
                            alert('<spring:message code="msg.saveOk"/>');
                            fn_apply();
                        
                        }
                    }, "obj"); 
					

				}
			}, "obj");
		});
	}
	
	//수정된 AP1 정보
	function fn_getGrdSavedataAP1() {
		
		var ap1Data = [];
		
		var updateRows = dataProvider.getAllStateRows().updated;
		for (var i = 0; i < updateRows.length; i++) {
			
			var updateJsonRow = dataProvider.getJsonRow(updateRows[i]);
			var ap1PicList    = (updateJsonRow.AP1_PIC     != undefined ? updateJsonRow.AP1_PIC     : "").split(",");
			var ap1PicBakList = (updateJsonRow.AP1_PIC_BAK != undefined ? updateJsonRow.AP1_PIC_BAK : "").split(",");
			
			// 추가 AP1 확인
			for (var j = 0; j < ap1PicList.length; j++) {
				if (ap1PicList[j] == "") {
					continue;
				}
				var isSearch = false;
				for (var k = 0; k < ap1PicBakList.length; k++) {
					if (ap1PicList[j] == ap1PicBakList[k]) {
						isSearch = true;
						break;
					}
				}
				// 기존 AP1이 아니면 추가된 AP1
				if (!isSearch) {
					ap1Data.push({
						state         : "updated",
						ITEM_CD       : updateJsonRow.ITEM_CD,
						CUST_GROUP_CD : updateJsonRow.CUST_GROUP_CD,
						AP1_USER_ID   : ap1PicList[j],
					});
				}
			}
			
			// 제외 AP1 확인
			for (var j = 0; j < ap1PicBakList.length; j++) {
				if (ap1PicBakList[j] == "") {
					continue;
				}
				var isSearch = false;
				for (var k = 0; k < ap1PicList.length; k++) {
					if (ap1PicBakList[j] == ap1PicList[k]) {
						isSearch = true;
						break;
					}
				}
				// 현재 AP1이 아니면 제외된 AP1
				if (!isSearch) {
					ap1Data.push({
						state         : "deleted",
						ITEM_CD       : updateJsonRow.ITEM_CD,
						CUST_GROUP_CD : updateJsonRow.CUST_GROUP_CD,
						AP1_USER_ID   : ap1PicBakList[j],
					});
				}
			}
		}
		
		return ap1Data;
	}
	
	function fn_checkClose() {
		return gfn_getGrdSaveCount(grdMain) == 0;
	}
	
	function fn_getExcelData(){
		
		EXCEL_SEARCH_DATA = "";
		EXCEL_SEARCH_DATA += "Product" + " : ";
		EXCEL_SEARCH_DATA += $("#loc_product").html();
		EXCEL_SEARCH_DATA += "\nCustomer" + " : ";
		EXCEL_SEARCH_DATA += $("#loc_customer").html();
		EXCEL_SEARCH_DATA += "\nSales Org" + " : ";
		EXCEL_SEARCH_DATA += $("#loc_salesOrg").html();
		
		$.each($(".view_combo"), function(i, val){
			
			var temp = "";
			var id = gfn_nvl($(this).attr("id"), "");
			
			if(id != ""){
				
				var name = $("#" + id + " .ilist .itit").html();
				
				//타이틀
				EXCEL_SEARCH_DATA += "\n" + name + " : ";	
				
				//데이터
				if(id == "divItem"){
					EXCEL_SEARCH_DATA += $("#item_nm").val();
				}else if(id == "divAp1Pic"){
					$.each($("#ap1Pic option:selected"), function(i2, val2){
						
						var txt = gfn_nvl($(this).text(), "");
						
						if(i2 == 0){
							temp = txt;								
						}else{
							temp += ", " + txt;
						}
					});		
					EXCEL_SEARCH_DATA += temp;
				}else if(id == "divAp2Pic"){
					$.each($("#ap2Pic option:selected"), function(i2, val2){
						
						var txt = gfn_nvl($(this).text(), "");
						
						if(i2 == 0){
							temp = txt;								
						}else{
							temp += ", " + txt;
						}
					});		
					EXCEL_SEARCH_DATA += temp;
				}else if(id == "divSalesPlanYn"){
					EXCEL_SEARCH_DATA += $("#salesPlanYn option:selected").text();
				}else if(id == "divRemark"){
					EXCEL_SEARCH_DATA += $("#remark").val();
				}else if(id == "divDrawNo"){
					EXCEL_SEARCH_DATA += $("#drawNo").val();
				}else if(id == "divSalesPriceYn"){
					EXCEL_SEARCH_DATA += $("#salesPriceYn option:selected").text();
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
							<div class="view_combo" id="divItem"></div>
							<div class="view_combo" id="divAp1Pic"></div>
							<div class="view_combo" id="divAp2Pic"></div>
							<div class="view_combo" id="divSalesPlanYn"></div>
							<div class="view_combo" id="divRemark">
								<div class="ilist">
									<div class="itit"><spring:message code="lbl.remark"/></div>
									<input type="text" id="remark" name="remark" class="ipt">
								</div>
							</div>
							<div class="view_combo" id="divDrawNo">
								<div class="ilist">
									<div class="itit"><spring:message code="lbl.drawNo"/></div>
									<input type="text" id="drawNo" name="drawNo" class="ipt">
								</div>
							</div>
							<div class="view_combo" id="divSalesPriceYn"></div>
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
					<a href="javascript:;" id="btnOpenPopupAP2" class="app authClass MNG10301"><spring:message code="lbl.ap2PicMgmt"/></a>
					<a href="javascript:;" id="btnOpenPopupAP1" class="app authClass MNG10302"><spring:message code="lbl.ap1AuthChange"/></a>
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
