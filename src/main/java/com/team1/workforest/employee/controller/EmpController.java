package com.team1.workforest.employee.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team1.workforest.employee.service.EmployeeService;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.security.CustomUserDetailsService;
import com.team1.workforest.util.ArticlePageSearchOption;
import com.team1.workforest.vo.DepartmentVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/emp")
public class EmpController {

	@Autowired
	private CustomUserDetailsService userDetailsService;

	@Autowired
	EmployeeService empService;
	
//	@Autowired
//	DepartmentService deptService;

	// 비밀번호 암호화 의존성 주입
	@Autowired
	PasswordEncoder passwordEncoder;
	
	@GetMapping("/tree")
	public String tree() {
		
		return "emp/empTree";
	}

	// 주소록 - 사원리스트
	@GetMapping("/list")
	public String getList(Model model, Map<String, Object> map,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
			@RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
			@RequestParam(value = "searchOption", required = false, defaultValue = "") String searchOption) {

		// 페이지 번호
		map.put("currentPage", currentPage);
		map.put("keyword", keyword);
		map.put("searchOption", searchOption);

		// 전체 행의 수 (total)
		int total = this.empService.getkeywordTotal(map);
		log.info("total -> ", total);

		// 한 화면에 보여지는 행의 수 (기본 10행)
		int size = 10;

		List<EmployeeVO> empVOList = this.empService.list(map);
		log.info("list -> EmployeeVO : " + empVOList);

		ArticlePageSearchOption<EmployeeVO> data = new ArticlePageSearchOption<EmployeeVO>(total, currentPage, size,
				empVOList, keyword, searchOption);

		String url = "/emp/list";

		data.setUrl(url);
		model.addAttribute("data",
				new ArticlePageSearchOption<EmployeeVO>(total, currentPage, size, empVOList, keyword, searchOption));

		return "emp/list";

	}

	@ResponseBody
	@PostMapping("/list")
	public ArticlePageSearchOption<EmployeeVO> listAjax(@RequestBody(required = false) Map<String, Object> map) {

		if (map.get("keyword") == null) {
			map.put("keyword", "");
		}

		log.info("listAjax->map: " + map);

		List<EmployeeVO> empVOList = this.empService.list(map);
		log.info("list->empVOList : " + empVOList);

		int total = this.empService.getkeywordTotal(map);
		log.info("list->total : " + total);
		int size = 10;

		String currentPage = map.get("currentPage").toString();

		String keyword = map.get("keyword").toString();
		String searchOption = map.get("searchOption").toString();

		ArticlePageSearchOption<EmployeeVO> data = new ArticlePageSearchOption<EmployeeVO>(total,
				Integer.parseInt(currentPage), size, empVOList, keyword, searchOption);

		String url = "/emp/list";

		data.setUrl(url);

		return data;

	}

	// 사원 정보(내 정보)
	@GetMapping("/detail")
	public String detail(@RequestParam("empNo") String reqempNo, Model model, HttpSession session) {
		String loginEmpNo = (String) session.getAttribute("empNo");

		if (loginEmpNo == null || !loginEmpNo.equals(reqempNo)) {
			// 로그인한 사용자와 요청된 사용자가 다른 경우 처리
			return "redirect:/accessError";
		}

		EmployeeVO empVO = this.empService.detail(reqempNo);

		// 입사일, 생년월일 형식 지정
		String ecnyDate = empVO.getEcnyDate();
		String bdate = empVO.getBdate();

		if (ecnyDate != null) {
			LocalDate localEcnyDate = LocalDate.parse(ecnyDate, DateTimeFormatter.ofPattern("yyyyMMdd"));
			DateTimeFormatter ecnyDateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
			String formattedEcnyDate = localEcnyDate.format(ecnyDateFormatter);
			empVO.setEcnyDate(formattedEcnyDate);
		}

		if (bdate != null) {
			LocalDate localBdate = LocalDate.parse(bdate, DateTimeFormatter.ofPattern("yyyyMMdd"));
			DateTimeFormatter bdateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
			String formattedBdate = localBdate.format(bdateFormatter);
			empVO.setBdate(formattedBdate);
		}

		model.addAttribute("empVO", empVO);
		log.info("empVO: {}", empVO);

		// forwarding
		return "emp/empDetail";

	}

