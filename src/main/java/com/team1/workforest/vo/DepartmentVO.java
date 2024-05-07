package com.team1.workforest.vo;

import lombok.Data;

@Data
public class DepartmentVO { //부서
	private String deptNo; //부서_번호
	private String deptNm; //부서_명
	private String upperDept; //상위_부서
	
	private String empNm;
	private String position;
	private String rspnsblCtgryNm;
	 //private String employees;
	
	
}
