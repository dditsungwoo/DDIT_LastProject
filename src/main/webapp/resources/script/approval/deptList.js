let _pagination;
$(function () {

    _pagination = new Pagination({
        search: {
            SEARCH_TYPE: {
                target: $('#SEARCH_TYPE'),
            },
            SEARCH_VALUE: {
                target: $('#SEARCH_VALUE'),
            }
        },
        pagination: {
            rowSize: 10,
            pageListTarget: $('ul#PAGINAION'),
            onClickAll: createTable,
        },
    });

    createTable();

    $('input#SEARCH_VALUE').keypress(function (e) {
        if (e.keyCode === 13) createTable();
    });

    // 검색 버튼 클릭 
    $('button#SEARCH_BTN').click(createTable);

});

function createTable() {

    let tbody = $('#deptTbody');
    let param = _pagination.getParameter();
    console.log("param->", param);

    $.ajax({
        url: `${_ctx}/approval/deptListView/list`,
        type: 'get',
        data: param,
        dataType: 'json',
        success: (result) => {
            console.log("부서문서함 -> ", result);
            tbody.empty();

            let html = _HTML.deptList.tr(param);

            let { LIST, PAGE, ROWSIZE } = result; // Changed 'data' to 'result'

            if (Array.isArray(LIST)) {
                LIST.forEach((e, i) => {

                    let tr = _HTML.deptList.tr({
                        docName: _HTML.msg.docNm[e.docFormNo],
                        ...e
                    });
                    tbody.append(tr);
                });
            } else {
                tbody.append(_HTML.myList.noData());
            }

            // pagination 세팅
            _pagination.setPage(parseInt(result.PAGE)).setRowCount(result.ROWCOUNT).makePagination(); // Changed 'data' to 'result'
        }
    });
}


// 페이지네이션, 검색 적용 전 test
/*$(function () {
    createTable();
});

function createTable() {
    let tbody = $('#deptTbody');
    $.ajax({
        url: `${_ctx}/approval/deptListView/list`,
        type: 'get',
        dataType: 'json',
        success: (data) => {
            console.log("부서문서함 -> ", data);
            tbody.empty();


            if (Array.isArray(data) && data.length > 0) {
                data.forEach((e, i) => {

                    let tr = _HTML.deptList.tr({
                        docName: _HTML.msg.docNm[e.docFormNo],
                        ...e
                    });
                    tbody.append(tr);
                });
            } else {
                tbody.append(_HTML.myList.noData());
            }

        }
    });
}*/