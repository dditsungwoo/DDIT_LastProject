package com.team1.workforest.common.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.team1.workforest.common.service.CommonService;
import com.team1.workforest.employee.vo.EmployeeVO;

@RestController
public class CommonController {

	@Autowired
	CommonService commonService;

	// 직원 정보 불러오기
	@GetMapping("/empInfo/{empNo}")
	public EmployeeVO getEmpInfo(@PathVariable String empNo) {
		return commonService.getEmpInfo(empNo);
	}
}
