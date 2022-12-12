<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<script type="text/javascript">
    $(function() {
    	parent.brresize();
    });
    </script>

</head>
<body id="dvframe">
	<%//@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div class="msgpage">
		<div class="msgbox">
			<c:choose>
				<c:when test="${sessionScope.GV_BU_CD == 'QT'}">
			<div class="tit"><img src="${ctx}/statics/images/win_msg_t1.png" alt="Quartz"></div>
				</c:when>
				<c:when test="${sessionScope.GV_BU_CD == 'BM'}">
				</c:when>
				<c:when test="${sessionScope.GV_BU_CD == 'CM'}">
				</c:when>
				<c:when test="${sessionScope.GV_BU_CD == 'SNOP'}">
				</c:when>
			</c:choose>
			<div class="logo"><img src="${ctx}/statics/images/win_msg_bg1.png" alt="WonIk"></div>
		</div>
	</div>
</body>
</html>
