package com.team1.workforest.employee.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.employee.mapper.EmpAlramSetupMapper;
import com.team1.workforest.employee.service.EmpAlramSetupService;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.vo.UserSetupNtcnMatterVO;

@Service
public class EmpAlramSetupServiceImpl implements EmpAlramSetupService{

	@Autowired
	EmpAlramSetupMapper empAlramSetupMapper;
	
	@Override
	public List<UserSetupNtcnMatterVO> getAlramSetUpList(EmployeeVO empVo) {
		return this.empAlramSetupMapper.getAlramSetUpList(empVo);
	}

	@Override
	public int updateAlramSetUpList(Map<String, String> map) {
		int res = 0;
		for(int i=1;i<=5;i++) {
			String setupSe = map.get("data"+i);
			map.put("setupNtcnNo", i + "");
			map.put("ntcnYnCd", setupSe);
			res += this.empAlramSetupMapper.updateAlramSetUpList(map);
		}
		
		return res;
	}

}
