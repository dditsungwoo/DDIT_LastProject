package com.team1.workforest.board.freeboard.vo;

import java.util.Date;

import lombok.Data;

@Data
public class FreeBoardReplyVO {
	private String freeBrdReNo;	// 자유게시판 댓글 번호
	private String reSj;		// 댓글 제목
	private String empNo;		// 작성자
	private Date writngDate;	// 작성일시
	private Date updtDate;		// 수정일시
	private String freeBrdNo;	// 자유게시글번호
	private String upperRe;		// 상위댓글
}
