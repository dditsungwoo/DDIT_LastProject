<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<script>

/*
function displaySelectedFileName() {
    var fileInput = document.getElementById('atchmnflNo');
    var fileInfoElement = document.getElementById('selectedFiles');
    
    
    //파일 계수 제한
    document.getElementById('atchmnflNo').addEventListener('change', function() {
    var input = this;
	var maxFiles = 5; // 최대 파일 수
	if (input.files && input.files.length > maxFiles) {
	        alert('최대 ' + maxFiles + '개의 파일을 선택할 수 있습니다.');
	        input.value = ''; // 선택한 파일 제거
	    }
	});
    
    
    
    // 파일 선택(input) 요소에서 선택된 파일 가져오기
    var files = fileInput.files;
	
    console.log("files -> ",files);
    
    // 선택된 파일이 존재하는지 확인
    if (files.length > 0 && files.length <= 5) {
        // 선택된 파일이 있다면, 파일 이름을 표시할 div 요소를 초기화합니다.
        fileInfoElement.innerHTML = '';

        // 모든 선택된 파일에 대해 반복하면서 파일 이름을 표시합니다.
       	 for (var i = 0; i < files.length; i++) {
            // 각 파일의 이름을 가져와서 표시할 HTML을 생성합니다.
            var fileName = files[i].name;
            var fileHtml = '<div id="selectfile'+i+'">'+ fileName +'&nbsp;&nbsp;<button type="button" class="del-btn"><i class="xi-close-square"></i></button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>';
	
            
            // 생성된 HTML을 파일 이름을 표시할 div 요소에 추가합니다.
            fileInfoElement.innerHTML += fileHtml;
       	 }
        
    } else {
        // 선택된 파일이 없을 경우 메시지를 표시합니다.
        fileInfoElement.innerHTML = 'No file selected';
    }
}
*/
			$(() => {

				$('.ck-blurred').keydown(function () {
					console.log("str : " + window.editor.getData());
					$("#sugestBrdCn").val(window.editor.getData());
				});

				$('.ck-blurred').on("focusout", function () {
					$("#sugestBrdCn").val(window.editor.getData());
				});
				

				$(".del-btn").on("click",function(){
					console.log(event.target);
					let ev = event.target;

					//지우는 영역설정
					let deleteArea = $(ev).closest(".origin-file");
					console.log(deleteArea);

					let file = $(ev).closest(".del-file");
					let atchmnflSeq = event.target.closest(".del-file").dataset.setFileNo;

					console.log("atchmnflSeq -> ",atchmnflSeq);

					let data ={
						atchmnflSeq:atchmnflSeq,
					}

					$.ajax({
						url: "/suggestion/update/fileDelete",
                        data: JSON.stringify(data),
                        contentType: "application/json;charset=utf-8",
                        type: "post",
                        dataType: "json",
                        beforeSend: function (xhr) {
                            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                        },
						success:function(res){
							console.log("삭제버튼 눌렀어요");
							deleteArea.remove();
						},


					});





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
					<form id="myForm"
						action=" /suggestion/updateSuggest?${_csrf.parameterName}=${_csrf.token}"
						method="post" enctype="multipart/form-data">
						<!-- =============== body 시작 =============== -->
						<!-- =============== 상단타이틀영역 시작 =============== -->
						<div class=" wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
							<h1 class="page-tit">건의 게시판</h1>
							<div class="wf-util">
								<button type="button" class="btn1"
									onclick="location.href='/suggestion/list'">취소</button>
								<!-- 등록폼 시작 -->

								<input type="hidden" id="sugestBrdNo" name="sugestBrdNo"
									value="${vo.sugestBrdNo}" />
								<button id="suggestionSubmit" type="submit" class="btn2">수정</button>
							</div>
						</div>
						<!-- =============== 상단타이틀영역 끝 =============== -->
						<!-- =============== 컨텐츠 영역 시작 =============== -->
						<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
							<div class="wf-content-area">

								<ul class="wf-insert-form3">
									<li><input type="hidden" id="empNo" name="empNo"
										value="<%=session.getAttribute(" empNo")%>">
										<div class="wf-insert-tit">
											<input type="text" id="sugestBrdSj" name="sugestBrdSj"
												placeholder="제목을 입력해주세요" value="${vo.sugestBrdSj }">
										</div></li>
									<li>
										<div id="ckExam"></div> <textarea name="sugestBrdCn"
											id="sugestBrdCn" name="sugestBrdCn" value="${vo.sugestBrdCn}"
											style="display: none;">${vo.sugestBrdCn}</textarea>
									</li>
									<li><input type="file" name="uploadfile" id="uploadfile"
										onchange="displaySelectedFileName()" multiple></li>
									<input type="hidden" name="atchmnflNo" value="${vo.atchmnflNo}" />
									
									<!-- 기존 파일 여부 -->
									<c:if test="${atfVO != null }">
										<c:forEach var="atfVO" items="${atfVO}" varStatus="stat">
											<div class="origin-file">
												<div class="del-file"
													data-set-file-no="${atfVO.atchmnflSeq}">${atfVO.atchmnflOriginNm}&nbsp;&nbsp;<button
														type="button" class="del-btn">
														<i class="xi-close-square"></i>
													</button>
													&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												</div>
											</div>
										</c:forEach>
									</c:if>
									<!-- 등록폼 끝 -->
									</ul>
							</div>
						</div>
						<!-- =============== 컨텐츠 영역 끝 =============== -->
						<!-- =============== body 끝 =============== -->
					</form>
				</div>
			</main>
		</div>
	</div>
</body>

</html>

<script type="text/javascript">
			ClassicEditor
				.create(document.querySelector('#ckExam'), { ckfinder: { uploadUrl: '/upload/uploads?${_csrf.parameterName}=${_csrf.token}' } })
				.then(editor => { window.editor = editor; })
				.catch(err => { console.error(err.stack); });
		</script>
<script type="text/javascript">
			window.editor.setData("${vo.sugestBrdCn}");
		</script>