$(function () {
    let jsPDF = jspdf.jsPDF;

    // pdf download
    $("#pdf_btn").on("click", function () {
        html2canvas($('#htmlContainer')[0]).then(function (canvas) {
            var imgData = canvas.toDataURL('image/png');
            var imgWidth = 210;
            var pageHeight = imgWidth * 1.414;
            var imgHeight = parseInt(canvas.height * imgWidth / canvas.width);
            var heightLeft = imgHeight;
            var margin = 0;

            var doc = new jsPDF('p', 'mm', 'a4');
            var position = 0;

            // 첫 페이지 출력
            doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
            heightLeft -= pageHeight;

            // 페이지가 더 있을 경우 루프 돌면서 출력
            while (heightLeft >= 0) {
                position = heightLeft - imgHeight;
                doc.addPage();
                doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
                heightLeft -= pageHeight;
            }

            doc.save('문서양식.pdf');
        });
    });

    // PDF 다운로드 후 Blob URL 생성 및 프리뷰에 바인딩
    function createBlobUrl(doc) {
        let blobPDF = new Blob(
            [doc.output('blob')],
            { type: 'application/pdf' }
        );

        // Blob URL 생성
        let blobUrl = window.URL.createObjectURL(blobPDF); // 서버에 저장할 url

        // iframe에 url 바인딩
        $('#pdf_preview').attr('src', blobUrl);
    }
});