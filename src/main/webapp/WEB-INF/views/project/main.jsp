<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>	
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/5.10.1/main.js"></script>
 -->

<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">  
<link rel="stylesheet" href="/resources/css/project/main.css"> 
<!-- chart js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

 <!--  fullcalender -->

<link href="/resources/css/fullcalendar.css" rel="stylesheet" />
<script src="/resources/js/fullcalendar.js"></script>
<script src="/resources/js/fullcalendar-ko.js"></script>

<!-- <script src="/resources/script/project/projectMain.js"></script> -->

<script type="text/javascript">
/* let sttus = {
        "1": "대기",
        "2": "진행중",
        "3": "동결",
        "4": "완료"
    }; */
$(()=>{
	let $prjctNm = $("#prjctNm");	
	let $prjctBeginDate = $("#prjctBeginDate");	
	let $prjctEndDate = $("#prjctEndDate");	
	let $prjctDetailCn = $("#prjctDetailCn");
	let $leader = $("#hdnEmpNo");
	//let $team1 = $("#hdnEmpNo1");
	let sessionEmpNo= <%=session.getAttribute("empNo") %>;
	let rspnsblCd= "<%=session.getAttribute("rspnsblCtgryNm") %>";
	console.log("sessionEmpNo"+sessionEmpNo);
	// 검색버튼을 누르면 실행되는 함수
	/* $("#searchBtn").on("click",function(){
		console.log('searchBtn');
		let cate=$("#cate").val();
		let keyword=$("#searchBox").val();
		
		location.href="/project/projects?cate="+cate+"&keyword="+keyword+";
		
	}); */
		
	insertBtn();
	getDoneProjectList(1);
	var elements = document.getElementsByClassName('disabled');
	for (var i = 0; i < elements.length; i++) {
	    elements[i].addEventListener('click', function(event) {
	        event.preventDefault(); // 기본 클릭 동작을 막음
	        event.stopPropagation(); // 이벤트 버블링을 중지시킴
	        // 추가로 필요한 작업 수행 (예: 메시지 출력 등)
	    });
	}

	
	let permission = "${data.content[0].prjctNo}";
	console.log("permission",permission);
/* 	if (permission == null || permission==''){
	    Swal.fire({
	        title: "진행중인 프로젝트가 없습니다.",
	        text: "",
	        icon: "error"
	    }).then((result) => {
	        if (result.isConfirmed) {
	            location.href = "/home";
	        }
	    });
	} */
	
	
	
	
	 let empNo= "<%= session.getAttribute("empNo") %>"; 
	// 메인 프로젝트를 추가하는 버튼--------------------------
	$("#btnCreateProject").on("click",function(){
		let $teams= $(".teams");
		let prjctNm = $prjctNm.val();
		let prjctBeginDate = $prjctBeginDate.val();
		let prjctEndDate = $prjctEndDate.val();
		let prjctDetailCn = $prjctDetailCn.val();
		let leader = $leader.val();
		let teams =[];       
        $teams.each(function() { 
            var team = $(this).data("empno"); 
            console.log(team);
            teams.push(team); 
        });	
        console.log("teams",teams);
        if(prjctNm=="" || prjctEndDate=="" || prjctDetailCn=="" || leader==""){
			Toast.fire({
			  title: _msg.common.fillEmptyFieldsAlert,
			  text: "",
			  icon: "error"
			});
        	return;
        }
        
		let data ={
			"prjctNm":prjctNm,
			"prjctBeginDate":prjctBeginDate,
			"prjctEndDate": prjctEndDate,
			"prjctDetailCn": prjctDetailCn,
			"leader": leader,
			"teams": teams		
		};
		$.ajax({
            type : 'post',
            data: JSON.stringify(data),
            url: '/project/project',
            contentType:"application/json",
            dataType : 'json',
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
            success : function(res) {
            	console.log("/projectcreate"+res);
            	if (res>0){
            		   $("#modal-createProject").removeClass('open');
            	       $('html').removeClass('scroll-hidden');
            		Toast.fire({
            			  title: _msg.common.insertSuccessAlert,
            			  text: "",
            			  icon: "success"
            			});
            		location.reload();
            	}
            	
            }
       }); //ajax끝
		
		
	})// 메인 프로젝트를 추가하는 버튼 끝----------------------	
	
	
	
	//자동완성 버튼 함수------------------------------------
	$("#btnAutoTyping").on("click",function(){
		$("#prjctNm").val("그룹웨어 개발");
		$("#prjctBeginDate").val("2024-04-10");
		$("#prjctEndDate").val("2024-04-20");
		$("#leader").val("유선영");
		$("#hdnEmpNo").val("2020015");
		$("#team1").val("김대덕");
		$("#team1").data("empno","2019202");
		$("#prjctDetailCn").val("WORKFOREST 그룹웨어 개발");
		
		
		
		
		
		
		
	});//자동완성 버튼 함수끝--------------------------------
	
	
	
	// 상세 일감으로 들어가는 함수---------------------------
	$(document).on("click",".prjctList", function() {
	   
		let pNo = $(this).data("prjctNo"); // 선택한 요소의 데이터 속성을 가져옵니다.
	    console.log(pNo);
		location.href="project/"+pNo;
	});	// 상세 일감으로 들어가는 함수 끝---------------
	
	 
	
	
	 //텍스트박스가 추가되는 버튼---------------------
	$(".xi-plus").on("click",function(){ 
        var textBoxCount = $('#textBoxContainer input[type="text"]').length;
        if (textBoxCount >= 5) {
        	Toast.fire({
     			  title: "팀원 추가는 5명이상 불가능합니다!",     			  
     			  icon: "error"
     		});
            return;
        }
        // input 요소를 생성하고 textBoxContainer에 추가합니다.
        var textBox = $('<li><input type="text" class="teams autocomplete" value="" style="margin:3px;"/></li>');
        $('#textBoxContainer').append(textBox);
        
    	$('.teams').autocomplete({
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
                console.log("select시 :"+this);
                console.log("select시 :"+".teams",this);
                console.log("ui.item.label ",ui.item.label);
                console.log("ui.item.value ",ui.item.value);
               // $("#hdnEmpNo").val(ui.item.empNo);
               // console.log("empno발 위치"+ $("#hdnEmpNo").val());
               
            },
            focus : function(event, ui) {
                return false;
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
	});//텍스트박스가 추가되는 버튼 끝----------------
	
	//리더 명 자동완성
		$(document).on("focus", "input[class='autocomplete']", function(e) {
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
            console.log("leader 자동완성", this);
            console.log("leader 자동완성", ".teams",this);
            console.log("ui.item.label ",ui.item.label);
            console.log("ui.item.value ",ui.item.value);
            $("#hdnEmpNo").val(ui.item.empNo);
            console.log("empno발 위치"+ $("#hdnEmpNo").val());
      
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
        	$("#ui-id-1").remove();
            console.log(event);
            
        }
    });
	}// autocomplete 끝
	});
     
		//팀원명 자동완성
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
        
            console.log("teams시 :",this);

	        $(this).val(ui.item.empNo);
	        $(this).data("empno",ui.item.empNo);
	       
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
	    	$("#ui-id-1").remove();
	        console.log(event);
	        
	    }
	});
	}// autocomplete 끝
	});     	
        	
        	
        	
	   gData(sessionEmpNo);
	   //gantt.init("e7eGantt");
	    
	   //renderChart(projectData);
	   
	    var calendarEl = document.getElementById('calendarBox');
	   	empNo=sessionEmpNo;   
	    var calendar = new FullCalendar.Calendar(calendarEl, {
	        headerToolbar: {
	       		left: 'title', // 왼쪽에는 제목만 표시하도록 설정
	    	    center: '',
	    	    right: 'prev,next today' // 오른쪽에는 이전/다음 버튼과 오늘 버튼 표시
	    	 },
	    	locale: 'ko',
	    	initialView: 'dayGridMonth',
	    	aspectRatio: 1.5 ,
	        events: function(etchInfo, successCallback, failureCallback){
	        	data ={
	        		"empNo"	:empNo
	        	};
	        	 $.ajax({
	        		   	url:"/project/allProjectProgress2",
	        				data:JSON.stringify(data),
	        				contentType:"application/json;charset=utf-8",
	        				type:"post",
	        				dataType:"json",
	        				beforeSend:function(xhr){
	        					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
	        				},
	        				success:function(res){  
	        			   		let calendar=calendarData(res);
	        			   		console.log("allProjectProgress",res);	   	 
	        			   		
	        			   		successCallback(calendar);

	        			   		
	        				}
	        		   }); 
	
	        },
	        
	        eventContent: function(info) {
	        	   return {
	                   html: '<div>' + info.event.title + ' - 종료일자 :  ' + info.event.endStr + '</div>', // 이벤트의 title과 종료 날짜를 표시
	                 
	        	   };
	        },
	        eventRender: function(info) {
	        	 info.el.style.border = 'none'; // border를 없애기 위해 투명색으로 설정
	        }
	      });

	      calendar.render();
	     $(".fc-toolbar-title").append(" 프로젝트 진행상황");
	     $(".fc-toolbar-title").css("font-size","17px");
	      countProjectSttus(sessionEmpNo);	
	      calendarEl.style.width = '560px';
	      calendarEl.style.height = '340px';
	      
	        var currentDate = new Date(); 
	        //만약 3일 미만으로 남았으면 테두리를 빨간색으로 하는 함수
	        $(".prjctList").each(function() {
	        	console.log("3일미만 함수",this);
	            // 각 행의 enddate 값을 가져옵니다.
	            var endDateStr = $(this).find(".endDate").data("endDate");
	            
	            var endDate = new Date(endDateStr);
	       		var sttusCd= $(this).find(".dayBadge")[0].classList.contains("wf-badge4");
	            var daysRemaining = Math.ceil((endDate - currentDate) / (1000 * 60 * 60 * 24));
	            console.log("daysRemaining"+daysRemaining);
	            console.log("daysRemaining"+sttusCd);
	            if (daysRemaining < 3 && !sttusCd) {
	            	console.log("3일미만 함수 함수 안"+".dayBadge",this);
	            	
	            	$(this).find(".dayBadge").removeClass("wf-badge3").addClass("wf-badge5").html("마감임박");
	            }
	        });
	      
       
       var beginDateInput = document.getElementById('prjctBeginDate');
       var endDateInput = document.getElementById('prjctEndDate');

       // 종료일 입력 요소에 이벤트 리스너 추가
       endDateInput.addEventListener('change', function() {
           // 시작일과 종료일 값 가져오기
           var beginDate = new Date(beginDateInput.value);
           var endDate = new Date(endDateInput.value);
      
           if (endDate < beginDate) {
        	   Swal.fire({
     			  title: _msg.reservation.formDateErrorAlert,
     			  text: "",
     			  icon: "error"
     			});
               endDateInput.value = '';
           }
       });	        
     
}); //$(function) 끝 
			  
	
		 

	  
   
