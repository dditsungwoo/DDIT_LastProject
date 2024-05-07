package com.team1.workforest.admin.reservation.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.team1.workforest.admin.reservation.service.AdminMtrResveService;
import com.team1.workforest.admin.reservation.util.ArticlePageForAdminResve;
import com.team1.workforest.reservation.meetingroom.vo.MtrReservationVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/admin")
public class AdminMtrResveController {

	@Autowired
	AdminMtrResveService adminMtrResveService;

	// 회의실 예약 목록 불러오기
	@GetMapping("/reservations/mtr")
	public ArticlePageForAdminResve<MtrReservationVO> adminGetMtrResveList(@RequestParam Map<String, String> params) {

		List<MtrReservationVO> mtrResveList = adminMtrResveService.adminGetMtrResveList(params);
		if(mtrResveList.size()==0) {
			mtrResveList.add(0,new MtrReservationVO());
		}
		
		log.info("mtrResveList : {}", mtrResveList);

		int total = mtrResveList.get(0).getTotal();
		log.info("list total : {}", total);
		int size = 10;
	
		String fName = "adminGetMtrResveList";
	
		ArticlePageForAdminResve<MtrReservationVO> data = new ArticlePageForAdminResve<MtrReservationVO>(total, size, mtrResveList, fName, params);

		return data;

	}

	// 지난 회의실 예약 목록 불러오기
	@GetMapping("/reservations/mtr/past")
	public ArticlePageForAdminResve<MtrReservationVO> adminGetPastMtrResveList(@RequestParam Map<String, String> params) {
		List<MtrReservationVO> pastMtrResveList = adminMtrResveService.adminGetPastMtrResveList(params);
		if(pastMtrResveList.size()==0) {
			pastMtrResveList.add(0,new MtrReservationVO());
		}
		int total = pastMtrResveList.get(0).getTotal();	
		log.info("list total : {}", total);
		int size = 10;
	
		String fName = "adminGetPastMtrResveList";
		
		ArticlePageForAdminResve<MtrReservationVO> data = new ArticlePageForAdminResve<MtrReservationVO>(total, size, pastMtrResveList, fName, params);
		
		return data;
	}

}
