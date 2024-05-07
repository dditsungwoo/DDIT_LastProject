<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<style>

#gradient{
	height:900px;
}
</style>

<!-- =============== 상단타이틀영역 시작 =============== -->
<div class="wf-tit-wrap">
	<h1 class="page-tit" style="padding:5px;">전체 자료실</h1>
	
	<div class="side-util">
		<button type="button" class="btn3" id="fileDeleteBtn">삭제</button>
		<button type="button" class="btn1" id="DeleteBack" style="display:none;">삭제 해제</button>
		<!-- <p class="heading1" style="margin:5px;"></p> -->
		<!-- <img src="/resources/img/icon/amaS3.png" style="width:160px; height:80px;"> -->
		<form action="/menu/uploadFile?${_csrf.parameterName}=${_csrf.token}"
			method="post" enctype="multipart/form-data" id='uploadFileForm'>
			<label for="uploadBtn" class="btn2" style="margin-left:5px;">업로드</label> <input type='file'
				id='uploadBtn' name='uploadFile' style="display: none;" /> <input
				type='text' name='menuNm' style="display: none;" value="" />
		</form>
	</div>
</div>
<!-- =============== 상단타이틀영역 끝 =============== -->
<!-- =============== 컨텐츠 영역 시작 =============== -->
<div class="wf-content-wrap">
	<div class="wf-content-area">
		<table class="wf-table">
			<colgroup>
				<col style="width: 70%;">
				<col style="width: 15%;">
				<col style="width: 5%;">
			</colgroup>
			<thead>
				<tr>
					<th>제목</th>
					<th>용량</th>
					<th>확장자</th>
				</tr>
			</thead>
			<tbody id="s3Table">
			</tbody>
		</table>
	</div>

	<!-- 페이지네이션 시작 -->
	<div id="pagination"></div>
	<!-- 페이지네이션 끝 -->

	<!-- 검색영역 시작 -->
	<div class="wf-search-area">
		<input type="text" placeholder="검색할 내용을 입력해주세요" id="keywordBox">
		<button type="button" class="btn4" id='searchBtn'>
			<i class="xi-search"></i>
		</button>
	</div>
	<!-- 검색영역 끝 -->
</div>


<script>
$(()=>{
	let deptNo="${deptNo}";
	console.log("deptNo"+deptNo);
	readBucket(1);
	
	//페이지 번호 클릭시
	$(document).on("click",".pagination .page-link",function(){
		event.stopPropagation();
		let currentPage=$(this).text();
		readBucket(currentPage);
	});
	
	//파일 이름 클릭시
	$(document).on("click",".detail",function(){
		let param= $(this).text();
		let deptNo="${deptNo}";
		console.log("디테일"+param);
		downloadFile(param);
	}); 
	
	//upload 실행
	$("#uploadBtn").on('change', function() {
		$("#uploadFileForm").submit();
}); 
	
	//검색버튼
	$("#searchBtn").on("click",function(){
		let keyword=$("#keywordBox").val();
		searchBucket(1,keyword);
	})
	
	//삭제모드
	$("#fileDeleteBtn").on("click",function(){
		$("#DeleteBack").css("display","block");		
		$("#fileDeleteBtn").css("display","none");		
		$(".FNames").removeClass("detail");
		$(".FNames").addClass("deleteDetail");
	});
	
	//삭제모드 해제
	$("#DeleteBack").on("click",function(){
		$(".FNames").removeClass("deleteDetail");
		$(".FNames").addClass("detail");
		$("#DeleteBack").css("display","none");
		$("#fileDeleteBtn").css("display","block");	
	});
	
	
	//삭제모드후 원하는 파일을 클릭하면 삭제가 됨 
	$(document).on("click",".deleteDetail",function(){
		let param= $(this).text();
		//let deptNo="${deptNo}";
		
		//console.log(deptNo+"/"+param);
		let path=deptNo+"/"+param;
		let data={
			//deptNo:deptNo,
			pageUrl:path			
		};
		Swal.fire({
			  title:_msg.common.deleteConfirm
			  //icon: "success"
			}).then((result) => {
		        if (result.isConfirmed) {
					$.ajax({
						url:"/menu/deleteFile",
					    data:JSON.stringify(data),
					    contentType:"application/json;charset=utf-8",
					    type:"post",
					    dataType:"text",
					    beforeSend:function(xhr){
					       xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
					    },
					    success: async function(res) { 
					    	console.log("deleteFile"+res);
					    	if(res=="success"){
					    	await deleteBucket(1);					    	
					    	Toast.fire({
				     			  title: _msg.common.deleteSuccessAlert,
				     			  icon: "error"
				     			});
					    	}
					    }
					}); 
					};
			});
	}); 
		
	
	
	
	
}); //$(function)끝


	
	
	


