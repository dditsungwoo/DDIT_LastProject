<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<style>
#ui-id-1 {
	z-index: 100000;
}
.swal2-container {
	z-index: 100000;
}

</style>

<!-- =============== body 시작 =============== -->

	<!-- =============== 상단타이틀영역 시작 =============== -->
	<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
		<h1 class="page-tit">부서 관리</h1>
		<ul class="wf-util">
			<li><a href="javascript:void(0)" class="btn5"> 부서
						관리</a>
				<div class="wf-menu-dropdown" style="margin-right:22px;">
					<a href="#" modal-id="deptAddModal"><i class="xi-plus">부서
							등록</i></a>
					<hr>	
					<a href="#" modal-id="deptModModal"><i class="xi-plus">부서
							수정/삭제</i></a>
				</div>
				</li>
		</ul>
	</div>
	<!-- =============== 상단타이틀영역 끝 =============== -->


	<!-- =============== 컨텐츠 영역 시작 =============== -->
	<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
		<div class="wf-content-area">
			<table class="wf-table">
				<colgroup>
					<col style="width: 33%;">
					<col style="width: 33%;">
					<col style="width: 34%;">			
				</colgroup>
				<thead>
					<tr>
						<th>부서번호</th>
						<th>부서명</th>
						<th>상위 부서번호</th>
					</tr>
				</thead>
				<tbody id="depTBody">
					<c:forEach var="deptVO" items="${deptVOList}" varStatus="stat">
						<tr>
							<td>${deptVO.deptNo}</td>
							<td>${deptVO.deptNm}</td>
							<td>${deptVO.upperDept}</td>		
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
	<!-- =============== 컨텐츠 영역 끝 =============== -->

<!-- =============== body 끝 =============== -->


<!--------------------------------- 부서 등록 모달 시작 --------------------------------->
<div class="modal" id="deptAddModal">
	<div class="modal-cont">
		<h1 class="modal-tit" id="modalTit">부서(팀) 등록</h1>
		<div class="modal-content-area">
			<div class="wf-flex-box">
				<form id="deptAddForm" action="/admin/addDept" method="post">
					<ul class="wf-insert-form">
						<li><label for="upperDept">상위 부서<i class="i">*</i></label>
							<div>
								<div class="wf-select-group">
									<select name="upperDept" id="upperDept" required>
										<option value="">상위부서</option>
										<option value="DEPT01">기획본부(DEPT01)</option>
										<option value="DEPT02">경영지원본부(DEPT02)</option>
										<option value="DEPT03">영업본부(DEPT03)</option>
										<option value="DEPT04">마케팅본부(DEPT04)</option>
										<option value="DEPT05">연구개발본부(DEPT05)</option>
									</select>
								</div>
							</div></li>
						<li></li>

						<li><label for="inputdeptNo">부서 번호<i class="i">*</i></label>
							<div>
								<input type="text" id="inputdeptNo" name="deptNo"
									placeholder="부서번호: DEPT+순번">
							</div></li>

						<li><label for="deptNm">부서 명<i class="i">*</i></label>
							<div>
								<input type="text" id="deptNm" name="deptNm" placeholder="부서명">
							</div></li></ul>
							
		<div class="modal-btn-wrap" id="createBtnGroup">
				<button type="button" class="btn2" id="createDeptBtn">등록</button>
		</div>
		<sec:csrfInput />
		</form>
			</div>
		</div>
	
				<button type="button" class="close-btn" id="rsvModalCloseBtn"></button>
	</div>
</div>


<!--------------------------------- 부서 등록 모달 끝 --------------------------------->

<!--------------------------------- 부서 수정 모달 시작 --------------------------------->
<div class="modal" id="deptModModal">
	<div class="modal-cont">
		<h1 class="modal-tit" id="modalTit">부서(팀) 수정/삭제</h1>
		<div class="modal-content-area">
			<div class="wf-flex-box">
				<form id="deptModForm" action="/admin/modDept" method="post">
					<ul class="wf-insert-form">
					
					<li><label for="inputField">부서 명<i class="i">*</i></label>
							<div>
								<input type="text" id="inputField" class="autocomplete teams" placeholder="부서명" />
							</div></li>
					
					
					<li><label for="deptNo">부서 번호<i class="i">*</i></label>
							<div>
								<input type="text" id="deptNo" name="deptNo" value="" readonly />
							</div></li>
							
								<li><label for="newDeptNm">새로운 부서 명<i class="i">(수정일 경우에만 입력)</i></label>
							<div>
								<input type="text" id="newDeptNm" name="deptNm" placeholder="새로운 부서 명을 입력해주세요." />
							</div></li>
							
							
							</ul>
	<br><br>
		<div class="modal-btn-wrap" id="createBtnGroup">
				<button type="button" class="btn2" id="createModBtn">수정</button>
				<button type="button" class="btn2" id="deleteModBtn">삭제</button>
		</div>
				<sec:csrfInput />
				</form>

			</div>
		</div>

		
		<button type="button" class="close-btn" id="rsvModalCloseBtn"></button>
	</div>
