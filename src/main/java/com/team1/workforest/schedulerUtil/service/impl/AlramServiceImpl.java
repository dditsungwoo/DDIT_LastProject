package com.team1.workforest.schedulerUtil.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.schedulerUtil.mapper.AlramMapper;
import com.team1.workforest.schedulerUtil.service.AlramService;
import com.team1.workforest.vo.NotificationVO;

@Service
public class AlramServiceImpl implements AlramService{

	@Autowired
	AlramMapper alramMapper;
	
	@Override
	public int updateAlramYN(EmployeeVO empVo) {
		return this.alramMapper.updateAlramYN(empVo);
	}
	
	public String getAlramCount(Map<String, String> map) {
		return this.alramMapper.getAlramCount(map);
	}

	public int addAlram(Map<String, String> map) {
		return this.alramMapper.addAlram(map);
	}

	@Override
	public List<NotificationVO> getAlramList(EmployeeVO empVo) {
		
		List<NotificationVO> voList = this.alramMapper.getAlramList(empVo);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		String formatTime = "";
		
		for(NotificationVO vo:voList) {
			Date date = vo.getRcveDate();
			formatTime = formatter.format(date);
			vo.setFormatTime(formatTime);
			
		}
		
		return this.alramMapper.getAlramList(empVo);
	}

	@Override
	public String getEmpDutyYN(EmployeeVO empVo) {
		return this.alramMapper.getEmpDutyYN(empVo);
	}

	@Override
	public String getEmpApvYN(EmployeeVO empVo) {
		return this.alramMapper.getEmpApvYN(empVo);
	}

	@Override
	public int updateAlramSeeYN(Map<String, String> map) {
		return this.alramMapper.updateAlramSeeYN(map);
	}

}
