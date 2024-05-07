<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/tiles/taglib.jsp"%>
<script type="text/javascript" src="/resources/js/stripe-gradient.js"></script>
<script>
	function emailDetail(emailNo, prevMailNo, nextMailNo) {
		var mailbox = "${mailbox}";
		window.location.href = '/mail/detail/' + mailbox + '/' + emailNo
				+ '?prevMailNo=' + prevMailNo + '&nextMailNo=' + nextMailNo;
	}
	function emailCreate() {
		window.location.href = '/mail/create';
	}
	function emailSendbox() {
		window.location.href = '/mail/sendbox';
	}
	function emailAttachbox() {
		window.location.href = '/mail/attachbox';
	}
	function emailDeletebox() {
		window.location.href = '/mail/deletebox';
	}
	function emailUnreadbox() {
		window.location.href = '/mail/unreadbox';
	}
	function emailMain() {
		window.location.href = '/mail/main';
	}
	function emailTemporary() {
		window.location.href = '/mail/temporarybox';
	}
	
	
	$(function(){
		let text = $(".index").eq(0).text();
		let tag = document.querySelector("#atag2");
		tag.href = _storage + text;
		console.log(_storage + text)
		
	});

	</script>
<style>
.emailfile{
	min-height: auto;
}
.comment-area ul li:last-child {
    margin-bottom: 0px;
}
</style>
<!-- 왼쪽파트 없애고, <div class="wf-mail-right">태그 부분만 남겨놓기  -->
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


		<!-- =============== 상단타이틀영역 끝 =============== -->
		<!-- =============== 컨텐츠 영역 시작 =============== -->
		<div class="wf-content-wrap">

			<div class="wf-content-area">

				<!-- 상세보기 시작 -->
				<ul class="wf-insert-form3 detail">
						<div class="wf-tit-wrap">
							<h1 id="emailSj" class="tit">${emailVO.emailSj}</h1>
							<div class="side-util">
								<button type="button" class="btn2" id="resendBtn">답장</button>
							</div>
						</div>
					<li>
						<div class="form3-head-wrap">
							<div class="user-info">
								<span class="user-thumb"> <img src="/resources/img/icon/${empVO.proflImageUrl}"
									alt="예시이미지">
								</span>
								<div>
									<span id="senderName" class="user-name">${emailVO.senderName}</span> <span
										class="user-position">(${empVO.rspnsblCtgryNm}, ${empVO.deptNm})</span>
									<ul>
										<li>
											<p class="date">${emailVO.sendDate}</p>
										</li>
									</ul>
								</div>
							</div>

						</div>
					</li>

				</ul>
				<div class="comment-area">
					<div id="leftside-navigation" class="leftside-navigation">
						<ul class="depth1">
							<li class="sub-menu"><a href="javascript:void(0)"
								class="arrow"> <i class="xi-angle-down"></i> <span>첨부파일</span>
							</a> <c:choose>
									<c:when test="${empty attachdata}">
										<ul class="depth2" style="display: none;">
											<!-- 값이 없을 때의 처리 -->
										</ul>
									</c:when>
									<c:otherwise>
										<ul class="depth2">
											<li>
												<div class="custom-box">
													<ul class="file-lst bul-lst01 emailfile">
														<c:forEach var="attachlistVO" items="${attachdata}"
															varStatus="stat">
															<li><span class="index" style="display:none;">${attachlistVO.atchmnflUrl}</span><span class="file-name">${attachlistVO.atchmnflOriginNm}</span>
																<a id="atag${stat.count+1}" href="${attachlistVO.atchmnflUrl}"
																class="file-download"
																download="${attachlistVO.atchmnflOriginNm}"></a></li>
														</c:forEach>
													</ul>
												</div>
											</li>
										</ul>
									</c:otherwise>
								</c:choose></li>
						</ul>
					</div>

					<ul class="wf-insert-form3 detail">
						<li>
							<span id="emailCn" class="detail-content">${emailVO.emailCn}</span>
						</li>
					</ul>
				</div>
				<!-- 상세보기 끝	 -->
				<c:choose>
				<c:when test="${empty pEmailVO && empty nEmailVO}">
				</c:when>
				<c:otherwise>
				<div class="comment-area">
					<!-- 이전, 다음 메일 보기 시작 -->
					<table class="wf-table">
						<colgroup>
							<col style="width: 2%;">
							<col style="width: 2%;">
							<col style="width: 10%;">
							<col style="width: 10%;">
							<col style="width: auto;">
							<col style="width: 20%;">
						</colgroup>
						<!-- 이전 메일 시작 -->
						<c:choose>
						<c:when test="${empty pEmailVO}">
						</c:when>
						<c:otherwise>
						<tr>
							<td>
								<div class="wf-mail-button-wrap">
									<button type="button">
										<i class="xi-angle-up"></i>
									</button>
								</div>
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
							<td
								onclick="emailDetail('${pEmailVO.emailNo}', '${pEmailVO.prevMailNo}', '${pEmailVO.nextMailNo}')">
								<p>${pEmailVO.senderName}</p>
							</td>
							<td
								onclick="emailDetail('${pEmailVO.emailNo}', '${pEmailVO.prevMailNo}', '${pEmailVO.nextMailNo}')">
								<p>${pEmailVO.emailSj}</p>
							</td>
							<td
								onclick="emailDetail('${pEmailVO.emailNo}', '${pEmailVO.prevMailNo}', '${pEmailVO.nextMailNo}')">
								<p>${pEmailVO.sendDate}</p>
							</td>
						</tr>
						</c:otherwise>
					</c:choose>
						<!-- 이전 메일 끝 -->
						<!-- 다음 메일 시작 -->
						<c:choose>
						<c:when test="${empty nEmailVO}">
						</c:when>	
						<c:otherwise>					
						<tr>
							<td>
								<div class="wf-mail-button-wrap">
									<button type="button">
										<i class="xi-angle-down"></i>
									</button>
								</div>
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

							<td
								onclick="emailDetail('${nEmailVO.emailNo}', '${nEmailVO.prevMailNo}', '${nEmailVO.nextMailNo}')">
								<p>${nEmailVO.senderName}</p>
							</td>
							<td
								onclick="emailDetail('${nEmailVO.emailNo}', '${nEmailVO.prevMailNo}', '${nEmailVO.nextMailNo}')">
								<p>${nEmailVO.emailSj}</p>
							</td>
							<td
								onclick="emailDetail('${nEmailVO.emailNo}', '${nEmailVO.prevMailNo}', '${nEmailVO.nextMailNo}')">
								<p>${nEmailVO.sendDate}</p>
							</td>
						</tr>
						</c:otherwise>
						</c:choose>
						<!-- 다음 메일 끝 -->
					</table>
					<!-- 이전, 다음 메일 보기 끝 -->
				</div>
				
				</c:otherwise>
				</c:choose>
				

			</div>

		</div>
	</div>
	<!-- 메일 오른쪽 파트 끝 -->

