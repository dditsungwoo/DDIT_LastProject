<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- fullcalendar -->
<link href="${pageContext.request.contextPath}/resources/css/fullcalendar.css" rel="stylesheet" />
<script src="${pageContext.request.contextPath}/resources/js/fullcalendar.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/fullcalendar-ko.js"></script>
<!-- CSS -->
<link href="${pageContext.request.contextPath}/resources/css/schedule/style.css" rel="stylesheet" />
<script>
    let empNo = '<%=(String)session.getAttribute("empNo")%>';
    console.log(empNo);
</script>
<!-- Javascript -->
<script src="${pageContext.request.contextPath}/resources/script/schedule/main.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/script/common/commonForSchAndRsv.js" defer></script>
<script>
    /* ---------------------------- 전역변수 영역 시작 ---------------------------- */
    // 일정 번호
    let schdulNo;

    const myColor = "#0cc24c";
    const teamColor = "#319ef1";
    const deptColor = "#9266ff";
    const compColor = "#f85385";

    // form에서 값 가져오기
    const serializeSchVO = function (cForm) {
        let elems = cForm.elements;
        let rsltObj = {};
        for (let i = 0; i < elems.length; i++) {
            if (elems[i].name == "schEmpName") continue;
            if (elems[i].type == "submit") continue;

            if (elems[i].name == "allDayCd") {
                if (!elems[i].checked) {
                    rsltObj[elems[i].name] = "0";
                    continue;
                }
            }
            rsltObj[elems[i].name] = elems[i].value;
        }
        return rsltObj;
    };

    /* ---------------------------- 전역변수 영역 끝---------------------------- */

    $(function () {
        // modal 달력 최소값 설정
        let today = new Date().toISOString().split("T")[0];
        document.querySelector("#schSDate").min = today;
        document.querySelector("#schEDate").min = today;

        // 일정들 불러오고 난 뒤 캘린더 랜더링
        getAndInitializeSchedule();

        // 체크박스 선택이 변경되면 일정 다시 불러오기
        $(".chkSch").on("change", function () {
            getAndInitializeSchedule();

            /* getSchedule().done(function (data) {
                calendar.removeAllEvents(); // 기존 이벤트 제거
                calendar.addEventSource(data); // 새로운 이벤트 추가
                calendar.refetchEvents(); // 이벤트 다시 로드
            }); */
        });

        // 일정 등록(추가) 버튼 클릭하면 모달 표시
        $("#createBtn").on("click", function () {
            // 모달 초기화
            $("#selectSch").val("1");
            $("#schName").val("");
            $("#schSDate").val("");
            $("#schEDate").val("");
            $("#schSTime").val("08:00");
            $("#schETime").val("08:00");
            $("#schLoc").val("");
            $("#schCont").val("");
            // 모달 표시
            $("#schModal").addClass("open");
        });

        // 모달 닫으면
        $("#schModalCloseBtn").on("click", function () {
            // 모달 제목 바꾸기
            $("#modalTit").text("일정 등록");
            // 등록자 박스 안보이게
            $("#schEmpNameBox").css("display", "none");
            // 올데이 체크 풀기
            $("#allDay").prop("checked", false);
            $("#schSTime").prop("disabled", false);
            $("#schETime").prop("disabled", false);
            // 수정삭제버튼 disabled 풀기
            $("#updateBtn").prop("disabled", false);
            $("#deleteBtn").prop("disabled", false);
            // 수정삭제버튼 안보이고, 등록취소버튼 보이게
            $("#updateBtnGroup").css("display", "none");
            $("#createBtnGroup").css("display", "block");
        });

        // 모달에서 종일버튼 클릭에 따라 시간선택 활성화 변경
        $("#allDay").on("change", function () {
            if ($(this).is(":checked")) {
                $("#schSTime").prop("disabled", true);
                $("#schETime").prop("disabled", true);
            } else {
                $("#schSTime").prop("disabled", false);
                $("#schETime").prop("disabled", false);
            }
        });

        // 폼 제출 버튼 눌렀을 때 등록 또는 수정
        $("#schForm").on("submit", function () {
            event.preventDefault();
            console.log("cllick event:", event.submitter.id);

            let data = getData();
            if (data) {
                let buttonId = event.submitter.id;
                if (buttonId == "createConfBtn") {
                    createEvent(data);
                } else if (buttonId == "updateBtn") {
                    updateEvent(data, schdulNo);
                }
                $("#schModal").removeClass("open");
            }
        });

        // 일정 삭제 버튼 누르면 모달 닫고 일정 삭제 진행
        $("#deleteBtn").on("click", function () {
            $("#schModal").removeClass("open");
            deleteEvent(schdulNo);
        });

        // 자동 완성
        $("#autoComplete").on("click", function () {
            $("#selectSch").val("2");
            $("#schName").val("개발팀 회식");
            $("#schSDate").val("2024-04-18");
            $("#schEDate").val("2024-04-18");
            $("#schSTime").val("18:00");
            $("#schETime").val("22:00");
            $("#schLoc").val("오류동 오목돈");
            $("#schCont").val("프로젝트 완료 기념 회식합니다!");
        });

        // 캘린더에 표시할 일정 불러오기
        function getScheduleList() {
            let chkSchs = [];
            // 체크된 체크박스의 값을 배열에 추가
            $(".chkSch:checked").each(function () {
                chkSchs.push(this.id);
                console.log("check :", chkSchs);
            });

            // 배열을 쿼리 문자열로 변환
            let queryString = chkSchs.map(function (id) {
                return "chkSchs=" + encodeURIComponent(id);
            });

            return $.ajax({
                url: "/api/schedules?" + queryString.join("&"),
                method: "GET",
                contentType: "application/json",
                dataType: "json",
            }).done(function (data) {
                data.forEach(function (item) {
                    // 일정 종류에 따라 색상 설정
                    if (item.schType == "mySch") {
                        item.backgroundColor = myColor;
                    } else if (item.schType == "teamSch") {
                        item.backgroundColor = teamColor;
                        if (item.schSeCd == "1") {
                            item.title += item.empInfo;
                        }
                    } else if (item.schType == "deptSch") {
                        item.backgroundColor = deptColor;
                    } else {
                        item.backgroundColor = compColor;
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
        }

        // 캘린더 랜더링
        function initializeFullCalendarWithData(data) {
            console.log("calendar data : ", data);

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
                initialView: "dayGridMonth", // 초기 로드 될 때 보이는 캘린더 화면 (기본 설정 : 달)
                navLinks: true, // 날짜를 선택하면 Day 캘린더나 Week 캘린더로 링크
                editable: true, // 수정 가능
                selectable: true, // 달력 일자 드래그 설정 가능
                droppable: true, // 드래그 앤 드롭
                events: data,
                locale: "ko", // 한국어 설정

                // 일정 클릭하면 일정 상세 모달 표시
                eventClick: function (info) {
                    showSchDetail(info);
                },

                // 캘린더에서 클릭 또는 드래그로 일정 등록 모달 표시
                select: function (info) {
                    console.log("clicked info : ", info);

                    let calendarType = info.view.type;
                    let endStr = "";
                    if (calendarType == "dayGridMonth") {
                        endStr = formatEDate(info.end);
                    } else {
                        endStr = info.endStr;
                    }
                    // 모달 초기화
                    document.getElementById("selectSch").value = "1";
                    document.getElementById("schName").value = "";
                    document.getElementById("schSDate").value = info.startStr;
                    document.getElementById("schSTime").value = "08:00";
                    document.getElementById("schEDate").value = endStr;
                    document.getElementById("schETime").value = "08:00";
                    document.getElementById("schLoc").value = "";
                    document.getElementById("schCont").value = "";
                    document.getElementById("schModal").classList.add("open");
                },
            });
            calendar.render();
        }

        // 캘린더에 표시할 일정 불러서 캘린더 랜더링
        function getAndInitializeSchedule() {
            getScheduleList().done(function (data) {
                initializeFullCalendarWithData(data);
            });
        }

        // 데이터 가져오기
        function getData() {
            const schForm = document.querySelector("#schForm");
            let data = serializeSchVO(schForm);

            // Validation
            let schSDate = data.schSDate;
            let schSTime = data.schSTime;
            let schEDate = data.schEDate;
            let schETime = data.schETime;

            if (schSDate > schEDate) {
                alert(_msg.reservation.formDateErrorAlert);
                return false;
            }

            if (schSDate == schEDate && schETime <= schSTime && !$("#allDay").is(":checked")) {
                alert(_msg.reservation.formTimeErrorAlert);
                return false;
            }

            // 일시로 포맷
            let schStart = schSDate + " " + schSTime;
            let schEnd = schEDate + " " + schETime;

            // 포맷한 데이터 추가, 삭제
            delete data.schSDate;
            delete data.schSTime;
            delete data.schEDate;
            delete data.schETime;

            data.schdulBeginDate = schStart;
            data.schdulEndDate = schEnd;
            data.empNo = empNo;

            return data;
        }

        // 일정 상세 모달 불러오기
        function showSchDetail(info) {
            console.log("Event clicked:", info);
            schdulNo = info.event._def.extendedProps.schNo;

            // 일정 불러와서 모달에 추가
            $.ajax({
                url: `/api/schedule/\${schdulNo}`,
                type: "GET",
                dataType: "json",
                success: function (data) {
                    console.log(data);
                    let schdulSeCd = data.schdulSeCd;
                    // 등록자 정보 불러와서 표시
                    getEmpInfo(data.empNo, function (empInfo) {
                        let empNm = empInfo.empNm;
                        let position = empInfo.position;
                        let rspnsblCtgryNm = empInfo.rspnsblCtgryNm;
                        if (rspnsblCtgryNm != "팀원") {
                            position = rspnsblCtgryNm;
                        }
                        $("#schEmpName").val(`\${empNm} \${position}`);
                        $("#schEmpNameBox").css("display", "block");
                    });

                    // 일정 등록자가 다른 사람인 경우
                    if (empNo != data.empNo) {
                        $("#updateBtn").prop("disabled", true);
                        $("#deleteBtn").prop("disabled", true);
                    }

                    // 데이터 값 폼에 채우기
                    let schSDateNtime = data.schdulBeginDate;
                    let schEDateNtime = data.schdulEndDate;

                    $("#selectSch").val(schdulSeCd);
                    $("#schName").val(data.schdulSj);
                    $("#schSDate").val(schSDateNtime.substr(0, 10));
                    $("#schSTime").val(schSDateNtime.substr(11, 5));
                    $("#schEDate").val(schEDateNtime.substr(0, 10));
                    $("#schETime").val(schEDateNtime.substr(11, 5));

                    $("#schLoc").val(data.schdulLoc);
                    $("#schCont").val(data.schdulCn);

                    let allDayCd = data.allDayCd;
                    if (allDayCd == "1") {
                        $("#allDay").prop("checked", true);
                        $("#schSTime").prop("disabled", true);
                        $("#schETime").prop("disabled", true);
                        $("#schSTime").val("");
                        $("#schETime").val("");
                    }
                },
            });

            // 일정 상세 모달로 바꾸기
            $("#modalTit").text("일정 상세");
            $("#createBtnGroup").css("display", "none");
            $("#updateBtnGroup").css("display", "block");

            // 모달 열기
            $("#schModal").addClass("open");
        } // 일정 상세 모달 불러오기 끝

        // 특정 일정 불러오기
        function getSchedule(schdulNo) {
            $.ajax({
                url: `/api/schedule/\${schdulNo}`,
                type: "GET",
                dataType: "json",
                success: function (data) {
                    console.log(data);
                    let schdulSeCd = data.schdulSeCd;
                    if (schdulSeCd == "1") {
                        // 일정이 팀원 일정인 경우
                        if (empNo != data.empNo) {
                            schTypeStr = "teamSch";
                            $("#schEmpName").val(data.empNo);
                            $("#schEmpNameBox").css("display", "block");
                            $("#updateBtn").prop("disabled", true);
                            $("#deleteBtn").prop("disabled", true);
                        }
                    }

                    // 데이터 값 폼에 채우기
                    $("#selectSch").val(schdulSeCd);
                    $("#schName").val(data.schdulSj);

                    let schSDateNtime = data.schdulBeginDate;
                    let schEDateNtime = data.schdulEndDate;

                    $("#schSDate").val(schSDateNtime.substr(0, 10));
                    $("#schSTime").val(schSDateNtime.substr(11, 5));
                    $("#schEDate").val(schEDateNtime.substr(0, 10));
                    $("#schETime").val(schEDateNtime.substr(11, 5));

                    $("#schLoc").val(data.schdulLoc);
                    $("#schCont").val(data.schdulCn);
                },
            });
        }

        // 일정 등록
        function createEvent(data) {
            console.log("create data : ", data);
            $.ajax({
                url: "/api/schedule",
                type: "post",
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
                        getAndInitializeSchedule();

                        // 알림 출력
                        Toast.fire({
                            icon: "success",
                            title: _msg.common.insertSuccessAlert,
                        });
                    } else {
                        Toast.fire({
                            icon: "success",
                            title: _msg.common.insertFailAlert,
                        });
                    }
                },
            });
        } // 일정 등록 끝

        // 일정 수정
        function updateEvent(data, schdulNo) {
            console.log("update data : ", data);
            $.ajax({
                url: `/api/schedule/\${schdulNo}`,
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
                        // 캘린더에 반영
                        getAndInitializeSchedule();

                        // 알림 출력
                        Toast.fire({
                            icon: "success",
                            title: _msg.common.updateSuccessAlert,
                        });
                    } else {
                        Toast.fire({
                            icon: "success",
                            title: _msg.common.updateFailAlert,
                        });
                    }
                },
            });
        } // 일정 수정 끝

        // 일정 삭제
        function deleteEvent(schdulNo) {
            console.log("delete schdulNo : ", schdulNo);
            // 삭제 확인창 표시
            Swal.fire({
                title: _msg.common.deleteConfirm,
                showDenyButton: true,
                confirmButtonText: "삭제",
                denyButtonText: `취소`,
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        url: `/api/schedule/\${schdulNo}`,
                        type: "DELETE",
                        dataType: "text",
                        beforeSend: function (xhr) {
                            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                        },
                        success: function (rslt) {
                            console.log("delete : ", rslt);

                            if (rslt == "success") {
                                // 캘린더에 반영
                                getAndInitializeSchedule();

                                // 알림 출력
                                Toast.fire({
                                    icon: "success",
                                    title: _msg.common.deleteSuccessAlert,
                                });
                            } else {
                                Toast.fire({
                                    icon: "info",
                                    title: _msg.common.deleteFailAlert,
                                });
                            }
                        },
                    });
                } else if (result.isDenied) {
                    Toast.fire({
                        icon: "info",
                        title: _msg.common.deleteFailAlert,
                    });
                }
            });
        } // 일정 등록 끝
    });
