<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 모든 페이지에서 웹소켓을 적용시키기 위해서는 타일에 따로 추가할 필요가 있다? 그런데 그런방식이 권장되진 않는다고함... -->
<script>
let receipter = "";
let myId = "";
function getAlram(){
	$.ajax({
		url:"/admin/alram",
		data:{"empNo":myId},
		type:"get",
		success:function(res){
			$(".note-num").html(res)
			console.log("res:",res)
			if(res == "0"){
				$(".note-num").css("display","none")
			}else{
				$(".note-num").css("display","inline-block")
			}
			
		}
	})
}

$(function(){


let webSocket; // 페이지 바뀌면 변수가 사라진다는 사실에 주목할 필요가 있음
myId = <%=session.getAttribute("empNo")%>//f_ranID();
const c_chatWin = document.querySelector("#id_chatwin");
const c_message = document.querySelector("#id_message");		
const c_send = document.querySelector("#id_send");
const c_exit = document.querySelector("#id_exit");

if(c_send != null){
	c_send.addEventListener("click", function(){
		send();
	});
}
// 연결 끊기
if(c_exit != null){
	c_exit.addEventListener("click", function () {
		disconnect();
	}); 
	
}

//연결
connect();
function connect() {
	webSocket = new WebSocket("ws://localhost:80/ws-chat"); // End Point
	
	if(myId != null){
		webSocket.onopen = fOpen; // 로그인 했을 경우에 소켓 접속
	}
	
	webSocket.onmessage = fMessage; // 메세지 보낼 때 실행함수
}

//연결 시
function fOpen() {
	webSocket.send(myId + "님이 접속했습니다.");
	console.log("open")
}

function send() {  // 웹소켓 메세지 전송
	let msg = c_message.value;	// 실험하는 곳에서는 c_message지만 다른곳에서는 메세지 내용을 따로 적어줘야 함
	let targetId = receipter;
	targetId = "2020003"	// 여기에 받는사람 아이디 넣어줌
	
	webSocket.send(myId + ":" + msg + "_" + targetId);
	c_message.value = "";
}

function fMessage() {
	
	let data = event.data;
	// 받는사람이 나일 경우 실행
	if(data.split("_")[1] == myId){
		
		// 알람 테이블에 내용 인서트
		$.ajax({
			url:"/admin/addAlram",
			data:{
				"empNo":myId,
				"msg":data.split("_")[0]
			},
			type:"get",
			async:false,
			success:function(res){
				// 알람 테이블에서 empNo가 자신이고 읽은상태가 N인 행의 수 반환 후 알람 옆에 표시
				getAlram();
				
			}
		})
		
		Swal.fire(data.split("_")[0])
		
		
	}
	if(c_chatWin != null){
		if(data.split("_")[1]){
			c_chatWin.innerHTML = c_chatWin.innerHTML + "<br/>" + data.split("_")[0] + "->" + data.split("_")[1];
		}else{
			c_chatWin.innerHTML = c_chatWin.innerHTML + "<br/>" + data.split("_")[0]
		}
	}
}

function disconnect() { // 웹소켓 종료
	webSocket.send(myId + "님이 접속을 종료했습니다");
	webSocket.close();
}
	if(myId != null){
		getAlram();
	}
})
</script>