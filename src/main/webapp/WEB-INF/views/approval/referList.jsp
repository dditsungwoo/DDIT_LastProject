<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/views/tiles/taglib.jsp"%>
<!-- =============== 상단타이틀영역 시작 =============== -->
<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
    <h1 class="page-tit">참조 문서함</h1>
    <div class="side-util"></div>
</div>
<!-- =============== 상단타이틀영역 끝 =============== -->
<!-- =============== 컨텐츠 영역 시작 =============== -->
<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">

    <div class="wf-content-area">
        <table class="wf-table">
            <colgroup>
                <col style="width: 10%;">
               <col style="width: 10%;">
               <col style="width: 10%;">
               <col style="width: 10%;">
               <col style="width: 10%;">
               <col style="width: 10%;">
               <col style="width: 10%;">
               <col style="width: 10%;">
           </colgroup>
           <thead>
               <tr>
                   <th>번호</th>
                   <th>문서종류</th>
                   <th>제목</th>
                   <th>소속부서</th>
                   <th>기안일자</th>
                   <th>최종결재일자</th>
                   <th>기안자</th>
                   <th>상태</th>
               </tr>
           </thead>
           <tbody>
               <tr>
                   <td>
                       <p>1</p>
                   </td>
                   <td>
                       <p>품의서</p>
                   </td>
                   <td>
                       <p>
                           <i class="xi-lock"></i>
                           기안제목 기안제목기안제목기안제목기안제목기안제목기안제목기안제목기안제목
                       </p>
                   </td>
                   <td>
                       <p>개발팀</p>
                   </td>
                   <td>
                       <p>2024-03-09</p>
                   </td>
                   <td>
                       <p>2024-03-09</p>
                   </td>
                   <td>
                       <p>김대덕</p>
                   </td>
                   <td>
                       <p>완료</p>
                   </td>
               </tr>
           </tbody>
       </table>
   </div>

   <!-- 페이지네이션 시작 -->
   <nav class="wf-pagination-wrap">
       <ul class="pagination">
           <li class="page-item">
               <a class="page-link prev" href="#">
                   <i class="xi-angle-left"></i>
               </a>
           </li>
           <li class="page-item active">
               <a class="page-link" href="#">1</a>
           </li>
           <li class="page-item">
               <a class="page-link" href="#">2</a>
           </li>
           <li class="page-item">
               <a class="page-link" href="#">3</a>
           </li>
           <li class="page-item">
               <a class="page-link next" href="#">
                   <i class="xi-angle-right"></i>
               </a>
           </li>
       </ul>
   </nav>
   <!-- 페이지네이션 끝 -->

   <!-- 검색영역 시작 -->
   <div class="wf-search-area">
       <div class="select-box">
           <select name="" id="">
               <option value="">제목</option>
               <option value="">제목+내용</option>
               <option value="">작성자</option>
           </select>
       </div>
       <input type="text" placeholder="검색할 내용을 입력해주세요">
       <button type="button" class="btn4">
           <i class="xi-search"></i>
       </button>
   </div>
   <!-- 검색영역 끝 -->
</div>
<!-- =============== 컨텐츠 영역 끝 =============== -->