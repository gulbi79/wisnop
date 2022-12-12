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

<script type="text/javascript">
$(function() {
	
	var value = "<spring:eval expression="@environment.getProperty('props.devMode')"/>";
	if(value != "REAL"){
		$("#serverChk").val(value);
		$("#serverChk").show();
	}
	
	<c:if test="${loginMap.errCode == '-1'}">
		alert('${loginMap.errMsg}');
		$("#userPw").focus();
	</c:if>

	<c:if test="${loginMap.errCode == '-3'}">
		$("#userPw").val('${loginMap.userPw}');
		alert('${loginMap.errMsg}');
		$("#cfnDiv").show();
		//$("#userPw").val("");
		$("#userPw").focus();
	</c:if>
	
	<c:if test="${not empty sessionScope.GV_USER_ID}">
		location.href="${ctx}/login/goPortal";
	</c:if>
	
	<c:if test="${not empty cookie.snopCookieId}">
		//$('input:checkbox[id="chkAutoLogin"]').attr("checked",true);
		$('input:checkbox[id="chkAutoLogin"]').attr("checked",false);
	</c:if>
	
    $("#loginSubmitBtn").on("click",function() {
    	var userId = $("#userId").val();
    	//var userPw = gfn_replaceAll($("#userPw").val(), "$", "");
    	var userPw = $("#userPw").val();
    
    	if (userId == undefined || userId == null || userId == "") {
    		alert("아이디를 입력해주세요!");
    		$("#userId").focus();
    		return; 
    	}
    	if (userPw == undefined || userPw == null || userPw == "") {
    		alert("패스워드를 입력해주세요!");
    		$("#userPw").focus();
    		return; 
    	}
    	
    	
    	
    	
    	if ($("#cfnDiv").css("display") != "none") {
    		
    		var passwordRules = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$/;
    		var passwordRules2 = /(\w)\1\1/;
    		var passwordRulesYn = passwordRules.test(userPw);
    		var passwordRules2Yn = passwordRules2.test(userPw);
    		var passwordRules3Yn = stck(userPw, 3);
    		//var cfnPw = gfn_replaceAll($("#userPwCfn").val(), "$", "");
    		var cfnPw = $("#userPwCfn").val();
    		var cfnPwInclude = cfnPw.indexOf("$");
    		 
    		if (userPw != cfnPw) {
    			alert("패스워드가 일치하지 않습니다.");
    			$("#userPwCfn").focus();
        		return;
    		}
    		
    		if(cfnPwInclude != -1){
    			alert("$ 를 사용할 수 없습니다.")
    			return;
    		}
    		
    		if(!passwordRulesYn){
    			alert("숫자와 영문 대소문자  조합으로 8자리 이상 사용해야 합니다.")
    			$("#userPw").focus();
    			$("#userPw,#userPwCfn").val("");
				return;
    		}
    		
    		if(passwordRules2Yn){
    			alert('같은 문자를 3번 이상 사용하실 수 없습니다.');
    			$("#userPw").focus();
    			$("#userPw,#userPwCfn").val("");
    			return;
    		}
    		
    		if(!passwordRules3Yn){
    			alert('연속된 문자를 3번 이상 사용하실 수 없습니다.');
    			$("#userPw").focus();
    			$("#userPw,#userPwCfn").val("");
    			return;
    		}
    	}
    	
    	//$("#userPw").val(userPw);
    	//$("#userPwCfn").val(userPw);
    	
    	/* setTimeout(function() {
    			
    	}, 3000); */
    	
    	goLogin();
    	
    });
    
    $('form input').keydown(function (e) {
        if (e.keyCode == 13) {
        	if ($("#cfnDiv").css("display") == "none" && this.id == "userPw") {
        		$("#loginSubmitBtn").trigger("click");
        	} else if (this.id == "userPwCfn") {
        		$("#loginSubmitBtn").trigger("click");
        	} else {
	        	var inputs = $(this).parents("form").eq(0).find(":input");
	            if (inputs[inputs.index(this) + 1] != null) {                    
	                inputs[inputs.index(this) + 1].focus();
	            }
	            e.preventDefault();
	            return false;
        	}
        }
    });
});

//연속된 문자 카운트
function stck(str, limit) {
    var o, d, p, n = 0, l = limit == null ? 4 : limit;
    for (var i = 0; i < str.length; i++) {
        var c = str.charCodeAt(i);
        if (i > 0 && (p = o - c) > -2 && p < 2 && (n = p == d ? n + 1 : 0) > l - 3) return false;
        d = p, o = c;
    }
    return true;
}

function goLogin() {
    $("#mainForm").attr("onSubmit", "return true");
    $("#mainForm").attr("action", "${ctx}/login/submit");
    $("#mainForm").submit().attr("onSubmit", "return false");
}

function gfn_replaceAll(fullStr,str1, str2, ignore) {
	if (gfn_isNull(fullStr)) return "";
	return fullStr.replace(new RegExp(str1.replace(/([\/\,\!\\\^\$\{\}\[\]\(\)\.\*\+\?\|\<\>\-\&])/g,"\\$&"),	(ignore?"gi":"g")),(typeof(str2)=="string")?str2.replace(/\$/g,"$$$$"):str2);
}

function gfn_nvl(obj,rObj) {
	if (gfn_isNull(obj)) return rObj;
	else return obj;
}

function gfn_isNull(obj) {
	
	if (obj == undefined || obj == null || obj == "" || obj == 'undefined') return true;
	else return false;
}

</script>
</head>
<body id="login">
    <div id="loginBox">
		<div id="tbox">
			<div class="thead">
				<h1><a href="#"><img src="${ctx}/statics/images/common/logo_hd.png" alt="WonIk"></a></h1>
				<h1 id="serverChk" style="text-align: center;font-size: 50px;display:none;">NEW개발서버</h1>
			</div>
			<c:if test="${empty sessionScope.GV_USER_ID}">
				<form id="mainForm" name="mainForm" method="POST" onSubmit="return false;">
				<div class="frm">
					<div class="fst"><input type="text"  id="userId" name="userId" value="${loginMap.userId}" placeholder="ID"/></div>
					<div class="fst"><input type="password" id="userPw" name="userPw" placeholder="PASSWORD"/></div>
					<div id="cfnDiv" style="display:none"><input type="password" id="userPwCfn" name="userPwCfn" placeholder="CONFIRM"/></div>
				</div>
				<a href="#" id="loginSubmitBtn" class="btn_login">LOGIN</a>
				<div class="view_combo" style="display:none;">
					<div class="ilist">
						<ul class="rdofl" style="padding-top:5px;">
							<li><input type="checkbox" id="chkAutoLogin" name="chkAutoLogin"><label for="chkAutoLogin">자동 로그인</label></li>
						</ul>
					</div>
				</div>
				<sec:csrfInput />
				</form>
			</c:if>
		</div>
	</div>
</body>
</html>
