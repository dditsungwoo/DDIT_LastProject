<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<div class="wf-main-container">
	<!-- =============== body 시작 =============== -->
	<!-- =============== 상단타이틀영역 시작 =============== -->
	<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
		<h1 class="page-tit">${vo.dutySj }</h1>
		<div class="wf-util">
			
			<button type="button" class="btn1 downloadFileBtn" idx="다운로드 올자리" style="height:40px;">
		    <i class="xi-attachment"></i>
		    </button>	                
			<button type="button" id="btnPrgs" class="btn4">진행률 수정</button>
			<input type='range' id='progressBar' min='1' max='10' step='1'  value="${vo.prgsRate }" style='width:70%; display:none;'/>
			<button type="button" id="btnPrgsConfirm" class="btn3" style="display:none;">수정</button>
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
				<li><label>발신자</label>
					<div>
						<p>${vo.sender } ${vo.position }</p>
					</div></li>
				<li><label>발신일자</label>
					<div>
						<p>${vo.sendDate }</p>
					</div></li>
				<li><label>마감일자</label>
					<div>
						<p>${vo.closDate }</p>
					</div></li>
				<li><label>진행률</label>
					<div>
						<p id="prgsRate">${(vo.prgsRate*10) }%</p>
					</div></li>
				<li><label>마감시간</label>
					<div>
						<p>${vo.closTime }</p>
					</div></li>
				
				<li><label>업무 상세 내용</label>
					<div>
						<p>${vo.dutyCn }</p>
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
console.log("_storage"+_storage);
let afNo= "${vo.atchmnflNo }";
afNo = "${vo.atchmnflNo}".substring(1);
console.log("afNo"+afNo);
$(()=>{
	let $prgsRate=$("#prgsRate");
    let $progressBar= $("#progressBar");
    let dutyNo="${vo.dutyNo}";
    let SenderEmpNo="${vo.empNo}";
    let recipient="${vo.recipient}";
	
    
    
    $(document).on("click",".downloadFileBtn",function(){
    	console.log("afNo"+afNo);
    	if(afNo==''){
    		 Toast.fire({
    			  title: _msg.common.fileNotFoundAlert,
    			  icon: "error"
    			});
    		return;
    	}
    	downloadFile(afNo);
    });
    
    
	// 진행률 수정 버튼 클릭시 나타나는 함수-------------------------
	$("#btnPrgs").on("click",function(){
		$(this).css("display","none");
		$("#btnPrgsConfirm").css("display","block");
		$(".downloadFileBtn").css("display","none");
		$progressBar.css("display","block");
		let prgsRate=$progressBar.val();
		console.log("prgsRate",$progressBar);
		console.log("prgsRate",prgsRate);
		
	});// 진행률 수정 버튼 클릭시 나타나는 함수 끝--------------------
	

	
	
	//수정 확정 버튼 클릭시 나타나는 함수---------------------------
	$("#btnPrgsConfirm").on("click",function(){
		prgsRate=$progressBar.val();
		
		let data={
			"prgsRate":prgsRate,
			"empNo":recipient,
			"dutyNo":dutyNo
		};
		
		$.ajax({
			url:"/duty/detailPrgsUpdate",
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
		     			  title: _msg.common.updateSuccessAlert,
		     			  text: "",
		     			  icon: "success"
		     			});
					 prgsRate=(prgsRate*10)+"%";
					 $prgsRate.html(prgsRate);
					 $("#btnPrgs").css("display","block");
					 $("#btnPrgsConfirm").css("display","none");
					 $(".downloadFileBtn").css("display","block");
					 $progressBar.css("display","none");
				}
				
			}
			
		});	
		
	});//수정 확정 버튼 클릭시 나타나는 함수-----------------------
	
	
	
	
	
});//$function 끝 ------------------------------------------

function downloadFile(param) {
    // AWS S3 URL 설정
    const s3Url = _storage + param;
    console.log("s3Url",s3Url);
    //let url = idx.split("/img/")[1];
    // 버튼 클릭 시 파일 다운로드
    const a = document.createElement('a');
    a.href = s3Url;
    a.download = param; // 다운로드될 파일 이름
    
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
}


</script>
