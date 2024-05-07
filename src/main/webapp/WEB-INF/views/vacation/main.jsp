<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<!-- CSS -->
<link href="${pageContext.request.contextPath}/resources/css/vacation/style.css" rel="stylesheet" />
<!-- Javascript -->
<script src="${pageContext.request.contextPath}/resources/script/common/commonForSchAndRsv.js" defer></script>
<script>
    let empNo = '<%=(String)session.getAttribute("empNo")%>';

    // 당해년도
    let today = new Date();
    let year = today.getFullYear();
    let currentYear = year.toString();

    let detailYear = currentYear;
    let pastYear = currentYear;

    let myChart;

    let recordCnt; // 사용한 휴가 개수
    let remainCnt; // 잔여 휴가 개수
    let totalCnt; // 총 휴가 개수
    let dissipateCnt; // 소멸 휴가 개수
</script>

<script>
    $(function () {
        // 내 연차들 불러오기
        getVacationList(empNo, currentYear);

        // 휴가 상세 현황 불러오기
        getVacationDetail(empNo, currentYear);
        // 휴가 기록 불러오기
        getMyVacationRecordList(empNo, currentYear);

        // 휴가 시작일 변경하면 휴가 상세 편집 표시
        $("#sDate").on("change", function () {
            let dateArray = getAllDatesBetween();
            console.log(dateArray);

            let editStr = "";
            if (dateArray) {
                $("#vcatnEdit").empty();

                dateArray.forEach(function (date, index) {
                    editStr += `<div class="wf-flex-box">
                                    <input type="date" name="vcatnUseDate" id="eDate" value="\${date}" readonly>
                                    <div class="wf-select-group">
                                        <select name="vcatnSeCd" id="vcatnSeCd">
                                            <option value="1">종일</option>
                                            <option value="2">오전반차</option>
                                            <option value="3">오후반차</option>
                                        </select>
                                    </div>
                                </div>`;
                });
                console.log("editStr : ", editStr);
                $("#vcatnEdit").append(editStr);
            }

            if (dateArray.length >= 3) {
                getApvLine(empNo, "4");
            }
        });

        // 휴가 종료일 변경하면 휴가 상세 편집 표시
        $("#eDate").on("change", function () {
            let dateArray = getAllDatesBetween();
            console.log(dateArray);

            let editStr = "";
            if (dateArray) {
                $("#vcatnEdit").empty();

                dateArray.forEach(function (date, index) {
                    editStr += `<div class="wf-flex-box">
                                    <input type="date" name="vcatnUseDate" id="eDate" value="\${date}" readonly>
                                    <div class="wf-select-group">
                                        <select name="vcatnSeCd" id="vcatnSeCd">
                                            <option value="1">종일</option>
                                            <option value="2">오전반차</option>
                                            <option value="3">오후반차</option>
                                        </select>
                                    </div>
                                </div>`;
                });
                console.log("editStr : ", editStr);
                $("#vcatnEdit").append(editStr);
            }

            if (dateArray.length >= 3) {
                getApvLine(empNo, "4");
            }
        });

        // 모달 닫기 버튼 누르면 첨부파일 박스 없애기
        $("#vcatnModalCloseBtn").on("click", function () {
            $("#evidenceBox").css("display", "none");
        });

        //휴가 폼 제출 버튼 눌렀을 때 승인요청
        $("#vacationForm").on("submit", function () {
            event.preventDefault();

            let vacationForm = document.querySelector("#vacationForm");
            let formData = new FormData(vacationForm);
            formData.append("empNo", empNo);
            formData.append("giveYear", currentYear);

            console.log("button clicked : ", formData);

            if (formData) {
                let buttonId = event.submitter.id;
                if (buttonId == "createConfBtn") {
                    createVacation(formData);
                } else if (buttonId == "updateMtrBtn") {
                    updatecar(formData);
                }

                $("#vacationModal").removeClass("open");
            }
        });

        // 휴가 상세 현황 올해 다음 연도로 못넘어가게 막기
        $("#detailYearNextArrow").on("click", function () {
            let yearVal = $("#detailYearBox").text();
            if (yearVal == currentYear) {
                event.preventDefault();
            }
        });

        // 휴가 기록 올해 다음 연도로 못넘어가게 막기
        $("#recordYearNextArrow").on("click", function () {
            let yearVal = $("#recordYearBox").text();
            if (yearVal == currentYear) {
                event.preventDefault();
            }
        });

        // 자동 완성
        $("#autoComplete").on("click", function () {
            $("#vcatnCn").val("여행 다녀오겠습니다.");
        });
    });

    // 내 연차들 불러오기
    function getVacationList(empNo, giveYear) {
        data = {
            empNo: empNo,
            giveYear: giveYear,
        };
        $.ajax({
            url: "/api/vacations",
            type: "GET",
            data: data,
            dataType: "json",
            success: function (vacations) {
                console.log("vacations : ", vacations);
                let vcatnStr = "";
                vacations.forEach(function (vacation, index) {
                    let vcatnCtgr = vacation.vcatnCtgryNo;
                    if (vcatnCtgr == "1") {
                        vcatnStr += `   <div class="wf-content-box createBtn" data-id="\${vacation.vcatnCtgryNo}">
                                            <img src="\${_storage}vcatn\${vcatnCtgr}.png" width="45px">
                                            <p class="box-heading1" style="margin-top:10px;">\${vacation.vcatnCtgrySj}</p>
                                            <p>\${vacation.remainCnt}일</p>
                                        </div>`;
                    } else if (vcatnCtgr == "2" || vcatnCtgr == "3" || vcatnCtgr == "4") {
                        if (!vacation.remainCnt) {
                            vcatnStr += `   <div class="wf-content-box disable createBtn" data-id="\${vacation.vcatnCtgryNo}">
                                                <img src="\${_storage}vcatn\${vcatnCtgr}.png" width="45px">
                                                <p class="box-heading1" style="margin-top:10px;">\${vacation.vcatnCtgrySj}</p>
                                                <p>0일</p>
                                            </div>`;
                        } else {
                            vcatnStr += `   <div class="wf-content-box createBtn" data-id="\${vacation.vcatnCtgryNo}">
                                                <img src="\${_storage}vcatn\${vcatnCtgr}.png" width="45px">
                                                <p class="box-heading1" style="margin-top:10px;">\${vacation.vcatnCtgrySj}</p>
                                                <p>\${vacation.vcatnCtgryCn}</p>
                                            </div>`;
                        }
                    } else {
                        vcatnStr += `   <div class="wf-content-box createBtn" data-id="\${vacation.vcatnCtgryNo}">
                                            <img src="\${_storage}vcatn\${vcatnCtgr}.png" width="45px">
                                            <p class="box-heading1" style="margin-top:10px;">\${vacation.vcatnCtgrySj}</p>
                                            <p>\${vacation.vcatnCtgryCn}</p>
                                        </div>`;
                    }
                });
                $("#vacationBox").append(vcatnStr);

                $(".createBtn").on("click", function (e) {
                    console.log(e);
                    let vcatnCtgryNo = e.currentTarget.dataset.id;
                    console.log(vcatnCtgryNo);
                    document.querySelector("#vacationForm").reset();
                    $("#vcatnEdit").empty();

                    getVacationInfo(empNo, vcatnCtgryNo);
                    getApvLine(empNo, vcatnCtgryNo);

                    $("#vacationModal").addClass("open");
                });
            },
        });
    }

    // 연차 정보 가져오기
    function getVacationInfo(empNo, vcatnCtgryNo) {
        let data = {
            empNo: empNo,
            vcatnCtgryNo: vcatnCtgryNo,
            giveYear: currentYear,
        };
        $.ajax({
            url: "/api/vacation",
            type: "GET",
            data: data,
            dataType: "json",
            success: function (vcatnInfo) {
                // 값채우기
                $("#modalTit").text(vcatnInfo.vcatnCtgrySj);
                $("#vcatnCtgryNo").val(vcatnInfo.vcatnCtgryNo);
                $("#remainDispBox").text(vcatnInfo.remainCnt + "일 사용 가능");
            },
        });
    }

    // 결재 라인 불러오기
    function getApvLine(empNo, vcatnCtgryNo) {
        let apvLevel = "";
        let apvLineStr = "";
        let apvStr = "";
        if (vcatnCtgryNo == 1 || vcatnCtgryNo == 2 || vcatnCtgryNo == 3 || vcatnCtgryNo == 8) {
            apvLevel = 1;
            apvStr = "1단계 승인";
        } else {
            apvLevel = 2;
            apvStr = "2단계 승인";
        }
        $("#apvLevelBox").text(apvStr);

        $.ajax({
            url: `/api/vacation/apvLine/\${empNo}/\${apvLevel}`,
            type: "GET",
            dataType: "json",
            success: function (apvLines) {
                $("#apvLineDispBox").empty();
                console.log("apvLine : ", apvLines);
                apvLines.forEach(function (apvLine, index) {
                    console.log(apvLine.empNo);
                    $("#apvLine" + (index + 1)).val(apvLine.empNo);
                    console.log($("#apvLine1").val());
                    console.log($("#apvLine2").val());
                    apvLineStr += `<span class="circle">\${index+1}</span><span class="text"> \${apvLine.empNm} \${apvLine.rspnsblCtgryNm}</span>  `;
                });
                console.log(apvLineStr);
                $("#apvLineDispBox").append(apvLineStr);
            },
        });
    }

    // 휴가 상세 현황 불러오기
    function getVacationDetail(empNo, yearVal) {
        $("#detailYearBox").text(yearVal);

        // 사용 휴가 개수
        getVacationRecordsCount(empNo, yearVal, function (count) {
            console.log("recordCnt: ", count);
            console.log(typeof count);
            recordCnt = count;
        });

        // 남은 휴가 개수
        getRemainVacationCount(empNo, yearVal, function (count) {
            console.log("remainCnt: ", count);
            console.log(typeof count);
            remainCnt = count;
        });

        // 연도가 당해면 소멸 휴가 0
        if (yearVal == currentYear) {
            dissipateCnt = 0;
        } else {
            dissipateCnt = remainCnt;
        }

        totalCnt = recordCnt + remainCnt;

        $("#totalVcatn").text(totalCnt);
        $("#useVcatn").text(recordCnt);
        $("#remainVcatn").text(remainCnt);
        $("#dissipateVcatn").text(dissipateCnt);

        detailYear = yearVal;
        console.log("getVacationDetail:", recordCnt, totalCnt);

        console.log(myChart);
        if (myChart) {
            updateChart(recordCnt, totalCnt);
        } else {
            drawChart(totalCnt, recordCnt);
        }
    }

    // 사용 휴가 개수 가져오기
    function getVacationRecordsCount(empNo, yearVal, callback) {
        let data = {
            empNo: empNo,
            giveYear: yearVal,
        };

        $.ajax({
            url: "/api/vacations/count",
            type: "GET",
            data: data,
            async: false,
            success: function (count) {
                console.log("VacationRecordsCount : ", count);
                callback(count);
            },
        });
    }

    // 남은 휴가 개수 가져오기
    function getRemainVacationCount(empNo, yearVal, callback) {
        let data = {
            empNo: empNo,
            vcatnCtgryNo: "1",
            giveYear: yearVal,
        };

        $.ajax({
            url: "/api/vacation",
            type: "GET",
            data: data,
            async: false,
            success: function (vcatnInfo) {
                let count = vcatnInfo.remainCnt;
                console.log("remainCnt : ", count);

                callback(count);
            },
        });
    }

    // 차트 그리기
    function drawChart() {
        const ctx = document.querySelector("#vacationChart").getContext("2d");
        const DATA_COUNT = 7;
        const NUMBER_CFG = { count: DATA_COUNT, min: 0, max: 100 };

        const data = {
            labels: [""],
            datasets: [
                {
                    label: "",
                    data: [recordCnt],
                    backgroundColor: "#F8B5CB",
                },
                {
                    label: "",
                    data: [totalCnt],
                    backgroundColor: "#ABDBFF",
                },
            ],
        };

        myChart = new Chart(ctx, {
            type: "bar",
            data: data,
            options: {
                indexAxis: "y",
                elements: {
                    bar: {
                        borderWidth: 2,
                        borderRadius: 10,
                    },
                },
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false,
                    },
                },
                scales: {
                    y: {
                        stacked: true,
                    },
                },
            },
        });
    }

    // 차트 업데이트
    function updateChart(recordCnt, totalCnt) {
        myChart.data.datasets[0].data = [recordCnt];
        myChart.data.datasets[1].data = [totalCnt];

        myChart.update();
    }

    // 휴가 기록 불러오기
    function getMyVacationRecordList(empNo, yearVal) {
        $("#recordYearBox").text(yearVal);

        let data = {
            empNo: empNo,
            giveYear: yearVal,
        };
        $.ajax({
            url: "/api/vacations/record",
            type: "GET",
            data: data,
            dataType: "json",
            success: function (records) {
                $("#vcatnRecordBox").empty();
                let rowStr = "";
                if (!records) {
                    rowStr += ` <tr>
                                    <td colspan="5">휴가 기록이 없습니다.</td>
                                </tr>`;
                } else {
                    const sortedKeys = Object.keys(records).sort((a, b) => parseInt(b) - parseInt(a));

                    sortedKeys.forEach((key) => {
                        const vacations = records[key];
                        console.log("vacations : ", vacations);

                        let statusStr = "";
                        let categoryStr = "";
                        let startDate = null;
                        let startDateStr = "";
                        let currentDate = null;
                        let duration = 0;
                        if (vacations.length == 1) {
                            // 휴가 결재 상태
                            statusStr = getApvStatus(vacations[0].apvSttusCd);

                            startDate = new Date(vacations[0].vcatnUseDate); // 휴가시작일
                            startDateStr = formatDate(startDate);

                            vcatnCn = vacations[0].vcatnCn; //휴가내용

                            let vcatnCtgryNo = vacations[0].vcatnCtgryNo;
                            categoryStr = getCategoryString(vcatnCtgryNo); // 휴가 종류

                            // 휴가 일수
                            let vcatnSeCd = vacations[0].vcatnSeCd;

                            if (vcatnSeCd == "1") {
                                duration = 1;
                            } else {
                                duration = 0.5;
                            }

                            if (vcatnCtgryNo == "1" && vcatnSeCd == "2") {
                                categoryStr = "오전반차";
                            } else if (vcatnCtgryNo == "1" && vcatnSeCd == "3") {
                                categoryStr = "오후반차";
                            }
                        } else {
                            vacations.forEach((vacation) => {
                                console.log("more : ", vacation);
                                // 휴가 결재 상태
                                statusStr = getApvStatus(vacation.apvSttusCd);

                                vcatnCn = vacation.vcatnCn; //휴가내용

                                categoryStr = getCategoryString(vacation.vcatnCtgryNo); // 휴가 종류

                                // 휴가 시작일
                                currentDate = new Date(vacation.vcatnUseDate);
                                if (!startDate || currentDate < startDate) {
                                    startDate = currentDate;
                                }
                                startDateStr = formatDate(startDate);

                                // 휴가 기간
                                let vcatnSeCd = vacation.vcatnSeCd;
                                if (vcatnSeCd == 1) {
                                    duration += 1;
                                } else {
                                    duration += 0.5;
                                }
                            });
                        }
                        let btnStr = "";
                        let compareDate = new Date(startDateStr);
                        if (compareDate > today) {
                            btnStr = `<button type="button" class="btn3 deleteBtn" data-id="\${vacations[0].apvNo}">휴가 취소</button>`;
                        }
                        rowStr += ` <tr>
                                        <td>
                                            \${statusStr}
                                        </td>
                                        <td>
                                            <p>\${categoryStr}</p>
                                        </td>
                                        <td>
                                            <p>\${startDateStr}</p>
                                        </td>
                                        <td>
                                            <p>\${vcatnCn}</p>
                                        </td>
                                        <td>
                                            <span class="wf-badge3" id="vcatnPeriodBox">\${duration}일</span>
                                        </td>
                                        <td>
                                            \${btnStr}
                                        </td>
                                    </tr>`;
                    });
                    $("#vcatnRecordBox").append(rowStr);
                }
                $(".deleteBtn").on("click", function (e) {
                    apvNo = e.target.dataset.id;

                    deleteVacation(apvNo);
                });
            },
        });

        pastYear = yearVal;
    }

    // 휴가 종류
    function getCategoryString(category) {
        let categoryStr;
        switch (category) {
            case "1":
                categoryStr = "연차";
                break;
            case "2":
                categoryStr = "생일";
                break;
            case "3":
                categoryStr = "건강검진";
                break;
            case "4":
                categoryStr = "리프레시";
                break;
            case "5":
            case "6":
                categoryStr = "조의";
                break;
            case "7":
                categoryStr = "결혼";
                break;
            case "8":
                categoryStr = "보건";
                break;
            default:
                categoryStr = "";
        }

        return categoryStr;
    }

    // 결재 상태 반환
    function getApvStatus(status) {
        let statusStr = "";
        switch (status) {
            case "Y":
                statusStr = "<span class='wf-badge1'>승인완료</span>";
                break;
            case "0":
                statusStr = "<span class='wf-badge2'>결재진행</span>";
                break;
            case "N":
                statusStr = "<span class='wf-badge5'>반려</span>";
                break;
            default:
                statusStr = "<span class='wf-badge2'>결재진행</span>";
                break;
        }
        return statusStr;
    }

    // 시작 날짜와 종료 날짜 사이의 모든 날짜를 배열로 반환
    function getAllDatesBetween() {
        let sDate = $("#sDate").val();
        let eDate = $("#eDate").val();

        let dateArray = [];
        let vcatnSDate = new Date(sDate);
        let vcatnEDate = new Date(eDate);

        while (vcatnSDate <= vcatnEDate) {
            let dates = formatDate(vcatnSDate).substr(0, 10);
            dateArray.push(dates);
            vcatnSDate.setDate(vcatnSDate.getDate() + 1);
        }

        return dateArray;
    }

    // 휴가 생성
    function createVacation(data) {
        $.ajax({
            url: "/api/vacation",
            type: "POST",
            data: data,
            dataType: "text",
            contentType: false,
            processData: false,
            beforeSend: function (xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function (rslt) {
                console.log("create : ", rslt);

                if (rslt == "success") {
                    $("#rsvModal").removeClass("open");
                    // 알림 출력
                    Toast.fire({
                        icon: "success",
                        title: _msg.common.insertSuccessAlert,
                    });

                    // 화면 다시 로딩
                    getMyVacationRecordList(empNo, currentYear);
                } else {
                    Toast.fire({
                        icon: "success",
                        title: _msg.common.insertFailAlert,
                    });
                }
            },
        });
    }

    // 휴가 삭제
    function deleteVacation(apvNo) {
        // 삭제 확인창 표시
        Swal.fire({
            title: _msg.vacation.deleteConfirm,
            showDenyButton: true,
            denyButtonText: `취소`,
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: `/api/vacation/\${apvNo}`,
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
                                title: _msg.vacation.deleteSuccessAlert,
                            });
                            getVacationList(empNo, currentYear);
                            getVacationDetail(empNo, currentYear);
                            getMyVacationRecordList(empNo, currentYear);
                        } else {
                            Toast.fire({
                                icon: "info",
                                title: _msg.vacation.deleteFailAlert,
                            });
                        }
                    },
                });
            } else if (result.isDenied) {
                Toast.fire({
                    icon: "info",
                    title: _msg.vacation.deleteFailAlert,
                });
            }
        });
    }
