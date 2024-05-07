<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<body class="login">
    <canvas id="gradient"></canvas>
<form class="findPassForm" id="form-horizontal" action="/findPw" method="post">
    <div class="login-container">
        <div class="login-wrap">
            <h1 class="logo-wrap"><span class="logo">WORKFOREST</span></h1>
            <h2 class="sub-tit"> <span class="msg-txt1">임시 비밀번호가 이메일로 전송되었습니다.</span></h2>
            <br><br>
              <a href="/" class="forgot" style="display: block; text-align: center;">로그인하러 가기</a>
        </div>
    </div>
          	<sec:csrfInput />
    </form>
</body>