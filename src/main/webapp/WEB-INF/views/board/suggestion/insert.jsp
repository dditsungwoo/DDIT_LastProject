<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>









<script>
 $(()=>{
	 	
	 
	 
	 $('.ck-blurred').keydown(function(){
	        console.log("str : " + window.editor.getData());
	        $("#sugestBrdCn").val(window.editor.getData());
	    });
	    
	    $('.ck-blurred').on("focusout", function(){
	        $("#sugestBrdCn").val(window.editor.getData());
	    });
	 
	
	    
	 
		
	// 다행히 확인만 하넹!
	$("#suggestionSubmit").on("click",function(){
		//event.preventDefault();	멈추기
		console.log("체킁:", $("[name=uploadfile]")[0].files);
		let sugestBrdSj = $("#sugestBrdSj").val();
		let editorContent = $("#sugestBrdCn").val();
		let empNo = $("#empNo").val();
		
		
		console.log("제목 : ",sugestBrdSj);
		console.log("내용 : ",editorContent);
		console.log("글쓴이 :" ,empNo);
		
	});
 });


</script>




<!DOCTYPE html>
<html lang="en">
<body>
	<canvas id="gradient"></canvas>
	<div class="main-container">
		<div class="content-wrap">
			<main class="custom">
				<div class="wf-main-container"">
					<!-- =============== body 시작 =============== -->
					<!-- =============== 상단타이틀영역 시작 =============== -->
					<form
						action="/suggestion/creatSuggest?${_csrf.parameterName}=${_csrf.token}"
						method="post" enctype="multipart/form-data">
						<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
							<h1 class="page-tit">건의 게시판</h1>
							<div class="wf-util">
								<button type="button" class="btn1"
									onclick="location.href='/suggestion/list'">취소</button>
								<!-- 등록폼 시작 -->
								<button id="suggestionSubmit" type="submit" class="btn2">등록</button>
							</div>
						</div>
						<!-- =============== 상단타이틀영역 끝 =============== -->
						<!-- =============== 컨텐츠 영역 시작 =============== -->
						<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
							<div class="wf-content-area">
								<ul class="wf-insert-form3">
									<li><input type="hidden" id="empNo" name="empNo"
										value="<%=session.getAttribute("empNo")%>">
										<div class="wf-insert-tit">
											<input type="text" id="sugestBrdSj" name="sugestBrdSj"
												placeholder="제목을 입력해주세요">
										</div></li>
									<li>
										<div id="ckExam"></div> <textarea name="sugestBrdCn"
											id="sugestBrdCn" placeholder="내용을 입력해주세요."
											style="display: none;"></textarea>
									</li>
									<li><input type="file" name="uploadfile" id="atchmnflNo"
										multiple /></li>

								</ul>
							</div>

						</div>
					</form>
					<!-- 등록폼 끝 -->
					<!-- =============== 컨텐츠 영역 끝 =============== -->
					<!-- =============== body 끝 =============== -->
				</div>
			</main>
		</div>
	</div>
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