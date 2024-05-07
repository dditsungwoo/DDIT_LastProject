<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style>
.drop-zone {
	width: 100%;
	height: 70px;
	background-color: azure
}

.drop-zone-dragenter, .drop-zone-dragover {
	border: 10px solid blue;
}
</style>
<script>
function emailCreate(){
    window.location.href = 'create';
}
function emailSendbox(){
    window.location.href = 'sendbox';
}
function emailAttachbox(){
    window.location.href = 'attachbox';
}
function emailDeletebox(){
    window.location.href = 'deletebox';
}
function emailUnreadbox(){
    window.location.href = 'unreadbox';
}
function emailMain(){
    window.location.href = 'main';
}
function emailTemporary(){
    window.location.href = 'temporarybox';
}

</script>
<!-- =============== 상단타이틀영역 시작 =============== -->
<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
	<h1 class="page-tit">메일</h1>

	<div class="side-util"></div>
</div>
<!-- =============== 상단타이틀영역 끝 =============== -->
<!-- 왼쪽파트 없애고, <div class="wf-mail-right">태그 부분만 남겨놓기  -->
<div class="wf-mail-wrap">
	<!-- 메일 왼쪽 파트 -->
	<div class="wf-content-area wf-mail-left" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
		<button type="button" class="btn2 mail-btn" onclick="emailCreate()">메일쓰기</button>
		<div class="wf-mail-top">
			<button type="button" onclick="emailUnreadbox()">
				<span class="data">${noreadCount}</span>안읽음
			</button>
			<button type="button" onclick="emailAttachbox()">
				<i class="xi-attachment"></i>첨부
			</button>
		</div>

		<div class="wf-mail-menu">
			<button type="button" class="getmailbtn1" onclick="emailMain()">
				<i class="xi-mail-read-o"></i> 받은메일함 ${getCount}
			</button>
			<button type="button" class="getmailbtn2" onclick="emailSendbox()">
				<i class="xi-share"></i> 보낸메일함 ${sendCount}
			</button>
			<button type="button" class="getmailbtn3" onclick="emailTemporary()">
				<i class="xi-folder-o"></i> 임시보관함 ${tempCount}
			</button>
			<button type="button" class="getmailbtn4" onclick="emailDeletebox()">
				<i class="xi-trash-o"></i> 휴지통 ${deleteCount}
			</button>
		</div>
	</div>

	<!-- 메일 오른쪽 파트 -->
	<div class="wf-mail-right" data-aos="fade-right" data-aos-duration="700" data-aos-delay="400">

		<!-- =============== 상단타이틀영역 끝 =============== -->
		<!-- =============== 컨텐츠 영역 시작 =============== -->
		<div class="wf-content-wrap">

			<div class="wf-content-area form">
				<form method="post" enctype="multipart/form-data">
					<div class="wf-tit-wrap">
						<h1 class="modal-tit">메일쓰기</h1>
						<div class="side-util" style="justify-content: right;">
							<button type="submit"
								formaction="/mail/createMail?${_csrf.parameterName}=${_csrf.token}"
								class="btn2" id="submitBtn">보내기</button>
							<button type="submit"
								formaction="/mail/temporaryMail?${_csrf.parameterName}=${_csrf.token}"
								class="btn2" id="temporaryBtn">임시저장</button>
						</div>
					</div>
					<ul class="wf-insert-form3">
						<li>
							<div class="wf-insert-tit" id="senderPlus">
								<label for="inputField">받는사람</label> 
								<input type="text"
									id="inputField" class="autocomplete teams"
									placeholder="받는 사람을 입력해주세요" />
								<i class="xi-plus xi-2x" id="addButton"></i></div></li>
								<li>
								<div id="recipientList">
								<span class="wf-badge2">
								<div class="dynamic-div" data-empno="${reEmpVO.empNo}">${reEmpVO.email}(${reEmpNo})<button type="button" class="del-btn empDelete"><i class="xi-close"></i></button></div>
								</span>
								</div>
								</li>
								<div id="hdnField" style='display: none;'></div>
								<input type="hidden" name="emailRVOList" id="emailRVOList"
									value="">

							
						<li>
							<div class="wf-insert-tit">
								<label>제목</label> <input type="text" name="emailSj" value="RE : ${reTitle}"
									placeholder="제목을 입력해주세요">

							</div>
						</li>
						<li>
							<div class="wf-insert-tit">
								<label>파일첨부</label> <input type="file" name="multipartFile"
									id="atchmnflNo" multiple />

							</div>
						</li>
						<div class="wf-content-area drop-zone">또는 파일을 여기로 드래그하세요.</div>
						<li><textarea name="emailCn" class="editor"
								placeholder="Editing with Markdown output"><br><br>========================이전 내용=========================${reCont}</textarea></li>
					</ul>
					<sec:csrfInput />
				</form>
			</div>

		</div>
	</div>
	<!-- 메일 오른쪽 파트 끝 -->
