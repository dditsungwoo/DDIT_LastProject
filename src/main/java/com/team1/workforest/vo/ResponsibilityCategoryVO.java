package com.team1.workforest.vo;

import lombok.Data;

@Data
public class ResponsibilityCategoryVO { //직책
	private String rspnsblCd; //직책_코드
	private String rspnsblCtgryNm; //직책_분류_명
	private String authorCd; //권한_코드
	private String useYnCd; //사용_여부_코드
}
