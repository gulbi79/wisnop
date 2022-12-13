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
$("document").ready(function (){
	gfn_popresize();
	
	fn_init();
	
	fn_initGrid();
	
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
	//FORM_SEARCH = opener.FORM_SEARCH;
	
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
	grdMain      = gridInstance.objGrid;
	dataProvider = gridInstance.objData;
	
	//그리드 옵션
	grdMain.setOptions({
		sorting : { enabled      : false },
		display : { columnMovable: false }
	});
	
	var columns = 
		[	
			{
				name      : "DESC",
				fieldName : "DESC",
				header    : {text : '<spring:message code="lbl.category"/>'},
				styles    : {textAlignment : "near", background : gv_editColor},
				editable  : false,
				width     : 120
			}, {
				name      : "TOT_QTY", 
				fieldName : "TOT_QTY", 
				header    : {text: '<spring:message code="lbl.qty" javaScriptEscape="true" />'},
				styles    : {textAlignment: "far", background : gv_editColor, numberFormat : "#,##0"},
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
				name      : "TOT_AMT", 
				fieldName : "TOT_AMT", 
				header    : {text: '<spring:message code="lbl.amount" javaScriptEscape="true" />'},
				styles    : {textAlignment: "far", background : gv_editColor, numberFormat : "#,##0"},
				dataType  : "number",
				editable  : false,
				width     : 130
			}
		];

	grdMain.setColumns(columns);
	
	var fields = new Array();
	fields = [
		{ fieldName : "DESC"},
		{ fieldName : "TOT_QTY", dataType : 'number'},
		{ fieldName : "TOT_AMT", dataType : 'number'}
    ];
	
	dataProvider.setFields(fields);
	
}


//조회
function fn_apply(sqlFlag) {
	

	//메인 데이터를 조회
	fn_getGridData(sqlFlag);
}

//그리드 데이터 조회
function fn_getGridData(sqlFlag) {
	
	FORM_SEARCH._mtd     = "getList";
	FORM_SEARCH.sql 	 = sqlFlag;
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"supply.product.prodPlanSummary"}];
	
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

//엑셀, 쿼리 다운로드 권한 확인
function fn_excelSqlAuth() {
	
	gfn_service({
	    async   : false,
	    url     : GV_CONTEXT_PATH + "/biz/obj",
	    data    : {
   			_mtd : "getList",
   			popUpMenuCd : popUpMenuCd,
   			tranData : [
   				{outDs : "authorityList", _siq : "supply.product.prodPlanSummaryExcelSql"}
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
		<div class="pop_tit"><spring:message code="lbl.summary"/></div>
		<div class="popCont">
			<div class="srhwrap">
				<div class="srhcondi">
					<ul style="float:right;">
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