</div>

<script>
$(()=>{
	
// var firstRecipient = `<span class="wf-badge2"><div class='dynamic-div' data-empno='\${reEmpVO.empNo}'>\${reEmpVO.email}(${reEmpNo})<button type="button" class="del-btn empDelete"><i class="xi-close"></i></button></div></span>`;	
// 	$("#recipientList").append(firstRecipient);
	
$(document).on("focus", ".teams", function(e) {
	if (!$(this).hasClass("ui-autocomplete")) {   
$(this).autocomplete({

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
        url: '/menu/selectEmail',
        contentType:"application/json",
        dataType : 'json',
        success : function(data) {
            // 서버에서 json 데이터 response 후 목록 추가
            console.log("자동완성 : ",data);
            response(
                $.map(data, function(item) {
                	console.log("single page app",item.empNm.substr(0, item.empNm.indexOf('(')));
                    	 
                    return {
                    	  label: item.empNm, 
                          value: item.email+'('+item.empNm+')',
                          empNo: item.empNo
                    }
                })
            );
        }
    });
},
select : function(event, ui) {

    console.log("teams시 :",this);
	
    $(this).val(ui.item.empNo);
    $(this).data("empno",ui.item.empNo);
    $("#hdnField").append(ui.item.empNo);
    console.log("select시 :", $(this).val());

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
    console.log(event);
    
}
});
}// autocomplete 끝
});  
});

$(function(){
	// '등록' 버튼 클릭 시
    $("#submitBtn").click(function(event){
        // 필수 입력 필드의 값을 가져옴
        var empnoList = $("#recipientList").find("[data-empno]").map(function() {
    	return $(this).data("empno");
   		}).get();

		console.log(empnoList);
		$("#emailRVOList").val(empnoList);
        var recipientListValue = $("#emailRVOList").val();
        
        var subjectValue = $("input[name='emailSj']").val();

        // 필수 입력 필드의 값이 비어 있는지 확인
        if (recipientListValue === "" || subjectValue === "") {
            // 필수 입력 필드 중 하나라도 비어 있다면 경고 메시지를 출력하고 등록을 중지
            alert("수신자와 제목은 필수 입력 사항입니다.");
            event.preventDefault(); // 등록 중지
        } else {
            // 필수 입력 필드에 값이 모두 입력되어 있다면 등록을 계속 진행
            // 이 경우에는 별도의 처리가 필요 없음
        }
    });
	
    
});   

//엔터 키 입력 처리
$("#inputField").keypress(function(event){
    if(event.which === 13) { // Enter 키의 keyCode 값은 13입니다.
        addRecipient();
    }
});

$("input").not("#inputField").keypress(function(event){
    if(event.which === 13) { // Enter 키의 keyCode 값은 13입니다.
        event.preventDefault(); // 기본 동작을 막습니다.
    }
});

$(document).on("click", ".empDelete", function (){
	let $dynamicDiv = $(this).closest(".dynamic-div");
	let recipientList = $("#recipientList");
	
	$dynamicDiv.closest(".wf-badge2").remove();
	
	recipientList.find(".total-recipients").remove();
	let updatedRecipients = $(".wf-badge2").length;
	if(updatedRecipients==0){
		return;
	}else{
	recipientList.append(`<div class='total-recipients'>총 \${updatedRecipients}명</div>`);
	}
	
});

