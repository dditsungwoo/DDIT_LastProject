package com.team1.workforest.admin.reservation.service;

import java.util.List;
import java.util.Map;

import com.team1.workforest.reservation.car.vo.CarReservationVO;

public interface AdminCarResveService {

	List<CarReservationVO> adminGetCarResveList(Map<String, String> params);

	List<CarReservationVO> adminGetWaitReturnCarResveList(Map<String, String> params);

	List<CarReservationVO> adminGetPastCarResveList(Map<String, String> params);


}
