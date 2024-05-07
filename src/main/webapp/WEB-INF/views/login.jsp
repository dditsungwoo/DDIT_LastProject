<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<body class="login">
    <canvas id="gradient"></canvas>

    <div class="login-container">
        <div class="login-wrap">
            <h1 class="logo-wrap"><span class="logo">WORKFOREST</span></h1>
            <div class="input id">
                <input type="text" name="empNo" placeholder="사원번호">
            </div>
            <div class="input pw">
                <input type="password" name="empPw" placeholder="비밀번호">
            </div>
            <!-- <span class="msg-txt1">비밀번호가 일치합니다</span> -->
            <!-- <span class="msg-txt2">비밀번호가 일치하지 않습니다.</span> -->

            <div class="check-lst">
                <span class="remember">
                    <input type="checkbox" class="checkbox" id="checkbox">
                    <label for="checkbox">사번 기억하기</label>
                </span>
                <a href="javascript:void(0)" class="forgot">비밀번호 찾기</a>
            </div>

            <button type="submit" class="submit-btn">로그인</button>
        </div>
    </div>
</body>
