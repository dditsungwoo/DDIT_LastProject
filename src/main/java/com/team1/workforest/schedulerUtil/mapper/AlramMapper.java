package com.team1.workforest.schedulerUtil.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.vo.NotificationVO;

public interface AlramMapper {

	public String getAlramCount(Map<String, String> map);

	public int addAlram(Map<String, String> map);
	
	public int updateAlramYN(EmployeeVO empVo);

	public List<NotificationVO> getAlramList(EmployeeVO empVo);

	public String getEmpDutyYN(EmployeeVO empVo);

	public String getEmpApvYN(EmployeeVO empVo);

	public int updateAlramSeeYN(Map<String, String> map);

}
