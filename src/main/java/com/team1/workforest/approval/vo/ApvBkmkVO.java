package com.team1.workforest.approval.vo;

import lombok.Data;

@Data
public class ApvBkmkVO {
	private int bkmkNo;            /* 즐겨찾기번호 */
	private String bkmkNm;         /* 즐겨찾기명 */
	private String apvSeCd;        /* 구분코드 */
	private String empNm;          /* 사원명 */
	private String empNo;          /* 사원번호 */
	private String deptNm;         /* 부서명 */
	private String cmmnCdNm;       /* 직급명 */
	private String rspnsblCtgryNm; /* 직책명 */
	private int apvLineSeq;        /* 결재라인순서 */
}