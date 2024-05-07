package com.team1.workforest.admin.chart.service.serviceImpl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.admin.chart.mapper.AdminProjectMapper;
import com.team1.workforest.admin.chart.service.AdminProjectService;
import com.team1.workforest.admin.chart.vo.adminEmpVO;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.project.vo.ProjectDutyVO;
import com.team1.workforest.project.vo.ProjectVO;

@Service
public class AdminProjectServiceImpl implements AdminProjectService{

	@Autowired
	AdminProjectMapper adminProjectMapper;
	
	@Override
	public List<String> getProjectCount() {
		
		List<String> dataList = new ArrayList<String>();
		Map<String, String> map = new HashMap<String, String>();
		
		map.put("sttusCd", "1");
		String data = "1_" + this.adminProjectMapper.getProjectCount(map);
		dataList.add(data);
		
		map.put("sttusCd", "2");
		data = "2_" + this.adminProjectMapper.getProjectCount(map);
		dataList.add(data);
		
		map.put("sttusCd", "3");
		data = "3_" +  this.adminProjectMapper.getProjectCount(map);
		dataList.add(data);
		
		map.put("sttusCd", "4");
		data = "4_" +  this.adminProjectMapper.getProjectCount(map);
		dataList.add(data);
		
		return dataList;
	}

	@Override
	public List<adminEmpVO> getEnableEmp() {
		return this.adminProjectMapper.getEnableEmp();
	}

	@Override
	public List<String> getMonthNewProj(Map<String, String> map) {
		
		List<String> dataList = new ArrayList<String>();
		String year = map.get("year");
		String month = "";
		// 1~12월까지
		for(int i=1;i<=12;i++) {
			if(i<10) {
				month = "0" + i;
			}else {
				month = "" + i;
			}
			
			map.put("month", year + month);
			String data = month + "_" +  this.adminProjectMapper.getMonthNewProj(map);
			dataList.add(data);
		}
		
		return dataList;
	}

	@Override
	public List<String> getMonthEndProj(Map<String, String> map) {
		List<String> dataList = new ArrayList<String>();
		String year = map.get("year");
		String month = "";
		// 1~12월까지
		for(int i=1;i<=12;i++) {
			if(i<10) {
				month = "0" + i;
			}else {
				month = "" + i;
			}
			
			map.put("month", year + month);
			String data = month + "_" + this.adminProjectMapper.getMonthEndProj(map);
			dataList.add(data);
		}
		
		return dataList;
	}

	@Override
	public List<String> getProceedPeriod() {
		List<String> dataList = new ArrayList<String>();
		Map<String, String> map = new HashMap<String, String>();
		String data = "";
		String begin = "";
		String end = "";
		for(int i=0; i<5; i++) {
			begin = (i*15 + 1) + "";
			end = ((i+1)*15) + "";
			map.put("begin", begin);
			map.put("end", end);
			if(i==4) {
				map.put("end", "9999");
			}
			data = begin + "-" + end + "_" + this.adminProjectMapper.getProceedPeriod(map);
			dataList.add(data);
		}
		
		return dataList;
	}

	@Override
	public List<ProjectVO> getProjects() {
		return this.adminProjectMapper.getProjects();
	}

	@Override
	public List<EmployeeVO> getProjectEmp(ProjectVO pVo) {
		return this.adminProjectMapper.getProjectEmp(pVo);
	}

	@Override
	public List<ProjectDutyVO> getEmpPjDuty(ProjectVO pVo) {
		return this.adminProjectMapper.getEmpPjDuty(pVo);
	}

}
