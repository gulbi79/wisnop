<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.summary"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
var popupWidth, popupHeight;
var dataRow, bucketList;
var gridInstance, grdMain, dataProvider;
var popUpMenuCd = "${param.menuCd}";
var lv_conFirmFlag = true;
var codeMap   = null;
var codeMapEx = null;
$("document").ready(function (){
	gfn_popresize();
	fn_initCode();
	fn_init();
	
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
function fn_init() {
	
	//부모검색조건
	FORM_SEARCH = {};
	
	$.each(opener.FORM_SEARCH, function(i, el){
		if (!$.isArray(el)) {
			FORM_SEARCH[i] = el;
		}
	});
	
	
	$("#btnClose" ).click("on", function() { window.close(); });
}



//그리드 초기화
function fn_initGrid() {
	
	//메저 width 설정
	gv_meaW = 150;
	
	//그리드 설정
	gridInstance = new GRID();
	gridInstance.init("realgrid");
	grdMain	  = gridInstance.objGrid;
	dataProvider = gridInstance.objData;
	
	//그리드 옵션
	grdMain.setOptions({
		sorting : { enabled	  : false },
		display : { columnMovable: false }
	});

	var totAr =  ['REP_CUST_GROUP_NM_NM','CUST_GROUP_NM','PROD_PART','PROD_TEAM'];
	var columns = 
		[
			
			{
                name      : "REP_CUST_GROUP_NM_NM",
                fieldName : "REP_CUST_GROUP_NM_NM",
                header    : {text : '<spring:message code="lbl.salesGroupNm"/>'},
                styles    : {textAlignment : "near", background : gv_editColor},
                mergeRule : { criteria : "values['REP_CUST_GROUP_NM_NM'] + value" },
                dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
                editable  : false,
                width     : 100
            },
            {
                name      : "CUST_GROUP_NM",
                fieldName : "CUST_GROUP_NM",
                header    : {text : '<spring:message code="lbl.custGroupName"/>'},
                styles    : {textAlignment : "near", background : gv_editColor},
                mergeRule : { criteria : "values['CUST_GROUP_NM'] + value" },
                dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
                editable  : false,
                width     : 100
            },
            
			{
				name	  : "PROD_PART",
				fieldName : "PROD_PART",
				header    : {text : '<spring:message code="lbl.productionTeam"/>'},
				styles    : {textAlignment : "near", background : gv_editColor},
				mergeRule : { criteria : "values['PROD_PART'] + value" },
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
				editable  : false,
				width     : 100
			}, 
			
			{
                name      : "PROD_TEAM",
                fieldName : "PROD_TEAM",
                header    : {text : '<spring:message code="lbl.prodPart2"/>'},
                styles    : {textAlignment : "near", background : gv_editColor},
                mergeRule : { criteria : "values['PROD_TEAM'] + value" },
                dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
                editable  : false,
                width     : 100
            }, 
            
			
			{ 
				type      : "group",
				name      : "AP2", 
				header    : { fixedHeight : 20, text : "<spring:message code='lbl.ap2Sp'/>" },
				width     : 160, 
				columns   : [
					{
						name      : "AP2_QTY", 
						fieldName : "AP2_QTY", 
						header    : { text : "<spring:message code='lbl.qty'/>" }, 
						styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
						dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
						width     : 80, 
						editable  : false 
					}, {
						name      : "AP2_AMT", 
						fieldName : "AP2_AMT", 
						header    : { text : "<spring:message code='lbl.amt'/>" }, 
						styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
						dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
						width     : 80, 
						editable  : false 
					}
				]
			}, { 
				type      : "group",
				name      : "INVEN", 
				header    : { fixedHeight : 20, text : "<spring:message code='lbl.invenSales'/>" },
				width     : 160, 
				columns   : [
					{
						name      : "INVEN_QTY", 
						fieldName : "INVEN_QTY", 
						header    : { text : "<spring:message code='lbl.qty'/>" }, 
						styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
						dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
						width     : 80, 
						editable  : false 
					}, {
						name      : "INVEN_AMT", 
						fieldName : "INVEN_AMT", 
						header    : { text : "<spring:message code='lbl.amt'/>" }, 
						styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
						dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
						width     : 80, 
						editable  : false 
					}
				]
			}, { 
				type      : "group",
				name      : "PROD_NEED", 
				header    : { fixedHeight : 20, text : "<spring:message code='lbl.prodNeed'/>" },
				width     : 160, 
				columns   : [
					{
						name      : "PROD_NEED_QTY", 
						fieldName : "PROD_NEED_QTY", 
						header    : { text : "<spring:message code='lbl.qty'/>" }, 
						styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
						dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
						width     : 80, 
						editable  : false 
					}, {
						name      : "PROD_NEED_AMT", 
						fieldName : "PROD_NEED_AMT", 
						header    : { text : "<spring:message code='lbl.amt'/>" }, 
						styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
						dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
						width     : 80, 
						editable  : false 
					}
				]
			}, { 
				type      : "group",
				name      : "PROD_POSS", 
				header    : { fixedHeight : 20, text : "<spring:message code='lbl.prodPoss'/>" },
				width     : 160, 
				columns   : [
					{
						name      : "PROD_POSS_QTY", 
						fieldName : "PROD_POSS_QTY", 
						header    : { text : "<spring:message code='lbl.qty'/>" }, 
						styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
						dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
						width     : 80, 
						editable  : false 
					}, {
						name      : "PROD_POSS_AMT", 
						fieldName : "PROD_POSS_AMT", 
						header    : { text : "<spring:message code='lbl.amt'/>" }, 
						styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
						dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
						width     : 80, 
						editable  : false 
					}
				]
			}, { 
				type      : "group",
				name      : "PROD_PLAN", 
				header    : { fixedHeight : 20, text : "<spring:message code='lbl.prodFinishPlan'/>" },
				width     : 160, 
				columns   : [
					{
						name      : "PROD_PLAN_QTY", 
						fieldName : "PROD_PLAN_QTY", 
						header    : { text : "<spring:message code='lbl.qty'/>" }, 
						styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
						dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
						width     : 80, 
						editable  : false 
					}, {
						name      : "PROD_PLAN_AMT", 
						fieldName : "PROD_PLAN_AMT", 
						header    : { text : "<spring:message code='lbl.amt'/>" }, 
						styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
						dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
						width     : 80, 
						editable  : false 
					}
				]
			}, { 
				type      : "group",
				name      : "CFM", 
				header    : { fixedHeight : 20, text : "<spring:message code='lbl.salesFix'/>" },
				width     : 160, 
				columns   : [
					{
						name      : "CFM_QTY", 
						fieldName : "CFM_QTY", 
						header    : { text : "<spring:message code='lbl.qty'/>" }, 
						styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
						dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
						width     : 80, 
						editable  : false 
					}, {
						name      : "CFM_AMT", 
						fieldName : "CFM_AMT", 
						header    : { text : "<spring:message code='lbl.amt'/>" }, 
						styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
						dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
						width     : 80, 
						editable  : false 
					}
				]
			}, { 
				type      : "group",
				name      : "PRECED", 
				header    : { fixedHeight : 20, text : "<spring:message code='lbl.precedProd2'/>" },
				width     : 160, 
				columns   : [
					{
						name      : "PRECED_QTY", 
						fieldName : "PRECED_QTY", 
						header    : { text : "<spring:message code='lbl.qty'/>" }, 
						styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
						dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
						width     : 80, 
						editable  : false 
					}, {
						name      : "PRECED_AMT", 
						fieldName : "PRECED_AMT", 
						header    : { text : "<spring:message code='lbl.amt'/>" }, 
						styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
						dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
						width     : 80, 
						editable  : false 
					}
				]
			}, { 
				type      : "group",
				name      : "NO_PROD", 
				header    : { fixedHeight : 20, text : "<spring:message code='lbl.noProd'/>" },
				width     : 160, 
				columns   : [
					{
						name      : "NO_PROD_QTY", 
						fieldName : "NO_PROD_QTY", 
						header    : { text : "<spring:message code='lbl.qty'/>" }, 
						styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
						dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
						width     : 80, 
						editable  : false 
					}, {
						name      : "NO_PROD_AMT", 
						fieldName : "NO_PROD_AMT", 
						header    : { text : "<spring:message code='lbl.amt'/>" }, 
						styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
						dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
						width     : 80, 
						editable  : false 
					}
				]
			}
		];

	grdMain.setColumns(columns);
	
	var fields = new Array();
	fields = [
		{ fieldName : "REP_CUST_GROUP_NM_NM"},
	    { fieldName : "CUST_GROUP_NM"},
        { fieldName : "PROD_PART"},
        { fieldName : "PROD_TEAM"},
		{ fieldName : "AP2_QTY" , dataType : 'number'},
		{ fieldName : "AP2_AMT"   , dataType : 'number'},
		{ fieldName : "INVEN_QTY"   , dataType : 'number'},
		{ fieldName : "INVEN_AMT"   , dataType : 'number'},
		{ fieldName : "PROD_NEED_QTY"  , dataType : 'number'},
		{ fieldName : "PROD_NEED_AMT"  , dataType : 'number'},
		{ fieldName : "PROD_POSS_QTY"  , dataType : 'number'},
		{ fieldName : "PROD_POSS_AMT"  , dataType : 'number'},
		{ fieldName : "PROD_PLAN_QTY"  , dataType : 'number'},
		{ fieldName : "PROD_PLAN_AMT"  , dataType : 'number'},
		{ fieldName : "CFM_QTY"  , dataType : 'number'},
		{ fieldName : "CFM_AMT"  , dataType : 'number'},
		{ fieldName : "PRECED_QTY"  , dataType : 'number'},
		{ fieldName : "PRECED_AMT"  , dataType : 'number'},
		{ fieldName : "NO_PROD_QTY"  , dataType : 'number'},
		{ fieldName : "NO_PROD_AMT"  , dataType : 'number'}
	];
	
	dataProvider.setFields(fields);
	
	/* 
	var divUN = grdMain.columnByName("divUN");
	if (divUN) {
		var hide = !this.grdMain.getColumnProperty(divUN, "hideChildHeaders");
		this.grdMain.setColumnProperty(divUN, "hideChildHeaders", hide);
	}
	var divOB = grdMain.columnByName("divOB");
	if (divOB) {
		var hide = !this.grdMain.getColumnProperty(divOB, "hideChildHeaders");
		this.grdMain.setColumnProperty(divOB, "hideChildHeaders", hide);
	}
	var divEX = grdMain.columnByName("divEX");
	if (divEX) {
		var hide = !this.grdMain.getColumnProperty(divEX, "hideChildHeaders");
		this.grdMain.setColumnProperty(divEX, "hideChildHeaders", hide);
	} */
}


//조회
function fn_apply(sqlFlag) {
	
	//메인 데이터를 조회
	FORM_SEARCH = $("#searchForm").serializeObject();
    
	fn_getGridData(sqlFlag);
	
}

//그리드 데이터 조회
function fn_getGridData(sqlFlag) {
	
	FORM_SEARCH.sql      = sqlFlag;
	FORM_SEARCH._mtd	 = "getList";
	FORM_SEARCH.startMonth	 = "${param.startMonth}";
	FORM_SEARCH.pastPlanId	 = "${param.pastPlanId}";
	
	FORM_SEARCH.tranData = [];
	FORM_SEARCH.tranData.push( { "outDs" : "rtnList", "_siq" : "dp.planMonth.planConfirmationSummary"} );
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

//엑셀, 쿼리 다운로드 권한 확인
function fn_excelSqlAuth() {
	
	gfn_service({
	    async   : false,
	    url     : GV_CONTEXT_PATH + "/biz/obj.do",
	    data    : {
   			_mtd : "getList",
   			popUpMenuCd : popUpMenuCd,
   			tranData : [
   				{outDs : "authorityList", _siq : "dp.planMonth.planConfirmationSummaryExcelSql"}
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
//필터 초기화
function fn_initCode(){
	var grpCd      = 'PROD_PART,PROD_L2';
    codeMap   = gfn_getComCode(grpCd, 'N');
	codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP"], null, {itemType : "10,20,30,50" });
    
	codeMap.PROD_PART.push({CODE_CD:'기타',CODE_NM:'기타'});
	codeMap.PROD_L2.push({CODE_CD:'기타',CODE_NM:'기타'});
    
	
	
	fn_initFilter();
}


function fn_initFilter() {
    // 콤보박스

    gfn_setMsCombo("prodPart", codeMap.PROD_PART, [], {});  
    gfn_setMsCombo("prodTeam", codeMap.PROD_L2, [], {});
    gfn_setMsCombo("reptCustGroup", codeMapEx.REP_CUST_GROUP , [], {});   
    gfn_setMsCombo("custGroup", codeMapEx.CUST_GROUP, [], {});   
    
}

//이벤트 초기화
function fn_initEvent() {
    
    //버튼 이벤트
    
    $("#btnSearch").click("on", function(){  fn_apply() });
   

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
		<div class="pop_tit"><spring:message code="lbl.summary"/></div>
		<div class="popCont">
			<div class="srhwrap">
			    <form id="searchForm" name="searchForm" method="POST" onSubmit="return false;"> 	
				<div class="srhcondi">
				<ul>
				    <li>
                        <strong style="padding-right:5px"><spring:message code="lbl.salesGroupNm"/></strong><!-- 대표거래처 그룹명 -->
                        <div class="selectBox">
                            <select id="reptCustGroup" name="reptCustGroup" multiple="multiple"></select>
                        </div>
                    </li>
                    <li>
                        <strong style="padding-right:5px"><spring:message code="lbl.custGroupName"/></strong><!-- 대표거래처 소그룹명 -->
                        <div class="selectBox">
                            <select id="custGroup" name="custGroup" multiple="multiple"></select>
                        </div>
                    </li>
                    <li>
                        <strong style="padding-right:5px"><spring:message code="lbl.productionTeam"/></strong><!-- 생산파트 -->
                        <div class="selectBox">
                            <select id="prodPart" name="prodPart" multiple="multiple"></select>
                        </div>
                    </li>
                    <li>
                        <strong style="padding-right:5px;min-width:40px;"><spring:message code="lbl.prodPart2"/></strong><!-- 생산팀 -->
                        <div class="selectBox">
                            <select id="prodTeam" name="prodTeam" multiple="multiple"></select>
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
                    <a href="javascript:;" id ="btnSearch" class="fl_app"><spring:message code="lbl.search"/></a>
                </div>
			</div>
			<div id="realgrid" class="realgrid1"></div>
		</div>
		<div class="pop_btm">
			<div class="pop_btn_info">
				<strong >Sum  :</strong> <span id="bottom_userSum"></span>
			</div>
			<div class="pop_btn_info">
				<strong >Avg  :</strong> <span id="bottom_userAvg"></span>
			</div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>