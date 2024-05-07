<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
.wf-main-container{
	width: 100%;
}
.wf-chat-left{
	height: 100%;
	min-height: auto;
	width: 35%;
}
.wf-chat-body{
	height: 100%;
	min-height: auto;
	width: 100%;
}
.wf-mail-right{
	height: 100%;
	min-height: auto;
	width: 65%;
}
.wf-mail-wrap{
	height: 100%;
	width: 100%;
}
.wf-content-area{
	height: 100%;
}
.chat-content{
	height: 80%;
	overflow: scroll;
}
.comment-area{
	padding: 10px 0px 10px;
}
.wf-chat-body .comment-area{
	padding: 10px 0px 10px;
}
#modal-test{
	width: 200px;
    height: 150px;
    background-color: #ffffff;
    border: 1px solid #ccc;
    position: fixed;
    bottom: 10px;
    right: 10px;
    z-index: 1000;
}
</style>
<script>
let realSize = window.innerWidth;
let realHeight = window.innerHeight;
let empNo = <%=session.getAttribute("empNo")%> + "";
let empNm = "";
let chatRoomNo = "0";
/* let empNo = ${empNo} + ""; */
let chatAddOrInvite = "";	// 모달창 타겟이 기존 채팅방에 초대인지 새로운 채팅방 생성인지 구분
let chatRoomEmpList = [];
let chatRoomEmpListTemp = []; // 일단 임시저장해뒀다가 필요할때 chatRoomEmpList로 덮어씌우기용도

// 현재 날짜와 시간을 가져오기
let currentDate = new Date();

// 월과 일이 한 자리 숫자인 경우 앞에 0을 추가하여 두 자리로 표시
let month = ('0' + (currentDate.getMonth() + 1)).slice(-2);
let day = ('0' + currentDate.getDate()).slice(-2);

// 시간이 한 자리 숫자인 경우 앞에 0을 추가하여 두 자리로 표시
let hours = ('0' + currentDate.getHours()).slice(-2);
let minutes = ('0' + currentDate.getMinutes()).slice(-2);

// yyyy-MM-dd hh:mm 형식으로 날짜와 시간을 표시
let formattedDateTime = currentDate.getFullYear() + '-' + month + '-' + day + ' ' + hours + ':' + minutes;

$("body").css("width",realSize)
window.addEventListener("resize", function() {
	realSize = window.innerWidth;
	realHeight = window.innerHeight;
	$("body").css("width",realSize)
	$("body").css("height",realHeight)
})

$("header").html("")
$("header").css("height","0px")
$("aside").html("")
$("aside").css("width","0px")

$.ajax({
	url:"/chat/getEmp",
	data:{"empNo":empNo},
	type:"get",
	contentType:"application/x-www-form-urlencoded; charset=UTF-8",
	success:function(res){
		empNm = res.empNm
	}
})





