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
var measureCd = "${param.measure}";
var paramMenuCd = "${menuInfo.menuCd}";
var typeCd = "${param.type}";

$("document").ready(function (){
	gfn_popresize();
	fn_initData();
	fn_initEvent();
	
});

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

/******************************************************************************************
** 데이터 초기화
******************************************************************************************/
function fn_initData() {
	fn_getCopyInfo();
}


/******************************************************************************************
** 조회 하기
******************************************************************************************/
function fn_getCopyInfo() {
	
	gfn_service({
	    async   : false,
	    url     : GV_CONTEXT_PATH + "/biz/obj",
	    data    : {
	    	_mtd     :"getList",
	    	menuCd   : paramMenuCd,
	    	fromWeek : "${param.fromWeek}",
	    	toWeek   : "${param.toWeek}",
	    	year     : "${param.year}",
	    	tranData : [
	    		{outDs : "meaList", _siq : "common.measure"},
	    		{outDs : "weekList", _siq : "dp.popup.copyWeek"}
	    	]
	    },
	    success :function(data) {
	    	
	    	var temp = [];
	    	$.each(data.meaList, function(n, v) {
	    		
	    		var cd = v.CD;
	    		
	    		if(cd == "AP1_DMD1_SP" || cd == "AP1_DMD2_SP" || cd == "AP1_DMD3_SP" || cd == "AP1_SP" ||
	    		   cd == "AP2_DMD1_SP" || cd == "AP2_DMD2_SP" || cd == "AP2_DMD3_SP" || cd == "AP2_SP" ||
	    		   cd == "CFM_DMD1_SP" || cd == "CFM_DMD2_SP" || cd == "CFM_DMD3_SP" || cd == "CFM_SP"){
	    			
	    			temp.push({CODE_CD : v.CD, CODE_NM : v.NM});
	    		}
			});
	    	
	    	codeMap.MEASURE = temp;
	    	codeMap.PWEEK = data.weekList;
	    	
	    }
	}, "obj");
	
	fn_initFilter();
}

/******************************************************************************************
** 필터 초기화
******************************************************************************************/
function fn_initFilter() {
	
	var sourceLen = codeMap.MEASURE.length;
	var sourceExcept, targetExcept;
	
	if(measureCd == "AP2_SP"){
		sourceExcept = ["AP2_SP"];
		targetExcept = ["AP1_DMD1_SP", "AP1_DMD2_SP", "AP1_DMD3_SP", "AP1_SP"];	
	}else if(measureCd == "CFM_SP"){
		sourceExcept = ["CFM_SP"];
		targetExcept = ["AP2_DMD1_SP", "AP2_DMD2_SP", "AP2_DMD3_SP", "AP2_SP"];
	}
	
	if(measureCd == "AP2_SP" && typeCd != "Value"){
		
		var cnt = 0;
		
		$.each(codeMap.MEASURE, function(i, val){
			
			var codeCd = val.CODE_CD;
			
			if(codeCd == "AP1_DMD1_SP" || codeCd == "AP1_DMD2_SP" || codeCd == "AP1_DMD3_SP"){
				cnt++;
			}
		});
		
		if(cnt < 3){
			sourceExcept.push("AP1_SP");
			targetExcept.push("AP2_SP");
		}
	}else if(measureCd == "CFM_SP" && typeCd != "Value"){
		var cnt = 0;
		
		$.each(codeMap.MEASURE, function(i, val){
			
			var codeCd = val.CODE_CD;
			
			if(codeCd == "AP2_DMD1_SP" || codeCd == "AP2_DMD2_SP" || codeCd == "AP2_DMD3_SP"){
				cnt++;
			}
		});
		
		if(cnt < 3){
			sourceExcept.push("AP2_SP");
			targetExcept.push("CFM_SP");
		}
	}
	
	if(typeCd == "ST"){
		
		if(sourceLen == 1){
			if(measureCd == "CFM_SP"){
				alert('<spring:message code="msg.cfmSt"/>');	
			}else if(measureCd == "AP2_SP"){
				alert('<spring:message code="msg.ap2St"/>');
			}else if(measureCd == "AP1_SP"){
				alert('<spring:message code="msg.ap1Sp"/>');
			}
			/* else if(measureCd == "CPFR_SP"){
				alert('<spring:message code="msg.cpfrSp"/>');
			} */
		}
		gfn_setMsCombo("source", codeMap.MEASURE, sourceExcept, {width : "130px"});
	}else if(typeCd == "WW"){
		gfn_setMsCombo("source", codeMap.MEASURE, sourceExcept, {width:"130px"});
	}else{
		$("#source").inputmask("numeric");
	}
	
	gfn_setMsCombo("target", codeMap.MEASURE, targetExcept, {width : "130px"});
	gfn_setMsCombo("fromWeek", codeMap.PWEEK, [], {width : "130px"});
	gfn_setMsCombo("toWeek", codeMap.PWEEK, [], {width : "130px"});
	
	$("#source").val("");
	$("#target").val("");
	$("#toWeek").val("${param.toWeek}");
}

