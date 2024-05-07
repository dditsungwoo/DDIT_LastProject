<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet" href="/resources/css/duty/senderMain.css">

<!--  autocomplete css -->
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">  
    
 <!--  fullcalender -->

<link href="/resources/css/fullcalendar.css" rel="stylesheet" />
<script src="/resources/js/fullcalendar.js"></script>
<script src="/resources/js/fullcalendar-ko.js"></script> 
 
 
<div class="wf-main-container">
	<!-- =============== body 시작 =============== -->
	<!-- =============== 상단타이틀영역 시작 =============== -->
	<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
		<h1 class="page-tit">업무 관리자페이지</h1>
		
		<div class="side-util">
			<button class="btn4" style="float:right;" onclick="location.href='/duty/main'" >사원 페이지</button> 
			<button class="btn2" id="createDuty" style="float:right;" modal-id="modal-createDuty">업무 등록</button> 
		</div>
	</div>
	<!-- =============== 상단타이틀영역 끝 =============== -->
	<!-- =============== 컨텐츠 영역 시작 =============== -->
	<div class="wf-content-wrap" >

		<!-- 상단영역 시작 -->
		<div class="wf-content-area box3">
			<div class="wf-flex-box">
				<div class="wf-content-box c1box" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
					<p class="heading2" id="placeForChart1"> 사원 업무 통계</p>	
					<div id="senderChart1"></div>
				</div>
				<div class="wf-content-box c2box" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">									
					<div id="myDay"></div>					
				</div>

				<div class="wf-content-box" data-aos="fade-right" data-aos-duration="700" data-aos-delay="400">
					<div id="monthDay"></div>					
				</div>
			</div>
		</div>
		<!-- 상단영역 끝 -->

	<!-- 하단영역 시작 -->
		<div class="wf-content-area" data-aos="fade-right" data-aos-duration="700" data-aos-delay="600">

			<div class="tab-type tab-type1">
				<div class="wf-flex-box between">
					<p class="heading1">보낸 업무함</p>
					<div class="tab-menu">
						<button data-tab="tab1" type="button" class="tab-btn active totalBar">전체</button>
						<button data-tab="tab2" type="button" class="tab-btn" id="ingBar">읽지않음</button>
						<button data-tab="tab3" type="button" class="tab-btn" id="doneBar">읽음</button>
						<div class="tab-indicator"
							style="width: 140px; transform: translateX(0px);"></div>
					</div>
				</div>

				<!-- tab1  -->
				<div data-tab="tab1" class="tab-content active">
					<div class="tab-board-lst">
					<div id="tabId1"></div>
					</div>
				</div>

				<!-- tab2  -->
				<div data-tab="tab2" class="tab-content">
					<div class="tab-board-lst">
					<div id="tabId2"></div>
					</div>
				</div>

				<!-- tab3  -->
				<div data-tab="tab3" class="tab-content">
					<div class="tab-board-lst">
					<div id="tabId10"></div>
				</div>
			</div>

		</div>
		<!-- 하단영역 끝 -->
	</div>
	<!-- =============== 컨텐츠 영역 끝 =============== -->
	<!-- =============== body 끝 =============== -->
</div>    

