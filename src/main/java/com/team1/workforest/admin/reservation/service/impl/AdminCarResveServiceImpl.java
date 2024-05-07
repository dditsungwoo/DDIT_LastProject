package com.team1.workforest.admin.reservation.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.admin.reservation.mapper.AdminCarResveMapper;
import com.team1.workforest.admin.reservation.service.AdminCarResveService;
import com.team1.workforest.reservation.car.vo.CarReservationVO;

@Service
public class AdminCarResveServiceImpl implements AdminCarResveService {

	@Autowired
	AdminCarResveMapper adminCarResveMapper;

	@Override
	public List<CarReservationVO> adminGetCarResveList(Map<String, String> params) {
		return adminCarResveMapper.adminGetCarResveList(params);
	}

	@Override
	public List<CarReservationVO> adminGetWaitReturnCarResveList(Map<String, String> params) {
		return adminCarResveMapper.adminGetWaitReturnCarResveList(params);
	}

	@Override
	public List<CarReservationVO> adminGetPastCarResveList(Map<String, String> params) {
		return adminCarResveMapper.adminGetPastCarResveList(params);
	}

}