</script>

<!--------------------------------- body 시작 --------------------------------->
<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
    <h1 class="page-tit">휴가</h1>
</div>
<div class="wf-content-wrap">
    <div class="wf-content-area vacationContainer" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
        <p class="heading1">휴가 등록</p>
        <div class="wf-flex-box" id="vacationBox"></div>
    </div>
    <div class="wf-content-area" data-aos="fade-right" data-aos-duration="700" data-aos-delay="400">
        <p class="heading1">휴가 상세 현황</p>
        <nav class="wf-pagination-wrap arrow-wrap">
            <ul class="pagination">
                <li class="page-item">
                    <a class="page-link prev" href="javascript:getVacationDetail(empNo, detailYear-1)">
                        <i class="xi-angle-left"></i>
                    </a>
                </li>
                <li id="detailYearBox"></li>

                <li class="page-item">
                    <a class="page-link next" id="detailYearNextArrow" href="javascript:getVacationDetail(empNo, detailYear+1)">
                        <i class="xi-angle-right"></i>
                    </a>
                </li>
            </ul>
        </nav>
        <div id="chartDiv">
            <canvas id="vacationChart" style="height: 100px"></canvas>
        </div>
        <div class="wf-flex-box">
            <ul class="wf-list-style">
                <li class="style1 vcatn-li">자동 지급<br><span class="vcatnCnt" id="totalVcatn"></span></li>
                
            </ul>

            <ul class="wf-list-style">
                <li class="style5 vcatn-li">사용<br><span class="vcatnCnt" id="useVcatn"></li>
                </span>
            </ul>
            <ul class="wf-list-style">
                <li class="style2 vcatn-li">남은 휴가<br><span class="vcatnCnt" id="remainVcatn"></li>
                </span>
            </ul>
            <ul class="wf-list-style">
                <li class="style4 vcatn-li">소멸<br><span class="vcatnCnt" id="dissipateVcatn"></li>
                </span>
            </ul>
        </div>
    </div>

    <div class="wf-content-area recordContainer" data-aos="fade-right" data-aos-duration="700" data-aos-delay="600">
        <p class="heading1">휴가 기록</p>
        <nav class="wf-pagination-wrap arrow-wrap">
            <ul class="pagination">
                <li class="page-item">
                    <a class="page-link prev" href="javascript:getMyVacationRecordList(empNo, pastYear-1)">
                        <i class="xi-angle-left"></i>
                    </a>
                </li>
                <li id="recordYearBox"></li>

                <li class="page-item">
                    <a class="page-link next" id="recordYearNextArrow" href="javascript:getMyVacationRecordList(empNo, pastYear+1)">
                        <i class="xi-angle-right"></i>
                    </a>
                </li>
            </ul>
        </nav>
        <table class="wf-table vcatn-table">
            <colgroup>
                <col style="width: 10%" />
                <col style="width: 10%" />
                <col style="width: 20%" />
                <col style="width: 40%" />
                <col style="width: 10%" />
                <col style="width: 10%" />
            </colgroup>
            <thead>
                <tr>
                    <th>결재상태</th>
                    <th>휴가종류</th>
                    <th>휴가시작일</th>
                    <th>휴가내용</th>
                    <th>휴가일수</th>
                    <th></th>
                </tr>
            </thead>
            <tbody id="vcatnRecordBox"></tbody>
        </table>
    </div>
