let myYChart = "";
let myPositionYChart = "";
let myDeptYChart = "";

let myChart = "";
let myAgeChart = "";
let myRetireChart = "";

let myGenderChart = "";
let myLocationChart = "";
let myStateChart = "";
let paramYear = "";
paramYear = "2024";
let deptDetailNo = "DEPT01";
function drawAgeChart(chartDiv, chartLabels, chartData) {
    const ctx = document.getElementById(chartDiv);

    myAgeChart = new Chart(ctx, {
        type: "bar",
        data: {
            labels: chartLabels,
            datasets: [
                {
                    label: "사원 수",
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
            plugins: {
                legend: {
                    display: false, // 범례 숨기기
                },
            },
            maintainAspectRatio: false,
        },
    });
}

function drawLocationChart(chartDiv, chartLabels, chartData) {
    const ctx = document.getElementById(chartDiv);

    myLocationChart = new Chart(ctx, {
        type: "bar",
        data: {
            labels: chartLabels,
            datasets: [
                {
                    axis: "y",
                    label: "사원 수",
                    data: chartData,
                    borderWidth: 1,
                },
            ],
        },
        options: {
            indexAxis: "y",
            scales: {
                x: {
                    beginAtZero: true,
                    min: 0,
                },
            },
            plugins: {
                legend: {
                    display: false, // 범례 숨기기
                },
            },
            maintainAspectRatio: false,
        },
    });
}

function drawRetireChart(chartDiv, chartLabels, chartData) {
    const ctx = document.getElementById(chartDiv);

    myRetireChart = new Chart(ctx, {
        type: "bar",
        data: {
            labels: chartLabels,
            datasets: [
                {
                    label: "사원 수",
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
            plugins: {
                legend: {
                    display: false, // 범례 숨기기
                },
            },
            maintainAspectRatio: false,
        },
    });
}

function drawYChart(chartDiv, chartLabels, chartData) {
    const ctx = document.getElementById(chartDiv);

    myYChart = new Chart(ctx, {
        type: "bar",
        data: {
            labels: chartLabels,
            datasets: [
                {
                    axis: "y",
                    label: "사원 수",
                    data: chartData,
                    borderWidth: 1,
                },
            ],
        },
        options: {
            indexAxis: "y",
            scales: {
                x: {
                    beginAtZero: true,
                    min: 0,
                },
            },
            plugins: {
                legend: {
                    display: false, // 범례 숨기기
                },
            },
            maintainAspectRatio: false,
        },
    });
}

function drawDeptYChart(chartDiv, chartLabels, chartData) {
    const ctx = document.getElementById(chartDiv);

    myDeptYChart = new Chart(ctx, {
        type: "bar",
        data: {
            labels: chartLabels,
            datasets: [
                {
                    axis: "y",
                    label: "사원 수",
                    data: chartData,
                    borderWidth: 1,
                },
            ],
        },
        options: {
            indexAxis: "y",
            scales: {
                x: {
                    beginAtZero: true,
                    min: 0,
                },
            },
            plugins: {
                legend: {
                    display: false, // 범례 숨기기
                },
            },
            maintainAspectRatio: false,
        },
    });
}

function drawPositionYChart(chartDiv, chartLabels, chartData) {
    const ctx = document.getElementById(chartDiv);

    myPositionYChart = new Chart(ctx, {
        type: "bar",
        data: {
            labels: chartLabels,
            datasets: [
                {
                    label: "사원 수",
                    data: chartData,
                    borderWidth: 1,
                },
            ],
        },
        options: {
            scales: {
                x: {
                    beginAtZero: true,
                },
            },
            plugins: {
                legend: {
                    display: false, // 범례 숨기기
                },
            },
            maintainAspectRatio: false,
        },
    });
}

function drawDoughnutChart(chartDiv, chartLabels, chartData) {
    const ctx = document.getElementById(chartDiv);

    myGenderChart = new Chart(ctx, {
        type: "doughnut",
        data: {
            datasets: [
                {
                    data: chartData,
                    backgroundColor: ["rgb(54, 162, 235)", "rgb(255, 99, 132)"],
                    hoverOffset: 4,
                },
            ],
        },
        options: {
            legend: {
                display: false, // 레전드 표시 여부 설정
            },
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            let label = context.label || "";

                            if (label) {
                                label += ": ";
                            }
                            console.log("context:");
                            if (context.dataset.data[context.dataIndex] !== null) {
                                label += context.dataset.data[context.dataIndex] + "%";
                            }
                            return label;
                        },
                    },
                },
            },
            maintainAspectRatio: false,
        },
    });
}

