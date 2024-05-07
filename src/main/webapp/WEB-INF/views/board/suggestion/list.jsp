<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core"%>
<!-- =============== body 시작 =============== -->
<!-- =============== 상단타이틀영역 시작 =============== -->

<script>

$(function(){

    //검색
	$("#btnSearch").on("click", function(){
		
		let searchOption = $("#searchOption").val();
	    let keyword = $.trim($("input[name='keyword']").val());
	    
	    console.log("searchOption: " + searchOption);
	    console.log("keyword : " + keyword);
	    
	   //검색 시 페이지번호는 1로 초기화
	    let currentPage = "1";
	    
	    //json 오브젝트
	    let data = {
	       "searchOption": searchOption,
	        "keyword": keyword,
	        "currentPage": currentPage
	    };
	    
	    console.log("data : ", data);
	  
	    $.ajax({
	        url: "/suggestion/list",
	        contentType: "application/json;charset=utf-8",
	        data: JSON.stringify(data),
	        type: "post",
	        dataType: "json",
	        beforeSend: function(xhr){
	            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	        },
	        success: function(res){
	        	//res : articlePage
	        	console.log("res" ,res);
	            let str = "";
	            let studPwStr = "";
				
	            // 목록을 초기화
	            $("#suggestionTBody").html(""); // 변경된 부분: suggestionTBody로 변경

	            $.each(res.content, function(idx, suggestionVO){
	                console.log("suggestionVO[" + idx + "] : ", suggestionVO);
	                str += "<tr>";
	                str += "<td>";
	                str += "<p>"+suggestionVO.rnum+"</p>";
	                str += "</td>";
	                str += "<td onclick='location.href='/suggestion/list/detail?sugestBrdNo="+suggestionVO.sugestBrdNo+"' style='padding:0px;'>";
	                str += "<a href='/suggestion/list/detail?sugestBrdNo="+suggestionVO.sugestBrdNo+"' style='padding:0px;'>";
	                str += "<p>"+suggestionVO.sugestBrdSj+"</p>";
	                str += "</a>";
	                str += "</td>";
	                str += "<td>";
	                str += "<p>"+suggestionVO.empNm+"</p>";
	                str += "</td>";
	                str += "<td>";
	                str += "<p>"+suggestionVO.writngDate+"</p>";
	                str += "</td>";
	                str += "<td>";
	                str += "<p style='content: center'>"+suggestionVO.rdcnt+"</p>";
	                str += "</td>";
	                str += "</tr>";
	                str += "</tr>";
	                str += "<br>";
	            });//end each
	            //목록
	            $("#suggestionTBody").append(str); 

	         	//페이징
	         	$("#divPaging").html(res.pagingArea);
	            
	        }
 	    });
	 
 	   });
});

</script>





<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
    <h1 class="page-tit">건의 게시판</h1>
    <div class="side-util">
        <button type="button" class="btn2" onclick="location.href='http://localhost/suggestion/list/insertSuggestion'">
            등록
        </button>
    </div>
</div>


<!-- =============== 상단타이틀영역 끝 =============== -->
<!-- =============== 컨텐츠 영역 시작 =============== -->
<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
    <div class="wf-content-area">
        <table class="wf-table">
            <colgroup>
                <col style="width: 10%" />
                <col style="width: 58%" />
                <col style="width: 10%" />
                <col style="width: 15%" />
                <col style="width: 7%" />
            </colgroup>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                    <th>조회수</th>
                </tr>
            </thead>
            <tbody id ="suggestionTBody">
                <c:forEach var="suggestionVO" items="${suggestdata.content}" varStatus="stat">
                     <c:set var="writngDate" value="${suggestionVO.writngDate.substring(0, 10)}" />
                    <tr>
                        <td>
                            <p>${suggestionVO.rnum }</p>
                        </td>
                        <td onclick="location.href='/suggestion/list/detail?sugestBrdNo=${suggestionVO.sugestBrdNo}'" style='padding:0px;' >
                            <a href="/suggestion/list/detail?sugestBrdNo=${suggestionVO.sugestBrdNo}"
                                style='padding:0px;'><p>${suggestionVO.sugestBrdSj}</p></a>
                        </td>
                        <td>
                            <p>${suggestionVO.empNm }</p>
                        </td>
                        <td>
                            <p>${writngDate}</p>
                        </td>
                        <td>
                            <p style="content: center">${suggestionVO.rdcnt}</p>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- 페이지네이션 시작 -->
    <br>
    <div class="row" id="divPaging">
	    ${suggestdata.getPagingArea() }
    </div>
    <!-- 페이지네이션 끝 -->

    <!-- 검색영역 시작 -->
    <div class="wf-search-area">
        <div class="select-box">
            <select name="searchOption" id="searchOption">
                <option value="title"
                	<c:if test="${param.searchOption=='title'}">selected</c:if>
                >제목</option>
                <option value="titlecontent"
                	<c:if test="${param.searchOption=='titlecontent'}">selected</c:if>
                >제목+내용</option>
                <option value="empNm"
                	<c:if test="${param.searchOption=='empNm'}">selected</c:if>
                >작성자</option>
            </select>
        </div>
        <input type="text" id="keyword" name="keyword" placeholder="검색할 내용을 입력해주세요" value="${param.keyword}" />
        <button type="button" id="btnSearch" class="btn4">
            <i class="xi-search"></i>
        </button>
    </div>
    <!-- 검색영역 끝 -->
</div>
<!-- =============== 컨텐츠 영역 끝 =============== -->
<!-- =============== body 끝 =============== -->

