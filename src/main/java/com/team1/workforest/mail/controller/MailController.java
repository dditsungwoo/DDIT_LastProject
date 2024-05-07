package com.team1.workforest.mail.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.team1.workforest.common.service.CommonService;
import com.team1.workforest.employee.service.EmployeeService;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.mail.service.MailService;
import com.team1.workforest.mail.vo.EmailRecipientVO;
import com.team1.workforest.mail.vo.EmailVO;
import com.team1.workforest.project.service.ProjectService;
import com.team1.workforest.project.vo.ProjectDutyVO;
import com.team1.workforest.util.ArticlePage;
import com.team1.workforest.vo.AttachedFileVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/mail")
public class MailController {

	@Autowired
	MailService mailService;

	@Autowired
	EmployeeService empService;

	@Autowired
	ProjectService projectService;

	@Autowired
	CommonService commonService;

	//home.jsp 메일 ajax
	
	
	// 메일 메인화면 (받은 메일 출력)
	@GetMapping("/main")
	public String getMainList(Model model, HttpServletRequest request,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage) {

		Map<String, Object> map = new HashMap<String, Object>();
		// 세션을 통해 사용자 이름 가져오기
		HttpSession session = request.getSession();
		String empNo = (String) session.getAttribute("empNo");

		// 페이지 번호
		map.put("currentPage", currentPage);
		map.put("empNo", empNo);

		log.info("map : " + map);
		// 한 화면에 보여지는 행의 수 (기본 10행)
		int size = 10;

		// 각 메일함 메일 수
		// 임시보관함
		int tempCount = this.mailService.getTemporaryMailCount(map);
		// 보낸메일함
		int sendCount = this.mailService.getSendMailCount(map);
		// 받은메일함
		int getCount = this.mailService.getMailCount(map);
		// 읽지않은메일
		int noreadCount = this.mailService.getNoreadCount(map);
		// 휴지통
		int deleteCount = this.mailService.getDeleteCount(map);
		// 첨부파일 메일
		int attachCount = this.mailService.getAttachMailCount(map);

		List<EmailVO> emailVOList = this.mailService.getMailList(map);
		log.info("list -> emailVOList : " + emailVOList);

		model.addAttribute("emaildata", new ArticlePage<EmailVO>(getCount, currentPage, size, emailVOList, null));
		model.addAttribute("size", size);
		model.addAttribute("getCount", getCount);
		model.addAttribute("noreadCount", noreadCount);
		model.addAttribute("tempCount", tempCount);
		model.addAttribute("sendCount", sendCount);
		model.addAttribute("deleteCount", deleteCount);
		model.addAttribute("attachCount", attachCount);
		return "mail/main";
	}

