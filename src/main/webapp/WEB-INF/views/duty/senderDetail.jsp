<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<div class="wf-main-container">
	<!-- =============== body 시작 =============== -->
	<!-- =============== 상단타이틀영역 시작 =============== -->
	<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
		<h1 class="page-tit">${vo.dutySj }  ${vo.cnfirmDate == '읽음' ? '<badge class="wf-badge1 topBadge">읽음</badge>' : '<badge class="wf-badge5 topBadge">읽지 않음</badge>'}</h1>
		
		<div class="wf-util">
			<button type="button" id="btnPrgs" class="btn4">수정</button>
			<button type="button" id="btnDel" class="btn3">삭제</button>
			
			<button type="button" id="btnPrgsConfirm" class="btn3" style="display:none;">수정</button>
			<button type="button" id="btnPrgsBack" class="btn4" style="display:none;">돌아가기</button>
			<button type="button" id="btnAutoTyping" class="btn5" style="display:none;">자동완성</button>
			
		</div>
	</div>
	<!-- =============== 상단타이틀영역 끝 =============== -->
	<!-- =============== 컨텐츠 영역 시작 =============== -->
	<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">

		<div class="wf-content-area">

			<!-- 상세폼 시작 -->
			<!-- wf-insert-form에 "detail"추가해주세요 -->
			<ul class="wf-insert-form detail">
				<li><label></label>
					<div class="wf-flex-box">
						<div class="img-box" style="width:250px; height:250px;">
							<img src="/resources/img/project/projectDefault.png">
						</div>
					</div></li>
				<li><label>수신자</label>
					<div>
						<p>${vo.sender}</p>
					</div></li>
				<li><label>발신일자</label>
					<div>
						<p>${vo.sendDate }</p>
					</div></li>
				<li><label>마감일자</label>
					<div>
						<p class ="updateTxt" id="closDt">${vo.closDate }</p>
						<input type="date" id="dateBox" style="display:none;">
					</div></li>
				<li><label>진행률</label>
					<div>
						<p id="pprgsRate">${(vo.prgsRate*10) }%</p>
					</div></li>
				<li><label>마감시간</label>
					<div>
						<p class ="updateTxt" id="closTm">${vo.closTime }</p>
						<input type="text" id="timeBox" style="display:none;" value="${vo.closTime }"> 
					</div></li>
				
				<li><label>업무 상세 내용</label>
					<div>
						<p class ="updateTxt" id="dutyCt">${vo.dutyCn }</p>
						<textarea id="dutyCnBox" style="display:none;">${vo.dutyCn }</textarea>
					</div></li>
					
				<li><label>첨부 파일</label>
					<div>
					
						<a>${vo.atchmnflNo }</a>
					</div></li>
			</ul>

			<!-- 상세폼 끝 -->
		</div>

	</div>
	<!-- =============== 컨텐츠 영역 끝 =========== -->
	<!-- =============== body 끝 =============== -->
</div>
 
<script src="/resources/script/duty/detail.js"></script>

