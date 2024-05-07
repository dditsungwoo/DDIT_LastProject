<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/views/tiles/taglib.jsp"%>

<!-- jstree -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.15/themes/default/style.min.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.15/jstree.min.js"></script>

<script src="${_script}/approval/html.js"></script>
<script src="${_script}/common/util.js"></script>
<script src="${_script}/approval/createDoc.js" type="module"></script>
<script src="${_script}/approval/approval.js" type="module"></script>
<script src="${_script}/approval/approvalLine.js"></script>
<script src="${_script}/approval/approvalRefer.js"></script>
<script src="${_script}/approval/reWrite.js"></script>

<!-- =============== 상단타이틀영역 시작 =============== -->
<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
    <h1 class="page-tit">결재 작성</h1>
    <div class="wf-util">
    	<button type="button" class="btn1" id="autoInput">자동입력</button>
        <button type="button" class="btn1" onclick="history.back()">취소</button>
        <button type="button" class="btn4" id="preview_btn">미리보기</button>
        <button type="button" class="btn3" id="temp_btn">임시저장</button>
        <button type="button" class="btn2" id="save_btn">결재상신</button>
    </div>
</div>
<!-- =============== 상단타이틀영역 끝 =============== -->
<div>
	<input type="hidden" id="empNo" value="<%= session.getAttribute("empNo") %>">
	<input type="hidden" id="empNm" value="<%= session.getAttribute("empNm") %>">
	<input type="hidden" id="deptNm" value="<%= session.getAttribute("deptNm") %>">
	<input type="hidden" id="position_s" value="<%= session.getAttribute("position") %>">
	<input type="hidden" id="rspnsblCtgryNm" value="<%= session.getAttribute("rspnsblCtgryNm") %>">
</div>
<!-- =============== 컨텐츠 영역 시작 =============== -->
<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
    <div class="approval-create-wrap wf-flex-box">
		<div class="wf-content-area left">
		<ul class="wf-insert-form3" id="doc_cont" style="height: 100%;" data-id="1">
		   <li class="tit-area">
		       <div class="wf-insert-tit">
		           <div class="wf-select-group">
		               <select name="docFormNo" id="docFormNo">
		               	   <option value="0" selected>양식 선택</option>
		                   <option value="1" >품의서</option>
		                   <option value="2">출장신청서</option>
		                   <option value="3">도서구입신청서</option>
		               </select>
		           </div>
		           <input type="text" id="tit" placeholder="제목을 입력해주세요">
		       </div>
		   </li>
		   <li style="height: 100%;">
		       <!-- <textarea name="editor" class="editor" id="cont"
		placeholder="내용을 입력해주세요"></textarea> -->
		       <textarea id="cont" style="height: 100%;" placeholder="내용을 입력해주세요"></textarea>
               </li>
           </ul>
        </div>
        <div class="wf-content-area right">
            <div class="approval-write-box">
                <div class="tit-wrap">
                    <p class="heading2">결재라인</p>
                    <button type="button" class="add-btn" id="apv_modal_btn">
                        <i class="xi-users-plus"></i>
                    </button>
                </div>
                <ul class="approval-add-user bul-lst01 no-data" id="apv_line1">
                 <!--    <li>
                        <div class="user">
                            <span class="dept">개발팀</span>
                            <span>이소망</span>
                            <span>사원</span>
                        </div>
                        <span class="approval-status1">기안</span>
                    </li>
                    <li>
                        <div class="user">
                            <span class="dept">개발팀</span>
                            <span>이소망</span>
                            <span>사원</span>
                        </div>
                        <span class="approval-status2">검토</span>
                    </li>
                    <li>
                        <div class="user">
                            <span class="dept">개발팀</span>
                            <span>이소망</span>
                            <span>사원</span>
                        </div>
                        <span class="approval-status3">결재</span>
                    </li> -->
                </ul>
            </div>
            <div class="approval-write-box">
                <div class="tit-wrap">
                    <p class="heading2">참조인</p>
                    <button type="button" class="add-btn" id="APV_REFER_MODAL_BTN">
                        <i class="xi-users-plus"></i>
                    </button>
                </div>
                <ul class="approval-add-user bul-lst01 no-data" id="apv_line2">
                <!--     <li>
                        <div class="user">
                            <span class="dept">개발팀</span>
                            <span>이소망</span>
                            <span>사원</span>
                        </div>
                    </li> -->
                </ul>
            </div>
            <div class="approval-write-box">
                <div class="tit-wrap">
                    <p class="heading2">첨부파일</p>
                    <label for="file-custom" class="file-btn">
                        <input type="file" id="file-custom" multiple>
                    </label>
                </div>
                <ul class="file-lst">
                    <li class="all-remove">
                        <span class="checkbox-radio-custom">
                            <input type="checkbox" name="chck" id="all-check">
                            <label for="all-check"></label>
                        </span>
                        <span class="file-name">전체 삭제</span>
                        <button type="button" class="file-all-remove">
                        </button>
                    </li>
                </ul>
                    
