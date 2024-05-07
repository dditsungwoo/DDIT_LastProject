package com.team1.workforest.reservation.car.service.impl;

import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.common.mapper.CommonMapper;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.reservation.car.mapper.CarResveMapper;
import com.team1.workforest.reservation.car.service.CarResveService;
import com.team1.workforest.reservation.car.vo.CarReservationVO;
import com.team1.workforest.reservation.car.vo.CarVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CarResveServiceImpl implements CarResveService{
	
	@Autowired
	CarResveMapper carResveMapper;
	
	@Autowired
	CommonMapper commonMapper;

	// 차량 예약 목록 불러오기
	@Override
	public JSONArray getCarResveList(CarReservationVO carReservationVO) {
		log.info("carReservationVO : {}", carReservationVO);

		List<CarReservationVO> carResveList = carResveMapper.getCarResveList(carReservationVO);

		JSONArray jsonArr = new JSONArray();
		

		for (CarReservationVO carResve : carResveList) {
			String empNo = carResve.getEmpNo();
			EmployeeVO empVO = commonMapper.getEmpInfo(empNo);
			String empNm = empVO.getEmpNm();
			String position = empVO.getPosition();
			String rspnsblCtgryNm = empVO.getRspnsblCtgryNm();
			if(!rspnsblCtgryNm.equals("팀원")) {
				position = rspnsblCtgryNm;
			}
			String deptNm = empVO.getDeptNm();
			
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("carResveNo", carResve.getCarResveNo());
			jsonObj.put("carNo", carResve.getCarNo());
			jsonObj.put("empNo", carResve.getEmpNo());
			jsonObj.put("start", carResve.getResveBeginDate());
			jsonObj.put("end", carResve.getResveEndDate());
			jsonObj.put("content", carResve.getResveCn());
			jsonObj.put("title", carResve.getCarNm() + "(" + empNm + " " + position + ", " + deptNm + ")");
			jsonObj.put("allDayCd", carResve.getAllDayCd());

			jsonArr.add(jsonObj);
		}

		return jsonArr;
	}

	@Override
	public CarReservationVO getCarResve(String carResveNo) {
		return carResveMapper.getCarResve(carResveNo);
	}

	@Override
	public List<CarReservationVO> getMyCarResve(String empNo) {
		return carResveMapper.getMyCarResve(empNo);
	}

	@Override
	public List<CarReservationVO> getMyPastCarResve(String empNo) {
		return carResveMapper.getMyPastCarResve(empNo);
	}
	
	@Override
	public int createCarResve(CarReservationVO carResveVO) {
		return carResveMapper.createCarResve(carResveVO);
	}

	@Override
	public int updateCarResve(CarReservationVO carResveVO) {
		return carResveMapper.updateCarResve(carResveVO);
	}
	
	@Override
	public int updateCarReturn(CarReservationVO carResveVO) {
		return carResveMapper.updateCarReturn(carResveVO);
	}

	@Override
	public int deleteCarResve(String carResveNo) {
		return carResveMapper.deleteCarResve(carResveNo);
	}

	@Override
	public CarVO getCarInfo(String carNo) {
		return carResveMapper.getCarInfo(carNo);
	}

	@Override
	public List<CarVO> getCars() {
		return carResveMapper.getCars();
	}
}
