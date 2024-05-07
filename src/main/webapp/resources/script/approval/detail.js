// 파라미터 조회
const _queryString = window.location.search;
const _params = new URLSearchParams(_queryString);
const _apvNo = _params.get('apvNo');


$(function () {

    createDetailCont();

    // 상세 내용 줄바꿈
    $('#apvCn .convert-txt').append(convertText($('#apvCn_val').val()));

    // 회수
    $('#docReturn_btn').on('click', docReturn);

    // 승인
    $('#approval_btn').on('click', approval);

    // 반려
    $('#refuse_btn').on('click', refuse);

    // 새창으로 보기
    $('#apv_open').on('click', function () {


        let target = $('.apv-doc-form')[0];
        html2canvas(target).then(canvas => {
            let imgData = canvas.toDataURL('image/png');
            let pdf = new jsPDF();
            pdf.addImage(imgData, 'PNG', 0, 0, pdf.internal.pageSize.getWidth(), pdf.internal.pageSize.getHeight());
            let blob = pdf.output('blob');
            let url = URL.createObjectURL(blob);
            let newWindow = window.open(url, '_blank', 'width=970,height=920');
            newWindow.focus();
        });
    });

    //================================================================
    // jsPDF 다운로드
    let jsPDF = jspdf.jsPDF;

    // pdf download
    $("#pdf_btn").on("click", function () {
        html2canvas($('#pdfViewer')[0]).then(function (canvas) {
            var imgData = canvas.toDataURL('image/png');
            var imgWidth = 210;
            var pageHeight = imgWidth * 1.414;
            var imgHeight = parseInt(canvas.height * imgWidth / canvas.width);
            var heightLeft = imgHeight;
            var margin = 0;

            var doc = new jsPDF('p', 'mm', 'a4');
            var position = 0;

            // 첫 페이지 출력
            doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
            heightLeft -= pageHeight;

            // 페이지가 더 있을 경우 루프 돌면서 출력
            while (heightLeft >= 0) {
                position = heightLeft - imgHeight;
                doc.addPage();
                doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
                heightLeft -= pageHeight;
            }

            let doc_name = $('.doc-name').text();

            doc.save(`${doc_name}.pdf`);
        });
    });

});

// PDF 다운로드 후 Blob URL 생성 및 프리뷰에 바인딩
function createBlobUrl(doc) {
    let blobPDF = new Blob(
        [doc.output('blob')],
        { type: 'application/pdf' }
    );

    // Blob URL 생성
    let blobUrl = window.URL.createObjectURL(blobPDF);

    // iframe에 url 바인딩
    $('#pdf_preview').attr('src', blobUrl);
}

// 문자열 컨버트 함수
function convertText(text) {
    return text.replace(/\r?\n/g, '<br>');
}

// 회수
function docReturn() {

    let data = {
        apvNo: _apvNo,
        apvEmpNo: $('#empNo').val()
    }

    Swal.fire({
        title: _msg.approval.returnConfirm,
        showDenyButton: true,
        confirmButtonText: "회수",
        denyButtonText: "취소",
    }).then((result) => {
        if (result.isConfirmed) {

            $.ajax({
                url: `${_ctx}/approval/docReturn`,
                type: "put",
                contentType: 'application/json',
                data: JSON.stringify(data),
                dataType: "json",
                success: (data) => {
                    if (data > 0) {
                        Toast.fire({
                            icon: "success",
                            title: _msg.approval.returnSuccessAlert,
                        });
                        location.href = `${_ctx}/approval/listView`;
                    } else {
                        Toast.fire({
                            icon: "info",
                            title: _msg.approval.returnFailAlert,
                        });
                    }
                }
            });

        } else if (result.isDenied) {
            // 실패 알림 출력
            Toast.fire({
                icon: "info",
                title: _msg.approval.returnConfirmFailAlert,
            });
        }
    });

}


// 승인
function approval() {
    $.ajax({
        url: `${_ctx}/approval/approval`,
        type: 'post',
        contentType: 'application/json',
        data: JSON.stringify(_apvNo),
        dataType: "json",
        success: (data) => {
            if (data > 0) {
                Toast.fire({
                    icon: "success",
                    title: _msg.approval.approvalSuccessAlert,
                });
                location.href = `${_ctx}/approval/mainView`;
            } else {
                Toast.fire({
                    icon: "info",
                    title: _msg.approval.approvalFailAlert,
                });
            }
        }
    });
}