<!-- ==============create 모달 시작===============   -->
<div class="modal" id="modal-createDuty"> 
    <div class="modal-cont">
        <h1 class="modal-tit">업무 등록</h1>
        <div class="modal-content-area">
            <form action="/duty/insertDuty?${_csrf.parameterName}=${_csrf.token}" method="post"
             enctype="multipart/form-data">
                <ul class="wf-insert-form2">
 					
                    <li>
                        <label for="dutyNm">업무 명<i class="i">*</i></label>
                        <div>
                            <input type="text" id="dutySj" name="dutySj" placeholder="텍스트를 입력해주세요" required >
                        </div>
                    </li>
					<li></li>
                    <li>
                        <label for="closDate">종료 일자</label>
                        <div>
                            <input type="date" id="closDate" name="closDate">
                        </div>
                    </li>
                    <li>
                        <label for="closDate">종료 시간</label>
                        <div class="wf-select-group">
                        	<select id="closTime" name="closTime">
						    	<option value="09:00">09:00</option>
						    	<option value="10:00">10:00</option>
						    	<option value="11:00">11:00</option>
						    	<option value="12:00">12:00</option>
						    	<option value="13:00">13:00</option>
						    	<option value="14:00">14:00</option>
						    	<option value="15:00">15:00</option>						       
						    	<option value="16:00">16:00</option>						       
						    	<option value="17:00">17:00</option>						       						       
    						</select>
                        </div>
                    </li>
                    <li>
                       <input type='hidden' id='empNo' name='empNo' value='<%=session.getAttribute("empNo") %>'/>
                        <label for="">수신자 1</label>
                        <div class="divRecipientNo">
                            <input type="text"  class="autocomplete" id='rTxt1' placeholder="텍스트를 입력해주세요" required />
                        	<input type="hidden" class="recipientNo" id='rNo1'  name="recipientNo"/>
                        </div>
                    </li>
                    <li>
                       
                        <label for="">수신자 2</label>
                        <div class="divRecipientNo">
                            <input type="text" class="autocomplete" id='rTxt2'  placeholder="텍스트를 입력해주세요"/>
                        	<input type="hidden" class="recipientNo" id='rNo2' name="recipientNo"/>
                        </div>
                    </li>
                    <li>
                       
                        <label for="">수신자 3</label>
                        <div class="divRecipientNo">
                            <input type="text" class="autocomplete"  id='rTxt4'  placeholder="텍스트를 입력해주세요"/>
                        	<input type="hidden" class="recipientNo"  id='rNo4' name="recipientNo"/>
                        </div>
                    </li>
                    <li>
                       
                        <label for="">수신자 4</label>
                        <div class="divRecipientNo">
                            <input type="text" class="autocomplete" id='rTxt3'  placeholder="텍스트를 입력해주세요"/>
                        	<input type="hidden" class="recipientNo" id='rNo3' name="recipientNo"/>
                        </div>
                    </li>
          
                    <li>
                        	상세 내용<i class="i">*</i>
                        <div>
                            <textarea name="dutyCn" id="dutyCn" required ></textarea>
                        </div>
                    </li>
                    <li>
                    	<div id="textBoxContainer">
                    	
                    	</div>
                    </li>
                      <li>
                        	첨부 파일<i class="i">*</i>
                        <div>
                            <input type="file" id="uploadFile" name="uploadFile" />
                        </div>
                    </li>
                </ul>				
        	</div>

	        <div class="modal-btn-wrap">
	            <button class="btn6">취소</button>
	            <button class="btn2" id="btnCreateProject" type="submit">저장</button>
	            <button class="btn5" id="btnAutoTyping" type="button">자동완성</button>
	        </div>
           </form>

        <button class="close-btn"></button>
    </div>
</div>
<!-- ==============create 모달 끝===============   -->


<script type="text/javascript">
_senderBadge={
	"중단":"wf-badge5",
	"준비":"wf-badge1",
	"진행":"wf-badge2",
	"완료":"wf-badge4"
	};
	
_senderStyle={
		"중단":1,
		"준비":2,
		"진행":3,
		"완료":4
		};
let _senderRate={
		0:"wf-badge5",
		1:"wf-badge1",
		2:"wf-badge2",
		3:"wf-badge2",
		4:"wf-badge2",
		5:"wf-badge2",
		6:"wf-badge2",
		7:"wf-badge2",
		8:"wf-badge2",
		9:"wf-badge2",
		10:"wf-badge4"
	}
	
_prgName={
		0:"중지",
		1:"진행중",
		2:"진행중",
		3:"진행중",
		4:"진행중",
		5:"진행중",
		6:"진행중",
		7:"진행중",
		8:"진행중",
		9:"진행중",
		10:"완료"
	};
_cnfirmDate={
	"읽음":"wf-badge1" ,
	"읽지않음":"wf-badge5"
};	
	

