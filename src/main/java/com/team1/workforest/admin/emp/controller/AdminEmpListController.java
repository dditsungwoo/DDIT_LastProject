package com.team1.workforest.admin.emp.controller;

import java.util.List;
import java.util.Map;

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

import com.team1.workforest.employee.service.DepartmentService;
import com.team1.workforest.employee.service.EmployeeService;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.project.vo.ProjectDutyVO;
import com.team1.workforest.util.ArticlePageSearchOption;
import com.team1.workforest.vo.DepartmentVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/admin")
@Controller
public class AdminEmpListController {
	@Autowired
	PasswordEncoder passwordEncoder;

	@Autowired
	EmployeeService empService;

	@Autowired
	DepartmentService deptService;

	// 관리자 사원목록 메인
//	@GetMapping("/main")
//	public String empList() {
//		return "admin/empList";
//	}

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

		String url = "/admin/empList";

		data.setUrl(url);
		model.addAttribute("data",
				new ArticlePageSearchOption<EmployeeVO>(total, currentPage, size, empVOList, keyword, searchOption));

		return "admin/empList";

	}

	@ResponseBody
	@PostMapping("/list")
	public ArticlePageSearchOption<EmployeeVO> listAjax(@RequestBody(required = false) Map<String, Object> map) {
		log.info("map: " + map);

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

		String url = "/admin/empList";

		data.setUrl(url);

		return data;

	}

	// 사원등록
	@PostMapping("/addEmp")
	public String addEmp(EmployeeVO empVO) {
	    log.info("empVO : " + empVO);

	    // 비밀번호는 암호화해서 저장
	    String empPw = empVO.getEmpPw();
	    log.info("empPw : " + empPw);
	    String encodedPw = passwordEncoder.encode(empPw);
	    empVO.setEmpPw(encodedPw);
	    int result = this.empService.addEmp(empVO);
	    log.info("addEmp->result : " + result);
	    log.info("empVO후 : " + empVO);

	    return "redirect:/admin/list";
	}

	// 재직 구분 변경
	@PostMapping("/updEmp")
	@ResponseBody
	public int updEmp(@RequestBody EmployeeVO empVO) {
		log.info("empVO:{}", empVO);
		int result = this.empService.updWorkSeCd(empVO);
		log.info("updWorkSeCd->result : " + result);

		return result;
		// return null;
	}

	// 부서명 자동완성 /admin/findDeptByName
	// 이름을 자동완성하는 함수
	@ResponseBody
	@PostMapping("/findDeptByName")
	public List<DepartmentVO> findEmpByName(@RequestBody DepartmentVO deptVO) {
		List<DepartmentVO> list = this.deptService.findEmpByName(deptVO);
		log.info("findDeptByName =>" + list);
		return list;

	}

	// 부서 관리- 목록
	@GetMapping("/deptList")
	public String getDeptList(Model model) {
		List<DepartmentVO> deptVOList = this.deptService.deptList();
		log.info("DepartmentVO: {}", deptVOList);
		model.addAttribute("deptVOList", deptVOList);
		return "admin/deptList";
	}

	// 부서번호 부여
	@ResponseBody
	@PostMapping("/findMyDeptNo")
	public String findMyDeptNo(@RequestBody DepartmentVO deptVO) {
		log.info("deptVO:{}", deptVO);
		String MyDeptNo = this.deptService.findMyDeptNo(deptVO);
		log.info("MyDeptNo:", MyDeptNo);
		return MyDeptNo;
	}

	// 부서 등록
	@PostMapping("/addDept")
	public String addDept(DepartmentVO deptVO) {
		log.info("deptVO: " + deptVO);

		int result = this.deptService.addDept(deptVO);
		log.info("addDept->result : " + result);

		return "redirect:/admin/deptList";
	}

	// 부서 수정
	@PostMapping("/modDept")
	public String modDept(DepartmentVO deptVO) {
		log.info("deptVO: " + deptVO);

		int result = this.deptService.modDept(deptVO);
		log.info("modDept->result : " + result);

		return "redirect:/admin/deptList";
	}

	// 부서 삭제
	@PostMapping("/delDept")
	public String delDept(DepartmentVO deptVO) {
		log.info("deptVO: " + deptVO);

		int result = this.deptService.delDept(deptVO);
		log.info("delDept->result : " + result);

		return "redirect:/admin/deptList";
	}
	
	
	    //문서발급관리 메인
//		@GetMapping("/docMain")
//		public String docMain() {
//			return "admin/docMain";
//		}

}
