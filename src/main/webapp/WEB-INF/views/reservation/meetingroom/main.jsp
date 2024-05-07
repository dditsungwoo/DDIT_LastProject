<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- fullcalendar -->
<link href="${pageContext.request.contextPath}/resources/css/fullcalendar.css" rel="stylesheet" />
<script src="${pageContext.request.contextPath}/resources/js/fullcalendar.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/fullcalendar-ko.js"></script>
<!-- CSS -->
<link href="${pageContext.request.contextPath}/resources/css/reservation/style.css" rel="stylesheet" />
<script>
    let empNo = '<%=(String)session.getAttribute("empNo")%>';
</script>
<!-- Javascript -->
<script src="${pageContext.request.contextPath}/resources/script/common/commonForSchAndRsv.js" defer></script>
<script>
    // 회의실 예약 번호
    let mtrResveNo;

    // 회의실 종류에 따른 색상
    const room1Color = "#40AEB6";
    const room2Color = "#5CB164";
    const room3Color = "#BF7FD2";
    const room4Color = "#3CA8E4";
    const room5Color = "#ED855A";

    // form에서 값 가져오기
    const serializeMtrRsvVO = function (cForm) {
        let elems = cForm.elements;
        let rsltObj = {};
        for (let i = 0; i < elems.length; i++) {
            if (elems[i].name == "allDay") continue;
            if (elems[i].name == "rsvEmpName") continue;
            if (elems[i].type == "submit") continue;
            rsltObj[elems[i].name] = elems[i].value;
        }
        return rsltObj;
    };

    $(function () {
        // modal 달력 최소값 설정
        let today = new Date().toISOString().split("T")[0];
        document.querySelector("#rsvDate").min = today;

        // 예약 리스트 불러오고 캘린더 랜더링
        getAndInitializeReservation();
        // 회의실 목록 선택보기 불러오기
        getMtrOptions();

        // 예약 현황 탭 누르면 예약 불러오기
        $("#rsvListBtn").on("click", function () {
            getAndInitializeReservation();
        });

        // 내 예약 탭 누르면 예약 불러오기
        $("#myMtrRsvBtn").on("click", function () {
            getMyMtrResveList();
        });

        // 차 선택 변경하면 예약 불러오기
        $("#keyword").on("change", function () {
            getAndInitializeReservation();
        });

        // 지난 예약 탭 누르면 예약 불러오기
        $("#myPastMtrRsvBtn").on("click", function () {
            getMyPastMtrResveList();
        });

        // 예약 등록(추가) 버튼 클릭하면 모달 표시
        $("#createBtn").on("click", function () {
            // 모달 초기화
            document.getElementById("rsvDate").value = "";
            document.getElementById("rsvSTime").value = "08:00";
            document.getElementById("rsvETime").value = "08:00";
            document.getElementById("rsvCont").value = "";

            // 회의실 목록 불러오기
            getMtrsForModal();

            document.getElementById("rsvModal").classList.add("open");
        });

        // 회의실 바꿈에 따라
        $("#selectRoom").on("change", function () {
            let mtrNo = $("#selectRoom").val();
            // 회의실 정보 불러와서 표시
            getMtrInfo(mtrNo);
            // 예약된 시간 비활성화
            getInfoAndDisableTime();
        });

        // 날짜 바꿈에 따라
        $("#rsvDate").on("change", function () {
            // 예약된 시간 비활성화
            getInfoAndDisableTime();
        });

        // 모달 닫으면
        $("#rsvModalCloseBtn").on("click", function () {
            // 제목 바꾸고
            $("#modalTit").text("회의실 예약");
            $("#rsvEmpNameBox").css("display", "none");
            // 수정삭제버튼 disabled 풀고
            $("#updateBtn").prop("disabled", false);
            $("#deleteBtn").prop("disabled", false);
            // 수정삭제버튼 안보이게 하기
            $("#updateBtnGroup").css("display", "none");
            $("#createBtnGroup").css("display", "block");
        });

        // 폼 제출 버튼 눌렀을 때 등록 또는 수정
        $("#mtrRsvForm").on("submit", function () {
            event.preventDefault();

            let data = getData();
            if (data) {
                let buttonId = event.submitter.id;
                if (buttonId == "createConfBtn") {
                    createMtrResve(data);
                } else if (buttonId == "updateBtn") {
                    updateMtrResve(data, mtrResveNo);
                }

                $("#rsvModal").removeClass("open");
            }
        });

        // 예약 취소 버튼 누르면 모달 닫고 예약 삭제 진행
        $("#deleteBtn").on("click", function () {
            $("#rsvModal").removeClass("open");
            deleteMtrResve(mtrResveNo);
        });

        // 자동 완성
        $("#autoComplete").on("click", function () {
            $("#rsvDate").val("2024-04-18");
            $("#rsvSTime").val("10:00");
            $("#rsvETime").val("12:00");
            $("#rsvCont").val("개발팀 프로젝트 회의");
        });
    });

    // 회의실 예약 리스트 불러오기
    function getMtrResveList() {
        let keyword = $("#keyword").val();
        data = {
            mtrNo: keyword,
        };

        return $.ajax({
            url: "/api/reservations/mtr",
            type: "GET",
            data: data,
            dataType: "json",
        }).done(function (data) {
            data.forEach(function (item) {
                let mtrNo = item.mtrNo;
                // 회의실 종류에 따라 색상 설정
                if (mtrNo == "ROOM1") {
                    item.backgroundColor = room1Color;
                } else if (mtrNo == "ROOM2") {
                    item.backgroundColor = room2Color;
                } else if (mtrNo == "ROOM3") {
                    item.backgroundColor = room3Color;
                } else if (mtrNo == "ROOM4") {
                    item.backgroundColor = room4Color;
                } else {
                    item.backgroundColor = room5Color;
                }
            });
        });
    } // 회의실 예약 리스트 불러오기 끝

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
                showMtrRsvDetail(info);
            },

            // 캘린더에서 클릭 또는 드래그로 예약 등록 모달 표시
            select: function (info) {
                console.log("clicked info : ", info);

                let calendarType = info.view.type;
                let timeStr = "";
                if (calendarType != "dayGridMonth") {
                    timeStr = info.startStr.substr(11, 2) + ":00";
                    console.log(timeStr);
                } else {
                    timeStr = "08:00";
                }

                // 초기화
                document.querySelector("#rsvSTime").value = timeStr;
                document.querySelector("#rsvETime").value = timeStr;
                document.querySelector("#rsvDate").value = info.startStr.substr(0, 10);
                document.querySelector("#rsvCont").value = "";

                // 예약 시간 비활성화
                getInfoAndDisableTime();

                // 회의실 목록 불러오기
                getMtrsForModal();

                document.querySelector("#rsvModal").classList.add("open");
            },
        });
        calendar.render();
    } // 캘린더 랜더링 끝

    // 예약 리스트 불러오고 캘린더 랜더링
    function getAndInitializeReservation() {
        getMtrResveList().done(function (data) {
            initializeFullCalendarWithData(data);
        });
    }

    // 내 예약 리스트 불러오기
    function getMyMtrResveList() {
        $.ajax({
            url: `/api/reservations/mtr/\${empNo}`,
            type: "GET",
            dataType: "json",
            success: function (mtrResves) {
                console.log("mtrResves:", mtrResves);
                $("#mtrRsvBody").empty();
                if (!mtrResves.length) {
                    let rowStr = `<tr >
                                    <td colspan="6" style="text-align:center;">
                                        <p>신청한 회의실 예약이 없습니다.</p>
                                    </td>
                                </tr>`;
                    $("#mtrRsvBody").append(rowStr);
                } else {
                    $.each(mtrResves, function (index, mtrResve) {
                        console.log("mtrResve:");
                        let mtrResveDate = new Date(mtrResve.resveBeginDate.substr(0, 10));
                        let mtrResveDateStr = formatDate(mtrResveDate);
                        let rowStr = `<tr>
                                        <td>
                                            <p>\${index+1}</p>
                                        </td>
                                        <td>
                                            <p>\${mtrResve.mtrNm}</p>
                                        </td>
                                        <td>
                                            <p>\${mtrResve.mtrLoc}</p>
                                        </td>
                                        <td>
                                            <p>\${mtrResveDateStr} \${mtrResve.resveBeginDate.substr(11,5)}~\${mtrResve.resveEndDate.substr(11,5)}</p>
                                        </td>
                                        <td>
                                            <p>\${mtrResve.resveCn}</p>
                                        </td>
                                        <td>
                                            <p>
                                                <button type="button" class="btn4 listUdtBtn" data-id="\${mtrResve.mtrResveNo}">예약 수정</button>
                                                <button type="button" class="btn3 listDelBtn" data-id="\${mtrResve.mtrResveNo}">예약 취소</button>
                                            </p>
                                        </td>
                                    </tr>`;
                        $("#mtrRsvBody").append(rowStr);
                    });
                }
                // 내 예약 목록에서 수정 버튼 누르면 수정 모달 열기
                $(".listUdtBtn").on("click", function (e) {
                    mtrResveNo = e.target.dataset.id;

                    // 예약 불러와서 모달 열기
                    getMtrResveAndOpenModal(mtrResveNo);
                });

                // 내 예약 목록에서 삭제 누르면 삭제 진행
                $(".listDelBtn").on("click", function (e) {
                    mtrResveNo = e.target.dataset.id;

                    deleteMtrResve(mtrResveNo);
                });
            },
        });
    } // 내 예약 리스트 불러오기 끝

    // 내 지난 예약 리스트 불러오기
    function getMyPastMtrResveList() {
        $.ajax({
            url: `/api/reservations/mtr/past/\${empNo}`,
            type: "GET",
            dataType: "json",
            success: function (mtrResves) {
                console.log("mtrResves:", mtrResves);
                $("#pastMtrRsvBody").empty();
                if (!mtrResves.length) {
                    let rowStr = `<tr>
                                        <td colspan="6">
                                            <p>지난 2주간 회의실 예약이 없습니다.</p>
                                        </td>
                                    </tr>`;
                    $("#pastMtrRsvBody").append(rowStr);
                } else {
                    $.each(mtrResves, function (index, mtrResve) {
                        console.log("mtrResve:");
                        let mtrResveDate = new Date(mtrResve.resveBeginDate.substr(0, 10));
                        let mtrResveDateStr = formatDate(mtrResveDate);
                        let rowStr = `<tr>
                                            <td>
                                                <p>\${index+1}</p>
                                            </td>
                                            <td>
                                                <p>\${mtrResve.mtrNm}</p>
                                            </td>
                                            <td>
                                                <p>\${mtrResve.mtrLoc}</p>
                                            </td>
                                            <td>
                                                <p>\${mtrResveDateStr} \${mtrResve.resveBeginDate.substr(11,5)}~\${mtrResve.resveEndDate.substr(11,5)}</p>
                                            </td>
                                            <td>
                                                <p>\${mtrResve.resveCn}</p>
                                            </td>
                                            <td>
                                                <p>
                                                <button type="button" class="btn4 listUdtBtn" disabled>예약 수정</button>
                                                <button type="button" class="btn3 listDelBtn" disabled>예약 취소</button>
                                            </p>
                                            </td>
                                        </tr>`;
                        $("#pastMtrRsvBody").append(rowStr);
                    });
                }
            },
        });
    } // 내 지난 예약 리스트 불러오기 끝

    // 내 모든 예약 리스트 불러오기
    function getMyAllMtrResveList() {
        getMyMtrResveList();
        getMyPastMtrResveList();
    }

    // 데이터 가져오기
    function getData() {
        const mtrRsvForm = document.querySelector("#mtrRsvForm");
        let data = serializeMtrRsvVO(mtrRsvForm);

        // Validation
        let rsvDate = data.rsvDate;
        let rsvSTime = data.rsvSTime;
        let rsvETime = data.rsvETime;

        if (rsvETime <= rsvSTime) {
            alert(_msg.reservation.formTimeErrorAlert);
            return false;
        }

        // 일시로 포맷
        let rsvStart = rsvDate + " " + rsvSTime;
        let rsvEnd = rsvDate + " " + rsvETime;

        // 포맷한 데이터 추가, 삭제
        delete data.rsvDate;
        delete data.rsvSTime;
        delete data.rsvETime;

        data.resveBeginDate = rsvStart;
        data.resveEndDate = rsvEnd;
        data.empNo = empNo;

        return data;
    }

    // 예약 상세 모달 불러오기
    function showMtrRsvDetail(info) {
        console.log("Event clicked:", info);
        mtrResveNo = info.event._def.extendedProps.mtrResveNo;

        // 예약 불러와서 모달 열기
        getMtrResveAndOpenModal(mtrResveNo);
    }

    // 회의실 정보 가져와서 표시
    function getMtrInfo(mtrNo) {
        // 초기화
        $("#mtrInfoBox").empty();
        $("#mtrImgBox").empty();

        $.ajax({
            url: `/api/mtr/\${mtrNo}`,
            type: "GET",
            dataType: "json",
            success: function (data) {
                console.log("mtrInfo : ", data);
                let infoStr = ` <p>\${data.mtrNm}(\${data.mtrLoc})</p>
                                        <p>수용 가능 인원 : \${data.aceptblNmpr}명</p>
                                        `;

                data.mtrEquipedList.forEach(function (item) {
                    console.log("item :", item);
                    let itemType = item.eqpmnNo;
                    let iconStyle = "font-size: 30px;";
                    let iconClass = "";
                    let description = "";

                    if (itemType == 1) {
                        iconClass = "xi-projector";
                        description = "프로젝터";
                    } else if (itemType == 2) {
                        iconClass = "xi-laptop";
                        description = "화이트보드";
                    } else if (itemType == 3) {
                        iconClass = "xi-keyboard-o";
                        description = "컴퓨터";
                    } else {
                        iconClass = "xi-microphone";
                        description = "마이크";
                    }

                    if (item.equipYnCd == 0) {
                        iconStyle += " color: #e4e3e3;";
                    }

                    infoStr += "<i class='" + iconClass + "' title='" + description + "' style='" + iconStyle + "'></i>";
                });

                let imgStr = `<img src='\${_storage}\${data.photoUrl}' style='width:400px'/>`;

                $("#mtrInfoBox").append(infoStr);
                $("#mtrImgBox").append(imgStr);
            },
        });
    } // 회의실 정보 가져와서 표시 끝

    // 날짜, 시간 가져와서 이미 예약된 시간 비활성화
    function getInfoAndDisableTime() {
        let mtrNo = $("#selectRoom").val();
        let resveBeginDate = $("#rsvDate").val();
        if (mtrNo && resveBeginDate) {
            console.log("실행한다");
            getMtrResvedTimes(mtrNo, resveBeginDate);
        }
    }

    // 예약된 시간 추출
    function getMtrResvedTimes(mtrNo, resveBeginDate) {
        $.ajax({
            url: `/api/mtr/reservedTimes/\${mtrNo}/\${resveBeginDate}`,
            type: "GET",
            dataType: "json",
            success: function (rsvTimes) {
                console.log(rsvTimes);
                let allTimes = [];
                let selectIds = ["rsvSTime", "rsvETime"];

                if (!rsvTimes.length) {
                    disableResvedTimes(allTimes, selectIds);
                } else {
                    rsvTimes.forEach(function (rsvTime) {
                        // 시작 시간과 종료 시간 사이 모든 시간을 추출
                        getAllTimesBetween(rsvTime.resveBeginDate, rsvTime.resveEndDate, allTimes);
                        disableResvedTimes(allTimes, selectIds);
                        console.log("disabled time : ", allTimes);
                    });
                }
            },
        });
    }

    // 시작 시간과 종료시간 사이의 모든 시간을 배열로 반환
    function getAllTimesBetween(sTime, eTime, allTimes) {
        let sDate = new Date(sTime);
        let eDate = new Date(eTime);

        while (sDate < eDate) {
            let hours = sDate.getHours().toString().padStart(2, "0");
            let timeStr = hours + ":00";
            allTimes.push(timeStr);
            sDate.setHours(sDate.getHours() + 1);
        }
    }

    // 시간 비활성화
    function disableResvedTimes(allTimes, selectIds) {
        selectIds.forEach(function (selectId) {
            let selectElement = document.querySelector("#" + selectId);
            let options = selectElement.options;

            // 옵션 초기화
            for (let i = 0; i < options.length; i++) {
                options[i].disabled = false;
            }
            // 예약된 시간이 있으면 비활성화
            if (allTimes.length) {
                allTimes.forEach(function (reservedTime) {
                    let option = selectElement.querySelector('option[value="' + reservedTime + '"]');
                    if (option) {
                        option.disabled = true;
                    }
                });
            }
        });
    }

    // 특정 예약 불러와서 모달 열기
    function getMtrResveAndOpenModal(mtrResveNo) {
        $.ajax({
            url: `/api/reservation/mtr/\${mtrResveNo}`,
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

                let mtrNo = data.mtrNo;
                $("#selectRoom").val(mtrNo);
                $("#rsvDate").val(data.resveBeginDate.substr(0, 10));
                $("#rsvSTime").val(data.resveBeginDate.substr(11, 5));
                $("#rsvETime").val(data.resveEndDate.substr(11, 5));
                $("#rsvCont").val(data.resveCn);

                getMtrInfo(mtrNo);
            },
        });

        // 예약 상세 모달로 바꾸기
        $("#modalTit").text("예약 상세");
        $("#createBtnGroup").css("display", "none");
        $("#updateBtnGroup").css("display", "block");

        // 모달 열기
        $("#rsvModal").addClass("open");
    }

    // 예약 등록
    function createMtrResve(data) {
        console.log("create data : ", data);
        $.ajax({
            url: "/api/reservation/mtr",
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
                    $("#rsvModal").removeClass("open");
                    // 알림 출력
                    Toast.fire({
                        icon: "success",
                        title: _msg.reservation.insertSuccessAlert,
                    });

                    getAndInitializeReservation();
                    getMyAllMtrResveList();
                } else {
                    Toast.fire({
                        icon: "success",
                        title: _msg.reservation.insertFailAlert,
                    });
                }
            },
        });
    } // 예약 등록 끝

    // 예약 수정
    function updateMtrResve(data, mtrResveNo) {
        console.log("update data : ", data);
        $.ajax({
            url: `/api/reservation/mtr/\${mtrResveNo}`,
            type: "PUT",
            data: JSON.stringify(data),
            contentType: "application/json;charset=utf-8",
            dataType: "text",
            beforeSend: function (xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function (rslt) {
                console.log(rslt);

                if (rslt == "success") {
                    // 알림 출력
                    Toast.fire({
                        icon: "success",
                        title: _msg.reservation.updateSuccessAlert,
                    });
                    // 데이터, 캘린더 로드
                    getAndInitializeReservation();
                    getMyAllMtrResveList();
                } else {
                    Toast.fire({
                        icon: "success",
                        title: _msg.reservation.updateFailAlert,
                    });
                }
            },
        });
    } // 예약 수정 끝

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
                            getAndInitializeReservation();
                            getMyAllMtrResveList();
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

    // 회의실 목록 선택보기 불러오기
    function getMtrOptions() {
        $.ajax({
            url: "/api/mtrs",
            type: "GET",
            dataType: "json",
            success: function (mtrs) {
                $("#keyword").empty();

                let keywordStr = "<option value=''>전체보기</option>";

                mtrs.forEach(function (mtr, index) {
                    keywordStr += `<option value="\${mtr.mtrNo}">\${mtr.mtrNm}</option>`;
                });
                $("#keyword").append(keywordStr);
            },
        });
    }

    // 회의실 목록 불러오기
    function getMtrsForModal() {
        $.ajax({
            url: "/api/mtrs",
            type: "GET",
            dataType: "json",
            success: function (mtrs) {
                $("#selectRoom").empty();
                let selectRoomStr = "";

                mtrs.forEach(function (mtr, index) {
                    let useCd = mtr.usePosblYnCd;
                    if (useCd != "0") {
                        selectRoomStr += `<option value="\${mtr.mtrNo}">\${mtr.mtrNm}</option>`;
                    } else {
                        selectRoomStr += `<option value="\${mtr.mtrNo}" disabled>\${mtr.mtrNm}</option>`;
                    }
                });
                $("#selectRoom").append(selectRoomStr);

                // 특정 회의실 정보 불러오기
                getMtrInfo(mtrs[0].mtrNo);
            },
        });
    }
</script>

<!--------------------------------- body 시작 --------------------------------->
<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
    <h1 class="page-tit">회의실 예약</h1>
    <div class="side-util">
        <button type="button" class="btn2" id="createBtn">회의실 예약</button>
    </div>
</div>
<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
    <div class="tab-type tab-type2">
        <div class="tab-menu">
            <!-- "active"가 추가되면 메뉴가 활성화됩니다. -->
            <button data-tab="tab1" type="button" class="tab-btn active" id="rsvListBtn">예약 현황</button>
            <button data-tab="tab2" type="button" class="tab-btn" id="myMtrRsvBtn">내 예약</button>
            <button data-tab="tab3" type="button" class="tab-btn" id="myPastMtrRsvBtn">지난 예약</button>
            <div class="tab-indicator"></div>
        </div>

        <!-- tab1  -->
        <div data-tab="tab1" class="tab-content active">
            <div class="wf-select-group" style="width:200px;">
                <select name="mtrNo" id="keyword"></select>
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
                            <col style="width: 10%" />
                            <col style="width: 15%" />
                            <col style="width: 15%" />
                            <col style="width: 20%" />
                            <col style="width: 20%" />
                            <col style="width: 20%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>종류</th>
                                <th>위치</th>
                                <th>예약일시</th>
                                <th>사용목적</th>
                                <th>상태변경</th>
                            </tr>
                        </thead>
                        <tbody id="mtrRsvBody"></tbody>
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
                            <col style="width: 10%" />
                            <col style="width: 15%" />
                            <col style="width: 15%" />
                            <col style="width: 20%" />
                            <col style="width: 20%" />
                            <col style="width: 20%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>종류</th>
                                <th>위치</th>
                                <th>예약일시</th>
                                <th>사용목적</th>
                                <th>상태변경</th>
                            </tr>
                        </thead>
                        <tbody id="pastMtrRsvBody"></tbody>
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
        <h1 class="modal-tit" id="modalTit">회의실 예약</h1>
        <div class="modal-content-area">
            <div class="wf-flex-box baseline">
                <form id="mtrRsvForm">
                    <ul class="wf-insert-form2 vertical">
                        <li>
                            <label for="selectRoom">회의실<i class="i">*</i></label>
                            <div>
                                <div class="wf-select-group">
                                    <select name="mtrNo" id="selectRoom" required></select>
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
                            <div class="wf-flex-box">
                                <input type="date" name="rsvDate" id="rsvDate" min="" max="" required />
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
                            </div>
                        </li>
                        <li>
                            <label for="rsvCont">사용 목적<i class="i">*</i></label>
                            <div>
                                <textarea name="resveCn" id="rsvCont" placeholder="사용목적" required></textarea>
                            </div>
                        </li>
                    </ul>
                </form>
                <ul class="wf-insert-form2 vertical">
                    <li>
                        <p class="heading2">회의실 정보</p>
                        <div id="mtrImgBox"></div>
                        <div id="mtrInfoBox"></div>
                    </li>
                </ul>
            </div>
        </div>

        <div class="modal-btn-wrap" id="createBtnGroup">
            <button class="btn5" id="autoComplete">자동완성</button>
            <button type="submit" form="mtrRsvForm" class="btn2" id="createConfBtn">예약</button>
        </div>

        <div class="modal-btn-wrap" id="updateBtnGroup">
            <button class="btn3" id="deleteBtn">예약취소</button>
            <button type="submit" form="mtrRsvForm" class="btn4" id="updateBtn">예약수정</button>
        </div>

        <button class="close-btn" id="rsvModalCloseBtn"></button>
    </div>
</div>
<!--------------------------------- 예약 등록/수정 모달 끝 --------------------------------->