// 반려
function refuse() {
    $.ajax({
        url: `${_ctx}/approval/refuse`,
        type: "put",
        data: JSON.stringify(_apvNo),
        contentType: 'application/json; charset=utf-8',
        dataType: "json",
        success: (data) => {
            if (data > 0) {
                Toast.fire({
                    icon: "success",
                    title: _msg.approval.refuseSuccessAlert,
                });
                location.href = `${_ctx}/approval/mainView`;
            } else {
                Toast.fire({
                    icon: "info",
                    title: _msg.approval.refuseFailAlert,
                });
            }
        }
    });
}

// 기타 내용 출력
function createDetailCont() {

    let apvNo = location.search.slice(7);

    $.ajax({
        url: `${_ctx}/approval/approvalDetailView/${apvNo}`,
        type: 'get',
        dataType: 'json',
        success: (data) => {

            let { apvVo, apvLineList, apvReferVOList } = data;
            let apvLineFirst; // 기안자

            // 출장신청서 기타 내용
            if (apvVo.apvEtc !== null && apvVo.apvEtc !== "null") {
                let info = JSON.parse(apvVo.apvEtc);
                $('#etc').append(_HTML.detail.tr(info));
            }

            for (let i = 0; i < apvLineList.length; i++) {
                apvLineFirst = apvLineList[0];
                let second = apvLineList[1]; // 검토자
                // let last = apvLineList[apvLineList.length - 1]; // 마지막 결재자
                let e = apvLineList[i];

                // 결재 완료 문서 판별
                // if (last.apvSeCd === "3" && last.apvSttusCd === "Y") break;

                // 결재 진행중일때 버튼 활성화 여부 결정
                if ($('#empNo').val() === e.apvEmpNo) {

                    // 기안자
                    if (e.apvSeCd === "1") {
                        if (e.apvSttusCd === "Y" && second.apvSttusCd === "0") {
                            $('#docReturn_btn').show(); // 회수 버튼 활성화
                        } else if (e.apvSttusCd === "Y") {
                            $('#docReturn_btn').hide(); // 회수 버튼 비활성화
                        }
                    }
                    // 검토자
                    if (e.apvSeCd === "2") {
                        if (e.apvSttusCd === "0") {
                            $('#refuse_btn').show();   // 반려 버튼 활성화
                            $('#approval_btn').show(); // 승인 버튼 활성화
                        } else {
                            $('#refuse_btn').hide();   // 반려 버튼 비활성화
                            $('#approval_btn').hide(); // 승인 버튼 비활성화
                        }
                    }

                    // 결재자
                    if (second.apvSttusCd === "Y" && e.apvSeCd === "3") {
                        if (e.apvSttusCd === "0") {
                            $('#refuse_btn').show();   // 반려 버튼 활성화
                            $('#approval_btn').show(); // 승인 버튼 활성화
                        } else {
                            $('#refuse_btn').hide();   // 반려 버튼 비활성화
                            $('#approval_btn').hide(); // 승인 버튼 비활성화
                        }
                    }
                }
            }

            // 첨부파일
            if (!(apvVo.atchmnflNm === null)) {
                let html = `
                    <li>
                        <div class="wrap wrap1">
                            <span class="file-name">${apvVo.atchmnflOriginNm}</span>
                            <span class="user-info">${apvLineFirst.deptNm} ${apvLineFirst.empNm} ${apvLineFirst.apvPosition}</span>
                        </div>
                        <div class="wrap wrap2">
                            <span class="file-size">${apvVo.atchmnflSize}KB</span>
                            <span class="date">${apvVo.drftDate.split(" ")[0]}</span>
                        </div>
                        <a href="#" class="file-download"></a>
                    </li>
                `;

                // html = $(html).apvVo('info', apvVo.atchmnflOriginNm);
                $('#fileList').append(html);

                // 파일 다운로드
                $('#fileList .file-download').on('click', (e) => {
                    e.preventDefault();
                    let url = _storage + apvVo.atchmnflNm;
                    let a = document.createElement('a');
                    a.download = apvVo.atchmnflOriginNm;
                    a.href = url;
                    // a.download = $('#fileList li').apvVo('info');
                    document.body.appendChild(a);
                    a.click();
                    document.body.removeChild(a);
                });

            } else {
                let html = `
                <ul style="display: flex; align-items: center; justify-content: center; min-height: 57px;">
                    <li><div class="no-data">등록된 첨부파일이 없습니다.</div></li>
                </ul>
                `;
                $('#fileList').append(html);
            }
        }
    });
}