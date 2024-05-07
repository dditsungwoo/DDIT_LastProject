package com.team1.workforest.admin.reservation.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.team1.workforest.admin.reservation.service.AdminResourcesService;
import com.team1.workforest.reservation.car.service.CarResveService;
import com.team1.workforest.reservation.car.vo.CarVO;
import com.team1.workforest.reservation.meetingroom.service.MtrResveService;
import com.team1.workforest.reservation.meetingroom.vo.MtrVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/admin")
public class AdminResourcesController {

	@Autowired
	AdminResourcesService adminResourcesService;
	
	@Autowired
	MtrResveService mtrResveService;
	
	@Autowired
	CarResveService carResveService;

	// 회의실 목록 불러오기
	@GetMapping("/mtrs")
	public List<MtrVO> getMtrList() {
		return adminResourcesService.getMtrList();
	}
	
	// 특정 회의실 정보 불러오기
	@GetMapping("/mtr/{mtrNo}")
	public MtrVO getMtr(@PathVariable String mtrNo) {
		return mtrResveService.getMtrInfo(mtrNo);
	}

	// 회의실 추가
	@PostMapping("/mtr")
	public String createMtr(MtrVO mtrVO) {
		log.info("mtrVO : {}", mtrVO);
		
		int result = adminResourcesService.createMtr(mtrVO);
		if (result != 0) {
			return "success";
		}
		return "fail";
	}

	// 회의실 수정
	@PutMapping("/mtr")
	public String updateMtr(MtrVO mtrVO) {
		log.info("mtrVO : {}", mtrVO);

		int result = adminResourcesService.updateMtr(mtrVO);
		if (result != 0) {
			return "success";
		}
		return "fail";
	}
	
	// 회의실 삭제
	@DeleteMapping("/mtr/{mtrNo}")
	public String deleteMtr(@PathVariable String mtrNo) {
		int result = adminResourcesService.deleteMtr(mtrNo);
		if (result != 0) {
			return "success";
		}
		return "fail";
	}
	
	// 회의실 번호 생성
	@GetMapping("/mtrNo")
	public String createMtrNo() {
		String result = adminResourcesService.createMtrNo();
		log.info(result);
		
		return result;
	}

	// 차량 목록 불러오기
	@GetMapping("/cars")
	public List<CarVO> getCarList() {
		return adminResourcesService.getCarList();
	}
	
	// 특정 회의실 정보 불러오기
	@GetMapping("/car/{carNo}")
	public CarVO getCar(@PathVariable String carNo) {
		return carResveService.getCarInfo(carNo);
	}

	// 차량 추가
	@PostMapping("/car")
	public String createCar(CarVO carVO) {
		log.info("carVO : {}", carVO);
		
		int result = adminResourcesService.createCar(carVO);
		if (result != 0) {
			return "success";
		}
		return "fail";
	}
	
	// 차량 수정
	@PutMapping("/car")
	public String updateCar(CarVO carVO) {
		log.info("carVO : {}", carVO);
		log.info("carVOfile : {}", carVO.getUploadFile());

		int result = adminResourcesService.updateCar(carVO);
		if (result != 0) {
			return "success";
		}
		return "fail";
	}
	
	// 차량 삭제
	@DeleteMapping("/car/{carNo}")
	public String deleteCar(@PathVariable String carNo) {
		int result = adminResourcesService.deleteCar(carNo);
		if (result != 0) {
			return "success";
		}
		return "fail";
	}

}
