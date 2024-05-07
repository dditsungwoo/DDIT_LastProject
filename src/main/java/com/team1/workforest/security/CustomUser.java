package com.team1.workforest.security;

import java.util.Collection;
import java.util.Collections;
import java.util.stream.Collectors;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import com.team1.workforest.employee.vo.EmployeeVO;

public class CustomUser extends User{
	
	private EmployeeVO empVO;
	
	// USER의 생성자를 처리해주는 생성자
	public CustomUser(String username, String password
				, Collection<? extends GrantedAuthority> authorities) {
		super(username, password, authorities);
	}

	// 생성자.return empVO == null?null:new CustomUser(empVO);
	//public CustomUser(EmployeeVO empVO) {
		//사용자가 정의한 (select한) EmployeeVO 타입의 객체 empVO를
		//스프링 시큐리티에서 제공해주고 있는 UsersDetails 타입으로 변환
		// 회원정보를 보내서 스프링이 관리
	public CustomUser(EmployeeVO empVO) {
	    super(empVO.getEmpNo() + "", empVO.getEmpPw(),
	            empVO.getEmpAuthVOList() != null ? 
	            empVO.getEmpAuthVOList().stream()
	                .map(auth -> new SimpleGrantedAuthority(auth.getAuth()))
	                .collect(Collectors.toList()) 
	            : Collections.emptyList()
	    );
	    this.empVO = empVO;
	}
	
	public EmployeeVO getEmpVO() {
		return empVO;
	}
	
	public void setEmpVO(EmployeeVO empVO) {
		this.empVO = empVO;
	}
}
