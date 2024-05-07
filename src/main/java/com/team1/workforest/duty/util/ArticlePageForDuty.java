package com.team1.workforest.duty.util;

import java.util.List;

// 페이징 관련 정보 + 게시글 정보
// new ArticlePage<FreeBoardVO> (total,currentPage,size,content);
// size : 한 화면에 보여질 게시글 수
public class ArticlePageForDuty<T> {
   // 전체 글 수
   private int total;
   // 현재 페이지 번호
   private int currentPage;
   // 전체 페이지수
   private int totalPages;
   // 블록의 시작 페이지 번호
   private int startPage;
   // 블록의 종료 페이지 번호
   private int endPage;
   // 검색어
   private String keyword = "";
   // 요청 URL
   private String url = "";
   // select 결과데이터
   // 제네릭으로 구성 타입 정함
   private List<T> content;
   // 페이징 처리
   private String pagingArea = "";
   // 요청url주소

   // 생성자(Constructor) : 페이징 정보를 생성
   // 753 1 10 select결과 10행
   public ArticlePageForDuty(int total, int currentPage, int size, List<T> content, String keyword) {
      // size : 한 화면에 보여질 목록의 행 수
      this.total = total; // 753
      this.currentPage = currentPage; // 1
      this.content = content;
      this.keyword = keyword;
      if (keyword==null) {
    	  keyword = "";
      }
      // 전체 글 수가 0이면
      if (total == 0) {
         totalPages = 0; // 전체 페이지 수
         startPage = 0; // 블록 시작 번호
         endPage = 0; // 블록 종료 번호
      } else { // 글이 있다면
         // 전체 페이지 수 = 전체 글 수/ 한 화면에 보여질 목록의 행 수
         // 3 = 31 / 10
         totalPages = total / size; // 75

         // 나머지가 있다면, 페이지를 1증가
         if (total % size > 0) { // 3
            totalPages++; // 76
         }

         // 페이지 블록 시작번호를 구하는 공식
         // 블록시작번호 = 현재페이지 / 페이지크기 * 페이지크기 + 1
         startPage = currentPage / 4 * 4 + 1;

         // 현재페이지 % 페이지크기 => 0일 때 보정
         if (currentPage % 4 == 0) {
            startPage -= 4;
         }

         // 블록종료번호 = 시작페이지번호 + (페이지크기 - 1)
         // [1][2][3][4][5][다음]
         endPage = startPage + (4 - 1);

         // 종료페이지번호 > 전체페이지 수
         if (endPage > totalPages) {
            endPage = totalPages;
         }
      }


      pagingArea += "<nav class='wf-pagination-wrap'> ";
        pagingArea += "<ul class='pagination'> ";
        pagingArea += "<li class='page-item'> ";
        pagingArea += "<a class='page-link prev' ";
        if (this.startPage < 5) { pagingArea += "style='pointer-events: none;'"; }
        pagingArea += " href='javascript:getDutyList(" + (this.startPage-4) + ", " + keyword + ")'>";
        pagingArea += "<i class='xi-angle-left'></i> ";
        pagingArea += " </a>";
        pagingArea += "</li>";

        for (int pNo = this.startPage; pNo <= this.endPage; pNo++) {
        pagingArea += "<li class='page-item ";
        if (this.currentPage==pNo) {
           pagingArea +="active" ;
        }
        pagingArea +="'>";
        pagingArea += "<a class='page-link' href='javascript:getDutyList(" + pNo + ", " + keyword + ")'>" + pNo + "</a>";	
        pagingArea += "</li>";
        }
        // 페이지가 5개 미만일 경우 오른쪽 화살표 제거
      if(this.endPage < this.totalPages){
        pagingArea += "<li class='page-item'> ";
        pagingArea += "<a class='page-link next ";
        pagingArea += "' href='javascript:getDutyList(" + (this.startPage+4) + ", " + keyword + ")'>";
        pagingArea += "<i class='xi-angle-right'></i>  ";
        pagingArea += "</a>";
        pagingArea += "</li>";
      }
        pagingArea += "</ul> ";
        pagingArea += "</nav>";
      
   }// end생성자

   public int getTotal() {
      return total;
   }

   public void setTotal(int total) {
      this.total = total;
   }

   public int getCurrentPage() {
      return currentPage;
   }

   public void setCurrentPage(int currentPage) {
      this.currentPage = currentPage;
   }

   public int getTotalPages() {
      return totalPages;
   }

   public void setTotalPages(int totalPages) {
      this.totalPages = totalPages;
   }

   public int getStartPage() {
      return startPage;
   }

   public void setStartPage(int startPage) {
      this.startPage = startPage;
   }

   public int getEndPage() {
      return endPage;
   }

   public void setEndPage(int endPage) {
      this.endPage = endPage;
   }

   public String getKeyword() {
      return keyword;
   }

   public void setKeyword(String keyword) {
      this.keyword = keyword;
   }

   public String getUrl() {
      return url;
   }

   public void setUrl(String url) {
      this.url = url;
   }

   public List<T> getContent() {
      return content;
   }

   public void setContent(List<T> content) {
      this.content = content;
   }

   // 전체 글의 수가 0인가?
   public boolean hasNoArticles() {
      return this.total == 0;
   }

   // 데이터가 있나?
   public boolean hasArticles() {
      return this.total > 0;
   }

   public String getPagingArea() {
      return this.pagingArea = pagingArea;
   }

   public void setPagingArea(String pagingArea) {
      this.pagingArea = pagingArea;
   }

   // 페이징 블록을 자동화

}
