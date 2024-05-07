<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<body class="login">
	<canvas id="gradient"></canvas>
	<div class="login-container">
		<div class="login-wrap">
			<h1 class="logo-wrap">
				<span class="logo">WORKFOREST</span>
			</h1>
			<c:if test="${param.error=='' }">
				<span class="msg-txt2">잘못된 정보 입력입니다.</span>
			</c:if>
			<form class="form-horizontal" action="/login" method="post">

				<div class="input id">
					<input type="text" id="username" name="username" placeholder="사원번호">
				</div>
				<div class="input pw">
					<input type="password" id="password" name="password"
						placeholder="비밀번호">
				</div>
				<div class="check-lst">
					<span class="remember"> <input type="checkbox"
						class="checkbox" id="remember-me" name="remember-me" /> <label
						for="checkbox">사번 기억하기</label>
					</span> <a href="/findPw" class="forgot">비밀번호 찾기</a>
				</div>
				<div>
					<button type="submit" class="submit-btn">로그인</button>
				</div>
				<br>
				<div class="wf-util">
					<button type="button" class="btn1" onclick="autoFill3()">대표이사</button>
					<button type="button" class="btn1" onclick="autoFill2()">팀      장</button>
					<button type="button" class="btn1" onclick="autoFill1()">사      원</button>
				</div>
				<sec:csrfInput />
			</form>
		</div>
	</div>
</body>
<script>
//사원등록-자동입력
function autoFill1() {

    var username = "2019202";
    var password= "asd";

    $("#username").val(username);
    $("#password").val(password);
  
}
function autoFill2() {

    var username = "2020015";
    var password= "asd";

    $("#username").val(username);
    $("#password").val(password);
}
function autoFill3() {

    var username = "2018001";
    var password= "asd";

    $("#username").val(username);
    $("#password").val(password);
}
</script>
