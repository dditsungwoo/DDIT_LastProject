package com.team1.workforest.security;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.team1.workforest.employee.mapper.EmployeeMapper;
import com.team1.workforest.employee.vo.EmployeeVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CustomUserDetailsService implements UserDetailsService {
	
	//비밀번호 암호화 의존성 주입
	@Autowired
	PasswordEncoder passwordEncoder;
    
    @Autowired
    private EmployeeMapper empMapper;
    
    @Autowired
    private HttpServletRequest request;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // 사원 정보 검색(username : 로그인 시 입력받은 사번)
        EmployeeVO empVO = empMapper.detail(username);
        log.info("empVO : {}", empVO);

        if (empVO == null) {
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + username);
        }

        // CustomUser로 리턴
        return new CustomUser(empVO);
    }
    
    public EmployeeVO getEmployeeByUsername(String username) {
        return empMapper.detail(username);
    }
    
    public boolean authenticateEmployeePassword(String username, String password) {
        // 사용자의 입력 비밀번호와 데이터베이스에 저장된 비밀번호를 비교하여 일치 여부 확인
        EmployeeVO empVO = empMapper.detail(username);
        if (empVO != null) {
            // 데이터베이스에 저장된 비밀번호를 가져옴
            String storedPassword = empVO.getEmpPw();
            // 입력 비밀번호와 저장된 비밀번호를 비교
            return passwordEncoder.matches(password, storedPassword);
        }
        return false; // 사용자 정보가 없는 경우
    }
    
    
}