function transformData(data) {  
    return data.map(task => {
        var transformedTask = {
            id: task.prjctNo,
            text: task.prjctNm,
            start_date: task.prjctBeginDate,
            end_date: task.prjctEndDate,
            duration : 3
        };
        return transformedTask;
    });
}

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
}


gData = function(empNo) {
	let data ={
		"empNo"	:empNo
		};
      
   $.ajax({
   	url:"/project/allProjectProgress",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		dataType:"json",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(res){  
	   		console.log("allProjectProgress",res);
	   	 

	        // 차트 렌더링 함수를 호출합니다.
	        renderChart(res);
	       
		}
   });  
}




function renderChart(projectData) {  
	// 차트 생성
	if (!Array.isArray(projectData)) {
    // 배열로 변환
   		projectData = [projectData];
	}
	console.log("projectData",projectData);
	console.log("projectData"+projectData);
	  const ctx = document.getElementById('myChart').getContext('2d');
	  console.log("배경색"+projectData.map(project =>getColorByProgress(project.total)));
	  new Chart(ctx, {
		    type: 'bar',
		    data: {
		        labels: projectData.map(project => project.prjctNm), // 프로젝트명을 라벨로 사용
		        datasets: [{
		            label: '진행률', 
		            backgroundColor: projectData.map(project => getColorByProgress(project.total)), // 진행률에 따라 색상 설정
		            borderWidth: 1,
		            data: projectData.map(project => ({
		                x: project.prjctNm, // x축에 진행률
		                y: project.total // y축에 프로젝트명
		            }))
		        }]
		    },
		    options: {
		    	scaleShowLabels: false,
		        legend: {
		        	display: false // 막대기의 라벨을 표시하지 않음
		        },
		        title: {
	                display: true,
	                text: '프로젝트 진행률'
	            },
		        scales: {
		            xAxes: [{
		                scaleLabel: {
		                    display: true,
		                    labelString: 'Progress (%)' // x축의 라벨을 'Progress (%)'로 설정
		                },
	                    ticks: {
	                        display: false // x축의 눈금 표시하지 않음
	                    }
	                }],
	                
		            yAxes: [{
		                scaleLabel: {
		                    display: true,
		                    labelString: 'Project Name' // y축의 라벨을 'Project Name'으로 설정
		                }
		            }]
		        }
		    }
		});
	};
	
	
	  
	// 진행률에 따라 색상을 반환하는 함수