$(()=>{
	let sessionEmpNo= <%=session.getAttribute("empNo") %>;
	
	let data={
		"empNo":sessionEmpNo
	};
	
	getDutyListForSender(1,"");
	getDutyListCnfirmDate(1,'0');
	getDutyListCnfirmDate(1,'1');
	getSenderInfo(sessionEmpNo);
	
	//전체 탭 누르면  리스트 보이게-------------------------------------------
	$(document).on("click",".totalBar",function(){
		getDutyListForSender(1,"");
	});//---------------------------------------------------------------
	
	
	// 자동완성 버튼 누르면
	$("#btnAutoTyping").on("click",function(){
		$("#dutySj").val("천안지사 교육 참여 출장의 관한 건");
		$("#closDate").val("2024-04-17");
		$("#closTime").val("17:00");
		$("#rTxt1").val("유선영");
		$("#rNo1").val("2019202");
		$("#rTxt2").val("한지훈");
		$("#rNo2").val("2019201");
		let cnText=`
		    1. 목적:
		    	Microservices Architecture (MSA) 및 Kubernetes 기술에 대한 심층적인 이해 증진
		    	현대적인 애플리케이션 아키텍처 설계와 관리에 필요한 역량 강화
		
			2.내용 및 참여 계획:
				이를 위해 다음과 같이 개발요원 투입을 요청합니다.
				협조 부탁드립니다.
			
		    	대상요원 : 개발팀 OO명
			       투입기간 : 2024-04-18 ~ 2024.04-19
			
			첨부. 개발팀 인력투입 요청서 1부 `;
	    
		$("#dutyCn").val(cnText);
		
	});//자동완성 버튼 누르면 끝
	
	
	//상세페이지 들어가기---------------------------------------------------
	$(document).on("click",".dutyLists",function(){
		let dutyNo=$(this).data("dutyNo");
		let empNo=$(this).data("empNo");
		
		location.href="/duty/senderDetail?dutyNo="+dutyNo+"&empNo="+empNo;
	});
    //상세페이지 들어가기 끝--------------------------------------------------
	
	
	//상단에 버튼 클릭 할때 밑에 리스트 나오게	----------------------------
	$(document).on("click",".todayList, .calendarCn, .btnChart1 ",function(){
		console.log("btnChart2");
		let chart1EmpNo="";
		chart1EmpNo=$(this).data("empNo");
		getDutyListForSender(1,chart1EmpNo);		
	});//상단 버튼 클릭 할때 밑에 리스트 나오게	끝 -------------------

	
	var closDateInput = document.getElementById('closDate');

	// 현재 날짜 가져오기
	var currentDate = new Date();

	// 이전 날짜를 선택할 수 없도록 설정------------------
	closDateInput.addEventListener('input', function() {
	    var selectedDate = new Date(closDateInput.value);
	    if (selectedDate < currentDate) {
	        closDateInput.value = ''; // 선택한 날짜를 초기화하여 이전 날짜를 선택할 수 없도록 함
	        Toast.fire({
   			  title: _msg.reservation.formDateErrorAlert,
   			  text: "",
   			  icon: "error"
   			});
	    }
	});// 이전 날짜를 선택할 수 없도록 설정-------------------
	
	
	//관리자의 왼쪽 상단 통계--------------------------------
	$.ajax({
		url:"/duty/senderChart1",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		dataType:"json",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(res){  
	 		console.log(res);
	   		console.log("weekDoList",res);
		    let str="";
	   		str +=  `<div class="wf-flex-box between">
					</div>
					<ul class="wf-list-style"><br>`;
		 $.each(res, function(idx, vo){	
				let position = vo.position;
	            let rspnsbl = vo.rspnsbl;
	            if (rspnsbl != "팀원") {
	                position = rspnsbl;
	            }			 
				str +=  `<li class="style\${_senderStyle[vo.prgsRate]} btnChart1" data-emp-no="\${vo.empNo}">
							<span class="user-thumb" >
                				<img src="/resources/img/icon/\${vo.proflImageUrl}" style="width:30px; height:30px;">
            				</span>
						\${vo.empNm} \${position}
							<p style="float:right; padding:3px;">
							\${vo.col1 ? `<badge class="wf-badge5">\${vo.col1}</badge>` : ''}
							\${vo.col2 ? `<badge class="wf-badge1">\${vo.col2}</badge>` : ''}
							\${vo.col3 ? `<badge class="wf-badge2">\${vo.col3}</badge>` : ''}
							\${vo.col4 ? `<badge class="wf-badge4">\${vo.col4}</badge>` : ''}
							</p></li>`;
						
		 })
			 str +=`</ul>`;
			 $("#senderChart1").html(str);
		}
		
	   }); //관리자의 왼쪽 상단 통계 끝----------------------- 
	
	//관리자의 중앙 통계--------------------------------
	$.ajax({
		url:"/duty/senderChart2",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		dataType:"json",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(res){  
	   		console.log("todayDoList",res);
	   		let $myDay = $("#myDay");
	     
	   		$myDay.html();
	   	    let str = ``;
	            str +=`<p class="heading2"> \${res[0].sendDate}  오늘까지 업무 </p><br>`;
	        	str += `<ul class="wf-list-style">`;
	        $.each(res, function(idx, vo){
	        	let position = vo.position;
	            let rspnsbl = vo.rspnsbl;
	            if (rspnsbl != "팀원") {
	                position = rspnsbl;
	            }
	        	str +=`<li class="style\${idx+1} todayList" data-emp-no="\${vo.empNo}" data-duty-no="\${vo.dutyNo}">\${vo.closTime}시<span class="heading2"> &nbsp;&nbsp;\${vo.empNm} \${position}</span>` ; 
	        	str +=`<p class="heading2" style="float:right; padding:3px;">\${vo.dutySj}</p></li>`; 

	        })
	        	str +=`</ul>`;
	        $myDay.html(str);   
		}
	   }); //관리자의 중앙 통계 끝----------------------- 
	   
	   
	
	   
	// 상단 오른쪽 차트 시작    --------------------------------
    var calendarEl = document.getElementById('monthDay');
   	empNo=sessionEmpNo;   
    var calendar = new FullCalendar.Calendar(calendarEl, {
    	initialView: 'dayGridWeek',
    	locale: 'ko',
        //slotDuration: '', // 시간 슬롯을 비활성화
        allDaySlot: true, // 종일 이벤트만 표시하도록 설정
    	aspectRatio: 1.5 ,
        events: function(etchInfo, successCallback, failureCallback){
        	data ={
        		"empNo"	:empNo
        	};
        	 $.ajax({
        		   	url:"/duty/senderChart3",
        				data:JSON.stringify(data),
        				contentType:"application/json;charset=utf-8",
        				type:"post",
        				dataType:"json",
        				beforeSend:function(xhr){
        					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
        				},
        				success:function(res){  
        			   		let calendar=calendarData(res);
        			   		console.log("senderChart3",calendar);	   	 
        			   		
        			
        			   		successCallback(calendar);
    			       
        				}
        		   }); 

        },
        
        eventContent: function(info) {
        	 console.log(info.event.extendedProps.description);
		   let rate=info.event.extendedProps.description;
        	 
            return {
            	 html: "<badge class='" + _senderRate[rate] + " calendarCn' data-emp-no='"+info.event.id+"' >"+info.event.title+"</badge>"
                	 
            };
        },
        eventRender: function(info) {
        	 info.el.style.border = 'none'; // border를 없애기 위해 투명색으로 설정
        }
      });

      calendar.render();
      $(".fc-toolbar-title").append(" 업무 상황");
	  $(".fc-toolbar-title").css("font-size","17px");
      calendarEl.style.width = '400px';
      calendarEl.style.height = '200px';
  	 // 상단 오른쪽 차트 시작   ----------------------------------------------------
	   
      
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
            $(this).closest(".divRecipientNo").find(".recipientNo").val(ui.item.empNo);
            console.log("empno발 위치", $(this).closest(".divRecipientNo").find(".recipientNo").val());
        	//$(".ui-autocomplete",this).prevObject.hide();
            console.log("select 후",  $(this).closest(".divRecipientNo").find(".recipientNo"));
      
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
    }); //자동완성 끝     
    
      
	   
	   
	   
	   
})//$function 끝-------------------------------------------


