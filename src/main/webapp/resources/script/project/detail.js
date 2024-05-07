
let $boxes= $(".boxes");
let $readyBox= $("#readyBox");
let $deleteBox= $("#deleteBox");
let $ingBox= $("#ingBox");
let $doneBox= $("#doneBox");
let prjctNo= "${prjctNo}";
let data ={
		"prjctNo":prjctNo	
};
let str="";
let _prgRate={
	0:"대기중",
	1:"시작",
	2:"시작",
	3:"진행중",
	4:"진행중",
	5:"진행중",
	6:"진행중",
	7:"진행중",
	8:"진행중",
	9:"거의 완료",
	10:"완료"
}

$(()=>{
	
	
	//간트 페이지로 가는 함수
	$("#toGantt").on("click",function(){
		location.href="/project/gantt/"+prjctNo;
	});
	
		//하위 모달의 hover시에 데이터 나오는 함수 
		$(document).on("mouseenter", ".duties", function() {
	    var pThis = $(this).data("pdno");
	    console.log("hover 함수"+pThis);
	    var data = {
	        prjctDutyNo: pThis
	    };
	    
	    $.ajax({
	        url: "/project/getEmpImage",
	        data: JSON.stringify(data),
	        contentType: "application/json;charset=utf-8",
	        type: "post",
	        beforeSend: function(xhr) {
	            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
	        },
	        success: (res)=> {
	        	var imgSrc = '/resources/img/icon/' + res[0].atchmnflNo;
	            console.log("success empName",res[0]);
	            var empName = res[0].empNm;
	            var dayLeft = res[0].prjctEndDate;
	            console.log("success empName",res[0].empNm);
	            
	            var title = "<div class='img-wrap'>";
	            	title +=  "<img src='" + imgSrc + "'>" ;
	            	title +=  "<p>" + empName + "</p>";
	            	title +=  "<p>마감까지 남은 일자 : " + dayLeft + "일</p>";
	            	title += "</div>";	
	            	console.log("success 함수 안"+title);	
	            $(this).tooltip({
	                title: title,
	                html: true 
	            }).tooltip("show");
	        }
	    });
		}).on("mouseleave click drag", ".duties", function() {
	    $(this).tooltip("hide"); 
	    
	    
	});
			
	
 
       
	//------- 모달창 내에서 수정 확정버튼을 눌렀을때 나오는 함수 -------------
	$(document).on("click","#btnModifyConfirm",function(){
		 let cempNo= $("#hdnEmpNo").html();
		 let cdetailCn=$("#mdetailCn").val();
		 let cprjctDutyNo=$("#mprjctDutyNo").data("dutyNo");
		 let cprgsRate= $("#progressBar").val();
		 let cdutySj=$("#mdutySj").val();
		 let uploadFile =$("#uploadFile").val();
		 //let cprjctEndDate=$("#mprjctEndDate").data("endDate");
		 let cprjctEndDate=$("#mprjctEndDate").val();
		 console.log("cempNo"+cempNo);
		 console.log("uploadFile"+uploadFile);			
		 //$("#uploadForm").submit();
		 let data={
			 "empNo":cempNo,
			 "prjctEndDate":cprjctEndDate,
			 "dutySj":cdutySj,
			 "detailCn":cdetailCn,
			 "prgsRate":(cprgsRate*10),
			 "prjctDutyNo":cprjctDutyNo
		 };
	
		 $.ajax({
			type : 'post',
        	data: JSON.stringify(data),
           	url: '/project/updateDuty',
            //processData: false,
            //contentType: false,
            contentType:"application/json",
		    dataType : 'json',
    		beforeSend:function(xhr){
    		xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
    			},
    		success:function(res){
    			console.log("updateDuty : ",res);
    			if(res>0){
             		Swal.fire({
          			  title: _msg.common.insertSuccessAlert,
          			  text: "",
          			  icon: "success"
          			});
             		location.reload();
    			}
    		}	
    			
		 });
		 
	});//------- 모달창 내에서 수정 확정버튼을 눌렀을때 나오는 함수 끝 -------------
		

		
	//-------모달 창 내에서 수정을 눌렀을때 나오는 함수--------------------
	$(document).on("click","#btnModify",function(){
		let mprjctDutyNo=$("#mprjctDutyNo").data("dutyNo");
		let mprgsRate= $("#mprgsRate").data("prgsRate");
		let mdetailCn=$("#mdetailCn").html();
		let mdutySj=$("#mdutySj").html();
		let mprjctEndDate=$("#mprjctEndDate").data("endDate");
		let mprjctBeginDate=$("#mprjctEndDate").data("beginDate");
		//let mempNo=$("#mempNo").html();
		let mempNo= $("#hdnEmpNo").val();
		let mempNm=$("#mempName").val();

		console.log("1 :"+mprjctDutyNo);
		console.log("2 :"+mprgsRate);
		console.log("3 :"+mdetailCn);
		console.log("4 :"+mdutySj);
		console.log("5 :"+mprjctEndDate);
		str="";
		str+="<div class='wf-flex-fbox center' id='mprjctDutyNo'  data-duty-no='"+mprjctDutyNo+"'>";
		str+="<h1><input type='text' class='modal-tit' id ='mdutySj'  value='"+mdutySj+"'></input></h1>";		
		str+="<h4>진행률</h4>";
		str+="<ul class='wf-insert-form' >";	
		str+="<input type='range' id='progressBar' min='0' max='0.9' step='0.1'  value='"+mprgsRate+"' style='width:40%;'>";
		str+="</div>";
		str+="<div class='modal-content-area'>";
		str+="<div class='wf-grid-box'>";
		str+="<ul class='wf-insert-form2 vertical detail'>";
		str+="<li>";
		str+="<div class='wf-work-detail-info'>";
		str+="<div class='wf-worker'>";	
		
		str+="<input type='text' class='txt autocomplete' id='mempName'  value='"+mempNo+"' required/>";
		str+="</div><br>";
		str+="<span>종료일  설정&nbsp;&nbsp;</span>";
		str+="<input type='date' class='date' id='mprjctEndDate'  data-end-date='"+mprjctEndDate+"' data-begin-date='"+mprjctBeginDate+"' >"+mprjctBeginDate+" ~</div>";
		str+="</div>";
		str+="</li>";
		str+="<li>";
		str+="<div class='wf-work-detail-cont'>";
		str+="<textarea id='mdetailCn' >"+mdetailCn+"</textarea>";
		str+="</div>";
		str+="</li>";
		str+="</ul>";
		str+="</div>";
		str+="<div class='modal-btn-wrap'>";
		//str+="<form id='uploadForm' enctype='multipart/form-data' action='/project/updateDuty?${_csrf.parameterName}=${_csrf.token}' method='post'>";
		str+="<input type='file' id='uploadFile' name='uploadFile' style='display: none;' multiple>";
		str+="<label for='uploadFile' class='btn5'><i class='xi-attachment'></i>업로드</label>"
		str+="<button class='btn2' id ='btnModifyConfirm'>수정</button>";
		//str+="<sec:csrfInput />";
		//str+="</form>";		
		str+="</ul>";
		str+="<button class='btn3'>삭제</button>";
		str+="</div>";
		str+="<button class='close-btn'></button>";
		str+="<div id='hdnEmpNo'style='display:none;' value='"+mempNo+"'></div>";
		str+="</div>";
		$("#duty-modal-area").html(str);
		
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
		            $("#hdnEmpNo").html(ui.item.empNo);
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
		    }); //자동완성 끝
		
			
	});//--------------모달 창 내에서 수정을 눌렀을때 나오는 함수 끝------------------


	
	// 프로젝트 하위 상세를 눌렀을때 함수
	$(document).on("click",".duties",function(){
		  pdno= $(".duties",this).prevObject.data("pdno");
		  console.log("pdno는 ",$(".duties",this));
		  console.log("pdno는 "+pdno);
		  getDutyModal(pdno);
		  $('.duties').click(modal);
	})


	
	// 일감 생성 버튼을 눌렀을때 함수
	$(".addDuty").on("click",function(){
		let dutyNumber=$("#readyBox").find(".duties");
		if (dutyNumber.length >=6){
			Swal.fire({
    			  title: "한 곳에 6개이상 생성 불가능합니다!",
    			  text: "",
    			  icon: "error"
    			});
			return;
		}
		prjctNo= "${prjctNo}";
		data ={
			"prjctNo":prjctNo	
		};
		$.ajax({
			url:"/project/addDuty",
			data:JSON.stringify(data),
			contentType:"application/json;charset=utf-8",
			type:"post",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success: function(res){
				console.log("add ",res);
				location.reload();
				
			}
		})//ajax 끝
		
	});// 일감 생성 버튼 함수 끝


	//리스트를 보여주는 함수
	$.ajax({
		url:"/project/getProjectDuty",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success: function(res){
			console.log("리스트" +res);					
			 res.forEach(function(item) {
			        var prgsRate = item.prgsRate;
			        var dutySj = item.dutySj;
			        
			        console.log("리스트" ,$readyBox);
			      	str="";
			        if (prgsRate === 0) {
			       		str +="<div class='wf-content-box duties draggable' data-pdno='"+item.prjctDutyNo+"'";
			       		str += " modal-id='modal-project-duty'>";
			      	    str +="<p class='box-heading1'>"+dutySj+"</p>";
			      	    str +="<ul class='wf-list-style'>";
			      	    str +="<li class='style1'>"+item.detailCn+"</li>";   
			      	    str +="</ul></div>";
			      	    $("#readyBox").append(str);
			      	    
			        } else if (prgsRate === 10 ) {
			       		str +="<div class='wf-content-box duties draggable' data-pdno='"+item.prjctDutyNo+"'";
			       		str += " modal-id='modal-project-duty'>";
			      	    str +="<p class='box-heading1'>"+dutySj+"</p>";
			      	    str +="<ul class='wf-list-style'>";
			      	    str +="<li class='style1'>"+item.detailCn+"</li>";   
			      	    str +="</ul></div>";
			      	    $("#doneBox").append(str);
			        } else {
			       		str +="<div class='wf-content-box duties draggable' data-pdno='"+item.prjctDutyNo+"'";
			       		str += " modal-id='modal-project-duty'>";
			      	    str +="<p class='box-heading1'>"+dutySj+"</p>";
			      	    str +="<ul class='wf-list-style'>";
			      	    str +="<li class='style1'>"+item.detailCn+"</li>";   
			      	    str +="</ul></div>";
			      	    $("#ingBox").append(str);
			        }
			        		
			        //임박한 날짜를 계산 
			        //var beginDate = new Date(item.prjctBeginDate);
			        var beginDate = new Date(item.prjctBeginDate);
			        var endDate = new Date(item.prjctEndDate);			     
			        var timeDiff = Math.abs(endDate.getTime() - beginDate.getTime());
			        var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24)); 
			        
			      if((diffDays)<3){
			    	  $(".duties[data-pdno='"+item.prjctDutyNo+"']").css("border", "1px solid #FFA07A");
			    	
			      }
			     
			
			 })
		$('.draggable').draggable();
		$("#prjctTitle").html(res[0].text+" (종료일 : "+res[0].endDate+")");	 
		},
		error :function(xhr){
			console.log("에러" +xhr.status);
		}
	})// 리스트를 보여주는 함수 끝
	
	//드래그 한 일감들이 놓였을때 함수
	$('.droppable').droppable({ 
		drop: function(event,ui){
			var id = $(this).attr('id');
			let pdno= ui.draggable.data("pdno");
			
			let base=$(".droppable",this).prevObject;
			console.log("여기",$(".droppable",this));
			console.log("$('.droppable',this).prevObject : ",base);
			console.log("this 찍히는: ",this);
			console.log("ui.draggable: ",ui.draggable);
			let target=$(ui.draggable);
			if (id == 'readyBox') {
				 updateProgress(pdno,0);
				
		   	} else if (id == 'ingBox') {       
	   			updateProgress(pdno,5);
		       
		    } else if (id == 'doneBox') {
		    	updateProgress(pdno,10);
				
		    }else{
		    	deleteDuties(pdno);
				target.remove();		    
		    }
		//this.append("",target);  
			getProgress();
		},
		out:function(event,ui){		
	
			//console.log("event",event);
			//console.log("ui",ui);
		}
	});
	
	getProgress();
	
}) //$ function 끝

	//진행도를 계산하는 함수
