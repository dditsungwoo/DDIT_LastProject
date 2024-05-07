package com.team1.workforest.admin.chart.service;

import java.util.List;
import java.util.Map;

import com.team1.workforest.attendance.vo.AttendanceManageVO;
import com.team1.workforest.employee.vo.EmployeeVO;

public interface AdminAttendanceService {

	public List<EmployeeVO> getEmp(Map<String, String> map);

	public Map<String, String> getAvgRes(Map<String, String> map);

	public List<AttendanceManageVO> getAttendanceList(Map<String, String> map);

	public List<EmployeeVO> getEmpNo(Map<String, String> map);

}
