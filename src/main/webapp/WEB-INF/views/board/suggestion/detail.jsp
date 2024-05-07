<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
            $(() => {

                var detailEmpNo = "${suggestDetail.empNo}";
                console.log("detailEmpNo--> ", detailEmpNo);
                let rspnsblCd= "<%=session.getAttribute("rspnsblCtgryNm") %>";
                console.log("rspnsblCd--> ", rspnsblCd);
                
                //로그인한 session
                //var sessionEmpNo = <%=session.getAttribute("empNo") != null ? session.getAttribute("empNo") : "defaultValue"%>;
                var sessionEmpNo = <%=session.getAttribute("empNo")%>;
                console.log("sessionEmpNo--> ", sessionEmpNo);
                var sessionEmpNm = '<%=session.getAttribute("empNm")%>';
                console.log("sessionEmpNm -> ", sessionEmpNm);
                // 본인 게시글 수정 삭제 버튼
                if (detailEmpNo == sessionEmpNo) {
                    console.log("참");
                    document.getElementById("suggestUpdate").style.display = "block";
                    document.getElementById("suggestDelete").style.display = "block";
                } else {
                    console.log("거짓");
                }






                // 댓글 리스트
                function getList() {
                	let myPic= "${proflImageUrl}";
                    const sugestBrdNo = "${suggestDetail.sugestBrdNo}";
                    let data = {
                        sugestBrdNo: sugestBrdNo,
                    };
                    $.ajax({
                        url: "/suggestion/list/reply",
                        data: JSON.stringify(data),
                        contentType: "application/json;charset=utf-8",
                        type: "post",
                        beforeSend: function (xhr) {
                            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                        },
                        success: function (res) {
                            console.log("체크 getList result :", res);

                            let str = "";

                            res.forEach(function (item) {
                                str += "<div class='rere' id='rerere" + item.sugestBrdReNo + "'>";
                                str += "<li id='reply" + item.sugestBrdReNo + "'>";
                                str += "<div class='sug1'>";
                                str += "<div class='user-wrap'>";
                                str += "<span class='user-thumb'>";
                                str += "<img src='/resources/img/icon/"+item.proflImageUrl+"' alt='예시이미지'>";
                                str += "</span>";
                                str += "<div class='user-info'>";
                                str += "<div>";
                                str += "<div style='display:none;' class='sgtReplyNo' >" + item.sugestBrdReNo + "</div>";
                                str += "<span class='user-name'>" + item.empNm + "</span>";
                                str += "<span class='user-position'>" + item.cmmnCdNm + "</span>";
                                str += "</div>";
                                str += "<div>";
                                str += "<span class='user-team'>" + item.deptNm + "</span>";
                                str += "<span class='user-date'>" + item.writngDate + "</span>";
                                str += "</div>";
                                str += "</div>";
                                str += "<div class='user-btn'>";
                                str += "<button type='button' class='add-btn' data-re-empNo='" + item.empNo + "'  data-sugest-brd-re-no='" + item.sugestBrdReNo + "'";
                                if (sessionEmpNo != item.empNo) {
                                    str += "style ='display:none;' ";
                                }

                                str += ">";
                                str += "<i class='xi-pen'>";
                                str += "</i>";
                                str += "</button>";
                                str +=
                                    "<button type='button' id='deleteReply' data-re-empNo='" + item.empNo + "' ";
                                if (sessionEmpNo != item.empNo) {
                                    str += "style ='display:none;' ";
                                }
                                str += " class='del-btn' data-reply-no='" +
                                    item.sugestBrdReNo +
                                    "'>";
                                str += "<input type='hidden' id='replyNum' value='" + item.sugestBrdNo + "'/>";
                                str += "<i class='xi-trash'>";
                                str += "</i>";
                                str += "</button>";
                                str += "</div>";
                                str += "</div>";
                                str += "<div class='txt'>" + item.reSj + "</div>";

                                //str += "<input class='txtRe' type='text' style='display:none;' value='"+ item.reSj + "' />";

                                // 수정 시 나오는 등록
                                str += "<div class='input-wrap txtRe' style='display:none; align-items: center;'>";
                                str += "<br>";
                                str += "<br>";
                                str += "<input type='text'  value='" + item.reSj + "' >";
                                str += "<button class='btn4' data-sugest-brd-re-no='" + item.sugestBrdReNo + "' style='right'>수정</button>";
                                str += "<br>";
                                str += "</div>";
                                // 수정 끝

                                str += "</div>";


                                str += "<li class='reply' id='insRereply" + item.sugestBrdReNo + "' style='display:none;' >"; // 대댓글 내부 검색 창 시작
                                str += "<div class='input-wrap'>";
                                str += "<span class='user-thumb'>";
                                str += "<img src='/resources/img/icon/"+myPic+"' alt='예시이미지'>";
                                str += "</span>";
                                str += "<input type='text' placeholder='댓글을 입력하세요' class='sugReReplyInsert' id='sugReReplyInsert'>";
                                str += "<div>"
                                str += "<button class='btn4 replyRe' data-btn='" + item.sugestBrdReNo + "'   id='ReplyReInsert" + item.sugestBrdReNo + "'>등록</button>";
                                str += "</div>";
                                str += "</li>"; //끝
                                str += "</li>";
                                str += "<div>";
                                str +=
                                    "<button type ='button' data-re-no='" +
                                    item.sugestBrdReNo +
                                    "' class='reply-btn'>답글(" +
                                    item.upperReNum
                                    + ")</button> ";
                                str += "</div>";
                                str += "</div>";
                                str += "<br>";

                                $("#suggestReplyList").html(str);
                            });
                        },
                    });
                }
                getList();

                /* 
                                        $(document).on("click", ".reply-btn", function () {
                                            // 대댓글 창이 열려있는지 여부를 저장하는 변수
                                            $(this).data('isOpen',false); // isOpen 데이터 속성을 false로 설정
                                            let isOpen = $(this).data('isOpen'); // isOpen 데이터 속성의 값을 가져옴
                                            console.log("test -> ", isOpen); // false가 출력될 것입니다.
                    	
                                            //id 값 가져오기
                                            let liId = event.target.dataset.reNo;
                    	
                                            let sugestBrdReNo = $(this).data("reNo");
                                            let sugestBrdNo = $("#replyNum").val();
                    	
                                            let data = {
                                                "sugestBrdReNo": sugestBrdReNo,
                                                "sugestBrdNo": sugestBrdNo
                                            }
                                            $.ajax({
                                                url: "/suggestion/list/reply/Re",
                                                data: JSON.stringify(data),
                                                contentType: "application/json;charset=utf-8",
                                                type: "post",
                                                dataType: "json",
                                                beforeSend: function (xhr) {
                                                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                                                },
                                                success: function (res) {
                                                    console.log(this);
                                                    isOpen = $(this).data('isOpen'); // isOpen 데이터 속성의 값을 가져옴
                                                    console.log("isOpen -> ",isOpen);
                                                    console.log("result(res)-> : ", res);
                                                    let str = "";
                    	
                                                    if (isOpen == false) {
                                                        if (res.length == 1) {
                                                            console.log("inOpen ->" ,isOpen);
                                                            alert("대댓글 없음");
                                                        } else {
                                                            alert("대댓글 있음");
                                                            for (var i = 1; i < res.length; i++) {
                                                                console.log("for문 들어옴");
                                                                console.log(" 하나 뽑아보자", res[i].upperRe);
                    	
                                                                str += "<li class='reply'>";
                                                                str += "<div class='user-wrap'>";
                                                                str += "<span class='user-thumb'>";
                                                                str += "<img src='/img/icon/avatar.png' alt='예시이미지'>";
                                                                str += "</span>";
                                                                str += "<div class='user-info'>";
                                                                str += "<div>";
                                                                str += "<div style='display:none;' class='sgtReplyNoRe' >" + res[i].sugestBrdReNo + "</div>"
                                                                str += "<span class='user-name'>" + res[i].empNm + "</span>";
                                                                str += "<span class='user-position'>" + res[i].cmmnCdNm + "</span>";
                                                                str += "</div>";
                                                                str += "<div>";
                                                                str += "<span class='user-team'>" + res[i].deptNm + "</span>";
                                                                str += "<span class='user-date'>" + res[i].writngDate + "</span>";
                                                                str += "</div>";
                                                                str += "</div>";
                                                                str += "<div class='user-btn'>";
                                                                str += "<button type='button' class='add-btn'>";
                                                                str += "<i class='xi-pen'>";
                                                                str += "</i>";
                                                                str += "</button>";
                                                                str += "<input type='hidden' id='replyNum' value='" + res[i].sugestBrdNo + "'/>"
                                                                str += "<i class='xi-trash'>";
                                                                str += "</i>";
                                                                str += "</div>";
                                                                str += "</div>";
                                                                str += "<div class='txt'>" + res[i].reSj + "</div>";
                                                                str += "</li>";
                                                            }
                                                        }
                                                        str += "<li class='reply' id='insertRereply' >";
                                                        str += "<div class='input-wrap'>";
                                                        str += "<span class='user-thumb'>";
                                                        str += "<img src='/img/icon/avatar.png' alt='예시이미지'>";
                                                        str += "</span>";
                                                        str += "<input type='text' placeholder='댓글을 입력하세요' id='suggestReplyReInsert'>";
                                                        str += "<button class='btn4' id='Replycheck'>등록</button>";
                                                        str += "</div>";
                                                        str += "</li>";
                                                        $("#reply" + liId).append(str);
                    	
                                                        // 대댓글 창 열렸음을 표시
                                                        isOpen =$(this).data('isOpen', true); // isOpen 데이터 속성을 true로 설정
                                                        console.log("현재 상태 -> ",isOpen);
                                                    } else {
                                                        alert("대댓글 창 닫기");
                                                        // 대댓글 창 닫기
                                                	
                                                        $("#insertRereply").remove();
                                                        // 대댓글 창 닫혔음을 표시
                                                        $(this).data('isopen', false);
                                                    }
                                                    console("체크 -> " ,isOpen);
                                                }
                                            });
                                        });
                         */


                // 대댓글 리스트(버튼 클릭 시 댓글이 나오고 그거에 대한 입력 창 출력)
                $(document).on("click", ".reply-btn", function () {
                    //id 값 가져오기
                    let liId = event.target.dataset.reNo;

                    console.log("$$$$$$$", liId);
                    //$("#reply"+liId).html($("#reply"+liId).html()+"<input type=text value='민준바봉'>");



                    let sugestBrdReNo = $(this).data("reNo");
                    let sugestBrdNo = $("#replyNum").val();


                    let data = {
                        sugestBrdReNo: sugestBrdReNo,
                        sugestBrdNo: sugestBrdNo,
                    };

                    let spnLen = $("#spn" + liId).length;
                    console.log("spnLen : " + spnLen);

                    //1) 대댓글 입력 란 처리
                    $("#insRereply" + liId).toggle();

                    //2)
                    if (spnLen > 0) {
                        //대댓글이 있으면
                        $("#spn" + liId).remove();
                        return; // 요 밑은 실행 안함
                    }

                    $.ajax({
                        url: "/suggestion/list/reply/Re",
                        data: JSON.stringify(data),
                        contentType: "application/json;charset=utf-8",
                        type: "post",
                        dataType: "json",
                        beforeSend: function (xhr) {
                            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                        },
                        success: function (res) {
                            console.log(this);
                            console.log(res);

                            console.log("result(res)-> : ", res);
                            let str = `<span id='spn\${liId}'>`;
                            if (res.length == 1) {
                                console.log("대댓글이 없습니다.");
                            } else {
                                for (var i = 1; i < res.length; i++) {
                                    console.log(i);
                                    str += `
                                    <div id='replyRe'>
                                                <li class='reply' data-list-no='\${res.length}'>
                                                    <div class='user-wrap'>
                                                        <span class='user-thumb'>
                                                            <img src='/resources/img/icon/\${res[i].proflImageUrl}' alt='예시이미지'>
                                                        </span>
                                                        <div class='user-info'>
                                                            <div>
                                                                <div style='display:none;' class='sgtReplyNoRe' >\${res[i].sugestBrdReNo}</div>
                                                                <span class='user-name'>\${res[i].empNm}</span>
                                                                <span class='user-position'>\${res[i].cmmnCdNm}</span>
                                                            </div>
                                                            <div>
                                                                <span class='user-team'>\${res[i].deptNm}</span>
                                                                <span class='user-date'>\${res[i].writngDate}</span>
                                                            </div>
                                                        </div>
                                                        <div class='user-btn'>
                                                            <button type='button' class='add-btn-re'`;
                                    if (sessionEmpNo != res[i].empNo) { str += `style ='display:none;' `; }
                                    str += `data-re-empNo='\${res[i].empNo}' data-sugest-brd-re-no='\${res[i].sugestBrdReNo}'>
                                                                <i class='xi-pen'></i>
                                                            </button>
                                                            <input type='hidden' id='replyNum' value='\${res[i].sugestBrdNo}'/>
                                                            <input type='hidden' id='length' value='\${res.length}' />
                                                            <button type='button' id='deleteReply'  data-sugest-brd-re-no='\${res[i].sugestBrdReNo}' `;
                                    if (sessionEmpNo != res[i].empNo) { str += `style ='display:none;' `; }
                                    str += `class='del-re-btn'>
                                                                <i class='xi-trash'></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                    <div>
                                                        <div class='txt' id='txt\${res[i].sugestBrdReNo}'>\${res[i].reSj}</div>
                                                            <div class='input-wrap txtRe' style='display:none;'>
                                                            <br>
                                                            <br>
                                                            <input type='text'  value='\${res[i].reSj}' >
                                                            <button class='btn4' data-sugest-brd-re-no='\${res[i].sugestBrdReNo}' style='right'>수정</button>
                                                            <br>
                                                        </div>
                                                    <input type='text' style ='display:none;' class='txtRe1' value='\${res[i].reSj}' />
                                                    </div>
                                                </li>
                                            </div>`;
                                } //end for
                            } //end if
                            str += "</span>";
                            str += "<br>";
                            $("#reply" + liId).append(str);
                        },
                    });
                });
                ////////////////////////////////////////// 꼼꼼해야 손(눈도 집중) -> 머리에 생각 이 따라가야 하는 꼼꼼 (정답은 없엉! -> Refactoring)






                //댓글 수정
                $(document).on("click", ".add-btn", function () {

                    console.log("이벤트발생:", event.target);
                    console.log("부모  sug1", $(event.target).closest(".sug1"));
                    console.log(".txt", $(event.target).closest(".sug1").find(".txt"));


                    // DOM 검색을 잘해야 함, 검색이 잘 되게 하려면 레이아웃이 좋아야 함(부모 자식 관계)
                    // 
                    let $evtBtn = $(event.target);    // 이벤트 발생시킨 애
                    let $sug1 = $evtBtn.closest(".sug1"); // 이벤트 발생시킨 애 기준 가장 가까운 sug1 클래스를 가진애
                    let $txt = $sug1.find(".txt");   // 선택된 sug1 안에서 txt 클래스 가진 애 찾기
                    let $txtRe = $sug1.find(".txtRe");  //
                    console.log("$txt -> ", $txt);
                    console.log("$txtRe -> ", $txtRe);

                    //data-sugest-brd-re-no='"+res.sugestBrdReNo+"'
                    let sugestBrdReNo = $(this).data("sugestBrdReNo");
                    console.log("sugestBrdReNo --> ", sugestBrdReNo);
                    let th = $(this);
                    console.log(th);
                    /* var li = $(this).parents("li").find(".txt")[1];
                    console.log(li); */
                    var txtElement = $(this).closest('.sug1').find('.txt')[0];
                    console.log("txtElement->", txtElement);

                    console.log("체킁:", $(".txt"));  // 

                    $txt.toggle();
                    $txtRe.toggle();

                    $(document).on("click", ".btn4", function () {
                        let reSj = $(event.target).closest("div").find('input').val();
                        sugestBrdReNo = $(this).data("sugestBrdReNo");
                        console.log("reSj -> ", reSj);
                        console.log("sugestBrdReNo --> ", sugestBrdReNo);
                        let data = {
                            reSj: reSj,
                            sugestBrdReNo: sugestBrdReNo,
                        };
                        console.log("너가 구한것 1 ->", reSj);
                        console.log("너가 구한것 1 ->", sugestBrdReNo);

                        // ajax시작
                        // reSj , sugestBrdReNo
                        $.ajax({
                            url: "/suggestion/list/reply/update",
                            data: JSON.stringify(data),
                            contentType: "application/json;charset=utf-8",
                            type: "post",
                            dataType: "json",
                            beforeSend: function (xhr) {
                                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                            },
                            success: function (res) {
                                console.log(res);
                                location.reload();

                            },//end ajax



                        });


                    });

                });



                // 대댓글 삭제 핸들러
                $(document).on("click", ".del-re-btn", function () {
                    console.log("삭제버튼 누름");

                    let Area = $(event.target).closest('#replyRe');

                    let sugestBrdReNo = event.target.closest('#deleteReply').dataset.sugestBrdReNo;
                    console.log(sugestBrdReNo);

                    let data = {
                        sugestBrdReNo: sugestBrdReNo,
                    }
                    let ev = event.target;
                    let ccc = ev.closest('.rere');
                    console.log("cccc -> ", $(ccc).find('.reply-btn').text());
                    let sum = $(ccc).find('.reply-btn').text();
                    console.log("sum -> ", sum);

                    let numbers = sum.match(/\d+/);
                    let number = numbers ? numbers[0] : null;
                    console.log("숫자는 -> ", number);
                    number--;
                    $(ccc).find('.reply-btn').text("답글(" + number + ")");
                    $.ajax({
                        url: "/suggestion/list/reply/re/delete",
                        data: JSON.stringify(data),
                        contentType: "application/json;charset=utf-8",
                        type: "post",
                        dataType: "json",
                        beforeSend: function (xhr) {
                            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                        },
                        success: function (res) {
                            console.log(res);

                            Area.remove();
                        },


                    });





                });






                //대댓글 수정 핸들러
                $(document).on("click", ".add-btn-re", function () {
                    let txtElement = $(this).closest('li').find('.txt');
                    console.log("하위 댓글의 텍스트 요소:", txtElement.text());

                    let sugestBrdReNo = $(this).data("sugestBrdReNo");
                    console.log("this -> ", sugestBrdReNo);

                    console.log("reply --> ", $(event.target).closest('.reply').find('.txt'));
                    let text1 = $(event.target).closest('.reply');

                    let textArea = text1.find(".txt");
                    let inputArea = $(event.target).closest('.reply').find('.txtRe');

                    console.log("textArea -> ", textArea);
                    console.log("inputArea -> ", inputArea);

                    textArea.toggle();
                    inputArea.toggle();

                    $(document).on("click", ".btn4", function () {
                        console.log("sugestBrdReNo -> ", sugestBrdReNo);
                        let reSj = $(this).closest('div').find('input').val();
                        
                        sugestBrdReNo = $(this).data("sugestBrdReNo");
                        console.log("resj   ->", reSj);
                        
                        //alert("sugestBrdReNo : " + sugestBrdReNo + ", reSj : " + reSj);
                        
                        $("#txt"+sugestBrdReNo).html(reSj);
                        
                        let data = {
                            sugestBrdReNo: sugestBrdReNo,
                            reSj: reSj,
                        };
                        $.ajax({
                            url: "/suggestion/list/reply/update",
                            data: JSON.stringify(data),
                            contentType: "application/json;charset=utf-8",
                            type: "post",
                            dataType: "json",
                            beforeSend: function (xhr) {
                                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                            },
                            success: function (res) {
                                console.log(res);
                                inputArea.css("display", "none");
//                                 textArea.text(reSj);
                                textArea.css("display", "flex");
                            },
                        });

                    });


                });



                /////////대댓글 등록
                $(document).on("click", ".replyRe", function () {
                    console.log("클릭 댐");
                    let ev = event.target;
                    console.log("체크 -> ", ev);

                    //let reSj = (".sugReReplyInsert").val();
                    let off = ev.closest(".input-wrap");
                    let reSj = $(off).find(".sugReReplyInsert").val();
                    console.log("off -> ", off);
                    console.log("qqq -> ", reSj);
                    //console.log("reSj ->",reSj);
                    let sugestBrdNo = $("#replyNum").val();
                    console.log("sugestBrdNo : " + sugestBrdNo);
                    let sugestBrdReNo = event.target.dataset.btn;
                    console.log("sugestBrdReNo : " + sugestBrdReNo);

                    let span = $("#spn" + sugestBrdReNo);
                    let spa = document.getElementById("spn" + sugestBrdReNo);
                    console.log("span -> ", span);
                    console.log("spa -> ", spa);

                    let data = {
                        reSj: reSj,
                        sugestBrdReNo: sugestBrdReNo,
                        sugestBrdNo: sugestBrdNo,
                    };

                    let ccc = ev.closest('.rere');
                    console.log("cccc -> ", $(ccc).find('.reply-btn').text());
                    let sum = $(ccc).find('.reply-btn').text();
                    console.log("sum -> ", sum);

                    let numbers = sum.match(/\d+/);
                    let number = numbers ? numbers[0] : null;
                    console.log("숫자는 -> ", number);


                    //$(ccc).find('.reply-btn').text("수정");



                    // 입력 후 새로운 댓글 
                    $.ajax({
                        url: "/suggestion/list/reply/Re/insert",
                        data: JSON.stringify(data),
                        contentType: "application/json;charset=utf-8",
                        type: "post",
                        dataType: "json",
                        beforeSend: function (xhr) {
                            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                        },
                        success: function (res) {
                            console.log("res -> ", res);


                            number++;
                            $(ccc).find('.reply-btn').text("답글(" + number + ")");
                            let str = "<div id='replyRe'><li class='reply' data-list-no='12'><div class='user-wrap'><span class='user-thumb'><img src='/resources/img/icon/"+res.proflImageUrl+"' alt='예시이미지'></span><div class='user-info'><div><div style='display:none;' class='sgtReplyNoRe'>" + res.sugestBrdReNo + "</div><span class='user-name'>" + res.empNm + "</span><span class='user-position'>" + res.cmmnCdNm + "</span></div><div><span class='user-team'>" + res.deptNm + "</span><span class='user-date'>2024-03-20 16:46:51</span></div></div><div class='user-btn'><button type='button' class='add-btn-re' data-sugest-brd-re-no='" + res.sugestBrdReNo + "' ><i class='xi-pen'></i></button><input type='hidden' id='replyNum' value='83'><input type='hidden' id='length' value='12'>";
                            str += "<button type='button' id='deleteReply' data-sugest-brd-re-no='" + res.sugestBrdReNo + "' class='del-re-btn'>";
                            str += "<i class='xi-trash'></i>";
                            str += "</button>";
                            str += "</div></div>";
                            str += "<div class='txt'>" + res.reSj + "</div>";
                            str += "<div class='input-wrap txtRe' style='display:none; align-items: center;'>";
                            str += "<br>";
                            str += "<br>";
                            str += "<input type='text'  value='" + res.reSj + "' >";
                            str += "<button class='btn4' data-sugest-brd-re-no='" + res.sugestBrdReNo + "' style='right'>수정</button>";
                            str += "<br>";
                            str += "</div>";
                            str += "</li></div>";
                            console.log("str -> ", str);

                            $("#spn" + sugestBrdReNo).append(str);

                            // 	                        	span.append(str);
                            $(".sugReReplyInsert").val("");





                        },
                    });//end ajax 
                });









                // 댓글 삭제
                $(document).on("click", ".del-btn", function () {
                    let sugestBrdReNo = $(this).data("replyNo");
                    let check = event.target;
                    console.log("check -> ", check);
                    let deleteArea = $(check).closest(".rere");
                    console.log("deleteArea -> ", deleteArea);

                    console.log(sugestBrdReNo);
                    let data = {
                        sugestBrdReNo: sugestBrdReNo,
                    };


                    $.ajax({
                        url: "/suggestion/list/reply/delete",
                        data: JSON.stringify(data),
                        contentType: "application/json;charset=utf-8",
                        type: "post",
                        dataType: "json",
                        beforeSend: function (xhr) {
                            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                        },
                        success: function (res) {
                            console.log(res);
                            deleteArea.remove();
                        },
                    });

                });

                //댓글 등록
                $("#Replycheck").on("click", function () {
                    let reply = $("#suggestReplyInsert").val();
                    let empNo = sessionEmpNo;
                    console.log("sessionEmpNo ->",sessionEmpNo);
                    console.log("empNo", empNo);
                    const sugestBrdNo = "${suggestDetail.sugestBrdNo}";

                    // const det = document.querySelector("#suggestReplyList");
                    const det = $("#suggestReplyList");
                    console.log("확인 ", det);

                    let data = {
                        sugestBrdNo: sugestBrdNo,
                        reSj: reply,
                        empNo: empNo,
                    };
                    $.ajax({
                        url: "/suggestion/list/reply/insert",
                        data: JSON.stringify(data),
                        contentType: "application/json;charset=utf-8",
                        type: "post",
                        dataType: "json",
                        beforeSend: function (xhr) {
                            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                        },
                        success: function (res) {
                            console.log("댓글 등록 result :", res);
                            res.upperReNum = 0;
                            let str = "";
                            str += "<li>";
                            str += "<div class='user-wrap'>";
                            str += "<span class='user-thumb'>";
                            str += "<img src='/resources/img/icon/"+res.proflImageUrl+"' alt='예시이미지'>";
                            str += "</span>";
                            str += "<div class='user-info'>";
                            str += "<div>";
                            str += "<span class='user-name'>" + res.empNm + "</span>";
                            str += "<span class='user-position'>" + res.cmmnCdNm + "</span>";
                            str += "</div>";
                            str += "<div>";
                            str += "<span class='user-team'>" + res.deptNm + "</span>";
                            str += "<span class='user-date'>" + res.writngDate + "</span>";
                            str += "</div>";
                            str += "</div>";
                            str += "<div class='user-btn'>";
                            str += "<button type='button' id='updateReply' data-re-empNo='" + res.empNo + "' modal-id='modal-name' class='add-btn' data-sugest-brd-re-no='" + res.sugestBrdReNo + "' >";
                            str += "<i class='xi-pen'>";
                            str += "</i>";
                            str += "</button>";
                            str += "<button type='button' id='deleteReply' data-re-empNo='" + res.empNo + "' class='del-btn'>";
                            str += "<i class='xi-trash'>";
                            str += "</i>";
                            str += "</button>";
                            str += "</div>";
                            str += "</div>";
                            str += "<div class='txt'>" + res.reSj + "</div>";
                            str += "<input type='text' style ='display:none;' class='txtRe' value='" + res.reSj + "' />";
                            str += "</li>";
                            str += "<div>";
                            str += "<button type ='button' id='replybtn' class='reply-btn replyRe'>답글(" + res.upperReNum + ")</button> ";
                            str += "</div>";
                            str += "<br>";

                            det.append(str);
                            location.reload();
                            $("#suggestReplyInsert").val("");
                        },
                    });
                });

                // 건의 게시판 수정 
                $("#suggestUpdate").on("click", function () {
                    const sugestBrdNo = "${suggestDetail.sugestBrdNo}";
                    console.log("sugestBrdNo ", sugestBrdNo);

                    location.href = "/suggestion/list/update?sugestBrdNo=" + sugestBrdNo;
                    let data = {
                        sugestBrdNo: sugestBrdNo,
                    };
                    $.ajax({
                        url: "/suggestion/list/update",
                        data: JSON.stringify(data),
                        contentType: "application/json;charset=utf-8",
                        type: "post",
                        dataType: "json",
                        beforeSend: function (xhr) {
                            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                        },
                        success: function (res) {

                        }
                    });


                });





                // 건의 게시글 삭제 sweet alert2
                $("#suggestDelete").on("click", function () {
                    Swal.fire({
                        title: "게시글을 삭제 하시겠습니까?",
                        text: "삭제 후 게시글 복원이 불가합니다.",
                        icon: "warning",
                        showCancelButton: true,
                        confirmButtonColor: "#3085d6",
                        cancelButtonColor: "#d33",
                        confirmButtonText: "Yes",
                    }).then((result) => {
                        if (result.isConfirmed) {
                            const sugestBrdNo = "${suggestDetail.sugestBrdNo}";
                            let data = {
                                sugestBrdNo: sugestBrdNo,
                            };
                            $.ajax({
                                url: "/suggestion/list/delete",
                                data: JSON.stringify(data),
                                contentType: "application/json;charset=utf-8",
                                type: "post",
                                beforeSend: function (xhr) {
                                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                                },
                                success: function (res) {
                                    console.log(res);
                                    //setTimeout(function(){
                                    Swal.fire({
                                        title: "삭제 되었습니다!",
                                        text: "게시글이 삭제되었습니다.",
                                        icon: "success",
                                    });
                                    //},2000);

                                    setTimeout(function () {
                                        location.href = "/suggestion/list/";
                                    }, 1000);
                                },
                            });
                        }
                    });
                });
                
                
                
                $(document).on("click",".file-name",function(){
                	let param= $(this).data("url").replace("/", "");
                	
                	downloadFile(param);
                });
                
             
            });
            
            
        	function downloadFile(param) {
        	
        	    const s3Url = _storage + param;
        	    // let url = idx.split("/img/")[1]
        	    // 버튼 클릭 시 파일 다운로드
        	    const a = document.createElement('a');
        	    a.href = s3Url;
        	    a.download = param; // 다운로드될 파일 이름
        	    
        	    document.body.appendChild(a);
        	    a.click();
        	    document.body.removeChild(a);
        	}
        	
        </script>