$(function(){
	
	getChatRoomList()
	
	// 내 채팅방 리스트 불러오기
	function getChatRoomList(){
		$.ajax({
			url:"/chat/getChatRoom",
			data:{"empNo":empNo},
			type:"get",
			contentType:"application/x-www-form-urlencoded; charset=UTF-8",
			success:function(res){
				let str = "";
				str += `<div class="wf-chat-list">
						    <span class="txt">
					        <i class="xi-wechat"></i>
					        ALL MESSAGE
					    </span>`
				$.each(res,function(i,v){
					connect(v.chatRoomNo)
					str += `<div class="wf-chat-box myChatRoom" idx="\${v.chatRoomNo}">
								<div class="chat-img">
					            	<img src="/resources/img/icon/avatar.png">
						        </div>
						        <div class="chat-txt">
						            <p class="chat-name list-chat-name">\${v.chatRoomNm}</p>
						            <p class="chat-txt"></p>
						        </div>
						        <div class="chat-side">
						            <p class="chat-date"></p>
						            <span class="fw-alarm-badge" style="display:none">&nbsp;</span>
						        </div>
					        </div>`
				})
				
				str += `</div>`
				
				$(".wf-chat-list").html(str)
				$.each(res,function(i,v){
					// 마지막 채팅 불러오기
					$.ajax({
						url:"/chat/getChatRoomLastChat",
						data:{"chatRoomNo":v.chatRoomNo},
						type:"get",
						contentType:"application/x-www-form-urlencoded; charset=UTF-8",
						success:function(res){
							if(res.mssageCn){
								$(`.myChatRoom[idx=\${v.chatRoomNo}] .chat-date`).html(res.formatDate.split("_")[1])
								if(res.mssageCn.length > 8){
									$(`.myChatRoom[idx=\${v.chatRoomNo}] p[class=chat-txt]`).html(res.mssageCn.substr(0,8) + "...");
								}else{
									$(`.myChatRoom[idx=\${v.chatRoomNo}] p[class=chat-txt]`).html(res.mssageCn);
								}
							}
						}
					})
					
					// 안본 메세지 수 불러오기
					$.ajax({
						url:"/chat/getOverMsgCount",
						data:{
							"chatRoomNo":v.chatRoomNo,
							"empNo":empNo
						},
						contentType:"application/x-www-form-urlencoded; charset=UTF-8",
						type:"get",
						success:function(res){
								$(`.myChatRoom[idx=\${v.chatRoomNo}] .fw-alarm-badge`).css("display","block");
							if(res == 0){
								$(`.myChatRoom[idx=\${v.chatRoomNo}] .fw-alarm-badge`).css("background","#53a336");
								$(`.myChatRoom[idx=\${v.chatRoomNo}] .fw-alarm-badge`).html("");
							}else{
								$(`.myChatRoom[idx=\${v.chatRoomNo}] .fw-alarm-badge`).html(res);
							}
							
							if(v.chatRoomNo == chatRoomNo){
								$(`.myChatRoom[idx=\${v.chatRoomNo}] .fw-alarm-badge`).css("background","#53a336");
								$(`.myChatRoom[idx=\${v.chatRoomNo}] .fw-alarm-badge`).html("");
							}
							
						}
					})
					
					if(v.chatRoomNo == chatRoomNo){
						$.ajax({
							url:"/chat/modChatEmpDate",
							data:JSON.stringify({
								"chatRoomNo":chatRoomNo,
								"empNo":empNo,
							}),
							type:"put",
							contentType:"application/json",
							success:function(res){
								$(`.myChatRoom[idx=\${chatRoomNo}] .fw-alarm-badge`).css("background","#53a336");
								$(`.myChatRoom[idx=\${chatRoomNo}] .fw-alarm-badge`).html("");
							}
						})
					}
					
					
				})
				
				
				
				
			}
		})
	}
	

	
function getChat(){
	$.ajax({
		url:"/chat/getChat",
		data:{
			"chatRoomNo":chatRoomNo,
			"empNo":empNo
		},
		contentType:"application/x-www-form-urlencoded; charset=UTF-8",
		type:"get",
		success:function(res){
			console.log(res)
			console.log("chatRoomNo:",chatRoomNo)
			let str = "";
			$.each(res,function(i,v){
				if(v.mssageCn.substr(-7,7) == "접속했습니다." || v.mssageCn.substr(-7,7) == "종료했습니다."){
					str += `<div style="text-align:center">\${v.mssageCn.substr(0,v.mssageCn.length)}</div>`;
					return;
				}
				
				if(v.empNo == empNo){
					str += `<div class="user mine">
							    <div class="chat-user-info">
							        <div class="chat-img">
							            <img src="/resources/img/icon/avatar.png">
							        </div>
							        <p class="chat-name emp-chat-name">\${v.empNm}</p>
							        <p class="chat-date">\${v.formatDate}</p>
							    </div>
							    <div class="chat-txt">
							        \${v.mssageCn}
							    </div>
							</div>`
				}else{
					str += `<div class="user you">
					    <div class="chat-user-info">
					        <div class="chat-img">
					            <img src="/resources/img/icon/avatar.png">
					        </div>
					        <p class="chat-name emp-chat-name">\${v.empNm}</p>
					        <p class="chat-date">\${v.formatDate}</p>
					    </div>
					    <div class="chat-txt">
					        \${v.mssageCn}
					    </div>
					</div>`
				}
				
			})
			
			c_chatWin.innerHTML = str;
			
			c_chatWin.scrollTop = c_chatWin.scrollHeight;
			
		}
	})
}
	// 채팅방 리스트 클릭 시의 기능
	$(document).on("click",".myChatRoom",function(){
		c_chatWin.innerHTML = "";
		chatRoomNo = $(this).attr("idx")
		let chatName = $(".list-chat-name", this).html();
		
		// 채팅위쪽 이름 변경
		$(".chatRoom-chat-name").html(chatName);
		// 채팅방 편집 모달 이름
		$("#modal-chat-modify .modal-tit").html(chatName)
		
		// 채팅방 리스트 클릭시 옆에 채팅방 화면 띄우기
		getChat();
		
		$.ajax({
			url:"/chat/modChatEmpDate",
			data:JSON.stringify({
				"chatRoomNo":chatRoomNo,
				"empNo":empNo,
			}),
			type:"put",
			contentType:"application/json",
			success:function(res){
				$(`.myChatRoom[idx=\${chatRoomNo}] .fw-alarm-badge`).css("background","#53a336");
				$(`.myChatRoom[idx=\${chatRoomNo}] .fw-alarm-badge`).html("");
			}
		})
		
		
		$.ajax({
			url:"/chat/getChatRoomEmp",
			data:{"chatRoomNo":chatRoomNo},
			type:"get",
			contentType:"application/x-www-form-urlencoded; charset=UTF-8",
			success:function(res){
				let str = "";
				
				chatRoomEmpListTemp = []
				$.each(res,function(i,v){
					chatRoomEmpListTemp.push(v.empNo)
					str += `<div class="chat-one">
                        <div class="img-wrap">
                        	<img src="/resources/img/icon/\${v.proflImageUrl}">
                        </div>
                        <p class="data eNm">\${v.empNm}</p>
                        <p class="data dNm">\${v.deptNm}</p>
                    </div>`;
				})
				
				
				$("#modal-chat-modify .wf-grid-box").html(str)
			}
			
		})
		
		
		
	})	
	
	// 모달 띄울 때 내용 초기화
	// 새 채팅방 만들기
	$("button[modal-id=modal-new-chat]").on("click",function(){
		chatRoomEmpList = [];
		chatRoomEmpList.push(empNo)
		chatAddOrInvite = "1";
		$("#cc").val("");
		$(".no-data-box").css("display","block")
		$("#modal-new-chat .wf-grid-box").html("");
		
	})
	
	$("#getEmpList").on("click",function(){
		let param = $("#cc").val()
		$.ajax({
			url:"/chat/getEmpList",
			data:{"param":param},
			type:"get",
			contentType:"application/x-www-form-urlencoded; charset=UTF-8",
			success:function(res){
				if(res != ""){
					$(".no-data-box").css("display","none")
					let str = "";
					console.log("chatRoomEmpList:",chatRoomEmpList)
					$.each(res,function(i,v){
						// 초대일 경우 이미 채팅방에 있는 사원이면 안나오게함
						if(chatRoomEmpList.includes(v.empNo)){
							return;
						}
						console.log("v.empNo:",v.empNo)
						str += `<div class="chat-one">
									<span class="checkbox-radio-custom" style="width:10%;">
			                            <input type="checkbox" name="chck\${i}" id="chck\${i}" class="chck" value="\${v.empNo}">
			                            <label for="chck\${i}"> </label>
		                        	</span>
		                            <div class="img-wrap">
		                            	<img src="/resources/img/icon/avatar.png">
			                        </div>
			                        <p class="data eNm">\${v.empNm}</p>
			                        <p class="data dNm">\${v.deptNm}</p>
			                    </div>`
					})
					$("#modal-new-chat .wf-grid-box").html(str);
				}else{
					
				}
				
			}
			
		})
		
	})
	
	// 원래 구상에서는 새로운 채팅생성만이었는데 채팅방에 사원초대도 같은 모달을 사용하게 됨
	$("#insert-new-chatRoom").on("click",function(){
		let newEmpNoList = []
		let newEmpNmList = []
		// 형식을 맞춰주기 위해 만듬... 받는 파라미터 Map<String,String[]>
		let chatRoomNoList = []
		
		if(chatAddOrInvite == "1"){	// 새로운 채팅방
			newEmpNmList.push(empNm);
			newEmpNoList.push(empNo);
			chatRoomNoList.push("");
		}else{	// 기존 채팅방에 사원 초대
			chatRoomNoList.push(chatRoomNo);
		}
		
		$.each($(".chck:checked"),function(i,v){
			let empNm = $(v).parents(".chat-one").find(".eNm").text()
			newEmpNoList.push($(v).val())
			newEmpNmList.push(empNm)
		})
		
		$.ajax({
			url:"/chat/addNewChatRoom",
			data:JSON.stringify({
				"chatRoomNoList":chatRoomNoList,
				"newEmpNoList":newEmpNoList,
				"newEmpNmList":newEmpNmList
			}),
			type:"post",
			contentType:"application/json",
			success:function(res){
				// 채팅방 생성시 채팅방 번호를 새로 만들어진 채팅방 번호로 지정
				chatRoomNo = res
				
				getChat();
				getChatRoomList();
				$("#modal-new-chat").removeClass("open")
				
				// 소켓에서 처리하려니 해당 소켓에 접속한 사람 수만큼 인서트돼서 여기에...
				let msg = ":% :% :%" + newEmpNmList + "님이 접속했습니다.:%" + chatRoomNo
				console.log("content:",msg.split(":%")[4])
			 	$.ajax({
	            	url:"/chat/addChat",
	            	data:{
	            		"chatRoomNo":chatRoomNo,
	            		"empNo":myId,
	            		"content":msg.split(":%")[3]
	            	},
	            	contentType:"application/x-www-form-urlencoded; charset=UTF-8",
	            	type:"post",
	            	async:false,
	            	success:function(res){
	            		$(`.myChatRoom[idx=\${chatRoomNo}] .chat-date`).html(formattedDateTime.split(" ")[1])
	            		if(msg.length > 8){
	                		$(`.myChatRoom[idx=\${chatRoomNo}] p[class=chat-txt]`).html(msg.substr(0,8)+"...")
	            		}else{
	                		$(`.myChatRoom[idx=\${chatRoomNo}] p[class=chat-txt]`).html(msg)
	            		}
	            	}
	            })
				
				
				$.each(sockets,function(i,socket) {
					if(socket.chatRoomNo == chatRoomNo){
						socket.send(msg)
					}
				})
				
			}
			
		})
		
		
	})
	
	$(".inviteBtn").on("click",function(){
		chatAddOrInvite = "2";
		chatRoomEmpList = chatRoomEmpListTemp;
		$("#modal-chat-modify").removeClass("open")
		$("#modal-new-chat").addClass("open")
		
	})
	
	
	$("#modal-chat-modify .modifyBtn").on("click",function(){
		let newChatRoomNm = $("#modal-chat-modify #cc").val();
		
		$.ajax({
			url:"/chat/modChatRoomNm",
			data:JSON.stringify({
				"newChatRoomNm":newChatRoomNm,
				"chatRoomNo":chatRoomNo
			}),
			type:"put",
			contentType:"application/json",
			success:function(res){
				getChatRoomList();
				$("#modal-chat-modify").removeClass("open");
			}
			
		})
		
		
	})
	
	$(".chatExit").on("click",function(){
		
		let exitConfirm = confirm("채팅방에서 나가시겠습니까?")
		if(exitConfirm == 1){
			
			$.ajax({
				url:"/chat/deleteChatRoom",
				data:JSON.stringify({
					"chatRoomNo":chatRoomNo,
					"empNo":empNo
				}),
				type:"delete",
				contentType:"application/json",
				success:function(res){
					getChatRoomList();
					$(".chat-content").html("")
					$(".chatRoom-chat-name").html("-- --")
					let msg = ":% :% :%" + empNm + "님이 접속을 종료했습니다.:%" + chatRoomNo
					
					$.ajax({
		            	url:"/chat/addChat",
		            	data:{
		            		"chatRoomNo":chatRoomNo,
		            		"empNo":myId,
		            		"content":msg.split(":%")[3]
		            	},
		            	contentType:"application/x-www-form-urlencoded; charset=UTF-8",
		            	type:"post",
		            	async:false,
		            	success:function(res){
		            		$(`.myChatRoom[idx=\${chatRoomNo}] .chat-date`).html(formattedDateTime.split(" ")[1])
		            		if(msg.length > 8){
		                		$(`.myChatRoom[idx=\${chatRoomNo}] p[class=chat-txt]`).html(msg.substr(0,8)+"...")
		            		}else{
		                		$(`.myChatRoom[idx=\${chatRoomNo}] p[class=chat-txt]`).html(msg)
		            		}
		            	}
		            })
					$.each(sockets,function(i,socket) {
						if(socket.chatRoomNo == chatRoomNo){
							socket.send(msg);
						}
					})
					
					chatRoomNo = "0";
					
				}
			})
			
			
		}
		
		
		
		
	})

	$("#chat-input").keypress(function(event){
		if(event.which === 13) {
			send(chatRoomNo);
		} 
	});

// 웹소켓 관련 기능들
let myId = "";
let sockets = [];
let webSocket; // 페이지 바뀌면 변수가 사라진다는 사실에 주목할 필요가 있음
connect("0")

myId = empNo//f_ranID();
const c_chatWin = document.querySelector(".chat-content");
const c_message = document.querySelector("#chat-input");		
const c_send = document.querySelector(".chat-send");
const c_exit = document.querySelector(".xi-log-out");


// 채팅 보내기
c_send.addEventListener("click", function(){
	send(chatRoomNo);
});

// 연결 끊기
c_exit.addEventListener("click", function () {
	disconnect();
}); 
	

//연결
function connect(chatRoomNo) {
	
	let exists = sockets.some(function(socket) {
        return socket.chatRoomNo == chatRoomNo;
    });

    if (exists) {
        return; // 이미 존재하면 함수 종료
    }
	webSocket = new WebSocket("ws://192.168.146.64:80/ws-chat?chatRoomNo="+chatRoomNo); // End Point
	webSocket.chatRoomNo = chatRoomNo;
	webSocket.onopen = function(event){
		fOpen(chatRoomNo,webSocket)
	};
	
	webSocket.onmessage = fMessage;
	sockets.push(webSocket);
	
}
	
	
	

//연결 시
function fOpen(chatRoomNo, socket) {
	console.log("open")
}

function send(chatRoomNo) {  // 웹소켓 메세지 전송
	let msg = c_message.value;



	$.each(sockets,function(i,socket) {
		// 웹소켓중에서 현재 채팅방에만 보냄
        if (socket.chatRoomNo == chatRoomNo) {
        	// 보내는 데이터 구분
            socket.send(myId + ":%" + empNm + ":%" + formattedDateTime + ":%" + msg + ":%" + chatRoomNo);
            
            // db에 채팅내용 insert
            $.ajax({
            	url:"/chat/addChat",
            	data:{
            		"chatRoomNo":chatRoomNo,
            		"empNo":myId,
            		"content":msg
            	},
            	contentType:"application/x-www-form-urlencoded; charset=UTF-8",
            	type:"post",
            	async:false,
            	success:function(res){
            		$(`.myChatRoom[idx=\${chatRoomNo}] .chat-date`).html(formattedDateTime.split(" ")[1])
            		if(msg.length > 8){
                		$(`.myChatRoom[idx=\${chatRoomNo}] p[class=chat-txt]`).html(msg.substr(0,8)+"...")
            		}else{
                		$(`.myChatRoom[idx=\${chatRoomNo}] p[class=chat-txt]`).html(msg)
            		}
            	}
            })
        }
    });
    c_message.value = "";
}

function fMessage() {
	let data = event.data;
	// 사원번호
	let data1 = data.split(":%")[0]
	// 사원이름
	let data2 = data.split(":%")[1]
	// 현재 날짜
	let data3 = data.split(":%")[2]
	// 메세지
	let data4 = data.split(":%")[3]
	// 채팅방번호
	let data5 = data.split(":%")[4]
	
	// 채팅룸이 현재 자신이 보고있는 채팅룸에만 데이터 적용
	if(event.currentTarget.chatRoomNo == chatRoomNo){
	console.log("data4:",data4)
	console.log("data5:",data5)
		if(chatRoomNo == data5){
			if(data4.substr(-7,7) == "접속했습니다." || data4.substr(-7,7) == "종료했습니다.") {
			    c_chatWin.innerHTML += `<div style="text-align:center">\${data4.substr(0,data4.length-1)}</div>`;
			    
			}else if(data1 == myId){
				c_chatWin.innerHTML += `<div class="user mine">
						    <div class="chat-user-info">
						        <div class="chat-img">
						            <img src="/resources/img/icon/avatar.png">
						        </div>
						        <p class="chat-name">\${data2}</p>
						        <p class="chat-date">\${data3}</p>
						    </div>
						    <div class="chat-txt">
						        \${data4}
						    </div>
						</div>`
			}else{
				c_chatWin.innerHTML += `<div class="user you">
				    <div class="chat-user-info">
				        <div class="chat-img">
				            <img src="/resources/img/icon/avatar.png">
				        </div>
				        <p class="chat-name">\${data2}</p>
				        <p class="chat-date">\${data3}</p>
				    </div>
				    <div class="chat-txt">
				        \${data4}
				    </div>
				</div>`
			}
			c_chatWin.scrollTop = c_chatWin.scrollHeight;
			
		}
		getChatRoomList();
		
	}
	
	
	
}


function disconnect(chatRoomNo) { // 웹소켓 종료
	$.each(sockets,function(i,socket){
		if(socket.chatRoomNo == chatRoomNo){
			socket.send(myId + "님이 접속을 종료했습니다.%");
			socket.close();
		}
		
	})
	
}

	// 파일첨부
	$(".attachFile").on("click",function(){
		$("#upload").click();
	})
	
	$("#upload").on("change",function(){
		
		let formData = new FormData($("#uploadForm")[0])
	    // aws s3 외부 저장소에 이미지 업로드 후 이미지 불러오기 
		$.ajax({
			url:"/chat/fileUpload",
			data: formData,
			type:"post",
			contentType: false,
            processData: false,
            dataType:"text",
			success:function(res){
				console.log("res:",res)
				let msg = "<img src='" + res + "' width='200' height='150'>"
				
				$.each(sockets,function(i,socket){
					if (socket.chatRoomNo == chatRoomNo) {
					 
						socket.send(myId + ":%" + empNm + ":%" + formattedDateTime + ":%" + msg + ":%" + chatRoomNo);
						
						$.ajax({
				           	url:"/chat/addChat",
				           	data:{
				           		"chatRoomNo":chatRoomNo,
				           		"empNo":myId,
				           		"content": msg
				           	},
				           	contentType:"application/x-www-form-urlencoded; charset=UTF-8",
				           	type:"post",
				           	async:false,
				           	success:function(res){
				           		$(`.myChatRoom[idx=\${chatRoomNo}] .chat-date`).html(formattedDateTime.split(" ")[1]);
				               	$(`.myChatRoom[idx=\${chatRoomNo}] p[class=chat-txt]`).html("사진")
				           	}
						})
						           
					
					}
				})
			}
		})
		
	})
	

})


