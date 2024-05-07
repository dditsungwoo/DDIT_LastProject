package com.team1.workforest.schedulerUtil.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.reservation.meetingroom.vo.MtrReservationVO;
import com.team1.workforest.schedulerUtil.mapper.MtrMapper;

@Service
public class MtrServiceImpl {
	
	@Autowired
	MtrMapper mtrMapper;

	public List<String> getMtr() {
		return this.mtrMapper.getMtr();
	}

	public MtrReservationVO getMtrReservation(String mtrNo) {
		return this.mtrMapper.getMtrReservation(mtrNo);
	}

	
}
