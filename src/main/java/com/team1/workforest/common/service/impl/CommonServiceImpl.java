package com.team1.workforest.common.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.common.mapper.CommonMapper;
import com.team1.workforest.common.service.CommonService;
import com.team1.workforest.employee.vo.EmployeeVO;

@Service
public class CommonServiceImpl implements CommonService{

	@Autowired
	CommonMapper commonMapper;
	
	@Override
	public EmployeeVO getEmpInfo(String empNo) {
		return commonMapper.getEmpInfo(empNo);
	}

}