// 버튼 클릭 처리
$("#addButton").click(function(){
    addRecipient();
});	

function addRecipient() {
    var inputText = $("#inputField").val();
    var inputEmpNo = $("#inputField").data("empno");
    console.log("inputEmpNo"+inputEmpNo);
    var recipientList = $("#recipientList");
    var newRecipient = `<span class="wf-badge2"><div class='dynamic-div' data-empno='\${inputEmpNo}'>\${inputText}<button type="button" class="del-btn empDelete"><i class="xi-close"></i></button></div></span>`;

   	recipientList.append(newRecipient);

    recipientList.find(".total-recipients").remove();
    
    let updatedRecipients = $(".wf-badge2").length;
    
    recipientList.append(`<div class='total-recipients'>총 \${updatedRecipients}명</div>`);
    
    // 입력 필드의 값을 비움
    $("#inputField").val("");
    
    // 추가된 수신자를 hidden 입력란에 추가
    var emailRVOList = $("#emailRVOList");
    var currentValue = emailRVOList.val(); // 현재 hidden 입력란의 값 가져오기
    if (currentValue.length > 0) {
        currentValue += ","; // 값 사이에 쉼표 추가
    }
    emailRVOList.val(currentValue + inputText); // 새로운 값 추가
    
    // 입력 필드의 너비를 동적으로 조정
    adjustInputFieldWidth();
}

//입력 필드의 너비를 조정하는 함수
function adjustInputFieldWidth() {
 var totalWidth = $("#senderPlus").width(); // 컨테이너의 총 너비
 var buttonWidth = $("#addButton").outerWidth(); // 버튼의 너비
 var spaceBetween = 10; // 요소 사이 간격
}


</script>
<script>
$(function() {
    
    var $file = document.getElementById("atchmnflNo")
    var dropZone = document.querySelector(".drop-zone")

    var toggleClass = function(className) {
        
        console.log("current event: " + className)

        var list = ["dragenter", "dragleave", "dragover", "drop"]

        for (var i = 0; i < list.length; i++) {
            if (className === list[i]) {
                dropZone.classList.add("drop-zone-" + list[i])
            } else {
                dropZone.classList.remove("drop-zone-" + list[i])
            }
        }
    }
    
    var showFiles = function(files) {
        dropZone.innerHTML = "<ul>"
        for(var i = 0, len = files.length; i < len; i++) {
            dropZone.innerHTML += "<li>" + files[i].name + ", </li>"
        }
        dropZone.innerHTML += "</ul>"
        
    }

    var selectFile = function(files) {
        // input file 영역에 드랍된 파일들로 대체
        $file.files = files
        showFiles($file.files)
        
    }
    
    $file.addEventListener("change", function(e) {
        showFiles(e.target.files)
    })

    // 드래그한 파일이 최초로 진입했을 때
    dropZone.addEventListener("dragenter", function(e) {
        e.stopPropagation()
        e.preventDefault()

        toggleClass("dragenter")

    })

    // 드래그한 파일이 dropZone 영역을 벗어났을 때
    dropZone.addEventListener("dragleave", function(e) {
        e.stopPropagation()
        e.preventDefault()

        toggleClass("dragleave")

    })

    // 드래그한 파일이 dropZone 영역에 머물러 있을 때
    dropZone.addEventListener("dragover", function(e) {
        e.stopPropagation()
        e.preventDefault()

        toggleClass("dragover")

    })

    // 드래그한 파일이 드랍되었을 때
    dropZone.addEventListener("drop", function(e) {
        e.preventDefault()

        toggleClass("drop")

        var files = e.dataTransfer && e.dataTransfer.files
        console.log(files)

        if (files != null) {
            if (files.length < 1) {
                alert("폴더 업로드 불가")
                return
            }
            selectFile(files)
        } else {
            alert("ERROR")
        }

    });

})();
</script>