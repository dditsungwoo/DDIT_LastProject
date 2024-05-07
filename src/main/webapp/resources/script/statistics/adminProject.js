let paramYear = "2024";
let myMonthNewChart = "";
let myMonthEndChart = "";
let myPeriodChart = "";
let projVOList = [];
let listTarget = "";
let targetPjNo = "";
let targetEmpNo = "";
let targetDutySj = "";
let dutyCn = "";
let stage = "0";
let stage2YN = "N";
function drawMonthNewChart(chartDiv, chartLabels, chartData) {
    const ctx = document.getElementById(chartDiv);

    myMonthNewChart = new Chart(ctx, {
        type: "bar",
        data: {
            labels: chartLabels,
            datasets: [
                {
                    label: "프로젝트 수",
                    data: chartData,
                    borderWidth: 1,
                },
            ],
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                },
            },
            maintainAspectRatio: false,
        },
    });
}

function drawMonthEndChart(chartDiv, chartLabels, chartData) {
    const ctx = document.getElementById(chartDiv);

    myMonthEndChart = new Chart(ctx, {
        type: "bar",
        data: {
            labels: chartLabels,
            datasets: [
                {
                    label: "프로젝트 수",
                    data: chartData,
                    borderWidth: 1,
                },
            ],
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                },
            },
            maintainAspectRatio: false,
        },
    });
}

function drawPeriodChart(chartDiv, chartLabels, chartData) {
    const ctx = document.getElementById(chartDiv);

    myPeriodChart = new Chart(ctx, {
        type: "bar",
        data: {
            labels: chartLabels,
            datasets: [
                {
                    label: "프로젝트 수",
                    data: chartData,
                    borderWidth: 1,
                },
            ],
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                },
            },
            maintainAspectRatio: false,
        },
    });
}

function getMonthProjectData() {
    // 시작 프로젝트 수
    $.ajax({
        url: "/adminProject/getMonthNewProj",
        data: { year: paramYear },
        type: "get",
        success: function (res) {
            let chartLabels = [];
            let chartData = [];

            $.each(res, function (i, v) {
                chartLabels.push(v.split("_")[0]);
                chartData.push(v.split("_")[1]);
            });

            if (myMonthNewChart && myMonthNewChart.data.labels) {
                newLabels = chartLabels;
                newData = chartData;

                myMonthNewChart.data.labels = newLabels;
                // 기존 차트의 데이터를 업데이트
                myMonthNewChart.data.datasets[0].data = newData; // 새로운 데이터로 업데이트
                // 차트 업데이트
                myMonthNewChart.update();
            } else {
                drawMonthNewChart("monthNewProj", chartLabels, chartData);
            }
        },
    });

    // 종료 프로젝트 수
    $.ajax({
        url: "/adminProject/getMonthEndProj",
        data: { year: paramYear },
        type: "get",
        success: function (res) {
            let chartLabels = [];
            let chartData = [];

            $.each(res, function (i, v) {
                chartLabels.push(v.split("_")[0]);
                chartData.push(v.split("_")[1]);
            });

            if (myMonthEndChart && myMonthEndChart.data.labels) {
                newLabels = chartLabels;
                newData = chartData;

                myMonthEndChart.data.labels = newLabels;
                // 기존 차트의 데이터를 업데이트
                myMonthEndChart.data.datasets[0].data = newData; // 새로운 데이터로 업데이트
                // 차트 업데이트
                myMonthEndChart.update();
            } else {
                drawMonthEndChart("monthEndProj", chartLabels, chartData);
            }
        },
    });
}
// 처음에 프로젝트 테이블 데이터 가져오기
function getProjects() {
    $.ajax({
        url: "/adminProject/getProjects",
        data: "",
        type: "get",
        async: false,
        success: function (res) {
            let str = "";
            projVOList = res;
        },
    });
}

