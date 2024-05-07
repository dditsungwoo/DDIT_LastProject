package com.team1.workforest.schedulerUtil.mapper;

import java.util.List;

import com.team1.workforest.attendance.vo.AttendanceManageVO;
import com.team1.workforest.reservation.meetingroom.vo.MtrReservationVO;

public interface SchedulerMapper {
	
	public List<String> getMtr();

	public MtrReservationVO getMtrReservation(String mtrNo);

	public List<AttendanceManageVO> getAttendanceList();

	public List<String> getEmpList();

}
