import { createDoc1, createDoc2, createDoc3 } from './createDoc.js';
const _html = _HTML.create;

let _docFormNo; // 선택된 양식
let _tit;       // 제목
let _cont;      // 내용

let _tmprStreYnCd = 'N'; // 임시저장 기본값'N'

createDoc3(); // 도서구입신청서
createDoc2(); // 출장신청서
createDoc1(); // 품의서

$(function () {

    // 자동완성
    $('#autoInput').on('click', autoInput);

    // 출장자 추가 버튼 이벤트
    $(document).on('click', '#emp_add_btn', () => {
        // let html = _html.docType2.emp_add_div(i);
        let i = $('.create-doc').find('.doc-sub-wrap').length + 1;

        let html = `
            <div class="doc-sub-wrap">
                <button type="button" class="btn5 emp-remove-btn">
                    <i class="xi-user-plus-o"></i> 출장자 삭제
                </button>
                <div class="doc-sub">
                    <div class="doc-tit-wrap">
                        <span class="doc-sub-tit">출장자</span>
                    </div>
                    <div class="doc-sub-inner">
                        <input type="text" id="name${i}" placeholder="성명">
                        <input type="text" id="dept${i}" placeholder="소속">
                        <input type="text" id="position${i}" placeholder="직급">
                        <input type="text" id="empId${i}" placeholder="사번">
                    </div>
                </div>
                <div class="doc-sub">
                    <span class="doc-sub-tit">출장지</span>
                    <div class="doc-sub-inner">
                        <input type="text" id="destination${i}" placeholder="출장지">
                    </div>
                </div>
                <div class="doc-sub">
                    <div class="doc-tit-wrap">
                        <span class="doc-sub-tit">출장일정</span>
                    </div>
                    <div class="doc-sub-inner">
                        <input type="date" id="startDate${i}" data-placeholder="시작일자 선택">
                        <span> ~ </span>
                        <input type="date" id="endDate${i}" data-placeholder="종료일자 선택">
                        <input type="text" id="task${i}" placeholder="업무내용">
                    </div>
                </div>
                <div class="doc-sub">
                    <span class="doc-sub-tit">출장비</span>
                    <div class="doc-sub-inner">
                        <input type="text" id="accommodation${i}" placeholder="숙박비">
                        <input type="text" id="dailyAllowance${i}" placeholder="일당">
                        <input type="text" id="transportation${i}" placeholder="교통비">
                        <input type="text" id="other${i}" placeholder="기타">
                        	합계 : <input type="text" id="total${i}" placeholder="계">
                    </div>
                </div>
            </div>
        `;

        $('.create-doc').append(html);
    });

    // 출장자 삭제
    $(document).on('click', '.emp-remove-btn', function () {
        Swal.fire({
            title: _msg.common.deleteConfirm,
            showDenyButton: true,
            confirmButtonText: "삭제",
            denyButtonText: "취소",
        }).then((result) => {
            if (result.isConfirmed) {
                $(this).closest('.doc-sub-wrap').remove();
            } else if (result.isDenied) {
                return false;
            }
        });
    });


    // 미리보기
    $('#preview_btn').on('click', function () {
        if (!($('#docFormNo').val() === '0')) {
            preview();
        } else {
            Toast.fire({
                icon: "info",
                title: _msg.approval.noChoiceAlert,
            });
        }
    });

    // 첨부파일
    $('#file-custom').change((e) => {

        let input = e.target;
        let files = input.files;

        // 파일 목록에 추가
        for (let i = 0; i < files.length; i++) {
            let file = files[i];
            let fileSize = file.size;
            let fileName = file.name;

            // 파일 크기를 KB 단위로 변환
            let fileSizeKB = Math.round(fileSize / 1024);

            let html = `
   				<li>
	                <span class="checkbox-radio-custom">
	                    <input type="checkbox" name="chck" id="chck">
	                    <label for="chck"></label>
	                </span>
	                <span class="file-name">${fileName}</span>
	                <span class="file-size">${fileSizeKB}KB</span>
	                <button type="button" class="file-remove"></button>
	            </li>
			`;

            // 파일 목록에 추가
            $('.file-lst').append(html);
        }

        // "file-remove" 버튼 클릭 시 해당 요소 삭제
        $('.file-remove').click((e) => {
            $(e.currentTarget).parent('li').remove();
        });

        // "전체 삭제" 클릭 시 "all-check" 제외한 모든 체크박스 삭제
        $('.file-all-remove').click(() => {

            // 모든 체크박스가 체크되어 있는지 확인
            let allChecked = true;
            $('input[name="chck"]').each(function () {
                if (!$(this).prop('checked')) {
                    allChecked = false;
                    return false;
                }
            });

            // 모든 체크박스가 체크되어 있을 때만 삭제
            if (allChecked) {
                $('input[name="chck"]').not('#all-check').closest('li').remove();
                $('#all-check').prop('checked', false);
            }
        });

        // "all-check" 클릭 시 모든 체크박스 선택
        $('#all-check').click(function () {
            $('input[name="chck"]').prop('checked', $(this).prop('checked'));
        });

    });

    // 양식 선택 이벤트
    $('select#docFormNo').change((e) => {
        _docFormNo = $(e.currentTarget).val();
        console.log("문서선택 -> ", _docFormNo);

        switch (_docFormNo) {
            case "1":
                $('#doc_cont').attr('data-id', '1');
                createDoc1();
                break;
            case "2":
                $('#doc_cont').attr('data-id', '2');
                createDoc2();
                break;
            case "3":
                $('#doc_cont').attr('data-id', '3');
                createDoc3();
                break;
            default:
                $('#doc_cont').attr('data-id', '1');
                createDoc1();
                break;
        }
    });

    // 임시저장
    $('#temp_btn').on('click', function () {
        var titValue = $('#tit').val();
        var contValue = $('#cont').val();
        let apvLine = $('#apv_line1 li').length;

        if (!titValue && !contValue && apvLine === 0) {
            // alert(_msg.approval.tempEmptyAlert);
            Toast.fire({
                icon: "info",
                title: _msg.approval.tempFailAlert,
            });
        } else {
            Toast.fire({
                icon: "success",
                title: _msg.approval.tempSuccessAlert,
            });
            _tmprStreYnCd = 'Y';
            $('#save_btn').trigger('click');
        }
    });

    // 결재상신
    $('#save_btn').on('click', createApv);
});


