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
				<span class="msg-txt2">비밀번호가 일치하지 않습니다.</span>
			</c:if>
			<form class="form-horizontal" action="/emp/detailLogin" method="post">
				<div class="input pw">
					<input type="password" name="password" placeholder="비밀번호">
				</div>
				<button type="submit" class="submit-btn">확인</button>
				<sec:csrfInput />
			</form>
		</div>
	</div>
</body>
