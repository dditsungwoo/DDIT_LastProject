<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/views/tiles/taglib.jsp"%>
<script src="/resources/script/approval/myList.js"></script>

<!-- =============== 상단타이틀영역 시작 =============== -->
<div class="wf-tit-wrap">
    <h1 class="page-tit">내 문서함</h1>
    <div class="side-util">
    	<a href="/approval/createView" class="btn2">결재 작성</a>
    </div>
</div>
<!-- =============== 상단타이틀영역 끝 =============== -->

<!-- =============== 컨텐츠 영역 시작 =============== -->
<%-- <div>${docReturnList}</div> --%>
<input type="hidden" id="empNo" value="<%= session.getAttribute("empNo") %>">
<div class="wf-content-wrap">
    <div class="tab-type tab-type2">
        <div class="tab-menu">
            <!-- "active"가 추가되면 메뉴가 활성화됩니다. -->
            <button data-tab="tab1" type="button" class="tab-btn active">결재 대기</button>
            <button data-tab="tab2" type="button" class="tab-btn">결재 진행</button>
            <button data-tab="tab3" type="button" class="tab-btn">결재 완료</button>
            <button data-tab="tab4" type="button" class="tab-btn">반려</button>
            <button data-tab="tab5" type="button" class="tab-btn">회수</button>
            <button data-tab="tab6" type="button" class="tab-btn">임시 저장함</button>
            <div class="tab-indicator"></div>
        </div>

        <!-- tab-content에 "active"가 추가되면 컨텐츠창이 활성화됩니다. -->
        <!-- tab1  -->
        <div data-tab="tab1" class="tab-content tab-content1 active">
            <div class="tab-board-lst">

                <div class="wf-content-area">
                    <table class="wf-table">
                        <colgroup>
                            <col style="width: auto;">
                            <col style="width: auto;">
                            <col style="width: auto;">
                            <col style="width: auto;">
                            <col style="width: auto;">
                            <col style="width: auto;">
                            <col style="width: auto;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>문서종류</th>
                                <th>제목</th>
                                <th>기안자</th>
                                <th>직급/직책</th>
                                <th>소속부서</th>
                                <th>기안일시</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
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
        </div>
        
        <!-- tab2  -->
        <div data-tab="tab2" class="tab-content tab-content2">
      		<div class="tab-board-lst">

               <div class="wf-content-area">
                   <table class="wf-table">
                       <colgroup>
                           <col style="width: auto;">
                           <col style="width: auto;">
                           <col style="width: auto;">
                           <col style="width: auto;">
                       </colgroup>
                       <thead>
                           <tr>
							<th>번호</th>
                            <th>문서종류</th>
                            <th>제목</th>
                            <th>기안일시</th>
                           </tr>
                       </thead>
                       <tbody></tbody>
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
        </div>

        <!-- tab3  -->
        <div data-tab="tab3" class="tab-content tab-content3">
            <div class="tab-board-lst">

                <div class="wf-content-area">
                    <table class="wf-table">
                        <colgroup>
                            <col style="width: auto;">
                            <col style="width: auto;">
                            <col style="width: auto;">
                            <col style="width: auto;">
                            <col style="width: auto;">
                            <col style="width: auto;">
                            <col style="width: auto;">
                            <col style="width: auto;">
                        </colgroup>
                        <thead>
                            <tr>
                            	<th>번호</th>
                                <th>문서종류</th>
                                <th>제목</th>
                                <th>기안자</th>
                                <th>직급/직책</th>
                                <th>소속부서</th>
                                <th>기안일시</th>
                                <th>최종결재일시</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
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
        </div>
        
        <!-- tab4  -->
        <div data-tab="tab4" class="tab-content tab-content4">
            <div class="tab-board-lst">

                <div class="wf-content-area">
                    <table class="wf-table">
                        <colgroup>
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
                                <th>기안일시</th>
                                <th>반려일자</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
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
        </div>
        
        <!-- tab5  -->
        <div data-tab="tab5" class="tab-content tab-content5">
            <div class="tab-board-lst">

                <div class="wf-content-area">
                    <table class="wf-table">
                        <colgroup>
                            <col style="width: 20%;">
                            <col style="width: 20%;">
                            <col style="width: 20%;">
                            <col style="width: 20%;">
                            <col style="width: 20%;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>문서종류</th>
                                <th>제목</th>
                                <th>기안일시</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody></tbody>
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
        </div>
        
        <!-- tab6 -->
        <div data-tab="tab6" class="tab-content tab-content6">
            <div class="tab-board-lst">

                <div class="wf-content-area">
                    <table class="wf-table">
                        <colgroup>
                            <col style="width: 20%;">
                            <col style="width: 20%;">
                            <col style="width: 20%;">
                            <col style="width: 20%;">
                            <col style="width: 20%;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>문서종류</th>
                                <th>제목</th>
                                <th>생성일자</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody></tbody>
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
        </div>
    </div>
</div>
<!-- =============== 컨텐츠 영역 끝 =============== -->