// 미리보기
function preview() {

    _docFormNo = $('#docFormNo').val();

    $('#preview_modal').addClass('open');
    $('html').removeClass('scroll-hidden');

    $('.apv-doc-form').empty();

    const today = new Date();
    let apv_date = today.toLocaleString();

    _tit = $('#doc_cont').find('#tit').val();
    _cont = $('#doc_cont').find('#cont').val();

    let empNm = $('#empNm').val();
    let deptNm = $('#deptNm').val();

    let HTML;
    switch (_docFormNo) {
        case "1":
            HTML = type1();
            break;
        case "2":
            HTML = type2();
            break;
        case "3":
            HTML = type3();
            break;
    }

    function type1() {
        return `
            <table>
            <colgroup>
                <col style="width: 10%;">
                <col style="width: 25%;">
                <col style="width: 10%;">
                <col style="width: auto;">
                <col style="width: 7%;">
                <col style="width: auto;">
            </colgroup>
            <tbody>
                <tr>
                    <td colspan="2"><span class="form-tit">품의서</span></td>
                    <td colspan="4">
                        <!-- 결재라인 사인 -->
                        <table class="apv-sign-table">
                            <colgroup>
                                <col style="width: 5%;">
                                <col style="width: 20%;">
                                <col style="width: 20%;">
                                <col style="width: 20%;">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th rowspan="4">결재</th>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th>기안부서</th>
                    <td>${deptNm}</td>
                    <th>기 안 일</th>
                    <td colspan="4">${apv_date}</td>
                    <!-- <th>문서번호</th>
                    <td></td> -->
                </tr>
                <tr>
                    <th>기안자</th>
                    <td>${empNm}</td>
                    <th>보존년한</th>
                    <td colspan="4">3년</td>
                    <!-- <th>비밀등급</th>
                <td></td> -->
                </tr>
                <tr>
                    <th>제목</th>
                    <td colspan="5">
                        <span class="data">${_tit}</span>
                    </td>
                </tr>
                <tr>
                    <td colspan="6">
                        <!-- <div class="data">${_cont}</div> -->
                        <textarea style="min-height: 300px;">${_cont}</textarea>
                    </td>
                </tr>
            </tbody>
        </table>

    	`;
    }

    function type2() {

        const inputData = getInputField();

        return `
           <table>
                <colgroup>
                    <col style="width: 10%;">
                    <col style="width: 25%;">
                    <col style="width: 7%;">
                    <col style="width: 20%;">
                    <col style="width: 7%;">
                    <col style="width: 20%;">
                </colgroup>
                <tbody>
                    <tr>
                        <td colspan="2"><span class="form-tit">출장 신청서</span></td>
                        <td colspan="4">
                            <!-- 결재라인 사인 -->
                            <table class="apv-sign-table">
                                <colgroup>
                                    <col style="width: 5%;">
                                    <col style="width: 20%;">
                                    <col style="width: 20%;">
                                    <col style="width: 20%;">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th rowspan="4">결재</th>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <th>기안부서</th>
                        <td >${deptNm}</td>
                        <th>기 안 일</th>
                        <td colspan="4">${apv_date}</td>
                    </tr>
                    <tr>
                        <th>기안자</th>
                        <td>${empNm}</td>
                        <th>보존년한</th>
                        <td colspan="4">3년</td>
                    </tr>
                    <tr>
                        <th>제목</th>
                        <td colspan="5">
                            <span class="data">${_tit}</span>
                        </td>
                    </tr>
                    <tr>
                        <th>내용</th>
                        <td colspan="5"  style="text-align: left;">
                            ${_cont}
                        </td>
                    </tr>
                </tbody>
            </table>

            <table style="margin-top: 20px;">
                <colgroup>
                    <col width="10%">
                    <col width="25%">
                    <col width="20%">
                    <col width="20%">
                    <col width="15%">
                </colgroup>
                <tbody>
                    <tr>
                        <th rowspan="2">출장자</th>
                        <th>성명</th>
                        <th>소속</th>
                        <th>직급</th>
                        <th>사번</th>
                    </tr>
                    <tr>
                        <td>${inputData.name}</td>
                        <td>${inputData.dept}</td>
                        <td>${inputData.position}</td>
                        <td>${inputData.empId}</td>
                    </tr>
                    <tr>
                        <th>출장지</th>
                        <td colspan="4">${inputData.destination}</td>
                    </tr>
                    <tr>
                        <th rowspan="2">출장일정별</th>
                        <th>일자</th>
                        <th>방문처</th>
                        <th colspan="2">업무내용</th>
                    </tr>
                    <tr>
                        <td colspan="2">${inputData.startDate} ~ ${inputData.endDate}</span></td>
                        <td colspan="2">${inputData.task}</td>
                    </tr>
                    <tr>
                        <th rowspan="6">출장비</th>
                        <th>항목</th>
                        <th>금액</th>
                        <th colspan="2">산출내역</th>
                    </tr>
                    <tr>
                        <td>숙박비</td>
                        <td>${inputData.accommodation}원</td>
                        <td colspan="2">숙박비 = 숙박 일수 × 일일 숙박료 <br> = 3일 × 100,000원 = ${inputData.accommodation}원</td>
                    </tr>
                    <tr>
                        <td>일 당</td>
                        <td>${inputData.dailyAllowance}원</td>
                        <td colspan="2">일당 = 출장자 일당 × 출장 일수</td>
                    </tr>
                    <tr>
                        <td>교 통 비</td>
                        <td>${inputData.transportation}원</td>
                        <td colspan="2">교통비 = 이동 거리 및 교통 수단에 따라 변동</td>
                    </tr>
                    <tr>
                        <td>기타</td>
                        <td>${inputData.other}</td>
                        <td colspan="2">식대: 50,000원<br>
                                        통신비: 30,000원<br>
                                        기타: 20,000원</td>
                    </tr>
                    <tr>
                        <td>계</td>
                        <td>${inputData.total}원</td>
                        <td colspan="2">숙박비 + 일당 + 교통비 + 기타</td>
                    </tr>
                    <tr>
                        <th>비고</th>
                        <td colspan="4"></td>
                    </tr>
                </tbody>
            </table>
		`;
    }

    function type3() {
        return `
            <table>
            <colgroup>
                <col style="width: 10%;">
                <col style="width: 25%;">
                <col style="width: 10%;">
                <col style="width: auto;">
                <col style="width: 7%;">
                <col style="width: auto;">
            </colgroup>
            <tbody>
                <tr>
                    <td colspan="2"><span class="form-tit">도서구입신청서</span></td>
                    <td colspan="4">
                        <!-- 결재라인 사인 -->
                        <table class="apv-sign-table">
                            <colgroup>
                                <col style="width: 5%;">
                                <col style="width: 20%;">
                                <col style="width: 20%;">
                                <col style="width: 20%;">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th rowspan="4">결재</th>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th>기안부서</th>
                    <td>${deptNm}</td>
                    <th>기 안 일</th>
                    <td colspan="4">${apv_date}</td>
                    <!-- <th>문서번호</th>
                    <td></td> -->
                </tr>
                <tr>
                    <th>기안자</th>
                    <td>${empNm}</td>
                    <th>보존년한</th>
                    <td colspan="4">3년</td>
                    <!-- <th>비밀등급</th>
                <td></td> -->
                </tr>
                <tr>
                    <th>제목</th>
                    <td colspan="5">
                        <span class="data">${_tit}</span>
                    </td>
                </tr>
                <tr>
                    <td colspan="6">
                        <!-- <div class="data" >${_cont}</div> -->
                        <textarea style="min-height: 300px;">${_cont}</textarea>
                    </td>
                </tr>
            </tbody>
        </table>
    	`;
    }

    $('.apv-doc-form').append(HTML);
}

