<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="com.team1.workforest.employee.vo.EmployeeVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<style>
/* .image {
	position: absolute;
	top: 500;
	left: 500;
} */
.modal:not(#openModal) .modal-cont {padding: 90px 40px 40px;}
.modal:not(#openModal) #pdf_btn {position: absolute; top: 40px;}
.modal:not(#openModal) .modal-content-area {padding: 0;}
</style>
<div class="wf-main-container">
	<!-- =============== body 시작 =============== -->
	<!-- =============== 상단타이틀영역 시작 =============== -->
	<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
		<h1 class="page-tit">My Page</h1>
	</div>
	<!-- =============== 상단타이틀영역 끝 =============== -->
	<!-- =============== 컨텐츠 영역 시작 =============== -->
	<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
		<div class="tab-type tab-type2">
			<div class="tab-menu">
				<!-- "active"가 추가되면 메뉴가 활성화 -->
				<button data-tab="1" type="button" class="tab-btn active">내
					정보</button>
				<button data-tab="2" type="button" class="tab-btn">문서/증명서</button>
				<div class="tab-indicator"
					style="width: 53.7031px; transform: translateX(0px);"></div>
			</div>

			<!-- tab1  -->
			<div data-tab="tab1" class="tab-content active">

				<ul class="tab-board-lst">
					<div class="wf-content-area">
						<!--  일반 모드-->
						<div id="spn1" class="wf-flex-box"
							style="justify-content: flex-end;">
							<button type="button" id="edit" class="btn4">수정</button>
						</div>
						<!-- 수정 모드 -->
						<div id="spn2" class="wf-flex-box" style="display: none;">
							<button type="button" id="cancel" class="btn1">취소</button>
							&nbsp;
							<button type="submit" id="confirm" class="btn2">확인</button>
						</div>
						<ul class="wf-insert-form2 detail">
							<li><label>프로필 이미지</label>
								<div class="wf-flex-box">
									<div class="img-box">
										<img src="/resources/img/icon/${empVO.proflImageUrl}">
									</div>
								</div> <input type="file" name="multipartFile" id="proflImageUrl"
								class="form-control" style="display: none;" /> <br> <br>
								<p>
									&nbsp;&nbsp;<strong>${empVO.empNm}</strong> 님 (${empVO.gender})
								</p> <input type="hidden" id="empNo" value="${empVO.empNo}" /></li>
							<li><label>사원번호</label>
								<div>
									<p>${empVO.empNo}</p>
								</div> <br> <br> <label>소속 부서</label>
								<div>
									<p>${empVO.deptNm}</p>
								</div></li>
							<li><label>직급</label>
								<div>
									<p>${empVO.position}</p>
								</div></li>
							<li><label>직책</label>
								<div>
									<p>${empVO.rspnsblCtgryNm}</p>
								</div></li>
							<li><label>입사일</label>
								<div>
									<p>${empVO.ecnyDate}</p>
								</div></li>
							<li><label>내선번호</label>
								<div>
									<p>${empVO.lxtn}</p>
								</div></li>
							<li><label>생년월일</label>
								<div>
									<p>${empVO.bdate}</p>
								</div></li>
							<li><label>개인 연락처</label>
								<div>
									<p>${empVO.cntcNo}</p>
									<br> <input type="text" name="cntcNo"
										value="${empVO.cntcNo}" class="form-control" id="cntcNo"
										placeholder="개인 연락처" style="display: none;" />
								</div></li>
							<li><label>근무지 위치</label>
								<div>
									<p>${empVO.workLocation}</p>
								</div></li>
							<li><label>이메일 주소</label>
								<div>
									<p>${empVO.email}</p>
									<br> <input type="text" name="email"
										value="${empVO.email}" class="form-control" id="email"
										placeholder="이메일 주소" style="display: none;" />
								</div></li>

							<li><label>주소</label>
								<div>
									<p>${empVO.zipCode}/${empVO.basisAdres}
										${empVO.detailAdres}</p>
									<br>
									<button type="button" id="btnZip"
										class="btn btn-default btn-sm form-control"
										style="display: none;">우편번호 검색</button>
									<input type="text" name="zipCode" value="${empVO.zipCode}"
										class="form-control" id="zipCode" placeholder="우편번호"
										style="display: none;" /> <input type="text"
										name="basisAdres" value="${empVO.basisAdres}"
										class="form-control" id="basisAdres" placeholder="기본 주소"
										style="display: none;" /> <input type="text"
										name="detailAdres" value="${empVO.detailAdres}"
										class="form-control" id="detailAdres" placeholder="상세 주소"
										style="display: none;" />
								</div></li>

							<li><label><a href="/emp/modPass"><i
										class="xi-cog">비밀번호 변경</i></a></label></li>
							<li style="display: none;">
								<p>${empVO}</p>
							</li>
						</ul>
					</div>
				</ul>
			</div>
			<!-- //////////////////////////////////////////////////////////////////////////////////////////////////////// -->
			<!-- tab2  -->
			<div data-tab="tab2" class="tab-content">
				<ul class="tab-board-lst">
					<div class="wf-content-area">
						<div class="wf-tit-wrap">
							<p class="heading1">발급 신청 목록</p>
							<div class="side-util">
								<button type="button" class="btn5" id="openModalButton"
									modal-id="openModal">발급 신청</button>
							</div>
						</div>
						<br>
						<table class="wf-table">
							<colgroup>
								<col style="width: 10%;">
								<col style="width: 20%;">
								<col style="width: 15%;">
								<col style="width: 20%;">
								<col style="width: 20%;">
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
								</tr>
							</thead>
							<tbody id="tbody2">
							</tbody>
						</table>
					</div>
					<!--  -->
					<div class="wf-content-area">
						<div class="wf-tit-wrap">
							<p class="heading1">발급 가능 목록</p>
<!-- 							<div class="side-util"> -->
<!-- 								<button type="button" class="btn5" modal-id="modal-name1">재직증명서</button> -->
<!-- 								<button type="button" class="btn5" modal-id="modal-name2">급여명세서</button> -->
<!-- 							</div> -->
						</div>
						<br>
						<table class="wf-table">
							<colgroup>
								<col style="width: 10%;">
								<col style="width: 15%;">
								<col style="width: 10%;">
								<col style="width: 10%;">
								<col style="width: 15%;">
								<col style="width: 15%;">
								<col style="width: 15%;">
								<col style="width: 10%;">
							</colgroup>
							<thead>
								<tr>
									<th>신청번호</th>
									<th>신청자 사번</th>
									<th>진행상태</th>
									<th>문서명</th>
									<th>신청일자</th>
									<th>사유</th>
									<th>발급처리일자</th>
									<th>발급</th>
								</tr>
							</thead>
							<tbody id="tbody3">
							</tbody>
						</table>
					</div>
				</ul>
			</div>
			<!--  tab2 끝-->
		</div>
	</div>
	<!-- =============== 컨텐츠 영역 끝 =============== -->
	<!-- =============== body 끝 =============== -->
	<%
		LocalDate currentDate = LocalDate.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");
	String formattedDate = currentDate.format(formatter);
	%>

	<!-- 발급신청 모달 -->
	<div class="modal" id="openModal">
		<div class="modal-cont">
			<h1 class="modal-tit" id="modalTit">발급 신청</h1>
			<div class="modal-content-area">
				<div class="wf-flex-box">
					<form id="docAddForm" action="/addDoc" method="post">
						<ul class="wf-insert-form">
							<li><label for="empNo">사번<i class="i">*</i></label>
								<div>
									<input type="text" id="empNo" name="empNo"
										value="${empVO.empNo}">
								</div></li>
							<li><label for="docNm">문서 종류<i class="i">*</i></label>
								<div>
									<div class="wf-select-group">
										<select name="docNm" id="docNm" required>
											<option value="">문서 종류</option>
											<option value="1">재직증명서</option>
											<option value="2">급여명세서</option>
											<option value="3">연봉계약서</option>
										</select>
									</div>
								</div></li>
							<li><label for="inputdocNo">발급신청번호<i class="i">*</i></label>
								<div>
									<input type="text" id="inputdocNo" name="docNo" />
								</div></li>
							<li><label for="docReason">발급 사유<i class="i">*</i></label>
								<div>
									<input type="text" id="docReason" name="docReason"
										placeholder="발급 사유를 입력하세요.">
								</div></li>
						</ul>
						<br>
						<div class="modal-btn-wrap" id="createBtnGroup">
							<button type="submit" class="btn2" form="docAddForm"
								id="createDeptBtn">등록</button>
						</div>
						<input type="hidden" name="${_csrf.parameterName}"
							value="${_csrf.token}" />
						<sec:csrfInput />
					</form>
				</div>
			</div>
			<button type="button" class="close-btn" id="rsvModalCloseBtn"></button>
		</div>
	</div>
	<!-- 발급신청 모달 끝 -->

	<!-- 재직증명서 - 미리 보기 모달 시작 -->
	<div class="modal" id="modal-name1">
		<div class="modal-cont">
			<div class="modal-content-area">
				<div class="apv-doc-form" id="pdfviewer1" style="height: auto;">
					<table>
						<tbody>
							<span class="form-tit">재직증명서</span>
						<tbody>
							<tr>
								<th rowspan="1">이름</th>
								<td colspan="5">${empNm}</td>
							</tr>
							<tr>
								<th rowspan="1">생년월일</th>
								<td colspan="5">${empVO.bdate}</td>
							</tr>
							<tr>
								<th rowspan="1">주소</th>
								<td colspan="5">${empVO.zipCode}/${empVO.basisAdres}
									${empVO.detailAdres}</td>
							</tr>
						</tbody>
						</td>
						</tr>
						<tr>
							<th>소속 부서</th>
							<td>${deptNm}</td>
							<th>직급</th>
							<td>${position}</td>
							<th>직책</th>
							<td>${rspnsblCtgryNm}</td>
						</tr>
						<tr>
							<th>기안자</th>
							<td>${empNm}</td>
							<th>보존년한</th>
							<td colspan="4">3년</td>
						</tr>
						<tr>
							<th>재직 기간</th>
							<td colspan="5">${empVO.ecnyDate} - 현재</td>
						</tr>
						<tr>
							<td colspan="6"><br> <br>상기와 같이 재직 중임을 증명함<br>
								<br> <br> <br> <br> <br> <br> <br>
								<br> <br> <br> 주소: 34908 / 대전광역시 중구 계룡로 846 3층<br>
								회사명: WorkForest<img src="/resources/img/icon/도장.png"
								style="width: 50px; height: 50px; object-fit: cover; vertical-align: middle;"
								class="image"><br> 대표 이사: 유재석<br> <br></td>
						</tr>
						</tbody>
					</table>
				</div>
			</div>
		<button class="close-btn"></button>
		<button type="button" class="btn5 pdfbtn" id="pdf_btn">
			PDF <i class="xi-download"></i>
		</button>	
		</div>
		
	</div>
	<!-- 재직증명서 - 미리 보기 모달 끝 -->

	<!-- 급여명세서 - 미리 보기 모달 시작 -->
	<div class="modal" id="modal-name2">
		<div class="modal-cont">
			<div class="modal-content-area">
				<div class="apv-doc-form" id="pdfviewer2">
					<table>
						<tbody>
							<%=formattedDate%>
							월
							<span class="form-tit">급여명세서</span>
							<tr>
								<th rowspan="1">이름</th>
								<td colspan="2">${empNm}</td>
								<th rowspan="1">생년월일</th>
								<td colspan="2">${empVO.bdate}</td>
							</tr>
							<tr>
								<th rowspan="1">주소</th>
								<td colspan="5">${empVO.zipCode}/${empVO.basisAdres}
									${empVO.detailAdres}</td>
							</tr>
							<tr>
								<th>소속 부서</th>
								<td>${deptNm}</td>
								<th>직급</th>
								<td>${position}</td>
								<th>직책</th>
								<td>${rspnsblCtgryNm}</td>
							</tr>
							<tr>
								<th colspan="6">세부 내역</th>
							</tr>
						</tbody>
					</table>
					<table style="width: 100%;">
						<tr>
							<td style="width: 15%;">기본 급여</td>
							<td style="width: 35%;">2,500,000원</td>
							<td style="width: 15%;">고용 보험</td>
							<td style="width: 35%;">100원</td>
						</tr>
						<tr>
							<td style="width: 15%;">기본 급여</td>
							<td style="width: 35%;">2,500,000원</td>
							<td style="width: 15%;">고용 보험</td>
							<td style="width: 35%;">100원</td>
						</tr>
						<tr>
							<td style="width: 15%;">시간외 수당</td>
							<td style="width: 35%;">2,500,000원</td>
							<td style="width: 15%;">건강 보험</td>
							<td style="width: 35%;">100원</td>
						</tr>
						<tr>
							<td style="width: 15%;">상여금</td>
							<td style="width: 35%;">2,500,000원</td>
							<td style="width: 15%;">국민 연금</td>
							<td style="width: 35%;">100원</td>
						</tr>
						<tr>
							<td style="width: 15%;">식대</td>
							<td style="width: 35%;">2,500,000원</td>
							<td style="width: 15%;"></td>
							<td style="width: 35%;"></td>
						</tr>
					</table>
					<table>
						<tbody>
							<tr>
								<td rowspan="3" style="width: 50%;">귀하의 노고에 대단히 감사드립니다.</td>
								<td>지급 합계</td>
								<td>3,000,000</td>
							</tr>
							<tr>
								<td>공제 합계</td>
								<td>3000</td>
							</tr>
							<tr>
								<td>실지급액</td>
								<td>2,997,000</td>
							</tr>
							<td colspan="6">Copyright © WorkForest 대표이사 유재석
							<img
								src="/resources/img/icon/도장.png"
								style="width: 30px; height: 30px; object-fit: cover; vertical-align: middle;"
								class="image"><br></td>
						</tbody>
					</table>
				</div>
			</div>
			<button class="close-btn"></button>
			<button type="button" class="btn5 pdfbtn" id="pdf_btn">PDF <i class="xi-download"></i></button>
		</div>
		
	</div>
	<!-- 급여명세서 - 미리 보기 모달 끝 -->

	<script type="text/javascript">
	
	let empNo= <%=session.getAttribute("empNo")%>
	$(document).ready(function() {
		tabList(2, empNo);
		tabList(3, empNo);
	});

	function tabList(num, empNo) {
	    let tab = "#tbody" + num;
	    let str = "";
	    console.log("docStatus: ", num);
	    console.log("empNo: ", empNo);

	    $.ajax({
	        url: '/getMyDocList',
	        type: 'post',
	        data: JSON.stringify({ docStatus: num, empNo: empNo }),
	        contentType: 'application/json',
	        dataType: "json",
	        success: function(data) {
	            console.log("data: ", data);

	            data.forEach(mFormVO => {
	                str += `<tr>
	                        <td>\${mFormVO.docNo}</td>
	                        <td>\${mFormVO.empNo}</td>`;
	                if (num == '3' || num == '4') {
	                    str += `<td><span class="wf-badge3">\${mFormVO.docStatus}</span></td>`;
	                } else {
	                    str += `<td><span class="wf-badge2">\${mFormVO.docStatus}</span></td>`;
	                }
	                str += `<td>\${mFormVO.docNm}</td>
	                        <td>\${mFormVO.issueBeginDate}</td>
	                        <td>\${mFormVO.docReason}</td>`;
	                if (num == '3' || num == '4') {
	                    str += `<td>\${mFormVO.issueAcceptDate}</td>`;
	                } else {
	                    str += `<td></td>`;
	                }
	                if (num == '3'){
	                if (mFormVO.docNm === '재직증명서') {
	                    str += `<td><button type="button" class="btn5 docBtn" modal-id="modal-name1">재직증명서</button></td>`;
	                } else if (mFormVO.docNm === '급여명세서') {
	                    str += `<td><button type="button" class="btn5 docBtn" modal-id="modal-name2">급여명세서</button></td>`;
	                } else {
	                    str += `<td></td>`; 
	                }
	                }
	            });

	            str += '</tr>';
	            $(tab).html(str);
	        },
	        error: function(xhr, status, error) {
	            // 에러 처리
	            console.error(error);
	        }
	    });
	}
	
	function modalOp(id) {
		
	    //let id = $(this).attr("modal-id");
	    console.log("modal",this);
	    $(".modal")
	        .removeClass("open")
	        .filter("#" + id)
	        .addClass("open");
	    $("html").addClass("scroll-hidden");
	}
	
	
	$(document).ready(function() {
		
	    $("#openModalButton").click(function() {
	        $.ajax({
	            url: "/findDocNo",
	            type: "POST",
	            dataType: "text",
	            beforeSend: function(xhr) {
	                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	            },
	            success: function(response) {
	                console.log("response:", response);
	                $("#inputdocNo").val(response);
	            },
	            error: function(xhr, status, error) {
	                console.error(xhr.responseText);
	                console.error(xhr.status);
	            }
	        });
	    });
	});

	
		$(function() {
			$(document).on("click",".docBtn",function(){
				let id = $(this).attr("modal-id");
				modalOp(id);
			})
			
			//다음 우편번호 검색
			$("#btnZip").on("click", function() {
				//console.log("우편번호 검색하실게요");
				new daum.Postcode({
					//다음 창에서 검색이 완료되면
					oncomplete : function(data) {
						$("#zipCode").val(data.zonecode); //우편번호
						$("#basisAdres").val(data.address); //주소
						$("#detailAdres").val(data.buildongName); //상세주소
					}
				}).open();
			});

			//수정 버튼 클릭시 - spn1:none, spn2:block
			$("#edit").on("click", function() {
				$("#spn1").css("display", "none");
				$("#spn2").css("display", "block").css("float", "right");
				$(".form-control").css("display", "block");
			});

			//확인(수정)
			$("#confirm").on(
					"click",
					function() {
						let proflImageUrl = $("#proflImageUrl").val(); //수정 대상
						let empNo = $("#empNo").val();
						let cntcNo = $("#cntcNo").val(); //수정 대상
						let email = $("#email").val(); //수정 대상
						let zipCode = $("#zipCode").val(); //수정 대상
						let basisAdres = $("#basisAdres").val(); //수정 대상
						let detailAdres = $("#detailAdres").val(); //수정 대상
						let empPw = $("#empPw").val(); //수정 대상

						//json오브젝트
						let data = {
							"proflImageUrl" : proflImageUrl,
							"empNo" : empNo,
							"cntcNo" : cntcNo,
							"email" : email,
							"zipCode" : zipCode,
							"basisAdres" : basisAdres,
							"detailAdres" : detailAdres,
							"empPw" : empPw
						};
						console.log("data : ", data);

						$.ajax({
						    url : "/emp/modDetail",
						    contentType : "application/json;charset=utf-8",
						    data : JSON.stringify(data),
						    type : "post",
						    dataType : "text",
						    beforeSend : function(xhr) {
						        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
						    },
						    success : function(result) {
						        console.log("result :", result);
						        if (result === "-1") {
						            Swal.fire({
						                icon: 'error',
						                title: '파일 형식이 맞지 않습니다.',
						                text: '이미지 형식의 파일을 선택해 주세요.'
						            });
						        } else {
						        	Toast.fire({
					                    icon: "success",
					                    title: _msg.common.SuccessAlert, 
					                }).then((result) => {
						                
						                    $("#cancel").click(); 
						                
						            });
						        }
						    }
						});
					});

			//취소 버튼 클릭시
			$("#cancel").on("click", function() {
				let empNo = "${param.empNo}";
				location.href = "/emp/detail?empNo=" + empNo;
			});

			let jsPDF = jspdf.jsPDF;
			//pdf download
			$(".pdfbtn").on("click", function() {
			    var selectedModalId = $(this).closest('.modal').find('.apv-doc-form').attr('id');
			    var modalTitle = $('#' + selectedModalId).find('.form-tit').text(); // 모달의 제목 가져오기

			    html2canvas($('#' + selectedModalId)[0]).then(function(canvas) {
			        // 캔버스를 이미지로 변환 
			        var imgData = canvas.toDataURL('image/png');
			        var imgWidth = 190;
			        var pageHeight = 500;
			        var imgHeight = parseInt(canvas.height * imgWidth / canvas.width);
			        var heightLeft = imgHeight;
			        var margin = (210 - imgWidth) / 2;

			        var doc = new jsPDF('p', 'mm', 'a4');
			        var position = 30;

			        // 첫 페이지 출력
			        doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
			        heightLeft -= pageHeight;

			        // 페이지가 더 있을 경우 루프 돌면서 출력
			        while (heightLeft >= 0) {
			            position = heightLeft - imgHeight;
			            doc.addPage();
			            doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
			            heightLeft -= pageHeight;
			        }

			        // 파일 저장(다운로드)
			        doc.save(modalTitle + '.pdf');

			    });
			});
		});

	</script>