package com.team1.workforest.admin.chart.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.attendance.vo.AttendanceManageVO;
import com.team1.workforest.vo.DepartmentVO;

public interface AdminDeptAttendanceMapper {

	public List<DepartmentVO> getDept1();

	public List<DepartmentVO> getDept2(DepartmentVO deptVo);

	public List<AttendanceManageVO> getDeptEmpAttendance(Map<String, String> map);

	public String getAvgAttend(Map<String, String> map);

	public String getAvgLeave(Map<String, String> map);

	public String getAvgWork(Map<String, String> map);

	public String getRestCount(Map<String, String> map);

	public String getWorkCount(Map<String, String> map);

	public String getLateCount(Map<String, String> map);

	public String getOut1Count(Map<String, String> map);

	public String getOut2Count(Map<String, String> map);

	public String getOut3Count(Map<String, String> map);

}
