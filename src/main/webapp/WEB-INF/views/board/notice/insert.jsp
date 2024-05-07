<%@page import="java.time.LocalDate" %>
	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

		<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
			<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
			<script>

				$(() => {
						
					

					 $('.ck-blurred').keydown(function(){
					        $("#noticeBrdCn").val(window.editor.getData());
					    });
					    
					    $('.ck-blurred').on("focusout", function(){
					        $("#noticeBrdCn").val(window.editor.getData());
					    });
					 
					



				});


				//자동 등록
				function autoFill() {

					let textAreaInput = "안녕하세요 공지사항 자동입력 테스트입니다.";
					let noticeBrdSeCd = "1";
					let fixingDate = "2024-05-12";
					let textAreaInputCn="이 편지는 영국에서 최초로 시작되어 일년에 한바퀴를 돌면서 받는 사람에게 행운을 주었고 지금은 당신에게로 옮겨진 이 편지는 4일 안에 당신 곁을 떠나야 합니다.<br> 이 편지를 포함해서 7통을 행운이 필요한 사람에게 보내 주셔야 합니다.<br> 복사를 해도 좋습니다. 혹 미신이라 하실지 모르지만 사실입니다.<br>"
						+ "영국에서 HGXWCH이라는 사람은 1930년에 이 편지를 받았습니다.<br> 그는 비서에게 복사해서 보내라고 했습니다.<br> 며칠 뒤에 복권이 당첨되어 20억을 받았습니다.<br> 어떤 이는 이 편지를 받았으나 96시간 이내 자신의 손에서 떠나야 한다는 사실을 잊었습니다.<br> 그는 곧 사직되었습니다.<br> 나중에야 이 사실을 알고 7통의 편지를 보냈는데 다시 좋은 직장을 얻었습니다.<br> 미국의 케네디 대통령은 이 편지를 받았지만 그냥 버렸습니다.<br> 결국 9일 후 그는 암살당했습니다. 기억해 주세요.<br> 이 편지를 보내면 7년의 행운이 있을 것이고 그렇지 않으면 3년의 불행이 있을 것입니다.<br> 그리고 이 편지를 버리거나 낙서를 해서는 절대로 안됩니다.<br> 7통입니다. <br>이 편지를 받은 사람은 행운이 깃들것입니다.<br> 힘들겠지만 좋은게 좋다고 생각하세요.<br> 7년의 행운을 빌면서...";

					$('#noticeBrdSeCd').val(noticeBrdSeCd);
					$('#fixingEndDate').val(fixingDate);
					$('#noticeBrdSj').val(textAreaInput);

					editor.setData(textAreaInputCn);
					document.getElementById("noticeBrdCn").value = textAreaInputCn;
				};
			</script>
			<!DOCTYPE html>
			<html>

			<body>
				<div class="wf-main-container">
					<!-- =============== body 시작 =============== -->
					<!-- =============== 상단타이틀영역 시작 =============== -->
					<form action="/notice/creatNotice?${_csrf.parameterName}=${_csrf.token}" method="post"
						enctype="multipart/form-data">
						<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
							<h1 class="page-tit">공지 게시판 등록</h1>
							<div class="wf-util">
								<button type="button" class="btn1" onclick="autoFill()">자동 완성</button>
								<button type="button" class="btn1" onclick="location.href='/notice/list'">취소</button>
								<button type="submit" id="submitBtn" class="btn2">등록</button>
							</div>
						</div>
						<!-- =============== 상단타이틀영역 끝 =============== -->
						<!-- =============== 컨텐츠 영역 시작 =============== -->
						<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">

							<div class="wf-content-area">

								<!-- 등록폼 시작 -->
								<ul class="wf-insert-form3">
									<li>
										<input type="hidden" id="empNo" name="empNo" value="<%=session.getAttribute("empNo")%>">
										<div class="wf-insert-tit">
											<div class="wf-select-group">
												<select name="noticeBrdSeCd" id="noticeBrdSeCd" required>
													<option value="1">일반</option>
													<option value="2">인사</option>
												</select>
											</div>
											<input type="text" id="noticeBrdSj" name="noticeBrdSj"
												placeholder="제목을 입력해주세요">
											<input type="date" name="fixingEndDate" id="fixingEndDate"
												min="<%= LocalDate.now() %>">
										</div>
									</li>
									<li>
										<div id="ckExam"></div> <textarea name="noticeBrdCn"
										id="noticeBrdCn" placeholder="내용을 입력해주세요." style="display:none;"
										 ></textarea>
									</li>
									<li><input type="file" name="uploadfile" id="uploadfile" multiple></li>
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
				.create( document.querySelector('#ckExam'),{ckfinder:{uploadUrl:'/upload/uploads?${_csrf.parameterName}=${_csrf.token}'}})
				 .then(editor=>{window.editor=editor;})
				 .catch(err=>{console.error(err.stack);});
		</script>
		<script type="text/javascript">
						window.editor.setData("내용을 입력해주세요");
				</script>