	// 메일 상세보기
	@GetMapping("/detail/{mailbox}/{emailNo}")
	public String getMailDetail(Model model, @PathVariable("mailbox") String mailbox,
			@PathVariable("emailNo") String emailNo,
			@RequestParam(value = "prevMailNo", required = false) String prevMailNo,
			@RequestParam(value = "nextMailNo", required = false) String nextMailNo, HttpSession session,
			EmailVO emailVO) {
		log.info("emailVO : " + emailVO);
		log.info("get {prevMailNo, nextMailNo} : " + prevMailNo + "," + nextMailNo);
		EmailVO pEmailVO = new EmailVO();
		EmailVO nEmailVO = new EmailVO();
		EmployeeVO empVO = new EmployeeVO();
		Map<String, Object> map = new HashMap<String, Object>();
		String empNo = (String) session.getAttribute("empNo");
		map.put("empNo", empNo);
		emailVO.setEmpNo(empNo);
		emailVO.setEmailNo(emailNo);
		pEmailVO.setEmpNo(empNo);
		pEmailVO.setEmailNo(prevMailNo);
		nEmailVO.setEmpNo(empNo);
		nEmailVO.setEmailNo(nextMailNo);
		AttachedFileVO attachFileVO = new AttachedFileVO();
		int updateCnfirmDate = 0;
		switch (mailbox) {
		case "main":
			// 보낸 사람 직책 commonservice로 가져오기
			log.info("mainEmail check");
			updateCnfirmDate = this.mailService.putCnfirmDate(emailVO);
			emailVO = this.mailService.getMailDetail(emailNo);
			pEmailVO = this.mailService.getMailDetail(prevMailNo);
			nEmailVO = this.mailService.getMailDetail(nextMailNo);
			model.addAttribute("mailbox", "mailbox");
			break;
		case "sendbox":
			// 본인 직책 세션에서 가져오기
			log.info("sendEmail check");
			emailVO = mailService.getSendMailDetail(emailNo);
			pEmailVO = this.mailService.getSendMailDetail(prevMailNo);
			nEmailVO = this.mailService.getSendMailDetail(nextMailNo);
			model.addAttribute("mailbox", "sendbox");
			break;
		case "attachbox":
			// 보낸 사람 직책 commonservice로 가져오기
			updateCnfirmDate = this.mailService.putCnfirmDate(emailVO);
			emailVO = this.mailService.getMailDetail(emailNo);
			pEmailVO = this.mailService.getMailDetail(prevMailNo);
			nEmailVO = this.mailService.getMailDetail(nextMailNo);
			model.addAttribute("mailbox", "attachbox");
			break;
		case "unreadbox":
			// 보낸 사람 직책 commonservice로 가져오기
			updateCnfirmDate = this.mailService.putCnfirmDate(emailVO);
			emailVO = this.mailService.getMailDetail(emailNo);
			pEmailVO = this.mailService.getMailDetail(prevMailNo);
			nEmailVO = this.mailService.getMailDetail(nextMailNo);
			model.addAttribute("mailbox", "unreadbox");
			break;
		case "deletebox":
			updateCnfirmDate = this.mailService.putCnfirmDate(emailVO);
			emailVO = this.mailService.getMailDetail(emailNo);
			pEmailVO = this.mailService.getMailDetail(prevMailNo);
			nEmailVO = this.mailService.getMailDetail(nextMailNo);
			model.addAttribute("mailbox", "deletebox");
			break;
		default:
			// 기본적으로 받은 메일함을 처리
			emailVO = this.mailService.getMailDetail(emailNo);
			pEmailVO = this.mailService.getMailDetail(prevMailNo);
			nEmailVO = this.mailService.getMailDetail(nextMailNo);
			model.addAttribute("mailbox", "main");
			break;
		}
		// 세션 empNo = 보낸사람 senderEmpNo 이면 세션에서 직책 부서 가져다 쓰기
		// 나머지는 commonservice에서 가져다 쓰기
		if (empNo == emailVO.getSenderEmplNo()) {
			empVO.setDeptNm((String)session.getAttribute("deptNm"));					//부서명
			empVO.setProflImageUrl((String)session.getAttribute("proflImageUrl")); 		//프로필이미지
			empVO.setPosition((String)session.getAttribute("position"));				//직급
			empVO.setRspnsblCtgryNm((String)session.getAttribute("rspnsblCtgryNm"));	//직책
		}else {
			String senderEmpNo = emailVO.getSenderEmplNo();
			empVO = this.commonService.getEmpInfo(senderEmpNo);
		}
		
		log.info("after empVO : " + empVO);
		log.info("after nEmailVO : " + nEmailVO);
		log.info("after pEmailVO : " + pEmailVO);
		log.info("after emailVO : " + emailVO);

		// 파일
		if (emailVO.getAtchmnflNo() != null) {
			log.info("파일-> 번호 " + emailVO.getAtchmnflNo());
			List<AttachedFileVO> list = this.mailService.getattachedFiles(emailVO.getAtchmnflNo());
			log.info("파일의 목록-> " + list);
			model.addAttribute("attachdata", list);
		} else {
			log.info("해당 게시글은 파일이 없습니다.");
		}

		log.info("파일 용량 : " + attachFileVO.getAtchmnflSize() / 1024.0);
		// 각 메일함 메일 수
		// 임시보관함
		int tempCount = this.mailService.getTemporaryMailCount(map);
		// 보낸메일함
		int sendCount = this.mailService.getSendMailCount(map);
		// 받은메일함
		int getCount = this.mailService.getMailCount(map);
		// 읽지않은메일
		int noreadCount = this.mailService.getNoreadCount(map);
		// 휴지통
		int deleteCount = this.mailService.getDeleteCount(map);
		// 첨부파일 메일
		int attachCount = this.mailService.getAttachMailCount(map);

		model.addAttribute("empVO", empVO);
		model.addAttribute("getCount", getCount);
		model.addAttribute("noreadCount", noreadCount);
		model.addAttribute("tempCount", tempCount);
		model.addAttribute("sendCount", sendCount);
		model.addAttribute("deleteCount", deleteCount);
		model.addAttribute("attachCount", attachCount);
		model.addAttribute("emailVO", emailVO);
		model.addAttribute("mailbox", mailbox);
		model.addAttribute("pEmailVO", pEmailVO);
		model.addAttribute("nEmailVO", nEmailVO);

		log.info("updateCnfirmDate : " + updateCnfirmDate);
		return "mail/detail";
	}