</div>

<!--------------------------------- 부서 수정 모달 끝 --------------------------------->
<script>
$(() => {
				    
				  //상위부서 선택시 부서번호 자동입력
				    $("#upperDept").on("change",function(){
				    	  var upperDept = $(this).val();
				    	  console.log("upperDept: ",upperDept);
				    	    $.ajax({
					            url: "/admin/findMyDeptNo", 
					            type: "POST",
					            dataType: "text",
					            data: JSON.stringify({
					            	"upperDept": upperDept
					            }),
					            beforeSend: function(xhr){
						            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
						        },
					            success: function(response) {
					                console.log("response:",response);
					                $("#inputdeptNo").val(response);
					            },
					            error: function(xhr, status, error) {
					                console.error(xhr.responseText);
					                console.error(xhr.status); 				                
					            }
					        });		    	
				    } );//끝
				    
				    //부서명 자동완성
				    $(() => {
						$(document).on("focus", ".teams", function (e) {
							if (!$(this).hasClass("ui-autocomplete")) {
								$(this).autocomplete({

									source: function (request, response) {
										console.log("auto1", this.element[0].value);
										autoNm = this.element[0].value;
										//console.log("auto2" ,autoNm);
										data = {
											"deptNm": autoNm
										}
										console.log("deptNm: ", autoNm);
										$.ajax({
											type: 'post',
											data: JSON.stringify(data),
											url: '/admin/findDeptByName',
											contentType: "application/json",
											dataType: 'json',
											success: function (data) {
												console.log("자동완성 : ", data);
												response(
													$.map(data, function (item) {
													
														return {
															label: item.deptNm,
															value: item.deptNm,
															deptNo: item.deptNo
														}
													})
												);
											}
										});
									},
									select: function (event, ui) {

										console.log("teams시 :", this);

										$(this).val(ui.item.deptNo);
										$(this).data("deptNo", ui.item.deptNo);
										

										console.log("select시 :", $(this).val());
										
										const deptNo= $("#inputField").val();
										console.log("select시 진짜야 deptNo :", deptNo);
										$("#deptNo").val(deptNo);
										
									},
									focus: function (event, ui) {

										return false;
									},
									open: function (event, ui) {
										console.log("open this", this);
										console.log("open ui", ui);
										console.log("open event", event);

									},
									minLength: 1,
									autoFocus: true,
									classes: {
										'ui-autocomplete': 'highlight'
									},
									delay: 500,
									position: { my: 'right top', at: 'right bottom' },
									close: function (event) {
										$("#ui-id-1").remove();
										console.log(event);

									}
								});
							}
						});
					});//끝
					
					//등록시 알럿
				    document.getElementById("createDeptBtn").addEventListener("click", function() {
				        Swal.fire({
				            title: _msg.common.docConfirm,
				            showDenyButton: true,
				            confirmButtonText: "확인",
				            denyButtonText: `취소`,
				        }).then((result) => {
				            if (result.isConfirmed) { 
				                Toast.fire({
				                    icon: "success",
				                    title: _msg.common.SuccessAlert, 
				                });
				                document.getElementById("deptAddForm").submit();
				            } else if (result.isDenied) { 
				                Toast.fire({
				                    icon: "info",
				                    title: _msg.common.FailAlert,
				                });
				            }
				        });
				    });
					
					//수정시 알럿
				    document.getElementById("createModBtn").addEventListener("click", function() {
				        Swal.fire({
				            title: _msg.common.docConfirm,
				            showDenyButton: true,
				            confirmButtonText: "확인",
				            denyButtonText: `취소`,
				        }).then((result) => {
				            if (result.isConfirmed) { 
				                Toast.fire({
				                    icon: "success",
				                    title: _msg.common.SuccessAlert, 
				                });
				                document.getElementById("deptModForm").submit();
				            } else if (result.isDenied) { 
				                Toast.fire({
				                    icon: "info",
				                    title: _msg.common.FailAlert,
				                });
				            }
				        });
				    });
				
				  //삭제시 알럿
				    document.getElementById("deleteModBtn").addEventListener("click", function() {
				        Swal.fire({
				            title: _msg.common.docConfirm,
				            showDenyButton: true,
				            confirmButtonText: "확인",
				            denyButtonText: `취소`,
				        }).then((result) => {
				            if (result.isConfirmed) { 
				                Toast.fire({
				                    icon: "success",
				                    title: _msg.common.SuccessAlert, 
				                });
				                // 폼 제출
				                document.getElementById("deptModForm").action = "/admin/delDept";
				                document.getElementById("deptModForm").submit();
				            } else if (result.isDenied) { 
				                Toast.fire({
				                    icon: "info",
				                    title: _msg.common.FailAlert,
				                });
				            }
				        });
				    });		
	
}); 				    

				
				
</script>