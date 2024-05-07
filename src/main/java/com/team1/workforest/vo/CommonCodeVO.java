package com.team1.workforest.vo;

import lombok.Data;

@Data
public class CommonCodeVO { //공통_코드
	private String cmmnCd; //공통_코드
	private String cmmnCdGroup; //공통_코드_그룹
	private String cmmnCdNm; //공통_코드_명
	private int outptSeq; //출력_순서
	private String useYn; //사용_여부
	private String cmmnCdDc; //공통_코드_설명

}
