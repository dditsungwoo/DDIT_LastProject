<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<link rel="stylesheet" href="/resources/css/project/detail.css" />
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">  
<!-- <script src="/resources/script/project/detail.js"></script> -->



<!-- =============== body 시작 =============== -->
<!-- =============== 상단타이틀영역 시작 =============== -->
<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
	<h1 class="page-tit draggable" id="prjctTitle" data-project-title="${prjctNo}"></h1>
	<div id="endBtnDiv"></div>
	<div id="getEmployeePicture" data-emp-no=""></div>
</div>
<!-- =============== 상단타이틀영역 끝 =============== -->
<!-- =============== 컨텐츠 영역 시작 =============== -->
<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
	<div class="tab-type tab-type1" style="float: right;">
		<div class="side-util" >
		<div class="tab-menu" >
			<button data-tab="tab1" type="button" class="tab-btn active" id="toKanban">칸반 차트</button>
			<button data-tab="tab2" type="button" class="tab-btn" id="toGantt">간트 차트</button>		
			<div class="tab-indicator"
				style="width: 140px; transform: translateX(0px);"></div>
		</div>

		<!-- tab1  -->
		<div data-tab="tab1" class="tab-content active">
			<ul class="tab-board-lst">
			</ul>
		</div>

		<!-- tab2  -->
		<div data-tab="tab2" class="tab-content">
			<ul class="tab-board-lst">
			</ul>
		</div>
	</div>
	</div>
	<!-- 상단영역 시작 -->
	<div id ="e7eGantt"></div>
	<div class="wf-content-area box3" style="height: 930px;">
		<div class='progressbg'  >
		<div class="wf-flex-box wf-content-box progressBar">
			<p class="progressPercent">0%</p>
		</div>
		</div >
		<div class="wf-flex-box">
			<div class="wf-content-box boxes droppable" id="readyBox">
				<i class="xi-mail xi-2x"></i>
				<i style="position: absolute; top: 15px; right: 15px;" class="xi-plus xi-3x addDuty"></i>
				<p class="heading1">대기</p>

			</div>
			<div class="wf-content-box boxes droppable" id="ingBox">
				<i class="xi-play xi-2x"></i>				
				<p class="heading1">진행중</p>

			</div>

			<div class="wf-content-box boxes droppable" id="doneBox">
				<i class="xi-check xi-2x"></i>
				<p class="heading1">완료</p>

				<ul class="wf-list-style">
				</ul>
			</div>
		</div>
		<div class="wf-content-box droppable" id="deleteBox">
			<i class="xi-trash xi-2x"></i>
		</div>
	</div>

	<!-- 상단영역 끝 -->
	<!-- 하단영역 끝 -->
	
</div>
<!--============모달 영역 시작 =================  -->
<div class="modal" id="modal-project-duty" modal-id="modal-project-duty">
    <div class="modal-cont" >  
    	<div id="duty-modal-area"></div>      
    </div>
</div>
<!-- =============== 컨텐츠 영역 끝 =============== -->
<!-- =============== body 끝 =============== -->

<script>


let $boxes= $(".boxes");
let $readyBox= $("#readyBox");
let $deleteBox= $("#deleteBox");
let $ingBox= $("#ingBox");
let $doneBox= $("#doneBox");
let prjctNo= "${prjctNo}";
let data ={
		"prjctNo":prjctNo	
};
let str="";
let _prgRate={
	0:"대기중",
	1:"시작",
	2:"시작",
	3:"진행중",
	4:"진행중",
	5:"진행중",
	6:"진행중",
	7:"진행중",
	8:"진행중",
	9:"거의 완료",
	10:"완료"
}

