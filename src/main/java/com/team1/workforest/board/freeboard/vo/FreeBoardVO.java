package com.team1.workforest.board.freeboard.vo;

import java.util.Date;

import lombok.Data;

@Data
public class FreeBoardVO {
	private String freeBrdNo;	// 자유 게시글 번호
	private String empNo;		// 작성자 사번
	private String freeBrdSj;	// 제목
	private Date writngDate;	// 작성일시
	private int rdcnt;			// 조회수
	private Date updtDate;		// 수정일시
	private String freeBrdSeCd;	// 자유게시판구분코드
	private String freeBrdCn;	// 게시판 내용
	private String atchmnflNo;	// 첨부파일번호	
}