</script>

<!--------------------------------- body 시작 --------------------------------->
<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
    <h1 class="page-tit">일정</h1>
    <div class="side-util">
        <button type="button" class="btn2" id="createBtn">일정 등록</button>
    </div>
</div>
<div class="wf-content-wrap">
    <div class="wf-flex-box">
        <div class="wf-content-area" id="calctgrbox" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
            <ul class="checkbox-radio-custom category-ul">
                <li class="category-li">
                    <div class="wf-flex-box">
                        <input type="checkbox" class="chkSch" id="mySch" checked />
                        <label for="mySch">내 일정 </label>
                        <span class="circle" id="mySchCircle"></span>
                    </div>
                </li>
                <li class="category-li">
                    <div class="wf-flex-box">
                        <input type="checkbox" class="chkSch" id="teamSch" />
                        <label for="teamSch">팀 일정</label>
                        <span class="circle" id="teamSchCircle"></span>
                    </div>
                </li>
                <li class="category-li">
                    <div class="wf-flex-box">
                        <input type="checkbox" class="chkSch" id="deptSch" />
                        <label for="deptSch">본부 일정</label>
                        <span class="circle" id="deptSchCircle"></span>
                    </div>
                </li>
                <li class="category-li">
                    <div class="wf-flex-box">
                        <input type="checkbox" class="chkSch" id="compSch" />
                        <label for="compSch">회사 일정</label>
                        <span class="circle" id="compSchCircle"></span>
                    </div>
                </li>
            </ul>
        </div>
        <div class="wf-content-area" id="calbox" data-aos="fade-right" data-aos-duration="700" data-aos-delay="400">
            <div id="calendar"></div>
        </div>
    </div>