<script>
$(()=>{
 
    let dutyNo="${vo.dutyNo}";
    let SenderEmpNo="${vo.empNo}";
    let recipient="${vo.recipient}";
	let cnfirmDate="${vo.cnfirmDate}";
	let vprgsRate="${vo.prgsRate}";
	// 수정 버튼 클릭시 나타나는 함수-------------------------------
	$("#btnPrgs").on("click",function(){
		$(this).css("display","none");
		$("#btnPrgsConfirm").css("display","block");
		$("#btnPrgsBack").css("display","block");
		$("#btnDel").css("display","none");
		$("#btnAutoTyping").css("display","block");
		$(".updateTxt").css("display","none");
		$("#dateBox").css("display","block");
		let dutyCnBr= $("#dutyCnBox").val();
		dutyCnBr=dutyCnBr.replaceAll("<br>","\n");
		$("#dutyCnBox").val(dutyCnBr);
		$("#dutyCnBox").css("display","block");
		$("#timeBox").css("display","block");
		
		
	});// 수정 버튼 클릭시 나타나는 함수 끝--------------------------
	
	
	
	
	// 수정 버튼 돌아가기 클릭시 나타나는 함수-------------------------------
	$("#btnPrgsBack").on("click",function(){		
		blockBtn();
	
	});// 수정 버튼  돌아가기 클릭시 나타나는 함수 끝--------------------------
	

	var closDateInput = document.getElementById('dateBox');

	// 현재 날짜 가져오기
	var currentDate = new Date();

	// 이전 날짜를 선택할 수 없도록 설정------------------
	closDateInput.addEventListener('input', function() {
	    var selectedDate = new Date(closDateInput.value);
	    if (selectedDate < currentDate) {
	        closDateInput.value = ''; // 선택한 날짜를 초기화하여 이전 날짜를 선택할 수 없도록 함
	        Swal.fire({
   			  title: _msg.reservation.formDateErrorAlert,
   			  text: "",
   			  //icon: "error"
   			});
	    }
	});// 이전 날짜를 선택할 수 없도록 설정-------------------
	
	
	// 삭제 버튼 클릭시 나타나는 함수-------------------------------
	$("#btnDel").on("click",function(){
		let data={
				"dutyNo":dutyNo,
				"empNo":recipient
			};
		if(vprgsRate=="0"){
			Swal.fire({
  			  title: "이미 중지된 업무입니다!",
  			  text: "",
  			  //icon: "error"
  			});
			return;
		}
		
		if(cnfirmDate.length==2){
       		Swal.fire({
    			  title: "직원이 이미 업무를 확인하였습니다!",
    			  text: _msg.common.deleteConfirm,
    			  //icon: "error"
    			}).then((result) => {
    		        if (result.isConfirmed) {
    		    		deleteDuty(data);
    		    		return;
    		        }
    		    });
		}else if(cnfirmDate.length==4){
			Swal.fire({
  			  title: _msg.common.deleteConfirm,
  			  text: "",
  			  //icon: "error"
  			}).then((result) => {
  		        if (result.isConfirmed) {
  		    		deleteDuty(data);
  		    		return;
  		        }
  		    });
		}
		
	

	});// 삭제 버튼 클릭시 나타나는 함수-----------------------------	 
	
	// 자동완성 버튼
	$("#btnAutoTyping").on("click",function(){
		$("#timeBox").val("14:00");
		$("#dutyCnBox").val("세부내용은 자료실 참조 부탁드립니다.");
		$("#dateBox").val("2024-04-20");
	})
	
	
	//자동완성 버튼 끝
	
	
	//수정 확정 버튼 클릭시 나타나는 함수-----------------------------
	$("#btnPrgsConfirm").on("click",function(){
		console.log("btnPrgsConfirm");
		let timeBox=$("#timeBox").val();
		let dutyCnBox=$("#dutyCnBox").val();
		let dateBox=$("#dateBox").val();
		console.log("btnPrgsConfirm"+timeBox);
		
		if(timeBox=="" || dutyCnBox=="" || dateBox==""){
			Swal.fire({
	  			  title: _msg.common.fillEmptyFieldsAlert,
	  			  text: "",
	  			  //icon: "error"
	  			});
			return;
		}
		let data={
			"closDate":dateBox,
			"empNo":recipient,
			"dutyNo":dutyNo,
			"closTime":timeBox,
			"dutyCn":dutyCnBox
		};
		$.ajax({
			url:"/duty/updateDuty",
			data:JSON.stringify(data),
			contentType:"application/json;charset=utf-8",
			type:"post",
			dataType:"json",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success:function(res){ 
				console.log(res);
				if(res>0){
				Swal.fire({
		  			  title: _msg.common.updateSuccessAlert,
		  			  text: "직원의 업무가 읽지 않음으로 변경됐습니다!",
		  			  //icon: "success"
		  			}).then((result) => {
		  		        if (result.isConfirmed) {
		  		    		$("#closDt").html(dateBox);
		  		    		$("#closTm").html(timeBox);
		  		    		$("#dutyCt").html(dutyCnBox);
		  		    		$(".topBadge").html("읽지않음");
		  		    		$(".topBadge").removeClass("wf-badge1");
		  		    		$(".topBadge").addClass("wf-badge5");
		  		    		blockBtn();
		  		        }
		  		    });
				}
			}
		});
		
	
		
	});//수정 확정 버튼 클릭시 나타나는 함수-----------------------
	
	
	
	
	
});//$function 끝 ------------------------------------------



//삭제하는 함수---------------------------------------------

function deleteDuty(data){
	$.ajax({
		url:"/duty/deleteDuty",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		dataType:"json",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(res){  
			console.log(res);
			if(res>0){
				Toast.fire({
	    			  title: _msg.common.deleteSuccessAlert,	    			  
	    			  icon: "success"
	    			});
	    		location.href="/duty/sender";   		    		      		           
			}
			
		}
	});	
}//삭제하는 함수 끝---------------------------------------------

// 수정버튼 눌렀을때 뒤로가기 누르면 버튼 사라지고 인풋박스 나오고하는 함수
function blockBtn(){
	$("#btnPrgsBack").css("display","none");
	$("#btnPrgsConfirm").css("display","none");	
	$("#btnDel").css("display","block");
	$("#btnPrgs").css("display","block");
	$("#btnAutoTyping").css("display","none");
	$(".updateTxt").css("display","block");
	$("#dateBox").css("display","none");
	$("#dutyCnBox").css("display","none");
	$("#timeBox").css("display","none");
}// 수정버튼 눌렀을때 뒤로가기 누르면 버튼 사라지고 인풋박스 나오고하는 함수 끝


</script>
