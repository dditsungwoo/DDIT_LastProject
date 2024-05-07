<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ page import="java.text.SimpleDateFormat" %>

            <script>
                $(() => {
                    noneDisplay();
                    
                    
                    var currentTime = new Date();
                	console.log("현재시간은 ",currentTime);
                	
                	
                	//선택시 
                	$("#brdCd").change(function(){
                        console.log("선택됌");

                		let brdCd = $(this).val();
                		let searchOption = $("#searchOption").val();
                	    let keyword = $.trim($("input[name='keyword']").val());


                		console.log("brdCd---> ",brdCd);
                		console.log("searchOption --> ",searchOption);
                        console.log("keyword--> ",keyword);
					
                        let currentPage = "1";
                        
                        let data ={
                            "searchOption": searchOption,
                	        "keyword": keyword,
                	        "currentPage": currentPage,
                	        "brdCd":brdCd,
                        }

                        console.log("data -> ",data);
                        $.ajax({
                	        url: "/notice/list",
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
                	            $("#noticeTbody").html(""); // 변경된 부분: suggestionTBody로 변경

                	            $.each(res.content, function(idx, noticeVO){
                	                console.log("noticeVO[" + idx + "] : ", noticeVO);
                	                str += "<tr onclick=\"location.href='/notice/list/detail?noticeBrdNo=" + noticeVO.noticeBrdNo + "'\">";
                                    str += "<td>";
                                    str += "<p>"+noticeVO.cmmnCdNm+"</p>";
                                    str += "</td>";
                	                str += "<td>";
                	                str += "<p>"+noticeVO.rnum+"</p>";
                	                str += "</td>";
                	                str += "<td>";
                	                str += "<p>"
                                        if(noticeVO.fixingEndDate != "" && noticeVO.fixingEndDate != null){
                                            str += "<span class='wf-badge3'>중요</span>&nbsp;" ;
                                        }
                                    str +=  noticeVO.noticeBrdSj;
                                    str += "</p>";
                	                str += "</a>";
                	                str += "</td>";
                	                str += "<td>";
                	                str += "<p>"+noticeVO.empNm+"</p>";
                	                str += "</td>";
                	                str += "<td>";
                                    let dataTime = noticeVO.writngDate.substr(0,10);
                	                str += "<p>"+dataTime+"</p>";
                	                str += "</td>";
                	                str += "<td>";
                	                str += "<p style='content: center'>"+noticeVO.rdcnt+"</p>";
                	                str += "</td>";
                	                str += "</tr>";
                	            });//end each
                	            //목록
                	            $("#noticeTbody").append(str); 
                	         	//페이징
                	         	$("#divPaging").html(res.pagingArea);
                	        }
                 	    });
                	});
                	
                	
                	
                // 검색
                	 //검색
                	$("#btnSearch").on("click", function(){
                		let brdCd = $("#brdCd").val();
                		console.log("brdCd -> ",brdCd);
                		let searchOption = $("#searchOption").val();
                	    let keyword = $.trim($("input[name='keyword']").val());
                	    
                	    console.log("searchOption: " + searchOption);
                	    console.log("keyword : " + keyword);
                	    console.log("brdCd: "+brdCd);
                	   //검색 시 페이지번호는 1로 초기화
                	    let currentPage = "1";
                	    
                	    //json 오브젝트
                	    let data = {
                	       "searchOption": searchOption,
                	        "keyword": keyword,
                	        "currentPage": currentPage,
                	        "brdCd":brdCd,
                	    };
                	    
                	    console.log("data : ", data);
                	  
                	    $.ajax({
                	        url: "/notice/list",
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
                	            $("#noticeTbody").html(""); // 변경된 부분: suggestionTBody로 변경

                	            $.each(res.content, function(idx, noticeVO){
                	                console.log("noticeVO[" + idx + "] : ", noticeVO);
                	                
                	                str += "<tr onclick=\"location.href='/notice/list/detail?noticeBrdNo=" + noticeVO.noticeBrdNo + "'\">";
                                    str += "<td>";
                                    str += "<p>"+noticeVO.cmmnCdNm+"</p>";
                                    str += "</td>";
                	                str += "<td>";
                	                str += "<p>"+noticeVO.rnum+"</p>";
                	                str += "</td>";
                	                str += "<td>";
                	                str += "<p>";
                                        if(noticeVO.fixingEndDate != "" && noticeVO.fixingEndDate != null){
                                        	str += "<span class='wf-badge3'>중요</span>&nbsp;"; 
                                        }
                                    str +=  noticeVO.noticeBrdSj;
                                    str += "</p>";
                	                str += "</a>";
                	                str += "</td>";
                	                str += "<td>";
                	                str += "<p>"+noticeVO.empNm+"</p>";
                	                str += "</td>";
                	                str += "<td>";
                	                let dataTime = noticeVO.writngDate.substr(0,10);
                	                console.log("noticeVO.writngDate--->",dataTime);
                	                str += "<p>"+dataTime+"</p>";
                	                str += "</td>";
                	                str += "<td>";
                	                str += "<p style='content: center'>"+noticeVO.rdcnt+"</p>";
                	                str += "</td>";
                	                str += "</tr>";
                	            });//end each
                	            //목록
                	            $("#noticeTbody").append(str); 

                	         	//페이징
                	         	$("#divPaging").html(res.pagingArea);
                	            
                	        }
                 	    });
                 	   });
                	 






                       




                        $(document).ready(function() {
                            // 각 행마다 시간 값이 있는 경우에만 출력
                            $(".fixingEndDateInput").each(function() {
                                var fixingEndDate1 = $(this).val();
                                let noticeBrdNo = $(this).data("noticeBrdNo");
                                let formattedFixingEndDateStr = fixingEndDate1.replace(/^(\d{4})(\d{2})(\d{2})$/, '$1-$2-$3');
                                let fixingEndDate = new Date(formattedFixingEndDateStr);

                                let th = $(this);
                                let sib = $(th).siblings();



                                if(currentTime > fixingEndDate){

                                    let data ={
                                        noticeBrdNo:noticeBrdNo,
                                    };
                                    
                                    console.log("data----> ",data);

                                    
                                    $.ajax({
                                        url: "/notice/list/time/delete",
                                        data: JSON.stringify(data),
                                        contentType: "application/json;charset=utf-8",
                                        type: "post",
                                        dataType: "json",
                                        beforeSend: function (xhr) {
                                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                                        },
                                        success: function (res) {
                                            sib.remove();
                                        },
                                    });
                                    
                                }

                            });
                        });

                       /*
                        let fixingEndDateStr = "${noticeVO.fixingEndDate}"; // YYYYMMDD 형식의 문자열
                        // YYYYMMDD 문자열을 YYYY-MM-DD 형식으로 변환
                        let formattedFixingEndDateStr = fixingEndDateStr.replace(/^(\d{4})(\d{2})(\d{2})$/, '$1-$2-$3');
                        let fixingEndDate = new Date(formattedFixingEndDateStr);
                        console.log("fixingEndDate  ", fixingEndDate);
        
                        // 시간을 표시하는 예시
                        let timeString = fixingEndDate.toLocaleString(); // 현재 로컬 시간에 맞는 형식으로 변환
                        console.log("Time  ", timeString);
                       */


                });
                	
					

                //등록 버튼 권한 없으면 안보이게
                function noneDisplay(){
                    let empNo = <%=session.getAttribute("empNo") %>;
                    let data ={
                        empNo:empNo,
                    };
                    $.ajax({
                        url: "/notice/getEmpRspn",
                        data: JSON.stringify(data),
                        contentType: "application/json;charset=utf-8",
                        type: "post",
                        dataType: "json",
                        beforeSend: function (xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                        },
                        success: function (res) {
                            let result = res.rspnsblCtgryNm;
                            if(result =="팀원"){
                                let btn = document.getElementById("insertBtn");
                                btn.style.display='none';
                            }
                        },
                    });
                }
                            












                

            </script>




            <div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
                <h1 class="page-tit">공지 게시판</h1>
                <div class="side-util">
                    <div class="wf-flex-box">
                        <div class="wf-select-group" style="flex: 0 1 calc(60%);">
                            <select name="brdCd" id="brdCd">
                                <option value="" <c:if test="${param.brdCd==''}">selected</c:if>>전체</option>
                                <option value="1" <c:if test="${param.brdCd=='1'}">selected</c:if> >일반</option>
                                <option value="2"<c:if test="${param.brdCd=='2'}">selected</c:if>>인사</option>
                            </select>
                        </div>
                            <button type="button" class="btn2" id="insertBtn" onclick="location.href='/notice/list/insertNotice'" style="flex: 0 1 calc(30%);">
                                등록
                            </button>
                    </div>
                </div>
            </div>


            <!-- =============== 상단타이틀영역 끝 =============== -->
            <!-- =============== 컨텐츠 영역 시작 =============== -->
            <div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
                <div class="wf-content-area">
                    <table class="wf-table">
                        <colgroup>
                            <col style="width: 5%" />
                            <col style="width: 5%" />
                            <col style="width: 60%" />
                            <col style="width: 7%" />
                            <col style="width: 13%" />
                            <col style="width: 8%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>분류</th>
                                <th>번호</th>
                                <th>제목</th>
                                <th>작성자</th>
                                <th>작성일</th>
                                <th>조회수</th>
                            </tr>
                        </thead>
                        <tbody id="noticeTbody">
                            <c:forEach var="noticeVO" items="${noticedata.content}" varStatus="stat">
                                <c:set var="writngDate" value="${noticeVO.writngDate.substring(0, 10)}" />
                                <tr onclick="location.href='/notice/list/detail?noticeBrdNo=${noticeVO.noticeBrdNo}'">
                                    <td>
                                        <p>${noticeVO.cmmnCdNm}</p>
                                    </td>
                                    <td>
                                        <p>${noticeVO.rnum}</p>
                                    </td>
                                    <td >
                                            <p>
                                                <c:if test="${not empty noticeVO.fixingEndDate}">
                                                    <c:set var="fixingEndDate" value="${noticeVO.fixingEndDate}" />
                                                    <c:set var="noticeBrdNo" value="${noticeVO.noticeBrdNo}" />
                                                    <input type="hidden" class="fixingEndDateInput" data-notice-brd-no="${noticeBrdNo}" value="${fixingEndDate}" />
                                                    <!--<c:out value="${fixingEndDate}" />-->
                                                <span class="hiddenTag" ><span class="wf-badge3">중요</span>&nbsp;</span>
                                                </c:if>${noticeVO.noticeBrdSj}
                                            </p>
                                    </td>
                                    <td>
                                        <p>${noticeVO.empNm }</p>
                                    </td>
                                    <td>
                                        <p>${writngDate}</p>
                                    </td>
                                    <td>
                                        <p style="content: center">${noticeVO.rdcnt}</p>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
				<br/>

                <!-- 페이지네이션 시작 -->
                <div class="row" id="divPaging">
                    ${noticedata.getPagingArea() }
                </div>
                <!--페이지네이션 끝 -->



                <!-- 검색영역 시작 -->
                <div class="wf-search-area">
                    <div class="select-box">
                        <select name="searchOption" id="searchOption">
                            <option value="title" <c:if test="${param.searchOption=='title'}">selected</c:if>
                                >제목</option>
                            <option value="titlecontent" <c:if test="${param.searchOption=='titlecontent'}">selected
                                </c:if>
                                >제목+내용</option>
                            <option value="empNm" <c:if test="${param.searchOption=='empNm'}">selected</c:if>
                                >작성자</option>
                        </select>
                    </div>
                    <input type="text" id="keyword" name="keyword" placeholder="검색할 내용을 입력해주세요"
                        value="${param.keyword}" />
                    <button type="button" id="btnSearch" class="btn4">
                        <i class="xi-search"></i>
                    </button>
                </div>
                <!-- 검색영역 끝 -->
            </div>
            <!-- =============== 컨텐츠 영역 끝 =============== -->
            <!-- =============== body 끝 =============== -->