// 밑에 리스트 출력 데이터
function getList(sttusCd) {
    let strEnd = "";
    let str = "";
    $.each(projVOList, function (i, v) {
        if (v.prjctSttusCd == sttusCd) {
            if (v.prjctEndDate != null) {
                strEnd = `${v.prjctEndDate.substr(0, 4)}-${v.prjctEndDate.substr(4, 2)}-${v.prjctEndDate.substr(6, 2)}`;
            } else {
                strEnd = "---- -- --";
            }

            str += `<tr class="pjTr" style="display:table; width:1510px;">
		                <td style="width:20.2%;">
		                    <p class="pjNo">${v.prjctNo}</p>
		                </td>
		                <td style="width:20.2%;">
		                    <p class="pjNm">${v.prjctNm}</p>
		                </td>
		                <td style="width:20.2%;">
		                    <p class="pjDate">${v.prjctBeginDate.substr(0, 4)}-${v.prjctBeginDate.substr(4, 2)}-${v.prjctBeginDate.substr(6, 2)}~${strEnd}</p>
		                </td>
		                <td style="width:20.4%;">
		                    <p class="pjContent">${v.prjctDetailCn}</p>
		                </td>
		                <td style="width:19%;">
		                    <p class="pjEmp">${v.total}</p>
		                </td>
		            </tr>`;
        }
    });
    $(".pjList").html(str);
}

function getProjectEmp(pjNo) {
    $.ajax({
        url: "/adminProject/getProjectEmp",
        data: { prjctNo: pjNo },
        type: "get",
        success: function (res) {
            let str = "";
            let headStr = `<tr style="width: 360px;">
			                <th style="width: 120px;">부서</th>
			                <th style="width: 120px;">이름</th>
			                <th style="width: 120px;">역할</th>
			            </tr>`;
            $.each(res, function (i, v) {
                str += `<tr class="projectEmp" style="display:table; width:360px;">
			                <td style="width:120px;">
			                    <p>${v.deptNm}</p>
			                </td>
			                <td style="width:120px;">
			                    <p>${v.empNm}<span class="pjEmpTrEmpNo" style="display:none;">${v.empNo}</span></p>
			                </td>
			                <td style="width:120px;">
			                    <p>${v.position}</p>
			                </td>
			            </tr>`;
            });
			$(".theadList").html(headStr);
            $(".pjEmpList").html(str);
            $(".listBoxP").html("프로젝트 팀원");
        },
    });
}

function getEmpPjDuty(empNo) {
    $.ajax({
        url: "/adminProject/getEmpPjDuty",
        data: {
            prjctNo: targetPjNo,
            empNo: empNo,
        },
        type: "get",
        success: function (res) {
            let count = 0;
            let str = "";
            let colStr = `<colgroup>
					        <col style="width: 40%;">
							<col style="width: 20%;">
							<col style="width: 40%;">
				        </colgroup>`;

            let headStr = `<tr style="width: 360px;">
			                <th style="width: 130px;">업무</th>
			                <th style="width: 86px;">진행률</th>
			                <th style="width: 144px;">종료일</th>
			            </tr>`;
            $.each(res, function (i, v) {
                count += 1;
                str += `<tr class="empPjDuty" style="display:table; width:360px;">
			                <td style="width:135px;">
			                    <p><span class="dutySj">${v.dutySj}</span><span class="dutyCn" style="display:none">${v.detailCn}</span></p>
			                </td>
			                <td style="width:80px;">
			                    <p>${v.prgsRate * 10}%</p>
			                </td>
			                <td style="width:145px;">
			                    <p>${v.prjctEndDate.substr(0, 4)}-${v.prjctEndDate.substr(4, 2)}-${v.prjctEndDate.substr(6, 2)}</p>
			                </td>
			            </tr>`;
            });

            $(".colList").html(colStr);
            $(".theadList").html(headStr);
            $(".pjEmpList").html(str);
            $(".listBoxP").html(count + "개의 업무가 있습니다");
        },
    });
}

function getDutyCn() {
    let colStr = `<colgroup>
					<col style="width: 100%;">
				</colgroup>`;

    let headStr = `<tr style="width: 360px;">
					<th style="width: 360px;">내용</th>
				</tr>`;
    let str = `<tr style="width: 360px;">
				    <td style="width: 360px;">
				        <p>${dutyCn}</p>
				    </td>
				</tr>`;

    $(".colList").html(colStr);
    $(".theadList").html(headStr);
    $(".pjEmpList").html(str);
    $(".listBoxP").html(targetDutySj);
}