</script>

	<!-- =============== body 시작 =============== -->
	<!-- =============== 상단타이틀영역 시작 =============== -->
	<!-- <div class="wf-tit-wrap">
	    <h1 class="page-tit">
	        <i class="xi-mail"></i>
	        전체메일
	        <span class="txt-style1 mg-l">1/51</span>
	    </h1>
	    <div class="side-util">
	        <button type="button" class="btn3">삭제</button>
	    </div>
	</div> -->
	<!-- =============== 상단타이틀영역 끝 =============== -->
	<!-- =============== 컨텐츠 영역 시작 =============== -->
	
	<div class="wf-mail-wrap">
	    <div class="wf-content-area wf-chat-left">
	        <button type="button" class="btn5 mail-btn" modal-id="modal-new-chat">채팅방 생성</button>
	
	        <!-- 채팅 목록 시작 -->
	<div class="wf-chat-list">
	    <span class="txt">
	        <i class="xi-wechat"></i>
	        ALL MESSAGE
	    </span>
	
	    <!-- 채팅방이 존재하지 않을때 -->
	<!-- <div class="no-chat">
	    채팅방이 존재하지 않습니다. 채팅방을 생성해보세요!
	</div> -->
	
	<!-- 채팅 목록 -->
	
	</div>
	<!-- 채팅 목록 끝-->
	</div>
	
	<div class="wf-mail-right" style="width: 600px;">
	    <div class="wf-content-area">
	        <!-- 채팅방 시작-->
	<div class="wf-chat-body">
	    <!-- 채팅방 상단 (톡명) -->
	<div class="chat-top">
	    <div class="chat-name chatRoom-chat-name">-- --</div>
	    <span class="chat-status-active">접속중</span>
	    <!-- <span class="chat-status-inactive">미접속중</span> -->
	    <div class="chat-util">
	        <button type="button" modal-id="modal-chat-modify">
	            <i class="xi-pen"></i>
	        </button>
	        <button type="button">
	            <i class="xi-info"></i>
	        </button>
	        <button type="button" class="chatExit">
	            <i class="xi-log-out"></i>
	        </button>
	    </div>
	</div>
	<!-- chat-content -->
	<div class="chat-content">
	</div>
	
	<!-- 채팅 입력창 -->
	    <div class="comment-area">
	        <div class="input-wrap">
	            <span class="user-thumb">
	                <img src="/resources/img/icon/avatar.png" alt="예시이미지">
	            </span>
	            <input type="text" id="chat-input" placeholder="댓글을 입력하세요">
            	<button type="button" class="btn5 attachFile"><i class="xi-attachment"></i></button>
            	<form id="uploadForm" enctype="multipart/form-data">
	           		<input type="file" name="upload" id="upload" accept="image/*" style="display:none;" multiple>
	            </form>
	            <button class="btn4 chat-send">보내기</button>
	        </div>
	    </div>
	</div>
	<!-- 채팅방 끝-->
	        </div>
	    </div>
	</div>
