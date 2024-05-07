$(function () {

    getDraftToRewrite();

});

// 재기안
function getDraftToRewrite() {

    let apvNo = location.search.slice(7);

    $.ajax({
        url: `${_ctx}/approval/reWrite?apvNo=` + apvNo,
        type: 'get',
        dataType: 'json',
        success: (result) => {
            result.forEach((e) => {
                $("#docFormNo").val(e.docFormNo);
                $('#tit').val(e.apvSj);
                $('#cont').text(e.apvCn);
            });
        }
    });
}