// 선택된 문서 데이터 가져오는 함수
function getSelectedDocData() {
    _tit = $('#tit').val();   // 제목
    _cont = $('#cont').val(); // 내용
    let _apvLineData = [];
    let _refer = [];

    // 결재라인
    _apvLineData = $('#apv_line1 li').toArray().map((e) => {
        return {
            apvEmpNo: e.info.empNo,
            apvSeCd: e.info.apvSeCd,
            apvLineSeq: e.info.apvLineSeq
        }
    });
    // 참조인
    _refer = $('#apv_line2 li').toArray().map((e) => {
        return { empNo: e.info.empNo }
    });

    return ['1', '2', '3'].includes(_docFormNo) ?
        {
            "apv": {
                "docFormNo": _docFormNo,
                // "empNo": _empNo,
                "empNo": $('#empNo').val(),
                "apvSj": _tit,
                "apvCn": _cont,
                "sttusCd": "Y",
                "tmprStreYnCd": _tmprStreYnCd // 임시저장 여부코드
            },
            "apvLine": _apvLineData,
            "refer": _refer,

        }
        : null;
}

// 기안 저장
function createApv() {

    const formData = new FormData();

    const data = getSelectedDocData();

    // 출장신청서 
    if (_docFormNo === "2") {
        let inputData = {
            name: $('#name').val(),                       // 출장자
            dept: $('#dept').val(),                       // 소속부서
            position: $('#position').val(),               // 직급
            empId: $('#empId').val(),                     // 사번
            destination: $('#destination').val(),         // 출장지
            startDate: $('#startDate').val(),             // 시작일자
            endDate: $('#endDate').val(),                 // 종료일자
            task: $('#task').val(),                       // 업무내용
            accommodation: $('#accommodation').val(),     // 숙박비
            dailyAllowance: $('#dailyAllowance').val(),   // 일당
            transportation: $('#transportation').val(),   // 교통비
            other: $('#other').val(),                     // 기타
            total: $('#total').val()                      // 총액
        }

        // 출장신청서 데이터(객체를 배열로 변환)
        let inputDataList = [];
        for (let key in inputData) {
            let map = {};
            map[key] = inputData[key];
            inputDataList.push(map);
        }

        formData.append("apvEtc",
            new Blob([JSON.stringify(inputDataList)], { type: "application/json;charset=utf-8" }));
    }

    // 파일
    const files = $('#file-custom')[0].files;
    for (let i = 0; i < files.length; i++) {
        formData.append('files', files[i]);
    }

    formData.append("data",
        new Blob([JSON.stringify(data)], { type: "application/json;charset=utf-8" }));

    if (_tmprStreYnCd === 'N') { // 기안상신

        Swal.fire({
            title: _msg.approval.insertConfirm,
            showDenyButton: true,
            confirmButtonText: "등록",
            denyButtonText: "취소",
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: `${_ctx}/approval/create`,
                    type: 'post',
                    data: formData,
                    processData: false,
                    contentType: false,
                    dataType: "json",
                    success: (data) => {
                        let apvNo = data.apvNo;

                        if (data.isOk > 0) {
                            Toast.fire({
                                icon: "success",
                                title: _msg.approval.insertSuccessAlert,
                            });

                            setTimeout(function () {
                                location.href = `${_ctx}/approval/approvalDetailView?apvNo=` + apvNo;
                            }, 1000);
                        } else {
                            Toast.fire({
                                icon: "info",
                                title: _msg.approval.insertFailAlert,
                            });
                        }
                    }
                });

            } else if (result.isDenied) {
                Toast.fire({
                    icon: "info",
                    title: _msg.approval.insertCancelAlert,
                });
            }
        });

    } else { // 임시저장

        Swal.fire({
            title: _msg.approval.tempConfirm,
            showDenyButton: true,
            confirmButtonText: "임시저장",
            denyButtonText: "취소",
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: `${_ctx}/approval/create`,
                    type: 'post',
                    data: formData,
                    processData: false,
                    contentType: false,
                    dataType: "json",
                    success: function (data) {
                        let apvNo = data.apvNo;

                        if (data.isOk > 0 && data.tmprStreYnCd === 'Y') {
                            Toast.fire({
                                icon: "success",
                                title: _msg.approval.tempSuccessAlert,
                            });

                            setTimeout(function () {
                                location.href = `${_ctx}/approval/listView`;  // 임시저장 목록 페이지로 이동
                            }, 1000);

                        } else {
                            Toast.fire({
                                icon: "info",
                                title: _msg.approval.tempFailAlert,
                            });
                        }
                    }
                });

            } else if (result.isDenied) {
                Toast.fire({
                    icon: "info",
                    title: _msg.approval.tempCancelAlert,
                });
            }
        });
    }
}

