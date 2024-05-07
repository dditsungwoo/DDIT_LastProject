<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
.main-container{
	width: 100%;
}
</style>
<script>
let realSize = window.innerWidth;
let empNo = <%=session.getAttribute("empNo")%>
let myChatRoomNo = "";

$("body").css("width",realSize)
window.addEventListener("resize", function() {
	let realSize = window.innerWidth;
	$("body").css("width",realSize)
})

$("header").html("")
$("header").css("height","0px")
$("aside").html("")

getChatRoomList()
// 내 채팅방 리스트 불러오기
function getChatRoomList(){
	$.ajax({
		url:"/chat/getChatRoom",
		data:{"empNo":empNo},
		type:"get",
		success:function(res){
			let str = "";
			str += `<div class="wf-content-wrap">`
			$.each(res,function(i,v){
				str += `<div class="wf-content-area myChatRoom" idx="\${v.chatRoomNo}" style="margin-top:2px;">
					<p class="heading1">\${v.chatRoomNm}</p>
					</div>`
			})
			
			str += `</div>`
			
			$("aside").html(str)
			
		}
	})
}

$(function(){
	// 채팅방 리스트 클릭 시의 기능
	$(document).on("click",".myChatRoom",function(){
		c_chatWin.innerHTML = "";
		myChatRoomNo = $(this).attr("idx")
		// 웹소켓 연결
		connect(myChatRoomNo);
		// 채팅방 리스트 클릭시 옆에 채팅방 화면 띄우기
		$.ajax({
			url:"/chat/getChat",
			data:{"chatRoomNo":myChatRoomNo},
			type:"get",
			success:function(res){
				console.log("채팅내역:",res)
			}
		})
		
	})	





let myId = "";
let webSocket; // 페이지 바뀌면 변수가 사라진다는 사실에 주목할 필요가 있음
let webSocketCheck = "x";
let webSocket2; // 페이지 바뀌면 변수가 사라진다는 사실에 주목할 필요가 있음
let webSocketCheck2 = "x";
let webSocket3; // 페이지 바뀌면 변수가 사라진다는 사실에 주목할 필요가 있음
let webSocketCheck3 = "x";
let webSocket4; // 페이지 바뀌면 변수가 사라진다는 사실에 주목할 필요가 있음
let webSocketCheck4 = "x";
let webSocket5; // 페이지 바뀌면 변수가 사라진다는 사실에 주목할 필요가 있음
let webSocketCheck5 = "x";
myId = <%=session.getAttribute("empNo")%>//f_ranID();
const c_chatWin = document.querySelector("#id_chatwin");
const c_message = document.querySelector("#id_message");		
const c_send = document.querySelector("#id_send");
const c_exit = document.querySelector("#id_exit");

// 채팅 보내기
c_send.addEventListener("click", function(){
	send(myChatRoomNo);
});

// 연결 끊기
c_exit.addEventListener("click", function () {
	disconnect();
}); 
	

//연결
function connect(chatRoomNo) {
	if(webSocketCheck == chatRoomNo ){
		return;
	}else if(webSocketCheck2 == chatRoomNo ){
		return;
	}else if(webSocketCheck3 == chatRoomNo ){
		return;
	}else if(webSocketCheck4 == chatRoomNo ){
		return;
	}else if(webSocketCheck5 == chatRoomNo ){
		return;
	}
	
	
	// 채팅방은 5개까지...
	if(!webSocket){
		webSocket = new WebSocket("ws://localhost:80/ws-chat?chatRoomNo="+chatRoomNo); // End Point
		webSocketCheck = chatRoomNo
		webSocket.onopen = fOpen(chatRoomNo); // 로그인 했을 경우에 소켓 접속
	}else if(!webSocket2){
		webSocket2 = new WebSocket("ws://localhost:80/ws-chat?chatRoomNo="+chatRoomNo); // End Point
		webSocketCheck2 = chatRoomNo
		webSocket2.onopen = fOpen(chatRoomNo); // 로그인 했을 경우에 소켓 접속
	}else if(!webSocket3){
		webSocket3 = new WebSocket("ws://localhost:80/ws-chat?chatRoomNo="+chatRoomNo); // End Point
		webSocketCheck3 = chatRoomNo
		webSocket3.onopen = fOpen(chatRoomNo); // 로그인 했을 경우에 소켓 접속
	}else if(!webSocket4){
		webSocket4 = new WebSocket("ws://localhost:80/ws-chat?chatRoomNo="+chatRoomNo); // End Point
		webSocketCheck4 = chatRoomNo
		webSocket4.onopen = fOpen(chatRoomNo); // 로그인 했을 경우에 소켓 접속
	}else if(!webSocket5){
		webSocket5 = new WebSocket("ws://localhost:80/ws-chat?chatRoomNo="+chatRoomNo); // End Point
		webSocketCheck5 = chatRoomNo
		webSocket5.onopen = fOpen(chatRoomNo); // 로그인 했을 경우에 소켓 접속
	}else{
		return;
	}
	
	
	
	
	
	webSocket.onmessage = fMessage; // 메세지 보낼 때 실행함수
	webSocket2.onmessage = fMessage; // 메세지 보낼 때 실행함수
	webSocket3.onmessage = fMessage; // 메세지 보낼 때 실행함수
	webSocket4.onmessage = fMessage; // 메세지 보낼 때 실행함수
	webSocket5.onmessage = fMessage; // 메세지 보낼 때 실행함수
}

//연결 시
function fOpen(chatRoomNo) {
	if(webSocketCheck == chatRoomNo ){
		webSocket.send(myId + "님이 접속했습니다.");
	}else if(webSocketCheck2 == chatRoomNo ){
		webSocket.send(myId + "님이 접속했습니다.");
	}else if(webSocketCheck3 == chatRoomNo ){
		webSocket.send(myId + "님이 접속했습니다.");
	}else if(webSocketCheck4 == chatRoomNo ){
		webSocket.send(myId + "님이 접속했습니다.");
	}else if(webSocketCheck5 == chatRoomNo ){
		webSocket.send(myId + "님이 접속했습니다.");
	}
	
	console.log("open")
}

function send(chatRoomNo) {  // 웹소켓 메세지 전송
	let msg = c_message.value;	// 실험하는 곳에서는 c_message지만 다른곳에서는 메세지 내용을 따로 적어줘야 함
	
	if(webSocketCheck == chatRoomNo ){
		webSocket.send(myId + ":" + msg);
	}else if(webSocketCheck2 == chatRoomNo ){
		webSocket2.send(myId + ":" + msg);
	}else if(webSocketCheck3 == chatRoomNo ){
		webSocket3.send(myId + ":" + msg);
	}else if(webSocketCheck4 == chatRoomNo ){
		webSocket4.send(myId + ":" + msg);
	}else if(webSocketCheck5 == chatRoomNo ){
		webSocket5.send(myId + ":" + msg);
	}
	c_message.value = "";
}

function fMessage() {
	
	let data = event.data;
	// 받는사람이 나일 경우 실행
	c_chatWin.innerHTML = c_chatWin.innerHTML + "<br/>" + data
}

function disconnect() { // 웹소켓 종료
	webSocket.send(myId + "님이 접속을 종료했습니다");
	webSocket.close();
}
})
</script>
<div id="id_chatwin" style="width: 100%; height: 80%"></div>
<div class="wf-flex-box">
<div style="width: 80%;"><input type="text" id="id_message" placeholder="텍스트를 입력해주세요" style="height: 100%"></div>
	<div style="width: 20%;">
		<button type="button" id="id_send" class="btn2">보내기</button>
	</div>
		<button type="button" class="btn1">
	    	<i class="xi-attachment"></i>
		</button>
</div>