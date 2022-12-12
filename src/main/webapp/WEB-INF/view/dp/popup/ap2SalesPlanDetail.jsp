<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.ap2SalesPlanDetail"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
var popupWidth, popupHeight;
var dataRow, bucketList;
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
	//파마미터 정리
	dataRow    = ${param.dataRow};
	bucketList = '${param.bucket}'.split(",");
	//검색조건 정리
	fn_setSearchParam();
}

function fn_setSearchParam() {
	
	//부모검색조건
	FORM_SEARCH = opener.FORM_SEARCH;
	
	//하이라키 정보 설정
	FORM_SEARCH.hrcyFlag     = false;
	FORM_SEARCH.productList  = [];
	FORM_SEARCH.customerList = [];
	gfn_getCurWindow().gfn_getHrcyChecked(gfn_getCurWindow().gv_zTreeObj.product ,"product" ,null,FORM_SEARCH.productList);
	gfn_getCurWindow().gfn_getHrcyChecked(gfn_getCurWindow().gv_zTreeObj.customer,"customer",null,FORM_SEARCH.customerList);
	
	//선택한 자식인덱스
	var meaLength   = opener.MEASURE.user.length;
	var selGrpLvlId = Number(opener.dataProvider.getValue(dataRow, gv_grpLvlId));
	var curGrpLvlId;
	var childIdxs   = [];
	
	if (selGrpLvlId == 0) {
		childIdxs.push(dataRow);
	}
	
	for (var i = dataRow+meaLength; i < opener.dataProvider.getRowCount(); i+=meaLength) {
		curGrpLvlId = Number(opener.dataProvider.getValue(i, gv_grpLvlId));
		if (selGrpLvlId <= curGrpLvlId) {
			break;
		}
		if (curGrpLvlId == 0) {
			childIdxs.push(i);
		}
	}

	//선택한 자식의 키정보 추출
	var param = {};
	$.each(opener.DIMENSION.user, function(i,v) {
		
		var key1 = v.DIM_CD.substring(0, 9) + "_CD";
		var key2 = v.DIM_CD + "_CD";
		
		if (param[key1] == undefined) {
			param[key1] = [];
		}
		
		$.each(childIdxs, function() {
			var val2 = opener.dataProvider.getValue(this, key2);
			if ($.inArray(val2, param[key1]) == -1) {
				param[key1].push(val2);
			}
		});
	});
	
	for (var key in param) {
		FORM_SEARCH[key] = param[key].join(",");
	}
}

//필터 초기화
function fn_initFilter() {
}

//그리드 초기화
function fn_initGrid() {
	
	//메저 width 설정
	gv_meaW = 140;
	
	//그리드 설정
	gridInstance = new GRID();
	gridInstance.init("realgrid");
	grdMain      = gridInstance.objGrid;
	dataProvider = gridInstance.objData;
	gridInstance.custBucketFalg = true;
	
	//그리드 옵션
	grdMain.setOptions({
		sorting : { enabled      : false },
		display : { columnMovable: false }
	});
}

//이벤트 초기화
function fn_initEvent() {
	//버튼 이벤트
	$("#btnClose" ).click("on", function() { window.close(); });
	$(".fl_app"   ).click("on", function() {
		gfn_doExportExcel({
			fileNm             : '<spring:message code="lbl.ap2SalesPlanDetail"/>',
			formYn             : "Y",
			indicator          : "hidden",
			conFirmFlag        : false,
			applyDynamicStyles : true
		});
	});
}

