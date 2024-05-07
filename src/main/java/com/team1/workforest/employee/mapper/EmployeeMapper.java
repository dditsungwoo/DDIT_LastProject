package com.team1.workforest.employee.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.vo.DepartmentVO;

public interface EmployeeMapper {

	//사원 정보(내 정보)
	public EmployeeVO detail(String empNo);
	
	//내 정보 수정
	public int modDetail(EmployeeVO empVO);
	
	//비밀번호 수정
	public int modPass(EmployeeVO empVO);

	//주소록
	public List<EmployeeVO> list(Map<String, Object> map);

	//페이징에 필요 - 행 수
	public int getTotal(Map<String, Object> map);

	//조직도(jstree)
	public List<DepartmentVO> treeAjax();

	//비밀번호 찾기
	public int getMemberPass(EmployeeVO empVO);

	//임시비밀번호 설정
	public int updatePass(EmployeeVO empVO);

	//검색 페이징
	public int getkeywordTotal(Map<String, Object> map);

	//관리자-사원등록
	public int addEmp(EmployeeVO empVO);

	//관리자-사원등록-권한부여
	public int addEmpAuth(EmployeeVO empVO);
	
	//재직 구분 변경
	public int updWorkSeCd(EmployeeVO empVO);

	//재직 구분 변경 - 퇴직 시 계정 활성화여부 변경(1->0)
	public int updEnabled(EmployeeVO empVO);

	//재직 구분 변경 - 복직 시 계정 활성화여부 변경(0->1)
	public int updEnabled2(EmployeeVO empVO);

	public String findSuperEmpNo(EmployeeVO empVO);

	public List<EmployeeVO> findCntcNo(EmployeeVO empVO);

	

}
