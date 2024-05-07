package com.team1.workforest.schedulerUtil.service;

import java.util.List;

import com.team1.workforest.attendance.vo.AttendanceManageVO;
import com.team1.workforest.reservation.meetingroom.vo.MtrReservationVO;

public interface SchedulerService {
	
	public List<String> getMtr();

	public MtrReservationVO getMtrReservation(String mtrNo);

	public List<AttendanceManageVO> getAttendanceList();

	public List<String> getEmpList();

}
