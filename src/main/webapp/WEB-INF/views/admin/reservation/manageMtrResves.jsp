<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Javascript -->
<script src="${pageContext.request.contextPath}/resources/script/common/commonForSchAndRsv.js" defer></script>
<script>
    $(function () {
        // 회의실 예약 목록 불러오기
        adminGetMtrResveList(1, "", "");

        // 예약 현황 탭 클릭하면 회의실 예약 목록 불러오기
        $("#mtrRsvBtn").on("click", function () {
            adminGetMtrResveList(1, "", "");
        });

        // 지난 예약 탭 클릭하면 지난 회의식 예약 목록 불러오기
        $("#pastMtrRsvtBtn").on("click", function () {
            adminGetPastMtrResveList(1, "", "");
        });

        // 검색 버튼 클릭하면
        $("#searchBtn").on("click", function () {
            console.log("search buton clicked");
            let searchOption = $("#searchOption").val();
            let keyword = $("#keyword").val().trim();
            adminGetMtrResveList(1, searchOption, keyword);
        });

        // 검색 버튼 클릭하면
        $("#pastSearchBtn").on("click", function () {
            console.log("search buton clicked");
            let searchOption = $("#pastSearchOption").val();
            let keyword = $("#pastKeyword").val().trim();
            adminGetPastMtrResveList(1, searchOption, keyword);
        });
    });

    // 회의실 예약 목록 불러오기
    function adminGetMtrResveList(currentPage, searchOption, keyword) {
        let data = {
            currentPage: currentPage,
            searchOption: searchOption,
            keyword: keyword,
        };
        $.ajax({
            url: "/admin/reservations/mtr",
            type: "GET",
            data: data,
            dataType: "json",
            success: function (rsvs) {
                console.log("rsvs : ", rsvs);

                $("#divPaging").html(rsvs.pagingArea);
                $("#mtrRsvBody").empty();
                if (!rsvs.total) {
                    let rowStr = `<tr>
                                        <td colspan="7">
                                            <p>회의실 예약이 없습니다.</p>
                                        </td>
                                    </tr>`;
                    $("#mtrRsvBody").append(rowStr);
                } else {
                    $.each(rsvs.content, function (index, rsv) {
                        let rowStr = "";

                        let mtrResveDate = new Date(rsv.resveBeginDate.substr(0, 10));
                        let mtrResveDateStr = formatDate(mtrResveDate);

                        // 팀원 정보 불러와서 채우기
                        getEmpInfo(rsv.empNo, function (empInfo) {
                            let deptNm = empInfo.deptNm;
                            let empNm = empInfo.empNm;
                            let position = empInfo.position;
                            let rspnsblCtgryNm = empInfo.rspnsblCtgryNm;
                            if (rspnsblCtgryNm != "팀원") {
                                position = rspnsblCtgryNm;
                            }
                            rowStr += ` <tr>
                                                <td>
                                                    <p>\${rsv.rnum}</p>
                                                </td>
                                                <td>
                                                    <p>\${rsv.mtrNm}</p>
                                                </td>
                                                <td>
                                                    <p>\${rsv.mtrLoc}</p>
                                                </td>
                                                <td>
                                                    <p>\${empNm} \${position}</p>
                                                </td>
                                                <td>
                                                    <p>\${deptNm}</p>
                                                </td>
                                                <td>
                                                    <p>\${mtrResveDateStr} \${rsv.resveBeginDate.substr(11,5)}~\${rsv.resveEndDate.substr(11,5)}</p>
                                                </td>
                                                <td>
                                                    <p>\${rsv.resveCn}</p>
                                                </td>
                                                <td>
                                                    <p>
                                                        <button type="button" class="btn3 listDelBtn" data-id="\${rsv.mtrResveNo}">예약 취소</button>
                                                    </p>
                                                </td>
                                            </tr>`;
                        });
                        $("#mtrRsvBody").append(rowStr);
                    });
                }
                // 내 예약 목록에서 삭제 누르면 삭제 진행
                $(".listDelBtn").on("click", function (e) {
                    mtrResveNo = e.target.dataset.id;

                    deleteMtrResve(mtrResveNo);
                });
            },
        });
    }

    // 지난 예약 목록 불러오기
    function adminGetPastMtrResveList(currentPage, searchOption, keyword) {
        let data = {
            currentPage: currentPage,
            searchOption: searchOption,
            keyword: keyword,
        };
        $.ajax({
            url: "/admin/reservations/mtr/past",
            type: "GET",
            data: data,
            dataType: "json",
            success: function (rsvs) {
                console.log("rsvs : ", rsvs);

                $("#pastDivPaging").html(rsvs.pagingArea);
                $("#pastMtrRsvBody").empty();
                if (!rsvs.total) {
                    let rowStr = `<tr>
                                        <td colspan="7">
                                            <p>회의실 예약이 없습니다.</p>
                                        </td>
                                    </tr>`;
                    $("#mtrRsvBody").append(rowStr);
                } else {
                    $.each(rsvs.content, function (index, rsv) {
                        let rowStr = "";

                        let mtrResveDate = new Date(rsv.resveBeginDate.substr(0, 10));
                        let mtrResveDateStr = formatDate(mtrResveDate);

                        // 팀원 정보 불러와서 채우기
                        getEmpInfo(rsv.empNo, function (empInfo) {
                            let deptNm = empInfo.deptNm;
                            let empNm = empInfo.empNm;
                            let position = empInfo.position;
                            let rspnsblCtgryNm = empInfo.rspnsblCtgryNm;
                            if (rspnsblCtgryNm != "팀원") {
                                position = rspnsblCtgryNm;
                            }
                            rowStr += ` <tr>
                                                <td>
                                                    <p>\${rsv.rnum}</p>
                                                </td>
                                                <td>
                                                    <p>\${rsv.mtrNm}</p>
                                                </td>
                                                <td>
                                                    <p>\${rsv.mtrLoc}</p>
                                                </td>
                                                <td>
                                                    <p>\${empNm} \${position}</p>
                                                </td>
                                                <td>
                                                    <p>\${deptNm}</p>
                                                </td>
                                                <td>
                                                    <p>\${mtrResveDateStr} \${rsv.resveBeginDate.substr(11,5)}~\${rsv.resveEndDate.substr(11,5)}</p>
                                                </td>
                                                <td>
                                                    <p>\${rsv.resveCn}</p>
                                                </td>
                                                <td>
                                                    <p>
                                                        <button type="button" class="btn3 listDelBtn" disabled>예약 취소</button>
                                                    </p>
                                                </td>
                                            </tr>`;
                        });
                        $("#pastMtrRsvBody").append(rowStr);
                    });
                }
            },
        });
    }

    function adminGetAllMtrResveList() {
        adminGetMtrResveList(1, "", "");
        adminGetPastMtrResveList(1, "", "");
    }

    // 예약 삭제
    function deleteMtrResve(mtrResveNo) {
        console.log("delete mtrResveNo : ", mtrResveNo);
        // 삭제 확인창 표시
        Swal.fire({
            title: _msg.reservation.deleteConfirm,
            showDenyButton: true,
            denyButtonText: `취소`,
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: `/api/reservation/mtr/\${mtrResveNo}`,
                    type: "DELETE",
                    dataType: "text",
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function (rslt) {
                        console.log("delete rslt : ", rslt);

                        if (rslt == "success") {
                            Toast.fire({
                                icon: "success",
                                title: _msg.reservation.deleteSuccessAlert,
                            });
                            adminGetAllMtrResveList();
                        } else {
                            Toast.fire({
                                icon: "info",
                                title: _msg.reservation.deleteFailAlert,
                            });
                        }
                    },
                });
            } else if (result.isDenied) {
                Toast.fire({
                    icon: "info",
                    title: _msg.reservation.deleteFailAlert,
                });
            }
        });
    } // 예약 삭제 끝