	// 메일 쓰기
	@GetMapping("/create")
	public String createMail(Model model, HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();

		HttpSession session = request.getSession();
		String empNo = (String) session.getAttribute("empNo");

		map.put("empNo", empNo);
		// 각 메일함 메일 수
		// 임시보관함
		int tempCount = this.mailService.getTemporaryMailCount(map);
		// 보낸메일함
		int sendCount = this.mailService.getSendMailCount(map);
		// 받은메일함
		int getCount = this.mailService.getMailCount(map);
		// 읽지않은메일
		int noreadCount = this.mailService.getNoreadCount(map);
		// 휴지통
		int deleteCount = this.mailService.getDeleteCount(map);
		// 첨부파일 메일
		int attachCount = this.mailService.getAttachMailCount(map);

		model.addAttribute("getCount", getCount);
		model.addAttribute("noreadCount", noreadCount);
		model.addAttribute("tempCount", tempCount);
		model.addAttribute("sendCount", sendCount);
		model.addAttribute("deleteCount", deleteCount);
		model.addAttribute("attachCount", attachCount);
		return "mail/create";
	}

	// 메일 쓰기 성공
	@GetMapping("/success")
	public String createSuccess(Model model, HttpServletRequest request) {// Model model
		Map<String, Object> map = new HashMap<String, Object>();
		HttpSession session = request.getSession();
		String empNo = (String) session.getAttribute("empNo");
		map.put("empNo", empNo);
		// 각 메일함 메일 수
		// 임시보관함
		int tempCount = this.mailService.getTemporaryMailCount(map);
		// 보낸메일함
		int sendCount = this.mailService.getSendMailCount(map);
		// 받은메일함
		int getCount = this.mailService.getMailCount(map);
		// 읽지않은메일
		int noreadCount = this.mailService.getNoreadCount(map);
		// 휴지통
		int deleteCount = this.mailService.getDeleteCount(map);
		// 첨부파일 메일
		int attachCount = this.mailService.getAttachMailCount(map);

		model.addAttribute("getCount", getCount);
		model.addAttribute("noreadCount", noreadCount);
		model.addAttribute("tempCount", tempCount);
		model.addAttribute("sendCount", sendCount);
		model.addAttribute("deleteCount", deleteCount);
		model.addAttribute("attachCount", attachCount);
		return "mail/success";
	}

	// 메일보내기
	@PostMapping("/createMail")
	public String insertMail(Model model, HttpServletRequest request, EmailVO emailVO, EmailRecipientVO emailRVO,
			BindingResult brResult) {
		// @RequestPart(value="files", required=false) MultipartFile[] files,
		log.info("emailVO : " + emailVO);
		HttpSession session = request.getSession();
		String empNo = (String) session.getAttribute("empNo");

		emailVO.setEmpNo(empNo);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("empNo", empNo);
		int noreadCount = this.mailService.getNoreadCount(map);
		model.addAttribute("noreadCount", noreadCount);
		MultipartFile[] files = emailVO.getMultipartFile();
		log.info("insertmail 전 : " + emailVO);
        int sendResult = this.mailService.insertMail(files, emailVO);
       
        log.info("sendResult : " + sendResult);
        
        
        return "redirect:success";
	}

