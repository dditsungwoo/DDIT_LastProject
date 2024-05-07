package com.team1.workforest.reservation.meetingroom.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.team1.workforest.reservation.meetingroom.service.MtrResveService;
import com.team1.workforest.reservation.meetingroom.vo.MtrReservationVO;
import com.team1.workforest.reservation.meetingroom.vo.MtrVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api")
public class MtrResveController {
	
	@Autowired
	MtrResveService mtrResveService;	

	// 회의실 예약 리스트 불러오기
	@GetMapping("/reservations/mtr")
	public JSONArray getMtrResveList(MtrReservationVO mtrReservationVO) {
		return mtrResveService.getMtrResveList(mtrReservationVO);
	}	
	
	// 특정 예약 불러오기
	@GetMapping("/reservation/mtr/{mtrResveNo}")
	public MtrReservationVO getMtrResve(@PathVariable String mtrResveNo) {
		return mtrResveService.getMtrResve(mtrResveNo);
		
	}
	
	// 내 예약 리스트 불러오기
	@GetMapping("/reservations/mtr/{empNo}")
	public List<MtrReservationVO> getMyMtrResve(@PathVariable String empNo) {
		return mtrResveService.getMyMtrResve(empNo);
		
	}
	
	// 내 지난 예약 리스트 불러오기
	@GetMapping("/reservations/mtr/past/{empNo}")
	public List<MtrReservationVO> getMyPastMtrResve(@PathVariable String empNo) {
		return mtrResveService.getMyPastMtrResve(empNo);

	}
	
	// 회의실 예약 추가
	@PostMapping("/reservation/mtr")
	public String createMtrResve(@RequestBody MtrReservationVO mtrResveVO) {
		
		int result = mtrResveService.createMtrResve(mtrResveVO);
		
		if (result != 0) {
			return "success";
		}
		return "fail";	
	}
	// 회의실 예약 수정
	@PutMapping("/reservation/mtr/{mtrResveNo}")
	public String updateMtrResve(@PathVariable String mtrResveNo, @RequestBody MtrReservationVO mtrResveVO) {
		// 예약번호 vo에 추가
		mtrResveVO.setMtrResveNo(mtrResveNo);
		
		int result = mtrResveService.updateMtrResve(mtrResveVO);
		
		if (result != 0) {
			return "success";
		}
		return "fail";	
	}
	
	// 회의실 예약 취소
	@DeleteMapping("/reservation/mtr/{mtrResveNo}")
	public String deleteMtrResve(@PathVariable String mtrResveNo) {
		
		int result = mtrResveService.deleteMtrResve(mtrResveNo);
		
		if (result != 0) {
			return "success";
		}
		return "fail";	
	}
	
	// 회의실 정보 불러오기
	@GetMapping("/mtr/{mtrNo}")
	public MtrVO getMtrInfo(@PathVariable String mtrNo) {
		return mtrResveService.getMtrInfo(mtrNo);
	}
		
	// 예약된 시간 추출
	@GetMapping("/mtr/reservedTimes/{mtrNo}/{resveBeginDate}")
	public List<MtrReservationVO> getMtrResvedTimes(@PathVariable String mtrNo, @PathVariable String resveBeginDate) {
		Map<String, String> params = new HashMap<>();
		params.put("mtrNo", mtrNo);
		params.put("resveBeginDate", resveBeginDate);
		
		return mtrResveService.getMtrResvedTimes(params);
	}
	
	// 오늘의 회의실 예약 불러오기
	@GetMapping("/reservations/mtr/today")
	public List<MtrReservationVO> getTodayMtrResveList() {
		return mtrResveService.getTodayMtrResveList();
	}
	
	// 회의실 목록 불러오기
	@GetMapping("/mtrs")
	public List<MtrVO> getMtrs() {
		return mtrResveService.getMtrs();
	}

}