$(()=>{
	
	let empNo= "<%=session.getAttribute("empNo")%>";
	
	var elements = document.getElementsByClassName('disabled');
	for (var i = 0; i < elements.length; i++) {
	    elements[i].addEventListener('click', function(event) {
	        event.preventDefault(); // 기본 클릭 동작을 막음
	        event.stopPropagation(); // 이벤트 버블링을 중지시킴
	        // 추가로 필요한 작업 수행 (예: 메시지 출력 등)
	    });
	}
		
		//모달창의 댓글수정하기 버튼을 누르면 나오는 함수
		$(document).on("click",".add-btn",function(){
			console.log("add-btn");
			let reno= $(this).data("reno");
			let $btn= $(this);
			let $replyCn= $btn.closest(".replyCn");
			$replyCn.find(".txt").css("display","none");
			$replyCn.find(".txtModify").css("display","block");

		});	//모달창의 댓글수정하기 버튼을 누르면 나오는 함수 끝
	
		
		//모달창의 댓글수정확정하기 버튼을 누르면 나오는 함수
		$(document).on("click",".btnReModifyCnfirm",function(){
			let reno= $(this).data("reno");
			let $btn= $(this);
			let $replyCn= $btn.closest(".replyCn");
			let reSj= $replyCn.find(".txtModify input").eq(0).val();
			console.log(reSj);
			console.log(reno);
			let data={
				"prjctDutyReNo":reno,
				"reSj":reSj
			};
			 $.ajax({
			        url: "/project/updateReply",
			        data: JSON.stringify(data),
			        contentType: "application/json;charset=utf-8",
			        type: "post",
			        beforeSend: function(xhr) {
			            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			        },
			        success: function(res){
			        	console.log(res);
			        	if(res>0){
			        		$replyCn.find(".txt").html(reSj);
			    			$replyCn.find(".txt").css("display","block");
			    			$replyCn.find(".txtModify").css("display","none");	
			        	}
			        }
			 });       
			
			
		});//모달창의 댓글수정확정하기 버튼을 누르면 나오는 함수 끝
		
		
	
		
		
		
		
		//모달창의 댓글지우기 버튼을 누르면 나오는 함수
		$(document).on("click",".del-btn",function(){
			let reno= $(this).data("reno");
			let $btn= $(this);
			let data={
				"prjctDutyReNo":reno	
			};
			 $.ajax({
			        url: "/project/deleteReply",
			        data: JSON.stringify(data),
			        contentType: "application/json;charset=utf-8",
			        type: "post",
			        beforeSend: function(xhr) {
			            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			        },
			        success: function(res){
			        	if(res>0){
			        		Toast.fire({
			          			  title: _msg.common.deleteSuccessAlert,
			          			  text: "",
			          			  icon: "success"
			          			});
			        		$btn.closest(".replyCn").remove();
			        	}
			        }
			 });

		});//모달창의 댓글지우기 버튼을 누르면 나오는 함수 끝-------
	
	
		//모달창의 댓글쓰기 버튼을 누르면 나오는 함수
		$(document).on("click","#insertReply",function(){
			let pdno=$(this).data("pdno");
			let reSj=$("#txtReply").val();
			
			let data={
				"prjctDutyNo":pdno,
				"reSj":reSj,
				"empNo":empNo
			};		    
		    $.ajax({
		        url: "/project/insertReply",
		        data: JSON.stringify(data),
		        contentType: "application/json;charset=utf-8",
		        type: "post",
		        beforeSend: function(xhr) {
		            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		        },
		        success: function(res){
		        	console.log(res);
					let writngDate= new Date(res.writngDate);
					writngDate = writngDate.toISOString().slice(0, 16).replace("T", " ");
					let position = res.position;
		            let rspnsblCtgryNm = res.rspnsbl;
		            if (rspnsblCtgryNm != "팀원") {
		           	 position = rspnsblCtgryNm;
		            }
		        	let str=
	                     `	<div class="replyCn">
	                        <div class="user-wrap">
	                            <span class="user-thumb">
	                                <img src="/resources/img/icon/\${res.proflImageUrl}" alt="예시이미지">
	                            </span>
	                            <div class="user-info">
	                                <span class="user-name">\${res.empNm} \${position}</span>
	                                <span class="user-date">\${writngDate}</span>
	                            </div>
	                            <div class="user-btn">
	                                <button type="button" class="add-btn" data-reno='\${res.prjctDutyReNo}'><i class="xi-pen"></i></button>
	                                <button type="button" class="del-btn" data-reno='\${res.prjctDutyReNo}'><i class="xi-trash"></i></button>
	                            </div>
	                        </div>
	                        <div class="txt">
	                            \${res.reSj}
	                        </div>
	                        	<div style="display:none;" class="txtModify">
	                        		<input type="text"  value="\${res.reSj}">
	                        		<button type='button' class='btn4 btnReModifyCnfirm' style='float:right; padding:1px; width:30px; height:20px; font-size:10px;' data-reno='\${res.prjctDutyReNo}'>수정</button>
	                        	</div>
	                        </div><br><br>                   
			        	`;
			        	var divReplyCn= $("#comment-area").find(".replyCn");
						if (divReplyCn.length > 2) {
							divReplyCn.last().remove();
						}			        
			        	console.log("ca",$("#comment-area").find(".replyCn").last());
			        	$("#comment-area").prepend(str);
			        	$("#txtReply").val("");
			        	
		        }
		    });
			
		})//모달창의 댓글쓰기 버튼을 누르면 나오는 함수 끝----
		
	
	
	
		//간트 페이지로 가는 함수
		$("#toGantt").on("click",function(){
			location.href="/project/gantt/"+prjctNo;
		});
			
		
		//하위 모달의 hover시에 데이터 나오는 함수 
		$(document).on("mouseenter", ".duties", function() {
	    var pThis = $(this).data("pdno");
	    console.log("hover 함수"+pThis);
	    var data = {
	        prjctDutyNo: pThis
	    };
	    
	    $.ajax({
	        url: "/project/getEmpImage",
	        data: JSON.stringify(data),
	        contentType: "application/json;charset=utf-8",
	        type: "post",
	        beforeSend: function(xhr) {
	            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
	        },
	        success: (res)=> {
	        	var imgSrc = '/resources/img/icon/' + res[0].atchmnflNo;
	            console.log("success empName",res[0]);
	            let position = res[0].position;
	            let rspnsbl = res[0].rspnsbl;
	            if (rspnsbl != "팀원") {
	                position = rspnsbl;
	            }
	            var empName = res[0].empNm;
	            var dayLeft = res[0].prjctEndDate;
	            console.log("success empName",res[0].empNm);
	            
	            var title = "<div class='img-wrap "+res[0].prjctDutyNo+" hovertool' >";
	            	title +=  "<img src='" + imgSrc + "' >" ;
	            	title +=  "<p>" + empName + " "+position+"</p>";
	            	title +=  "<p>마감까지 남은 일자 : " + dayLeft + "일</p>";
	            	title +=  "<input type='hidden' class='ihdnPdno' value='"+res[0].prjctDutyNo+"'/>";
	            	title += "</div>";	
	            	console.log("success 함수 안"+title);	
	            $(this).tooltip({
	                title: title,
	                html: true 
	            }).tooltip("show");
	        }
	    });
		}).on("mouseleave click drag", ".duties", function() {
	    $(this).tooltip("hide"); 
	    
	});
	$(document).on("click",".hovertool",function(){
		  console.log("hovertool pdno1",$(this));
		  
		  var pdno = $(this).attr("class").split(" ")[1];
		  console.log("hovertool pdno2",pdno);
		  getDutyModal(pdno);
		   $(".modal")
	        .removeClass("open")
	        .addClass("open");
	});
			
		
		//리더 바꾸기로 변경
		$(document).on("click",".detailPicture",function(){
			let empName= $(this).find("p:eq(0)").html();
			let rspnsbl= $(this).find("p:eq(1)").html();
			let rspnsblCd= "<%=session.getAttribute("rspnsblCtgryNm") %>";
			if(rspnsblCd=='팀원'){return;}
			
			console.log("this",this);
     		Swal.fire({
    			  title:"리더를 "+empName+" "+rspnsbl+"으로 바꾸시겠습니까?",
    			  text: "",
    			  //icon: "success"
    			}).then((result) => {
    		        if (result.isConfirmed) {
    		        	let empNo = $(this).data("empno");
    					let prjctNo="${prjctNo}";
    					var data = {
    					        prjctNo: prjctNo,
    					        empNo :empNo
    					    };
    					$.ajax({
    				        url: "/project/updateLeader",
    				        data: JSON.stringify(data),
    				        contentType: "application/json;charset=utf-8",
    				        type: "post",
    				        beforeSend: function(xhr) {
    				            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
    				        },
    				        success: (res)=> { 
    				        	if(res>0){
    				      			location.reload();
    				        		Toast.fire({
    				      			  title:"리더가 변경됐습니다!",
    				      			  text: "",
    				      			  icon: "success"
    				      			}) 
    				      			//$(".detailPicture").css("border", "");
    				      		    //$(".detailPicture[data-empno='" + empNo + "']").css("border", "2px solid yellow");
    				    		    //console.log(".detailPicture[data-empno='" + empNo + "']");	
    				      			
    				        	}
    				        }
    					})       		           
    		        }
    		    });
	
		
		})
		
		
		
		//타이틀옆에  사진 호버시에 데이터 나오는 함수 
		$(document).on("mouseenter", ".detailPicture", function() {
	    var empNo = $(this).data("empno");
	 
	    var data = {
	        prjctNo: "${prjctNo}",
	        empNo :empNo
	    };
	    
	    $.ajax({
	        url: "/project/getOneEmployeePicture",
	        data: JSON.stringify(data),
	        contentType: "application/json;charset=utf-8",
	        type: "post",
	        beforeSend: function(xhr) {
	            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
	        },
	        success: (res)=> {
	        	var imgSrc = '/resources/img/icon/' + res[0].proflImageUrl;
	            console.log("success empName",res[0]);
	            var empName = res[0].text;	           
	            console.log("success empName",res[0].empNm);
	            
	            var title = "<div class='img-wrap' >";
	            	title +=  "<img src='" + imgSrc + "'>" ;
	            	title +=  "<p>" + empName + "</p>";	            
            
	            	title += "</div>";	
	            	console.log("success 함수 안"+title);	
	            $(this).tooltip({
	                title: title,
	                html: true 
	            }).tooltip("show");
	        }
	    });
		}).on("mouseleave click drag", ".duties", function() {
	    $(this).tooltip("hide"); 
	    
	    
	});
			
		
		
		
 
       
	//------- 모달창 내에서 수정 확정버튼을 눌렀을때 나오는 함수 -------------
	$(document).on("click","#btnModifyConfirm",function(){
		 let cempNo= $("#hdnEmpNo").html();
		 let cdetailCn=$("#mdetailCn").val();
		 let cprjctDutyNo=$("#mprjctDutyNo").data("dutyNo");
		 let cprgsRate= $("#progressBar").val();
		 let cdutySj=$("#mdutySj").val();
		 let uploadFile =$("#uploadFile").val();
		 //let cprjctEndDate=$("#mprjctEndDate").data("endDate");
		 let cprjctEndDate=$("#mprjctEndDate").val();
		 console.log("cempNo"+cempNo);
		 		
		 //$("#uploadForm").submit();
		//var formData = new FormData();

		/* formData.append('uploadFile', $('#uploadForm')[0].files[0]); 
		
		console.log("uploadFile"+formData);	
		console.log("uploadFile",formData);	 */
		
		 if (cempNo == "" || cprjctEndDate == "") {
			 Toast.fire({
     			  title: _msg.common.fillEmptyFieldsAlert,
     			  text: "",
     			  icon: "error"
     			});
			 return;
		 }
		 
			
		 let data={
			 "empNo":cempNo,
			 "prjctEndDate":cprjctEndDate,
			 "dutySj":cdutySj,
			 "detailCn":cdetailCn,
			 "prgsRate":(cprgsRate*10),
			 "prjctDutyNo":cprjctDutyNo,
			 "proflImageUrl": uploadFile.split('\\').pop()
		 };
	
		 
		 $.ajax({
			type : 'post',
        	data:JSON.stringify(data),
           	url: '/project/updateDuty',
            /* processData: false,
            contentType: false, */
            contentType:"application/json;",
		    dataType : 'json',
    		beforeSend:function(xhr){
    			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");  
    			},
    		success:function(res){
    			console.log("updateDuty : ",res);
    			if(res>0){
             		Swal.fire({
          			  title: _msg.common.insertSuccessAlert,
          			  text: "",
          			  //icon: "success"
          			}).then((result) => {
          		        if (result.isConfirmed) {
		             		location.reload();         		           
          		        }
          		    });
    			}
    		}	
    			
		 });
		 
	});//------- 모달창 내에서 수정 확정버튼을 눌렀을때 나오는 함수 끝 -------------
		
	
	
	// 모달창 내에서 자동완성버튼 눌렀을때 나오는 함수------------------------
	$(document).on("click","#btnAutoTyping",function(){
	
		
		 $("#hdnEmpNo").html("2019202");
		 $("#mempName").val("유선영");
	     $("#mdetailCn").val("엑셀을 사용한 다중 인서트 구현 요청");
	     $("#mprjctDutyNo").data("dutyNo");
	     $("#progressBar").val("0.5");
	     $("#mdutySj").val("로그인 페이지 구현");
	     $("#uploadFile").val("");
	     $("#mprjctEndDate").val("2024-04-19");
		
	});// 모달창 내에서 자동완성버튼 눌렀을때 나오는 함수 끝 ----------
	
			
	//-------모달 창 내에서 수정을 눌렀을때 나오는 함수--------------------
	$(document).on("click","#btnModify",function(){
		let mprjctDutyNo=$("#mprjctDutyNo").data("dutyNo");
		let mprgsRate= $("#mprgsRate").data("prgsRate");
		let mdetailCn=$("#mdetailCn").html();
		let mdutySj=$("#mdutySj").html();
		let mprjctEndDate=$("#mprjctEndDate").data("endDate");
		let mprjctBeginDate=$("#mprjctEndDate").data("beginDate");
		//let mempNo=$("#mempNo").html();
		let mempNo= $("#hdnEmpNo").val();
		let mempNm=$("#mempName").val();

		console.log("1 :"+mprjctDutyNo);
		console.log("2 :"+mprgsRate);
		console.log("3 :"+mdetailCn);
		console.log("4 :"+mdutySj);
		console.log("5 :"+mprjctEndDate);
		str="";
		str+="<span>프로젝트 명 수정&nbsp;&nbsp;</span><br><div class='wf-flex-fbox center' id='mprjctDutyNo'  data-duty-no='"+mprjctDutyNo+"'>";
		str+="<h1><input type='text' class='modal-tit' id ='mdutySj'  value='"+mdutySj+"'></input></h1>";		
		str+="<span>진행률 수정</span>";
		str+="<ul class='wf-insert-form' >";	
		str+="<input type='range' id='progressBar' min='0' max='0.9' step='0.1'  value='"+mprgsRate+"' style='width:40%;'>";
		str+="</div>";
		str+="<div class='modal-content-area'>";
		str+="<div class='wf-grid-box'>";
		str+="<ul class='wf-insert-form2 vertical detail'>";
		str+="<li>";
		str+="<div class='wf-work-detail-info'>";
		str+="<div class='wf-worker'>";
		str+="<span>수행인 수정&nbsp;</span>";
		str+="<input type='text' class='txt autocomplete' id='mempName'  value='"+mempNo+"' required/>";
		str+="</div>";
		str+="</div>";
		str+="<br><br><span>종료일  수정&nbsp;</span>";
		str+="<input type='date' class='date' id='mprjctEndDate'  data-end-date='"+mprjctEndDate+"' data-begin-date='"+mprjctBeginDate+"' ></div>";
		str+="</li><br><br>";
		//str+="<li>";
		str+="<span>내용 수정&nbsp;&nbsp;</span><div class='wf-work-detail-cont'>";
		str+="<textarea id='mdetailCn' >"+mdetailCn+"</textarea>";
		str+="</div>";
		//str+="</li>";
		str+="</ul>";
		str+="</div>";
		str+="<div class='modal-btn-wrap'>";
		//str+="<form id='uploadForm' enctype='multipart/form-data' action='#' method='post'>";
		str+="<input type='file' id='uploadFile' name='uploadFile' style='display: none;' multiple>";
		str+="<label for='uploadFile' class='btn5'><i class='xi-attachment'></i>업로드</label>"
		str+="<button class='btn2' id ='btnModifyConfirm'>수정</button>";
		//str+="<sec:csrfInput />";
		//str+="</form>";		
		str+="</ul>";
		str+="<button class='btn5' id='btnAutoTyping'>자동완성</button>";
		str+="</div>";
		str+="<button class='close-btn'></button>";
		str+="<div id='hdnEmpNo'style='display:none;' value='"+mempNo+"'></div>";
		str+="</div>";
		$("#duty-modal-area").html(str);
		
		//자동완성
		 $(".autocomplete").autocomplete({

		        source : function(request, response) {
		        	 console.log("auto1" ,this.element[0].value);
		             autoNm=this.element[0].value;
		             //console.log("auto2" ,autoNm);
		        	data={
		            	"empNm":autoNm
		            }
		            console.log("empNm",autoNm	);
		        	$.ajax({
		                type : 'post',
		                data: JSON.stringify(data),
		                url: '/project/findEmpByName',
		                contentType:"application/json",
		                dataType : 'json',
		    			beforeSend:function(xhr){
		    				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		    			},
		                success : function(data) {
		                    // 서버에서 json 데이터 response 후 목록 추가
		                    
		                    console.log("자동완성 : ",data);
		                    response(
		                        $.map(data, function(item) {
		                        	console.log("single page app",item.empNm.substr(0, item.empNm.indexOf('(')));
		                            	 
		                            return {
		                            	  label: item.empNm, 
		                                  value: item.empNm.substr(0, item.empNm.indexOf('(')),
		                                  empNo: item.empNo
		                            }
		                        })
		                    );
		                }
		            });
		        },
		        select : function(event, ui) {
		            console.log(ui);
		            console.log("ui.item.label ",ui.item.label);
		            console.log("ui.item.value ",ui.item.value);
		            $("#hdnEmpNo").html(ui.item.empNo);
		            console.log("empno발 위치"+ $("#hdnEmpNo").val());
		      
		        },
		        focus : function(event, ui) {
		        	
		            return false;
		        },
		    	open: function (event, ui) {
		    		console.log("open this" ,this);
		    		console.log("open ui" ,ui);
		    		console.log("open event" ,event);
		    		
		    	},
		        minLength : 1,
		        autoFocus : true,
		        classes : {
		            'ui-autocomplete': 'highlight'
		        },
		        delay : 500,
		        position : { my : 'right top', at : 'right bottom' },
		        close : function(event) {
		        	$("#ui-id-1").remove();
		            console.log(event);
		            
		        }
		    }); //자동완성 끝
		
			
	});//--------------모달 창 내에서 수정을 눌렀을때 나오는 함수 끝------------------


	
	// 프로젝트 하위 상세를 눌렀을때 함수
	$(document).on("click",".duties",function(){
		  pdno= $(".duties",this).prevObject.data("pdno");
		  //console.log("pdno는 ",$(".duties",this));
		  //console.log("pdno는 "+pdno);
		  getDutyModal(pdno);
		  $('.duties').click(modal);
	})

	$(document).on('click', '#modal-project-duty .close-btn', function(){{
        $(this).parents('.modal').removeClass('open');
	}});
	
	
	// 일감 생성 버튼을 눌렀을때 함수
	$(".addDuty").on("click",function(){
		let dutyNumber=$("#readyBox").find(".duties");
		if (dutyNumber.length >=6){
			Toast.fire({
    			  title: "한 곳에 6개이상 생성 불가능합니다!",
    			  text: "",
    			  icon: "error"
    			});
			return;
		}
		prjctNo= "${prjctNo}";
		data ={
			"prjctNo":prjctNo	
		};
		$.ajax({
			url:"/project/addDuty",
			data:JSON.stringify(data),
			contentType:"application/json;charset=utf-8",
			type:"post",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success: function(res){
				console.log("add ",res);
				location.reload();
				
			}
		})//ajax 끝
		
	});// 일감 생성 버튼 함수 끝


	//리스트를 보여주는 함수
	$.ajax({
		url:"/project/getProjectDuty",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success: function(res){
			console.log("getProjectDuty 리스트" ,res);
		/* 	if (res[0].progress=='4' ){
				Swal.fire({
		  			  title: "이미 완료된 프로젝트입니다!",
		  			  text: "",
		  			  icon: "error"
		  			}).then((result) => {
	    		        if (result.isConfirmed) {
							location.href="/project/projects";	    		        
	    		        }
	    		    })
			} */
			 res.forEach(function(item) {
			        var prgsRate = item.prgsRate;
			        var dutySj = item.dutySj;
			        
			        console.log("리스트" ,$readyBox);
			      	str="";
			        if (prgsRate === 0) {
			       		str +="<div class='wf-content-box duties draggable' data-pdno='"+item.prjctDutyNo+"'";
			       		str += " modal-id='modal-project-duty'>";
			      	    str +="<p class='box-heading1'>"+dutySj+"</p>";
			      	    str +="<ul class='wf-list-style'>";
			      	    str +="<li class='style1'>"+item.detailCn+"</li>";   
			      	    str +="</ul></div>";
			      	    $("#readyBox").append(str);
			      	    
			        } else if (prgsRate === 10 ) {
			       		str +="<div class='wf-content-box duties draggable' data-pdno='"+item.prjctDutyNo+"'";
			       		str += " modal-id='modal-project-duty'>";
			      	    str +="<p class='box-heading1'>"+dutySj+"</p>";
			      	    str +="<ul class='wf-list-style'>";
			      	    str +="<li class='style1'>"+item.detailCn+"</li>";   
			      	    str +="</ul></div>";
			      	    $("#doneBox").append(str);
			        } else {
			       		str +="<div class='wf-content-box duties draggable' data-pdno='"+item.prjctDutyNo+"'";
			       		str += " modal-id='modal-project-duty'>";
			      	    str +="<p class='box-heading1'>"+dutySj+"</p>";
			      	    str +="<ul class='wf-list-style'>";
			      	    str +="<li class='style1'>"+item.detailCn+"</li>";   
			      	    str +="</ul></div>";
			      	    $("#ingBox").append(str);
			        }
			        		
			        //임박한 날짜를 계산 
			        //var beginDate = new Date(item.prjctBeginDate);
			        var beginDate = new Date(item.prjctBeginDate);
			        var endDate = new Date(item.prjctEndDate);			     
			        var timeDiff = Math.abs(endDate.getTime() - beginDate.getTime());
			        var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24)); 
			        
			      if((diffDays)<3){
			    	  $(".duties[data-pdno='"+item.prjctDutyNo+"']").css("border", "1px solid #FFA07A");
			    	
			      }
			     
			
			 })
		$('.draggable').draggable();
		$("#prjctTitle").html(res[0].text+" (종료일 : "+res[0].endDate+")");		
		},
		error :function(xhr){
			console.log("에러" +xhr.status);
		}
	})// 리스트를 보여주는 함수 끝
	
	//타이틀 옆에 프로필 사진 보여주는 함수
	$.ajax({
		url:"/project/getEmployeePicture",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success: function(res){
			console.log("상단 사진",res);
			let str="";
			str +=`<div class="wf-worker">			
				     <div class="img-lst">`;				
			res.forEach(function(vo) {	
		      str+= `<div class="img-wrap detailPicture" data-empno="\${vo.empNo}">
		                <img src="/resources/img/icon/\${vo.proflImageUrl}">
		            	<p style='display:none;'> \${vo.empNm}</p>            
		            	<p style='display:none;'> \${vo.rspnsbl}</p>	
		            </div>`;
		            if (vo.open == '리더') {
		            	leaderNo=vo.empNo;
		        	}
				 })					
		     str +=`</div>
	        </div>`;
	        $("#getEmployeePicture").html(str);
		    $(".detailPicture[data-empno='" + leaderNo + "']").css("border", "2px solid yellow");
		    console.log(".detailPicture[data-empno='" + leaderNo + "']");
		    //getOneEmployeePicture(leaderNo);
		}
		
	});//타이틀 옆에 프로필 사진 보여주는 함수 끝

	
	
	
	
	
	//드래그 한 일감들이 놓였을때 함수
	$('.droppable').droppable({ 
		drop: function(event,ui){
			var id = $(this).attr('id');
			let pdno= ui.draggable.data("pdno");
			
			let base=$(".droppable",this).prevObject;
			console.log("여기",$(".droppable",this));
			console.log("$('.droppable',this).prevObject : ",base);
			
			console.log("ui.draggable: ",ui.draggable);
			let target=$(ui.draggable);
			if (id == 'readyBox') {
				 updateProgress(pdno,0);
				
		   	} else if (id == 'ingBox') {       
	   			updateProgress(pdno,5);
	   			getStart();
		    } else if (id == 'doneBox') {
		    	updateProgress(pdno,10);
				
		    }else{
		    	let rspnsblCd= "<%=session.getAttribute("rspnsblCtgryNm") %>";
				if(rspnsblCd=='팀원'){return;}
		    	deleteDuties(pdno);
				target.remove();		    
		    }
		//this.append("",target);  
			getProgress();
			console.log("droppable 안에 진행도:"+$(".progressPercent").html());
		},
		out:function(event,ui){		
	
			//console.log("event",event);
			//console.log("ui",ui);
		}
	});
	
	getProgress();
	isProjectDone();
