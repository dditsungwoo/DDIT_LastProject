package com.team1.workforest.approval.vo;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class ApvVO {
	private int apvNo;             // 결재_번호
	private String empNo;          // 작성자_사번
	private String docFormNo;      // 문서_양식_번호
	private String sttusCd;        // 상태_코드
	private String apvSj;          // 결재_제목
	private String apvCn;          // 결재_내용
	private String apvEtc;         // 결재_기타         	
	private String drftDate;       // 기안_일자
	private String refuseDate;     // 반려_일자
	
	// 프로퍼티 추가
	private String empNm;           // 사원명
	private String apvPosition;     // 결재자_직급
	private String apvRspnsbl;      // 결재자_직책
	private String deptNm;          // 부서명
	private String proflImageUrl;   // 프로필이미지
	private int num;                // 행
	
	private String apvDate;         // 결재_일시
	private String apvSeCd;         // 결재_구분_코드
	private String apvSttusCd;      // 결재_상태_코드
	
	private String tmprStreYnCd;    // 임시_저장_여부_코드
	private String atchmnflNo;      // 첨부파일_번호
	
	private String atchmnflSeq;        // 첨부파일 순번
	private String atchmnflNm;         // 첨부파일 명
	private String atchmnflOriginNm;   // 첨부파일 원본 명
	private long atchmnflSize;         // 첨부파일 크기
	
	private MultipartFile[] multipartFile;
	
	private List<ApvLineVO> apvLineVOList;
	private List<ApvReferVO> apvReferVOList;
	
}
