<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<div class="wf-main-container">
	<!-- =============== 상단타이틀영역 시작 =============== -->
	<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
		<h1 class="page-tit">
			문자 발송 <i class="xi-message"></i>
		</h1>
		<div class="side-util">
			<button type="button" class="btn1" onclick="autoFill()">자동입력</button>
			<button type="button" class="btn2" onclick="messageSubmit()"
				style="float: right;">전송</button>
		</div>
	</div>
	<!-- =============== 상단타이틀영역 끝 =============== -->
	<br>
	<!-- =============== 컨텐츠 영역 시작 =============== -->
	<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
		<div class="wf-content-area">
			<form id="smsForm" method="post"
				action="/sendSMSAfter?${_csrf.parameterName}=${_csrf.token}">
				<ul class="wf-insert-form3">
					<li><label>발신자: </label>
						<div>
							<h3>WorkForest관리자<h3>
						</div></li>
					<li>
					<label for="inputField">수신자:</label>
						<div class="wf-insert-tit"  id="senderPlus"><input type="text"
								id="inputField" class="autocomplete cntcnos"
								placeholder="수신자 이름을 입력해주세요." />
								<i class="xi-plus xi-2x"
								id="addButton"></i>
						</div>
					</li>
					<li><label></label>
						<div id="recipientList"></div>
					</li>
					<div id="hdnField" style='display: none;'></div>
					<input type="hidden" class="autocomplete cntcnos" name="to"
						id="empVOList" value="" />
					<br>
					<li><label>내용: </label> <textarea name="text">${baseMessage}</textarea>
					</li>
				</ul>
				<sec:csrfInput />
			</form>
		</div>
	</div>
	<!-- =============== 컨텐츠 영역 끝 =============== -->
</div>
<script>

function messageSubmit() {
    var empnoList = $("#recipientList").find("[data-empno]").map(function() {
        return $(this).data("empno");
    }).get();

    console.log("empVOList", empnoList);
    $("#empVOList").val(empnoList);

   
    Swal.fire({
        title: _msg.common.sendConfirm,
        showDenyButton: true,
        confirmButtonText: "발송",
        denyButtonText: `취소`,
    }).then((result) => {
        if (result.isConfirmed) { 
             Toast.fire({
                            icon: "success",
                            title: _msg.common.sendSuccessAlert, 
                        });
            document.getElementById("smsForm").submit();
        } else if (result.isDenied) { 
            Toast.fire({
                icon: "info",
                title: _msg.common.sendFailAlert,
            });
        }
    });
}

				    //부서명 자동완성
				    $(() => {
						$(document).on("focus", ".cntcnos", function (e) {
							if (!$(this).hasClass("ui-autocomplete")) {
								$(this).autocomplete({

									source: function (request, response) {
										console.log("auto1", this.element[0].value);
										autoNm = this.element[0].value;
										console.log("auto2" ,autoNm);
										data = {
											"empNm": autoNm
										}
										console.log("empNm: ", autoNm);
										$.ajax({
											type: 'post',
											data: JSON.stringify(data),
											url: '/findCntcNo',
											contentType: "application/json",
											dataType: 'json',
											success: function (data) {
												console.log("자동완성 : ", data);
												response(
													$.map(data, function (item) {
														return {
															label: item.empNm,
															value: item.empNm,
															cntcNo: item.cntcNo
														}
													})
												);
											}
										});
									},
									select: function (event, ui) {
										console.log("cntcnos시 :", this);
										$(this).val(ui.item.cntcNo);
										$(this).data("cntcNo", ui.item.cntcNo);
										
										console.log("select시 :", $(this).val());
										
										const cntcNo= $("#inputField").val();
										console.log("select시 진짜야 cntcNo :", cntcNo);
										$("#inputField").val(cntcNo);
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
										//$("#ui-id-1").remove();
										console.log(event);
									}
								});
							}
						});
					});//끝
					
				
					// x버튼 클릭, 삭제
					$(document).on("click", ".empDelete", function () {
					    console.log("버튼 누름");

					    let $dynamicDiv = $(this).closest(".dynamic-div"); // 클릭된 버튼의 가장 가까운 ".dynamic-div" 요소 찾기
					    console.log("$dynamicDiv:", $dynamicDiv);

					    let recipientList = $("#recipientList"); // recipientList 변수를 함수 내부에서 정의

					    $dynamicDiv.closest(".wf-badge2").remove(); // 해당 ".dynamic-div" 요소를 포함하는 부모 ".wf-badge2" 요소 삭제
					    
					    // 삭제한 후에 총 수신자 수 업데이트
					      recipientList.find(".total-recipients").remove(); 
					    let updatedRecipients = $(".wf-badge2").length; // 현재 수신자의 수를 계산
					    console.log("updatedRecipients: ", updatedRecipients);
					    recipientList.append(`<div class='total-recipients'>총 \${updatedRecipients}명</div>`); 
					   // updateTotalRecipients(recipientList, updatedRecipients); // 총 수신자 수 업데이트 함수 호출
					});

					// 총 수신자 수 업데이트 함수
