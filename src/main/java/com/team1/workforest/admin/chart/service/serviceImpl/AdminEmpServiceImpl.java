package com.team1.workforest.admin.chart.service.serviceImpl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.admin.chart.mapper.AdminEmpMapper;
import com.team1.workforest.admin.chart.service.AdminEmpService;
import com.team1.workforest.admin.chart.vo.adminEmpVO;
import com.team1.workforest.vo.DepartmentVO;

@Service
public class AdminEmpServiceImpl implements AdminEmpService{

	@Autowired
	AdminEmpMapper adminEmpMapper;

	@Override
	public List<Integer> getAgeGraph(Map<String, String> map) {
		
		List<Integer> dataList = new ArrayList<Integer>();
		int data = 0;
		
		for(int i=5; i<=11; i++) {
			String start = (5*(i-1) + 1) + "";
			String end = 5*i + "";
			
			if(i == 11) {
				end = "100";
			}
			
			map.put("start", start);
			map.put("end", end);
			data = this.adminEmpMapper.getAgeGraph(map);
			dataList.add(data);
			
		}
		
		return dataList;
	}

	@Override
	public int getAvgAge(Map<String, String> map) {
		return this.adminEmpMapper.getAvgAge(map);
	}

	@Override
	public int getEmpCount(Map<String, String> map) {
		return this.adminEmpMapper.getEmpCount(map);
	}

	@Override
	public List<Integer> getGenderRate(Map<String, String> map) {
		List<Integer> dataList = new ArrayList<Integer>();
		
		map.put("gender", "1");
		int data = this.adminEmpMapper.getGenderRate(map);
		dataList.add(data);
		
		
		map.put("gender", "2");
		data = this.adminEmpMapper.getGenderRate(map);
		dataList.add(data);
		
		return dataList;
	}

	@Override
	public List<Integer> getRetireCount(Map<String, String> map) {
		
		List<Integer> dataList = new ArrayList<Integer>();
		
		map.put("retire", "3");
		int data = this.adminEmpMapper.getRetireCount(map);
		dataList.add(data);
		
		
		map.put("retire", "4");
		data = this.adminEmpMapper.getRetireCount(map);
		dataList.add(data);
		
		return dataList;
	}

	@Override
	public int getHireCount(Map<String, String> map) {
		return this.adminEmpMapper.getHireCount(map);
	}

	@Override
	public List<String> getDeptCount(Map<String, String> map) {
		List<String> dataList = new ArrayList<String>();
		
		List<String> deptNoList = this.adminEmpMapper.getDeptNo();
		
		String data = "";
		
		for(String deptNo : deptNoList) {
			map.put("deptNo", deptNo);
			data = deptNo + "_" + this.adminEmpMapper.getDeptCount(map);
			dataList.add(data);
		}
		
		return dataList;
	}

	@Override
	public List<DepartmentVO> getDeptName(Map<String, String> map) {
		return this.adminEmpMapper.getDeptName(map);
	}

	@Override
	public List<String> getRetireRate(Map<String, String> map) {
		List<String> dataList = new ArrayList<String>();
		
		String year = map.get("year");
		String month = "";
		String data = "";
		for(int i=1;i<=12;i++) {
			if(i<10) {
				month = year + "0" + i;
			}else {
				month = year + i;
			}
			map.put("month", month);
			data = this.adminEmpMapper.getRetireRate(map);
			dataList.add(data);
		}
		
		
		return dataList;
	}
	
	@Override
	public String getYearRetireRate(Map<String, String> map) {
		
		
		String year = map.get("year");
		String month = "";
		
		int data1 = 0;
		int data2 = 0;
		// 1년간 총 퇴사자 수
		data1 = this.adminEmpMapper.getYearRetireRate1(map);
		for(int i=1;i<=12;i++) {
			if(i<10) {
				month = year + "0" + i;
			}else {
				month = year + i;
			}
			map.put("month", month);
			// 매월 재직인원 평균
			data2 += this.adminEmpMapper.getYearRetireRate2(map);
			
		}
		data2 = data2/12;
		String res = (data1 * 10000 / data2)/100.0 + "";
		
		return res;
	}

	@Override
	public List<adminEmpVO> getPositionGraph(Map<String, String> map) {
		
		List<adminEmpVO> EmployeeVOList = this.adminEmpMapper.getPositionGraph(map);
		
		return EmployeeVOList;
	}

	@Override
	public List<adminEmpVO> getLocalCount(Map<String, String> map) {
		
		List<adminEmpVO> EmployeeVOList = this.adminEmpMapper.getLocalCount(map);
		
		return EmployeeVOList;
	}
	
	@Override
	public List<adminEmpVO> getWorkerCount(Map<String, String> map) {
		
		List<adminEmpVO> EmployeeVOList = this.adminEmpMapper.getWorkerCount(map);
		
		return EmployeeVOList;
	}
}
