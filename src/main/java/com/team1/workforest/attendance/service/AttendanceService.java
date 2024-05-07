package com.team1.workforest.attendance.service;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import com.team1.workforest.attendance.vo.AttendanceManageVO;


public interface AttendanceService {

	public List<AttendanceManageVO> getAttendanceList(Map<String, String> map);

	public String getPlusTime(Map<String, String> map);

	public String getMinusTime(Map<String, String> map);

	public String getOverTime(Map<String, String> map);

	public String getAvgAttend(Map<String, String> map);

	public String getAvgLeave(Map<String, String> map);

	public String getAvgWork(Map<String, String> map);

	public String getLateCount(Map<String, String> map);

	public String getRestCount(Map<String, String> map);

	public String getOut1Count(Map<String, String> map);

	public String getOut2Count(Map<String, String> map);

	public String getOut3Count(Map<String, String> map);

	public int insertAttend(Map<String, String> map);

	public String getAttendTime(Map<String, String> map);

	public String getLvffcTime(Map<String, String> map);

	public int insertLvffc(Map<String, String> map);

	public String getTodayWorkTime(Map<String, String> map);

	public List<String> getWeekWorkTime(Map<String, String> map);

	public String getTodayRestUse(Map<String, String> map);

	public List<String> getVcatnSeCd(Map<String, String> map);

}
