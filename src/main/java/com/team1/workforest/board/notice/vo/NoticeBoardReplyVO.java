package com.team1.workforest.board.notice.vo;

import java.util.Date;

import lombok.Data;

@Data
public class NoticeBoardReplyVO {
	private String noticeBrdReNo;		//글번호
	private String reSj;				// 내용
	private String empNo;				// 사원 번호
	private String writngDate;			//입력날짜
	private Date updtDate;				//업데이트 날짜
	private String noticeBrdNo;			//게시글 번호
	private String upperRe;				//대댓글 상위 댓글 번호
	
	private String lvl;			// 레벨
	private String cmmnCdNm; 	// 직급
	private String deptNm;		// 부서
	private String empNm;		// 이름
	private String proflImageUrl;
}
