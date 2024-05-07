<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- fullcalendar -->
<link href="${pageContext.request.contextPath}/resources/css/fullcalendar.css" rel="stylesheet" />
<script src="${pageContext.request.contextPath}/resources/js/fullcalendar.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/fullcalendar-ko.js"></script>
<!-- message -->
<script src="${pageContext.request.contextPath}/resources/js/message.js"></script>
<!-- CSS -->
<link href="${pageContext.request.contextPath}/resources/css/reservation/car_style.css" rel="stylesheet" />
<script>
    let empNo = '<%=(String)session.getAttribute("empNo")%>';
</script>
<!-- Javascript -->
<script src="${pageContext.request.contextPath}/resources/script/common/commonForSchAndRsv.js" defer></script>
<script>
    // 차량 예약 번호
    let carResveNo;

    // 차량 종류에 따른 색상
    const car1Color = "#40AEB6";
    const car2Color = "#5CB164";
    const car3Color = "#BF7FD2";
    const car4Color = "#3CA8E4";

    // form에서 값 가져오기
    const serializeCarRsvVO = function (cForm) {
        let elems = cForm.elements;
        let rsltObj = {};
        for (let i = 0; i < elems.length; i++) {
            if (elems[i].name == "rsvEmpName") continue;
            if (elems[i].type == "submit") continue;

            if (elems[i].name == "allDayCd") {
                if (!elems[i].checked) {
                    rsltObj[elems[i].name] = "0";
                    continue;
                }
            }
            rsltObj[elems[i].name] = elems[i].value;
        }
        console.log("체크2 :", rsltObj);
        return rsltObj;
    };

    $(function () {
        // modal 달력 최소값 설정
        let today = new Date().toISOString().split("T")[0];
        document.querySelector("#rsvSDate").min = today;
        document.querySelector("#rsvEDate").min = today;

        // 예약들 불러오고 난 뒤 캘린더 랜더링
        getAndInitializeReservation();
        // 차량 목록 선택보기 불러오기
        getCarOptions();

        // 예약 현황 탭 누르면 예약 불러오기
        $("#carRsvListBtn").on("click", function () {
            getAndInitializeReservation();
        });

        // 내 예약 탭 누르면 예약 불러오기
        $("#myCarRsvBtn").on("click", function () {
            getMyCarResveList();
        });

        // 차 선택 변경하면 예약 불러오기
        $("#keyword").on("change", function () {
            getAndInitializeReservation();
        });

        // 지난 예약 탭 누르면 예약 불러오기
        $("#myPastCarRsvBtn").on("click", function () {
            getMyPastCarResveList();
        });
        // 예약 등록(추가) 버튼 클릭하면 모달 표시
        $("#createBtn").on("click", function () {
            // 모달 초기화
            document.getElementById("rsvSDate").value = "";
            document.getElementById("rsvSTime").value = "08:00";
            document.getElementById("rsvEDate").value = "";
            document.getElementById("rsvETime").value = "08:00";
            document.getElementById("rsvCont").value = "";

            // 차량 목록 불러오기
            getCarsForModal();

            document.getElementById("rsvModal").classList.add("open");
        });

        // 차량 바꿈에 따라
        $("#selectCar").on("change", function () {
            let carNo = $("#selectCar").val();
            //차량 정보 불러와서 표시
            getCarInfo(carNo);
        });

        // 모달 닫으면
        $("#rsvModalCloseBtn").on("click", function () {
            // 모달 제목 바꾸기
            $("#modalTit").text("차량 예약");
            // 예약자 박스 안보이게
            $("#rsvEmpNameBox").css("display", "none");
            // 올데이 체크 풀기
            $("#allDay").prop("checked", false);
            $("#rsvSTime").prop("disabled", false);
            $("#rsvETime").prop("disabled", false);
            // 수정삭제버튼 disabled 풀기
            $("#updateConfbtn").prop("disabled", false);
            $("#deleteBtn").prop("disabled", false);
            // 반납 버튼 안보이게
            $("#rturnSttsBox").css("display", "none");
            // 수정삭제버튼 안보이고, 등록취소버튼 보이게
            $("#updateBtnGroup").css("display", "none");
            $("#createBtnGroup").css("display", "block");
        });

        // 모달에서 종일버튼 클릭에 따라 시간선택 활성화 변경
        $("#allDay").on("change", function () {
            if ($(this).is(":checked")) {
                $("#rsvSTime").prop("disabled", true);
                $("#rsvETime").prop("disabled", true);
            } else {
                $("#rsvSTime").prop("disabled", false);
                $("#rsvETime").prop("disabled", false);
            }
        });

        // 폼 제출 버튼 눌렀을 때 등록 또는 수정
        $("#carRsvForm").on("submit", function () {
            event.preventDefault();

            let data = getData();
            if (data) {
                let buttonId = event.submitter.id;
                if (buttonId == "createConfBtn") {
                    createCarResve(data);
                } else if (buttonId == "updateBtn") {
                    updateCarResve(data, carResveNo);
                } else if (buttonId == "rturnBtn") {
                    data.rturnCd = "2";
                    updateCarResve(data, carResveNo);
                }

                $("#rsvModal").removeClass("open");
            }
        });

        // 예약 취소 버튼 누르면 모달 닫고 예약 삭제 진행
        $("#deleteBtn").on("click", function () {
            $("#rsvModal").removeClass("open");
            deleteCarResve(carResveNo);
        });

        // 반납 버튼 누르면 반납 처리 진행
        $("#rturnBtn").on("click", function () {
            let data = {
                carResveNo: carResveNo,
                rturnCd: "2",
            };

            updateReturnStatus(data);
        });

        // 자동 완성
        $("#autoComplete").on("click", function () {
            $("#rsvSDate").val("2024-04-22");
            $("#rsvEDate").val("2024-04-24");
            $("#rsvCont").val("세종지사 출장으로 차량 사용하겠습니다.");
        });
    });

    // 차량 예약 리스트 불러오기
    function getCarResveList() {
        let keyword = $("#keyword").val();
        data = {
            carNo: keyword,
        };

        return $.ajax({
            url: "/api/reservations/car",
            type: "GET",
            data: data,
            dataType: "json",
        }).done(function (data) {
            data.forEach(function (item) {
                let carNo = item.carNo;
                // 차량 종류에 따라 색상 설정
                if (carNo == "133가1312") {
                    item.backgroundColor = car1Color;
                } else if (carNo == "461로5277") {
                    item.backgroundColor = car2Color;
                } else if (carNo == "213하9432") {
                    item.backgroundColor = car3Color;
                } else {
                    item.backgroundColor = car4Color;
                }

                // 종일 일정 구분
                if (item.allDayCd == "1") {
                    item.allDay = true;
                    let endDate = new Date(item.end);
                    endDate.setDate(endDate.getDate() + 1);
                    item.end = endDate;
                }
            });
        });
    } // 차량 예약 리스트 불러오기 끝

    // 캘린더 랜더링
    function initializeFullCalendarWithData(data) {
        console.log(data);

        let calendarEl = document.getElementById("calendar");
        calendar = new FullCalendar.Calendar(calendarEl, {
            height: "700px",
            slotMinTime: "08:00", // Day 캘린더에서 시작 시간
            slotMaxTime: "22:00", // Day 캘린더에서 종료 시간
            // 헤더에 표시할 툴바
            headerToolbar: {
                left: "prev,next today",
                center: "title",
                right: "dayGridMonth,timeGridWeek,timeGridDay,listWeek",
            },
            initialView: "timeGridWeek", // 초기 로드 될 때 보이는 캘린더 화면
            navLinks: true, // 날짜를 선택하면 Day 캘린더나 Week 캘린더로 링크
            editable: true, // 수정 가능
            selectable: true, // 달력 일자 드래그 설정 가능
            droppable: true, // 드래그 앤 드롭
            events: data,
            locale: "ko", // 한국어 설정

            // 예약 클릭하면 예약 상세 모달 표시
            eventClick: function (info) {
                showCarRsvDetail(info);
            },

            // 캘린더에서 클릭 또는 드래그로 예약 등록 모달 표시
            select: function (info) {
                console.log("clicked info : ", info);
                console.log("startstr : ", info.startStr);

                let calendarType = info.view.type;
                let endStr = "";
                let timeStr = "";

                if (calendarType == "dayGridMonth") {
                    endStr = formatEDate(info.end);
                    timeStr = "08:00";
                } else {
                    endStr = info.endStr.substr(0, 10);
                    timeStr = info.startStr.substr(11, 2) + ":00";
                }

                console.log("end : ", endStr);
                console.log("timeStr : ", timeStr);

                // 모달 초기화
                document.getElementById("rsvSDate").value = info.startStr.substr(0, 10);
                document.getElementById("rsvSTime").value = timeStr;
                document.getElementById("rsvEDate").value = endStr;
                document.getElementById("rsvETime").value = timeStr;
                document.getElementById("rsvCont").value = "";

                // 차량 목록 불러오기
                getCarsForModal();

                document.getElementById("rsvModal").classList.add("open");
            },
        });
        calendar.render();
    } // 캘린더 랜더링 끝

    // 예약 리스트 불러오고 캘린더 랜더링
    function getAndInitializeReservation() {
        getCarResveList().done(function (data) {
            initializeFullCalendarWithData(data);
        });
    }

    // 내 예약 리스트 불러오기
    function getMyCarResveList() {
        $.ajax({
            url: `/api/reservations/car/\${empNo}`,
            type: "GET",
            dataType: "json",
            success: function (carResves) {
                console.log("carResves:", carResves);
                $("#carRsvBody").empty();
                if (!carResves.length) {
                    let rowStr = `<tr>
                                    <td colspan="7" style="text-align:center;">
                                        <p>저장된 차량 예약이 없습니다.</p>
                                    </td>
                                </tr>`;
                    $("#carRsvBody").append(rowStr);
                } else {
                    $.each(carResves, function (index, carResve) {
                        console.log("carResve : ", carResve);
                        let rowStr = "";

                        let carResveSDate = new Date(carResve.resveBeginDate.substr(0, 10));
                        let carResveSDateStr = formatDate(carResveSDate);
                        let carResveEDate = new Date(carResve.resveEndDate.substr(0, 10));
                        let carResveEDateStr = formatDate(carResveEDate);

                        let allDayCd = carResve.allDayCd;
                        let carResveDate = "";
                        if (allDayCd == "1") {
                            carResveDate = `<p>\${carResveSDateStr} ~ \${carResveEDateStr} <span class="wf-badge1">종일</span></p>`;
                        } else {
                            carResveDate = `<p>\${carResveSDateStr} \${carResve.resveBeginDate.substr(11,5)} ~ \${carResveEDateStr} \${carResve.resveEndDate.substr(11,5)}</p>`;
                        }

                        let rturnCd = carResve.rturnCd;
                        console.log("rturnCd", rturnCd);

                        let rturnStr = "";
                        let buttonStr = "";

                        if (rturnCd == "1") {
                            rturnStr = "<span class='wf-badge5'>반납 전</span>";
                            buttonStr = `<button type="button" class="btn5 listrturnBtn" data-id="\${carResve.carResveNo}">반납</button>
                                            <button type="button" class="btn4 listUdtBtn" data-id="\${carResve.carResveNo}">예약 수정</button>
                                            <button type="button" class="btn3 listDelBtn" data-id="\${carResve.carResveNo}">예약 취소</button>`;
                        } else if (rturnCd == "2") {
                            rturnStr = "<span class='wf-badge4'>반납 처리 중</span>";
                            buttonStr = `<button type='button' class='btn5 listrturnBtn' disabled>반납</button>
                                            <button type='button' class='btn4 listUdtBtn' disabled>예약 수정</button>
                                            <button type='button' class='btn3 listDelBtn' disabled>예약 취소</button>`;
                        } else {
                            rturnStr = "<span class='wf-badge3'>반납 완료</span>";
                            buttonStr = `<button type='button' class='btn5 listrturnBtn' disabled>반납</button>
                                            <button type='button' class='btn4 listUdtBtn' disabled>예약 수정</button>
                                            <button type='button' class='btn3 listDelBtn' disabled>예약 취소</button>`;
                        }

                        rowStr += `<tr>
                                        <td>
                                            <p>\${index+1}</p>
                                        </td>
                                        <td>
                                            <p>\${carResve.carNm}</p>
                                        </td>
                                        <td>
                                            <p>\${carResve.carNo}</p>
                                        </td>
                                        <td>
                                            \${carResveDate}
                                        </td>
                                        <td>
                                            <p>\${carResve.resveCn}</p>
                                        </td>
                                        <td>
                                            <p>\${rturnStr}</p>
                                        </td>
                                        <td>
                                            \${buttonStr}
                                        </td>
                                    </tr>`;
                        $("#carRsvBody").append(rowStr);
                    });

                    $(".listrturnBtn").on("click", function (e) {
                        carResveNo = e.target.dataset.id;

                        let data = {
                            carResveNo: carResveNo,
                            rturnCd: "2",
                        };

                        updateReturnStatus(data);
                    });

                    $(".listUdtBtn").on("click", function (e) {
                        carResveNo = e.target.dataset.id;

                        // 예약 불러와서 모달 열기
                        getCarResveAndOpenModal(carResveNo);
                    });

                    $(".listDelBtn").on("click", function (e) {
                        carResveNo = e.target.dataset.id;

                        deleteCarResve(carResveNo);
                    });
                }
            },
        });
    } // 내 예약 리스트 불러오기 끝

    // 내 지난 예약 리스트 불러오기
    function getMyPastCarResveList() {
        $.ajax({
            url: `/api/reservations/car/past/\${empNo}`,
            type: "GET",
            dataType: "json",
            success: function (carResves) {
                console.log("carResves:", carResves);
                $("#pastCarRsvBody").empty();
                if (!carResves.length) {
                    let rowStr = `<tr>
                                        <td colspan="7" style="text-align:center;">
                                            <p>지난 2주간 차량 예약이 없습니다.</p>
                                        </td>
                                    </tr>`;
                    $("#pastCarRsvBody").append(rowStr);
                } else {
                    $.each(carResves, function (index, carResve) {
                        console.log("carResve : ", carResve);
                        let rowStr = "";

                        let carResveSDate = new Date(carResve.resveBeginDate.substr(0, 10));
                        let carResveSDateStr = formatDate(carResveSDate);
                        let carResveEDate = new Date(carResve.resveEndDate.substr(0, 10));
                        let carResveEDateStr = formatDate(carResveEDate);

                        let allDayCd = carResve.allDayCd;
                        let carResveDate = "";
                        if (allDayCd == "1") {
                            carResveDate = `<p>\${carResveSDateStr} ~ \${carResveEDateStr} <span class="wf-badge1">종일</span></p>`;
                        } else {
                            carResveDate = `<p>\${carResveSDateStr} \${carResve.resveBeginDate.substr(11,5)} ~ \${carResveEDateStr} \${carResve.resveEndDate.substr(11,5)}</p>`;
                        }

                        let rturnCd = carResve.rturnCd;
                        console.log("rturnCd", rturnCd);

                        let rturnStr = "";
                        let buttonStr = "";
                        if (rturnCd == "1") {
                            rturnStr = "<span class='wf-badge5'>반납 전</span>";
                            buttonStr = `<button type="button" class="btn5 listrturnBtn" data-id="\${carResve.carResveNo}">반납</button>`;
                        } else if (rturnCd == "2") {
                            rturnStr = "<span class='wf-badge4'>반납 처리 중</span>";
                            buttonStr = "<button type='button' class='btn5 listrturnBtn' disabled>반납</button>";
                        } else {
                            rturnStr = "<span class='wf-badge3'>반납 완료</span>";
                            buttonStr = "<button type='button' class='btn5 listrturnBtn' disabled>반납</button>";
                        }

                        rowStr = `  <tr>
                                        <td>
                                            <p>\${index+1}</p>
                                        </td>
                                        <td>
                                            <p>\${carResve.carNm}</p>
                                        </td>
                                        <td>
                                            <p>\${carResve.carNo}</p>
                                        </td>
                                        <td>
                                            \${carResveDate}                                            
                                        </td>
                                        <td>
                                            <p>\${carResve.resveCn}</p>
                                        </td>
                                        <td>
                                            <p>\${rturnStr}</p>
                                        </td>
                                        <td>
                                            \${buttonStr}
                                            <button type="button" class="btn4 listUdtBtn" disabled>예약 수정</button>
                                            <button type="button" class="btn3 listDelBtn" disabled>예약 취소</button>
                                        </td>
                                    </tr>`;
                        $("#pastCarRsvBody").append(rowStr);
                    });

                    $(".listrturnBtn").on("click", function (e) {
                        carResveNo = e.target.dataset.id;

                        let data = {
                            carResveNo: carResveNo,
                            rturnCd: "2",
                        };

                        updateReturnStatus(data);
                    });
                }
            },
        });
    } // 내 예약 리스트 불러오기 끝

    // 내 모든 예약 리스트 불러오기
    function getMyAllCarResveList() {
        getMyCarResveList();
        getMyPastCarResveList();
    }

    // 데이터 가져오기
    function getData() {
        const carRsvForm = document.querySelector("#carRsvForm");
        let data = serializeCarRsvVO(carRsvForm);
        console.log("vo: ", data);

        // Validation
        let rsvSDate = data.rsvSDate;
        let rsvSTime = data.rsvSTime;
        let rsvEDate = data.rsvEDate;
        let rsvETime = data.rsvETime;

        if (rsvSDate > rsvEDate) {
            alert(_msg.reservation.formDateErrorAlert);
            return false;
        }

        if (rsvSDate == rsvEDate && rsvETime <= rsvSTime && !$("#allDay").is(":checked")) {
            alert(_msg.reservation.formTimeErrorAlert);
            return false;
        }

        // 일시로 포맷
        let rsvStart = rsvSDate + " " + rsvSTime;
        let rsvEnd = rsvEDate + " " + rsvETime;

        // 포맷한 데이터 추가, 삭제
        delete data.rsvSDate;
        delete data.rsvSTime;
        delete data.rsvEDate;
        delete data.rsvETime;

        data.resveBeginDate = rsvStart;
        data.resveEndDate = rsvEnd;
        data.empNo = empNo;
        data.rturnCd = 1;

        return data;
    }

    //예약 상세 모달 불러오기
    function showCarRsvDetail(info) {
        console.log("Event clicked:", info);
        carResveNo = info.event._def.extendedProps.carResveNo;

        // 예약 불러와서 모달 열기
        getCarResveAndOpenModal(carResveNo);
    } // 예약 상세 모달 불러오기 끝

    // 차량 정보 가져와서 표시
    function getCarInfo(carNo) {
        // 초기화
        $("#carInfoBox").empty();

        $.ajax({
            url: `/api/car/\${carNo}`,
            type: "GET",
            dataType: "json",
            success: function (data) {
                console.log("carInfo : ", data);

                let infoStr = ` <img src='\${_storage}\${data.photoUrl}' style='width:400px'/>
                                    <p>차량번호 : \${data.carNo}</p>`;

                $("#carInfoBox").append(infoStr);
            },
        });
    } // 차량 정보 가져와서 표시 끝

    // 특정 예약 불러와서 모달 열기
    function getCarResveAndOpenModal(carResveNo) {
        $.ajax({
            url: `/api/reservation/car/\${carResveNo}`,
            type: "GET",
            dataType: "json",
            success: function (data) {
                console.log(data);
                // 팀원 정보 불러와서 채우기
                getEmpInfo(data.empNo, function (empInfo) {
                    let empNm = empInfo.empNm;
                    let position = empInfo.position;
                    let rspnsblCtgryNm = empInfo.rspnsblCtgryNm;
                    if (rspnsblCtgryNm != "팀원") {
                        position = rspnsblCtgryNm;
                    }
                    $("#rsvEmpName").val(`\${empNm} \${position}`);
                    $("#rsvEmpNameBox").css("display", "block");
                });

                // 예약자가 내가 아닌 경우 수정 삭제 버튼 비활성화
                if (empNo != data.empNo) {
                    $("#updateBtn").prop("disabled", true);
                    $("#deleteBtn").prop("disabled", true);
                }

                let carNo = data.carNo;
                $("#selectCar").val(carNo);
                $("#rsvEmpNameBox").css("display", "block");
                $("#rsvSDate").val(data.resveBeginDate.substr(0, 10));
                $("#rsvSTime").val(data.resveBeginDate.substr(11, 5));
                $("#rsvEDate").val(data.resveEndDate.substr(0, 10));
                $("#rsvETime").val(data.resveEndDate.substr(11, 5));
                $("#rsvCont").val(data.resveCn);

                let allDayCd = data.allDayCd;
                if (allDayCd == "1") {
                    $("#allDay").prop("checked", true);
                    $("#rsvSTime").val("");
                    $("#rsvETime").val("");
                    $("#rsvSTime").prop("disabled", true);
                    $("#rsvETime").prop("disabled", true);
                }

                // 반납코드
                let rturnCd = data.rturnCd;
                let rturnStts = "";
                if (rturnCd == "1") {
                    rturnStts = "<span class='wf-badge5'>반납 전</span>";
                } else if (rturnCd == "2") {
                    rturnStts = "<span class='wf-badge4'>반납 처리 중</span>";
                    $("#rturnBtn").prop("disabled", true);
                } else {
                    rturnStts = "<span class='wf-badge3'>반납 완료</span>";
                    $("#rturnBtn").prop("disabled", true);
                }
                $("#rturnStts").html(rturnStts);

                getCarInfo(carNo);
            },
        });

        // 예약 상세 모달로 바꾸기
        $("#modalTit").text("예약 상세");
        $("#createBtnGroup").css("display", "none");
        $("#updateBtnGroup").css("display", "block");
        $("#rturnSttsBox").css("display", "block");

        // 모달 열기
        $("#rsvModal").addClass("open");
    } // 특정 예약 불러와서 모달 열기 끝

    // 예약 등록
    function createCarResve(data) {
        console.log("create data : ", data);
        $.ajax({
            url: "/api/reservation/car",
            type: "POST",
            data: JSON.stringify(data),
            contentType: "application/json;charset=utf-8",
            dataType: "text",
            beforeSend: function (xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function (rslt) {
                console.log("create : ", rslt);

                if (rslt == "success") {
                    // 캘린더에 반영
                    getAndInitializeReservation();

                    // 알림 출력
                    Toast.fire({
                        icon: "success",
                        title: _msg.reservation.insertSuccessAlert,
                    });
                } else {
                    Toast.fire({
                        icon: "info",
                        title: _msg.reservation.insertFailAlert,
                    });
                }
            },
        });
    } // 예약 등록 끝

    // 예약 수정
    function updateCarResve(data, carResveNo) {
        console.log("update data : ", data);
        $.ajax({
            url: `/api/reservation/car/\${carResveNo}`,
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
                    // 알림 출력
                    Toast.fire({
                        icon: "success",
                        title: _msg.reservation.updateSuccessAlert,
                    });
                    // 데이터, 캘린더 로드
                    getAndInitializeReservation();
                    getMyAllCarResveList();
                } else {
                    Toast.fire({
                        icon: "info",
                        title: _msg.reservation.updateFailAlert,
                    });
                }
            },
        });
    } // 예약 수정 끝

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
                            getAndInitializeReservation();
                            getMyAllCarResveList();
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
        // 모달 닫기
        $("#rsvModal").removeClass("open");

        // 반납 확인창 표시
        Swal.fire({
            title: _msg.reservation.returnConfirm,
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
                                title: _msg.reservation.returnSuccessAlert,
                            });
                            getAndInitializeReservation();
                            getMyAllCarResveList();
                        } else {
                            Toast.fire({
                                icon: "info",
                                title: _msg.reservation.returnFailAlert,
                            });
                        }
                    },
                });
            } else if (result.isDenied) {
                Toast.fire({
                    icon: "info",
                    title: _msg.reservation.returnFailAlert,
                });
            }
        });
    }

    // 차량 목록 선택보기 불러오기
    function getCarOptions() {
        $.ajax({
            url: "/api/cars",
            type: "GET",
            dataType: "json",
            success: function (cars) {
                $("#keyword").empty();

                let keywordStr = "<option value=''>전체보기</option>";

                cars.forEach(function (car, index) {
                    keywordStr += `<option value="\${car.carNo}">\${car.carNm}</option>`;
                });
                $("#keyword").append(keywordStr);
            },
        });
    }

    // 회의실 목록 불러오기
    function getCarsForModal() {
        $.ajax({
            url: "/api/cars",
            type: "GET",
            dataType: "json",
            success: function (cars) {
                $("#selectCar").empty();
                let selectCarStr = "";

                cars.forEach(function (car, index) {
                    let useCd = car.carUsePosblYnCd;
                    if (useCd != "0") {
                        selectCarStr += `<option value="\${car.carNo}">\${car.carNm}</option>`;
                    } else {
                        selectCarStr += `<option value="\${car.carNo}" disabled>\${car.carNm}</option>`;
                    }
                });
                $("#selectCar").append(selectCarStr);

                // 특정 회의실 정보 불러오기
                getCarInfo(cars[0].carNo);
            },
        });
    }