//조회
function fn_apply() {
	
	//디멘전 정리
	DIMENSION.user = [];
	DIMENSION.user.push({DIM_CD:"PROD_LVL3_CD" , DIM_NM:'<spring:message code="lbl.prodL3"       />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:50});
	DIMENSION.user.push({DIM_CD:"PROD_LVL3_NM" , DIM_NM:'<spring:message code="lbl.prodL3Name"   />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
	DIMENSION.user.push({DIM_CD:"CUST_LVL2_CD" , DIM_NM:'<spring:message code="lbl.custL2"       />', LVL:20, DIM_ALIGN_CD:"L", WIDTH:80});
	DIMENSION.user.push({DIM_CD:"CUST_LVL2_NM" , DIM_NM:'<spring:message code="lbl.custL2Name"   />', LVL:20, DIM_ALIGN_CD:"L", WIDTH:80});
	DIMENSION.user.push({DIM_CD:"CUST_GROUP_CD", DIM_NM:'<spring:message code="lbl.custGroup"    />', LVL:30, DIM_ALIGN_CD:"L", WIDTH:50});
	DIMENSION.user.push({DIM_CD:"CUST_GROUP_NM", DIM_NM:'<spring:message code="lbl.custGroupName"/>', LVL:30, DIM_ALIGN_CD:"L", WIDTH:100});
	DIMENSION.user.push({DIM_CD:"ITEM_CD"      , DIM_NM:'<spring:message code="lbl.item"         />', LVL:40, DIM_ALIGN_CD:"L", WIDTH:80});
	DIMENSION.user.push({DIM_CD:"ITEM_NM"      , DIM_NM:'<spring:message code="lbl.itemName"     />', LVL:40, DIM_ALIGN_CD:"L", WIDTH:120});
	DIMENSION.user.push({DIM_CD:"SPEC"         , DIM_NM:'<spring:message code="lbl.spec"         />', LVL:40, DIM_ALIGN_CD:"L", WIDTH:150});
	DIMENSION.user.push({DIM_CD:"DRAW_NO"      , DIM_NM:'<spring:message code="lbl.drawNo"       />', LVL:40, DIM_ALIGN_CD:"L", WIDTH:120});
	DIMENSION.user.push({DIM_CD:"REMARK"       , DIM_NM:'<spring:message code="lbl.remark"       />', LVL:40, DIM_ALIGN_CD:"L", WIDTH:80});
	
	//메저 정리
	MEASURE.user = [];
	MEASURE.user.push({CD:"AP2_SP",NM:"AP2_SP"});
	
	//버킷 정리
	BUCKET.query = [];
	$.each(bucketList, function() {
		BUCKET.query.push({CD:this,NM:this.substring(2)});
	});
	
	//그리드를 그린다.
	fn_drawGrid();

	//조회조건 설정
	FORM_SEARCH.dimList	   = DIMENSION.user;
	FORM_SEARCH.meaList	   = MEASURE.user;
	FORM_SEARCH.bucketList = BUCKET.query;

	//메인 데이터를 조회
	fn_getGridData();
}

//필드 배열 객체를  생성
function fn_setFieldsBuket() {
	var fields = [];
	$.each(bucketList, function() {
		fields.push({ fieldName : this, dataType : "number" });
	});
	return fields;
}

//필드와 연결된 컬럼 배열 객체를 생성
function fn_setColumnsBuket() {
	var columns = [];
	$.each(bucketList, function() {
		columns.push({
			name         : this,
			fieldName    : this,
			editable     : false,
			header       : { text: this.substring(2) },
			styles       : { background : gv_noneEditColor, textAlignment: "far" },
			dynamicStyles: [gfn_getDynamicStyle(-2)],
			width        : 80,
		});
	});
	return columns;
}

//그리드를 그린다.
function fn_drawGrid() {
	gridInstance.setDraw();
	grdMain.removeColumn("CATEGORY_NM");
}

//그리드 데이터 조회
function fn_getGridData() {
	
	FORM_SEARCH._mtd     = "getList";
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"dp.popup.ap2SalesPlanDetail"}];
	
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

</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit"><spring:message code="lbl.ap2SalesPlanDetail"/></div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
					<div class="srhcondi">
					</div>
				</form>
				<div class="bt_btn">
					<a href="javascript:;" class="fl_app"><spring:message code="lbl.excelDownload"/></a>
				</div>
			</div>
			<div id="realgrid" class="realgrid1"></div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>