	// 보낸메일함
	@GetMapping("/sendbox")
	public String getSendList(Model model, HttpServletRequest request,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage) {
		Map<String, Object> map = new HashMap<String, Object>();

		HttpSession session = request.getSession();
		String empNo = (String) session.getAttribute("empNo");

		map.put("empNo", empNo);
		map.put("currentPage", currentPage);

		log.info("map : " + map);

		int size = 10;

		List<EmailVO> emailVOList = this.mailService.getSendList(map);
		log.info("list -> emailVOList : " + emailVOList);
		// 각 메일함 메일 수
		// 임시보관함
		int tempCount = this.mailService.getTemporaryMailCount(map);
		// 보낸메일함
		int sendCount = this.mailService.getSendMailCount(map);
		// 받은메일함
		int getCount = this.mailService.getMailCount(map);
		// 읽지않은메일
		int noreadCount = this.mailService.getNoreadCount(map);
		// 휴지통
		int deleteCount = this.mailService.getDeleteCount(map);
		// 첨부파일 메일
		int attachCount = this.mailService.getAttachMailCount(map);

		model.addAttribute("getCount", getCount);
		model.addAttribute("noreadCount", noreadCount);
		model.addAttribute("tempCount", tempCount);
		model.addAttribute("sendCount", sendCount);
		model.addAttribute("deleteCount", deleteCount);
		model.addAttribute("attachCount", attachCount);
		model.addAttribute("emaildata", new ArticlePage<EmailVO>(sendCount, currentPage, size, emailVOList, null));

		return "mail/sendbox";
	}

	// 첨부파일메일함
	@GetMapping("/attachbox")
	public String getAttachList(Model model, HttpServletRequest request,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage) {
		Map<String, Object> map = new HashMap<String, Object>();

		HttpSession session = request.getSession();
		String empNo = (String) session.getAttribute("empNo");

		map.put("currentPage", currentPage);
		map.put("empNo", empNo);

		log.info("map : " + map);

		int size = 10;

		List<EmailVO> emailVOList = this.mailService.getAttachList(map);
		log.info("list -> emailVOList : " + emailVOList);
		// 각 메일함 메일 수
		// 임시보관함
		int tempCount = this.mailService.getTemporaryMailCount(map);
		// 보낸메일함
		int sendCount = this.mailService.getSendMailCount(map);
		// 받은메일함
		int getCount = this.mailService.getMailCount(map);
		// 읽지않은메일
		int noreadCount = this.mailService.getNoreadCount(map);
		// 휴지통
		int deleteCount = this.mailService.getDeleteCount(map);
		// 첨부파일 메일
		int attachCount = this.mailService.getAttachMailCount(map);

		model.addAttribute("getCount", getCount);
		model.addAttribute("noreadCount", noreadCount);
		model.addAttribute("tempCount", tempCount);
		model.addAttribute("sendCount", sendCount);
		model.addAttribute("deleteCount", deleteCount);
		model.addAttribute("attachCount", attachCount);
		model.addAttribute("emaildata", new ArticlePage<EmailVO>(attachCount, currentPage, size, emailVOList, null));

		return "mail/attachbox";
	}

	// 휴지통
	@GetMapping("/deletebox")
	public String deleteList(Model model, HttpServletRequest request,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage) {
		Map<String, Object> map = new HashMap<String, Object>();

		HttpSession session = request.getSession();
		String empNo = (String) session.getAttribute("empNo");

		map.put("empNo", empNo);
		map.put("currentPage", currentPage);

		log.info("map : " + map);

		int size = 10;
		List<EmailVO> emailVOList = this.mailService.getDeleteList(map);
		log.info("list -> emailVOList : " + emailVOList);
		// 각 메일함 메일 수
		// 임시보관함
		int tempCount = this.mailService.getTemporaryMailCount(map);
		// 보낸메일함
		int sendCount = this.mailService.getSendMailCount(map);
		// 받은메일함
		int getCount = this.mailService.getMailCount(map);
		// 읽지않은메일
		int noreadCount = this.mailService.getNoreadCount(map);
		// 휴지통
		int deleteCount = this.mailService.getDeleteCount(map);
		// 첨부파일 메일
		int attachCount = this.mailService.getAttachMailCount(map);

		model.addAttribute("getCount", getCount);
		model.addAttribute("noreadCount", noreadCount);
		model.addAttribute("tempCount", tempCount);
		model.addAttribute("sendCount", sendCount);
		model.addAttribute("deleteCount", deleteCount);
		model.addAttribute("attachCount", attachCount);
		model.addAttribute("emaildata", new ArticlePage<EmailVO>(deleteCount, currentPage, size, emailVOList, null));

		return "mail/deletebox";
	}

