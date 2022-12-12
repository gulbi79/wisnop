<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<div id="view_Her">
		<strong class="filter_tit" id="filter_tit">View Horizon</strong>
		<c:if test="${param.radioYn=='Y'}">
		<ul class="rdofl">
			<li><input type="radio" id="rSWeek" name="vhWeekType" value="SW" onchange="javascript:gfn_setViewH();" <c:if test="${param.wType=='SW'}"> checked </c:if> > <label for="rSWeek"><spring:message code="lbl.stdWeek" /></label></li>
			<li><input type="radio" id="rPweek" name="vhWeekType" value="PW" onchange="javascript:gfn_setViewH();" <c:if test="${param.wType!='SW'}"> checked </c:if> > <label for="rPweek"><spring:message code="lbl.partialWeek" /></label></li>
		</ul>
		</c:if>
		<div class="tlist">
			<div class="tit2"><spring:message code="lbl.start" /></div>
			<input type="text" id="fromCal" name="fromCal" class="iptdate datepicker1" readonly value="" />
			<input type="<c:if test="${param.wType=='SW'}">hidden</c:if><c:if test="${param.wType!='SW'}">text</c:if>" id="fromPWeek" name="fromPWeek" class="iptdateweek" disabled="disabled" value=""/>
			<input type="<c:if test="${param.wType=='SW'}">text</c:if><c:if test="${param.wType!='SW'}">hidden</c:if>" id="fromWeek" name="fromWeek" class="iptdateweek" disabled="disabled" value=""/>
			<input type="hidden" id="swFromDate" name="swFromDate"/>
			<input type="hidden" id="pwFromDate" name="pwFromDate"/>
		</div>
		<div class="tlist">
			<div class="tit2"><spring:message code="lbl.end" /></div>
			<input type="text" id="toCal" name="toCal" class="iptdate datepicker2" readonly value="" />
			<input type="<c:if test="${param.wType=='SW'}">hidden</c:if><c:if test="${param.wType!='SW'}">text</c:if>" id="toPWeek" name="toPWeek" class="iptdateweek" disabled="disabled" value=""/>
			<input type="<c:if test="${param.wType=='SW'}">text</c:if><c:if test="${param.wType!='SW'}">hidden</c:if>" id="toWeek" name="toWeek" class="iptdateweek" disabled="disabled" value=""/>
			<input type="hidden" id="swToDate" name="swToDate"/>
			<input type="hidden" id="pwToDate" name="pwToDate"/>
		</div>
	</div>
