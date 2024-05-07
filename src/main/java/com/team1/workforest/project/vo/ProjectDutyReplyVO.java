package com.team1.workforest.project.vo;

import java.util.Date;

import lombok.Data;

@Data
public class ProjectDutyReplyVO {
	private String prjctDutyReNo; // 프로젝트댓글 번호
	private String prjctDutyNo; // 프로젝트 일감명
	private String reSj; // 댓글 제목
	private String empNo; // 사번
	private Date writngDate; // 작성일
	private Date updtDate; // 수정일
	private String upperRe; // 상위 댓글번호
	
	
	private int rnum;
	private int total;
	private String empNm;
	private String proflImageUrl;
	
	private String position;
	private String rspnsbl;
}
