<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.custGroupMgmt"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
var popupWidth, popupHeight;
var gridInstance, grdMain, dataProvider;
var codeSalesOrgMap, codeAPMap;
var ap1Data = [];
var popUpMenuCd = "${param.menuCd}";
var lv_conFirmFlag = true;
$("document").ready(function (){
	gfn_popresize();
	fn_initData();
	fn_initGrid();
	fn_initEvent();
	fn_apply();
	fn_excelSqlAuth();
	
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

function fn_initData() {
	codeAPMap       = fn_getAuthList();
	codeSalesOrgMap = fn_getSalesOrg();
}

function fn_getAuthList() {
	var rtnMap = {};
	gfn_service({
	    async   : false,
	    url     : GV_CONTEXT_PATH + "/biz/obj.do",
	    data    : {
	    	_mtd:"getList",
	    	tranData:[
	    		{outDs:"ap1List",_siq:"master.popup.custGroupAuthAp1"},
	    	]
	    },
	    success :function(data) {
	    	rtnMap.AP1 = data.ap1List;
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
	    		{outDs:"orgList",_siq:"master.popup.custGroupSalesOrg"}
	    	]
	    },
	    success :function(data) {
	    	rtnMap.ORG = data.orgList;
	    }
	}, "obj");
	return rtnMap;
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
}

//그리드필드
function fn_setFields(provider) {
	var fields = [
		{ fieldName : "CUST_GROUP_CD" },
		{ fieldName : "CUST_GROUP_NM" },
		{ fieldName : "REP_CUST_CNT", dataType : "number" },
		{ fieldName : "SALES_ORG_CD" },
		{ fieldName : "AP1_PIC" },
		{ fieldName : "AP1_PIC_BAK" },
		{ fieldName : "SORT", dataType : "number" },
		{ fieldName : "USE_FLAG" },
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
			name         : "CUST_GROUP_CD",
			fieldName    : "CUST_GROUP_CD",
			editable     : false,
			header       : { text: '<spring:message code="lbl.custGroup"/>' },
			styles       : { background : gv_noneEditColor, textAlignment: "near" },
			width        : 100
		},
		{
			name         : "CUST_GROUP_NM",
			fieldName    : "CUST_GROUP_NM",
			editable     : true,
			header       : { text: '<spring:message code="lbl.custGroupName"/>' },
			styles       : { textAlignment: "near", background : gv_requiredColor },
			width        : 150
		},
		{
			name         : "REP_CUST_CNT",
			fieldName    : "REP_CUST_CNT",
			editable     : false,
			header       : { text: '<spring:message code="lbl.reptCustCnt"/>' },
			styles       : { textAlignment: "far", background : gv_noneEditColor },
			width        : 100
		},
		
		{
			name         : "SALES_ORG_CD",
			fieldName    : "SALES_ORG_CD",
			editable     : true,
			header       : { text: '<spring:message code="lbl.salesOrgL5Name"/>' },
			styles       : { textAlignment: "near" },
			editor       : { type: "dropDown", domainOnly: true },
			values       : gfn_getArrayExceptInDs(codeSalesOrgMap.ORG, "CODE_CD", ""),
			labels       : gfn_getArrayExceptInDs(codeSalesOrgMap.ORG, "CODE_NM", ""),
			nanText      : "",
			lookupDisplay: true,
			width        : 150
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
			name         : "SORT",
			fieldName    : "SORT",
			editable     : true,
			editor       : { type : "number" },
			header       : { text: '<spring:message code="lbl.sort"/>' },
			styles       : { textAlignment: "far" },
			width        : 50
		},
		{
			name         : "USE_FLAG",
			fieldName    : "USE_FLAG",
			editable     : false,
			header       : { text: '<spring:message code="lbl.useYn"/>' },
			renderer     : gfn_getRenderer("CHECK",{editable:true}),
			dynamicStyles: [{
                criteria: ["values['REP_CUST_CNT']=0","values['REP_CUST_CNT']<>0"],
                styles  : ["background="+gv_editColor,"background="+gv_noneEditColor]
            }],
			width        : 80
		},
		{
			name         : "UPDATE_DTTM",
			fieldName    : "UPDATE_DTTM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.updateDttm"/>' },
			styles       : { background : gv_noneEditColor },
			width        : 120
		},
		{
			name         : "UPDATE_ID",
			fieldName    : "UPDATE_ID",
			editable     : false,
			header       : { text: '<spring:message code="lbl.updateBy"/>' },
			styles       : { background : gv_noneEditColor, textAlignment: "near" },
			width        : 100
		},
		{
			name         : "CREATE_DTTM",
			fieldName    : "CREATE_DTTM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.createDttm"/>' },
			styles       : { background : gv_noneEditColor },
			width        : 120
		},
		{
			name         : "CREATE_ID",
			fieldName    : "CREATE_ID",
			editable     : false,
			header       : { text: '<spring:message code="lbl.createBy"/>' },
			styles       : { background : gv_noneEditColor, textAlignment: "near" },
			width        : 100
		},
	];
	grdMain.setColumns(columns);
	
	grdMain.addCellRenderers([{
		"id"     : "imageBtn",
		"type"   : "imageButtons",
		"margin" : 10,
		"images" : [{
			"name" : "imageBtn",
			"up"   : "${ctx}/statics/images/common/ico_srh.png",
			"hover": "${ctx}/statics/images/common/ico_srh.png",
			"down" : "${ctx}/statics/images/common/ico_srh.png",
		}]
	}]);
	
	//grdMain.setColumnProperty("CUST_GROUP_CD", "buttonVisibility", "always");
	grdMain.setColumnProperty("CUST_GROUP_CD", "dynamicStyles", [
		{ criteria : "state<>'c'", styles : { background : gv_noneEditColor } },
		{ criteria : "state='c'" , styles : { background : gv_requiredColor, renderer : "imageBtn" } },
	]);
}

