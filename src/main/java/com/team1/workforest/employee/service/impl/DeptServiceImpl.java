package com.team1.workforest.employee.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.employee.mapper.DepartmentMapper;
import com.team1.workforest.employee.service.DepartmentService;
import com.team1.workforest.vo.DepartmentVO;
@Service
public class DeptServiceImpl implements DepartmentService {
	
	@Autowired
	DepartmentMapper deptMapper;

	@Override
	public String findMyDeptNo(DepartmentVO deptVO) {
		return this.deptMapper.findMyDeptNo(deptVO);
	}

	@Override
	public int addDept(DepartmentVO deptVO) {
		return this.deptMapper.addDept(deptVO);
	}

	@Override
	public List<DepartmentVO> deptList() {
		return this.deptMapper.deptList();
	}

	@Override
	public List<DepartmentVO> findEmpByName(DepartmentVO deptVO) {
		return this.deptMapper.findEmpByName(deptVO);
	}

	@Override
	public int modDept(DepartmentVO deptVO) {
		return this.deptMapper.modDept(deptVO);
	}

	@Override
	public int delDept(DepartmentVO deptVO) {
		return this.deptMapper.delDept(deptVO);
	}

}
