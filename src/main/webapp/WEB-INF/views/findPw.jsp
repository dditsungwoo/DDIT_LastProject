<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<!-- body에 class="login"을 붙여주세요 -->
<body class="login">
    <canvas id="gradient"></canvas>

    <div class="login-container">
        <div class="login-wrap">
            <h1 class="logo-wrap"><span class="logo">WORKFOREST</span></h1>
            <h2 class="sub-tit">비밀번호 찾기</h2>
            <div class="input id">
                <input type="text" placeholder="사원번호">
            </div>
            <div class="input mail">
                <input type="text" placeholder="이메일">
            </div>
            <span class="msg-txt1">임시 비밀번호가 이메일로 전송되었습니다.</span>
            <!-- <span class="msg-txt2">비밀번호가 일치하지 않습니다.</span> -->

            <button type="submit" class="submit-btn">임시 비밀번호 발급</button>
        </div>
    </div>
</body>