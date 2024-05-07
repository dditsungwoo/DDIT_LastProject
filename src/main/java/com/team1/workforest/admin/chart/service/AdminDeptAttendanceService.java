package com.team1.workforest.admin.chart.service;

import java.util.List;
import java.util.Map;

import com.team1.workforest.attendance.vo.AttendanceManageVO;
import com.team1.workforest.vo.DepartmentVO;

public interface AdminDeptAttendanceService {

	public List<DepartmentVO> getDept1();

	public List<DepartmentVO> getDept2(DepartmentVO deptVo);

	public List<AttendanceManageVO> getDeptEmpAttendance(Map<String, String> map);

	public Map<String, String> getAvgRes(Map<String, String> map);

}
