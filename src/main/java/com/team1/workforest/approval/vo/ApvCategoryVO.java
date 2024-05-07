package com.team1.workforest.approval.vo;

import lombok.Data;

@Data
public class ApvCategoryVO {
	private String apvCtgryNo;     // 결재_종류_번호
	private String apvNm;          // 결재_명
	private String deleteYnCd;     // 삭제_여부_코드
	private String svcClassNm;     // 서비스_클래스_명
	private String svcClassFuncNm; // 서비스_클래스_함수_명
}
