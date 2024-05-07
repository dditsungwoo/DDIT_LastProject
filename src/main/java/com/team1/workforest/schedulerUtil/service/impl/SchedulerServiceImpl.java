package com.team1.workforest.schedulerUtil.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.attendance.vo.AttendanceManageVO;
import com.team1.workforest.reservation.meetingroom.vo.MtrReservationVO;
import com.team1.workforest.schedulerUtil.mapper.SchedulerMapper;
import com.team1.workforest.schedulerUtil.service.SchedulerService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SchedulerServiceImpl implements SchedulerService{
	
	@Autowired
	SchedulerMapper schedulerMapper;
	
	public List<String> getMtr() {
		return this.schedulerMapper.getMtr();
	}
	
	public MtrReservationVO getMtrReservation(String mtrNo) {
		return this.schedulerMapper.getMtrReservation(mtrNo);
	}
	
	@Override
	public List<AttendanceManageVO> getAttendanceList() {
		log.error("service:" + this.schedulerMapper.getAttendanceList());
		return this.schedulerMapper.getAttendanceList();
	}

	@Override
	public List<String> getEmpList() {
		return this.schedulerMapper.getEmpList();
	}
	

}