$(document).on("click","#endBtnBtn",function(){
	Swal.fire({
			  title: "프로젝트의 진행도가 100%입니다",
			  text: "프로젝트를 완료 하시겠습니까?"
			  //icon: "question"
			}).then((result) => {
		        if (result.isConfirmed) {
		        	doneProjectProgress(prjctNo);
		        }
		    });
})	
	
	
}) //$ function 끝

	//진행도를 계산하는 함수
let getProgress = function(){
	let prjctNo= "${prjctNo}";
	let data ={
			"prjctNo":prjctNo	
	};
	$.ajax({
		url:"/project/getProgress",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(res){
			console.log("진행도 : "+res);
			$(".progressBar").css("width",res+"%");
			$(".progressPercent").html(res+"%");
			if(res=='100'){
				let str='';
				str+=`<button type='button' class='btn2' id='endBtnBtn' style='left:80%; position: absolute; top:4%;'>프로젝트 완료</button>`;
				$("#endBtnDiv").html(str);
			}
		}
		
	})
}; //진행도를 계산하는 함수 끝

//각자의 진행률 업데이트 하는 함수
function updateProgress(pdno,prgsRate){
	
	console.log("일감 번호",pdno);
	data={
		"prjctDutyNo":pdno,
		"prgsRate": prgsRate
	};
	$.ajax({
		url:"/project/updateProgress",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(res){
			console.log("업데이트 완료 : "+res);
			
		}
		
	})
}; //진행도를 업데이트하는 함수 끝

	//일감을 삭제하는 함수
