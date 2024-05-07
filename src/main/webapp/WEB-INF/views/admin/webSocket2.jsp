<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
	#id_chatwin {
		width:300px;
		height:300px;
		background-color:black;
		border:1px solid pink;
		color:yellow;
	}
</style>
	<h1>간단히 억지롱 대화라도 할깡</h1>
	<div>
		<div id="id_chatwin"></div>
		<input type="text" id="id_message" /> 
		<input type="button" id="id_send" value="떤쏭"> 
		<input type="button" id="id_exit" value="나갈령">
	</div>
	<br><br>
	<div class="wf-main-container">
		<div class="wf-content-wrap">
			<div class="wf-content-area box2">
				<p class="heading1 align-center alram"></p>
			</div>
		</div>
	</div>
<script>
$(function(){
	

	//그냥 띰띰해서 맹근 랜덤 아이디 맹그는 함쑹
	const c_alpha="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	const f_ranID = function(){
		let ranID ="";
		for(let i=1; i< (Math.ceil(Math.random()*5)+4); i++){
			ranID += c_alpha[Math.floor(Math.random()*c_alpha.length)];
		}
		return ranID;
	}

	let webSocket; // 페이지 바뀌면 변수가 사라진다는 사실에 주목할 필요가 있음
	let myId = <%=session.getAttribute("empNo")%>//f_ranID();
	const c_chatWin = document.querySelector("#id_chatwin");
	const c_message = document.querySelector("#id_message");		
	const c_send = document.querySelector("#id_send");
	const c_exit = document.querySelector("#id_exit");

	c_send.addEventListener("click", function(){
		send();
	});
	// 연결 끊깅
	c_exit.addEventListener("click", function () {
		disconnect();
	});

	//연결
	connect();
	function connect() {
		webSocket = new WebSocket("ws://localhost:80/ws-chat"); // End Point
		//이벤트에 이벤트핸들러 뜽록 
		webSocket.onopen = fOpen; // 소켓 접속되면 짜똥 실행할 함수(fOpen)
		webSocket.onmessage = fMessage; // 써버에서 메쎄징 오면  짜똥 실행할 함수(fMessage) 
	}

	//연결 시
	function fOpen() {
		webSocket.send(myId + "님 이프짱.");
	} 

	function send() {  // 써버로 메쎄찡 떤쏭하는 함수
		let msg = c_message.value;
		webSocket.send(myId + ":" + msg + "_2020003");
		c_message.value = "";
	}

	function fMessage() {
		let data = event.data;
		console.log("data:",data);
		console.log("data.split('_')[1]:",data.split("_")[1]);
		console.log("myId:",myId);
		if(data.split(":")[0] != myId && data.split("_")[1] == myId){
			
			$.ajax({
				url:"/admin/addAlram",
				data:{
					"empNo":myId,
					"msg":data.split("_")[0]
				},
				type:"get",
				async:false,
				success:function(res){
					console.log("res1:",res)
					$.ajax({
						url:"/admin/alram",
						data:{"empNo":myId},
						type:"get",
						success:function(res){
							console.log("res2:",res)
							$(".note-num").html(res)
							Swal.fire("업무가 추가되었습니다.");
						}
					})
					
				}
			})
			
			
			
		}
		c_chatWin.innerHTML = c_chatWin.innerHTML + "<br/>" + data;
	}

	function disconnect() { //써버와 인연 끊는 함쑹
		webSocket.send(myId + "님이 뛰쳐나갔쪙");
		webSocket.close();
	}
	})
</script>