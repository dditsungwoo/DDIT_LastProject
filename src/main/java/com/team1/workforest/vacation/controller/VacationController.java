package com.team1.workforest.vacation.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.vacation.service.VacationService;
import com.team1.workforest.vacation.vo.EmpVacationManageVO;
import com.team1.workforest.vacation.vo.VacationRecordVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api")
public class VacationController {
	
	@Autowired
	VacationService vacationService;
	
	// 내 휴가 목록(잔여 휴가 개수) 가져오기
	@GetMapping("/vacations") 
	public List<EmpVacationManageVO> getMyVacationList(EmpVacationManageVO empVcatnManageVO) {
		return vacationService.getMyVacationList(empVcatnManageVO);	
	}
	
	// 내 특정 휴가 정보 가져오기
	@GetMapping("/vacation")
	public EmpVacationManageVO getMyVacation(EmpVacationManageVO empVcatnManageVO) {
		log.info("empVcatnManageVO : {}", empVcatnManageVO);
		return vacationService.getMyVacation(empVcatnManageVO);
	}
	
	// 결재 라인 불러오기
	@GetMapping("/vacation/apvLine/{empNo}/{apvLevel}")
	public List<EmployeeVO> getApvLine(@PathVariable String empNo, @PathVariable int apvLevel) {
		return vacationService.getApvLine(empNo,apvLevel);
	}
	
	// 휴가 기록 가져오기
	@GetMapping("/vacations/record")
	public Map<Integer, List<VacationRecordVO>> getMyVacationRecordList(VacationRecordVO vacationRecordVO) {		
		return vacationService.getMyVacationRecordList(vacationRecordVO);
	}
	
	// 사용 연차 카운트(종일연차, 반차)
	@GetMapping("/vacations/count")
	public float getVacationRecordsCount(VacationRecordVO vacationRecordVO) {
		return vacationService.getVacationRecordsCount(vacationRecordVO);
	}
	
	// 휴가 신청
	@PostMapping("/vacation")
	public String createVacation(VacationRecordVO vacationRecordVO) {		
		int result = vacationService.createVacation(vacationRecordVO);
		
		if (result != 0) {
			return "success";
		}

		return "fail";
	}
	
	// 휴가 삭제
	@DeleteMapping("/vacation/{apvNo}")
	public String deleteVacation(@PathVariable int apvNo) {
		int result = vacationService.deleteVacation(apvNo);
		
		if (result != 0) {
			return "success";
		}

		return "fail";
	}
	
}
