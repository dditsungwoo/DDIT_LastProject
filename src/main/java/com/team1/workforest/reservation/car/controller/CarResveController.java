package com.team1.workforest.reservation.car.controller;

import java.util.List;

import org.json.simple.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.team1.workforest.reservation.car.service.CarResveService;
import com.team1.workforest.reservation.car.vo.CarReservationVO;
import com.team1.workforest.reservation.car.vo.CarVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api")
public class CarResveController {
	
	@Autowired
	CarResveService carResveService;
	
	// 차량 예약 목록 불러오기
	@GetMapping("/reservations/car")
	public JSONArray getCarResveList(CarReservationVO carReservationVO) {
		return carResveService.getCarResveList(carReservationVO);
	}
	
	// 특정 예약 불러오기
	@GetMapping("/reservation/car/{carResveNo}")
	public CarReservationVO getCarResve(@PathVariable String carResveNo) {
		return carResveService.getCarResve(carResveNo);
	}
	
	// 내 예약 불러오기
	@GetMapping("/reservations/car/{empNo}")
	public List<CarReservationVO> getMyCarResve(@PathVariable String empNo) {
		return carResveService.getMyCarResve(empNo);
	}
	
	// 내 지난 예약 불러오기
	@GetMapping("/reservations/car/past/{empNo}")
	public List<CarReservationVO> getMyPastCarResve(@PathVariable String empNo) {
		return carResveService.getMyPastCarResve(empNo);
	}
	
	// 차량 예약 추가
	@PostMapping("/reservation/car")
	public String createCarResve(@RequestBody CarReservationVO carResveVO) {
		int result = carResveService.createCarResve(carResveVO);	
		if (result != 0) {
			return "success";
		}
		return "fail";	
		
	}
	
	// 차량 예약 수정
	@PutMapping("/reservation/car/{carResveNo}")
	public String updateCarResve(@PathVariable String carResveNo, @RequestBody CarReservationVO carResveVO) {
		// 예약번호 vo에 추가
		carResveVO.setCarResveNo(carResveNo);
		
		int result = carResveService.updateCarResve(carResveVO);	
		if (result != 0) {
			return "success";
		}
		return "fail";
	}
	
	// 반납상태 수정
	@PutMapping("/reservation/car/return")
	public String updateCarReturn(@RequestBody CarReservationVO carResveVO) {		
		int result = carResveService.updateCarReturn(carResveVO);	
		if (result != 0) {
			return "success";
		}
		return "fail";
	}
	
	// 차량 예약 취소
	@DeleteMapping("/reservation/car/{carResveNo}")
	public String deleteCarResve(@PathVariable String carResveNo) {
		int result = carResveService.deleteCarResve(carResveNo);
		if (result != 0) {
			return "success";
		}
		return "fail";
	}
	
	// 차량 정보 불러오기
	@GetMapping("/car/{carNo}")
	public CarVO getCarInfo(@PathVariable String carNo) {
		return carResveService.getCarInfo(carNo);
	}
	
	// 차량 목록 불러오기
	@GetMapping("/cars")
	public List<CarVO> getCars() {
		return carResveService.getCars();
	}
}