	@ResponseBody
	@PostMapping("/hardDelete")
	public int hardDeleteMail(@RequestBody EmailVO emailVO, HttpSession session) {
		String[] deleteDataList = emailVO.getDeleteDataList();
		String empNm = (String) session.getAttribute("empNm");

		int result = 0;

		return 0;
	}

	@ResponseBody
	@PostMapping("/delete/{mailbox}")
	public int deleteMail(@PathVariable("mailbox") String mailbox, @RequestBody EmailVO emailVO, HttpSession session) {
		log.info("emailVO : " + emailVO);
		String[] checkboxList = emailVO.getCheckboxList();

		String empNo = (String) session.getAttribute("empNo");

		int result = 0;

		switch (mailbox) {
		case "main":
			for (int i = 0; i < checkboxList.length; i++) {
				EmailVO demailVO = new EmailVO();
				demailVO.setEmailNo(checkboxList[i]);
				demailVO.setEmpNo(empNo);

				result += this.mailService.deleteGetMail(demailVO);

			}
			break;

		case "sendbox":
			for (int i = 0; i < checkboxList.length; i++) {
				EmailVO demailVO = new EmailVO();
				demailVO.setEmailNo(checkboxList[i]);
				demailVO.setEmpNo(empNo);

				result += this.mailService.deleteSendMail(demailVO);
			}
			break;

		case "unreadbox":
			for (int i = 0; i < checkboxList.length; i++) {
				EmailVO demailVO = new EmailVO();
				demailVO.setEmailNo(checkboxList[i]);
				demailVO.setEmpNo(empNo);

				result += this.mailService.deleteGetMail(demailVO);

			}
			break;

		case "attachbox":
			for (int i = 0; i < checkboxList.length; i++) {
				EmailVO demailVO = new EmailVO();
				demailVO.setEmailNo(checkboxList[i]);
				demailVO.setEmpNo(empNo);

				result += this.mailService.deleteGetMail(demailVO);

			}
			break;
		case "temporarybox":
			for (int i = 0; i < checkboxList.length; i++) {
				log.info("empNo : " + empNo);
				EmailVO demailVO = new EmailVO();
				demailVO.setEmailNo(checkboxList[i]);
				demailVO.setEmpNo(empNo);
				log.info("demailVO : " + demailVO);
				result += this.mailService.deleteSendMail(demailVO);
			}
			break;
		default:
			for (int i = 0; i < checkboxList.length; i++) {
				EmailVO demailVO = new EmailVO();
				demailVO.setEmailNo(checkboxList[i]);
				demailVO.setEmpNo(empNo);

				result += this.mailService.deleteGetMail(demailVO);

			}
			break;
		}

		log.info("result:" + result);
		return result;
	}

	// 안읽은메일함
	@GetMapping("/unreadbox")
	public String unreadList(Model model, HttpServletRequest request,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage) {
		Map<String, Object> map = new HashMap<String, Object>();

		HttpSession session = request.getSession();
		String empNo = (String) session.getAttribute("empNo");

		map.put("empNo", empNo);
		map.put("currentPage", currentPage);

		log.info("map : " + map);

		int size = 10;

		List<EmailVO> emailVOList = this.mailService.getUnreadList(map);
		log.info("list -> emailVOList : " + emailVOList);
		// 각 메일함 메일 수
		// 임시보관함
		int tempCount = this.mailService.getTemporaryMailCount(map);
		// 보낸메일함
		int sendCount = this.mailService.getSendMailCount(map);
		// 받은메일함
		int getCount = this.mailService.getMailCount(map);
		// 읽지않은메일
		int noreadCount = this.mailService.getNoreadCount(map);
		// 휴지통
		int deleteCount = this.mailService.getDeleteCount(map);
		// 첨부파일 메일
		int attachCount = this.mailService.getAttachMailCount(map);

		model.addAttribute("getCount", getCount);
		model.addAttribute("noreadCount", noreadCount);
		model.addAttribute("tempCount", tempCount);
		model.addAttribute("sendCount", sendCount);
		model.addAttribute("deleteCount", deleteCount);
		model.addAttribute("attachCount", attachCount);
		model.addAttribute("emaildata", new ArticlePage<EmailVO>(noreadCount, currentPage, size, emailVOList, null));
		return "mail/unreadbox";
	}

