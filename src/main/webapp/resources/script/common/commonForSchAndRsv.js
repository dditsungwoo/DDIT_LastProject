// 캘린더에서 일정 등록할 때 종료일 포맷
function formatEDate(dateString) {
    let date = new Date(dateString);

    date.setDate(date.getDate() - 1);

    let year = date.getFullYear();
    let month = ("0" + (date.getMonth() + 1)).slice(-2); // 월을 0부터 시작하기 때문에 1을 더하고, 앞에 0을 붙여 두 자리로
    let day = ("0" + date.getDate()).slice(-2); // 날짜를 두 자리로
    return year + "-" + month + "-" + day;
}

// 회원 정보 가져오기
function getEmpInfo(empNo, callback) {
    $.ajax({
        url: `/empInfo/${empNo}`,
        type: "GET",
        async: false,
        dataType: "json",
        success: function (empInfo) {
            callback(empInfo);
        },
    });
}

// 날짜 포맷
function formatDate(date) {
    const year = date.getFullYear();
    const month = ("0" + (date.getMonth() + 1)).slice(-2);
    const day = ("0" + date.getDate()).slice(-2);
    const dayOfWeek = ["일", "월", "화", "수", "목", "금", "토"][date.getDay()];

    return `${year}-${month}-${day}(${dayOfWeek})`;
}
