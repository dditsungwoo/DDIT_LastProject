package com.team1.workforest.approval.vo;

import lombok.Data;

@Data
public class ApvLineBkmkDetailVO {
	private String empNo;   // 결재자_사번
	private String bkmkNo;  // 즐겨찾기_번호
	private int apvLineSeq; // 결재_라인_순서
	private String apvSeCd; // 결재_구분_코드
}
