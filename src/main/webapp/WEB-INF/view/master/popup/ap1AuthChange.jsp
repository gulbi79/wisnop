<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.ap1AuthChange"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>
<style type="text/css">
.srhcondi > ul > li > strong { width:90px; }
.srhcondi > ul > li { width:300px; }
</style>
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
	//코드 데이터 조회
	codeMap = fn_getCodeList();
}

//코드 데이터 조회
function fn_getCodeList() {
	var rtnMap = {};
	gfn_service({
	    async   : false,
	    url     : GV_CONTEXT_PATH + "/biz/obj",
	    data    : {
	    	_mtd:"getList",
	    	tranData:[
	    		{outDs:"authLvl",_siq:"master.popup.ap1AuthChangeUserAuthLvl"},
	    		{outDs:"ap1List",_siq:"master.master.itemCustGroupMappingAuthAp1"},
	    		{outDs:"ap2List",_siq:"master.master.itemCustGroupMappingAuthAp2"},
	    		{outDs:"pr3List",_siq:"master.popup.ap1AuthChangeProdL3"},
	    		{outDs:"cu2List",_siq:"master.popup.ap1AuthChangeCustL2"},
	    	]
	    },
	    success :function(data) {
	    	rtnMap.LVL = data.authLvl[0];
	    	rtnMap.AP1 = data.ap1List;
	    	rtnMap.AP2 = data.ap2List;
	    	rtnMap.PR3 = data.pr3List;
	    	rtnMap.CU2 = data.cu2List;
	    }
	}, "obj");
	return rtnMap;
}

//필터 초기화
function fn_initFilter() {
	
	// 키워드팝업
	gfn_keyPopAddEvent([
		{ target : 'divItem', id : 'item', type : 'COM_ITEM_PLAN', title : '<spring:message code="lbl.item"/>', popupYn : "Y" }
	]);
	
	// 콤보박스
	gfn_setMsCombo("ap1PicFrom", codeMap.AP1, [], {width:"150px"});
	gfn_setMsCombo("ap1PicTo"  , codeMap.AP1, [], {width:"150px"});
	gfn_setMsCombo("prodL3"    , codeMap.PR3, [], {width:"150px"});
	gfn_setMsCombo("custL2"    , codeMap.CU2, [], {width:"150px"});
	
	// 콤보박스 초기화
	if (codeMap.LVL == "AP1") {
		$("#ap1PicFrom").val("${sessionScope.GV_USER_ID}");
		$("#ap1PicFrom").prop("disabled", true);
	} else if (codeMap.LVL == "GOC") {
		;
	} else {
		$("#ap1PicFrom option").remove();
		$("#ap1PicFrom").prop("disabled", true);
	}
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
		{ fieldName : "COMPANY_CD" },
		{ fieldName : "BU_CD" },
		{ fieldName : "PROD_LVL3_NM" },
		{ fieldName : "CUST_LVL2_NM" },
		{ fieldName : "ITEM_CD" },
		{ fieldName : "ITEM_NM" },
		{ fieldName : "SPEC" },
		{ fieldName : "CUST_GROUP_CD" },
		{ fieldName : "CUST_GROUP_NM" },
		{ fieldName : "AP1_USER_ID" },
	];
	dataProvider.setFields(fields);
}

//그리드컬럼
function fn_setColumns(grd) {
	var columns = [
		{
			name         : "PROD_LVL3_NM",
			fieldName    : "PROD_LVL3_NM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.prodL3Name"/>' },
			styles       : { textAlignment: "near" },
			width        : 120,
		},
		{
			name         : "CUST_LVL2_NM",
			fieldName    : "CUST_LVL2_NM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.custL2Name"/>' },
			styles       : { textAlignment: "near" },
			width        : 120,
		},
		{
			name         : "ITEM_CD",
			fieldName    : "ITEM_CD",
			editable     : false,
			header       : { text: '<spring:message code="lbl.item"/>' },
			styles       : { textAlignment: "near" },
			width        : 100,
		},
		{
			name         : "ITEM_NM",
			fieldName    : "ITEM_NM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.itemName"/>' },
			styles       : { textAlignment: "near" },
			width        : 120,
		},
		{
			name         : "SPEC",
			fieldName    : "SPEC",
			editable     : false,
			header       : { text: '<spring:message code="lbl.spec"/>' },
			styles       : { textAlignment: "near" },
			width        : 120,
		},
		{
			name         : "CUST_GROUP_CD",
			fieldName    : "CUST_GROUP_CD",
			editable     : false,
			header       : { text: '<spring:message code="lbl.custGroup"/>' },
			styles       : { textAlignment: "near" },
			width        : 100,
		},
		{
			name         : "CUST_GROUP_NM",
			fieldName    : "CUST_GROUP_NM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.custGroupName"/>' },
			styles       : { textAlignment: "near" },
			width        : 120,
		},
	];
	grdMain.setColumns(columns);
}

