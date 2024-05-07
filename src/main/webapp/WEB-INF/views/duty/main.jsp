<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix ="c" uri="http://java.sun.com/jsp/jstl/core" %>	
	
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet" href="/resources/css/duty/main.css">
<script type="text/javascript">
_prgBadge={
	0:"wf-badge5",
	1:"wf-badge1",
	2:"wf-badge1",
	3:"wf-badge1",
	4:"wf-badge1",
	5:"wf-badge1",
	6:"wf-badge1",
	7:"wf-badge1",
	8:"wf-badge2",
	9:"wf-badge2",
	10:"wf-badge4"
};

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


$(()=>{
	let rspnsblCd= "<%=session.getAttribute("rspnsblCtgryNm") %>";	
	if(rspnsblCd=="대표이사"){
		location.href="/duty/sender";
	}
	let sessionEmpNo= <%=session.getAttribute("empNo") %>;
	console.log("rspnsblCd  "+rspnsblCd);
	insertBtn();
	getDutyList(1,"");
	gData(sessionEmpNo);
	todayDoList(sessionEmpNo,'');
	weekDoList(sessionEmpNo);
	
	
$("#ingBar").on("click",function(){
	getDutyList(1,"2");
})	
	
$("#doneBar").on("click",function(){
	getDutyList(1,"10");
})	

$(".totalBar").on("click",function(){
	getDutyList(1,"");
});



//오늘 업무를 누르면 완료가 되게하는 함수---------------------------
$(document).on("click",".todayList",function(){
	
	let empNo= $(this).data("empNo");
	let dutyNo=$(this).data("dutyNo");
	console.log("todayList"+empNo);
	console.log("todayList"+dutyNo);
	$(this).css("textDecoration","line-through");
	$("p",this).css("textDecoration","line-through");
	
	let data={
		"empNo":empNo,
		"dutyNo":dutyNo
	}
	$.ajax({
		url:"/duty/clickAndDone",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		dataType:"json",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		
		success:function(res){  
	 		console.log(res);
	 	     Toast.fire({
	   			  title: "업무를 완료하였습니다!",
	   			  icon: "success"
	   			});
	       
		}
		
	   });  
	
	
	
});//오늘 업무를 누르면 완료가 되게하는 함수 끝----------------------



//이번주 업무를 누르면 리스트가 뜨는 함수 ----------------------
$(document).on("click",".weekList",function(){
	$("#tabId1").html();
	let closDate=$(this).data("closDate");
	console.log("closDate"+closDate);
	
	var date = new Date(closDate);

	var formattedDate = date.getFullYear() +
	    ('0' + (date.getMonth() + 1)).slice(-2) +
	    ('0' + date.getDate()).slice(-2);
	console.log(formattedDate); // 출력: 20230101
	getDutyList(1,formattedDate);
	
	
	
});//이번주 업무를 누르면 리스트가 뜨는 함수----------------------


let day= "${day}";
//오늘 업무에서 <를 누르면 나오는 함수-----------------------------
$(document).on("click",".btnMinus",function(){
	console.log("btnminus");
	todayDoList(sessionEmpNo,-1);
});//오늘 할일에서 <를 누르면 나오는 함수 끝-----------------------

//오늘 업무에서 >를 누르면 나오는 함수-----------------------------
$(document).on("click",".btnPlus",function(){
	console.log("btnPlus");
	todayDoList(sessionEmpNo,1);
});//오늘 업무에서 <를 누르면 나오는 함수 끝-----------------------


// 업무 상세 페이지로 들어가는 함수-------------------------------
$(document).on("click",".dutyLists",function(){
	let dutyNo=$(this).data("dutyNo");
	sessionEmpNo
	location.href="/duty/detail?dutyNo="+dutyNo+"&empNo="+sessionEmpNo;

	
});// 업무 상세 페이지로 들어가는 함수 끝--------------------------

//관리자 페이지로 가는 버튼
$(document).on("click",".senderBtn",function(){
	location.href="/duty/sender";
})

	
	
}); //$function 끝


