package com.team1.workforest.admin.reservation.mapper;

import java.util.List;

import com.team1.workforest.reservation.car.vo.CarVO;
import com.team1.workforest.reservation.meetingroom.vo.MtrEquipmentVO;
import com.team1.workforest.reservation.meetingroom.vo.MtrVO;

public interface AdminResourcesMapper {
	
	public List<MtrVO> getMtrList();
	
	public int createMtr(MtrVO mtrVO);

	public int updateMtr(MtrVO mtrVO);

	public int deleteMtr(String mtrNo);

	public List<CarVO> getCarList();
	
	public int createCar(CarVO carVO);

	public int updateCar(CarVO carVO);

	public int deleteCar(String carNo);

	public int createMtrEquipment(MtrEquipmentVO mtrEquipmentVO);

	public String createMtrNo();

	public int updateMtrEquipment(MtrEquipmentVO mtrEquipmentVO);

	public int deleteMtrEquipment(String mtrNo);
}