function deleteDuties(pdno){	
	console.log("일감 번호",pdno);
	data={
		"prjctDutyNo":pdno		
	};
	$.ajax({
		url:"/project/deleteDuties",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(res){
			console.log("삭제 완료 : "+res);
			Toast.fire({
    			  title: _msg.common.deleteSuccessAlert,
    			  text: "",
    			  icon: "error"
    			});
			getProgress();
			
		}
		
	})
}




//상세 모달창을 보여주는 함수
async function getDutyModal(pdno,currentPage){
 		$("#duty-modal-area").html();
 		let sessionEmpNo= "<%=session.getAttribute("empNo")%>";
		let data={
			"prjctDutyNo":pdno,
			"currentPage":currentPage
		};
	try {	
		
		let res=await $.ajax({
				url:"/project/getDutyModal",
				data:JSON.stringify(data),
				contentType:"application/json;charset=utf-8",
				type:"post",
				beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
				},
		});			
				console.log("resajax : ",res);
				console.log("resajax : ",res.empNo);				
				  let position = res.position;
                  let rspnsbl = res.rspnsbl;
                  if (rspnsbl != "팀원") {
                      position = rspnsbl;
                  }
                 
				var empName = res.empNm;
			
				var replyData = await getProjectDutyReply(res.prjctDutyNo,currentPage);
				
				
				console.log("empName"+empName);
				console.log("replyData",replyData);
			   	if (empName == null) {
				    empName = "담당자 필요";
				}
			  
				str="";
				str+="<div class='wf-content-wrap'>";
				str+="<div class='wf-flex-fbox center' id='mprjctDutyNo' data-duty-no='"+res.prjctDutyNo+"'>";
				str+="<span class='wf-badge1' id='mprgsRate'  data-prgs-rate='"+res.prgsRate+"'>"+_prgRate[res.prgsRate]+"</span>";
				str+="<h1 class='modal-tit' id ='mdutySj'>"+res.dutySj+"</h1>";
				str+="<div class='img-wrap' style='float:center;' >";
				
				
				str+="<img src='/resources/img/"+res.atchmnflNo+"' style='height:200px; width:200px' >";
				str+="</div>";
				str+="</div>";
				str+="<div class='modal-content-area'>";
				str+="<div class='wf-grid-box'>";
				str+="<ul class='wf-insert-form2 vertical detail'>";
				str+="<li>";
				str+="<div class='wf-work-detail-info'>";
				str+="<div class='wf-worker'>";
				str+="<div class='img-lst'>";
				str+="<div class='img-wrap'>";
				str+="<img src='/resources/img/icon/"+res.proflImageUrl+"'>";
				str+="</div>";
				str+="<span class='txt' id='mempNo'  >"+empName+" "+position+"</span>";
				str+="</div>";
				str+="</div>";
				str+="<div class='date' id='mprjctEndDate' data-end-date='"+res.prjctEndDate+"' data-begin-date='"+res.prjctBeginDate+"'> "+res.prjctEndDate+" 일 까지</div>";
				str+="<div id='hdnEmpNo'style='display:none;' value='"+res.empNo+"'></div>";
				str+="</div>";
				str+="</li>";
				str+="<li>";
				str+="<div class='wf-work-detail-cont'>";
				str+="<p id='mdetailCn'>"+res.detailCn+"</p>";
				str+="</div>";
				str+="</li>";
				str+="</ul>";
				str+="<div class='comment-area' id='comment-area'>";
				
				str +="<ul>";
				if(replyData.startPage!= "0"){
			 	content= replyData.content;			
				content.forEach(function(vo) {
				let writngDate= new Date(vo.writngDate);
				writngDate = writngDate.toISOString().slice(0, 16).replace("T", " ");
			    let position = vo.position;
                let rspnsblCtgryNm = vo.rspnsbl;
                if (rspnsblCtgryNm != "팀원") {
                    position = rspnsblCtgryNm;
                }

				str +="<li>";
				str +="<div class='replyCn'>";
				str +="<div class='user-wrap'>";
				str +="<span class='user-thumb'>";
				str +="<img src='/resources/img/icon/"+vo.proflImageUrl+"' alt='예시이미지'>";
				str +="</span>";
				str +="<div class='user-info'>";
				str +="<span class='user-name'>"+vo.empNm+" "+position+"</span>";
				str +="<span class='user-date'> "+writngDate+"</span>";
				str +="</div>";
				if(sessionEmpNo==vo.empNo){
				str +="<div class='user-btn'>";
				str +="<button type='button' class='add-btn' data-reno='"+vo.prjctDutyReNo+"'><i class='xi-pen'></i></button>";
				str +="<button type='button' class='del-btn' data-reno='"+vo.prjctDutyReNo+"'><i class='xi-trash'></i></button>";
				str +="</div>";
				}
				str +="</div>";
				str +="<div class='txt'>";
				str += vo.reSj;
				str +="</div>";
				str +="<div style='display:none;' class='txtModify'>";
				str +="<input type='text' value='"+vo.reSj+"'>";
				str += "<button type='button' class='btn4 btnReModifyCnfirm' style='float:right; padding:1px; width:30px; height:20px; font-size:10px;' data-reno='"+vo.prjctDutyReNo+"'>수정</button></br>";
				str +="</div>";
				str +="</div>";
				str +="</li>";	
				});
				str +="</ul>";
				str+="<div class='input-wrap'>";
			    str+="<input type='text' id='txtReply' placeholder='댓글을 입력하세요'>";
                str+="<button class='btn4' id='insertReply' data-pdno='"+res.prjctDutyNo+"'>등록</button>";
				str+="</div>";
				str +=replyData.pagingArea;
				}else{
				str+="<div class='input-wrap'>";
			    str+="<input type='text' id='txtReply' placeholder='댓글을 입력하세요'>";
                str+="<button class='btn4' id='insertReply' data-pdno='"+res.prjctDutyNo+"'>등록</button>";
				str+="</div>";					
				}
				str+="</div>";
				str+="</div>";
				str+="</div>";
				str+="<div class='modal-btn-wrap'>";
				str+="<button class='btn4' id ='btnModify'>수정</button>";
			
				str+="</div>";
				str+="<button class='close-btn'></button>";
				str+="</div>";
				str+="</div>";
				
				
				$("#duty-modal-area").html(str);
		} catch (error) {
	        console.error("Error:", error);
	    }
 
	};//상세 모달창을 보여주는 함수 끝

