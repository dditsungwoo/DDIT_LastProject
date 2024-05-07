<%@page import="java.time.LocalDate" %>
	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
		<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
			<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
				<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

				<script>

					$(() => {
						
						
						window.onload = function() {
					        // 기존 데이터를 가져와서 변수에 저장
					        var existingData = "${noticeVO.noticeBrdCn}";

					        // 가져온 데이터를 <textarea> 요소에 설정
					        document.getElementById("noticeBrdCn").value = existingData;
					    };
						
						
						
						
						if("${noticeVO.fixingEndDate}" != null){
							console.log("체크")
							let time = "${noticeVO.fixingEndDate}";
							console.log("time ---> ",time);
							
							let year = time.substring(0,4);
							console.log("year --> ",year);
							let month = time.substring(4,6);
							console.log("month---->",month);
							let day = time.substring(6,8);
							console.log("day---->",day);

							var fixingDate = year+"-"+month+"-"+day;
							console.log("fixingDate --->" ,fixingDate);

							document.getElementById("fixingEndDate").value = fixingDate;
							
							
							
						}
						
						
						
						
						
						
						
						
						
						$('.ck-blurred').keydown(function () {
							console.log("str : " + window.editor.getData());
							$("#noticeBrdCn").val(window.editor.getData());
						});

						$('.ck-blurred').on("focusout", function () {
							$("#noticeBrdCn").val(window.editor.getData());
						});




						$(document).on("click",".del-btn",function(){
							console.log("체크")
							let th = this;
							console.log("th ----> ",th);
							let Area = this.closest(".del-file");
							console.log("area ---> ",Area);
							// 삭제할 파일 번호
							let atchmnflSeq = Area.dataset.setFileNo;
							console.log("atchmnflSeq ---> ",atchmnflSeq);
							// 삭제 후 사라질 지역
							let deleteArea = th.closest(".origin-file");
							console.log("deleteArea ---> ",deleteArea);
							
							let data ={
								atchmnflSeq:atchmnflSeq,
							};
							$.ajax({
								url: "/notice/deletefile",
								data: JSON.stringify(data),
								contentType: "application/json;charset=utf-8",
								type: "post",
								dataType: "json",
								beforeSend: function (xhr) {
								xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
								},
								success: function (res) {
									console.log(res);
									deleteArea.remove();
								},
							});
						});


						

						




					});




				</script>




				<!DOCTYPE html>
				<html>

				<body>
					<div class="wf-main-container">
						<!-- =============== body 시작 =============== -->
						<!-- =============== 상단타이틀영역 시작 =============== -->
						<!-- 등록폼 시작 -->
						<form action="/notice/updateNotice?${_csrf.parameterName}=${_csrf.token}" method="post"
							enctype="multipart/form-data">
							<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
								<h1 class="page-tit">공지 게시판 수정</h1>
								<div class="wf-util">
									<button type="button" class="btn1"
										onclick="location.href='http://localhost/notice/list'">취소</button>
									<button type="submit" id="submitBtn" class="btn2">수정</button>
									<input type="hidden" id="noticeBrdNo" name="noticeBrdNo" value="${noticeVO.noticeBrdNo}">
								</div>
							</div>
							<!-- =============== 상단타이틀영역 끝 =============== -->
							<!-- =============== 컨텐츠 영역 시작 =============== -->
							<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">

								<div class="wf-content-area">

									
									<ul class="wf-insert-form3">
										<li><input type="hidden" id="empNo" name="empNo" value="${noticeVO.empNo}">
											<div class="wf-insert-tit">
												<div class="wf-select-group">
													<select name="noticeBrdSeCd" id="noticeBrdSeCd" required>
														<option value="1" <c:if test="${noticeVO.noticeBrdSeCd == 1}">selected</c:if> >일반</option>
														<option value="2" <c:if test="${noticeVO.noticeBrdSeCd == 2}">selected</c:if>>인사</option>
													</select>
												</div>
												<input type="text" name="noticeBrdSj" placeholder="제목을 입력해주세요" value="${noticeVO.noticeBrdSj}">
												<input type="date" name="fixingEndDate" id="fixingEndDate"  value=""
													min="<%=LocalDate.now()%>">
											</div>
										</li>
										<li>
											<div id="ckExam"></div> <textarea name="noticeBrdCn" id="noticeBrdCn"
												placeholder="내용을 입력해주세요." style="display: none;"></textarea>
										</li>
										<li><input type="file" name="uploadfile" id="uploadfile" multiple></li>
										<c:if test="${not empty fileVO}">
											<c:forEach var="file" items="${fileVO}" varStatus="stat">
												<div class="origin-file">
													<div class="del-file" data-set-file-no="${file.atchmnflSeq}">
														${file.atchmnflOriginNm}&nbsp;&nbsp;<button type="button"
															class="del-btn">
															<i class="xi-close-square"></i>
														</button>
														&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
													</div>
												</div>
											</c:forEach>
										</c:if>
									</ul>
								</div>
							</div>
						</form>
						<!-- 등록폼 끝 -->
					</div>
					<!-- =============== 컨텐츠 영역 끝 =============== -->
					<!-- =============== body 끝 =============== -->
				</body>

				</html>
				<script type="text/javascript">
					ClassicEditor
						.create(document.querySelector('#ckExam'), { ckfinder: { uploadUrl: '/upload/uploads?${_csrf.parameterName}=${_csrf.token}' } })
						.then(editor => { window.editor = editor; })
						.catch(err => { console.error(err.stack); });
				</script>
				<script type="text/javascript">
					window.editor.setData("${noticeVO.noticeBrdCn}");
				</script>