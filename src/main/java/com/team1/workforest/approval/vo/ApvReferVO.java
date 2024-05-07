package com.team1.workforest.approval.vo;

import lombok.Data;

@Data
public class ApvReferVO {
	private int apvNo;          // 결재번호
	private String empNo;       // 참조인사번
	
	private String empNm;       // 사원명
	private String deptNm;      // 부서명
	private String apvPosition; // 직급
	private String apvRspnsbl;  // 직책
}