//그리드 옵션
function fn_setOptions(grd) {
	grd.setOptions({
		checkBar: { visible: true, showAll: true },
	});
}

//이벤트 초기화
function fn_initEvent() {
	$(".fl_app"     ).click("on", function() { fn_apply(); });
	$("#btnCopy"    ).click("on", function() { fn_save("Copy"); });
	$("#btnHandOver").click("on", function() { fn_save("HandOver"); });
	$("#btnClose"   ).click("on", function() { window.close(); });
}

//조회
function fn_apply(sqlFlag) {
	
	//조회조건 설정
	FORM_SEARCH = $("#searchForm").serializeObject();
	
	//그리드 데이터 조회
	fn_getGridData(sqlFlag);
}

//그리드 데이터 조회
function fn_getGridData(sqlFlag) {
	
	FORM_SEARCH.sql	     = sqlFlag;
	FORM_SEARCH._mtd     = "getList";
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"master.popup.ap1AuthChange"}];
	
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

//AP1 권한 복사
function fn_save(type) {
	
	if (gfn_isNull($("#ap1PicTo").val())) {
		return;
	}
	
	var rows = grdMain.getCheckedRows(true);
	if (rows.length == 0) {
		alert('<spring:message code="msg.pleaseCheckData"/>');
		return;
	}
	
	// 저장
	if (type == "Copy") {
		confirm('<spring:message code="msg.copyAp1Auth"/>', function() {
			fn_proc(type, rows);
		});
	} else if (type == "HandOver") {
		confirm('<spring:message code="msg.handOverAp1Auth"/>', function() {
			fn_proc(type, rows);
		});
	}
}

//처리
function fn_proc(type, rows) {
	
	// 선정 데이터 정리
	var grdData = [];
	$.each(rows, function(n,v) {
		var jsonRow = dataProvider.getJsonRow(v);
		jsonRow.AP1_USER_ID_TO = $("#ap1PicTo").val();
		grdData.push(jsonRow);
	});
	
	FORM_SAVE          = {}; //초기화
	FORM_SAVE._mtd     = "saveUpdate";
	FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"master.popup.ap1AuthChange"+type,grdData:grdData}];
	
	gfn_service({
		url    : GV_CONTEXT_PATH + "/biz/obj",
		data   : FORM_SAVE,
		success: function(data) {
			alert('<spring:message code="msg.saveOk"/>');
			fn_apply();
			if (opener && opener.fn_popupSaveCallback) {
				opener.fn_popupSaveCallback("AP1");
			}
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
                {outDs : "authorityList", _siq : "master.popup.ap1AuthChangeExcelSql"}
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
		<div class="pop_tit"><spring:message code="lbl.ap1AuthChange"/></div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
					<div class="srhcondi">
						<ul>
							<li>
								<strong><spring:message code="lbl.fromAp1Pic"/></strong>
								<div class="selectBox">
									<select id="ap1PicFrom" name="ap1PicFrom" class="iptcombo"></select>
								</div>
							</li>
							<li>
								<strong><spring:message code="lbl.toAp1Pic"/></strong>
								<div class="selectBox">
									<select id="ap1PicTo" name="ap1PicTo" class="iptcombo"></select>
								</div>
							</li>
						</ul>
						<ul>
							<li>
								<strong><spring:message code="lbl.prodL3Name"/></strong>
								<div class="selectBox">
									<select id="prodL3" name="prodL3" multiple="multiple"></select>
								</div>
							</li>
							<li>
								<strong><spring:message code="lbl.custL2Name"/></strong>
								<div class="selectBox">
									<select id="custL2" name="custL2" multiple="multiple"></select>
								</div>
							</li>
						</ul>
						<ul>
							<li id="divItem"></li>
							<li>
								<strong><spring:message code="lbl.custGroup"/></strong>
								<input type="text" id="custGroup" name="custGroup" class="ipt" style="width:143px">
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
				<a href="javascript:;" id="btnCopy" class="app2 roleWrite"><spring:message code="lbl.copy"/></a>
				<a href="javascript:;" id="btnHandOver" class="app2 roleWrite"><spring:message code="lbl.handOver"/></a>
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>