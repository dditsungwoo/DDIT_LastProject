package com.team1.workforest.project.vo;

import java.util.List;

import lombok.Data;

@Data
public class ProjectVO {
	private int rnum; //
	private String prjctNo; // 프로젝트 번호
	private String prjctNm; // 프로젝트명
	private String prjctBeginDate; // 시작일자
	private String prjctEndDate; // 종료일자
	private String prjctDetailCn; // 프로젝트 내용
	private String prjctSttusCd; // 프로젝트 상태
	private int total;
	
	private List<ProjectDutyVO> projectDutyVOList;
	
	private String leader;  //project Employee쪽에 들어갈 것들
	private String[] teams;
	private String empNm;
	private String empNo;
	
	
	private String position;
	private String currentPage;
	private String rspnsbl;
	private String keyword;
}
