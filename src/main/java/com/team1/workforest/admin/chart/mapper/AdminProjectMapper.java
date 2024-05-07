package com.team1.workforest.admin.chart.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.admin.chart.vo.adminEmpVO;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.project.vo.ProjectDutyVO;
import com.team1.workforest.project.vo.ProjectVO;

public interface AdminProjectMapper {

	public String getProjectCount(Map<String, String> map);

	public List<adminEmpVO> getEnableEmp();

	public String getMonthNewProj(Map<String, String> map);

	public String getMonthEndProj(Map<String, String> map);

	public String getProceedPeriod(Map<String, String> map);

	public List<ProjectVO> getProjects();

	public List<EmployeeVO> getProjectEmp(ProjectVO pVo);

	public List<ProjectDutyVO> getEmpPjDuty(ProjectVO pVo);

}
