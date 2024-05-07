<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>  

<!-- body에 class="login"을 붙여주세요 -->
<body class="login">
    <canvas id="gradient"></canvas>
<form class="findPassForm" id="form-horizontal" action="/findPw" method="post">
    <div class="login-container">
        <div class="login-wrap">
            <h1 class="logo-wrap"><span class="logo">WORKFOREST</span></h1>
            <h2 class="sub-tit">비밀번호 찾기</h2>
            <c:if test="${param.error=='' }">
            	<span class="msg-txt2">정보를 다시 입력하세요</span>
            </c:if>
            <div class="input id">
                <input type="text" name="empNo" id="'empNo" placeholder="사원번호">
            </div>
            <div class="input mail">
                <input type="text" name="email" id="'email" placeholder="이메일">
            </div>
            <button type="submit" class="submit-btn">임시 비밀번호 발급</button>
        </div>
    </div>
          	<sec:csrfInput />
    </form>
</body>