</div>
<!--------------------------------- body 끝 --------------------------------->

<!--------------------------------- 예약 등록/수정 모달 시작 --------------------------------->
<div class="modal" id="vacationModal">
    <div class="modal-cont">
        <div class="vcatn-tit-wrap">
            <h1 class="modal-tit" id="modalTit"></h1>
            <span class="wf-badge1" id="remainDispBox"></span>
        </div>
        <div class="modal-content-area" id="vacationDiv">
            <form id="vacationForm">
                <ul class="wf-insert-form2 vertical">
                    <li id="vcatnCtgryNoBox">
                        <div>
                            <input type="text" name="vcatnCtgryNo" id="vcatnCtgryNo" />
                        </div>
                    </li>
                    <li></li>
                    <li class="apvLi">
                        <div class="wf-flex-box between">
                            <label for="apvLevelBox">승인</label>
                            <span class="wf-badge2" id="apvLevelBox"></span>
                        </div>
                        <div id="apvLineDispBox"></div>
                        <div id="apvLineDiv">
                            <input type="text" name="apvLine" id="apvLine1" />
                            <input type="text" name="apvLine" id="apvLine2" />
                        </div>
                    </li>
                    <li>
                        <label for="cc">일시<i class="i">*</i></label>
                        <div class="wf-flex-box">
                            <input type="date" name="sDate" id="sDate" min="" max="" required />
                            <span class="hyphen">-</span>
                            <input type="date" name="eDate" id="eDate" min="" max="" required />
                        </div>
                    </li>
                    <li>
                        <label for="vcatnCn">휴가 신청 메시지<i class="i">*</i></label>
                        <div>
                            <textarea name="vcatnCn" id="vcatnCn" placeholder="휴가 신청 메시지 입력" required></textarea>
                        </div>
                    </li>
                    <li id="vcatnEdit">
                        <label for="rturnStts">휴가 상세 편집<i class="i">*</i></label>
                        <div name="vcatnEdit" id="vcatnEdit"></div>
                    </li>
                </ul>
            </form>
        </div>

        <div class="modal-btn-wrap" id="createBtnGroup">
            <button class="btn5" id="autoComplete">자동완성</button>
            <button type="submit" form="vacationForm" class="btn2" id="createConfBtn">승인요청</button>
        </div>
        <button class="close-btn" id="vcatnModalCloseBtn"></button>
    </div>
</div>
<!--------------------------------- 예약 등록/수정 모달 끝 --------------------------------->