// 사원번호로 이름을 가져오는 함수
 function getNameByEmpNo(empno) {
    let data = {
        "empNo": empno
    };
    try {
        	response =  $.ajax({
            url: "/project/getNameByEmpNo",
            data: JSON.stringify(data),
            contentType: "application/json;charset=utf-8",
            type: "post",
            beforeSend: function (xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            }
        });
        console.log(response.empNm);
        return response.empNm;
    } catch (error) {
        console.error("Error:", error);
        return null; // 예외 발생 시에는 null을 반환하거나 다른 처리를 할 수 있습니다.
    }
}// 사원번호로 이름을 가져오는 함수 끝


//프로젝트의 진행률이 100프로일때 프로젝트를 완료해주는 함수
function doneProjectProgress(prjctNo){
	let data ={
		"prjctNo":prjctNo
	}
	$.ajax({
		url:"/project/doneProjectProgress",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success: function(res){
			Toast.fire({
  			  title: "프로젝트가 완료 되었습니다!",
  			  text: "",
  			  icon: "success"
  			});
			$('.draggable').draggable('destroy');
			$("#endBtnDiv").html('');
			$(".box3 .wf-content-box").css("background-color","rgb(0,0,0,0.1)");
		}
	});
}//프로젝트의 진행률이 100프로일때 프로젝트를 완료해주는 함수 끝


