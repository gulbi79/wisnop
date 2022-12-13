<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% response.setStatus(HttpServletResponse.SC_OK); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>잘못된 요청입니다.</title>
<style>
    #errorbox {
        width:500px;
        height:500px;
        margin:auto;
        text-align:center;
        vertical-align:middle;
        /* border:1px solid black; */
        font-size:14px;
    }
    a {
        text-decoration:none;
        color:gray;
        border:1px solid gray;
        padding:3px;
    }
</style>
</head>
	<body>
		<div id="errorbox">
		    <br/><br/>
<%-- 		    <img src="${ctx}/static/img/main/warning.png"/> --%>
		    <br/>
		    <h2>요청하신 페이지를 표시할 수 없습니다.</h2>
		    <br/>
		    <p>주소가 올바른지 확인해주시고, 잠시 후 다시 시도해주세요.</p>
		    <br/>
<%-- 		    <a href="<c:url value='/common/main'/>"><span>메인으로</span></a> --%>
		</div>
	</body>
</html>

