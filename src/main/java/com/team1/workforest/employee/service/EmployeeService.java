package com.team1.workforest.employee.service;

import java.util.List;
import java.util.Map;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.vo.DepartmentVO;

public interface EmployeeService {

	//사원 정보(내 정보)
	public EmployeeVO detail(String empNo);

	//내 정보 수정
	public int modDetail(EmployeeVO empVO);

	//비밀번호 수정
	public int modPass(EmployeeVO empVO);
	
	//주소록(사원목록)
	public List<EmployeeVO> list(Map<String, Object> map);
	
	//페이징에 필요 - 행 수
	public int getTotal(Map<String, Object> map);
	
	//조직도(jstree)
	public List<DepartmentVO> treeAjax();

	//비밀번호 찾기
	public int getMemberPass(EmployeeVO empVO);

	//임시비밀번호 설정
	public int updatePass(EmployeeVO empVO);

	
	public int getkeywordTotal(Map<String, Object> map);

	//관리자-사원등록
	public int addEmp(EmployeeVO empVO);

	//재직 구분 변경
	public int updWorkSeCd(EmployeeVO empVO);

	public String findSuperEmpNo(EmployeeVO empVO);

	public List<EmployeeVO> findCntcNo(EmployeeVO empVO);




	

}