// [미리보기 출력] 출장신청서 입력 데이터 반환하여 미리보기에 출력
function getInputField() {
    return {
        name: $('#name').val(),                       // 출장자
        dept: $('#dept').val(),                       // 소속부서
        position: $('#position').val(),               // 직급
        empId: $('#empId').val(),                     // 사번
        destination: $('#destination').val(),         // 출장지
        startDate: $('#startDate').val(),             // 시작일자
        endDate: $('#endDate').val(),                 // 종료일자
        task: $('#task').val(),                       // 업무내용
        accommodation: $('#accommodation').val(),     // 숙박비
        dailyAllowance: $('#dailyAllowance').val(),   // 일당
        transportation: $('#transportation').val(),   // 교통비
        other: $('#other').val(),                     // 기타
        total: $('#total').val()                      // 총액
    }
}

// 자동입력
function autoInput() {
    $('#doc_cont').find('#tit').val('MSA 아키텍처 및 Kubernetes 교육 참여 출장의 건');
    $('#doc_cont').find('#cont').val(`1. 출장 목적:
Microservices Architecture (MSA) 및 Kubernetes 기술에 대한 심층적인 이해 증진
현대적인 애플리케이션 아키텍처 설계와 관리에 필요한 역량 강화

2. 교육 내용 및 참여 계획:
MSA 아키텍처의 개념과 원리에 대한 이해
Kubernetes의 컨테이너 오케스트레이션 기능 및 운영 방법 습득
마이크로서비스 간 통신 및 관리를 위한 서비스 메시 패턴 학습
실전 프로젝트를 통한 Kubernetes 클러스터 구축 및 운영 경험 쌓기

3. 예상 효과 및 기대 이익:
혁신적인 MSA 아키텍처에 대한 이해도 향상 및 적용 능력 향상
Kubernetes를 활용한 클라우드 네이티브 애플리케이션 운영 능력 강화
비즈니스 프로세스의 유연성 및 확장성 향상을 통한 업무 효율성 개선`);

    $('#name').val('유선영');
    $('#dept').val('연구개발본부 개발팀');
    $('#position').val('사원');
    $('#empId').val('2019202');
    $('#destination').val('천안 지사');
    $('#startDate').val('2024-04-18');
    $('#endDate').val('2024-04-19');
    $('#task').val('Kubernetes를 이용한 DevOps운영과 MSA적용');
    $('#accommodation').val('300,000');
    $('#dailyAllowance').val('300,000');
    $('#transportation').val('300,000');
    $('#other').val('');
    $('#total').val('1,000,000');
}

