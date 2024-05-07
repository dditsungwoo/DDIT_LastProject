package com.team1.workforest.admin.chart.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.admin.chart.vo.adminEmpVO;
import com.team1.workforest.vo.DepartmentVO;

public interface AdminEmpMapper {

	public int getAgeGraph(Map<String, String> map);

	public int getAvgAge(Map<String, String> map);

	public int getEmpCount(Map<String, String> map);

	public int getGenderRate(Map<String, String> map);

	public int getRetireCount(Map<String, String> map);

	public int getHireCount(Map<String, String> map);

	public List<String> getDeptNo();

	public String getDeptCount(Map<String, String> map);

	public List<DepartmentVO> getDeptName(Map<String, String> map);

	public String getRetireRate(Map<String, String> map);
	
	public int getYearRetireRate1(Map<String, String> map);
	
	public int getYearRetireRate2(Map<String, String> map);

	public List<adminEmpVO> getPositionGraph(Map<String, String> map);

	public List<adminEmpVO> getLocalCount(Map<String, String> map);

	public List<adminEmpVO> getWorkerCount(Map<String, String> map);
	

}
