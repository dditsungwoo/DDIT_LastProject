package com.team1.workforest.vo;

import java.util.Date;

import lombok.Data;

@Data
public class AttachedFileVO {
	private String atchmnflNo;			// 첨부파일 번호
	private String atchmnflSeq;			// 첨부파일 순번
	private String atchmnflNm;			// 첨부파일 명
	private String atchmnflOriginNm;	// 첨부파일 원본 명
	private long atchmnflSize;			// 첨부파일 크기
	private Date atchmnflDwldDate;		// 첨부파일 다운로드 기한
	private String atchmnflUrl;			// 첨부파일 url
}
