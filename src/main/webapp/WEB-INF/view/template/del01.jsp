<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript" src="${ctx}/statics/nicEdit/nicEdit.js"></script>
	<!-- 실행계획달성율 -->
	<script type="text/javascript">
	
	var myNicEditor; 

	bkLib.onDomLoaded(function() { 
		myNicEditor = new nicEditor().panelInstance('myInstance1');
	});
	
	
	function dataCall(){
		
		console.log(nicEditors.findEditor('myInstance1').getContent());
	}
	
	function setCall(){
		nicEditors.findEditor('myInstance1').setContent ('<h2><u><font face="courier new" size="5">ㄴㅁㅇㅁㄴㅇ</font></u><img src="https://i.imgur.com/IZiTTOL.png" width="826"></h2>');
	}
	
 
	$(document).ready(function() {
	});
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<%-- <input type="hidden" id="pageFlag" name="pageFlag" value="M3">
		<input type="hidden" id="itemType" name="itemType" value="10,50"/> 
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %> 
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divCustGroup"></div>
					<div class="view_combo" id="divAmtQty"></div>
					<jsp:include page="/WEB-INF/view/common/filterViewHorizonMonth.jsp" flush="false" />
				</div>
				<div class="bt_btn">
					<a href="#" class="fl_app" id="btnSearch"><spring:message code="lbl.search"/></a>
				</div>
			</div>
		</div> --%>
		</form>
	</div>
	
	<!-- contents -->
	<div id="b" class="split split-horizontal">
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
			<div class="use_tit">
				<!-- <h3>My Opportunities</h3> <h4>- recently created</h4> -->
			</div>
			<div class="scroll">
				<!-- 그리드영역 -->
				<div style="width: 100%;height:100%" class="realgrid1">
					<textarea id="myInstance1" style="width: 800px;height:800px;" ></textarea>
					
				</div>
			</div>
			
			<div class="cbt_btn">
				<div class="bright">
					<a href="#" class="app1" onclick="javascript:dataCall();">데이터 호출</a>
					<a href="#" class="app2" onclick="javascript:setCall();">데이터 세팅</a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
