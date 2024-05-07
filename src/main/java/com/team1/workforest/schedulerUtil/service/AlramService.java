package com.team1.workforest.schedulerUtil.service;

import java.util.List;
import java.util.Map;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.vo.NotificationVO;

public interface AlramService {

	public int updateAlramYN(EmployeeVO empVo);

	public String getAlramCount(Map<String, String> map);
	
	public int addAlram(Map<String, String> map);

	public List<NotificationVO> getAlramList(EmployeeVO empVo);

	public String getEmpDutyYN(EmployeeVO empVo);

	public String getEmpApvYN(EmployeeVO empVo);

	public int updateAlramSeeYN(Map<String, String> map);
	
}
