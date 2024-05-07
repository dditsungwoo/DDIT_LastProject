package com.team1.workforest.employee.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.vo.DepartmentVO;

public interface DepartmentMapper {

	public String findMyDeptNo(DepartmentVO deptVO);

	public int addDept(DepartmentVO deptVO);

	public List<DepartmentVO> deptList();

	public List<DepartmentVO> findEmpByName(DepartmentVO deptVO);

	public int modDept(DepartmentVO deptVO);

	public int delDept(DepartmentVO deptVO);

}
