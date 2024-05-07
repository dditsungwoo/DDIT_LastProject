<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/views/tiles/taglib.jsp"%>
<script src="${_script}/common/util.js"></script>
<script src="${_script}/common/pagination.js"></script>
<script src="${_script}/approval/html.js"></script>
<script src="${_script}/approval/deptList.js"></script>

<!-- =============== 상단타이틀영역 시작 =============== -->
<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
    <h1 class="page-tit">부서 문서함</h1>
    <div class="side-util"></div>
</div>
<!-- =============== 상단타이틀영역 끝 =============== -->

<!-- =============== 컨텐츠 영역 시작 =============== -->
<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">

    <div class="wf-content-area">
        <table class="wf-table">
            <colgroup>
                <col style="width: auto;">
                <col style="width: auto;">
                <col style="width: auto;">
            </colgroup>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>문서종류</th>
                    <th>기안부서</th>
                    <th>제목</th>
					<th>기안자</th>
                    <th>최종결재일자</th>
                </tr>
            </thead>
            <tbody id="deptTbody"></tbody>
        </table>
    </div>

    <!-- 페이지네이션 시작 -->
    <nav class="wf-pagination-wrap">
        <ul id="PAGINAION" class="pagination"></ul>
    </nav>
    <!-- 페이지네이션 끝 -->

    <!-- 검색영역 시작 -->
     <div class="wf-search-area">
         <div class="select-box">
             <select id="SEARCH_TYPE">
                 <option selected>검색</option>
                 <option value="1">제목</option>
                 <option value="2">작성자</option>
             </select>
         </div>
         <input id="SEARCH_VALUE" type="text" placeholder="검색할 내용을 입력해주세요">
         <button id="SEARCH_BTN" type="button" class="btn4">
             <i class="xi-search"></i>
         </button>
     </div>
     <!-- 검색영역 끝 -->
</div>
<!-- =============== 컨텐츠 영역 끝 =============== -->