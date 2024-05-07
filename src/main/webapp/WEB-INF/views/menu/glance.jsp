<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.15/jstree.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.15/themes/default/style.min.css" />


<style>
.wf-content-area {
	display: flex;
	justify-content: space-between;
}
</style>


<div class="wf-tit-wrap">
	<h1 class="page-tit">조직도</h1>
	<ul class="wf-util" style="display: flex; justify-content: flex-end;">
		<li><a href="javascript:void(0)"> <i class="xi-users-plus">메뉴</i></a>
			<div class="wf-menu-dropdown">

				<a href="/emp/list"><i class="xi-external-link">주소록 보러가기</i></a>



			</div></li>
	</ul>
</div>
<div style="width: 100%;">
	<div class="">바로가기 설정</div>
<div class="wf-content-area" style="width: 25%;" >
	<div id="jstree1"></div>
	</div>
	<div class="wf-flex-box" style="border:1px solid black;">
	<button class='btn2' id ='insertGlance'>저장</button>
	</div>
	<button class='btn-modal' modal-id='modal-glance'> </button>
<!-- 	<div class="wf-content-area" style="float: right; width: 70%;" > -->

<!-- </div> -->
</div>
<div class="modal" id="modal-glance">
    <div class="modal-cont">
        <h1 class="modal-tit">바로가기 설정</h1>
        	<br/>
         	 <div class="wf-flex-box">
         	</div>
        <div class="modal-content-area">
         	<div id='jstree'></div><br>
        </div>
        <div class="modal-btn-wrap">
        
            <button class="btn6" id='resetGlanceBtn'>초기화</button>
            <button class="btn2" id='insertGlanceBtn'>바로가기 생성</button>
        </div>

        <button class="close-btn"></button>
    </div>
</div>

<script>
	let empNo="<%=session.getAttribute("empNo")%>";
	$(document).ready(function() {
	    // checkedMenuNos를 전역 변수로 선언
	    var checkedMenuNos = [];


	    $('#jstree').on('select_node.jstree', function (e, data) {
	        e.preventDefault();
	        console.log("jstree 시작");

	        var checkedNodes = $('#jstree').jstree(true).get_checked(); 
	        // checkedMenuNos를 초기화한 후 선택된 노드들의 menuNo를 다시 할당
	        checkedMenuNos = checkedNodes.map(function(nodeId) {
	            var node = $('#jstree').jstree(true).get_node(nodeId);
	            return node.id;
	        });
	    });

	    // 초기화버튼 클릭 이벤트 핸들러
	    $("#resetGlanceBtn").on("click", function() { 
	        $('#jstree').jstree(true).deselect_all();
	        // checkedMenuNos를 빈 배열로 초기화
	        checkedMenuNos = []; 
	    });

	    // 바로가기 생성 버튼 클릭 이벤트 핸들러
	    $("#insertGlanceBtn").on("click", function() {
	        console.log(checkedMenuNos);
	        if (checkedMenuNos.length > 4 || checkedMenuNos.length < 1) {
	            console.log("선택을 안했거나 4개이상 선택 불가능합니다");
	            checkedMenuNos = [];
	            $('#jstree').jstree(true).deselect_all();
	            return;
	        }
	     
	        let glanNm=$("#glanceName").val();
	        console.log("glanNm" + glanNm);
	        if(glanNm == '') {
	            console.log("바로가기 명을 적어주세요");
	            return;
	        }
	        let numToExtract = Math.min(4, checkedMenuNos.length); 
	        let data={
	            "menuNos": checkedMenuNos.slice(-numToExtract), 
	            "empNo":empNo,
	            "glanNm":"바로가기1"
	        };
	        console.log("data",data);
	        $.ajax({
	            url:"/menu/insertGlance",
	            data:JSON.stringify(data),
	            contentType:"application/json;charset=utf-8",
	            type:"post",
	            dataType:"json",
	            beforeSend:function(xhr){
	                xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
	            },
	            success:function(res) { 
	                console.log(res);
	                if(res>0){
	                $('.modal').removeClass('open');
	                $('html').removeClass('scroll-hidden');
	                $('#jstree').jstree(true).deselect_all();
	                }	                
	            }
	        });
	    }); 
	});

function selectGlance(){
	let data={
		"empNo":empNo,
		"glanNm":glanNm
	};
    $.ajax({
        url:"/menu/selectGlance",
        data:JSON.stringify(data),
        contentType:"application/json;charset=utf-8",
        type:"post",
        dataType:"json",
        beforeSend:function(xhr){
            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
        },
        success:function(res) { 
        	
        }
    });
};	
	
</script>
<script src="/resources/script/project/glance.js"></script> 

    