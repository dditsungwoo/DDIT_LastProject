package com.team1.workforest.schedule.service;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.schedule.vo.ScheduleVO;

public interface ScheduleService {
	
	public JSONArray getScheduleList(String empNo, List<String> chkSchs);

	public int createSchedule(ScheduleVO scheduleVO);

	public int updateSchedule(ScheduleVO scheduleVO);

	public int deleteSchedule(String schdulNo);

	public ScheduleVO getSchedule(String schdulNo);

	public JSONArray getTodayScheduleList(String empNo);

}
