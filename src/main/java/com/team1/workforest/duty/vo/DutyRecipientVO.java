package com.team1.workforest.duty.vo;

import java.util.Date;

import lombok.Data;

@Data
public class DutyRecipientVO { // 업무 수신자 테이블
	private String dutyNo; // 업무번호
	private String empNo; // 사번
	private String prgsRate; // 진행률
	private String cnfirmDate; // 확인한 일시
	private String empNm; //사원명
	
	private String prgsCate; //0,1,10등으로 분류
	private String prgsCateName; // 진행중 ,중단 ,완료등
	
	
	
	private String position;
	private String rspnsbl;
	
}
