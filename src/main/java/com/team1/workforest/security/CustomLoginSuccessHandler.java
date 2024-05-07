package com.team1.workforest.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;

import com.team1.workforest.employee.vo.EmployeeVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomLoginSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {
	
	@Autowired
    private CustomUserDetailsService userDetailsService;
    
    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication auth) throws ServletException, IOException {

        log.warn("onAuthenticationSuccess");
        
        // auth.getPrincipal() : 사용자 정보를 가져옴
        // 시큐리티에서 사용자 정보는 User 클래스의 객체로 저장됨(CustomUser.java를 참고)
        User customUser = (User) auth.getPrincipal();
        
        // 사용자 아이디를 리턴
        log.info("username : " + customUser.getUsername());
        
        List<String> roleNames = new ArrayList<String>();
        auth.getAuthorities().forEach(authority -> {
            roleNames.add(authority.getAuthority());
        });
    
        
      // 사용자의 empVO 가져오기
        EmployeeVO empVO = userDetailsService.getEmployeeByUsername(customUser.getUsername());
        if (empVO != null) {
        	
            // 세션에 필요한 값 저장
            HttpSession session = request.getSession();
           // session.setAttribute("empVO", empVO);
            session.setAttribute("empNo", customUser.getUsername()); //사원번호
            session.setAttribute("empNm", empVO.getEmpNm());  //사원명
            session.setAttribute("deptNm", empVO.getDeptNm());  //부서명
            session.setAttribute("position", empVO.getPosition());  //직급
            session.setAttribute("rspnsblCtgryNm", empVO.getRspnsblCtgryNm());  //직책
            session.setAttribute("proflImageUrl", empVO.getProflImageUrl());  //프로필이미지
            session.setAttribute("deptNo",empVO.getDeptNo()); //부서명
            session.setAttribute("rspnsblCd",empVO.getRspnsblCd()); //직책코드
            
            
            //값 확인
            log.info("Session : empNo={}, empNm={}, deptNm={}, position={}, rspnsblCtgryNm={}", customUser.getUsername(), empVO.getEmpNm(), empVO.getDeptNo(), empVO.getPosition(), empVO.getRspnsblCtgryNm());
       
        }

        // 부모 클래스의 메서드를 호출하여 원래의 동작을 수행
        //super.onAuthenticationSuccess(request, response, auth);
        response.sendRedirect(request.getContextPath() + "/home");
      
        
    }
}