//그리드 옵션
function fn_setOptions(grd) {
	grd.setOptions({
		checkBar: { visible: true, showAll: true },
		stateBar: { visible: true }
	});
}

//이벤트 초기화
function fn_initEvent() {
	
	//버튼 이벤트
	$(".fl_app"   ).click("on", function() { fn_apply(); });
	$("#btnReset" ).click("on", function() { fn_reset(); });
	$("#btnAdd"   ).click("on", function() { fn_add(); });
	$("#btnDelete").click("on", function() { fn_del(); });
	$("#btnSave"  ).click("on", function() { fn_save(); });
	$("#btnClose" ).click("on", function() { window.close(); });
	
	//그리드 이벤트
	grdMain.onImageButtonClicked = function(grid, itemIndex, column, buttonIndex, name) {
		fn_openPopup(grid.getDataRow(itemIndex));
	};
	grdMain.onCurrentChanging = function(grid, oldIndex, newIndex) {
		if (grid.getValue(newIndex.itemIndex, "REP_CUST_CNT") == 0) {
			grid.setColumnProperty("USE_FLAG", "readOnly", false);
		} else {
			grid.setColumnProperty("USE_FLAG", "readOnly", true);
		}
	}
}

//팝업 오픈
function fn_openPopup(dataRow) {
	gfn_comPopupOpen("MASTER_CUST_GROUP_SELECTION", {
		rootUrl : "master",
		url     : "custGroupSelection",
		width   : 400,
		height  : 400,
		dataRow : dataRow
	});
}

//팝업 콜백
function fn_popupSaveCallback(data, dataRow) {
	if (data) {
		dataProvider.setValue(dataRow, "CUST_GROUP_CD", data.REP_CUST_CD);
		dataProvider.setValue(dataRow, "CUST_GROUP_NM", data.REP_CUST_NM);
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
	FORM_SEARCH._mtd     = "getList";
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"master.popup.custGroup"}];
	
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

//그리드 초기화
function fn_reset() {
	grdMain.cancel();
	dataProvider.rollback(dataProvider.getSavePoints()[0]);
	maxSeq = 0;
}

//그리드 행추가
function fn_add() {
	grdMain.commit();
	dataProvider.insertRow(0,{REP_CUST_CNT:0, USE_FLAG:"Y"});
}

//삭제
function fn_del() {
	var rows = grdMain.getCheckedRows();
	dataProvider.removeRows(rows, false);
}

