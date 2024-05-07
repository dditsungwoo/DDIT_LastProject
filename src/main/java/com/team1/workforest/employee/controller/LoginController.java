package com.team1.workforest.employee.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.HtmlEmail;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.team1.workforest.crawling.service.NewsService;
import com.team1.workforest.crawling.vo.NewsVO;
import com.team1.workforest.dashboard.vo.DashboardVO;
import com.team1.workforest.employee.service.EmployeeService;
import com.team1.workforest.employee.vo.EmployeeVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class LoginController {
	@Autowired
	NewsService newsService;

	@Autowired
	EmployeeService empService;

	// 비밀번호 암호화 의존성 주입
	@Autowired
	PasswordEncoder passwordEncoder;

	// 로그인 전 main
	@GetMapping("/")
	public String login() {
		return "emp/login";
	}

	// 로그인
	@PostMapping("/login")
	public String login(@RequestParam("username") String username, @RequestParam("password") String password) {
		log.info(username);
		log.info(password);
		
		if (username.equals("user") && password.equals("password")) {
			
			return "loginSuccess";
		} else {
			return "redirect:/?error";
		}
	}

	// 로그인 후 main
	@GetMapping("/home")
	public String home(HttpSession session, Model model, HttpServletResponse response,
			@RequestParam(value = "drag", required = false, defaultValue = "0") String drag) throws IOException {
		String empNo = (String) session.getAttribute("empNo");
		if (empNo == null) {
	        response.sendRedirect("/"); 
	        return null; 
	    } else {
		EmployeeVO empVO = empService.detail(empNo);
		model.addAttribute("empVO", empVO);
		//home에 기사div
        List<NewsVO> newsList = newsService.getNewsDatas();
        //home에 dashboard정렬
        DashboardVO dashboardVO = this.newsService.getDashboard(empVO);
        log.info("home->dashboardVO : " + dashboardVO);
        
        model.addAttribute("newsList", newsList);
        model.addAttribute("drag", drag);
        model.addAttribute("dashboardVO", dashboardVO);
		return "home";
	}
	}

	// 비밀번호 찾기 페이지
	@GetMapping("/findPw")
	public String findPw() {
		return "emp/findPw";
	}

	// 비밀번호 찾기-임시비밀번호 발송+ 비밀번호로 update
	@PostMapping("/findPw")
	public String findPw(@RequestParam("empNo") String empNo, @RequestParam("email") String email,
			RedirectAttributes redirectAttributes) {

		EmployeeVO empVO = new EmployeeVO();
		empVO.setEmpNo(empNo);
		empVO.setEmail(email);

		int result = empService.getMemberPass(empVO);

		log.info("result: {}", result);

		if (result == 1) {

			// 임시비빌번호가 저장될 변수
			String str = "";

			// 이메일 제목
			final String subject = "[WorkForest 관리자]임시 비밀번호 발급 메일입니다.";

			// 임시 비밀번호를 발급받기 위한 랜덤번호(0~9,A~Z 까지 추가하고 싶은 문자는 아래의 형식처럼 추가가능)
			char[] charSet = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E',
					'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y',
					'Z' };

			// 임시비밀번호 생성
			int idx = 0;
			for (int i = 0; i < 8; i++) {
				idx = (int) (charSet.length * Math.random());
				str += charSet[idx];
			}

			// 확인용 log
			log.info("str: {}", str); // 임시비밀번호

			// 이메일 발신시 보낼 메세지( str : 임시비밀번호)
			final String body = "임시비밀번호는 << " + str + " >> 입니다.";

			// 임시비밀번호 암호화
			String encodedPwd = this.passwordEncoder.encode(str);
			// 임시비밀번호 db에 저장
			empVO.setEmpPw(encodedPwd);
			empService.updatePass(empVO);

			// 확인용 log
			log.info("empPw: {}", empVO.getEmpPw()); // 암호화된 임시비밀번호

			try {

				// Mail Server 설정
				String charset = "utf-8";
				String hostSMTP = "smtp.naver.com";
				String hostSMTPid = "hjw3138";
				String hostSMTPpwd = "5LTYM4DUPJVM";

				// 보내는 사람
				String fromEmail = "hjw3138@naver.com";
				String fromName = "WorkForest 관리자";

				HtmlEmail mail = new HtmlEmail();
				mail.setDebug(true);
				mail.setCharset(charset);
				mail.setSSLOnConnect(true);
				mail.setHostName(hostSMTP);
				mail.setSmtpPort(465);
				mail.setAuthenticator(new DefaultAuthenticator(hostSMTPid, hostSMTPpwd));
				mail.setStartTLSEnabled(true);
				mail.addTo(email);
				mail.setFrom(fromEmail, fromName, charset);
				mail.setSubject(subject);
				mail.setHtmlMsg(body);
				mail.send();

			} catch (Exception e) {

				e.printStackTrace();

			}

			log.info("메일 발송 성공");
			return "emp/updPw";

		} else {

			log.info("메일 발송 실패");
			return "redirect:/findPw?error";

		}

	}
	
	
//	// 로그아웃
//		@GetMapping("/logout")
//		public String logout() {
//			return "emp/login";
//		}	
//	
	
	

}
