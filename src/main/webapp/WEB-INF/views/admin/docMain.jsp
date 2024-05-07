<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<style>
.swal2-container {
	z-index: 100000;
}
</style>
<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">

	<div class="tab-type tab-type2">
		<div class="tab-menu">
			<!-- "active"가 추가되면 메뉴가 활성화됩니다. -->
			<button data-tab="2" type="button" class="tab-btn active">신청
				목록</button>
			<button data-tab="3" type="button" class="tab-btn">발급허락 목록</button>
			<button data-tab="4" type="button" class="tab-btn">발급 거절 목록</button>
			<div class="tab-indicator"></div>
		</div>

		<!-- tab1  -->
		<div data-tab="tab1" class="tab-content active">
			<div class="tab-board-lst">
				<div class="wf-content-area">
					<table class="wf-table">
						<colgroup>
							<col style="width: 10%;">
							<col style="width: 20%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 20%;">
							<col style="width: 20%;">
							<%-- 							<col style="width: 15%;"> --%>
						</colgroup>
						<thead>
							<tr>
								<th>신청번호</th>
								<th>신청자 사번</th>
								<th>진행상태</th>
								<th>문서명</th>
								<th>신청일자</th>
								<th>사유</th>
							</tr>
						</thead>
						<tbody id="tbody2">
						</tbody>
					</table>
				</div>
			</div>
		</div>

		<!-- tab2  -->
		<div data-tab="tab2" class="tab-content">
			<div class="tab-board-lst">

				<div class="wf-content-area">
					<table class="wf-table">
						<colgroup>
							<col style="width: 10%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
						</colgroup>
						<thead>
							<tr>
								<th>신청번호</th>
								<th>신청자 사번</th>
								<th>진행상태</th>
								<th>문서명</th>
								<th>신청일자</th>
								<th>사유</th>
								<th>처리일자</th>
							</tr>
						</thead>
						<tbody id="tbody3">
						</tbody>
					</table>
				</div>
			</div>
		</div>

		<!-- tab3  -->
		<div data-tab="tab2" class="tab-content">
			<div class="tab-board-lst">

				<div class="wf-content-area">
					<table class="wf-table">
						<colgroup>
							<col style="width: 10%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
						</colgroup>
						<thead>
							<tr>
								<th>신청번호</th>
								<th>신청자 사번</th>
								<th>진행상태</th>
								<th>문서명</th>
								<th>신청일자</th>
								<th>사유</th>
								<th>처리일자</th>
							</tr>
						</thead>
						<tbody id="tbody4">
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
		<!--------------------------------- 모달 시작 ------------------------------- -->
		<div class="modal" id="mFormModal">
			<div class="modal-cont">
				<h1 class="modal-tit" id="modalTit">문서 발급 처리</h1>
				<div class="modal-content-area">
					<div class="wf-flex-box">
						<form id="mForm" action="/updateDocStatus" method="post">
							<ul class="wf-insert-form">

								<li><label for="docNo">신청 번호<i class="i">*</i></label>
									<div>
										<input type="text" name="docNo" value="${mFormVO.docNo}"
											class="form-control" id="docNo" />
									</div></li>

								<li><label for="empNo">신청자 사번<i class="i">*</i></label>
									<div>
										<input type="text" name="empNo" value="${mFormVO.empNo}"
											class="form-control" id="empNo" />
									</div></li>

								<li><label for="docNm">문서명<i class="i">*</i></label>
									<div>
										<input type="text" name="docNm" value="${mFormVO.docNm}"
											class="form-control" id="docNm" />
									</div></li>

								<li><label for="issueBeginDate">신청일자<i class="i">*</i></label>
									<div>
										<input type="text" name="issueBeginDate"
											value="${mFormVO.issueBeginDate}" class="form-control"
											id="issueBeginDate" />
									</div></li>

								<li><label for="docReason">신청사유<i class="i">*</i></label>
									<div>
										<input type="text" name="docReason"
											value="${mFormVO.docReason}" class="form-control"
											id="docReason" />
									</div></li>

								<li><label for="docStatus">처리 결과<i class="i">*</i></label>
									<div>
										<div class="wf-select-group">
											<select id="docStatus" name="docStatus" required>
												<option value="">처리 결과</option>
												<option value="3">발급 가능</option>
												<option value="4">발급 거절</option>
											</select>
										</div>
									</div></li>

							</ul>
							<br> <br>
							<div class="modal-btn-wrap" id="createBtnGroup">
								<button type="button" class="btn2" id="createModBtn">확인</button>
							</div>
							<sec:csrfInput />
						</form>
					</div>
				</div>
				<button type="button" class="close-btn" id="rsvModalCloseBtn"></button>
			</div>
		</div>
		<!---------------------------------모달 끝 --------------------------------->
		<script>
