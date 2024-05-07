<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" src="/resources/js/jquery-3.7.0.min.js"></script>
<script type="text/javascript" src="/resources/js/stripe-gradient.js"></script>
<script>
function emailCreate(){
    window.location.href = 'create';
}
function emailSendbox(){
    window.location.href = 'sendbox';
}
function emailAttachbox(){
    window.location.href = 'attachbox';
}
function emailDeletebox(){
    window.location.href = 'deletebox';
}
function emailUnreadbox(){
    window.location.href = 'unreadbox';
}
function emailMain(){
    window.location.href = 'main';
}
function emailTemporary(){
    window.location.href = 'temporarybox';
}

</script>
<style>
.center {
  /* 설정 */
  position: relative;
}

.success {
  /* 상하좌우 정중앙 정렬하기 */
  position: absolute;
  top: 30%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.message {
  align-content: center;
  text-align : center;
}
</style>
<!-- =============== body 시작 =============== -->
<!-- =============== 상단타이틀영역 시작 =============== -->
<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
    <h1 class="page-tit">메일</h1>

    <div class="side-util"></div>
</div>
<!-- =============== 상단타이틀영역 끝 =============== -->
<!-- =============== 컨텐츠 영역 시작 =============== -->
<%-- <%=session.getAttribute("position") %> 세션가져오기 --%>
<div class="wf-mail-wrap">
	<!-- 메일 왼쪽 파트 -->
	<div class="wf-content-area wf-mail-left" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
		<button type="button" class="btn2 mail-btn" onclick="emailCreate()">메일쓰기</button>
		<div class="wf-mail-top">
			<button type="button" onclick="emailUnreadbox()">
				<span class="data">${noreadCount}</span>안읽음
			</button>
			<button type="button" onclick="emailAttachbox()">
				<i class="xi-attachment"></i>첨부
			</button>
		</div>

		<div class="wf-mail-menu">
			<button type="button" class="getmailbtn1" onclick="emailMain()">
				<i class="xi-mail-read-o"></i> 받은메일함 ${getCount}
			</button>
			<button type="button" class="getmailbtn2" onclick="emailSendbox()">
				<i class="xi-share"></i> 보낸메일함 ${sendCount}
			</button>
			<button type="button" class="getmailbtn3" onclick="emailTemporary()">
				<i class="xi-folder-o"></i> 임시보관함 ${tempCount}
			</button>
			<button type="button" class="getmailbtn4" onclick="emailDeletebox()">
				<i class="xi-trash-o"></i> 휴지통 ${deleteCount}
			</button>
		</div>
	</div>

	<!-- 메일 오른쪽 파트 -->
	<div class="wf-mail-right center" data-aos="fade-right" data-aos-duration="700" data-aos-delay="400">
				<!-- 성공 메세지 출력 -->
				<div class="success">
				<img src="/resources/img/icon/email1.png" />
				<h1 class="message">메세지를 성공적으로 보냈습니다.</h1>
				</div>

	</div>
	<!-- 메일 오른쪽 파트 끝 -->

</div>
<!-- =============== 컨텐츠 영역 끝 =============== -->

<!-- =============== body 끝 =============== -->