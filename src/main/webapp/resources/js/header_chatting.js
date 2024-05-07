let headerWebSocket;



$(function(){
	$(document).on("click",".close",function(){
		let clickA = $(this)
		let ntcnNo = $(this).attr("idx")
		$.ajax({
			url:"/alram/updateAlramSeeYN",
			data:{
				"empNo":headerEmpNo,
				"ntcnNo":ntcnNo
			},
			type:"get",
			success:function(res){
				clickA.parents(".alramLi").css("display","none");
				let str = "";
				if($(".alarm-list").text() == ""){
					str += "<li>";
					str += "<p>알람이 없습니다.</p>";
					str += "</li>";
					$(".getAlram").html(str);
				}
			}
			
		})
	})

	$(".xi-bell").on("click",function(){
		$.ajax({
			url:"/alram/updateAlramYN",
			data:{"empNo":headerEmpNo},
			type:"get",
			success:function(res){
				getAlramCount();
				
			}
			
		})
		
		
		$.ajax({
			url:"/alram/getAlram",
			data:{"empNo":headerEmpNo},
			type:"get",
			success:function(res){
			
				let str = ""
				let sendEmp = ""
				let position = ""
				
				if(res.length == 0){
					str += "<li>";
					str += "<p>알람이 없습니다.</p>";
					str += "</li>";
				}
				
				$.each(res,function(i,v){
					
					str += `<li class="alramLi">
		                      <div>
		                          <span class="tit">${v.ntcnCn}</span>
		                          <p>
		                              <span class="date">${v.formatTime}</span>
		                          </p>
		                      </div>
								<a class="close" idx="${v.ntcnNo}">X</a>
		                  </li>`
				
				})
				
				$(".getAlram").html(str);
				
			}
			
		})
		
	})

	$("a[modal-id='modal-user-alram']").on("click",function(){
		
		$.ajax({
			url:"/empAlram/getAlramSetUpList",
			data:{"empNo":headerEmpNo},
			type:"get",
			success:function(res){
				let str = "";
				let yn = "";
				$.each(res,function(i,v){
					
					if(v.ntcnYnCd == "Y"){
						yn = "checked"
					}else{
						yn = "";
					}
					
					str += `
						    <li>
						        <input type="checkbox" id="ch${i}" ${yn}>
						        <label for="ch${i}">${v.setupNtcnNm}</label>
						    </li>
							`
					
				})
				
				
				$(".myAlarmSetUpUl").html(str)
			}
			
		})
		
	})
	
	// 설정창 닫을 때 알람정보 업데이트
	$("#modal-user-alram .close-btn").on("click",function(){
		let yn = "";
		let param = {"empNo":headerEmpNo}
		$.each($(".myAlarmSetUpUl li"),function(i,v){
			if($(v).find('input[type="checkbox"]').prop("checked")){
				yn = "Y";
			}else{
				yn = "N";
			}
			
			param["data" + (i+1)] = yn;
			
		})
	
		$.ajax({
			url:"/empAlram/updateAlramSetUpList",
			data:param,
			type:"get",
			success:function(res){
			
			}
		})
	})


	$(".xi-wechat").on("click",function(){
		let url = "/chat/main"
		let name = "채팅방"
		let option = "width = 800, height = 800, left=2000, location=no, toolbars=no, status=no"
		open(url,name,option)
	})
	
	getAlramCount();
	function getAlramCount(){
		$.ajax({
			url:"/alram/getAlramCount",
			data:{"empNo":headerEmpNo},
			type:"get",
			dataType:'text',
			success:function(res){
				console.log("res123:",res)
				res = res+""
				$(".note-num1").html(res)
				if(res == "0"){
					$(".note-num1").css("display","none")
				}else{
					$(".note-num1").css("display","inline-block")
				}
				
			}
		})
	}
	
	headerWebSocket = new WebSocket("ws://192.168.146.64:80/ws-chat"); // End Point
	
	
	headerWebSocket.empNo = headerEmpNo;
			
	headerWebSocket.onopen = function(){}
	headerWebSocket.onmessage = receiveMessage;
		
	
	function receiveMessage(){
		// 받은 메세지
		let data = event.data;
		// 보낸 사람 사번
		let data1 = data.split(":%")[0]
		// 받는 사람 사번
		let data2 = data.split(":%")[1]
		// 메세지
		let data3 = data.split(":%")[2]
		// 무슨 종류의 메세지인지 구분
		let data4 = data.split(":%")[3]
		
		let exit = "";
		
		if(data2 == headerWebSocket.empNo){
		
			if(data4 == "dutyReceive"){
				$.ajax({
					url:"/alram/getEmpDutyYN",
					data:{"empNo":data2},
					type:"get",
					dataType:'text',
					async:false,
					success:function(res){
						if(res == "N"){
							exit = res;
						}
						
					}
				})
			}
			
			if(data4 == "approvalReceive" || data4 == "approvalResult"){
				$.ajax({
					url:"/alram/getEmpApvYN",
					data:{"empNo":data2},
					type:"get",
					dataType:'text',
					async:false,
					success:function(res){
						if(res == "N"){
							exit = res;
						}
						
					}
				})
			}
			
			if(exit == "N"){
				return;
			}
			
			if(data4 == "commute" || data4 == "lvffc"){
				location.reload();
			}
			
			if(data4 == "mReserve" || data4 == "lvffcMsg" || data4 == "attendMsg"){
			
			}
				//Swal.fire(data3)
				
				Toast.fire({
							icon: "info",
						    title: data3, // 메세지 수정해서 사용
						});
				
				// 알람 테이블에 내용 인서트
				$.ajax({
					url:"/alram/addAlram",
					data:{
						"empNo":data2,
						"msg":data3
					},
					type:"get",
					async:false,
					success:function(res){
						// 알람 테이블에서 empNo가 자신이고 읽은상태가 N인 행의 수 반환 후 알람 옆에 표시
						getAlramCount();
						
					}
				})
				
			
		}
		
	}
	
})