// 받은 업무 리스트 출력-----------------------------------
function getDutyList(currentPage,keyword){


//json 오브젝트
let data = {
    "currentPage": currentPage,
    "keyword":keyword
};

console.log("data : ", data);

$.ajax({
    url: "/duty/getDutyList",
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
      	let tid= "#tabId"+keyword;
		console.log("",result.content[0].empNo);
      	// 목록을 초기화
      	$(tid).html(""); 	
    	if(result.content[0].empNo == null){
    		str = "<p class='heading2'>업무를 찾을 수 없습니다</p>";
    		$("#tabId1").html(str);
    		return;
    	}
 		console.log("result",result);
	    str +="<table class='wf-table'>";
	    str +="<colgroup><col style='width: 8%;'><col style='width: 12%;'>";
	    str +="<col style='width: 35%;'><col style='width: 15%;'>";
	    str +="<col style='width: 15%;'><col style='width: 15%;'>";
	    str +="</colgroup><thead><tr>";
	    str +="<th>번호</th><th>진행상태</th><th>업무제목</th><th>발신자</th><th>수신일자</th><th>마감일자</th>";
	    str +="</tr></thead><tbody>";

        $.each(result.content, function(idx, vo){
        	let position = vo.position;
            let rspnsbl = vo.rspnsbl;
            if (rspnsbl != "팀원") {
                position = rspnsbl;
            }
        	console.log(_prgBadge[vo.prgsRate]);
        	console.log(vo.cnfirmDate);
        	var isNew = vo.cnfirmDate.length != 10 ? "<badge class='wf-badge3'>new</badge>" : "";
			str += "<tr class='dutyLists' data-duty-no='"+vo.dutyNo+"'>";
			str += "<td><p>"+vo.rnum+"</p></td>";
        	str += "<td><span class='"+_prgBadge[vo.prgsRate]+"'>"+_prgName[vo.prgsRate]+"</span></td>";
        	str += "<td><p>"+vo.dutySj+""+isNew+"</p></td>";
        	str += "<td><p>"+vo.empNm+" "+position+"</p></td>";
        	str += "<td><p>"+vo.sendDate+"</p></td>";
        	str += "<td><p>"+vo.closDate+"</p></td></tr>";
        });
           str += "</tbody></table>";
           str += result.pagingArea;
       $(tid).append(str);
   
    }
 });
} //getDutyList 끝--------------------------------------------


// 달력에 데이터 넣을때 쓰는 함수
function calendarData(data) {  
    return data.map(task => {
        var transformedTask = {          
            title: task.prjctNm,
            start: task.prjctBeginDate,
            end: task.prjctEndDate ,
            backgroundColor: getColorCalendar(task.total)
        };
        return transformedTask;
    });
}//달력에 데이터 넣을때 쓰는 함수 끝


//차트에 데이터 넣는 함수
gData = function(empNo) {
	let data ={
		"empNo"	:empNo
		};
      
   $.ajax({
   		url:"/duty/getPieChart",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		dataType:"json",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(res){  
	   		console.log("getPieChart",res);
	        // 차트 렌더링 함수를 호출합니다.
	        renderChart(res);
	       
		}
   });  
}




	// 차트 생성
function renderChart(projectData) {  
	if (!Array.isArray(projectData)) {
    // 배열로 변환
   		projectData = [projectData];
	}
	console.log("projectData",projectData);
	const datasets = projectData.map(project => ({
	    data: [project.prgsRate], // 각 항목의 데이터
	    backgroundColor: getColorByProgress(project.prgsRate), 
	    label: project.prgsCateName // 각 항목의 라벨
	}));
	  const ctx = document.getElementById('myChart').getContext('2d');
	  new Chart(ctx, {
		    type: 'pie',
		    data: {
		        datasets: [{
		            data: projectData.map(project => project.prgsRate),
		            backgroundColor: projectData.map(project => getColorByProgress(project.prgsRate))
		        }],		    
		    	labels: projectData.map(project => project.prgsCateName)
		    },
		    options: {
	            responsive: false,
	            maintainAspectRatio: false, 
	            title: {
	                display: true,
	                text: '프로젝트 진행률' 
		            },
	            //width: 300, 
	            //height: 280,
	            plugins:{
                    legend :{
                        position : 'right'
                    }
                }
		        }
		    });
	};
	
	
	
// 진행률이 낮을수록 빨간색, 높을수록 파란색으로 변화하도록 설정합니다.
function getColorByProgress(progress) {
    const green = Math.floor(255 * (10 - progress) / 10);
    const red = 0;
    const blue = Math.floor(255 * progress / 10);
    return "rgba(" + red + ", " + green + ", " + blue + ", 0.5)"; // 투명도는 0.5로 설정합니다.
}


