package com.team1.workforest.reservation.car.service;

import java.util.List;

import org.json.simple.JSONArray;

import com.team1.workforest.reservation.car.vo.CarReservationVO;
import com.team1.workforest.reservation.car.vo.CarVO;

public interface CarResveService {

	public JSONArray getCarResveList(CarReservationVO carReservationVO);

	public CarReservationVO getCarResve(String carResveNo);

	public List<CarReservationVO> getMyCarResve(String empNo);

	public List<CarReservationVO> getMyPastCarResve(String empNo);
	
	public int createCarResve(CarReservationVO carResveVO);

	public int updateCarResve(CarReservationVO carResveVO);

	public int updateCarReturn(CarReservationVO carResveVO);
	
	public int deleteCarResve(String carResveNo);

	public CarVO getCarInfo(String carNo);

	public List<CarVO> getCars();

}