<!-- =============== 컨텐츠 영역 끝 =============== -->
<!-- =============== body 끝 =============== -->
<div class="modal" id="modal-new-chat">
    <div class="modal-cont">
        <h1 class="modal-tit">대화상대 선택</h1>
        <div class="modal-content-area">
            <ul class="wf-insert-form2 vertical">
                <li>
                    <label for="cc">직원 검색</label>
                    <div>
                        <div class="wf-flex-box">
                            <input type="text" id="cc" placeholder="직원을 검색하세요">
                            <button type="button" id="getEmpList" class="btn4">
                                <i class="xi-search"></i>
                            </button>
                        </div>
                    </div>
                </li>
                <li>
                    <div class="wf-chat-detail-list">
                        <span class="txt">대화상대</span>
                        <div class="no-data-box">선택된 직원이 없습니다.</div>
                        <div class="wf-grid-box">
                        </div>
                    </div>
                </li>
            </ul>
        </div>

        <div class="modal-btn-wrap">
            <button id="insert-new-chatRoom" class="btn2">확인</button>
        </div>

        <button class="close-btn"></button>
    </div>
</div>

<div class="modal" id="modal-chat-modify">
    <div class="modal-cont">
        <h1 class="modal-tit">최프 단톡(여기에 톡방 이름이 나오게)</h1>
        <div class="modal-content-area">
            <ul class="wf-insert-form2 vertical">
                <li>
                    <label for="cc">이름 변경</label>
                    <div>
                        <input type="text" id="cc" placeholder="톡방 이름을 입력해주세요">
                    </div>
                </li>
                <li>
                    <div class="wf-chat-detail-list">
                    	<div class="wf-flex-box">
	                        <span class="txt" style="width: 80%;">대화상대</span>
	                        <button type="button" class="btn2 inviteBtn">추가하기</button>
                        </div>
                        <div class="wf-grid-box">
                        </div>
                    </div>
                </li>
            </ul>
        </div>

        <div class="modal-btn-wrap">
            <button class="btn2 modifyBtn">확인</button>
        </div>

        <button class="close-btn"></button>
    </div>
</div>

