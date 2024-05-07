<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<style>

/* 틀어짐 수정 */
.content-wrap {height: 100%;}
.wf-mail-wrap {width: 100% !important;}
.wf-chat-left {min-height: auto;}


.wf-main-container{
	width: 100%;
}
.wf-mail-wrap{
	height: 100%;
	width: 95%;
}
.wf-content-area{
	height: 100%;
}
.wf-table {
/*     font-size: 0.7rem; /* 원하는 크기로 조정 */ */
	font-size: 13px;
    overflow-x: auto;
}

/* #jstree { */
/*     font-size: 0.7rem; /* 원하는 크기로 조정 */ */
/* } */

/* .jstree-anchor { */
/*     font-size: 0.7rem; /* 원하는 크기로 조정 */ */
/* } */

#EMP_TREE .jstree-anchor {font-size: 13px; font-weight: 600;}

#modal-test{
	width: 200px;
    height: 150px;
    background-color: #ffffff;
    border: 1px solid #ccc;
    position: fixed;
    bottom: 10px;
    right: 10px;
    z-index: 1000;
}
</style>
<script>
let realSize = window.innerWidth;
let realHeight = window.innerHeight;
let empNo = <%=session.getAttribute("empNo")%> + "";
let empNm = "";
let chatRoomNo = "0";
/* let empNo = ${empNo} + ""; */
let chatAddOrInvite = "";	// 모달창 타겟이 기존 채팅방에 초대인지 새로운 채팅방 생성인지 구분
let chatRoomEmpList = [];
let chatRoomEmpListTemp = []; // 일단 임시저장해뒀다가 필요할때 chatRoomEmpList로 덮어씌우기용도



$("body").css("width",realSize)
window.addEventListener("resize", function() {
	realSize = window.innerWidth;
	realHeight = window.innerHeight;
	$("body").css("width",realSize)
	$("body").css("height",realHeight)
})

$("header").html("")
$("header").css("height","0px")
$("aside").html("")
$("aside").css("width","0px")

$.ajax({
	url:"/chat/getEmp",
	data:{"empNo":empNo},
	type:"get",
	contentType:"application/x-www-form-urlencoded; charset=UTF-8",
	success:function(res){
		empNm = res.empNm
	}
})

</script>

	<div class="wf-tit-wrap">
		<h1 class="page-tit">조직도</h1>
	</div>
	<div class="wf-mail-wrap">
	
    	<div style="width: 100%; display: flex; gap: 15px;">
		<div id="EMP_TREE" class="wf-content-area wf-chat-left" style="overflow-y: auto; width: 270px;">
			<div id="jstree"></div>
		</div>
		<div class="wf-mail-right" style="align-self: start;overflow-x: auto;flex: 1;">
			<table class='wf-table'>
			<tr>
						<th>번호</th>
						<th>사원번호</th>
						<th>사원명</th>
						<th>근무지역</th>
						<th>내선번호</th>
						<th>부서명</th>
						<th>직급</th>
						<th>직책</th>
						<th>이메일주소</th>
					</tr>
				<thead>
				<tbody id="empTBody">
					<tr class="text-center" style="text-align: center;">
						<th colspan="9" style="text-align: center;">왼쪽의 조직도를 선택해주세요</th>
					</tr>
				</table>
			</div>
		<!-- </div> -->
		</div>
	</div>
<!-- =============== 컨텐츠 영역 끝 =============== -->
<!-- =============== body 끝 =============== -->
<script type="text/javascript">
//데이터 그룹화 함수
$(document).ready(function() {
    $("#jstree").jstree({
        'core': {
            'data': function(obj, cb) {
                var xhr = new XMLHttpRequest();
                xhr.open("get", "/emp/treeAjax", true);
                xhr.onreadystatechange = function() {
                    if (xhr.readyState == 4 && xhr.status == 200) {
                        var data = JSON.parse(xhr.responseText); // 데이터 파싱
                        var groupedData = groupData(data); // 데이터 그룹화
                        var transformedData = transformData(groupedData); // 데이터 변환
                        cb.call(obj, transformedData); // jstree에 데이터 전달
                    }
                };
                xhr.send();
            }, 
            "check_callback": true
        },
        "plugins": ["wholerow", "dnd"]
    });
});

// 데이터 그룹화 함수
function groupData(data) {
    var groupedData = {};
    data.forEach(task => {
        if (!groupedData[task.deptNo]) {
            groupedData[task.deptNo] = [];
        }
        groupedData[task.deptNo].push(task);
    });
    return groupedData;
}

// 데이터 변환 함수
function transformData(groupedData) {
    var nodes = [];
    for (var deptNo in groupedData) {
        var deptInfo = groupedData[deptNo][0]; // 부서 정보는 배열의 첫 번째 요소에서 가져옴
        var deptNode = {
            id: deptInfo.deptNo,
            text: deptInfo.deptNm,
            parent: deptInfo.upperDept,
            icon: "https://jstree.com/tree-icon.png"
        };
        nodes.push(deptNode);

        groupedData[deptNo].forEach(employee => {
            var empNode = {
                id: employee.deptNo + "_" + employee.empNm, // 각 팀원의 ID는 부서번호와 이름을 조합하여 설정
                text: employee.empNm+ "_" + employee.position+ "_" + employee.rspnsblCtgryNm,
                parent: employee.deptNo,
                icon: ""
            };
            nodes.push(empNode);
        });
    }
    return nodes;
}

