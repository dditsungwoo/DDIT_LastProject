package com.team1.workforest.employee.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.employee.mapper.EmployeeMapper;
import com.team1.workforest.employee.service.EmployeeService;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.vo.DepartmentVO;

@Service
public class EmpServiceImpl implements EmployeeService {
	
	@Autowired
	EmployeeMapper empMapper;

	//사원 정보(내 정보)
	@Override
	public EmployeeVO detail(String empNo) {
		return this.empMapper.detail(empNo);
	}

	//내 정보 수정
	@Override
	public int modDetail(EmployeeVO empVO) {
		return this.empMapper.modDetail(empVO);
	}
	
	//비밀번호 수정
	@Override
	public int modPass(EmployeeVO empVO) {
		return this.empMapper.modPass(empVO);
	}

	//주소록
	@Override
	public List<EmployeeVO> list(Map<String, Object> map) {
		return this.empMapper.list(map);
	}
	
	//페이징에 필요 - 행 수
	@Override
	public int getTotal(Map<String, Object> map) {
		return this.empMapper.getTotal(map);
	}

	//조직도(jstree)
	@Override
	public List<DepartmentVO> treeAjax() {
		return this.empMapper.treeAjax();
	}

	//비밀번호 찾기
	@Override
	public int getMemberPass(EmployeeVO empVO) {
		return this.empMapper.getMemberPass(empVO);
	}

	//임시비밀번호 설정
	@Override
	public int updatePass(EmployeeVO empVO) {
		return this.empMapper.updatePass(empVO);
		
	}

	//페이징
	@Override
	public int getkeywordTotal(Map<String, Object> map) {
		return this.empMapper.getkeywordTotal(map);
	}

	//관리자-사원등록
	@Override
	public int addEmp(EmployeeVO empVO) {
		int result= this.empMapper.addEmp(empVO);
		result+= this.empMapper.addEmpAuth(empVO);
		return result;

		
	}

	//재직 구분 변경
	@Override
	public int updWorkSeCd(EmployeeVO empVO) {
		int result= this.empMapper.updWorkSeCd(empVO);
		//재직 구분 변경 - 퇴직 시 계정 활성화여부 변경
		if(empVO.getWorkSeCd().equals("4")){			
		result+= this.empMapper.updEnabled(empVO);
	}
		//재직 구분 변경 - 복직 시 계정 활성화여부 변경
		if(empVO.getWorkSeCd().equals("1")) {
			result+= this.empMapper.updEnabled2(empVO);
		}
		return result;
	}

	@Override
	public String findSuperEmpNo(EmployeeVO empVO) {
		return this.empMapper.findSuperEmpNo(empVO);
	}

	@Override
	public List<EmployeeVO> findCntcNo(EmployeeVO empVO) {
		return this.empMapper.findCntcNo(empVO);
	}

	

	 



	

}