//그리드 저장
function fn_save() {
	
	//수정된 그리드 데이터
	var grdData = gfn_getGrdSavedataAll(grdMain);
	if (grdData.length == 0) {
		alert('<spring:message code="msg.noChangeData"/>');
		return;
	}
	
	//그리드 유효성 검사
	var arrColumn = ["CUST_GROUP_CD","CUST_GROUP_NM"];
	if (!gfn_getValidation(gridInstance,arrColumn)) return;
	
	// PK 중복 체크 
    if (gfn_dupCheck(grdMain, "CUST_GROUP_CD")) return;
	
	// 저장
	confirm('<spring:message code="msg.saveCfm"/>', function() {
		
		fn_getGrdSavedataAP1(dataProvider.getAllStateRows().updated);
		fn_getGrdSavedataAP1(dataProvider.getAllStateRows().created);
		
		FORM_SAVE          = {}; //초기화
		FORM_SAVE._mtd     = "saveAll";
		FORM_SAVE.tranData = [
			{outDs:"saveCnt",_siq:"master.popup.custGroup", grdData : grdData, custDupChkYn : {"insert":"Y", "update":"Y", "delete":"Y"}},
			{outDs:"saveCnt2",_siq:"master.popup.custGroupAp1", grdData : ap1Data},
			{outDs:"saveCnt3",_siq:"master.master.itemCustGroupMappingSalesOrgCd", grdData:[{call : "call",state:"updated"}]}
		];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj.do",
			data   : FORM_SAVE,
			success: function(data) {
				ap1Data = [];
				
				if ( data.errCode == -10 || data.errCode == -20 ) {
					var cust_group_cd = dataProvider.getValue(data.errLine-1, "CUST_GROUP_CD")
					var cust_group_nm = dataProvider.getValue(data.errLine-1, "CUST_GROUP_NM")
					alert('<spring:message code="msg.duplicateCheck"/> '+cust_group_cd+' '+cust_group_nm);
					grdMain.setCurrent({dataRow : data.errLine-1, column : "CUST_GROUP_CD"});
				} else if ( data.errCode == -30 ) {
					var custGroup = '<spring:message code="lbl.custGroup"/>';
					var reptCust  = '<spring:message code="lbl.reptCust"/>';
					alert(gfn_getDomainMsg("msg.activeCheck2",custGroup+"|"+reptCust));
					grdMain.setCurrent({dataRow : data.errLine-1, column : "CUST_GROUP_CD"});
				} else {
					alert('<spring:message code="msg.saveOk"/>');
					fn_apply();
					if (opener && opener.fn_popupSaveCallback) {
						opener.fn_popupSaveCallback("R");
					}
				}
			}
		}, "obj");
	});
}



function fn_getGrdSavedataAP1(updateRows) {
	
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
					CUST_GROUP_CD : updateJsonRow.CUST_GROUP_CD,
					AP1_USER_ID   : ap1PicBakList[j],
				});
			}
		}
	}
	
	return ap1Data;
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
                {outDs : "authorityList", _siq : "master.popup.custGroupExcelSql"}
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



function fn_getExcelData(){
	
	/* EXCEL_SEARCH_DATA = "";
	EXCEL_SEARCH_DATA += "Customer" + " : ";
	EXCEL_SEARCH_DATA += $("#loc_customer").html();
	
	EXCEL_SEARCH_DATA += '\n<spring:message code="lbl.reptCustGroup"/> : ';
	$.each($("#reptCustGroup option:selected"), function(i2, val2){
		
		var txt = gfn_nvl($(this).text(), "");
		
		if(i2 == 0){
			temp = txt;								
		}else{
			temp += ", " + txt;
		}
	});		
	EXCEL_SEARCH_DATA += temp;
	EXCEL_SEARCH_DATA += '\n<spring:message code="lbl.custGroup"/> : ';
	EXCEL_SEARCH_DATA += $("#custGroup option:selected").text();
	
	console.log(EXCEL_SEARCH_DATA); */
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
		<div class="pop_tit"><spring:message code="lbl.custGroupMgmt"/></div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
					<div class="srhcondi">
						<ul>
							<li>
								<strong><spring:message code="lbl.custGroup"/></strong>
								<div class="selectBox">
									<input type="text" id="custGroup" name="custGroup" class="ipt">
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
			<div id="realgrid" class="realgrid1"></div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnAdd" class="app1 roleWrite"><spring:message code="lbl.add"/></a>
				<a href="javascript:;" id="btnDelete" class="app1 roleWrite"><spring:message code="lbl.delete"/></a>
				<a href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset"/></a>
				<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save"/></a>
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>