</div>
<!--------------------------------- body 끝 --------------------------------->

<!--------------------------------- 일정 등록/수정 모달 시작 --------------------------------->
<div class="modal" id="schModal">
    <div class="modal-cont">
        <h1 class="modal-tit" id="modalTit">일정 등록</h1>
        <div class="modal-content-area">
            <form id="schForm">
                <ul class="wf-insert-form2 vertical">
                    <li>
                        <label for="selectSch">일정 종류<i class="i">*</i></label>
                        <div>
                            <div class="wf-select-group">
                                <select name="schdulSeCd" id="selectSch" required>
                                    <option value="1">내 일정</option>
                                    <option value="2">팀 일정</option>
                                    <option value="3">본부 일정</option>
                                    <option value="4">회사 일정</option>
                                </select>
                            </div>
                        </div>
                    </li>
                    <li id="schEmpNameBox">
                        <label for="schEmpName">등록자</label>
                        <div>
                            <input type="text" name="schEmpName" id="schEmpName" />
                        </div>
                    </li>
                    <li>
                        <label for="schName">일정명<i class="i">*</i></label>
                        <div>
                            <input type="text" name="schdulSj" id="schName" placeholder="일정명 필수입력" required />
                        </div>
                    </li>
                    <li>
                        <label for="cc">일시<i class="i">*</i></label>
                        <div class="wf-flex-box">
                            <input type="date" name="schSDate" id="schSDate" required />
                            <div class="wf-select-group">
                                <select name="schSTime" id="schSTime" required>
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
                            <input type="date" name="schEDate" id="schEDate" required />
                            <div class="wf-select-group">
                                <select name="schETime" id="schETime" required>
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
                            <span class="checkbox-radio-custom">
                                <input type="checkbox" name="allDayCd" id="allDay" value="1" />
                                <label for="allDay">종일</label>
                            </span>
                        </div>
                    </li>
                    <li>
                        <label for="schLoc">장소</label>
                        <div>
                            <input type="text" name="schdulLoc" id="schLoc" placeholder="장소입력" />
                        </div>
                    </li>
                    <li>
                        <label for="schCont">상세 내용</label>
                        <div>
                            <textarea name="schdulCn" id="schCont" placeholder="상세내용"></textarea>
                        </div>
                    </li>
                </ul>
            </form>
        </div>

        <div class="modal-btn-wrap" id="createBtnGroup">
            <button class="btn5" id="autoComplete">자동완성</button>
            <button type="submit" form="schForm" class="btn2" id="createConfBtn">등록</button>
        </div>

        <div class="modal-btn-wrap" id="updateBtnGroup">
            <button class="btn3" id="deleteBtn">삭제</button>
            <button type="submit" form="schForm" class="btn4" id="updateBtn">수정</button>
        </div>

        <button class="close-btn" id="schModalCloseBtn"></button>
    </div>
</div>
<!--------------------------------- 일정 등록/수정 모달 끝 --------------------------------->
