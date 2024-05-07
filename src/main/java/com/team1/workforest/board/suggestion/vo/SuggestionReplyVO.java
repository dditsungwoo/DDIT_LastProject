package com.team1.workforest.board.suggestion.vo;

import lombok.Data;

@Data
public class SuggestionReplyVO {
	private String sugestBrdReNo;	// 글번호
	private String reSj;			// 내용
	private String empNo;			// 사원번호
	private String writngDate;
	private String updtDate;
	private String sugestBrdNo;
	private String upperRe;
	
	private String upperReNum;		//댓글 개수
	
	
	private String empNm;
	private String deptNo;
	private String positionCd;
	private String deptNm;
	private String cmmnCdNm;
	private String lvl;
	private String proflImageUrl;
}
