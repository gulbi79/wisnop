<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<script type="text/javascript" src="${ctx}/statics/js/jquery/jquery-3.1.0.min.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		var brheight = $(top.document).height() - 156;
		//$(top.document).find("#tt").css('height',brheight);
		$(top.document).find("iframe[name='${frameMenuCd}']").css('height',brheight);
		
		//동적 hidden 데이터 생성
		$("#menuFormArgs").html("");
		$("#menuFormArgs").html(parent.$("#menuFormArgs").html());
		
		$("#menuForm").attr("onSubmit","return true");
		
		if ("${paramMap.menuCd}" == "HOME") {
	    	$("#menuForm").attr("action","${ctx}/common/goHome");
		} else {
	    	$("#menuForm").attr("action","${ctx}/common/gomenu");
		}
	    $("#menuForm").submit().attr("onSubmit","return false");
	});
	
</script>
</head>
<body>
	<div>
		<form id="menuForm" name="menuForm" method="POST" onSubmit="return false;">
			<input type="hidden" id="moduleCd" name="moduleCd" value="${paramMap.moduleCd}" />
			<input type="hidden" id="menuCd" name="menuCd" value="${paramMap.menuCd}" />
			<input type="hidden" id="menuUrl" name="menuUrl" value="${paramMap.menuUrl}" />
			<input type="hidden" id="frameMenuCd" name="frameMenuCd" value="${paramMap.frameMenuCd}" />
			<sec:csrfInput />
			<div id="menuFormArgs"></div>
		</form>
	</div>
</body>
</html>
