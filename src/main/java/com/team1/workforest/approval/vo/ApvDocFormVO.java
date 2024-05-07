package com.team1.workforest.approval.vo;

import lombok.Data;

@Data
public class ApvDocFormVO {
	private String docFormNo;  // 문서_양식_번호
	private String apvCtgryNo; // 결재_종류_번호
	private String docFormSj;  // 문서_양식_제목
	private String docCn;      // 문서_내용
	private String useYnCd;    // 사용_여부_코드
}
