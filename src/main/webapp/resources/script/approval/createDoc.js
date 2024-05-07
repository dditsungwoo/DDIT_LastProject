function createDoc(HTML) {
    let docCont = $('#doc_cont');
    let docContLi = docCont.find('li');
    let titArea = docContLi[0];
    docContLi.not(titArea).remove();

    $('#doc_cont').append(HTML);
}

// 품의서
export function createDoc1() {
    const HTML = `
        <li style="height: 100%;">
        	<textarea id="cont" style="height: 100%;" placeholder="내용을 입력해주세요"></textarea>
        </li>
    `;
    createDoc(HTML);
}

// 출장신청서
export function createDoc2() {
    const HTML = `
    	<li>
    		<textarea id="cont" style="min-height: 100px;" placeholder="내용을 입력해주세요"></textarea>
    	</li>
       <li class="create-doc" style="height:100%;">
            <button id="emp_add_btn" type="button" class="btn5 emp-add-btn">
                <i class="xi-user-plus-o"></i> 출장자 추가
            </button>
            <div class="doc-sub-wrap">
                <div class="doc-sub">
                    <div class="doc-tit-wrap">
                        <span class="doc-sub-tit autocomplete">출장자</span>
                    </div>
                    <div class="doc-sub-inner">
                        <input type="text" id="name" placeholder="성명">
                        <input type="text" id="dept" placeholder="소속">
                        <input type="text" id="position" placeholder="직급">
                        <input type="text" id="empId" placeholder="사번">
                    </div>
                </div>
                <div class="doc-sub">
                    <span class="doc-sub-tit">출장지</span>
                    <div class="doc-sub-inner">
                        <input type="text" id="destination" placeholder="출장지">
                    </div>
                </div>
                <div class="doc-sub">
                    <div class="doc-tit-wrap">
                        <span class="doc-sub-tit">출장일정별</span>
                    </div>
                    <div class="doc-sub-inner">
                        <input type="date" id="startDate" data-placeholder="시작일자 선택" required>
                        <span> ~ </span>
                        <input type="date" id="endDate" data-placeholder="종료일자 선택" required>
                        <input type="text" id="task" placeholder="업무내용">
                    </div>
                </div>
                <div class="doc-sub">
                    <span class="doc-sub-tit">출장비</span>
                    <div class="doc-sub-inner">
                        <input type="text" id="accommodation" placeholder="숙박비">
                        <input type="text" id="dailyAllowance" placeholder="일당">
                        <input type="text" id="transportation" placeholder="교통비">
                        <input type="text" id="other" placeholder="기타">
                        &nbsp; 합계 <input type="text" id="total" placeholder="계">
                    </div>
                </div>
            </div>
        </li>
    `;
    createDoc(HTML);
}

// 도서구입신청서
export function createDoc3() {
    const HTML = `
    	<li>
	        <textarea id="cont" style="min-height: 100px;"
	        placeholder="내용을 입력해주세요"></textarea>
	    </li>
	    
	    <li class="create-doc" style="height: 100%;">
	        <div class="doc-sub">
	            <span class="doc-sub-tit">구입사유</span>
	            <div class="doc-sub-inner">
	                <input type="text" placeholder="구입사유">
	            </div>
	        </div>
	        <div class="doc-sub">
	            <div class="doc-tit-wrap">
	                <span class="doc-sub-tit">도서목록 신청</span>
	                <button type="button" class="add-btn">
	                    <i class="xi-plus-circle"></i>
	                </button>
	            </div>
	            <div class="doc-sub-inner">
	                <ul class="bul-lst01">
	                    <li>
                            <input type="text" id="title" placeholder="도서명">
                            <input type="text" id="author" placeholder="저자">
                            <input type="text" id="publisher" placeholder="출판사">
                            <input type="text" id="qty" placeholder="수량">
                            <input type="text" id="unitPrice" placeholder="예상단가">
                            <input type="text" id="totalAmount" placeholder="금액">
	                    </li>
	                    <!-- <li>
                            <input type="text" id="title" placeholder="도서명">
                            <input type="text" id="author" placeholder="저자">
                            <input type="text" id="publisher" placeholder="출판사">
                            <input type="text" id="qty" placeholder="수량">
                            <input type="text" id="unitPrice" placeholder="예상단가">
                            <input type="text" id="totalAmount" placeholder="금액">
	                        <button type="button" class="remove-btn">
	                            <i class="xi-minus-circle"></i>
	                        </button>
	                    </li> -->
	                </ul>
	            </div>
	        </div>
	        <div class="doc-sub">
	            <div class="doc-sub-inner">
	                <span class="tit">합계</span>
	                <input type="text" placeholder="">
	                <span class="tit">금액</span>
	                <input type="text" placeholder="">
	            </div>
	        </div>
	    </li>
    `;
    createDoc(HTML);
}