function getColorByProgress(progress) {
    // 진행률이 높을수록 파란색에 가까운 색을 반환합니다.
       const red = Math.floor(255 * (100 - progress) / 100);
    const green = 0;
    const blue = Math.floor(255 * progress / 100);
    return "rgba(" + red + ", " + green + ", " + blue + ", 0.5)"; // 투명도는 0.5로 설정합니다.
}
	
    // 달력의 색을 조절합니다
function getColorCalendar(progress) {
    const green = Math.floor(255 * (100 - progress) / 100);
    const red= 0;
    const blue = Math.floor(255 * progress / 100);
    return "rgba(" + red + ", " + green + ", " + blue + ", 0.5)"; // 투명도는 0.5로 설정합니다.
}


function countProjectSttus(empNo){
	let data ={
			"empNo"	:empNo
			};
      
	   $.ajax({
	   	url:"/project/countProjectSttus",
			data:JSON.stringify(data),
			contentType:"application/json;charset=utf-8",
			type:"post",
			dataType:"json",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success:function(res){
				console.log("여기입니다",res);
					let str="<ul class='wf-list-style'>";
			    for (let i = 0; i <res.length; i++) {
			        if (res[i].prjctSttusCd!=null) {
			            console.log("i번째",res[i].prjctSttusCd );
			        	str += "<li class='style"+res[i].rnum+"'><h4>"+res[i].prjctSttusCd+"";
			            str += "<p style='float:right; padding:5px; font-size:27px;'>"+res[i].total+"</h4></li><br/><br/>";
			        }
			    }
			    str +="</ul>";
			    $("#sttusBox").html(str);	 
			    }
	   });  	
}    
	 

	  
function insertBtn(){
	rspnsblCd= "<%=session.getAttribute("rspnsblCtgryNm") %>";
		console.log("insertBtn"+rspnsblCd);
	if (rspnsblCd=='팀원'){
		let str='';
		$(".projectCreate").css('display','none');
	}
	
}