// 오늘할일 함수---------------------------------------
function todayDoList(sessionEmpNo,keyword){
	let data ={
		"empNo":sessionEmpNo,
		"keyword":keyword,
		
	};
	
	$.ajax({
		url:"/duty/todayDoList",
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
	            str +=`<p class="heading2"> \${res[0].sendDate}  오늘의 업무 </p><br>`;
	        	str += `<ul class="wf-list-style">`;
	        $.each(res, function(idx, vo){
	        	str +=`<li class="style\${idx+1} todayList" data-emp-no="\${vo.empNo}" data-duty-no="\${vo.dutyNo}">\${vo.closTime}시`; 
	        	str +=`<p class="heading2" style="float:right; padding:3px;">\${vo.dutySj}</p></li>`; 

	        })
	        	str +=`</ul>`;
	        $myDay.html(str);    
		}
	   });  
}// 오늘할일 함수 끝-------------------------------------


//이번주 할일 리스트--------------------------------------
function weekDoList(sessionEmpNo){
	let data={
		"empNo":sessionEmpNo	
	};
	$.ajax({
		url:"/duty/weekDoList",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		dataType:"json",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(res){  
	   		console.log("weekDoList",res);
		    let str="";
	   		str +=  `<div class="wf-flex-box between">
						<p class="heading2"> 이번주 업무</p>
						<p>\${res[0].keyword}</p>
					</div>
					<ul class="wf-list-style"><br>`;
		 $.each(res, function(idx, vo){	
			str +=  `<li class="weekList style\${idx+1}"  data-clos-date="\${vo.closDate}">\${vo.closDate} \${vo.weekDay}요일
						<p class="heading2" style="float:right; padding:3px;">\${vo.dutySj}</p></li>`;

		 })
			 str +=`</ul>`;
			 $("#weekDay").html(str);
		}
	   });  

	
}//이번주 할일 리스트 끝--------------------------------------

function insertBtn(){
	rspnsblCd= "<%=session.getAttribute("rspnsblCtgryNm") %>";
	if (rspnsblCd=='본부장' || rspnsblCd=='팀장' || rspnsblCd=='대표이사'){
		console.log("insertBtn"+rspnsblCd);
		let str='';
		str +=`<button type='button' class='btn4 senderBtn'>관리자 페이지</button> `;
		$("#senderBtn").html(str);
	}
	
}


</script>
	
<div class="wf-main-container">
	<!-- =============== body 시작 =============== -->
	<!-- =============== 상단타이틀영역 시작 =============== -->
	<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
		<h1 class="page-tit">업무</h1>
		<div class="side-util">
			<div id="senderBtn"></div>
		</div>
	</div>
	<!-- =============== 상단타이틀영역 끝 =============== -->
	<!-- =============== 컨텐츠 영역 시작 =============== -->
	<div class="wf-content-wrap" data-aos="fade-right">
		
		<!-- 상단영역 시작 -->
		<div class="wf-content-area box3">
			<div class="wf-flex-box" style='height:320px;'>
				<div class="wf-content-box" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
					<p class="heading2" style="margin:0px;">업무 통계</p>
					<canvas id="myChart"></canvas>
				</div>
				<div class="wf-content-box" data-aos="fade-right" data-aos-duration="700" data-aos-delay="400">
					<div id="myDay">
						<p class="heading2">오늘의 업무</p>
					</div>
				</div>

				<div class="wf-content-box" data-aos="fade-right" data-aos-duration="700" data-aos-delay="600">
					<div id="weekDay"></div>
				</div>
			</div>
		</div>
		<!-- 상단영역 끝 -->

		<!-- 하단영역 시작 -->
		<div class="wf-content-area" data-aos="fade-right" data-aos-duration="700" data-aos-delay="800">  

			<div class="tab-type tab-type1">
				<div class="wf-flex-box between">
					<p class="heading1">내 업무함</p>
					<div class="tab-menu">
						<button data-tab="tab1" type="button" class="tab-btn active totalBar">전체</button>
						<button data-tab="tab2" type="button" class="tab-btn" id="ingBar">진행중</button>
						<button data-tab="tab3" type="button" class="tab-btn" id="doneBar">완료</button>
						<div class="tab-indicator"
							style="width: 140px; transform: translateX(0px);"></div>
					</div>
				</div>

				<!-- tab1  -->
				<div data-tab="tab1" class="tab-content active ">
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