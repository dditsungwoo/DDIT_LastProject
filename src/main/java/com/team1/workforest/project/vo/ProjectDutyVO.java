package com.team1.workforest.project.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class ProjectDutyVO {
	private String prjctDutyNo; // 일감 번호
	private int prgsRate; // 진행률
	private String detailCn; // 상세내용
	private String atchmnflNo; // 첨부파일명
	private String dutySj; // 일감 제목
	private String prjctNo; // 프로젝트명
	private String empNo; // 사번
	private String empNm; // 이름
	private String proflImageUrl;//url 
	private String prjctBeginDate; // 시작일자
	private String prjctEndDate; // 종료일자
	
	private MultipartFile[] uploadFile;
	
	
	//간트 차트를 위한 프로퍼티	
	private String id;
	private String text;
	private String startDate;
	private String duration;
	private String progress;
	private String endDate;
	private String open;
	private String cntcNo;
	
	private String position;
	private String rspnsbl;
	
	
}
