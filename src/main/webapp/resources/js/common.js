_storage = "https://projectawsimg.s3.ap-northeast-2.amazonaws.com/img/";

$(function () {
    // AOS 초기화
    AOS.init();

    // gradient (stripe-gradient)
    // new Gradient({
    //     canvas: "#gradient",
    //     colors: ["#80FFDB", "#64DFDF", "#48BFE3", "#5E60CE"],
    // });

    $("#gradient").gradient({
        colors: ["#80FFDB", "#64DFDF", "#48BFE3", "#5E60CE"],
    });


    // leftside-navigation
    $("#leftside-navigation .sub-menu > a").click(function (e) {
        //e.preventDefault();

        let $depth2 = $(this).next(".depth2");
        let $subMenu = $(this).parent(".sub-menu");

        $(".depth2").not($depth2).slideUp(200);
        $depth2.slideToggle(200);

        $(".sub-menu").not($subMenu).removeClass("open");
        $subMenu.toggleClass("open");
    });

    // 메뉴 active
    const url = window.location.pathname;
    $("#leftside-navigation a").each(function () {
        const linkHref = $(this).attr("href");

        if (linkHref === url) {
            $(this).parent().addClass("active");
            $(this).closest(".sub-menu").addClass("open").find(".depth2").show();
            return false;
        }
    });

    // wf-menu-dropdown
    $(document).on("click", function (event) {
        var $target = $(event.target);
        if (!$target.closest(".wf-util").length) {
            $(".wf-util > li").removeClass("wf-menu-open");
        }
    });

    $(".wf-util > li > a").on("click", function (event) {
        event.stopPropagation(); // 클릭 이벤트 전파 중지
        $(".wf-util > li").not($(this).parent()).removeClass("wf-menu-open");
        $(this).parent().toggleClass("wf-menu-open");
    });

    // Tab
    const tabContainers = $(".tab-type");

    tabContainers.each(function () {
        const container = $(this);
        const tabButtons = container.find(".tab-btn");
        const tabContents = container.find(".tab-content");
        const tabIndicator = container.find(".tab-indicator");
        const numTabs = tabButtons.length;
        let activeTabIndex = 0;

        function showTab(tabIndex) {
            if (tabIndex === activeTabIndex) {
                return;
            }
            tabButtons.removeClass("active");
            tabContents.removeClass("active");
            tabButtons.eq(tabIndex).addClass("active");
            tabContents.eq(tabIndex).addClass("active");
            activeTabIndex = tabIndex;

            const activeButton = tabButtons.eq(tabIndex);
            const buttonRect = activeButton[0].getBoundingClientRect();
            const tabIndicatorWidth = buttonRect.width;
            const tabIndicatorOffset = buttonRect.left - activeButton.parent()[0].getBoundingClientRect().left;
            tabIndicator.css({ width: `${tabIndicatorWidth}px`, transform: `translateX(${tabIndicatorOffset}px)` });
        }

        tabButtons.each(function (index) {
            $(this).click(function () {
                showTab(index);
            });
        });

        showTab(0);
    });

    // modal
    $("[modal-id]").click(modal);

    // modal close
    $(".modal .close-btn").click(function () {
        $(this).parents(".modal").removeClass("open");
        $("html").removeClass("scroll-hidden");
    });

    // ck-editors (Initial)
    const editors = document.querySelectorAll(".editor");
    editors.forEach((editor) => {
        ClassicEditor.create(editor).catch((error) => {
            console.error(error);
        });
    });
});

// modal
function modal() {
    let id = $(this).attr("modal-id");
    $(".modal")
        .removeClass("open")
        .filter("#" + id)
        .addClass("open");
    $("html").addClass("scroll-hidden");
}


// sweetalert toast 알림
const Toast = Swal.mixin({
    toast: true,
    position: "top-end",
    showConfirmButton: false,
    timer: 2000,
    didOpen: (toast) => {
        toast.onmouseenter = Swal.stopTimer;
        toast.onmouseleave = Swal.resumeTimer;
    },
});

function downloadFile(param) {
    // AWS S3 URL 설정
    const s3Url = _storage + param;
    // 버튼 클릭 시 파일 다운로드
    const a = document.createElement("a");
    a.href = s3Url;
    a.download = param; // 다운로드될 파일 이름

    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
}