	// 내 정보 수정
	@ResponseBody
	@PostMapping("/modDetail")
	public int modDetail(@RequestBody EmployeeVO empVO, HttpSession session) {

		log.info("modDetail->empVO : " + empVO);

		if (empVO.getProflImageUrl() != null && !empVO.getProflImageUrl().isEmpty()) {
			String newProflImageUrl = empVO.getProflImageUrl();
			String cutProflImageUrl = newProflImageUrl.substring(newProflImageUrl.lastIndexOf("\\") + 1);

	        // 확장자 확인
	        String extension = cutProflImageUrl.substring(cutProflImageUrl.lastIndexOf('.') + 1).toLowerCase();
	        if (!Arrays.asList("jpg", "jpeg", "png", "gif").contains(extension)) {
	            // 이미지 확장자가 아닌 경우 기존 이미지로 설정
	            String originalProflImageUrl = (String) session.getAttribute("proflImageUrl");
	            empVO.setProflImageUrl(originalProflImageUrl);
	            return -1;
	        } else {
	            empVO.setProflImageUrl(cutProflImageUrl);
	        }
		} else {
			String originalProflImageUrl = (String) session.getAttribute("proflImageUrl");
			empVO.setProflImageUrl(originalProflImageUrl);
		}

		int result = this.empService.modDetail(empVO);
		session.setAttribute("proflImageUrl", empVO.getProflImageUrl());
		log.info("modDetail : " + result);

		return result;

	}

	// 비밀번호 수정
	@GetMapping("/modPass")
	public String modPass(Model model, HttpSession session) {
		model.addAttribute("empNo", session.getAttribute("empNo"));
		return "emp/modPass";
	}

	// 비밀번호 수정
	@ResponseBody
	@PostMapping("/modPass")
	public int modPass(@RequestBody EmployeeVO empVO) {

		log.info("modPass->empVO : " + empVO);

		// 새로운 비밀번호가 입력된 경우 db에 암호화해서 저장
		if (empVO.getEmpPw() != null && !empVO.getEmpPw().isEmpty()) {
			String newPw = empVO.getEmpPw();
			String encodedPw = passwordEncoder.encode(newPw);
			empVO.setEmpPw(encodedPw);
		}

		int result = this.empService.modPass(empVO);
		log.info("modDetail : " + result);

		return result;

	}

	// 조직도
//	@GetMapping("/tree")
//	public String treeList() {
//		return "emp/empTree";
//
//	}

	// 조직도(jstree)
	@ResponseBody
	@GetMapping("/treeAjax")
	public List<DepartmentVO> treeAjax() {

		log.info("treeAjax");
		List<DepartmentVO> deptVOList = this.empService.treeAjax();
		for (int i = 0; i < deptVOList.size(); i++) {
			if (deptVOList.get(i).getUpperDept() == null) {
				deptVOList.get(i).setUpperDept("#");
			}
		}
		return deptVOList;
	}

	// 내정보페이지 가기 전에 비밀번호 확인
	@GetMapping("/detailLogin")
	public String detailLogin() {
		return "emp/detailLogin";
	}

	// 내정보페이지 가기 전에 비밀번호 확인
	@PostMapping("/detailLogin")
	public String detailLogin(@RequestParam("password") String password, HttpSession session) {

		String empNo = (String) session.getAttribute("empNo");
		log.info("empNo:{}", empNo);

		EmployeeVO empVO = empService.detail(empNo);
		String empPw = empVO.getEmpPw();
		log.info("empPw:{}", empPw);

		if (passwordEncoder.matches(password, empPw)) {

			// 비밀번호 일치 시 emp/detail 페이지로 이동
			return "redirect:/emp/detail?empNo=" + session.getAttribute("empNo");
		} else {
			return "redirect:/emp/detailLogin?error";
		}
	}

	//상급자 사번 구하기
		@ResponseBody
		@PostMapping("/findSuperEmpNo")
		public String findSuperEmpNo(@RequestBody EmployeeVO empVO) {
			String superEmpNo = this.empService.findSuperEmpNo(empVO);
			log.info("superEmpNo:", superEmpNo);
			return superEmpNo;
		}
	

}
