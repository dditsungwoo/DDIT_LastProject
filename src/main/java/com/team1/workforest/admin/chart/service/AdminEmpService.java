package com.team1.workforest.admin.chart.service;

import java.util.List;
import java.util.Map;

import com.team1.workforest.admin.chart.vo.adminEmpVO;
import com.team1.workforest.vo.DepartmentVO;

public interface AdminEmpService {

	public List<Integer> getAgeGraph(Map<String, String> map);

	public int getAvgAge(Map<String, String> map);

	public int getEmpCount(Map<String, String> map);

	public List<Integer> getGenderRate(Map<String, String> map);

	public List<Integer> getRetireCount(Map<String, String> map);

	public int getHireCount(Map<String, String> map);

	public List<String> getDeptCount(Map<String, String> map);

	public List<DepartmentVO> getDeptName(Map<String, String> map);

	public List<String> getRetireRate(Map<String, String> map);
	
	public String getYearRetireRate(Map<String, String> map);

	public List<adminEmpVO> getPositionGraph(Map<String, String> map);

	public List<adminEmpVO> getLocalCount(Map<String, String> map);

	public List<adminEmpVO> getWorkerCount(Map<String, String> map);

}
