<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script>
function tempCreate(emailNo){
    window.location.href = '/mail/tempcreate?emailNo='+emailNo;
}
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

$(function(){

	const ckAll = document.querySelector("#chk1")
	// 다른 모든 체크박스들
	var checkboxes = document.getElementsByName('checkbox');

	// 전체 선택 체크박스의 클릭 이벤트 처리
	ckAll.addEventListener('click', function() {
	    for (var i = 0; i < checkboxes.length; i++) {
	        checkboxes[i].checked = ckAll.checked;
	    }
	});
	let chkBoxCnt=0;   // 개별 체크박스 갯수


	function chkAll(){
	    let selChkCnt=document.querySelector("#emailTbody").querySelectorAll("input[type='checkbox']:checked").length;
	    console.log("선택된 체크박스 갯수:",selChkCnt);
	    console.log("전체   체크박스 갯수:",chkBoxCnt);

	    if(chkBoxCnt == selChkCnt){
	        console.log("모두 체크되었넹!")
	        ckAll.checked= !0;
	    }else {
	        console.log("모두에는 아직 모자라")
	        ckAll.checked= !1;
	    }
	    
	}

	function dragCheckBox(selector) {
	    let isDragging = false;
	    // 주어진 선택자에 해당하는 요소를 모두 반복하여 처리
	    document.querySelectorAll(selector).forEach((element) => {
	        // 해당 요소에서 체크박스를 찾음
	        const target = element.querySelector("input[type='checkbox']");
	        if (!target) return false;
	        chkBoxCnt++;
	        console.log("체크박스 갯수 체킁:",chkBoxCnt);

	        // 체크박스 클릭 시 기본 이벤트를 중지
	        target.addEventListener("click", (e) => {
	            console.log("클릭은 무시 왱 마우스다운으로 처링");
	            e.preventDefault();   // 이벤트 막깅
	        });

	        // 마우스를 누르고 드래그할 때
	        element.addEventListener("mousedown", (e) => {
	            console.log("마우스가 눌려있넹")
	            e.preventDefault();      
	            isDragging = true;
	            // 체크박스 상태를 토글
	            target.checked = !target.checked;
	            chkAll();  // 모두 체크 되었는지 갯수 체킁
	        });

	        // 드래그하면서 요소에 진입할 때
	        element.addEventListener("mouseenter", (e) => {
	            console.log("입장");
	            // 드래그 중이 아니면 무시
	            if (!isDragging) return false;
	            // 체크박스 상태를 토글
	            target.checked = !target.checked;
	            chkAll(); // 모두 체크 되었는지 갯수 체킁
	        });

	        // 마우스 버튼을 놓을 때
	        document.addEventListener("mouseup", (e) => {
	            console.log("드래그 해지");
	            // 드래그 중지
	            isDragging = false;
	        });
	    });
	}
	dragCheckBox(".checkbox-td")
	});

$(document).ready(function(){
	//삭제 버튼 클릭
	$("#delBtn").click(function(){
		var delCheckList = [];	//체크한 목록
		var checkboxList = document.getElementsByName('checkbox')
		$('input[name="checkbox"]:checked').each(function(){
			delCheckList.push($(this).data("emailNo"));
		});
		
		if(delCheckList.length === 0){
			alert(_msg.email.selectNull);
			return;
		}
		
		$.ajax({
			type: "POST",
			url: "/mail/delete/temporarybox", // 삭제 요청을 처리할 서버 측 URL
            data: JSON.stringify({ "checkboxList": delCheckList }), // 삭제할 메일 목록을 서버로 보냄
			contentType: "application/json;charset=utf-8",
            beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
            success: function(response) {
                // 삭제가 성공적으로 이루어졌을 때의 처리
                // 예를 들어, 화면에서 삭제된 메일을 갱신하는 등의 작업을 수행할 수 있음
                console.log("메일 삭제 완료:", response);
                // 화면 갱신 등의 추가 작업
                if(response > 0){
                    Swal.fire({
                        title: _msg.email.deleteBox,
                        text: "",
                        icon: "success"
                      }).then((result) => {
                           if (result.isConfirmed) {
                            location.reload();                          
                           }
                       });

                }
            },
            error: function(xhr, status, error) {
                // 삭제 요청이 실패했을 때의 처리
                console.error("메일 삭제 실패:", error);
                console.error("메일 삭제 실패:", xhr.status);
                
                
		}
	})
});
});
</script>

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
	<div class="wf-mail-right" data-aos="fade-right" data-aos-duration="700" data-aos-delay="400">
		<!-- 받은이메일 리스트(메일 첫 화면) -->
		<div class="wf-content-area getmail">
			<div class="wf-flex-box between mg-b-10">
				<h1 class="page-tit2">
					<i class="xi-mail"></i> 임시보관함 <span class="mail-badge">${tempCount}</span>
				</h1>
				<div class="side-util">
					<button type="button" class="btn3" id="delBtn">삭제</button>
				</div>
			</div>
			<table class="wf-table">
				<colgroup>
					<col style="width: 2%;">
					<col style="width: 2%;">
					<col style="width: 10%;">
					<col style="width: 10%;">
					<col style="width: auto;">
					<col style="width: 20%;">
				</colgroup>
				<thead>
					<tr>
						<th><span class="checkbox-radio-custom"> <input
								type="checkbox" name="checkboxAll" id="chk1" >
								<label class="checkbox-label" for="chk1"></label>
						</span></th>
						<th></th>
						<th></th>
						<th>보낸 사람</th>
						<th>제목</th>
						<th>받은 일시</th>
					</tr>
				</thead>
				<tbody id="emailTbody">
					<c:forEach var="emailVO" items="${emaildata.content}" varStatus="stat">
						<tr>
							<td class="checkbox-td">
								<span class="checkbox-radio-custom">
								<input type="checkbox" name="checkbox" id="chk${stat.count+1}" data-email-no="${emailVO.emailNo}">
								<label class="checkbox-label" for="chk${stat.count+1}"></label>
								</span>
							</td>
							<td>
								<div class="wf-mail-button-wrap">
								<button type="button">
								<i class="xi-mail-read"></i>
								</button>
								</div>
							</td>
							<td> 
								<div class="wf-mail-button-wrap">
								<button type="button">
								<i class="xi-attachment"></i>
								</button>
								</div>
							</td>
							<td onclick="tempCreate(${emailVO.emailNo})">
								<p>${emailVO.senderName}</p>
							</td>
							<td onclick="tempCreate(${emailVO.emailNo})">
								<p>${emailVO.emailSj}</p>
							</td>
							<td onclick="tempCreate(${emailVO.emailNo})">
								<p>${emailVO.sendDate}</p>
							</td>
						</tr>
					</c:forEach>
				</tbody>

			</table>


		</div>

		<!-- 페이지네이션 시작 -->
		${emaildata.getPagingArea() }
		<!-- 페이지네이션 끝 -->

		<!-- 검색영역 시작 -->
		<div class="wf-search-area">
			<div class="select-box">
				<select name="" id="">
					<option value="">제목</option>
					<option value="">제목+내용</option>
					<option value="">작성자</option>
				</select>
			</div>
			<input type="text" placeholder="검색할 내용을 입력해주세요">
			<button type="button" class="btn4">
				<i class="xi-search"></i>
			</button>
		</div>
		<!-- 검색영역 끝 -->

		<!-- 메일쓰기 폼 시작(안보이게)  -->


	</div>
	<!-- 메일 오른쪽 파트 끝 -->

</div>
<!-- =============== 컨텐츠 영역 끝 =============== -->

<!-- =============== body 끝 =============== -->