//  jstree 노드 클릭 이벤트 핸들러
$('#jstree').on('select_node.jstree', function (e, data) {
	console.log("jstree 시작");
	
	 $("#empTBody").html(""); 
	
    var nodeId = data.node.id;
    var empName = nodeId.split('_')[1]; // ID에서 직원의 이름 추출
    var deptNo = nodeId.split('_')[0]; // ID에서 부서 번호 추출
    var deptName = data.node.text;
    
   // alert('직원 이름: ' + empName + ', 부서 이름: ' + deptName);
   // searchEmployees(empName); // 검색 함수 호출
   
   //유재석_사장_본부장 -> 유재석 사장 본부장   
   //empName : 유재석
   console.log("empName : " + empName);
   if(empName!=null){
   	searchEmployees("empNm", empName);
   }
   
// 부서 이름으로 검색
//deptName : deptName : 유재석_사장_본부장
  console.log("deptName : " + deptName);
   searchEmployees2("deptNm", deptName);
});



//검색 요청을 보내고 검색 결과를 화면에 출력하는 함수
function searchEmployees(searchOption, keyword) {
	
	let tmp = { 
            "searchOption": searchOption, 
            "keyword": keyword, 
            "currentPage": "1"
        };
	console.log("searchEmployees->tmp : ", tmp);
	
    $.ajax({
        url: "/emp/list", // 검색을 처리하는 서버의 URL로 변경해야 합니다.
        contentType: "application/json;charset=utf-8",
        data: JSON.stringify({ 
            "searchOption": searchOption, 
            "keyword": keyword, 
            "currentPage": "1"
        }),
        type: "post",
        dataType: "json",
        beforeSend: function(xhr){
            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
        },
        success: function(result){
        	console.log("searchEmployees->result : ", result);
            let str = "";
            
//             str += "<table class='wf-table'>";
//             str += "<tr>";
//             str += "<th>번호</th>";
//             str += "<th>사원번호</th>";
//             str += "<th>사원명</th>";
//             str += "<th>근무지역</th>";
//             str += "<th>내선번호</th>";
//             str += "<th>부서명</th>";
//             str += "<th>직책</th>";
//             str += "<th>직급</th>";
//             str += "<th>이메일주소</th>";
//             str += "</tr>";
             if (result.content.length > 0) {
            $.each(result.content, function(idx, empVO){
            	
                str += "<tr>";
                str += "<td>" + (idx + 1) + "</td>";
                str += "<td>" + empVO.empNo + "</td>";
                str += "<td>" + empVO.empNm + "</td>";
                str += "<td>" + empVO.workLocation + "</td>";
                str += "<td>" + empVO.lxtn + "</td>";
                str += "<td>" + empVO.deptNm + "</td>";
                str += "<td>" + empVO.position + "</td>";
                str += "<td>" + empVO.rspnsblCtgryNm + "</td>";
                str += "<td>" + empVO.email + "</td>";
                str += "</tr>";
                
            });
             } else {
                 str += "<tr>";
                 str += "<td colspan='9' style='text-align:center;'>팀에 속한 사원이 없습니다.</td>";
                 str += "</tr>";
             }
            $("#empTBody").append(str);
        }
    });//end ajax
}//end searchEmployees


  //검색 요청을 보내고 검색 결과를 화면에 출력하는 함수
  function searchEmployees2(searchOption, keyword) {

		let tmp = { 
	            "searchOption": searchOption, 
	            "keyword": keyword, 
	            "currentPage": "1"
	        };
		console.log("searchEmployees2->tmp : ", tmp);
	
        $.ajax({
            url: "/emp/list", // 검색을 처리하는 서버의 URL로 변경해야 합니다.
            contentType: "application/json;charset=utf-8",
            data: JSON.stringify({ 
                "searchOption": searchOption, 
                "keyword": keyword, 
                "currentPage": "1"
            }),
            type: "post",
            dataType: "json",
            beforeSend: function(xhr){
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result){
            	console.log("searchEmployees2->result : ", result);
                let str = "";
                
                $.each(result.content, function(idx, empVO){
                	
                    str += "<tr>";
                    str += "<td>" + (idx + 1) + "</td>";
                    str += "<td>" + empVO.empNo + "</td>";
                    str += "<td>" + empVO.empNm + "</td>";
                    str += "<td>" + empVO.workLocation + "</td>";
                    str += "<td>" + empVO.lxtn + "</td>";
                    str += "<td>" + empVO.deptNm + "</td>";
                    str += "<td>" + empVO.position + "</td>";
                    str += "<td>" + empVO.rspnsblCtgryNm + "</td>";
                    str += "<td>" + empVO.email + "</td>";
                    str += "</tr>"; 
                });
                str += "</table>";
                $("#empTBody").append(str);
            }
        });//end ajax
    
}//end searchEmployees


</script>