<!-- =============== body 시작 =============== -->
<!-- =============== 상단타이틀영역 시작 =============== -->
<div class="wf-tit-wrap">
	<h1 class="page-tit">건의게시판</h1>
	<div class="wf-util">
		<button type="button" class="btn4" id="suggestUpdate"
			style="display: none;">수정</button>
		<button type="button" class="btn3" id="suggestDelete"
			style="display: none;">삭제</button>
		<button type="button" class="btn5"
			onclick="location.href='/suggestion/list/'">목록</button>
	</div>
</div>

<!-- =============== 상단타이틀영역 끝 =============== -->
<!-- =============== 컨텐츠 영역 시작 =============== -->
<div class="wf-content-wrap">
	<div class="wf-flex-box between">
		<div class="wf-content-area" style="flex: 1;">
			
			<!-- wf-insert-form2에 "detail"추가해주세요 -->
			<ul class="wf-insert-form3 detail">
				<li>
					<div class="detail-tit">
						<p class="tit">${suggestDetail.sugestBrdSj }</p>
					</div>
				</li>
				<li>

					<div class="form3-head-wrap">
						<div class="user-info">
							<span class="user-thumb"> <img src='/resources/img/icon/${suggestDetail.proflImageUrl }'
								alt="예시이미지" />
							</span>
							<div>
								<span class="user-name">${suggestDetail.empNm }</span>
							</div>
						</div>
						<p class="date">${suggestDetail.writngDate }</p>
						<p>조회수 ${suggestDetail.rdcnt }</p>
					</div>
				</li>
				<li>
					<p class="detail-content">${suggestDetail.sugestBrdCn }</p>
				</li>


			</ul>


			<!-- 댓글, 코멘트 영역 시작 -->
			<div class="comment-area">
				<ul>
					<div id="suggestReplyList"></div>
				</ul>

				<div id="deleteModal"></div>

				<div class="input-wrap">
					<span class="user-thumb"> <img src='/resources/img/icon/${proflImageUrl }'
						alt="예시이미지" />
					</span> <input type="text" placeholder="댓글을 입력하세요" id="suggestReplyInsert" />
					<input type="hidden" id="empNo" name="empNo"
						value="<%=session.getAttribute(" empNo")%>">
					<button class="btn4" id="Replycheck">등록</button>
				</div>
			</div>
			<!-- 댓글, 코멘트 영역 끝 -->
		</div>
		<div class="wf-content-area" style="width: 310px;">
			<h1 class="heading2">첨부파일</h1>
			<div class="custom-box">
				<ul class="file-lst bul-lst01">
					<c:forEach var="attachlistVO" items="${attachdata}"
						varStatus="stat">
						<li><p class="file-name" data-url="${attachlistVO.atchmnflUrl}">${attachlistVO.atchmnflOriginNm}</p>
							</li>
					</c:forEach>
				</ul>
			</div>
		</div>
	</div>
</div>



<!-- =============== 컨텐츠 영역 끝 =============== -->
<!-- =============== body 끝 =============== -->