function drawStateChart(chartDiv, chartLabels, chartData) {
    const ctx = document.getElementById(chartDiv);

    myStateChart = new Chart(ctx, {
        type: "doughnut",
        data: {
            labels: chartLabels,
            datasets: [
                {
                    label: chartLabels,
                    data: chartData,
                    hoverOffset: 4,
                },
            ],
        },
        options: {
            responsive: true, // 차트가 반응형으로 크기를 조절하도록 설정합니다.
            maintainAspectRatio: false, // 차트의 종횡비를 유지하지 않고 부모 요소에 맞추도록 설정합니다.
            plugins: {
                legend: {
                    position: "top", // 'top', 'bottom', 'left', 'right' 중 선택
                },
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            let label = context.label || "";

                            if (label) {
                                label += ": ";
                            }
                            console.log("context:");
                            if (context.dataset.data[context.dataIndex] !== null) {
                                label += context.dataset.data[context.dataIndex];
                            }
                            return label;
                        },
                    },
                },
                maintainAspectRatio: false,
            },
        },
    });
}

function empStatics(paramYear) {
    $(function () {
        // 나이 분포 그래프
        let ageData = [];
        let ageLabels = ["21-25", "26-30", "31-35", "36-40", "41-45", "46-50", "50+"];
        $.ajax({
            url: "/adminEmp/getAgeGraph",
            data: { year: paramYear },
            type: "get",
            success: function (res) {
                ageData = res;

                if (myAgeChart && myAgeChart.data.labels) {
                    newLabels = ageLabels;
                    newData = ageData;

                    myAgeChart.data.labels = newLabels;
                    // 기존 차트의 데이터를 업데이트
                    myAgeChart.data.datasets[0].data = newData; // 새로운 데이터로 업데이트
                    // 차트 업데이트
                    myAgeChart.update();
                } else {
                    drawAgeChart("myChart", ageLabels, ageData);
                }
            },
        });

        // 평균 나이
        $.ajax({
            url: "/adminEmp/getAvgAge",
            data: { year: paramYear },
            type: "get",
            success: function (res) {
                $(".avgage").html(res);
            },
        });

        // 사원 수
        $.ajax({
            url: "/adminEmp/getEmpCount",
            data: { year: paramYear },
            type: "get",
            success: function (res) {
                $(".allEmpCount").html(res);
            },
        });

        // 남녀 성비
        $.ajax({
            url: "/adminEmp/getGenderRate",
            data: { year: paramYear },
            type: "get",
            success: function (res) {
                let genderLabels = ["Male", "Female"];
                let genderData = [];

                let maleCount = res[0];
                let femaleCount = res[1];

                // 소수2번째자리에서 끊어서 100%가 안되는것 때문에 그냥 100에서 한쪽값을 빼는거로...
                let maleRate = parseInt((maleCount / (maleCount + femaleCount)) * 10000) / 100;
                let femaleRate = parseInt((femaleCount / (maleCount + femaleCount)) * 10000) / 100;

                genderData = [maleRate, femaleRate];

                $(".maleRate").html(maleCount);
                $(".femaleRate").html(femaleCount);

                if (myGenderChart && myGenderChart.data.labels) {
                    newLabels = genderLabels;
                    newData = genderData;

                    // 기존 차트의 데이터를 업데이트
                    myGenderChart.data.datasets[0].data = newData; // 새로운 데이터로 업데이트
                    // 차트 업데이트
                    myGenderChart.update();
                } else {
                    drawDoughnutChart("genderChart", genderLabels, genderData);
                }
            },
        });

        // 퇴사자 수, 퇴사자 유형별 수
        $.ajax({
            url: "/adminEmp/getRetireCount",
            data: { year: paramYear },
            type: "get",
            success: function (res) {
                let sumCount = res[0] + res[1];
                // 정년퇴직자
                let retire1 = res[0];
                // 그냥퇴직자
                let retire2 = res[1];

                $(".retireCount").html(sumCount);
                $(".retire1").html(retire1);
                $(".retire2").html(retire2);
            },
        });

        // 고용자 수
        $.ajax({
            url: "/adminEmp/getHireCount",
            data: { year: paramYear },
            type: "get",
            success: function (res) {
                $(".hireCount").html(res);
            },
        });

        let deptDetail = [];
        let deptDetailData = [];

        // deptNo 매개변수로 주고 불러오면 해당 부서의 하위부서들 그래프
        function getDeptDetailGraph(deptDetailNo) {
            deptDetail = [];
            deptDetailData = [];

            $.ajax({
                url: "/adminEmp/getDeptName",
                data: { year: paramYear },
                type: "get",
                success: function (res) {
                    $.each(res, function (i, v) {
                        if (v.deptNo.substr(0, 6) == deptDetailNo) {
                            deptDetail.push(v.deptNm);
                        }
                    });

                    $.ajax({
                        url: "/adminEmp/getDeptCount",
                        data: {
                            year: paramYear,
                        },
                        type: "get",
                        success: function (res) {
                            $.each(res, function (i, v) {
                                let deptNo = v.split("_")[0];
                                let empCount = parseInt(v.split("_")[1]);

                                if (deptNo.substr(0, 6) == deptDetailNo) {
                                    deptDetailData.push(empCount);
                                }
                            });

                            // 차트가 없으면 새로 생성, 차트가 있으면 업데이트
                            if (myYChart && myYChart.data.labels[0].substr(-2, 2) == "본부") {
                                newLabels = deptDetail;
                                newData = deptDetailData;

                                myYChart.data.labels = newLabels;
                                // 기존 차트의 데이터를 업데이트
                                myYChart.data.datasets[0].data = newData; // 새로운 데이터로 업데이트
                                // 차트 업데이트
                                myYChart.update();
                            } else {
                                drawYChart("deptDetailChart", deptDetail, deptDetailData);
                            }
                        },
                    });
                },
            });
        }

        // 상위부서들 차트
        $.ajax({
            url: "/adminEmp/getDeptCount",
            data: { year: paramYear },
            type: "get",
            success: function (res) {
                // 이것을 데이터 베이스에서 가져오려면 부서분류가 필요할듯함
                let deptChartLabels = ["기획", "경영", "영업", "마케팅", "개발"];
                let deptChartData = [];
                let dept01 = 0;
                let dept02 = 0;
                let dept03 = 0;
                let dept04 = 0;
                let dept05 = 0;

                $.each(res, function (i, v) {
                    let deptNo = v.split("_")[0];
                    let empCount = parseInt(v.split("_")[1]);

                    if (deptNo.substr(0, 6) == "DEPT01") {
                        dept01 += empCount;
                    }
                    if (deptNo.substr(0, 6) == "DEPT02") {
                        dept02 += empCount;
                    }
                    if (deptNo.substr(0, 6) == "DEPT03") {
                        dept03 += empCount;
                    }
                    if (deptNo.substr(0, 6) == "DEPT04") {
                        dept04 += empCount;
                    }
                    if (deptNo.substr(0, 6) == "DEPT05") {
                        dept05 += empCount;
                    }
                });

                deptChartData.push(dept01);
                deptChartData.push(dept02);
                deptChartData.push(dept03);
                deptChartData.push(dept04);
                deptChartData.push(dept05);

                // 차트가 없으면 새로 생성, 차트가 있으면 업데이트
                if (myDeptYChart && myDeptYChart.data.labels) {
                    newLabels = deptChartLabels;
                    newData = deptChartData;

                    myDeptYChart.data.labels = newLabels;
                    // 기존 차트의 데이터를 업데이트
                    myDeptYChart.data.datasets[0].data = newData; // 새로운 데이터로 업데이트
                    // 차트 업데이트
                    myDeptYChart.update();
                } else {
                    drawDeptYChart("deptChart", deptChartLabels, deptChartData);
                }
            },
        });
        /*
		$.ajax({
			url:"/adminEmp/getRetireRate",
			data:{"year":paramYear},
			type:"get",
			success:function(res){
				console.log("getRetireRate:",res)
				
				let chartLabels = ["01","02","03","04","05","06","07","08","09","10","11","12"]
				let chartData = res
				
				if (myRetireChart && myRetireChart.data.labels) { 
					
					newLabels = chartLabels
					newData = chartData
					
					myRetireChart.data.labels = newLabels
			        // 기존 차트의 데이터를 업데이트
				    myRetireChart.data.datasets[0].data = newData; // 새로운 데이터로 업데이트
			        // 차트 업데이트
			        myRetireChart.update();
			        
			    }else{
			    	drawRetireChart("retireChart",chartLabels,chartData)
			    	myRetireChart.data.datasets[0].label = "퇴사율(%)"
					myRetireChart.update()
			    }
			    
			}
		})
		*/
        $.ajax({
            url: "/adminEmp/getYearRetireRate",
            data: { year: paramYear },
            type: "get",
            success: function (res) {
                $(".retire3").html(res + "%");
            },
        });

        $.ajax({
            url: "/adminEmp/getLoaclCount",
            data: { year: paramYear },
            type: "get",
            success: function (res) {
                let chartLabels = [];
                let chartData = [];

                $.each(res, function (i, v) {
                    chartLabels.push(v.workLocation);
                    chartData.push(v.count);
                });

                if (myLocationChart && myLocationChart.data.labels) {
                    newLabels = chartLabels;
                    newData = chartData;

                    myLocationChart.data.labels = newLabels;
                    // 기존 차트의 데이터를 업데이트
                    myLocationChart.data.datasets[0].data = newData; // 새로운 데이터로 업데이트
                    // 차트 업데이트
                    myLocationChart.update();
                } else {
                    drawLocationChart("localChart", chartLabels, chartData);
                }
            },
        });

        $.ajax({
            url: "/adminEmp/getWorkerCount",
            data: { year: paramYear },
            type: "get",
            success: function (res) {
                let chartLabels = [];
                let chartData = [];

                $.each(res, function (i, v) {
                    chartLabels.push(v.workState);
                    chartData.push(v.count);
                });

                if (myStateChart && myStateChart.data.labels) {
                    newLabels = chartLabels;
                    newData = chartData;

                    myStateChart.data.labels = newLabels;
                    // 기존 차트의 데이터를 업데이트
                    myStateChart.data.datasets[0].data = newData; // 새로운 데이터로 업데이트
                    // 차트 업데이트
                    myStateChart.update();
                } else {
                    drawStateChart("workerChart", chartLabels, chartData);
                }
            },
        });

        $.ajax({
            url: "/adminEmp/getPositionGraph",
            data: { year: paramYear },
            type: "get",
            success: function (res) {
                let chartLabels = [];
                let chartData = [];

                console.log("res:", res);
                $.each(res, function (i, v) {
                    chartLabels.push(v.position);
                    chartData.push(v.count);
                });

                if (myPositionYChart && myPositionYChart.data.labels) {
                    console.log("myPositionYChart.data.labels:", myPositionYChart.data.labels);
                    newLabels = chartLabels;
                    newData = chartData;

                    myPositionYChart.data.labels = newLabels;
                    // 기존 차트의 데이터를 업데이트
                    myPositionYChart.data.datasets[0].data = newData; // 새로운 데이터로 업데이트
                    // 차트 업데이트
                    myPositionYChart.update();
                } else {
                    drawPositionYChart("positionChart", chartLabels, chartData);
                }
            },
        });

        // 첫 화면 디폴트로 dept01 부서의 하위부서 그래프
        getDeptDetailGraph(deptDetailNo);

        $("#deptSelect").on("change", function () {
            deptDetailNo = $(this).val();

            getDeptDetailGraph(deptDetailNo);
        });
    });
}

empStatics(paramYear);
$(function () {
    $(".yearClassify").on("click", function () {
        paramYear = $(this).find("p").text();
        empStatics(paramYear);

        $(".yearClassify").css("background", "#F8FFF8");
        $(this).css("background", "#00a287");
        $(".yearClassify").css("color", "#333");
        $(this).css("color", "#fff");
    });
});