</div>
<script>


  	$("#resendBtn").on("click", function(){
 		console.log("btn click");
 		
 		let reEmpNo= $("#senderName").text();
 		let reTitle= $("#emailSj").text();
 		let reCont= "${emailVO.emailCn}";
 		let reSend= "1";
 		console.log("reEmpNo:", reEmpNo);
 		console.log("reTitle:", reTitle);
 		console.log("reCont:", reCont);
 		
 		let data= {
 				"reSend": reSend,
 				"reEmpNo": reEmpNo,
 				"reTitle": reTitle,
 				"reCont": reCont
 				
 		};
 		
// 		var reEmpNo = ${emailVO.senderName};
// 		var reTitle = ${emailVO.emailSj};
// 		var reCont = ${emailVO.emailCn};
// 		var resend = "1";
// 		let data = {
// 			"resend": resend,
// 			"reEmpNo": reEmpNo,
// 			"reTitle": reTitle,
// 			"reCont": reCont
// 		};
		
		$.ajax({
			type: 'post',
			url: "/mail/recreate",
			data: JSON.stringify(data),
			dataType: "text",
	        contentType: "application/json;charset=utf-8",	    
	        beforeSend: function(xhr) {
	            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
	        },
			success: function(response){
				console.log("response"+response);
				window.location.href = "/mail/reSend";
			},
			error: function(xhr, status, error){
				console.error("fail : ", error);
			}
		});
	});
  	
  	

</script>



