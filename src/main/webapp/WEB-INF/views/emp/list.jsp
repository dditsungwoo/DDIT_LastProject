<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script type="text/javascript">
$(function(){
    // 검색
    $("#btnSearch").on("click", function(){
        let searchOption = $("#searchOption").val();
        let keyword = $.trim($("input[name='keyword']").val());
        
        console.log("searchOption: " + searchOption);
        console.log("keyword : " + keyword);
        
        // 검색 시 페이지번호는 1로 초기화
        let currentPage = "1";
        
        // json 오브젝트
        let data = {
            "searchOption": searchOption,
            "keyword": keyword,
            "currentPage": currentPage
        };
        
        console.log("data : ", data);
      
        $.ajax({
            url: "/emp/list",
            contentType: "application/json;charset=utf-8",
            data: JSON.stringify(data),
            type: "post",
            dataType: "json",
            beforeSend: function(xhr){
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result){
                console.log("result : ",result);
                
                let str = "";
                
                // 목록을 초기화
                $("#empTBody").html(""); 

                $.each(result.content, function(idx, empVO){
                    console.log("empVO[" + idx + "] : ", empVO);
                    str += "<tr>";
                    str += "<td>" +empVO.rnum + "</td>";
                    str += "<td>" + empVO.empNo + "</td>";
                    str += "<td>" + empVO.empNm + "</td>";
                    str += "<td>" + empVO.workLocation + "</td>";
                    str += "<td>" + empVO.lxtn + "</td>";
                    str += "<td>" + empVO.cntcNo + "</td>";
                    str += "<td>" + empVO.deptNm + "</td>";
                    str += "<td>" + empVO.position + "</td>";
                    str += "<td>" + empVO.rspnsblCtgryNm + "</td>";
                    str += "<td>" + empVO.email + "</td>";
                    str += "</tr>";
                });
                
                $("#empTBody").append(str);

                // 페이징 처리
                $("#divPaging").html(result.pagingArea);
            }
        });
    });
});
</script>
<div class="wf-main-container">
    <!-- =============== 상단타이틀영역 시작 =============== -->
    <div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
        <h1 class="page-tit">주소록</h1>
            <button type="button" class="btn2" id="downloadExcel">
                주소록 excel 다운로드 <i class="xi-download"></i>
            </button>
    </div>
    <!-- =============== 상단타이틀영역 끝 =============== -->
    <!-- =============== 컨텐츠 영역 시작 =============== -->
    <div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
        <div class="wf-content-area">
            <table class="wf-table">
                <colgroup>
                    <col style="width: 6%;">
                    <col style="width: 10%;">
                    <col style="width: 10%;">
                    <col style="width: 10%;">
                    <col style="width: 12%;">
                    <col style="width: 12%;">
                    <col style="width: 9%;">
                    <col style="width: 10%;">
                    <col style="width: 10%;">
                    <col style="width: 11%;">
                </colgroup>
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>사원번호</th>
                        <th>사원명</th>
                        <th>근무지역</th>
                        <th>내선번호</th>
                        <th>개인 연락처</th>
                        <th>부서명</th>
                        <th>직급</th>
                        <th>직책</th>
                        <th>이메일주소</th>
                    </tr>
                </thead>
                <tbody id="empTBody">
                    <c:forEach var="empVO" items="${data.content}" varStatus="stat">
                        <tr>
                            <td>${empVO.rnum}</td>
                            <td>${empVO.empNo}</td>
                            <td>${empVO.empNm}</td>
                            <td>${empVO.workLocation}</td>
                            <td>${empVO.lxtn}</td>
                            <td>${empVO.cntcNo}</td>
                            <td>${empVO.deptNm}</td>
                            <td>${empVO.position}</td>
                            <td>${empVO.rspnsblCtgryNm}</td>
                            <td>${empVO.email}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <br>
        <div class="row justify-content-center" id="divPaging">
            <!-- 페이지네이션 시작 -->
            ${data.getPagingArea()}
            <!-- 페이지네이션 끝 -->
        </div>
        <!-- 검색 시작 -->
        <div class="wf-search-area">
            <div class="select-box">
                <select name="searchOption" id="searchOption">
                    <option value="empNm">사원명</option>
                    <option value="deptNm">부서명</option>
                    <option value="workLocation">근무지역</option>
                </select>
            </div>
            <input type="text" name="keyword" id="keyword" placeholder="검색어를 입력해주세요">
            <button type="button" class="btn4" id="btnSearch"><i class="xi-search"></i></button>
        </div>
        <!-- 검색 끝 -->
    </div>
    <!-- =============== 컨텐츠 영역 끝 =============== -->
</div>

<script>
// 버튼 클릭 시 실행
document.getElementById('downloadExcel').addEventListener('click', function() {
    window.location.href = "/excel/empdownload";
});
</script>
