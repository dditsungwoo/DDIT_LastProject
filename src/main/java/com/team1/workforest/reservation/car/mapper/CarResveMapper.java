package com.team1.workforest.reservation.car.mapper;

import java.util.List;

import com.team1.workforest.reservation.car.vo.CarReservationVO;
import com.team1.workforest.reservation.car.vo.CarVO;

public interface CarResveMapper {

	public List<CarReservationVO> getCarResveList(CarReservationVO carReservationVO);

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
