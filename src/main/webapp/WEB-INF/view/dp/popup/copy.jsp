<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.copy${param.type}"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>
<style type="text/css">
.srhcondi > ul > li > strong { width:80px; }
.srhcondi > ul > li { width:230px; }
</style>
<script type="text/javascript">
var popupWidth, popupHeight;
var codeMap = {};

$("document").ready(function (){
	gfn_popresize();
	fn_initData();
	fn_initFilter();
	fn_initEvent();
	
});

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

//데이터 초기화
function fn_initData() {
	fn_getCopyInfo();
}

function fn_getCopyInfo() {
	
	gfn_service({
	    async   : false,
	    url     : GV_CONTEXT_PATH + "/biz/obj.do",
	    data    : {
	    	_mtd     :"getList",
	    	menuCd   : "${param.menuCd}",
	    	fromWeek : "${param.fromWeek}",
	    	toWeek   : "${param.toWeek}",
	    	year     : "${param.year}",
	    	tranData : [
	    		{outDs:"meaList" ,_siq:"common.measure"},
	    		{outDs:"weekList",_siq:"dp.popup.copyWeek"}
	    	]
	    },
	    success :function(data) {
	    	
	    	var temp = [];
	    	$.each(data.meaList, function(n,v) {
	    		if (v.CD == "AP1_SP"          ||
	    			v.CD == "AP2_SP"          ||
	    			v.CD == "CPFR_SP"         ||
	    			v.CD == "CFM_SP"          ||
	    			v.CD == "YP_QTY"          ||
	    			v.CD == "PROD_PLAN_QTY"   ||
	    			v.CD == "CALC_BOH_QTY"    ||
	    			v.CD == "AVAIL_QTY"       ||
	    			v.CD == "CALC_EOH_QTY"    ||
	    			v.CD == "OPEN_SO"         ||
	    			v.CD == "YEARLY_PLAN_Y_1" ||
	    			v.CD == "SALES_QTY_Y_1"   ) {
	    			temp.push({CODE_CD:v.CD, CODE_NM:v.NM});
	    		}
			});
	    	
	    	codeMap.MEASURE = temp;
	    	codeMap.PWEEK   = data.weekList;
	    }
	}, "obj");
}

//필터 초기화
function fn_initFilter() {

<c:choose>

	<c:when test="${param.type == 'ST'}">
	
	var val = '${param.measure}';
	
	if(codeMap.MEASURE.length == 1){
		if(val == "CFM_SP"){
			alert('<spring:message code="msg.cfmSt"/>');	
		}else if(val == "AP2_SP"){
			alert('<spring:message code="msg.ap2St"/>');
		}else if(val == "AP1_SP"){
			alert('<spring:message code="msg.ap1Sp"/>');
		}else if(val == "CPFR_SP"){
			alert('<spring:message code="msg.cpfrSp"/>');
		}
	}
	
	gfn_setMsCombo("source", codeMap.MEASURE, ['${param.measure}'], {width:"130px"});
	</c:when>
	
	<c:when test="${param.type == 'WW'}">
	gfn_setMsCombo("source"  , codeMap.MEASURE, [], {width:"130px"});
	</c:when>
	
	<c:otherwise>
	$("#source").inputmask("numeric");
	</c:otherwise>
</c:choose>


	gfn_setMsCombo("target"  , codeMap.MEASURE, [], {width:"130px"});
	gfn_setMsCombo("fromWeek", codeMap.PWEEK  , [], {width:"130px"});
	gfn_setMsCombo("toWeek"  , codeMap.PWEEK  , [], {width:"130px"});
	
	$("#target").val("${param.measure}");
<c:choose>
	<c:when test="${param.menuCd == 'DP101'}">
	$("#toWeek").val("${param.year}12");
	</c:when>
	<c:otherwise>
	$("#toWeek").val("${param.toWeek}");
	</c:otherwise>
</c:choose>
}