let getProgress = function(){
	let prjctNo= "${prjctNo}";
	let data ={
			"prjctNo":prjctNo	
	};
	$.ajax({
		url:"/project/getProgress",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(res){
			console.log("진행도 : "+res);
			$(".progressBar").css("width",res+"%");
			$(".progressPercent").html(res+"%");
		}
		
	})
}; //진행도를 계산하는 함수 끝

//각자의 진행률 업데이트 하는 함수
function updateProgress(pdno,prgsRate){
	
	console.log("일감 번호",pdno);
	data={
		"prjctDutyNo":pdno,
		"prgsRate": prgsRate
	};
	$.ajax({
		url:"/project/updateProgress",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(res){
			console.log("업데이트 완료 : "+res);
			
		}
		
	})
}; //진행도를 업데이트하는 함수 끝

	//일감을 삭제하는 함수
function deleteDuties(pdno){	
	console.log("일감 번호",pdno);
	data={
		"prjctDutyNo":pdno		
	};
	$.ajax({
		url:"/project/deleteDuties",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(res){
			console.log("삭제 완료 : "+res);
			Swal.fire({
    			  title: _msg.common.deleteSuccessAlert,
    			  text: "",
    			  icon: "error"
    			});
			getProgress();
			
		}
		
	})
}




//상세 모달창을 보여주는 함수
function getDutyModal(pdno){
		let data={
			"prjctDutyNo":pdno
			
		} 
		
		$.ajax({
			url:"/project/getDutyModal",
			data:JSON.stringify(data),
			contentType:"application/json;charset=utf-8",
			type:"post",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success: function(res){
				console.log("resajax : ",res);
				console.log("resajax : ",res.empNo);
				
				
				var empName = res.empNm;
			   
				console.log("empName"+empName);
			   	if (empName == null) {
				    empName = "담당자 필요";
				}
				str="";
				str+="<div class='wf-flex-fbox center' id='mprjctDutyNo' data-duty-no='"+res.prjctDutyNo+"'>";
				str+="<div class='img-wrap' style='float:center;' >";
				str+="<img src='/resources/img/"+res.atchmnflNo+"' style='height:250px; width:250px' >";
				str+="</div>";
				str+="<h1 class='modal-tit' id ='mdutySj'>"+res.dutySj+"</h1>";
				str+="<span class='wf-badge1' id='mprgsRate'  data-prgs-rate='"+res.prgsRate+"'>"+_prgRate[res.prgsRate]+"</span>";
				str+="</div>";
				str+="<div class='modal-content-area'>";
				str+="<div class='wf-grid-box'>";
				str+="<ul class='wf-insert-form2 vertical detail'>";
				str+="<li>";
				str+="<div class='wf-work-detail-info'>";
				str+="<div class='wf-worker'>";
				str+="<div class='img-lst'>";
				str+="<div class='img-wrap'>";
				str+="<img src='/resources/img/icon/"+res.proflImageUrl+"'>";
				str+="</div>";
				str+="<span class='txt' id='mempNo'  >"+empName+" </span>";
				str+="</div>";
				str+="</div>";
				str+="<div class='date' id='mprjctEndDate' data-end-date='"+res.prjctEndDate+"' data-begin-date='"+res.prjctBeginDate+"'>"+res.prjctBeginDate+" ~ "+res.prjctEndDate+"</div>";
				str+="<div id='hdnEmpNo'style='display:none;' value='"+res.empNo+"'></div>";
				str+="</div>";
				str+="</li>";
				str+="<li>";
				str+="<div class='wf-work-detail-cont'>";
				str+="<p id='mdetailCn'>"+res.detailCn+"</p>";
				str+="</div>";
				str+="</li>";
				str+="</ul>";
				str+="<div class='comment-area'>";
				str+="<ul>";
				str+="<li>";
				str+="<div class='no-data'>";
				str+="<span>등록된 댓글이 없습니다.</span>";
				str+="</div>";
				str+="</li> ";                 
				str+="</ul>";
				str+="<div class='input-wrap'>";
				str+="<span class='user-thumb'>";
				str+="<img src='/img/icon/avatar.png' alt='예시이미지'>";
				str+="</span>";
				str+="<input type='text' placeholder='댓글을 입력하세요'>";
				str+="<button class='btn4'>등록</button>";
				str+="</div>";
				str+="</div>";
				str+="</div>";
				str+="</div>";
				str+="<div class='modal-btn-wrap'>";
				str+="<button class='btn4' id ='btnModify'>수정</button>";
			
				str+="</div>";
				str+="<button class='close-btn'></button>";
				str+="</div>";
				$("#duty-modal-area").html(str);
			}
		})
	  
	};//상세 모달창을 보여주는 함수 끝