$(function () {
    getProjects();
    getList("1");
    // 프로젝트 수(대기중,진행중,완료,중단)
    $.ajax({
        url: "/adminProject/getProjectCount",
        data: "",
        type: "get",
        success: function (res) {
            let status = "";
            let count = 0;
            $.each(res, function (i, v) {
                status = v.split("_")[0];
                count = v.split("_")[1];

                $(".sttus" + status).html(count);
            });
        },
    });

    // 즉시 투입 가능 사원수
    $.ajax({
        url: "/adminProject/getEnableEmp",
        data: "",
        type: "get",
        success: function (res) {
            let count = res.length;
            $(".enableEmp").html(count);

            let strEmpNm = "";
            let strDeptNm = "";

            $.each(res, function (i, v) {
                strEmpNm += `<p class="heading2">${v.empNm}</p>`;
                strDeptNm += `<p class="heading2">${v.deptNm}</p>`;
            });

            $(".empNm").html(strEmpNm);
            $(".deptNm").html(strDeptNm);
        },
    });

    // 프로젝트 진행기간 그래프
    $.ajax({
        url: "/adminProject/getProceedPeriod",
        data: "",
        type: "get",
        success: function (res) {
            console.log("res:", res);
            let chartLabels = [];
            let chartData = [];

            $.each(res, function (i, v) {
                if (i == 4) {
                    chartLabels.push("60++");
                } else {
                    chartLabels.push(v.split("_")[0]);
                    chartData.push(v.split("_")[1]);
                }
            });

            if (myPeriodChart && myPeriodChart.data.labels) {
                newLabels = chartLabels;
                newData = chartData;

                myPeriodChart.data.labels = newLabels;
                // 기존 차트의 데이터를 업데이트
                myPeriodChart.data.datasets[0].data = newData; // 새로운 데이터로 업데이트
                // 차트 업데이트
                myPeriodChart.update();
            } else {
                drawPeriodChart("periodChart", chartLabels, chartData);
            }
        },
    });

    getMonthProjectData();

    $(".yearClassify").on("click", function () {
        paramYear = $(this).find("p").text();
        getMonthProjectData();
        $(".yearClassify").css("background", "#F8FFF8");
        $(this).css("background", "#00a287");
        $(".yearClassify").css("color", "#333");
        $(this).css("color", "#fff");
    });

    $(".moreInfo").on("click", function () {
        let sttus = $(this).attr("idx");
        $(".moreInfo").css("background", "var(--glass-bg)");
        $(this).css("background", "#00a287");
        $(".moreInfo").css("color", "#333");
        $(this).css("color", "#fff");
        
        $(".moreInfo").removeClass("active")
        $(this).addClass("active")
        
        
        getList(sttus);
        $(".targetPjState").html($(this).find(".pjState").text());
    });

    $(document).on("click", ".pjTr", function () {
        stage = "0";
        stage2YN = "N";
        let pjNo = $(this).find(".pjNo").html();
        targetPjNo = pjNo;
        getProjectEmp(targetPjNo);

        $(".nextBtn").prop("disabled", true);
        $(".prevBtn").prop("disabled", true);
    });

    $(document).on("click", ".projectEmp", function () {
        $(".pjEmpList tr").css("background", "var(--glass-bg)");
        $(this).css("background", "#00a287");
    });

    $(document).on("click", ".empPjDuty", function () {
        $(".pjEmpList tr").css("background", "var(--glass-bg)");
        $(this).css("background", "#00a287");
    });

    $(document).on("dblclick", ".projectEmp", function () {
        stage = "1";
        let empNo = $(this).find(".pjEmpTrEmpNo").html();
        targetEmpNo = empNo;
        getEmpPjDuty(empNo);

        $(".nextBtn").prop("disabled", true);
        $(".prevBtn").prop("disabled", false);
    });

    $(document).on("dblclick", ".empPjDuty", function () {
        targetDutySj = $(this).find(".dutySj").text();
        stage = "2";
        stage2YN = "Y";
        dutyCn = $(this).find(".dutyCn").html();
        getDutyCn();

        $(".nextBtn").prop("disabled", true);
        $(".prevBtn").prop("disabled", false);
    });

    $(".prevBtn").on("click", function () {
        if (stage == "1") {
            stage = "0";
            getProjectEmp(targetPjNo);
            $(".prevBtn").prop("disabled", true);
        }
        if (stage == "2") {
            stage = "1";
            getEmpPjDuty(targetEmpNo);
        }
        $(".nextBtn").prop("disabled", false);
    });

    $(".nextBtn").on("click", function () {
        if (stage == "1") {
            stage = "2";
            getDutyCn();
            $(".nextBtn").prop("disabled", true);
        }
        if (stage == "0") {
            stage = "1";
            getEmpPjDuty(targetEmpNo);
            if (stage2YN == "N") {
                $(".nextBtn").prop("disabled", true);
            }
        }
        $(".prevBtn").prop("disabled", false);
    });
});
