<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
$(function(){
	
	$.ajax({
		url:"/attendance/insertAttend",
		type:"post",
		data:{
			"empNo":${empNo},
			/* "vcatnSeCd":${vcatnSeCd} */
		},
		contentType:"application/x-www-form-urlencoded; charset=UTF-8",
		success:function(res){
			if(res == 1){
				headerWebSocket.empNo = "";
				headerWebSocket.send(":%${empNo}:%commute:%commute")
				alert("출근 처리가 완료되었습니다.")
			}
		}
	})

})
</script>