</script>
<!--------------------------------- body 시작 --------------------------------->
<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
    <h1 class="page-tit">회의실 예약 관리</h1>
</div>
<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
    <div class="tab-type tab-type2">
        <div class="tab-menu">
            <!-- "active"가 추가되면 메뉴가 활성화됩니다. -->
            <button data-tab="tab1" type="button" class="tab-btn active" id="mtrRsvBtn">예약 현황</button>
            <button data-tab="tab2" type="button" class="tab-btn" id="pastMtrRsvtBtn">지난 예약</button>
            <div class="tab-indicator"></div>
        </div>

        <!-- tab1  -->
        <div data-tab="tab1" class="tab-content active">
            <div class="tab-board-lst">
                <div class="wf-content-area" id="calbox">
                    <table class="wf-table">
                        <colgroup>
                            <col style="width: 5%" />
                            <col style="width: 10%" />
                            <col style="width: 10%" />
                            <col style="width: 10%" />
                            <col style="width: 10%" />
                            <col style="width: 20%" />
                            <col style="width: 20%" />
                            <col style="width: 15%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>종류</th>
                                <th>위치</th>
                                <th>예약자</th>
                                <th>부서</th>
                                <th>예약일시</th>
                                <th>사용목적</th>
                                <th>상태변경</th>
                            </tr>
                        </thead>
                        <tbody id="mtrRsvBody"></tbody>
                    </table>
                </div>

                <!-- 페이지네이션 시작 -->
                <nav class="wf-pagination-wrap">
                    <div class="row justify-content-center" id="divPaging"></div>
                </nav>
                <!-- 페이지네이션 끝 -->

                <!-- 검색영역 시작 -->
                <div class="wf-search-area">
                    <div class="select-box">
                        <select id="searchOption">
                            <option value="empNm">예약자명</option>
                            <option value="resveCn">사용목적</option>
                        </select>
                    </div>
                    <input type="text" id="keyword" placeholder="검색할 내용을 입력해주세요" />
                    <button type="button" class="btn4" id="searchBtn">
                        <i class="xi-search"></i>
                    </button>
                </div>
                <!-- 검색영역 끝 -->
            </div>
        </div>

        <!-- tab2  -->
        <div data-tab="tab2" class="tab-content">
            <div class="tab-board-lst">
                <div class="wf-content-area" id="calbox">
                    <table class="wf-table">
                        <colgroup>
                            <col style="width: 5%" />
                            <col style="width: 10%" />
                            <col style="width: 10%" />
                            <col style="width: 10%" />
                            <col style="width: 10%" />
                            <col style="width: 20%" />
                            <col style="width: 20%" />
                            <col style="width: 15%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>종류</th>
                                <th>위치</th>
                                <th>예약자</th>
                                <th>부서</th>
                                <th>예약일시</th>
                                <th>사용목적</th>
                                <th>상태변경</th>
                            </tr>
                        </thead>
                        <tbody id="pastMtrRsvBody"></tbody>
                    </table>
                </div>

                <!-- 페이지네이션 시작 -->
                <nav class="wf-pagination-wrap">
                    <div class="row justify-content-center" id="pastDivPaging"></div>
                </nav>
                <!-- 페이지네이션 끝 -->

                <!-- 검색영역 시작 -->
                <div class="wf-search-area">
                    <div class="select-box">
                        <select name="" id="pastSearchOption">
                            <option value="empNm">예약자명</option>
                            <option value="resveCn">사용목적</option>
                        </select>
                    </div>
                    <input type="text" placeholder="검색할 내용을 입력해주세요" id="pastKeyword" />
                    <button type="button" class="btn4" id="pastSearchBtn">
                        <i class="xi-search"></i>
                    </button>
                </div>
                <!-- 검색영역 끝 -->
            </div>
        </div>
    </div>

    <!--------------------------------- body 끝 --------------------------------->
</div>