function getDoneProjectList(currentPage){
	sessionEmpNo= "<%=session.getAttribute("empNo") %>";
	let data={
		empNo:sessionEmpNo,
		currentPage:currentPage
	};
	  $.ajax({
		   	url:"/project/getDoneProjectList",
				data:JSON.stringify(data),
				contentType:"application/json;charset=utf-8",
				type:"post",
				dataType:"json",
				beforeSend:function(xhr){
					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
				},
				success:function(res){
					console.log("getDoneProjectList",res.content);
					$("#projectDoneList").html("");
					let str="";
					str+=`<table class="wf-table">
							<colgroup>				
								<col style="width: 10%;">
								<col style="width: 10%;">
								<col style="width: 30%;">
								<col style="width: 20%;">
								<col style="width: 35%;">				
							</colgroup>
							<thead>
								<tr>
									<th>번호</th>
									<th>진행상태</th>
									<th>프로젝트명</th>
									<th>진행일자</th>
									<th>내용</th>					
								</tr>
							</thead>
							<tbody>`;
						     $.each(res.content, function(idx, vo){
								str+=`<tr class="prjctList" data-prjct-no="\${vo.prjctNo}">
									<td>
										<p>
											<p>\${vo.rnum } </p>
										</p>
									</td>
									<td>
										<p>
											 <span class="dayBadge wf-badge\${vo.prjctSttusCd }">\${vo.empNm } </span>
										</p>
									</td>
									<td>
										<p>\${vo.prjctNm}</p>
									</td>
									<td>
										<p class='endDate' data-end-date='\${vo.prjctEndDate}'>\${vo.prjctBeginDate} ~ \${vo.prjctEndDate}</p>
									</td>
									<td>
										<p>\${vo.prjctDetailCn}</p>
									</td>										
								</tr>`;
						     });
					str+=		`</tbody>
						</table>`;
					str+=`\${res.pagingArea }`;
					$("#projectDoneList").html(str);
				}
				
	  });
}	

