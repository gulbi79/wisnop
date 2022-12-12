<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>세션만료 페이지</title>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
</head>
<body>
    <script type="text/javascript">
    $(function() {
	    alert("세션이 만료되었습니다. \n로그인 페이지로 이동합니다.", function() {
	    	if (gfn_getCurWindow()) {
				gfn_getCurWindow().parent.location.href = "${ctx}/login/form";
				self.close();
			} else {
		    	parent.location.href = "${ctx}/login/form";
			}
	    });
    });
    </script>
</body>
</html>