// 					function updateTotalRecipients(recipientList, count) {
// 					  recipientList.find(".total-recipients").remove(); // 기존에 있던 총 수신자 수 텍스트를 제거
// 					    recipientList.append(`<div class='total-recipients'>총 ${count}명</div>`); // 새로운 총 수신자 수를 추가
// 					}

							
					 // 버튼 클릭 처리
				    $("#addButton").click(function(){
				        addRecipient();
				    });
							
				    function addRecipient() {
				        var inputText = $("#inputField").val();
				        var inputEmpNo = $("#inputField").data("cntcNo");
				        console.log("inputEmpNo"+inputEmpNo);
				        var recipientList = $("#recipientList");
				        var newRecipient = `<span class="wf-badge2"><div class='dynamic-div' data-empno='\${inputEmpNo}'>\${inputText}<button type="button" class="del-btn empDelete"><i class="xi-close"></i></button></div></span>`;
				  
				        
				        // 새로운 수신자를 목록에 추가
				      //  let count= recipientList.find(".dynamic-div").length+1;       
// 				        if (count > 2 ) {
// 				        	newRecipient= `<div class='dynamic-div' data-empno='\${inputEmpNo}' style='display:none;'>\${inputText}</div>`;
// 				        }
				       	recipientList.append(newRecipient);

				       recipientList.find(".total-recipients").remove();
				      //  recipientList.append(`<div class='total-recipients'>add총 \${count}명</div>`);
				       let updatedRecipients = $(".wf-badge2").length;
				        recipientList.append(`<div class='total-recipients'>총 \${updatedRecipients}명</div>`);
				        // 입력 필드의 값을 비움
				        $("#inputField").val("");
				        
				        // 추가된 수신자를 hidden 입력란에 추가
				        var empVOList = $("#empVOList");
				        var currentValue = empVOList.val(); // 현재 hidden 입력란의 값 가져오기
				        if (currentValue.length > 0) {
				            currentValue += ","; // 값 사이에 쉼표 추가
				        }
				        empVOList.val(currentValue + inputText); 
	
				    }
				    
				    //자동입력
				    function autoFill() {
				     
				        var recipients = [
				            { name: "황지원(데이터관리팀)", cntcNo: "01036298937" },
				            { name: "신성우(마케팅팀)", cntcNo: "01072081833" },
				            { name: "정민준(설비관리팀)", cntcNo: "01092447366" },
				            { name: "이근규(경영기획팀)", cntcNo: "01058833225" },
				            { name: "이현장(국내영업팀)", cntcNo: "01032836140" },
				            { name: "양연주(홍보팀)", cntcNo: "01040874120" },
				            { name: "이소망(연구개발본부)", cntcNo: "01053246883" }
				        ];
				       
				        var recipientList = $("#recipientList");
				        var empVOList = $("#empVOList");

				        recipientList.empty(); // 기존 목록 초기화

				        recipients.forEach(function (recipient) {
				        	   console.log("recipient.name: ", recipient.name);
				        	   console.log("recipient.cntcNo: ", recipient.cntcNo);
				            var newRecipient = `<span class="wf-badge2"><div class='dynamic-div' data-empno='\${recipient.cntcNo}'>\${recipient.name}<button type="button" class="del-btn empDelete"><i class="xi-close"></i></button></div></span>`;
				            recipientList.append(newRecipient);
				        });

				        // 숨겨진 입력란에 데이터 추가
				        var empVOListValue = recipients.map(function (recipient) {
				            return recipient.name;
				        }).join(",");
				        empVOList.val(empVOListValue);

				        // 총 수신자 수 표시
				        recipientList.find(".total-recipients").remove(); // 기존에 있던 총 수신자 수 텍스트 제거
				        recipientList.append(`<div class='total-recipients'>총 \${recipients.length}명</div>`);
				    }
	
				
			</script>