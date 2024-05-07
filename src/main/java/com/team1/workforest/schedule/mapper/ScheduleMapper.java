package com.team1.workforest.schedule.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.schedule.vo.ScheduleVO;

public interface ScheduleMapper {

	public List<ScheduleVO> getMyScheduleList(Map<String, String> params);
	
	public List<ScheduleVO> getTeamScheduleList(Map<String, String> params);
	
	public List<ScheduleVO> getDeptScheduleList(Map<String, String> params);
	
	public List<ScheduleVO> getCompScheduleList(Map<String, String> params);
	
	public ScheduleVO getSchedule(String schdulNo);
	
	public int createSchedule(ScheduleVO scheduleVO);

	public int updateSchedule(ScheduleVO scheduleVO);

	public int deleteSchedule(String schdulNo);
}
