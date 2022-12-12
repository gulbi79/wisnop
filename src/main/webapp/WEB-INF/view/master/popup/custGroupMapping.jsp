<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.custGroupMapping"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
var popupWidth, popupHeight;
var codeMap;
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
	codeMap = {};
	gfn_service({
	    async   : false,
	    url     : GV_CONTEXT_PATH + "/biz/obj.do",
	    data    : {
	    	_mtd:"getList",
	    	tranData:[
	    		{outDs:"reptList",_siq:"master.popup.custGroupMappingRept"},
	    		{outDs:"custList",_siq:"master.popup.custGroupMappingCust"}
	    	]
	    },
	    success :function(data) {
	    	codeMap.REPT = data.reptList;
	    	codeMap.CUST = data.custList;
	    }
	}, "obj");
}

//필터 초기화
function fn_initFilter() {
	// 콤보박스
	gfn_setMsCombo("reptCustGroup", codeMap.REPT, [], {});
	gfn_setMsCombo("custGroup"    , codeMap.CUST, [], {});
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
		{ fieldName : "REP_CUST_GROUP_CD" },
		{ fieldName : "REP_CUST_GROUP_NM" },
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
			name         : "REP_CUST_GROUP_CD",
			fieldName    : "REP_CUST_GROUP_CD",
			editable     : false,
			header       : { text: '<spring:message code="lbl.reptCustGroup"/>' },
			styles       : { background : gv_noneEditColor, textAlignment: "near" },
			width        : 100,
		},
		{
			name         : "REP_CUST_GROUP_CD",
			fieldName    : "REP_CUST_GROUP_CD",
			editable     : true,
			styles       : { textAlignment: "near" },
			header       : { text: '<spring:message code="lbl.reptCustGroupName"/>' },
			editor       : { type: "dropDown", domainOnly: true },
			values       : gfn_getArrayInDs(codeMap.REPT, "CODE_CD", true),
			labels       : gfn_getArrayInDs(codeMap.REPT, "CODE_NM", true),
			nanText      : "",
			lookupDisplay: true,
			width        : 150,
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
	$(".fl_app"   ).click("on", function() { fn_apply(); });
	$("#btnReset" ).click("on", function() { fn_reset(); });
	$("#btnSave"  ).click("on", function() { fn_save(); });
	$("#btnClose" ).click("on", function() { window.close(); });
	
	//그리드 이벤트
	grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
		if (dataProvider.getFieldName(field) === "REP_CUST_GROUP_CD") {
			var isSearch = false;
			$.each(codeMap.REPT, function(idx, item) {
				if (newValue == item.CODE_CD) {
					dataProvider.setValue(dataRow, "REP_CUST_GROUP_NM", item.CODE_NM);
					isSearch = true;
					return false;
				}
			});
			if (!isSearch) {
				dataProvider.setValue(dataRow, "REP_CUST_GROUP_NM", "");
			}
		}
    };
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
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"master.popup.custGroupMapping"}];
	
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
		
		FORM_SAVE          = {}; //초기화
		FORM_SAVE._mtd     = "saveUpdate";
		FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"master.popup.custGroupMapping",grdData:grdData}];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj.do",
			data   : FORM_SAVE,
			success: function(data) {
				alert('<spring:message code="msg.saveOk"/>');
				fn_apply();
				if (opener && opener.fn_popupSaveCallback) {
					opener.fn_popupSaveCallback();
				}
			}
		}, "obj");
	});
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
                {outDs : "authorityList", _siq : "master.popup.custGroupMappingExcelSql"}
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
		<div class="pop_tit"><spring:message code="lbl.custGroupMapping"/></div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
					<div class="srhcondi">
						<ul>
							<li>
								<strong><spring:message code="lbl.reptCustGroup"/></strong>
								<div class="selectBox">
									<select id="reptCustGroup" name="reptCustGroup" multiple="multiple"></select>
								</div>
							</li>
							<li>
								<strong><spring:message code="lbl.custGroup"/></strong>
								<div class="selectBox">
									<select id="custGroup" name="custGroup" multiple="multiple"></select>
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
				<a href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset"/></a>
				<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save"/></a>
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>