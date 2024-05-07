package com.team1.workforest.approval.vo;

import lombok.Data;

@Data
public class ApvLineVO {
	private int apvNo;           // 결재_번호
	private int apvLineSeq;      // 결재_라인_순서
	private String apvEmpNo;     // 결재자_사번
	private String realApvEmpNo; // 실제_결재자_사번
	private String apvDate;      // 결재_일시
	private String apvSeCd;      // 결재_구분_코드
	private String apvSttusCd;   // 결재_상태_코드
	private String apvOpinion;   // 결재_의견
	private String apvStmpUrl;   // 실제_결재자_도장URL
	private String apvPosition;  // 결재자_직급
	private String apvRspnsbl;   // 결재자_직책
	
	private String empNm;        // 사원명
	private String signImageUrl; // 도장,사인
	private String deptNm;       // 부서명
}
