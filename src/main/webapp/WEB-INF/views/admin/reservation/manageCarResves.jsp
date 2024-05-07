<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Javascript -->
<script src="${pageContext.request.contextPath}/resources/script/common/commonForSchAndRsv.js" defer></script>
<script>
    $(function () {
        adminGetCarResveList(1, "", "");

        // 예약 현황 탭 클릭하면 차량 예약 목록 불러오기
        $("#carRsvBtn").on("click", function () {
            adminGetCarResveList(1, "", "");
        });

        // 반납 관리 탭 클릭하면 반납 처리 해야되는 예약 목록 불러오기
        $("#rturnWaitBtn").on("click", function () {
            adminGetWaitReturnCarResveList(1, "", "");
        });

        // 지난 예약 탭 클릭하면 지난 차량 예약 목록 불러오기
        $("#pastCarRsvBtn").on("click", function () {
            adminGetPastCarResveList(1, "", "");
        });

        // 검색 버튼 클릭하면
        $("#searchBtn").on("click", function () {
            console.log("search buton clicked");
            let searchOption = $("#searchOption").val();
            let keyword = $("#keyword").val().trim();
            adminGetCarResveList(1, searchOption, keyword);
        });

        // 검색 버튼 클릭하면
        $("#rturnSearchBtn").on("click", function () {
            console.log("search buton clicked");
            let searchOption = $("#rturnSearchOption").val();
            let keyword = $("#rturnKeyword").val().trim();
            adminGetWaitReturnCarResveList(1, searchOption, keyword);
        });

        // 검색 버튼 클릭하면
        $("#pastSearchBtn").on("click", function () {
            console.log("search buton clicked");
            let searchOption = $("#pastSearchOption").val();
            let keyword = $("#pastKeyword").val().trim();
            adminGetPastCarResveList(1, searchOption, keyword);
        });
    });

    // 차량 예약 목록 불러오기
    function adminGetCarResveList(currentPage, searchOption, keyword) {
        let data = {
            currentPage: currentPage,
            searchOption: searchOption,
            keyword: keyword,
        };
        $.ajax({
            url: "/admin/reservations/car",
            type: "GET",
            data: data,
            dataType: "json",
            success: function (rsvs) {
                console.log("rsvs : ", rsvs);
                $("#carRsvBody").empty();
                if (!rsvs.total) {
                    let rowStr = `<tr>
                                    <td colspan="8">
                                        <p>차량 예약이 없습니다.</p>
                                    </td>
                                </tr>`;
                    $("#carRsvBody").append(rowStr);
                } else {
                    $.each(rsvs.content, function (index, rsv) {
                        let rowStr = "";
                        // 팀원 정보 불러와서 채우기
                        getEmpInfo(rsv.empNo, function (empInfo) {
                            let deptNm = empInfo.deptNm;
                            let empNm = empInfo.empNm;
                            let position = empInfo.position;
                            let rspnsblCtgryNm = empInfo.rspnsblCtgryNm;
                            if (rspnsblCtgryNm != "팀원") {
                                position = rspnsblCtgryNm;
                            }

                            let carResveSDate = new Date(rsv.resveBeginDate.substr(0, 10));
                            let carResveSDateStr = formatDate(carResveSDate);
                            let carResveEDate = new Date(rsv.resveEndDate.substr(0, 10));
                            let carResveEDateStr = formatDate(carResveEDate);

                            let allDayCd = rsv.allDayCd;
                            let carResveDate = "";
                            if (allDayCd == "1") {
                                carResveDate = `<p>\${carResveSDateStr} ~ \${carResveEDateStr} <span class="wf-badge1">종일</span></p>`;
                            } else {
                                carResveDate = `<p>\${carResveSDateStr} \${rsv.resveBeginDate.substr(11,5)} ~ \${carResveEDateStr} \${rsv.resveEndDate.substr(11,5)}</p>`;
                            }

                            let rturnCd = rsv.rturnCd;
                            console.log("rturnCd", rturnCd);

                            let rturnStr = "";
                            let buttonStr = "";
                            if (rturnCd == "1") {
                                rturnStr = "<span class='wf-badge5'>반납 전</span>";
                                buttonStr = `<button type="button" class="btn5 listRturnBtn" data-id="\${rsv.carResveNo}">반납 처리</button>
                                            <button type="button" class="btn3 listDelBtn" data-id="\${rsv.carResveNo}">예약 취소</button>`;
                            } else if (rturnCd == "2") {
                                rturnStr = "<span class='wf-badge4'>반납 처리 중</span>";
                                buttonStr = `<button type="button" class="btn5 listRturnBtn" data-id="\${rsv.carResveNo}">반납 처리</button>
                                            <button type="button" class="btn3 listDelBtn" disabled>예약 취소</button>`;
                            } else {
                                rturnStr = "<span class='wf-badge3'>반납 완료</span>";
                                buttonStr = `<button type="button" class="btn5 listRturnBtn" disabled>반납 처리</button>
                                            <button type="button" class="btn3 listDelBtn" disabled>예약 취소</button>`;
                            }

                            rowStr += ` <tr>
                                            <td>
                                                <p>\${rsv.rnum}</p>
                                            </td>
                                            <td>
                                                <p>\${rsv.carNm}</p>
                                            </td>
                                            <td>
                                                <p>\${rsv.carNo}</p>
                                            </td>
                                            <td>
                                                <p>\${empNm} \${position}</p>
                                            </td>
                                            <td>
                                                <p>\${deptNm}</p>
                                            </td>
                                            <td>
                                                \${carResveDate}
                                            </td>
                                            <td>
                                                <p>\${rsv.resveCn}</p>
                                            </td>
                                            <td>
                                                <p>\${rturnStr}</p>
                                            </td>
                                            <td>
                                                \${buttonStr}
                                            </td>
                                        </tr>`;
                        });
                        $("#carRsvBody").append(rowStr);
                        $("#divPaging").html(rsvs.pagingArea);
                    });

                    $(".listRturnBtn").on("click", function (e) {
                        carResveNo = e.target.dataset.id;

                        let data = {
                            carResveNo: carResveNo,
                            rturnCd: "3",
                        };

                        updateReturnStatus(data);
                    });

                    $(".listDelBtn").on("click", function (e) {
                        carResveNo = e.target.dataset.id;

                        deleteCarResve(carResveNo);
                    });
                }
            },
        });
    }

    // 반납 처리해야되는 차량 예약 불러오기
    function adminGetWaitReturnCarResveList(currentPage, searchOption, keyword) {
        let data = {
            currentPage: currentPage,
            searchOption: searchOption,
            keyword: keyword,
        };
        $.ajax({
            url: "/admin/reservations/car/waitReturn",
            type: "GET",
            data: data,
            dataType: "json",
            success: function (rsvs) {
                console.log("rsvs : ", rsvs);
                $("#rturnCarRsvBody").empty();
                if (!rsvs.total) {
                    let rowStr = `<tr>
                                    <td colspan="8">
                                        <p>차량 예약이 없습니다.</p>
                                    </td>
                                </tr>`;
                    $("#rturnCarRsvBody").append(rowStr);
                } else {
                    $.each(rsvs.content, function (index, rsv) {
                        let rowStr = "";
                        // 팀원 정보 불러와서 채우기
                        getEmpInfo(rsv.empNo, function (empInfo) {
                            let deptNm = empInfo.deptNm;
                            let empNm = empInfo.empNm;
                            let position = empInfo.position;
                            let rspnsblCtgryNm = empInfo.rspnsblCtgryNm;
                            if (rspnsblCtgryNm != "팀원") {
                                position = rspnsblCtgryNm;
                            }

                            let carResveSDate = new Date(rsv.resveBeginDate.substr(0, 10));
                            let carResveSDateStr = formatDate(carResveSDate);
                            let carResveEDate = new Date(rsv.resveEndDate.substr(0, 10));
                            let carResveEDateStr = formatDate(carResveEDate);

                            let allDayCd = rsv.allDayCd;
                            let carResveDate = "";
                            if (allDayCd == "1") {
                                carResveDate = `<p>\${carResveSDateStr} ~ \${carResveEDateStr} <span class="wf-badge1">종일</span></p>`;
                            } else {
                                carResveDate = `<p>\${carResveSDateStr} \${rsv.resveBeginDate.substr(11,5)} ~ \${carResveEDateStr} \${rsv.resveEndDate.substr(11,5)}</p>`;
                            }

                            let rturnCd = rsv.rturnCd;
                            console.log("rturnCd", rturnCd);

                            let rturnStr = "";
                            let buttonStr = "";

                            if (rturnCd == "1") {
                                rturnStr = "<span class='wf-badge5'>반납 전</span>";
                                buttonStr = `<button type="button" class="btn5 listRturnBtn" data-id="\${rsv.carResveNo}">반납 처리</button>
                                            <button type="button" class="btn3 listDelBtn" data-id="\${rsv.carResveNo}">예약 취소</button>`;
                            } else if (rturnCd == "2") {
                                rturnStr = "<span class='wf-badge4'>반납 처리 중</span>";
                                buttonStr = `<button type="button" class="btn5 listRturnBtn" data-id="\${rsv.carResveNo}">반납 처리</button>
                                            <button type="button" class="btn3 listDelBtn" disabled>예약 취소</button>`;
                            } else {
                                rturnStr = "<span class='wf-badge3'>반납 완료</span>";
                                buttonStr = `<button type="button" class="btn5 listRturnBtn" disabled>반납 처리</button>
                                            <button type="button" class="btn3 listDelBtn" disabled>예약 취소</button>`;
                            }

                            rowStr += ` <tr>
                                            <td>
                                                <p>\${rsv.rnum}</p>
                                            </td>
                                            <td>
                                                <p>\${rsv.carNm}</p>
                                            </td>
                                            <td>
                                                <p>\${rsv.carNo}</p>
                                            </td>
                                            <td>
                                                <p>\${empNm} \${position}</p>
                                            </td>
                                            <td>
                                                <p>\${deptNm}</p>
                                            </td>
                                            <td>
                                                \${carResveDate}
                                            </td>
                                            <td>
                                                <p>\${rsv.resveCn}</p>
                                            </td>
                                            <td>
                                                <p>\${rturnStr}</p>
                                            </td>
                                            <td>
                                                \${buttonStr}
                                            </td>
                                        </tr>`;
                        });
                        $("#rturnCarRsvBody").append(rowStr);
                        $("#rturnDivPaging").html(rsvs.pagingArea);
                    });

                    $(".listRturnBtn").on("click", function (e) {
                        carResveNo = e.target.dataset.id;

                        let data = {
                            carResveNo: carResveNo,
                            rturnCd: "3",
                        };

                        updateReturnStatus(data);
                    });

                    $(".listDelBtn").on("click", function (e) {
                        carResveNo = e.target.dataset.id;

                        deleteCarResve(carResveNo);
                    });
                }
            },
        });
    }

    // 지난 차량 예약 목록 불러오기
    function adminGetPastCarResveList(currentPage, searchOption, keyword) {
        let data = {
            currentPage: currentPage,
            searchOption: searchOption,
            keyword: keyword,
        };
        $.ajax({
            url: "/admin/reservations/car/past",
            type: "GET",
            data: data,
            dataType: "json",
            success: function (rsvs) {
                console.log("rsvs : ", rsvs);
                $("#pastCarRsvBody").empty();
                if (!rsvs.total) {
                    let rowStr = `<tr>
                                    <td colspan="8">
                                        <p>차량 예약이 없습니다.</p>
                                    </td>
                                </tr>`;
                    $("#pastCarRsvBody").append(rowStr);
                } else {
                    $.each(rsvs.content, function (index, rsv) {
                        let rowStr = "";
                        // 팀원 정보 불러와서 채우기
                        getEmpInfo(rsv.empNo, function (empInfo) {
                            let deptNm = empInfo.deptNm;
                            let empNm = empInfo.empNm;
                            let position = empInfo.position;
                            let rspnsblCtgryNm = empInfo.rspnsblCtgryNm;
                            if (rspnsblCtgryNm != "팀원") {
                                position = rspnsblCtgryNm;
                            }

                            let carResveSDate = new Date(rsv.resveBeginDate.substr(0, 10));
                            let carResveSDateStr = formatDate(carResveSDate);
                            let carResveEDate = new Date(rsv.resveEndDate.substr(0, 10));
                            let carResveEDateStr = formatDate(carResveEDate);

                            let allDayCd = rsv.allDayCd;
                            let carResveDate = "";
                            if (allDayCd == "1") {
                                carResveDate = `<p>\${carResveSDateStr} ~ \${carResveEDateStr} <span class="wf-badge1">종일</span></p>`;
                            } else {
                                carResveDate = `<p>\${carResveSDateStr} \${rsv.resveBeginDate.substr(11,5)} ~ \${carResveEDateStr} \${rsv.resveEndDate.substr(11,5)}</p>`;
                            }

                            let rturnCd = rsv.rturnCd;
                            console.log("rturnCd", rturnCd);

                            let rturnStr = "";
                            let buttonStr = "";

                            if (rturnCd == "1") {
                                rturnStr = "<span class='wf-badge5'>반납 전</span>";
                                buttonStr = `<button type="button" class="btn5 listRturnBtn" data-id="\${rsv.carResveNo}">반납 처리</button>
                                            <button type="button" class="btn3 listDelBtn" disabled>예약 취소</button>`;
                            } else if (rturnCd == "2") {
                                rturnStr = "<span class='wf-badge4'>반납 처리 중</span>";
                                buttonStr = `<button type="button" class="btn5 listRturnBtn" data-id="\${rsv.carResveNo}">반납 처리</button>
                                            <button type="button" class="btn3 listDelBtn" disabled>예약 취소</button>`;
                            } else {
                                rturnStr = "<span class='wf-badge3'>반납 완료</span>";
                                buttonStr = `<button type="button" class="btn5 listRturnBtn" disabled>반납 처리</button>
                                            <button type="button" class="btn3 listDelBtn" disabled>예약 취소</button>`;
                            }

                            rowStr += ` <tr>
                                            <td>
                                                <p>\${rsv.rnum}</p>
                                            </td>
                                            <td>
                                                <p>\${rsv.carNm}</p>
                                            </td>
                                            <td>
                                                <p>\${rsv.carNo}</p>
                                            </td>
                                            <td>
                                                <p>\${empNm} \${position}</p>
                                            </td>
                                            <td>
                                                <p>\${deptNm}</p>
                                            </td>
                                            <td>
                                                \${carResveDate}
                                            </td>
                                            <td>
                                                <p>\${rsv.resveCn}</p>
                                            </td>
                                            <td>
                                                <p>\${rturnStr}</p>
                                            </td>
                                            <td>
                                                \${buttonStr}
                                            </td>
                                        </tr>`;
                        });
                        $("#pastCarRsvBody").append(rowStr);
                        $("#pastDivPaging").html(rsvs.pagingArea);
                    });

                    $(".listRturnBtn").on("click", function (e) {
                        carResveNo = e.target.dataset.id;

                        let data = {
                            carResveNo: carResveNo,
                            rturnCd: "3",
                        };

                        updateReturnStatus(data);
                    });
                }
            },
        });
    }

    function adminGetAllMtrResveList() {
        adminGetCarResveList(1, "", "");
        adminGetWaitReturnCarResveList(1, "", "");
        adminGetPastCarResveList(1, "", "");
    }
    // 예약 삭제
    function deleteCarResve(carResveNo) {
        console.log("delete carResveNo : ", carResveNo);
        // 삭제 확인창 표시
        Swal.fire({
            title: _msg.reservation.deleteConfirm,
            showDenyButton: true,
            denyButtonText: `취소`,
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: `/api/reservation/car/\${carResveNo}`,
                    type: "DELETE",
                    dataType: "text",
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function (rslt) {
                        console.log("delete : ", rslt);

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

    // 반납 상태 수정
    function updateReturnStatus(data) {
        // 삭제 확인창 표시
        Swal.fire({
            title: _msg.reservation.adminReturnConfirm,
            showDenyButton: true,
            denyButtonText: `취소`,
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: `/api/reservation/car/return`,
                    type: "PUT",
                    data: JSON.stringify(data),
                    contentType: "application/json;charset=utf-8",
                    dataType: "text",
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function (rslt) {
                        console.log("update : ", rslt);

                        if (rslt == "success") {
                            Toast.fire({
                                icon: "success",
                                title: _msg.reservation.adminReturnSuccessAlert,
                            });
                            adminGetAllMtrResveList();
                        } else {
                            Toast.fire({
                                icon: "info",
                                title: _msg.reservation.adminReturnFailAlert,
                            });
                        }
                    },
                });
            } else if (result.isDenied) {
                Toast.fire({
                    icon: "info",
                    title: _msg.reservation.adminReturnFailAlert,
                });
            }
        });
    }
</script>
<!--------------------------------- body 시작 --------------------------------->
<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
    <h1 class="page-tit">차량 예약 관리</h1>
</div>
<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
    <div class="tab-type tab-type2">
        <div class="tab-menu">
            <!-- "active"가 추가되면 메뉴가 활성화됩니다. -->
            <button data-tab="tab1" type="button" class="tab-btn active" id="carRsvBtn">예약 현황</button>
            <button data-tab="tab2" type="button" class="tab-btn" id="rturnWaitBtn">반납 대기</button>
            <button data-tab="tab3" type="button" class="tab-btn" id="pastCarRsvBtn">지난 예약</button>
            <div class="tab-indicator"></div>
        </div>

        <!-- tab1  -->
        <div data-tab="tab1" class="tab-content active">
            <div class="tab-board-lst">
                <div class="wf-content-area">
                    <table class="wf-table">
                        <colgroup>
                            <col style="width: 5%" />
                            <col style="width: 7%" />
                            <col style="width: 8%" />
                            <col style="width: 8%" />
                            <col style="width: 7%" />
                            <col style="width: 25%" />
                            <col style="width: 13%" />
                            <col style="width: 10%" />
                            <col style="width: 17%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>차량명</th>
                                <th>차량번호</th>
                                <th>예약자</th>
                                <th>부서</th>
                                <th>예약일시</th>
                                <th>사용목적</th>
                                <th>반납상태</th>
                                <th>상태변경</th>
                            </tr>
                        </thead>
                        <tbody id="carRsvBody"></tbody>
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
                <div class="wf-content-area">
                    <table class="wf-table">
                        <colgroup>
                            <col style="width: 5%" />
                            <col style="width: 7%" />
                            <col style="width: 8%" />
                            <col style="width: 8%" />
                            <col style="width: 7%" />
                            <col style="width: 25%" />
                            <col style="width: 13%" />
                            <col style="width: 10%" />
                            <col style="width: 17%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>차량명</th>
                                <th>차량번호</th>
                                <th>예약자</th>
                                <th>부서</th>
                                <th>예약일시</th>
                                <th>사용목적</th>
                                <th>반납상태</th>
                                <th>상태변경</th>
                            </tr>
                        </thead>
                        <tbody id="rturnCarRsvBody"></tbody>
                    </table>
                </div>

                <!-- 페이지네이션 시작 -->
                <nav class="wf-pagination-wrap">
                    <div class="row justify-content-center" id="rturnDivPaging"></div>
                </nav>
                <!-- 페이지네이션 끝 -->

                <!-- 검색영역 시작 -->
                <div class="wf-search-area">
                    <div class="select-box">
                        <select id="rturnSelectOption">
                            <option value="empNm">예약자명</option>
                            <option value="resveCn">사용목적</option>
                        </select>
                    </div>
                    <input type="text" id="rturnKeyword" placeholder="검색할 내용을 입력해주세요" />
                    <button type="button" class="btn4" id="rturnSearchBtn">
                        <i class="xi-search"></i>
                    </button>
                </div>
                <!-- 검색영역 끝 -->
            </div>
        </div>

        <!-- tab3  -->
        <div data-tab="tab3" class="tab-content">
            <div class="tab-board-lst">
                <div class="wf-content-area">
                    <table class="wf-table">
                        <colgroup>
                            <col style="width: 5%" />
                            <col style="width: 7%" />
                            <col style="width: 8%" />
                            <col style="width: 8%" />
                            <col style="width: 7%" />
                            <col style="width: 25%" />
                            <col style="width: 13%" />
                            <col style="width: 10%" />
                            <col style="width: 17%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>차량명</th>
                                <th>차량번호</th>
                                <th>예약자</th>
                                <th>부서</th>
                                <th>예약일시</th>
                                <th>사용목적</th>
                                <th>반납상태</th>
                                <th>상태변경</th>
                            </tr>
                        </thead>
                        <tbody id="pastCarRsvBody"></tbody>
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
                        <select id="pastSearchOption">
                            <option value="empNm">예약자명</option>
                            <option value="resveCn">사용목적</option>
                        </select>
                    </div>
                    <input type="text" id="pastKeyword" placeholder="검색할 내용을 입력해주세요" />
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