//모달 창 안에 댓글을 보여주는 함수
async function getProjectDutyReply(prjctDutyNo, currentPage) {
    return new Promise((resolve, reject) => {
        let data = {
            "prjctDutyNo": prjctDutyNo,
            "currentPage": currentPage
        };
        $.ajax({
            url: "/project/getProjectDutyReply",
            data: JSON.stringify(data),
            contentType: "application/json;charset=utf-8",
            type: "post",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(res) {
                console.log(res);               
                resolve(res); // 비동기 호출 성공 시 결과를 resolve로 반환
            },
            error: function(xhr, status, error) {
                reject(error); // 비동기 호출 실패 시 에러를 reject로 반환
            }
        });
    });
}//모달 창 안에 댓글을 보여주는 함수 끝


//진행도가 0에서 넘어갔으면 진행중으로 상태를 바꿔주는 함수
function getStart(){
	let prjctNo= "${prjctNo}";
	let data={
		"prjctNo":prjctNo	
	};
	$.ajax({
		url: "/project/getStart",
        data: JSON.stringify(data),
        contentType: "application/json;charset=utf-8",
        type: "post",
        beforeSend: function(xhr) {
            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
        },
        success: function(res) {
        	cosole.log("getStart "+res);
        }
	});
}
//진행도가 0에서 넘어갔으면 진행중으로 상태를 바꿔주는 함수 끝


//첫화면에서 프로젝트가 완료되었으면  
function isProjectDone(){
	let prjctNo= "${prjctNo}";
	let data={
			"prjctNo":prjctNo	
		};
		$.ajax({
			url: "/project/isProjectDone",
	        data: JSON.stringify(data),
	        contentType: "application/json;charset=utf-8",
	        type: "post",
	        beforeSend: function(xhr) {
	            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	        },
	        success: function(res) {
	        	console.log("isProjectDone ",res);
	        	if(res=='' || res==null){
	        		return;
	        	}else if(res.total=='100' && res.prjctSttusCd=='4'){
	    		$('.draggable').draggable('destroy');
				$("#endBtnDiv").html('');
				$(".box3 .wf-content-box").css("background-color","rgb(0,0,0,0.1)");
				$(".addDuty").css("display","none");
				$("#prjctTitle").css("text-decoration","line-through");
	        	}
	        }
		});
}
		
	  

		




	

</script>
