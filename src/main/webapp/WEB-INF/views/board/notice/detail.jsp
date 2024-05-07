<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

		<script>
			$(() => {
				var sessionEmpNo = <%=session.getAttribute("empNo") %>;
                console.log("sessionEmpNo--> ", sessionEmpNo);
                let rspnsblCd= "<%=session.getAttribute("rspnsblCtgryNm") %>";
                console.log("rspnsblCd--> ", rspnsblCd);
                
                
                
                //로그인한 session
                //var sessionEmpNo = <%=session.getAttribute("empNo") != null ? session.getAttribute("empNo") : "defaultValue"%>;
                var sessionEmpNo = <%=session.getAttribute("empNo")%>;
                console.log("sessionEmpNo--> ", sessionEmpNo);
                var sessionEmpNm = '<%=session.getAttribute("empNm")%>';
                console.log("sessionEmpNm -> ", sessionEmpNm);
                // 본인 게시글 수정 삭제 버튼
                if (rspnsblCd == '팀원') {
                    console.log("참");
                    document.getElementById("noticeUpdate").style.display = "none";
                    document.getElementById("noticeDelete").style.display = "none";
                } else {
                    console.log("거짓");
                }

    
				// 댓글 등록
				$("#insertReply").on("click", function () {
					console.log("눌렀음")
					console.log("이건 체크", event.target);
					let sj = event.target;
					let sj2 = $(sj).closest("div");

					let reSj = sj2.find("input").val();
					let empNo = sessionEmpNo;
					console.log("sj -> ", sj);
					console.log("sj2-> ", sj2);
					console.log("reSj -> ", reSj);
					console.log("empNo ->", empNo)

					let noticeBrdNo = "${noticeDetail.noticeBrdNo}";
					console.log("noticeBrdNo ->", noticeBrdNo);

					let textArea = $(sj).closest(".comment-area");
					console.log("textArea", textArea);
					let lastElement = textArea[textArea.length - 1];
					console.log("lastElement -> ", lastElement);




					let data = {
						reSj: reSj,
						empNo: empNo,
						noticeBrdNo: noticeBrdNo,
					};
					console.log("data", data)


					$.ajax({
						url: "/notice/detail/reply/insert",
						data: JSON.stringify(data),
						contentType: "application/json;charset=utf-8",
						type: "post",
						dataType: "json",
						beforeSend: function (xhr) {
							xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
						},
						success: function (res) {
							let str = "";
							console.log("성공");
							console.log(res);
							
							// 등록 후
							str += "<ul class='replySet' data-notice-brd-re=" + res.noticeBrdReNo + " >";
							str += "<li data-notice-brd-re=" + res.noticeBrdReNo + ">";
							str += "<div class='user-wrap'>";
							str += "<span class='user-thumb'>";
							str += "<img src='/resources/img/icon/" + res.proflImageUrl + "' alt='예시이미지'>";
							str += "</span>";
							str += "<div class='user-info'>";
							str += "<div>";
							str += "<span class='user-name'>" + res.empNm + "</span>";
							str += "<span class='user-position'>" + res.cmmnCdNm + "</span>";
							str += "</div>";
							str += "<div>";
							str += "<span class='user-team'>" + res.deptNm + "</span>";
							str += "<span class='user-date'>" + res.writngDate + "</span>";
							str += "</div>";
							str += "</div>";
							console.log("empNo"+res.empNo);
							console.log("sessionEmpNo"+sessionEmpNo);
							if(res.empNo=sessionEmpNo){
							str += "<div class='user-btn'>";
							str += "<button type='button' class='add-btn' ";    
							str += ">";
							str += "<i class='xi-pen'>";
							str += "</i>";
							str += "</button>";
							str += "<button type='button' class='del-btn' ";
							str += ">";
							str += "<i class='xi-trash'>";
							str += "</i>";
							str += "</button>";
							str += "</div>";
							}
							str += "</div>";
							str += "<div class='txt'>" + res.reSj + "</div>";
							str += "<div class='input-wrap' style='display:none;'>";
							str += "<input type='text' value='" + res.reSj + "' >";
							str += "<button class='btn4 updatebtn'>수정</button>";
							str += "</div>";
							str += "<button type='button' class='reply-btn'>답글</button>";
							str += "</li>";
							//대댓글 버튼 눌렀을 때 입력창 시작
							str += "<div class='input-wrap ReReplyInsert' style='display: none;'>";
							str += "<span class='user-thumb'>";
							str += "<img src='/resources/img/icon/"+res.proflImageUrl+"' alt='예시이미지'>";
							str += "</span>";
							str += "<input type='text' placeholder='대댓글을 입력하세요'>";
							str += "<button id='insertReReply' class='btn4'>등록</button>";
							str += "</div>";
							str += "<br>";
							// 대댓글 버튼 눌렀을 때 입력창 끝
							str += "</ul>";
							str += "<br>";


							$(str).insertBefore(sj2);
							$(sj2).find("input").val("");
							
							Toast.fire({
								position: "top-end",
								icon: "success",
								title: "댓글이 등록되었습니다",
								showConfirmButton: false,
								timer: 1500
							});

						},
					});
				});





				// 대댓글 등록 핸들러
				$(document).on("click", ".reply-btn", function () {
					console.log("체크");
					let check = event.target;
					console.log("check ---> ", check);
					let parentClass = check.closest(".replySet");
					console.log("parentClass--> ", parentClass);

					let inputArea = $(parentClass).find(".ReReplyInsert");
					console.log("inputArea --> ", inputArea);

					inputArea.toggle();

				});

				// 대댓글 등록 아작스
				$(document).on("click", "#insertReReply", function () {
					console.log("체크입니다");

					// 텍스트 내용
					let ev = $(this);
					console.log("ev ---> ", ev);
					let parentClass = ev.closest(".ReReplyInsert");
					console.log("parentClass --> ", parentClass);
					let inputArea = parentClass.find("input");
					console.log("inputArea --> ", inputArea);
					let reSj = inputArea.val();
					console.log("reSj-----> ", reSj);

					// 부모 noticeBrdNo 
					let head = ev.closest(".replySet");
					console.log("head ---> ", head);
					// 부모댓글
					let noticeBrdReNo = head.data("noticeBrdRe");
					console.log("noticeBrdReNo ---> ", noticeBrdReNo);

					//작성자
					let empNo = sessionEmpNo;
					console.log("empNo --> ", empNo);

					// 게시글 번호
					let noticeBrdNo = "${noticeDetail.noticeBrdNo}";
					console.log("noticeBrdNo --> ", noticeBrdNo);

					let data = {
						reSj: reSj,
						noticeBrdReNo: noticeBrdReNo,
						empNo: empNo,
						noticeBrdNo: noticeBrdNo,
					}
					console.log("data ---> ", data);

					//새로운 페이지 append 할 곳 찾기
					let childrenWithClass = head.find(".reply");
					console.log("childrenWithClass ---> ", childrenWithClass);
					let lastChild = childrenWithClass.last();
					console.log("lastChild ----> ", lastChild);

					// 대댓이 없는 경우
					let check = event.target;
					console.log("check ---> ", check);
					let parentClass2 = $(check).closest(".replySet");
					console.log("parentClass--> ", parentClass2);
					let inputArea2 = parentClass2.find("li");
					console.log("inputArea2 --> ", inputArea2);

					$.ajax({
						url: "/notice/detail/reply/re/insert",
						data: JSON.stringify(data),
						contentType: "application/json;charset=utf-8",
						type: "post",
						dataType: "json",
						beforeSend: function (xhr) {
							xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
						},
						success: function (res) {
							console.log(res);
							let str = "";
							str += "<li class='reply' data-notice-brd-re=" + res.noticeBrdReNo + ">";
							str += "<div class='user-wrap'>";
							str += "<span class='user-thumb'>";
							str += "<img src='/resources/img/icon/"+res.proflImageUrl+"' alt='예시이미지'>";
							str += "</span>";
							str += "<div class='user-info'>";
							str += "<div>";
							str += "<span class='user-name'>" + res.empNm + "</span>";
							str += "<span class='user-position'>" + res.cmmnCdNm + "</span>";
							str += "</div>";
							str += "<div>";
							str += "<span class='user-team'>" + res.deptNm + "</span>";
							str += "<span class='user-date'>" + res.writngDate + "</span>";
							str += "</div>";
							str += "</div>";
							console.log("empNo"+res.empNo);
							console.log("sessionEmpNo"+sessionEmpNo);
							if(res.empNo=sessionEmpNo){
							str += "<div class='user-btn'>";
							str += "<button type='button' class='add-btn'>";
							str += "<i class='xi-pen'>";
							str += "</i>";
							str += "</button>";
							str += "<button type='button' class='del-re-btn'>";
							str += "<i class='xi-trash'>";
							str += "</i>";
							str += "</button>";
							str += "</div>";
							}
							str += "</div>";
							str += "<div class='txt'>" + res.reSj + "</div>";
							str += "<div class='input-wrap' style='display: none;'>";
							str += "<input type='text' value='" + res.reSj + "'>";
							str += "<button class='btn4 updatebtn'>수정</button>";
							str += "</div>";
							str += "</li>";
							str += "<br>";


							if (lastChild.length == 1) {
								//대댓이 있으면
								lastChild.after(str);
								inputArea.val("");
								Toast.fire({
									position: "top-end",
									icon: "success",
									title: "댓글이 등록되었습니다",
									showConfirmButton: false,
									timer: 1500
								});
							}

							//대댓이 없으면 만들어야됌
							else {
								console.log("대댓이 없음")
								inputArea2.after(str);
								inputArea.val("");
								Toast.fire({
									position: "top-end",
									icon: "success",
									title: "댓글이 등록되었습니다",
									showConfirmButton: false,
									timer: 1500
								});
							}

						},
					});




				});











				// 대,댓글 수정 핸들러
				$(document).on("click", ".add-btn", function () {
					console.log("체크");

					let aaaa = $(this).closest("li");
					console.log("aaaa -> ", aaaa);
					let noticeBrdReNo = aaaa.data("noticeBrdRe");
					console.log("noticeBrdReNo ---> ", noticeBrdReNo);

					let txtArea = $(this).closest("li").find(".txt");
					console.log("txtArea --> ", txtArea);

					let txtInput = $(this).closest("li").find(".input-wrap");
					console.log("txtInput --> ", txtInput);

					$(txtArea).toggle();
					txtInput.toggle();
				});


				// 수정 버튼 클릭 시 이벤트
				$(document).on("click", ".updatebtn", function () {

					let txtArea = $(this).closest("li").find(".txt");
					console.log("txtArea --> ", txtArea);

					let aaaa = $(this).closest("li");
					console.log("aaaa -> ", aaaa);
					let noticeBrdReNo = aaaa.data("noticeBrdRe");
					console.log("noticeBrdReNo ---> ", noticeBrdReNo);
					let txtInput = $(this).closest("li").find(".input-wrap");
					let reSj = txtInput.find('input').val();
					console.log("reSj --> ", reSj);

					let data = {
						noticeBrdReNo: noticeBrdReNo,
						reSj: reSj,
					}

					console.log("data ---> ", data);

					$.ajax({
						url: "/notice/detail/reply/update",
						data: JSON.stringify(data),
						contentType: "application/json;charset=utf-8",
						type: "post",
						dataType: "json",
						beforeSend: function (xhr) {
							xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
						},
						success: function (res) {
							console.log(res);
							Toast.fire({
								position: "top-end",
								icon: "success",
								title: "댓글이 수정되었습니다",
								showConfirmButton: false,
								timer: 1500
							});
							txtArea.html(reSj);
							txtInput.css("display", "none");
							txtArea.css("display", "flex");
						},
					});


				});

				// 댓글 삭제
				$(document).on("click", ".del-btn", function () {
					console.log("삭제 버튼 누름");

					let th = $(this);
					// 삭제할 해당 번호 찾기
					let parents = th.closest("li");
					console.log("parents ---> ", parents);
					let noticeBrdReNo = parents.data("noticeBrdRe");
					console.log("noticeBrdReNo --->", noticeBrdReNo);

					// 삭제할 Area찾기
					let parentArea = th.closest("ul");
					console.log("parentArea ", parentArea);

					let data = {
						noticeBrdReNo: noticeBrdReNo,
					};

					$.ajax({
						url: "/notice/detail/reply/delete",
						data: JSON.stringify(data),
						contentType: "application/json;charset=utf-8",
						type: "post",
						dataType: "json",
						beforeSend: function (xhr) {
							xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
						},
						success: function (res) {
							console.log(res);
							console.log("삭제 되었습니다");
							Toast.fire({
								position: "top-end",
								icon: "success",
								title: "댓글이 삭제되었습니다",
								showConfirmButton: false,
								timer: 1500
							});
							parentArea.remove();
						},
					});
				});

				//대댓글 삭제 
				$(document).on("click", ".del-re-btn", function () {
					console.log("대댓글 삭제 버튼 누름");
					let th = $(this);
					console.log("th ---> ", th);
					let ev = th.closest(".reply")[0];
					console.log("ev ----> ", ev);

					let noticeBrdReNo = $(ev).data("noticeBrdRe");
					console.log("noticeBrdReNo --->", noticeBrdReNo);

					let data = {
						noticeBrdReNo: noticeBrdReNo,
					};

					$.ajax({
						url: "/notice/detail/reply/re/delete",
						data: JSON.stringify(data),
						contentType: "application/json;charset=utf-8",
						type: "post",
						dataType: "json",
						beforeSend: function (xhr) {
							xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
						},
						success: function (res) {
							console.log(res);
							Toast.fire({
								position: "top-end",
								icon: "success",
								title: "댓글이 삭제되었습니다",
								showConfirmButton: false,
								timer: 1500
							});
							ev.remove();
						},
					});



				});



				//게시글 삭제
				$("#noticeDelete").on("click", function () {

					console.log("게시글 삭제 버튼 누름");

					let noticeBrdNo = "${noticeDetail.noticeBrdNo}";
					Swal.fire({
						title: "게시글을 삭제 하시겠습니까?",
						denyButtonText: "아니오",
						confirmButtonText: "삭제",  // 필요시 수정 거능
						showCancelButton: true,
					}).then((result) => {
						if (result.isConfirmed) {
							let noticeBrdNo = "${noticeDetail.noticeBrdNo}";
							let data = {
								noticeBrdNo: noticeBrdNo,
							};
							$.ajax({
								url: "/notice/detail/delete",
								data: JSON.stringify(data),
								contentType: "application/json;charset=utf-8",
								type: "post",
								beforeSend: function (xhr) {
									xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
								},
								success: function (res) {
									console.log(res);
									Toast.fire({
										title: "삭제 되었습니다!",
										icon: "success",
									});

									setTimeout(function () {
										location.href = "/notice/list/";
									}, 1000);
								},
							});
						}
					});
				});


			       $(document).on("click",".file-name",function(){
	                	let param= $(this).data("url").replace("/", "");
	                	
	                	downloadFile(param);
	                });
				
				



				});
			
			   
        	function downloadFile(param) {
        	
        	    const s3Url = _storage + param;
        	    // let url = idx.split("/img/")[1]
        	    // 버튼 클릭 시 파일 다운로드
        	    const a = document.createElement('a');
        	    a.href = s3Url;
        	    a.download = param; // 다운로드될 파일 이름
        	    
        	    document.body.appendChild(a);
        	    a.click();
        	    document.body.removeChild(a);
        	}
        	
			
		</script>
	


		<!-- =============== body 시작 =============== -->
		<!-- =============== 상단타이틀영역 시작 =============== -->
		<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
			<h1 class="page-tit">공지게시판</h1>
			<div class="wf-util">
				<form action="/notice/update?${_csrf.parameterName}=${_csrf.token}" method="post">
					<input type="hidden" name="noticeBrdNo" value="${noticeDetail.noticeBrdNo}">
					<button type="submit" class="btn4" id="noticeUpdate">수정</button>
				</form>
				<button type="button" class="btn3" id="noticeDelete" style='margin-left:10px;'>삭제</button>
				<button type="button" class="btn5" onclick="location.href='/notice/list/'">목록</button>
			</div>
		</div>

		<!-- =============== 상단타이틀영역 끝 =============== -->
		<!-- =============== 컨텐츠 영역 시작 =============== -->
		<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
			<div class="wf-flex-box between">
				<div class="wf-content-area" style="flex: 1;">
					<!-- wf-insert-form2에 "detail"추가해주세요 -->
					<ul class="wf-insert-form3 detail">
						<li>
							<div class="detail-tit">
								<p class="tit">${noticeDetail.noticeBrdSj }</p>
							</div>
						</li>
						<li>

							<div class="form3-head-wrap">
								<div class="user-info">
									<span class="user-thumb"> <img src="/resources/img/icon/${noticeDetail.proflImageUrl }" alt="예시이미지" />
									</span>
									<div>
										<span class="user-name">${noticeDetail.empNm }</span>
									</div>
								</div>
								<p class="date">${noticeDetail.writngDate }</p>
								<p>조회수 ${noticeDetail.rdcnt }</p>
							</div>
						</li>
						<li>
							<p class="detail-content">${noticeDetail.noticeBrdCn }</p>
						</li>


					</ul>




					<!-- 댓글, 코멘트 영역 시작 -->
					<div class="comment-area">
						<c:forEach var="noticeReplyVO" items="${replyList}" varStatus="stat">
							<c:if test="${noticeReplyVO.lvl == 1}">
								<c:set var="parentNoticeBrdReNo" value="${noticeReplyVO.noticeBrdReNo}" />
								<ul class="replySet" data-notice-brd-re="${noticeReplyVO.noticeBrdReNo}">
									<li data-notice-brd-re="${noticeReplyVO.noticeBrdReNo}">
										<div class="user-wrap">
											<span class="user-thumb"> <img src="/resources/img/icon/${noticeReplyVO.proflImageUrl }" alt="예시이미지">
											</span>
											<div class="user-info">
												<div>
													<span class="user-name">${noticeReplyVO.empNm}</span> <span
														class="user-position">${noticeReplyVO.cmmnCdNm }</span>
												</div>
												<div>
													<span class="user-team">${noticeReplyVO.deptNm }</span> <span
														class="user-date">${noticeReplyVO.writngDate}</span>
												</div>
											</div>
											<c:if test="${noticeReplyVO.empNo ==sessionEmpNo }">
											<div class="user-btn">
												<button type="button" class="add-btn">
													<i class="xi-pen"></i>
												</button>
												<button type="button" class="del-btn">
													<i class="xi-trash"></i>
												</button>
											</div>
											</c:if>
										</div>
										<div class="txt">${noticeReplyVO.reSj }</div>
										<div class="input-wrap" style="display: none;"><input type="text"
												value="${noticeReplyVO.reSj}">
											<button class="btn4 updatebtn" >수정</button>
										</div>
										<button type="button" class="reply-btn">답글</button>
									</li>
									<!-- 대댓글 시작부분 -->
									<c:forEach var="childNoticeReplyVO" items="${replyList}" varStatus="stat2">
										<c:if
											test="${childNoticeReplyVO.lvl == 2 && childNoticeReplyVO.upperRe == parentNoticeBrdReNo }">
											<li class="reply" data-notice-brd-re="${childNoticeReplyVO.noticeBrdReNo}">
												<div class="user-wrap">
													<span class="user-thumb"> <img src="/resources/img/icon/${childNoticeReplyVO.proflImageUrl }"
															alt="예시이미지">
													</span>
													<div class="user-info">
														<div>
															<span class="user-name">${childNoticeReplyVO.empNm}</span>
															<span class="user-position">${childNoticeReplyVO.cmmnCdNm
																}</span>
														</div>
														<div>
															<span class="user-team">${childNoticeReplyVO.deptNm
																}</span> <span
																class="user-date">${childNoticeReplyVO.writngDate}</span>
														</div>
													</div>
													<c:if test="${childNoticeReplyVO.empNo ==sessionEmpNo }">
													<div class="user-btn">
														<button type="button" class="add-btn">
															<i class="xi-pen"></i>
														</button>
														<button type="button" class="del-re-btn">
															<i class="xi-trash"></i>
														</button>
													</div>
													</c:if>
												</div>
												<div class="txt">${childNoticeReplyVO.reSj }</div>
												<div class="input-wrap" style="display: none;"><input type="text"
														value="${childNoticeReplyVO.reSj }">
													<button class="btn4 updatebtn">수정</button>
												</div>
											</li>
										</c:if>
									</c:forEach>
									<!-- 대댓글 끝 -->
									<br> 
									<div class="input-wrap ReReplyInsert" style="display: none;">
										<span class="user-thumb"> <img src="/resources/img/icon/${proflImageUrl }" alt="예시이미지">
										</span> <input type="text" placeholder="대댓글을 입력하세요">
										<button id="insertReReply" class="btn4">등록</button>
										<br> 
									</div>
									<br>
								</ul>
							</c:if>
						</c:forEach>
						<br>
						<div class="input-wrap">
							<span class="user-thumb"> <img src="/resources/img/icon/${proflImageUrl }" alt="예시이미지">
							</span> <input type="text" placeholder="댓글을 입력하세요">
							<button id="insertReply" class="btn4">등록</button>
						</div>
					</div>
					<br>
					<!-- 댓글, 코멘트 영역 끝 -->








				</div>
				<div class="wf-content-area" style="width: 310px;">
					<h1 class="heading2">첨부파일</h1>
					<div class="custom-box">
						<ul class="file-lst bul-lst01">
							<c:forEach var="attachlistVO" items="${attachdata}" varStatus="stat">
								<li><p class="file-name" data-url="${attachlistVO.atchmnflUrl}">${attachlistVO.atchmnflOriginNm}</p>
								</li>
							</c:forEach>
						</ul>
					</div>
				</div>
			</div>
		</div>











		<!-- =============== 컨텐츠 영역 끝 =============== -->
		<!-- =============== body 끝 =============== -->