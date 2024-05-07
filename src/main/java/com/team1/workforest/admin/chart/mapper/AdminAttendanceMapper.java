package com.team1.workforest.admin.chart.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.employee.vo.EmployeeVO;

public interface AdminAttendanceMapper {

	public List<EmployeeVO> getEmp(Map<String, String> map);

	public List<EmployeeVO> getEmpNo(Map<String, String> map);

}
