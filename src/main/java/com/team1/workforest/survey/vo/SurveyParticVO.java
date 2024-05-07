package com.team1.workforest.survey.vo;

import lombok.Data;

@Data
public class SurveyParticVO {
	private String surveyParticNo;
	private String surveyNo;
	private String surveyParticEmpNo;
	private String empNm;
	
	// 부서 번호
	private String deptNo;
	private String cmmnCdNm;
	private String rspnsblCtgryNm;
}
