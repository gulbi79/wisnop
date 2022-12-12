<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<div class="view_combo" id="divPlanId">
		<div class="ilist">
			<div class="itit"><spring:message code="lbl.planId"/></div>
			<div class="iptdv borNone">
				<select id="planId" name="planId" class="iptcombo"></select>
			</div>
		</div>
	</div>
	<c:if test="${param.wType!='M'}">
	<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
		<jsp:param name="radioYn" value="${param.radioYn}"/>
		<jsp:param name="wType" value="${param.wType}"/>
	</jsp:include>
	</c:if>
	<c:if test="${param.wType=='M'}">
	<jsp:include page="/WEB-INF/view/common/filterViewHorizonMonth.jsp" flush="false" />
	<input type="hidden" id="startMonth" name="startMonth"/>
	<input type="hidden" id="endMonth" name="endMonth"/>
	<input type="hidden" id="startWeek" name="startWeek"/>
	<input type="hidden" id="endWeek" name="endWeek"/>
	<input type="hidden" id="cutOffFlag" name="cutOffFlag"/>
	<input type="hidden" id="releaseFlag" name="releaseFlag"/>
	</c:if>