//리스트 뽑아주는 함수
function readBucket(currentPage){
	deptNo="${deptNo}";
    $.ajax({
        url:"/s3/bucket/img",
        //data:JSON.stringify(data),
        contentType:"application/json;charset=utf-8",
        type:"get",
        dataType:"json",
        beforeSend:function(xhr){
            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
        },
        success:function(res) { 
			$("#s3Table").html('');
			let str = '';

			let length = res.dates.length;
			let reverse = res.dates.slice((currentPage * 10) - (10 ), currentPage * 10).sort((a, b) => b - a);
			reverse.forEach(function(vo) {
				let idx = res.dates.indexOf(vo); 
       	        let fileName = res.fileNames[idx]; 
       	        let fileExe = res.fileExtensions[idx]; 
       	        let size= res.fileSizes[idx];    
       	        str += `<tr>
       	        			<td><p class='detail FNames'>\${fileName} </p></td>
       	        			<td><p>\${convertToKB(size) }</p></td>
       	        			<td><p>\${fileExe}</p></td>
       	        		</tr>`;
        	});
        	    $("#s3Table").html(str);
			
			let page='';
            page+=`<nav class="wf-pagination-wrap">
            			<ul class="pagination"> `;			
            	for(let i=1; i<(length/10)+1; i++){
               		page+=`<li class="page-item pagination" value='\${i}'>
                    			<a class="page-link" href="#">\${i}</a>
                		  </li>`;              
            	}
           page+=` </ul>
        		</nav>`;
			$("#pagination").html(page);
			$(".page-item").filter(function() {
			    return $('.page-link',this).text().trim() == currentPage;
			}).addClass("active");
	
        }
	});
}
//리스트 뽑아주는 함수 끝


function convertToKB(fileSize) {
    return Math.round(fileSize / 1024) + "KB";
}

//검색하는 함수
function searchBucket(currentPage,keyword){
	deptNo="${deptNo}";
	let data={
		"menuNm":keyword	
	};
    $.ajax({
        url:"/s3/find/bucket/img",
        data:JSON.stringify(data),
        contentType:"application/json;charset=utf-8",
        type:"post",
        dataType:"json",
        beforeSend:function(xhr){
            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
        },
        success:function(res) { 
			$("#s3Table").html('');
			let str = '';
			let length = res.dates.length;
			let first= (currentPage * 10) - (10 );
			let last= currentPage*10;
			if (length > 0) {			
			    first = Math.max(first, 1);			 
			    last = Math.min(last, length);
			    reverse = res.dates.slice(first - 1, last);
			} else {			    
			    reverse = [];
			}
			//let reverse = res.dates.slice((currentPage * 10) - (10 - 1), currentPage * 10);
			reverse.forEach(function(vo) {
				let idx = res.dates.indexOf(vo); 
       	        let fileName = res.fileNames[idx]; 
       	        let fileExe = res.fileExtensions[idx]; 
       	        let size= res.fileSizes[idx];    
       	        str += `<tr>
       	        			<td><p class='detail'>\${fileName} </p></td>
       	        			<td><p>\${convertToKB(size) }</p></td>
       	        			<td><p>\${fileExe}</p></td>
       	        		</tr>`;
        	});
				
        	    $("#s3Table").html(str);
        	    console.log(res.dates.length);
			let page='';
            page+=`<nav class="wf-pagination-wrap">
            			<ul class="pagination"> `;			
            	for(let i=1; i<(length/10)+1; i++){
               		page+=`<li class="page-item pagination" value='\${i}'>
                    			<a class="page-link" href="#">\${i}</a>
                		  </li>`;              
            	}
           page+=` </ul>
        		</nav>`;
			$("#pagination").html(page);
			$(".page-item").filter(function() {
			    return $('.page-link',this).text().trim() == currentPage;
			}).addClass("active");
	
        }
	});
}


//리스트 뽑아주는 함수
function deleteBucket(currentPage){
	deptNo="${deptNo}";
    $.ajax({
        url:"/s3/bucket/img",
        //data:JSON.stringify(data),
        contentType:"application/json;charset=utf-8",
        type:"get",
        dataType:"json",
        beforeSend:function(xhr){
            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
        },
        success:function(res) { 
			$("#s3Table").html('');
			let str = '';

			let length = res.dates.length;
			let reverse = res.dates.slice((currentPage * 10) - (10 ), currentPage * 10).sort((a, b) => b - a);
			reverse.forEach(function(vo) {
				let idx = res.dates.indexOf(vo); 
       	        let fileName = res.fileNames[idx]; 
       	        let fileExe = res.fileExtensions[idx]; 
       	        let size= res.fileSizes[idx];    
       	        str += `<tr>
       	        			<td><p class='deletDetail FNames'>\${fileName} </p></td>
       	        			<td><p>\${convertToKB(size) }</p></td>
       	        			<td><p>\${fileExe}</p></td>
       	        		</tr>`;
        	});
        	    $("#s3Table").html(str);
			
			let page='';
            page+=`<nav class="wf-pagination-wrap">
            			<ul class="pagination"> `;			
            	for(let i=1; i<(length/10)+1; i++){
               		page+=`<li class="page-item pagination" value='\${i}'>
                    			<a class="page-link" href="#">\${i}</a>
                		  </li>`;              
            	}
           page+=` </ul>
        		</nav>`;
			$("#pagination").html(page);
			$(".page-item").filter(function() {
			    return $('.page-link',this).text().trim() == currentPage;
			}).addClass("active");
	
        }
	});
}






</script>                       
                        
                        
                                        