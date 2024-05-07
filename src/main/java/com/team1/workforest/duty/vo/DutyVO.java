package com.team1.workforest.duty.vo;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class DutyVO {
	private String dutyNo; // 업무번호
	private String empNo; // 사원번호
	private String dutySj; // 업무 명
	private String dutyCn; // 업무 내용
	private String sendDate; // 송신일
	private String closDate; // 업무종료일
	private String closTime; // 업무종료일	
	private String atchmnflNo; // 첨부파일명
	
	private MultipartFile uploadFile;
	private String[] recipientNo;
	
	
	private int rnum; //페이징위한 rownum
	private int total; //페이징을 위한 total
	private String empNm; //사원명
	private String prgsRate; // 진행률
	private String cnfirmDate; // 확인한 일시
	private String keyword; //검색어
	private String weekDay; //요일
	private String sender; //송신자
	private String recipient; //발신자
	private String proflImageUrl;
	private String col1; // 통계가 들어갈 컬럼들
	private String col2;
	private String col3;
	private String col4;
	private String base64;
	
	
	private String position;
	private String rspnsbl;
	
}