</script>
<!--------------------------------- body 시작 --------------------------------->
<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
    <h1 class="page-tit">차량 예약</h1>
    <div class="side-util">
        <button type="button" class="btn2" id="createBtn">차량 예약</button>
    </div>
</div>
<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
    <div class="tab-type tab-type2">
        <div class="tab-menu">
            <!-- "active"가 추가되면 메뉴가 활성화됩니다. -->
            <button data-tab="tab1" type="button" class="tab-btn active" id="carRsvListBtn">예약 현황</button>
            <button data-tab="tab2" type="button" class="tab-btn" id="myCarRsvBtn">내 예약</button>
            <button data-tab="tab3" type="button" class="tab-btn" id="myPastCarRsvBtn">지난 예약</button>
            <div class="tab-indicator"></div>
        </div>

        <!-- tab1  -->
        <div data-tab="tab1" class="tab-content active">
            <div class="wf-select-group" style="width: 200px;">
                <select name="" id="keyword"></select>
            </div>
            <div class="tab-board-lst">
                <div class="wf-content-area" id="calbox">
                    <div id="calendar"></div>
                </div>
            </div>
        </div>

        <!-- tab2  -->
        <div data-tab="tab2" class="tab-content">
            <div class="tab-board-lst">
                <div class="wf-content-area">
                    <table class="wf-table">
                        <colgroup>
                            <col style="width: 5%" />
                            <col style="width: 8%" />
                            <col style="width: 10%" />
                            <col style="width: 27%" />
                            <col style="width: 15%" />
                            <col style="width: 15%" />
                            <col style="width: 20%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>차량명</th>
                                <th>차량번호</th>
                                <th>예약일시</th>
                                <th>사용목적</th>
                                <th>반납상태</th>
                                <th>상태변경</th>
                            </tr>
                        </thead>
                        <tbody id="carRsvBody"></tbody>
                    </table>
                </div>
            </div>
        </div>
        <!-- tab3  -->
        <div data-tab="tab3" class="tab-content">
            <div class="tab-board-lst">
                <div class="wf-content-area">
                    <table class="wf-table">
                        <colgroup>
                            <col style="width: 5%" />
                            <col style="width: 8%" />
                            <col style="width: 10%" />
                            <col style="width: 27%" />
                            <col style="width: 15%" />
                            <col style="width: 15%" />
                            <col style="width: 20%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>차량명</th>
                                <th>차량번호</th>
                                <th>예약일시</th>
                                <th>사용목적</th>
                                <th>반납상태</th>
                                <th>상태변경</th>
                            </tr>
                        </thead>
                        <tbody id="pastCarRsvBody"></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<!--------------------------------- body 끝 --------------------------------->