</script>

<div class="wf-main-container">
	<!-- =============== body 시작 =============== -->
	<!-- =============== 상단타이틀영역 시작 =============== -->
	<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
		<h1 class="page-tit">프로젝트</h1>
		<div class="side-util">
			<button type="button" class="btn2 projectCreate" modal-id="modal-createProject">프로젝트 등록</button>
		</div>
	</div>
	<!-- =============== 상단타이틀영역 끝 =============== -->
	<!-- =============== 컨텐츠 영역 시작 =============== -->
	<div class="wf-content-wrap">
		<div class="wf-content-area">
		<div class="wf-flex-box">
                                <div class="wf-content-box" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
                                    <p class="box-heading1" >프로젝트 상태</p><br/><br/>
                             			<div id='sttusBox'></div>                               
                             		
                                </div>
                                <div class="wf-content-box" id ="ganttBox" data-aos="fade-right" data-aos-duration="700" data-aos-delay="400"><span class='box-heading1'>프로젝트 진행률</span>
                               		<canvas id="myChart" style="width: 680px; height: 300px;"></canvas>
                                </div>   
                                <div class="wf-content-box" style="height: 350px;" data-aos="fade-right" data-aos-duration="700" data-aos-delay="600">
    								<div id="calendarBox" style="width: 560px; height: 340px;"></div>
								</div>                                                     
                            </div>
                            </br></br>
			<div class="tab-type tab-type1" data-aos="fade-right" data-aos-duration="700" data-aos-delay="800">
			<!-- style="height:41px;" -->
			<div class="wf-flex-box between" style="height:38px;">
				<p class="heading2">내 프로젝트</p>
					<div class="tab-menu">			
						<button data-tab="tab1" type="button" class="tab-btn" id="ingBar">진행중</button>
						<button data-tab="tab2" type="button" class="tab-btn" id="doneBar">완료</button>
						<div class="tab-indicator"
						style="width: 140px; transform: translateX(0px);">
						</div>
					</div>
				</div>
				
				<div data-tab="tab1" class="tab-content active ">
				<div class="tab-board-lst">
				<table class="wf-table">
				<colgroup>				
					<col style="width: 10%;">
					<col style="width: 10%;">
					<col style="width: 30%;">
					<col style="width: 20%;">
					<col style="width: 35%;">				
				</colgroup>
				<thead>
					<tr>
						<th>번호</th>
						<th>진행상태</th>
						<th>프로젝트명</th>
						<th>진행일자</th>
						<th>내용</th>					
					</tr>
				</thead>
				<tbody>
				<c:forEach var="vo" items="${data.content }" >
					<tr class="prjctList" data-prjct-no="${vo.prjctNo}">
										
						<td>
							<p>
								<p>${vo.rnum } </p>
							</p>
						</td>
						<td>
							<p>
								 <span class="dayBadge wf-badge${vo.prjctSttusCd }">${vo.empNm } </span>
							</p>
						</td>
						<td>
							<p>${vo.prjctNm}</p>
						</td>
						<td>
							<p class='endDate' data-end-date='${vo.prjctEndDate}'>${vo.prjctBeginDate} ~ ${vo.prjctEndDate}</p>
						</td>
						<td>
							<p>${vo.prjctDetailCn}</p>
						</td>
							
					</tr>
					</c:forEach>
				</tbody>
			</table>
		 ${data.getPagingArea() }
	</div>
	</div>
	<div data-tab="tab2" class="tab-content">
		<div id="projectDoneList"></div>
	<div class="tab-board-lst">
	</div>
	</div>
		 
		</div>
	</div>
