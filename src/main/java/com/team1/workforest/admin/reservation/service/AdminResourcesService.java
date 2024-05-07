package com.team1.workforest.admin.reservation.service;

import java.util.List;

import com.team1.workforest.reservation.car.vo.CarVO;
import com.team1.workforest.reservation.meetingroom.vo.MtrVO;

public interface AdminResourcesService {
	
	public List<MtrVO> getMtrList();
		
	public int createMtr(MtrVO mtrVO);

	public int updateMtr(MtrVO mtrVO);

	public int deleteMtr(String mtrNo);

	public List<CarVO> getCarList();
	
	public int createCar(CarVO carVO);

	public int updateCar(CarVO carVO);

	public int deleteCar(String carNo);

	public String createMtrNo();

}