function calendarData(data) {  
    return data.map(task => {
        var transformedTask = {
        	   id:task.empNo,	
            title: task.empNm,
            start:task.closDate+"T"+task.closTime,
            end: task.closDate+"T"+task.closTime,
            description:task.prgsRate
        };
        return transformedTask;
    });
}


// 관리자용 리스트 출력 
function getDutyListForSender(currentPage,keyword){


	//json 오브젝트
	let data = {
	    "currentPage": currentPage,
	    "keyword":keyword
	};

	console.log("data : ", data);

	$.ajax({
	    url: "/duty/getDutyListForSender",
	    contentType: "application/json;charset=utf-8",
	    data: JSON.stringify(data),	    
	    type: "post",
	    dataType: "json",
	    beforeSend: function(xhr){
	        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	    },
	    success: function(result){
			let str = "";
	      	if(keyword==null || keyword==""){keyword="1"};
	      	if(keyword.length==8){keyword='1'};
	      	
	      	let tid= "#tabId1";
			console.log("",result.content[0].empNo);
	      	// 목록을 초기화
	      	$(tid).html(""); 	
	    	if(result.content[0].empNo == null){
	    		str = "<p class='heading2'>업무를 찾을 수 없습니다</p>";
	    		$(tid).html(str);
	    		return;
	    	}
	 		console.log("result",result);
		    str +="<table class='wf-table'>";
		    str +="<colgroup><col style='width: 8%;'><col style='width: 12%;'>";
		    str +="<col style='width: 35%;'><col style='width: 15%;'>";
		    str +="<col style='width: 15%;'><col style='width: 15%;'>";
		    str +="</colgroup><thead><tr>";
		    str +="<th>번호</th><th>진행상태</th><th>업무제목</th><th>수신자</th><th>마감일자</th><th>수신자 확인여부</th>";
		    str +="</tr></thead><tbody>";

	        $.each(result.content, function(idx, vo){
	        	  let position = vo.position;
                  let rspnsbl = vo.rspnsbl;
                  if (rspnsbl != "팀원") {
                      position = rspnsbl;
                  }	        	
	        	//console.log(_prgBadge[vo.prgsRate]);
				str += "<tr class='dutyLists' data-duty-no='"+vo.dutyNo+"' data-emp-no='"+vo.empNo+"'>";
				str += "<td><p>"+vo.rnum+"</p></td>";
				str += "<td><span class='"+_senderRate[vo.prgsRate]+"'>"+_prgName[vo.prgsRate]+"</span></td>";
	        	str += "<td><p>"+vo.dutySj+"</p></td>";
	        	str += "<td><p>"+vo.col1+" "+position+"</p></td>";
	        	str += "<td><p>"+vo.closDate+"</p></td>";
	        	str += "<td><badge class='"+_cnfirmDate[vo.cnfirmDate]+"'>"+vo.cnfirmDate+"</badge></td></tr>";
	        });
	           str += "</tbody></table>";
	           str += result.pagingArea;
	       $(tid).append(str);
	   
	    }
	 });
	} //getDutyListForSender 끝--------------------------------------------

	
	
	//관리자용 받은 일감 (읽음 또는 읽지 않음 나타내기)
	function getDutyListCnfirmDate(currentPage,keyword){

		//json 오브젝트
		let data = {
		    "currentPage": currentPage,
		    "keyword":keyword
		};
		
		console.log("data : ", data);

		$.ajax({
		    url: "/duty/getDutyListCnfirmDate",
		    contentType: "application/json;charset=utf-8",
		    data: JSON.stringify(data),
		    type: "post",
		    dataType: "json",
		    beforeSend: function(xhr){
		        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		    },
		    success: function(result){
				let str = "";
				let tid = "";
		      	if(keyword==null || keyword==""){
		      		keyword="0";
		      	};
		      	if(keyword=='0'){
		      		tid="#tabId2";
		      	}
		      	if(keyword=='1'){
		      	   tid= "#tabId10";		
		      	}
				console.log("",result.content[0].empNo);
		      	// 목록을 초기화
		      	$(tid).html(""); 	
		    	if(result.content[0].empNo == null){
		    		str = "<p class='heading2'>업무를 찾을 수 없습니다</p>";
		    		$(tid).html(str);
		    		return;
		    	}
		 		console.log("result",result);
			    str +="<table class='wf-table'>";
			    str +="<colgroup><col style='width: 8%;'><col style='width: 12%;'>";
			    str +="<col style='width: 35%;'><col style='width: 15%;'>";
			    str +="<col style='width: 15%;'><col style='width: 15%;'>";
			    str +="</colgroup><thead><tr>";
			    str +="<th>번호</th><th>진행상태</th><th>업무제목</th><th>수신자</th><th>마감일자</th><th>수신자 확인여부</th>";
			    str +="</tr></thead><tbody>";

		        $.each(result.content, function(idx, vo){
		        	  let position = vo.position;
	                  let rspnsbl = vo.rspnsbl;
	                  if (rspnsbl != "팀원") {
	                      position = rspnsbl;
	                  }	        			        	
		        	//console.log(_prgBadge[vo.prgsRate]);
					str += "<tr class='dutyLists' data-duty-no='"+vo.dutyNo+"' data-emp-no='"+vo.empNo+"'>";
		        	str += "<td><p>"+vo.rnum+"</p></td>";
		        	str += "<td><span class='"+_senderRate[vo.prgsRate]+"'>"+_prgName[vo.prgsRate]+"</span></td>";
		        	str += "<td><p>"+vo.dutySj+"</p></td>";
		        	str += "<td><p>"+vo.col1+" "+position+"</p></td>";
		        	str += "<td><p>"+vo.closDate+"</p></td>";
		        	str += "<td><badge class='"+_cnfirmDate[vo.cnfirmDate]+"'>"+vo.cnfirmDate+"</badge></td></tr>";
		        });
		           str += "</tbody></table>";
		           str += result.pagingArea2;
		       $(tid).append(str);
		   
		    }
		 });
		} //getDutyListCnfirmDate 끝--------------------------------------------

function getSenderInfo(empNo){
	let data={
		"empNo":empNo	
	};
	$.ajax({
	    url: "/duty/getEmpInfo",
	    contentType: "application/json;charset=utf-8",
	    data: JSON.stringify(data),
	    type: "post",
	    dataType: "json",
	    beforeSend: function(xhr){
	        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	    },
	    success: function(result){
	    	
	    	let str= result.deptNm;
	    	$("#placeForChart1").html(str+" 업무 상황");
	    }
	});
}
		
//문자열 컨버트 함수
function convertText(text) {
    return text.replace(/\r?\n/g, '<br>');
}		

</script>