</div>
</div>


		<!-- 검색영역 시작 -->
	    <!--<div class="wf-search-area">
			<div class="select-box">
				<select name="cate" id="cate">
					<option value="prjctNm">프로젝트명</option>
					<option value="prjctSttus">상태</option>
					<option value="detailCn">내용</option>
				</select>
			</div>
			<input type="text" id='searchBox' placeholder="검색할 내용을 입력해주세요">
			<button type="button" class="btn4" id='searchBtn'>
				<i class="xi-search"></i>
			</button>
		</div> -->
		<!-- 검색영역 끝 -->
	</div>
	
	<!-- =============== 컨텐츠 영역 끝 =============== -->
	<!-- =============== body 끝 =============== -->
</div>

<!-- ==============create 모달 시작===============   -->
<div class="modal" id="modal-createProject"> 
    <div class="modal-cont">
        <h1 class="modal-tit">프로젝트 생성</h1>
        <div class="modal-content-area">
            <form action="" method="">
                <ul class="wf-insert-form2">
 
                    <li>
                        <label for="prjctNm">프로젝트명<i class="i">*</i></label>
                        <div>
                            <input type="text" id="prjctNm" name="prjctNm" placeholder="텍스트를 입력해주세요" required >
                        </div>
                    </li>
					<li></li>
                    <li>
                        <label for="prjctBeginDate">시작일</label>
                        <div>
                            <input type="date" id="prjctBeginDate" name="prjctBeginDate">
                        </div>
                    </li>
                    <li>
                        <label for="prjctEndDate">종료일</label>
                        <div>
                            <input type="date" id="prjctEndDate" name="prjctEndDate">
                        </div>
                    </li>
                    <li>
                        <label for="leader">리더 명</label>
                        <div>
                            <input type="text" id="leader" class="autocomplete" placeholder="텍스트를 입력해주세요" required >
                        	<input type="hidden" id="hdnEmpNo"/>
                        	<input type="hidden" id="hdnEmpNo1"/>
                        </div>
                    </li>
                    <li>
                        <label for="team1">팀원 <i class="xi-plus xi-2x" style="position: absolute; top: 275px; right: 50px;"></i></label> 
                        <div>
                            <input type="text" id="team1"  class="autocomplete teams" placeholder="텍스트를 입력해주세요">
                        </div>
                    </li>
          
                    <li>
                        	상세 내용<i class="i">*</i>
                        <div>
                            <textarea name="prjctDetailCn" id="prjctDetailCn" required ></textarea>
                        </div>
                    </li>
                    <li>
                    	<div id="textBoxContainer">
                    	
                    	</div>
                    </li>
                </ul>

            </form>
        </div>

        <div class="modal-btn-wrap">
            <button class="btn6">취소</button>
            <button class="btn2" id="btnCreateProject">저장</button>
            <button class="btn5" id="btnAutoTyping">자동완성</button>
        </div>

        <button class="close-btn"></button>
    </div>
</div>
<!-- ==============create 모달 끝===============   -->