$(function() {
	tabList(2);

  	$(".tab-btn").on("click",function(){
  		let num=$(this).data("tab");
  		tabList(num);
  	});
    
});

function tabList(num){

	        let tab="#tbody"+num;
	        let str="";
	        console.log("docStatus", num);

	        $.ajax({
	            url: '/docList',
	            type: 'post',
	            data: JSON.stringify({ docStatus: num }),
	            success: function(data) {
	            	console.log("data: ", data);
	            	data.forEach(mFormVO => {
	            		   str +=`<tr>`;
	            		   if(num=='2'){
	            			   str +=`<td modal-id="mFormModal" onclick="fillModalForm('\${mFormVO.docNo}', '\${mFormVO.empNo}', '\${mFormVO.docNm}', '\${mFormVO.issueBeginDate}', '\${mFormVO.docReason}')" style="text-decoration: underline;">
   	                            \${mFormVO.docNo}</td>`;
	            		   } else {
	            			   str +=`<td>\${mFormVO.docNo}</td>`;
	            		   }
	            		   str +=`<td>\${mFormVO.empNo}</td>`;
   	                     if(num=='2'){
   	                      str += `<td><span class="wf-badge2">\${mFormVO.docStatus}</span></td>`;
   	                     } else if (num=='3'){
   	                    	 str += `<td><span class="wf-badge3">\${mFormVO.docStatus}</span></td>`;
   	                     } else {
   	                    	 str += `<td><span class="wf-badge4">\${mFormVO.docStatus}</span></td>`;
   	                     }
   	                  str += `<td>\${mFormVO.docNm}</td>
   	                        <td>\${mFormVO.issueBeginDate}</td>
   	                        <td>\${mFormVO.docReason}</td>`;
   	                        if(num=='3' || num=='4'){
   	                        	str+=`<td>\${mFormVO.issueAcceptDate}</td>`;
   	                        }
   	                         
   	                     str +=`</tr>`;
   	               // 페이징 처리
   	                //  $("#divPaging").html(data.pagingArea);
	            	});
	            	
	            	$(tab).html(str);
	            },
	            error: function(xhr, status, error) {
	                // 에러 처리
	                console.error(error);
	            }
	        });	    
}

//신청할 때
function fillModalForm(docNo, empNo, docNm, issueBeginDate, docReason) {
	console.log("docNo:", docNo);
	console.log("docNo:", docNo);
    // 클릭한 정보를 모달 내의 폼 필드에 설정
    $('#docNo').val(docNo);
    $('#empNo').val(empNo);
    $('#docNm').val(docNm);
    $('#issueBeginDate').val(issueBeginDate);
    $('#docReason').val(docReason);
    $("#mFormModal").removeClass("open").addClass("open");
}

document.getElementById("createModBtn").addEventListener("click", function() {
    // 확인 알림 창 표시
    Swal.fire({
        title: _msg.common.docConfirm,
        showDenyButton: true,
        confirmButtonText: "확인",
        denyButtonText: `취소`,
    }).then((result) => {
        if (result.isConfirmed) { 
            // 확인 버튼을 클릭한 경우
            Toast.fire({
                icon: "success",
                title: _msg.common.SuccessAlert, 
            });
            document.getElementById("mForm").submit();
        } else if (result.isDenied) { 
            // 취소 버튼을 클릭한 경우
            Toast.fire({
                icon: "info",
                title: _msg.common.FailAlert,
            });
        }
    });
});

    </script>