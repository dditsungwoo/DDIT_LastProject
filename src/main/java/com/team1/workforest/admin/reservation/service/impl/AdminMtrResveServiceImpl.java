package com.team1.workforest.admin.reservation.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.admin.reservation.mapper.AdminMtrResveMapper;
import com.team1.workforest.admin.reservation.service.AdminMtrResveService;
import com.team1.workforest.reservation.meetingroom.vo.MtrReservationVO;

@Service
public class AdminMtrResveServiceImpl implements AdminMtrResveService {
	
	@Autowired
	AdminMtrResveMapper adminMtrResveMapper;

	@Override
	public List<MtrReservationVO> adminGetMtrResveList(Map<String, String> params) {
		return adminMtrResveMapper.adminGetMtrResveList(params);
	}

	@Override
	public List<MtrReservationVO> adminGetPastMtrResveList(Map<String, String> params) {
		return adminMtrResveMapper.adminGetPastMtrResveList(params);
	}
}
