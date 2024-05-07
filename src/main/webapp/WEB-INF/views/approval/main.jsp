<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/views/tiles/taglib.jsp"%>
<!-- <script src="https://unpkg.com/@popperjs/core@2/dist/umd/popper.js"></script> -->
<script src="https://unpkg.com/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="${_script}/common/util.js"></script>
<script src="${_script}/approval/html.js"></script>
<script src="${_script}/approval/main.js"></script>
<script src="${_script}/approval/sign.js"></script>

<!-- =============== 상단타이틀영역 시작 =============== -->
<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
	<h1 class="page-tit">결재 진행 현황</h1>
	<div class="side-util">
    	<a href="/approval/createView" class="btn2">결재 작성</a>
	</div>
</div>
<!-- =============== 상단타이틀영역 끝 =============== -->
<!-- =============== 컨텐츠 영역 시작 =============== -->

<div class="wf-content-wrap approval-cont-wrap">
   <div class="wf-flex-box between">

      <article class="left">
          <div class="wf-content-area status-box-area" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
              <div class="status-box" >
			      <a href="/approval/listView?tabId=1">
				      <div class="info-wrap">
	                      <p class="tit">대기 문서</p>
	                      <div class="count" id="pendingCnt">0</div>
	                  </div>
			      </a>
              </div>
              <div class="status-box">
              	  <a href="/approval/listView?tabId=2">
	              	  <div class="info-wrap">
	                      <p class="tit">진행 문서</p>
	                      <div class="count" id="progressCnt">0</div>
	                  </div>
              	  </a>
              </div>
              <div class="status-box">
				  <a href="/approval/listView?tabId=3">
	                  <div class="info-wrap">
	                      <p class="tit">완료 문서</p>
	                      <div class="count" id="completedCnt">0</div>
	                  </div>
				  </a>
              </div>
              <div class="status-box">
              	  <a href="/approval/listView?tabId=4">
	                  <div class="info-wrap">
	                      <p class="tit">반려 문서</p>
	                      <div class="count" id="rejectedCnt">0</div>
	                  </div>
              	  </a>
              </div>
          </div>
          <div class="wf-content-area process-area" data-aos="fade-right" data-aos-duration="700" data-aos-delay="400">
              <p class="heading1">결재 진행</p>
              <span class="sub-txt">여러명인 검토자에 마우스를 올리면 검토자들의 현재 결재 상태를 확인할 수 있습니다.</span>
              <div class="approval-process">
                  <section>
                      <div class="process-cont">
                          <div class="process-bar"></div>
                      </div>
                  </section>
              </div>
          </div>
      </article>
      <article class="right" data-aos="fade-right" data-aos-duration="700" data-aos-delay="600">
          <div class="wf-content-area sign-area">
              <p class="heading1">전자 서명</p>
              <div class="sign-cont">
              		<button id="SIGN_BTN" class="signature-btn">클릭하여 서명</button>
					<img id="SIGN_IMG" class="signature-btn" style="display:none;">
              		<form id="uploadForm" enctype="multipart/form-data">
              			<input id="SIGN_FILE" name="upload" type="file" style="display:none;">
              		</form>
              </div>
          </div>
          <div class="wf-content-area" id="pending">
              <p class="heading1">결재 대기</p>
              <ul class="form-list"></ul>
          </div>
          <div class="wf-content-area" id="completed">
              <p class="heading1">결재 완료</p>
              <ul class="form-list"></ul>
          </div>
      </article>
  </div>
	
</div>
<!-- =============== 컨텐츠 영역 끝 =============== -->

<!-- =============== 서명 모달 시작 =============== -->
<div class="modal" id="sign_modal">
   <div class="modal-cont" style="min-width:480px;">
	   <h1 class="modal-tit">전자 서명</h1>
	   <div class="modal-content-area">
			<div class="sign-pad-wrap">
				<canvas id="SIGN_PAD_CANVAS" class="sign-pad" width="400" height="400" style="cursor: crosshair;"></canvas>
				<span class="sign-pad-txt">마우스로 서명을 입력하세요.</span>
<!-- 				<div class="sign-edge"> -->
<!-- 					<span class="top-left"></span> -->
<!-- 					<span class="top-right"></span> -->
<!-- 					<span class="bottom-left"></span> -->
<!-- 					<span class="bottom-right"></span> -->
<!-- 				</div> -->
			</div>
			<div class="sign-pad-tools">
				<button id="RESET" class="reset-btn"><i class="xi-undo"></i>초기화</button>
				<div>
					<button id="UPLOAD" class="down-btn"><i class="xi-upload"></i>업로드</button>
					<button id="DOWNLOAD" class="down-btn" style="margin-left: 5px;"><i class="xi-download"></i>다운로드</button>
					<input id="FILE" type="file" accept=".png, .jpg" style="display:none;">
				</div>
			</div>
		</div>
        <div class="modal-btn-wrap">
            <button id="CANCEL_BTN" class="btn6">취소</button>
            <button id="SAVE_BTN" class="btn2">저장</button>
        </div>
		
	    <button id="SIGNPAD_CLOSE" class="close-btn"></button>
    </div>
</div>
<!-- =============== 서명 모달 끝 =============== -->