/******************************************************************************************
** 이벤트 세팅
******************************************************************************************/
function fn_initEvent() {
	
	// 버튼 이벤트
	$("#btnApply").click("on", function() { fn_apply(); });
	$("#btnClose").click("on", function() { window.close(); });
	
	// From ~ To Week 이벤트
	$("#fromWeek,#toWeek").change("on", function() { fn_weekChange(this.id); });
	$("#source,#target").change("on", function() { fn_sourceTargetChange(this.id); });
}

/******************************************************************************************
** 원본, 목표 변경시 이벤트
******************************************************************************************/
function fn_sourceTargetChange(id){
	
	if(typeCd != "Value"){
		
		var val = $("#" + id).val();
		
		if(id == "source"){
			
			if(val == "AP1_SP"){
				$("#target").val("AP2_SP");
				$("#target").attr("disabled", true);
			}else if(val == "AP2_SP"){
				$("#target").val("CFM_SP");
				$("#target").attr("disabled", true);
			}else{
				$("#target").val("");
				$("#target").attr("disabled", false);
			}
			
		}else if(id == "target"){
			
			if(val == "AP2_SP"){
				$("#source").val("AP1_SP");
				$("#target").attr("disabled", true);
			}else if(val == "CFM_SP"){
				$("#source").val("AP2_SP");
				$("#target").attr("disabled", true);
			}
		}	
	}
}

/******************************************************************************************
** 주차 변경시 이벤트
******************************************************************************************/
function fn_weekChange(source) {
	
	var fromIdx = 0;
	var targetId, targetVal;
	var startIdx, endIdx;
	var selected = $("#" + source).val();
	
	for(var i = 0; i < codeMap.PWEEK.length; i++){
		if (codeMap.PWEEK[i].CODE_CD == selected) {
			fromIdx = i;
			break;
		}
	}
		
	if (source == "fromWeek") {
		targetId = "#toWeek";
		targetVal = $(targetId).val();
		startIdx = fromIdx;
		endIdx = codeMap.PWEEK.length-1;
	} else {
		targetId = "#fromWeek", targetVal = $(targetId).val();
		startIdx = 0;
		endIdx = fromIdx;
	}
	
	$(targetId +" option").remove();
	
	for (var i = startIdx; i <= endIdx; i++) {
		$(targetId).append('<option value="' + codeMap.PWEEK[i].CODE_CD + '">' + codeMap.PWEEK[i].CODE_NM + '</option>');
	}
	$(targetId).val(targetVal);
}

/******************************************************************************************
** 적용 버튼 이벤트
******************************************************************************************/
function fn_apply() {
	
	if(opener && opener.fn_popupApplyCallback){
		
		var source = $("#source").val();
		var target = $("#target").val();
		
		if (gfn_isNull(source) || gfn_isNull(target)) {
			return;
		}
		
		gfn_blockUI();
		opener.fn_popupApplyCallback(typeCd, source, target, $("#fromWeek").val(), $("#toWeek").val());
		gfn_unblockUI();
	}
	window.close(); 
}

/******************************************************************************************
** 값 변경 이벤트
** -값일 경우 초기화
******************************************************************************************/
function fn_keyPress(e){
	
	if(event.keyCode == 189 || event.keyCode == 190){
		$("#source").val("");
	}
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
									<input type="text" id="source" name="source" class="ipt" style="width:118px; padding-right:5px" onkeyup="fn_keyPress(this);">
								</div>	
	</c:otherwise>
</c:choose>
							</li>
							<li>
								<strong><spring:message code="lbl.target"/></strong>
								<div class="selectBox">
									<select id="target" name="target" class="iptcombo"></select>
								</div>
							</li>
						</ul>
						<ul>
							<li>
<c:choose>
	<c:when test="${param.type == 'WW'}">
								<strong><spring:message code="lbl.sourceWeek"/></strong>
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