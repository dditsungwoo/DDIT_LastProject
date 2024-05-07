<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="../tiles/webSocket.jsp"></jsp:include>
<style>
	#id_chatwin {
		width:300px;
		height:300px;
		background-color:black;
		border:1px solid pink;
		color:yellow;
	}
</style>
	<h1>대화창</h1>
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