//이벤트 초기화
function fn_initEvent() {
	
	// 버튼 이벤트
	$("#btnApply").click("on", function() { fn_apply(); });
	$("#btnClose").click("on", function() { window.close(); });
	
	// From ~ To Week 이벤트
	$("#fromWeek,#toWeek").change("on", function() { fn_weekChange(this.id); });
}

function fn_weekChange(source) {
	
	var selected = $("#"+source).val();
	var fromIdx  = 0;
	
	for (var i = 0; i < codeMap.PWEEK.length; i++) {
		if (codeMap.PWEEK[i].CODE_CD == selected) {
			fromIdx = i;
			break;
		}
	}
	
	var targetId, targetVal;
	var startIdx, endIdx;	
	if (source == "fromWeek") {
		targetId  = "#toWeek";
		targetVal = $(targetId).val();
		startIdx  = fromIdx;
		endIdx    = codeMap.PWEEK.length-1;
	} else {
		targetId = "#fromWeek", targetVal = $(targetId).val();
		startIdx  = 0;
		endIdx    = fromIdx;
	}
	
	$(targetId+" option").remove();
	for (var i = startIdx; i <= endIdx; i++) {
		$(targetId).append('<option value="'+codeMap.PWEEK[i].CODE_CD+'">'+codeMap.PWEEK[i].CODE_NM+'</option>');
	}
	$(targetId).val(targetVal);
}

//선택
function fn_apply() {
	if (opener && opener.fn_popupApplyCallback) {
		
		var source = $("#source").val();
		var target = $("#target").val();
		if (gfn_isNull(source) || gfn_isNull(target)) {
			return;
		}
		
		gfn_blockUI();
		opener.fn_popupApplyCallback("${param.type}", source, target, $("#fromWeek").val(), $("#toWeek").val());
		gfn_unblockUI();
	}
	window.close();
}

</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit"><spring:message code="lbl.copy${param.type}"/></div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
					<div class="srhcondi">
						<ul>
							<li>
<c:choose>
	<c:when test="${param.type == 'ST' or param.type == 'WW'}">
								<strong><spring:message code="lbl.source"/></strong>
								<div class="selectBox">
									<select id="source" name="source" class="iptcombo"></select>
								</div>	
	</c:when>
	<c:otherwise>
								<strong><spring:message code="lbl.value"/></strong>
								<div class="selectBox">
									<input type="text" id="source" name="source" class="ipt" style="width:118px; padding-right:5px">
								</div>	
	</c:otherwise>
</c:choose>
							</li>
							<li>
								<strong><spring:message code="lbl.target"/></strong>
								<div class="selectBox">
									<select id="target" name="target" class="iptcombo" disabled="disabled"></select>
								</div>
							</li>
						</ul>
						<ul>
							<li>
<c:choose>
	<c:when test="${param.type == 'WW'}">
								<strong><spring:message code="lbl.sourceWeek"/></strong>
	</c:when>
	<c:when test="${param.menuCd == 'DP101'}">
								<strong><spring:message code="lbl.fromMonth"/></strong>
	</c:when>
	<c:otherwise>
								<strong><spring:message code="lbl.fromWeek"/></strong>
	</c:otherwise>
</c:choose>
								<div class="selectBox">
									<select id="fromWeek" name="fromWeek" class="iptcombo"></select>
								</div>
							</li>
							<li>
<c:choose>
	<c:when test="${param.type == 'WW'}">
								<strong><spring:message code="lbl.targetWeek"/></strong>
	</c:when>
	<c:when test="${param.menuCd == 'DP101'}">
								<strong><spring:message code="lbl.toMonth"/></strong>
	</c:when>
	<c:otherwise>
								<strong><spring:message code="lbl.toWeek"/></strong>
	</c:otherwise>
</c:choose>
								<div class="selectBox">
									<select id="toWeek" name="source" class="toWeek"></select>
								</div>
							</li>
						</ul>
					</div>
				</form>
			</div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnApply" class="app2"><spring:message code="lbl.apply"/></a>
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>