<!--------------------------------- 예약 등록/수정 모달 시작 --------------------------------->
<div class="modal" id="rsvModal">
    <div class="modal-cont">
        <h1 class="modal-tit" id="modalTit">차량 예약</h1>
        <div class="modal-content-area">
            <div class="wf-flex-box baseline carModalbox">
                <form id="carRsvForm">
                    <ul class="wf-insert-form2 vertical">
                        <li>
                            <label for="selectCar">차량<i class="i">*</i></label>
                            <div>
                                <div class="wf-select-group">
                                    <select name="carNo" id="selectCar" required></select>
                                </div>
                            </div>
                        </li>
                        <li id="rsvEmpNameBox">
                            <label for="rsvEmpName">예약자</label>
                            <div>
                                <input type="text" name="rsvEmpName" id="rsvEmpName" />
                            </div>
                        </li>
                        <li>
                            <label for="cc">일시<i class="i">*</i></label>
                            <div class="wf-flex-box dateBox">
                                <input type="date" name="rsvSDate" id="rsvSDate" min="" max="" required />
                                <div class="wf-select-group">
                                    <select name="rsvSTime" id="rsvSTime" required>
                                        <option value="08:00">08:00</option>
                                        <option value="09:00">09:00</option>
                                        <option value="10:00">10:00</option>
                                        <option value="11:00">11:00</option>
                                        <option value="12:00">12:00</option>
                                        <option value="13:00">13:00</option>
                                        <option value="14:00">14:00</option>
                                        <option value="15:00">15:00</option>
                                        <option value="16:00">16:00</option>
                                        <option value="17:00">17:00</option>
                                        <option value="18:00">18:00</option>
                                        <option value="19:00">19:00</option>
                                        <option value="20:00">20:00</option>
                                        <option value="21:00">21:00</option>
                                        <option value="22:00">22:00</option>
                                    </select>
                                </div>
                                <span class="hyphen">-</span>
                                <input type="date" name="rsvEDate" id="rsvEDate" min="" max="" required />
                                <div class="wf-select-group">
                                    <select name="rsvETime" id="rsvETime" required>
                                        <option value="08:00">08:00</option>
                                        <option value="09:00">09:00</option>
                                        <option value="10:00">10:00</option>
                                        <option value="11:00">11:00</option>
                                        <option value="12:00">12:00</option>
                                        <option value="13:00">13:00</option>
                                        <option value="14:00">14:00</option>
                                        <option value="15:00">15:00</option>
                                        <option value="16:00">16:00</option>
                                        <option value="17:00">17:00</option>
                                        <option value="18:00">18:00</option>
                                        <option value="19:00">19:00</option>
                                        <option value="20:00">20:00</option>
                                        <option value="21:00">21:00</option>
                                        <option value="22:00">22:00</option>
                                    </select>
                                </div>
                                <span class="checkbox-radio-custom allDaySpan">
                                    <input type="checkbox" name="allDayCd" id="allDay" value="1" />
                                    <label for="allDay">종일</label>
                                </span>
                            </div>
                        </li>
                        <li>
                            <label for="rsvCont">사용 목적<i class="i">*</i></label>
                            <div>
                                <textarea name="resveCn" id="rsvCont" placeholder="사용목적" required></textarea>
                            </div>
                        </li>
                        <li id="rturnSttsBox">
                            <label for="rturnStts">반납 상태</label>
                            <div name="rturnCd" id="rturnStts"></div>
                        </li>
                    </ul>
                </form>
                <ul class="wf-insert-form2 vertical">
                    <li>
                        <p class="heading2">차량 정보</p>
                        <div id="carInfoBox"></div>
                    </li>
                </ul>
            </div>
        </div>

        <div class="modal-btn-wrap" id="createBtnGroup">
            <button class="btn5" id="autoComplete">자동완성</button>
            <button type="submit" form="carRsvForm" class="btn2" id="createConfBtn">예약</button>
        </div>

        <div class="modal-btn-wrap" id="updateBtnGroup">
            <button class="btn5" id="rturnBtn">반납</button>
            <button type="submit" form="carRsvForm" class="btn4" id="updateBtn">예약 수정</button>
            <button class="btn3" id="deleteBtn">예약 취소</button>
        </div>

        <button class="close-btn" id="rsvModalCloseBtn"></button>
    </div>
</div>
<!--------------------------------- 예약 등록/수정 모달 끝 --------------------------------->
