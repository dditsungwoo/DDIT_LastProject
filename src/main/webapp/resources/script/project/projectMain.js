
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

	console.log("sessionEmpNo"+sessionEmpNo);
	// 검색버튼을 누르면 실행되는 함수
	/* $("#searchBtn").on("click",function(){
		console.log('searchBtn');
		let cate=$("#cate").val();
		let keyword=$("#searchBox").val();
		
		location.href="/project/projects?cate="+cate+"&keyword="+keyword+";
		
	}); */
		
	
		

	

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
            var team = $(this).val(); 
            console.log(team);
            teams.push(team); 
        });	
        console.log("teams",teams);
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
            		Swal.fire({
            			  title: _msg.common.insertSuccessAlert,
            			  text: "",
            			  icon: "success"
            			});
            	}
            	
            }
       }); //ajax끝
		
		
	})// 메인 프로젝트를 추가하는 버튼 끝----------------------	
	
	
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
            alert("팀원 추가는 5명 이상 불가능합니다");
            return;
        }
        // input 요소를 생성하고 textBoxContainer에 추가합니다.
        var textBox = $('<li><input type="text" class="teams autocomplete" style="margin:3px;"/></li>');
        $('#textBoxContainer').append(textBox);
        
    	$('.autocomplete').autocomplete({
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
	
	   //gantt.init("e7eGantt");
	    
	   //renderChart(projectData);
	   
	    var calendarEl = document.getElementById('calendarBox');
	   	empNo=sessionEmpNo;   
	    var calendar = new FullCalendar.Calendar(calendarEl, {
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
	       
	            var daysRemaining = Math.ceil((endDate - currentDate) / (1000 * 60 * 60 * 24));
	            console.log("daysRemaining"+daysRemaining);
	            if (daysRemaining < 3) {
	            	console.log("3일미만 함수 함수 안"+".dayBadge",this);
	            	$(this).find(".dayBadge").removeClass("wf-badge3").addClass("wf-badge5").html("마감임박");
	            }
	        });
	      
	      
}); //$(function) 끝 
			  
-->
		 

	  
   
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
		            label: '진행률', // 라벨을 '진행률'로 설정
		            backgroundColor: projectData.map(project => getColorByProgress(project.total)), // 진행률에 따라 색상 설정
		            borderWidth: 1,
		            data: projectData.map(project => ({
		                x: project.prjctNm, // x축에 진행률
		                y: project.total // y축에 프로젝트명
		            }))
		        }]
		    },
		    options: {
		        scales: {
		            xAxes: [{
		                scaleLabel: {
		                    display: true,
		                    labelString: 'Progress (%)' // x축의 라벨을 'Progress (%)'로 설정
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
			            str += "<p style='float:right; padding:5px;'>"+res[i].total+"</h4></li><br/><br/>";
			        }
			    }
			    str +="</ul>";
			    $("#sttusBox").html(str);	 
			    }
	   });  	
}    
	 

	  

	

