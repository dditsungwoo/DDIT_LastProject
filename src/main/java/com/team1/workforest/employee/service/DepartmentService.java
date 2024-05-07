package com.team1.workforest.employee.service;

import java.util.List;

import com.team1.workforest.vo.DepartmentVO;

public interface DepartmentService {

	//부서 등록할 때 부서번호 자동부여
	public String findMyDeptNo(DepartmentVO deptVO);

	//부서 등록
	public int addDept(DepartmentVO deptVO);

	//부서 목록
	public List<DepartmentVO> deptList();

	//부서명 자동완성
	public List<DepartmentVO> findEmpByName(DepartmentVO deptVO);

	//부서 수정
	public int modDept(DepartmentVO deptVO);

	//부서 삭제
	public int delDept(DepartmentVO deptVO);

}
