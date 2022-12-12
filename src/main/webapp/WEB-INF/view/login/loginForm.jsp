<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
<title>로그인 페이지</title>
<link rel="stylesheet" href="${ctx}/statics/css/jquery-ui.css" type="text/css" />
<link rel="stylesheet" href="${ctx}/statics/css/style.css" type="text/css" />
<script type="text/javascript" src="${ctx}/statics/js/jquery/jquery-3.1.0.min.js"></script>

<body>

<h3>아이디와 비밀번호를 입력해주세요.</h3>

<c:url value="/login" var="loginUrl" />
<form:form name="f" action="${loginUrl}" method="POST">
    <c:if test="${param.error != null}">
        <p>아이디와 비밀번호가 잘못되었습니다.</p>
    </c:if>
    <c:if test="${param.logout != null}">
        <p>로그아웃 하였습니다.</p>
    </c:if>
    <p>
        <label for="username">아이디</label>
        <input type="text" id="id" name="id" />
    </p>
    <p>
        <label for="password">비밀번호</label>
        <input type="password" id="password" name="password"/>
    </p>
    <button type="submit" class="btn">로그인</button>
</form:form>

</body>

</html>