	// 임시보관함
	@GetMapping("/temporarybox")
	public String temporaryList(Model model, HttpServletRequest request,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage) {
		Map<String, Object> map = new HashMap<String, Object>();

		HttpSession session = request.getSession();
		String empNo = (String) session.getAttribute("empNo");

		map.put("empNo", empNo);
		map.put("currentPage", currentPage);

		log.info("map : " + map);

		int size = 10;

		List<EmailVO> emailVOList = this.mailService.getTemporaryList(map);
		log.info("list -> emailVOList : " + emailVOList);
		// 각 메일함 메일 수
		// 임시보관함
		int tempCount = this.mailService.getTemporaryMailCount(map);
		// 보낸메일함
		int sendCount = this.mailService.getSendMailCount(map);
		// 받은메일함
		int getCount = this.mailService.getMailCount(map);
		// 읽지않은메일
		int noreadCount = this.mailService.getNoreadCount(map);
		// 휴지통
		int deleteCount = this.mailService.getDeleteCount(map);
		// 첨부파일 메일
		int attachCount = this.mailService.getAttachMailCount(map);

		model.addAttribute("getCount", getCount);
		model.addAttribute("noreadCount", noreadCount);
		model.addAttribute("tempCount", tempCount);
		model.addAttribute("sendCount", sendCount);
		model.addAttribute("deleteCount", deleteCount);
		model.addAttribute("attachCount", attachCount);
		model.addAttribute("emaildata", new ArticlePage<EmailVO>(tempCount, currentPage, size, emailVOList, null));
		return "mail/temporarybox";
	}

	// 임시저장메일 보내기
	@ResponseBody
	@GetMapping("/tempcreate")
	public String tempCreateMail(Model model, @RequestParam("emailNo") String emailNo, HttpServletRequest request,
			EmailVO emailVO) {
		Map<String, Object> map = new HashMap<String, Object>();

		HttpSession session = request.getSession();
		String empNo = (String) session.getAttribute("empNo");

		map.put("empNo", empNo);

		emailVO = this.mailService.getMailDetail(emailNo);
		// 각 메일함 메일 수
		// 임시보관함
		int tempCount = this.mailService.getTemporaryMailCount(map);
		// 보낸메일함
		int sendCount = this.mailService.getSendMailCount(map);
		// 받은메일함
		int getCount = this.mailService.getMailCount(map);
		// 읽지않은메일
		int noreadCount = this.mailService.getNoreadCount(map);
		// 휴지통
		int deleteCount = this.mailService.getDeleteCount(map);
		// 첨부파일 메일
		int attachCount = this.mailService.getAttachMailCount(map);
		log.info("emailVO : " + emailVO);
		log.info("emailRVOList : " + emailVO.getEmailRVOList());
		model.addAttribute("getCount", getCount);
		model.addAttribute("noreadCount", noreadCount);
		model.addAttribute("tempCount", tempCount);
		model.addAttribute("sendCount", sendCount);
		model.addAttribute("deleteCount", deleteCount);
		model.addAttribute("attachCount", attachCount);
		return "mail/tempcreate";
	}

	// 임시저장하기
	@ResponseBody
	@PostMapping("/temporaryMail")
	public String temporaryMail(Model model, HttpServletRequest request, EmailVO emailVO, BindingResult brResult) {
		log.info("emailVO : " + emailVO);
		Map<String, Object> map = new HashMap<String, Object>();
		HttpSession session = request.getSession();
		String empNo = (String) session.getAttribute("empNo");
		map.put("empNo", empNo);

		emailVO.setEmpNo(empNo);
		int noreadCount = this.mailService.getNoreadCount(map);
		model.addAttribute("noreadCount", noreadCount);
		int temporaryResult = this.mailService.insertTemporaryMail(emailVO);
		log.info("temporaryResult : " + temporaryResult);

		return "redirect:success";
	}

	// 이름을 자동완성하는 함수
	@ResponseBody
	@PostMapping("/findEmpByName")
	public List<EmployeeVO> findEmpByName(@RequestBody ProjectDutyVO vo) {
		List<EmployeeVO> list = this.projectService.findEmpByName(vo);
		log.info("findEmpByName =>" + list);

		return list;

	}

}