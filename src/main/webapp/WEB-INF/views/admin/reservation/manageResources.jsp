<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- CSS -->
<link href="${pageContext.request.contextPath}/resources/css/reservation/adminResources_style.css" rel="stylesheet" />
<!-- Javascript -->
<script src="${pageContext.request.contextPath}/resources/script/common/commonForSchAndRsv.js" defer></script>
<script>
    $(function () {
        // 회의실 목록 불러오기
        getMtrList();

        // 회의실 탭 클릭하면 회의실 목록 불러오기
        $("#mtrListBtn").on("click", function () {
            getMtrList();
            $("#createMtrBtn").css("display", "block");
            $("#createCarBtn").css("display", "none");
        });

        // 차량 탭 클릭하면 차량 목록 불러오기
        $("#carListBtn").on("click", function () {
            getCarList();
            $("#createCarBtn").css("display", "block");
            $("#createMtrBtn").css("display", "none");
        });

        // 회의실 추가 버튼 클릭하면 모달열기
        $("#createMtrBtn").on("click", function () {
            document.querySelector("#mtrForm").reset();

            $.ajax({
                url: "/admin/mtrNo",
                type: "GET",
                dataType: "text",
                success: function (mtrNo) {
                    console.log("max mtrNo : ", mtrNo);
                    $("#mtrNo").val(mtrNo);
                },
            });

            $("#mtrModalTit").text("회의실 등록");
            $("#updateMtrBtnGroup").css("display", "none");
            $("#createMtrBtnGroup").css("display", "block");
            $("#mtrModal").addClass("open");
        });

        // 차량 추가 버튼 클릭하면 모달열기
        $("#createCarBtn").on("click", function () {
            document.querySelector("#carForm").reset();

            $("#carModalTit").text("차량 등록");
            $("#updateCarBtnGroup").css("display", "none");
            $("#createCarBtnGroup").css("display", "block");
            $("#carModal").addClass("open");
        });

        // 회의실 폼 제출 버튼 눌렀을 때 등록 또는 수정
        $("#mtrForm").on("submit", function () {
            event.preventDefault();

            let mtrForm = document.querySelector("#mtrForm");
            let formData = new FormData(mtrForm);

            console.log("button clicked : ", formData);

            if (formData) {
                let buttonId = event.submitter.id;
                if (buttonId == "createMtrConfBtn") {
                    if (!validateFileExtension(formData)) {
                        return;
                    }
                    createMtr(formData);
                } else if (buttonId == "updateMtrBtn") {
                    if (!formData.get("uploadFile").size) {
                        formData.delete("uploadFile");
                    } else {
                        if (!validateFileExtension(formData)) {
                            return;
                        }
                    }
                    updateMtr(formData);
                }

                $("#mtrModal").removeClass("open");
            }
        });

        // 차량 폼 제출 버튼 눌렀을 때 등록 또는 수정
        $("#carForm").on("submit", function () {
            event.preventDefault();

            let carForm = document.querySelector("#carForm");
            let formData = new FormData(carForm);

            if (formData) {
                let buttonId = event.submitter.id;
                if (buttonId == "createCarConfBtn") {
                    if (!validateFileExtension(formData)) {
                        return;
                    }
                    createCar(formData);
                } else if (buttonId == "updateCarBtn") {
                    if (!formData.get("uploadFile").size) {
                        formData.delete("uploadFile");
                    } else {
                        if (!validateFileExtension(formData)) {
                            return;
                        }
                    }
                    updateCar(formData);
                }

                $("#carModal").removeClass("open");
            }
        });

        // 회의실 삭제 버튼 누르면
        $("#deleteMtrBtn").on("click", function () {
            let mtrNo = $("#mtrNo").val();
            $("#mtrModal").removeClass("open");
            deleteMtr(mtrNo);
        });

        // 차량 삭제 버튼 누르면
        $("#deleteCarBtn").on("click", function () {
            let carNo = $("#carNo").val();
            $("#carModal").removeClass("open");
            deleteCar(carNo);
        });

        // 자동 완성
        $("#mtrAutoComplete").on("click", function () {
            $("#mtrNm").val("대회의실");
            $("#mtrLoc").val("403호");
            $("#aceptblNmpr").val(40);
            $("#projector").prop("checked", true);
            $("#whiteboard").prop("checked", true);
            $("#microphone").prop("checked", true);
            $("#radio1").prop("checked", true);
        });

        // 자동 완성
        $("#carAutoComplete").on("click", function () {
            $("#carNm").val("아반떼");
            $("#carNo").val("532허1222");
            $("#radio3").prop("checked", true);
        });
    });

    // 회의실 목록 불러오기
    function getMtrList() {
        $.ajax({
            url: "/admin/mtrs",
            type: "GET",
            dataType: "json",
            success: function (mtrs) {
                console.log("mtrs : ", mtrs);
                $("#mtrBody").empty();
                if (!mtrs.length) {
                    let rowStr = `<tr>
                                    <td colspan="6" style="text-align:center;">
                                        <p>회의실이 없습니다.</p>
                                    </td>
                                </tr>`;
                    $("#mtrBody").append(rowStr);
                } else {
                    $.each(mtrs, function (index, mtr) {
                        let rowStr = "";
                        let itemStr = "";
                        mtr.mtrEquipedList.forEach(function (item) {
                            if (item.equipYnCd == 0) {
                                return;
                            }
                            let itemType = item.eqpmnNo;

                            if (itemType == 1) {
                                itemStr += `<p><i class="xi-projector" style="font-size:30px;"></i> 프로젝터</p>`;
                            } else if (itemType == 2) {
                                itemStr += `<p><i class="xi-laptop" style="font-size:30px;"></i> 화이트보드</p>`;
                            } else if (itemType == 3) {
                                itemStr += `<p><i class="xi-keyboard-o" style="font-size:30px;"></i> 컴퓨터</p>`;
                            } else {
                                itemStr += `<p><i class="xi-microphone" style="font-size:30px;"></i> 마이크</p>`;
                            }
                        });

                        let useCd = mtr.usePosblYnCd;
                        let useStr = "";
                        if (useCd == 1) {
                            useStr = "Y";
                        } else {
                            useStr = "N";
                        }

                        rowStr += ` <tr>
                                        <td>
                                            <p>\${index+1}</p>
                                        </td>
                                        <td>
                                            <p>\${mtr.mtrNm}</p>
                                        </td>
                                        <td>
                                            <p>\${mtr.mtrLoc}</p>
                                        </td>
                                        <td>
                                            <p>\${mtr.aceptblNmpr}명</p>
                                        </td>
                                        <td>
                                            \${itemStr}
                                        </td>
                                        <td>
                                            <p><img src='\${_storage}\${mtr.photoUrl}' style='width:200px'/></p>
                                        </td>
                                        <td>
                                            <p>\${useStr}</p>
                                        </td>
                                        <td>
                                            <p>
                                                <button type="button" class="btn4 listUdtMtrBtn" data-id="\${mtr.mtrNo}">수정</button>
                                                <button type="button" class="btn3 listDelMtrBtn" data-id="\${mtr.mtrNo}">삭제</button>
                                            </p>
                                        </td>
                                    </tr>`;
                        $("#mtrBody").append(rowStr);
                    });

                    $(".listUdtMtrBtn").on("click", function (e) {
                        mtrNo = e.target.dataset.id;

                        // 예약 불러와서 모달 열기
                        getMtrAndOpenModal(mtrNo);
                    });

                    $(".listDelMtrBtn").on("click", function (e) {
                        mtrNo = e.target.dataset.id;

                        deleteMtr(mtrNo);
                    });
                }
            },
        });
    }

    // 차량 목록 불러오기
    function getCarList() {
        $.ajax({
            url: "/admin/cars",
            type: "GET",
            dataType: "json",
            success: function (cars) {
                console.log("cars : ", cars);
                $("#carBody").empty();
                if (cars.length == 0) {
                    let rowStr = `<tr>
                                    <td colspan="6" style="text-align:center;">
                                        <p>보유한 차량이 없습니다.</p>
                                    </td>
                                </tr>`;
                    $("#carBody").append(rowStr);
                } else {
                    $.each(cars, function (index, car) {
                        let rowStr = "";
                        let useCd = car.carUsePosblYnCd;
                        let useStr = "";
                        if (useCd == 1) {
                            useStr = "Y";
                        } else {
                            useStr = "N";
                        }
                        rowStr += ` <tr>
                                        <td>
                                            <p>\${index+1}</p>
                                        </td>
                                        <td>
                                            <p>\${car.carNm}</p>
                                        </td>
                                        <td>
                                            <p>\${car.carNo}</p>
                                        </td>
                                        <td>
                                            <p><img src='\${_storage}\${car.photoUrl}' style='width:200px'/></p>
                                        </td>
                                        <td>
                                            <p>\${useStr}</p>
                                        </td>
                                        <td>
                                            <p>
                                                <button type="button" class="btn4 listUdtCarBtn" data-id="\${car.carNo}">수정</button>
                                                <button type="button" class="btn3 listDelCarBtn" data-id="\${car.carNo}">삭제</button>
                                            </p>
                                        </td>
                                    </tr>`;
                        $("#carBody").append(rowStr);
                    });
                    $(".listUdtCarBtn").on("click", function (e) {
                        carNo = e.target.dataset.id;
                        getCarAndOpenModal(carNo);
                    });

                    $(".listDelCarBtn").on("click", function (e) {
                        carNo = e.target.dataset.id;
                        deleteCar(carNo);
                    });
                }
            },
        });
    }

    // 회의실 추가
    function createMtr(data) {
        console.log("create data : ", data);

        $.ajax({
            url: "/admin/mtr",
            type: "POST",
            data: data, // multipart/form-data는 직렬화를 할 수 없음 왱? JSON문자열이 아니기 때문
            // contentType:"multipart/form-data,
            // FormData는 무조건 multipart/form-data 형식, 그래서 따로 contentType 지정 없음
            dataType: "text", // 받아서 JSON.parse
            contentType: false, // 하지망  defalt 하지마
            processData: false, // 하지말라공, {aaa:ppp,bbb:qqq}
            beforeSend: function (xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function (rslt) {
                console.log("create : ", rslt);
                getMtrList();

                // 알림 출력
                Toast.fire({
                    icon: "success",
                    title: _msg.common.insertSuccessAlert,
                });
            },
        });
    }

    // 차량 추가
    function createCar(data) {
        console.log("create data : ", data);

        $.ajax({
            url: "/admin/car",
            type: "POST",
            data: data,
            contentType: false,
            processData: false,
            dataType: "text", // 받아서 JSON.parse
            beforeSend: function (xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function (rslt) {
                console.log("create : ", rslt);
                getCarList();

                // 알림 출력
                Toast.fire({
                    icon: "success",
                    title: _msg.common.insertSuccessAlert,
                });
            },
        });
    }

    // 회의실 수정 모달 열기
    function getMtrAndOpenModal(mtrNo) {
        console.log("mtrNo : ", mtrNo);
        $.ajax({
            url: `/admin/mtr/\${mtrNo}`,
            type: "get",
            dataType: "json",
            success: function (data) {
                console.log("mtrInfo : ", data);

                document.querySelector("#mtrForm").reset();

                $("#mtrNo").val(data.mtrNo);
                $("#mtrNm").val(data.mtrNm);
                $("#mtrLoc").val(data.mtrLoc);
                $("#aceptblNmpr").val(data.aceptblNmpr);

                data.mtrEquipedList.forEach(function (item) {
                    if (item.equipYnCd == 0) {
                        return;
                    }
                    let itemType = item.eqpmnNo;

                    if (itemType == 1) {
                        $("#projector").prop("checked", true);
                    } else if (itemType == 2) {
                        $("#whiteboard").prop("checked", true);
                    } else if (itemType == 3) {
                        $("#computer").prop("checked", true);
                    } else {
                        $("#microphone").prop("checked", true);
                    }
                });

                let useCd = data.usePosblYnCd;
                if (useCd == "1") {
                    $("#radio1").prop("checked", true);
                } else {
                    $("#radio2").prop("checked", true);
                }
            },
        });

        $("#mtrModalTit").text("회의실 수정");
        $("#createMtrBtnGroup").css("display", "none");
        $("#updateMtrBtnGroup").css("display", "block");
        $("#mtrModal").addClass("open");
    }

    // 차량 수정 모달 열기
    function getCarAndOpenModal(carNo) {
        console.log("carNo : ", carNo);
        $.ajax({
            url: `/admin/car/\${carNo}`,
            type: "get",
            dataType: "json",
            success: function (data) {
                console.log("carInfo : ", data);

                document.querySelector("#carForm").reset();

                $("#carNm").val(data.carNm);
                $("#carNo").val(data.carNo);

                let useCd = data.carUsePosblYnCd;
                if (useCd == "1") {
                    $("#radio3").prop("checked", true);
                } else {
                    $("#radio4").prop("checked", true);
                }
            },
        });

        $("#carModalTit").text("차량 수정");
        $("#createCarBtnGroup").css("display", "none");
        $("#updateCarBtnGroup").css("display", "block");
        $("#carModal").addClass("open");
    }

    // 차량 수정
    function updateMtr(data) {
        console.log("update data : ", data);

        $.ajax({
            url: "/admin/mtr",
            type: "PUT",
            data: data,
            contentType: false,
            processData: false,
            dataType: "text", // 받아서 JSON.parse
            beforeSend: function (xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function (rslt) {
                console.log("update : ", rslt);

                if (rslt == "success") {
                    Toast.fire({
                        icon: "success",
                        title: _msg.common.updateSuccessAlert,
                    });
                    getMtrList();
                } else {
                    Toast.fire({
                        icon: "info",
                        title: _msg.common.updateFailAlert,
                    });
                }
            },
        });
    }

    // 차량 수정
    function updateCar(data) {
        console.log("update data : ", data);

        $.ajax({
            url: "/admin/car",
            type: "PUT",
            data: data,
            contentType: false,
            processData: false,
            dataType: "text", // 받아서 JSON.parse
            beforeSend: function (xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function (rslt) {
                console.log("update : ", rslt);

                if (rslt == "success") {
                    Toast.fire({
                        icon: "success",
                        title: _msg.common.updateSuccessAlert,
                    });
                    getCarList();
                } else {
                    Toast.fire({
                        icon: "info",
                        title: _msg.common.updateFailAlert,
                    });
                }
            },
        });
    }

    // 회의실 삭제
    function deleteMtr(mtrNo) {
        console.log("delete mtrNo : ", mtrNo);
        // 삭제 확인창 표시
        Swal.fire({
            title: _msg.common.deleteConfirm,
            showDenyButton: true,
            denyButtonText: `취소`,
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: `/admin/mtr/\${mtrNo}`,
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
                                title: _msg.common.deleteSuccessAlert,
                            });
                            getMtrList();
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
    } // 회의실 삭제 끝

    // 차량 삭제
    function deleteCar(carNo) {
        console.log("delete carNo : ", carNo);
        // 삭제 확인창 표시
        Swal.fire({
            title: _msg.common.deleteConfirm,
            showDenyButton: true,
            denyButtonText: `취소`,
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: `/admin/car/\${carNo}`,
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
                                title: _msg.common.deleteSuccessAlert,
                            });
                            getCarList();
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
    } // 차량 삭제 끝

    // 파일의 확장자 확인
    function validateFileExtension(data) {
        let fileName = data.get("uploadFile").name;
        console.log(fileName);
        let fileParts = fileName.split(".");
        let fileExtension = fileParts[fileParts.length - 1].toLowerCase();

        if (fileExtension !== "jpg" && fileExtension !== "jpeg" && fileExtension !== "png") {
            alert("이미지 파일만 업로드 가능합니다.");
            return false;
        }
        return true;
    }
</script>
<!--------------------------------- body 시작 --------------------------------->
<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
    <h1 class="page-tit">시설/자원 관리</h1>
    <div class="side-util">
        <button type="button" class="btn2" id="createMtrBtn">회의실 등록</button>
        <button type="button" class="btn2" id="createCarBtn">차량 등록</button>
    </div>
</div>
<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
    <div class="tab-type tab-type2">
        <div class="tab-menu">
            <!-- "active"가 추가되면 메뉴가 활성화됩니다. -->
            <button data-tab="tab1" type="button" class="tab-btn active" id="mtrListBtn">회의실</button>
            <button data-tab="tab2" type="button" class="tab-btn" id="carListBtn">차량</button>
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
                            <col style="width: 15%" />
                            <col style="width: 20%" />
                            <col style="width: 10%" />
                            <col style="width: 20%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>종류</th>
                                <th>위치</th>
                                <th>수용가능인원</th>
                                <th>보유장비</th>
                                <th>사진</th>
                                <th>사용가능여부</th>
                                <th>변경</th>
                            </tr>
                        </thead>
                        <tbody id="mtrBody"></tbody>
                    </table>
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
                            <col style="width: 10%" />
                            <col style="width: 10%" />
                            <col style="width: 30%" />
                            <col style="width: 20%" />
                            <col style="width: 20%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>차량명</th>
                                <th>차량번호</th>
                                <th>사진</th>
                                <th>사용가능여부</th>
                                <th>변경</th>
                            </tr>
                        </thead>
                        <tbody id="carBody"></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<!--------------------------------- body 끝 --------------------------------->

<!--------------------------------- 회의실 등록/수정 모달 시작 --------------------------------->
<div class="modal" id="mtrModal">
    <div class="modal-cont">
        <h1 class="modal-tit" id="mtrModalTit">회의실 등록</h1>
        <div class="modal-content-area">
            <form id="mtrForm" enctype="multipart/form-data">
                <ul class="wf-insert-form2 vertical">
                    <li id="mtrNoBox">
                        <label for="mtrNo">회의실 번호</label>
                        <div>
                            <input type="text" name="mtrNo" id="mtrNo" value="" readonly />
                        </div>
                    </li>
                    <li>
                        <label for="mtrNm">회의실 종류<i class="i">*</i></label>
                        <div>
                            <input type="text" name="mtrNm" id="mtrNm" placeholder="소회의실, 중회의실, 대회의실" required />
                        </div>
                    </li>
                    <li>
                        <label for="mtrLoc">회의실 호수<i class="i">*</i></label>
                        <div>
                            <input type="text" name="mtrLoc" id="mtrLoc" placeholder="회의실 호수" required />
                        </div>
                    </li>
                    <li>
                        <label for="aceptblNmpr">수용 가능 인원<i class="i">*</i></label>
                        <div>
                            <input type="number" name="aceptblNmpr" id="aceptblNmpr" required />
                        </div>
                    </li>
                    <li>
                        <label for="gg">비품 목록</label>
                        <div>
                            <ul class="checkbox-radio-custom">
                                <li>
                                    <input type="checkbox" name="equipments[]" id="projector" value="1" />
                                    <label for="projector">프로젝터</label>
                                </li>
                                <li>
                                    <input type="checkbox" name="equipments[]" id="whiteboard" value="2" />
                                    <label for="whiteboard">화이트보드</label>
                                </li>
                                <li>
                                    <input type="checkbox" name="equipments[]" id="computer" value="3" />
                                    <label for="computer">컴퓨터</label>
                                </li>
                                <li>
                                    <input type="checkbox" name="equipments[]" id="microphone" value="4" />
                                    <label for="microphone">마이크</label>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li>
                        <label for="mtrPhotoUrl">회의실 이미지<i class="i">*</i></label>
                        <div>
                            <input type="file" name="uploadFile" id="mtrPhotoUrl" />
                        </div>
                    </li>
                    <li>
                        <label for="gg">사용가능여부<i class="i">*</i></label>
                        <div>
                            <ul class="checkbox-radio-custom">
                                <li>
                                    <input type="radio" name="usePosblYnCd" id="radio1" value="1" />
                                    <label for="radio1">Y</label>
                                </li>
                                <li>
                                    <input type="radio" name="usePosblYnCd" id="radio2" value="0" />
                                    <label for="radio2">N</label>
                                </li>
                            </ul>
                        </div>
                    </li>
                </ul>
            </form>
        </div>

        <div class="modal-btn-wrap" id="createMtrBtnGroup">
            <button class="btn5" id="mtrAutoComplete">자동완성</button>
            <button type="submit" form="mtrForm" class="btn2" id="createMtrConfBtn">등록</button>
        </div>
        <div class="modal-btn-wrap" id="updateMtrBtnGroup">
            <button class="btn3" id="deleteMtrBtn">삭제</button>
            <button type="submit" form="mtrForm" class="btn4" id="updateMtrBtn">수정</button>
        </div>
        <button class="close-btn"></button>
    </div>
</div>
<!--------------------------------- 회의실 등록/수정 모달 끝 --------------------------------->

<!--------------------------------- 차량 등록/수정 모달 시작 --------------------------------->
<div class="modal" id="carModal">
    <div class="modal-cont">
        <h1 class="modal-tit" id="carModalTit">차량 등록</h1>
        <div class="modal-content-area">
            <form id="carForm" enctype="multipart/form-data">
                <ul class="wf-insert-form2 vertical">
                    <li>
                        <label for="cc">차량명<i class="i">*</i></label>
                        <div>
                            <input type="text" name="carNm" id="carNm" placeholder="자동차 모델을 입력하세요." required />
                        </div>
                    </li>
                    <li>
                        <label for="cc">차량번호<i class="i">*</i></label>
                        <div>
                            <input type="text" name="carNo" id="carNo" placeholder="차량 번호를 입력해주세요." required />
                        </div>
                    </li>
                    <li>
                        <label for="cc">차량 이미지<i class="i">*</i></label>
                        <div>
                            <input type="file" id="carPhotoUrl" name="uploadFile" />
                        </div>
                    </li>
                    <li>
                        <label for="radio3">사용가능여부<i class="i">*</i></label>
                        <div>
                            <ul class="checkbox-radio-custom">
                                <li>
                                    <input type="radio" name="carUsePosblYnCd" id="radio3" value="1" />
                                    <label for="radio3">Y</label>
                                </li>
                                <li>
                                    <input type="radio" name="carUsePosblYnCd" id="radio4" value="0" />
                                    <label for="radio4">N</label>
                                </li>
                            </ul>
                        </div>
                    </li>
                </ul>
            </form>
        </div>

        <div class="modal-btn-wrap" id="createCarBtnGroup">
            <button class="btn5" id="carAutoComplete">자동완성</button>
            <button type="submit" form="carForm" class="btn2" id="createCarConfBtn">등록</button>
        </div>
        <div class="modal-btn-wrap" id="updateCarBtnGroup">
            <button class="btn3" id="deleteCarBtn">삭제</button>
            <button type="submit" form="carForm" class="btn4" id="updateCarBtn">수정</button>
        </div>
        <button class="close-btn"></button>
    </div>
</div>
<!--------------------------------- 차량 등록/수정 모달 끝 --------------------------------->