// 사원번호로 이름을 가져오는 함수
 function getNameByEmpNo(empno) {
    let data = {
        "empNo": empno
    };
    try {
        	response =  $.ajax({
            url: "/project/getNameByEmpNo",
            data: JSON.stringify(data),
            contentType: "application/json;charset=utf-8",
            type: "post",
            beforeSend: function (xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            }
        });
        console.log(response.empNm);
        return response.empNm;
    } catch (error) {
        console.error("Error:", error);
        return null; // 예외 발생 시에는 null을 반환하거나 다른 처리를 할 수 있습니다.
    }
}// 사원번호로 이름을 가져오는 함수 끝

//hover시에 프로젝트 사원의 정보가 나오는 함수
/* function getEmpImage(pThis){
	
	data={
		prjctDutyNo:pThis			
	};
	
	$.ajax({
		url:"/project/getEmpImage",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8",
		type:"post",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success: function(res){
			console.log("resajax : ",res);
			str='';
			str+="<div class='img-wrap'>";
			str+="<img src='/resources/img/icon/"+res.atchmnflNo+"'>";
			str+="<p>"+res.empNm+"</p>";
			str+="</div>";
			
			return str;
		}

	}) 
}*/
//hover시에 프로젝트 사원의 정보가 나오는 함수 끝


/* // 간트차트용 필드명 수정 함수
function transformData(data) {
 return data.map(task => {
     return {
            id: task.id,
            text: task.text,
            start_date: task.startDate,
            end_date: task.endDate,
            progress: task.progress,
            open: task.open,
            duration:task.duration,
            user:task.empNm,
            type:task.prgsRate
        };
    });
}
//간트차트용 필드명 수정 함수 끝 */

	