<!--                     <li> -->
<!--                         <span class="checkbox-radio-custom"> -->
<!--                             <input type="checkbox" name="chck" id="chck"> -->
<!--                             <label for="chck"></label> -->
<!--                         </span> -->
<!--                         <span class="file-name">파일 이름</span> -->
<!--                         <span class="file-size">512KB</span> -->
<!--                         <button type="button" class="file-remove"> -->
<!--                         </button> -->
<!--                     </li> -->
            </div>
        </div>
    </div>
</div>
<!-- =============== 컨텐츠 영역 끝 =============== -->

<!-- =============== 결재라인 선택 모달 시작 =============== -->
<div id="APV_LINE_MODAL" class="modal">
    <div class="modal-cont" style="min-width:850px;">
        <h1 class="modal-tit">결재라인</h1>
        <div class="modal-content-area">

       <!-- modal-approval-cont -->
       <div class="modal-approval-cont" style="min-height: 597px;">
           <div class="left">
               <div class="tab-type tab-type1">
                   <div class="tab-menu">
                       <button id="MODAL_BKMK_BTN" data-tab="tab1" type="button" class="tab-btn active">즐겨찾기</button>
                       <button id="MODAL_EMP_BTN" data-tab="tab2" type="button" class="tab-btn">부서</button>
                       <div class="tab-indicator"></div>
                   </div>

                   <!-- tab1  -->
                   <div data-tab="tab1" class="tab-content active">
                       <div class="tab-board-lst" style="height: 560px;">
                           <ul id="MODAL_BKMK_LIST" class="bookmark-list bul-lst01">
                           </ul>
                       </div>
                   </div>

                   <!-- tab2  -->
                        <div data-tab="tab2" class="tab-content">
                            <div class="tab-board-lst" style="height: 560px;">
                            	<div id="MODAL_EMP_LIST"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="right">
                    <ul id="MODAL_APV_LINE_LIST" class="approval-add-user line bul-lst01 line-no-data">
                    </ul>
                </div>
            </div>
        </div>

        <div class="modal-btn-wrap">
            <button class="btn5" id="MODAL_BKMK_SAVE_BTN">즐겨찾기 저장</button>
            <button class="btn2" id="MODAL_APV_LINE_SAVE_BTN">확인</button>
        </div>

        <button class="close-btn"></button>
    </div>
</div>
<!-- =============== 결재라인 선택 모달 끝 =============== -->

<!-- =============== 참조인 선택 모달 시작 =============== -->
<div id="APV_REFER_MODAL" class="modal" >
    <div class="modal-cont" style="min-width:850px;">
        <h1 class="modal-tit">참조인</h1>
        <div class="modal-content-area">

       <!-- modal-approval-cont -->
       <div class="modal-approval-cont" style="min-height: 597px;">
           <div class="left">
               <div class="tab-type tab-type1">
                   <div class="tab-menu" style="width: 328px;">
                       <button data-tab="tab1" type="button" class="tab-btn active">부서</button>
                       <div class="tab-indicator" style="width:100%;"></div>
                   </div>

                   <div data-tab="tab1" class="tab-content active">
                       <div class="tab-board-lst">
                       		<div class="container"></div>
                       </div>
                   </div>
                </div>
                </div>
                <div class="right">
                    <ul id="MODAL_APV_REFER_LIST" class="approval-add-user line bul-lst01 no-data refer"></ul>
                </div>
            </div>
        </div>

        <div class="modal-btn-wrap" style="padding-top: 20px;">
            <button class="btn2" id="MODAL_APV_REFER_SAVE_BTN">확인</button>
        </div>

        <button class="close-btn"></button>
    </div>
</div>
<!-- =============== 참조인 선택 모달 끝 =============== -->

<!-- =============== 미리보기 모달 시작 =============== -->
<div class="modal" id="preview_modal">
   <div class="modal-cont" style="min-width:1000px;">
	   <h1 class="modal-tit">결재 미리보기</h1>
	   <div class="modal-content-area">
	       <div class="apv-doc-form-wrap">
	           <div class="apv-doc-form">
	               <!-- form 들어갈 위치 -->
	           </div>
	        </div>
		</div>
	    <button class="close-btn"></button>
    </div>
</div>
<!-- =============== 미리보기 모달 끝 =============== -->