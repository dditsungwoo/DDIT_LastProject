package com.team1.workforest.admin.chart.service;

import java.util.List;
import java.util.Map;

import com.team1.workforest.admin.chart.vo.adminEmpVO;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.project.vo.ProjectDutyVO;
import com.team1.workforest.project.vo.ProjectVO;

public interface AdminProjectService {

	public List<String> getProjectCount();

	public List<adminEmpVO> getEnableEmp();

	public List<String> getMonthNewProj(Map<String, String> map);

	public List<String> getMonthEndProj(Map<String, String> map);

	public List<String> getProceedPeriod();

	public List<ProjectVO> getProjects();

	public List<EmployeeVO> getProjectEmp(ProjectVO pVo);

	public List<ProjectDutyVO> getEmpPjDuty(ProjectVO pVo);

}
