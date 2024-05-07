package com.team1.workforest.admin.reservation.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.team1.workforest.admin.reservation.service.AdminCarResveService;
import com.team1.workforest.admin.reservation.util.ArticlePageForAdminResve;
import com.team1.workforest.reservation.car.vo.CarReservationVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/admin")
public class AdminCarResveController {

	@Autowired
	AdminCarResveService adminCarResveService;

	// 차량 예약 목록 불러오기
	@GetMapping("/reservations/car")
	public ArticlePageForAdminResve<CarReservationVO> adminGetCarResveList(@RequestParam Map<String, String> params) {
		List<CarReservationVO> carResveList = adminCarResveService.adminGetCarResveList(params);
		if(carResveList.size()==0) {
			carResveList.add(0,new CarReservationVO());
		}
		
		log.info("carResveList : {}", carResveList);
	
		int total = carResveList.get(0).getTotal();
		log.info("list total : {}", total);
		int size = 10;
	
		String fName = "adminGetCarResveList";
	
		ArticlePageForAdminResve<CarReservationVO> data = new ArticlePageForAdminResve<CarReservationVO>(total, size, carResveList, fName, params);

		return data;
	}

	// 반납 처리해야하는 차량 목록 불러오기
	@GetMapping("/reservations/car/waitReturn")
	public ArticlePageForAdminResve<CarReservationVO> adminGetWaitReturnCarResveList(@RequestParam Map<String, String> params) {
		List<CarReservationVO> waitReturnCarResveList = adminCarResveService.adminGetWaitReturnCarResveList(params);
		if(waitReturnCarResveList.size()==0) {
			waitReturnCarResveList.add(0,new CarReservationVO());
		}
		
		log.info("waitReturnCarResveList : {}", waitReturnCarResveList);

		int total = waitReturnCarResveList.get(0).getTotal();
		log.info("list total : {}", total);
		int size = 10;
	
		String fName = "adminGetWaitReturnCarResveList";
		
		ArticlePageForAdminResve<CarReservationVO> data = new ArticlePageForAdminResve<CarReservationVO>(total, size, waitReturnCarResveList, fName, params);

		return data;
	}

	// 지난 차량 예약 목록 불러오기
	@GetMapping("/reservations/car/past")
	public ArticlePageForAdminResve<CarReservationVO> adminGetPastCarResveList(@RequestParam Map<String, String> params) {
		List<CarReservationVO> pastCarResveList = adminCarResveService.adminGetPastCarResveList(params);
		if(pastCarResveList.size()==0) {
			pastCarResveList.add(0,new CarReservationVO());
		}

		log.info("pastCarResveList : {}", pastCarResveList);

		int total = pastCarResveList.get(0).getTotal();
		log.info("list total : {}", total);
		int size = 10;
	
		String fName = "adminGetPastCarResveList";
		
		ArticlePageForAdminResve<CarReservationVO> data = new ArticlePageForAdminResve<CarReservationVO>(total, size, pastCarResveList, fName, params);

		return data;
	}

}
