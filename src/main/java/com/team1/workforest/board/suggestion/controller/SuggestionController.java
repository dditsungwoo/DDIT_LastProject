package com.team1.workforest.board.suggestion.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team1.workforest.board.suggestion.service.SuggestionService;
import com.team1.workforest.board.suggestion.vo.SuggestionReplyVO;
import com.team1.workforest.board.suggestion.vo.SuggestionVO;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.util.ArticlePage;
import com.team1.workforest.util.ArticlePageSearchOption;
import com.team1.workforest.vo.AttachedFileVO;

import jdk.nashorn.internal.objects.annotations.Getter;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Controller
@RequestMapping("/suggestion")
public class SuggestionController {

	@Autowired
	SuggestionService suggestService;

	// 건의게시판 리스트 페이지(메인)
	// 1) /suggestion/list
	/// 2) suggestion/list?currentPage=2&searchOption=title&keyword=소망
	@GetMapping("/list")
	public String getSuggestList(Model model,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
			@RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
			@RequestParam(value = "searchOption", required = false, defaultValue = "") String searchOption) {

		Map<String, Object> map = new HashMap<String, Object>();

		// 페이지 번호
		map.put("currentPage", currentPage);
		map.put("keyword", keyword);
		map.put("searchOption", searchOption);
		// getSuggestList->map : {currentPage=2, keyword=제목}
		log.info("getSuggestList->map : " + map);

		// 전체 행의 수 (total) 또는
		// 검색한 키워드의 행 수
		int total = this.suggestService.getkeywordTotal(map);
		log.info("getSuggestList->total -> " + total);// 32

		// 한 화면에 보여지는 행의 수 (기본 10행)
		int size = 10;

		List<SuggestionVO> suggestBoardVOList = this.suggestService.list(map);
		log.info("list -> suggestBoardVOList : " + suggestBoardVOList);

		ArticlePageSearchOption<SuggestionVO> data = new ArticlePageSearchOption<SuggestionVO>(total, currentPage, size,
				suggestBoardVOList, keyword, searchOption);

		String url = "/suggestion/list";
		data.setUrl(url);

		model.addAttribute("suggestdata", data);

		return "board/suggestion/list";
	}

	// 건의 게시판 검색 기능
	@ResponseBody
	@PostMapping("/list")
	public ArticlePageSearchOption<SuggestionVO> listAjax(@RequestBody(required = false) Map<String, Object> map) {
		log.info("map: " + map);

		List<SuggestionVO> suggestionVOList = this.suggestService.list(map);
		log.info("list -> suggestionVOList : " + suggestionVOList);

		// 검색한 키워드의 행 수
		int total = this.suggestService.getkeywordTotal(map);

		log.info("listAjax->list -> total : " + total);

		int size = 10;

		String currentPage = map.get("currentPage").toString();

		String keyword = map.get("keyword").toString();
		String searchOption = map.get("searchOption").toString();

		log.info("total : " + total + ", currentPage : " + currentPage + ", size : " + size + ", keyword : " + keyword
				+ ", searchOption : " + searchOption);

		ArticlePageSearchOption<SuggestionVO> data = new ArticlePageSearchOption<SuggestionVO>(total,
				Integer.parseInt(currentPage), size, suggestionVOList, keyword, searchOption);

		log.info("listAjax->data : " + data);

		String url = "/suggestion/list";

		data.setUrl(url);

		return data;
	}

	// 건의 게시판 상세 조회
	@RequestMapping(value = "/list/detail", method = RequestMethod.GET)
	public String detailSuggestionBoard(Model model, @RequestParam String sugestBrdNo, HttpSession session) {
		
		String sessionEmpNo= (String)session.getAttribute("empNo");
		model.addAttribute("sessionEmpNo",sessionEmpNo);
		
		//로그인한 사원 번호
		/*
		 * HttpSession session = request.getSession(); String empNo = (String)
		 * session.getAttribute("empNo"); model.addAttribute("empNo", empNo);
		 */
		
		// 조회수 증가
		int suggestionView = this.suggestService.suggestionView(sugestBrdNo);
		// 조회수 증가하는 부분을 맨 위에 두지 않으면 상세 조회페이지로 들어갔을 때 조회수가 증가되지 않음

		// 선택된 게시판 상세 조회
		SuggestionVO suggestionVO = this.suggestService.detail(sugestBrdNo);
		log.info("suggestionVO -> " + suggestionVO);

		model.addAttribute("suggestDetail", suggestionVO);

		// 해당 게시글에 파일이 있다면
		if (suggestionVO.getAtchmnflNo() != null) {
			log.info("파일 -> 번호 " + suggestionVO.getAtchmnflNo());
			List<AttachedFileVO> list = this.suggestService.sugestAtchList(suggestionVO.getAtchmnflNo());
			log.info("파일의 목록 -> " + list);
			model.addAttribute("attachdata", list);
		} else {
			log.info("해당 게시글은 파일이 없습니다.");
		}
		
		return "board/suggestion/detail";
	}

	// 댓글 조회
	@ResponseBody
	@PostMapping("/list/reply")
	public List<SuggestionReplyVO> SuggestionReplyList(@RequestBody SuggestionReplyVO vo) {

		// 댓글 조회
		List<SuggestionReplyVO> suggestionReplyVOList = this.suggestService.suggestReplylist(vo);
		
		log.info("suggestionReplyVOList -> " + suggestionReplyVOList);
		
		for(SuggestionReplyVO list : suggestionReplyVOList) {
			String sugestBrdReNo = list.getSugestBrdReNo();
			log.info("suggestion&&&&& -> "+ sugestBrdReNo);
			int res = this.suggestService.suggestReplyNum(sugestBrdReNo);
			log.info("res ---------> "+res);
			String num = Integer.toString(res);
			list.setUpperReNum(num);
			log.info("list -----> "+list);
			
			
		}
		
		
		
		// model.addAttribute("suggestionReplyVOList",suggestionReplyVOList);
		return suggestionReplyVOList;
	}

	// 댓글 입력
	@ResponseBody
	@PostMapping("/list/reply/insert")
	public SuggestionReplyVO SuggestionReplyInsert(@RequestBody SuggestionReplyVO vo) {
		log.info("댓글 등록 vo -> " + vo);

		// 댓글 입력
		int result = this.suggestService.SuggestionReplyInsert(vo);
		log.info("SuggestionReplyInsert result = " + result);

		// 댓글 입력 완료 후..
		SuggestionReplyVO suggestionreplyVO = this.suggestService.insertSuggestionReplyVO(vo);
		log.info("suggestionreplyVO => " + suggestionreplyVO);

		return suggestionreplyVO;
	}

	// 댓글 삭제
	@ResponseBody
	@PostMapping("/list/reply/delete")
	public int suggestionReplyDelete(@RequestBody SuggestionReplyVO vo) {
		log.info("vo -> " + vo);
		int result = this.suggestService.deleteSuggestionReplyVO(vo);
		log.info("result -> " + result);
		return result;
	}

	// 대댓글 리스트
	@ResponseBody
	@PostMapping("/list/reply/Re")
	public List<SuggestionReplyVO> suggestionReplyReList(@RequestBody SuggestionReplyVO vo) {
		log.info("vo -> " + vo);

		List<SuggestionReplyVO> suggestionReplyReList = this.suggestService.suggestionReplyReList(vo);
		log.info("suggestionReplyReList : " + suggestionReplyReList);

		return suggestionReplyReList;
	}

	// 대댓글 등록	
	  @ResponseBody
	  @PostMapping("/list/reply/Re/insert") 
	  public SuggestionReplyVO insertReplyRe(@RequestBody SuggestionReplyVO vo,HttpServletRequest request) {
		  /*
		  SuggestionReplyVO(sugestBrdReNo=193, reSj=sdfsdfsd, empNo=null, writngDate=null, updtDate=null, sugestBrdNo=83,...)
		   */
		  log.info("insert Re vo -> "+vo);
		  HttpSession session = request.getSession();
		  String empNo = (String) session.getAttribute("empNo");
		  log.info("empNo -> "+empNo);
		  
		  vo.setEmpNo(empNo);
		  vo.setUpperRe(vo.getSugestBrdReNo());
		  log.info("reReply vo -> "+vo);
		  
		  //실행전 : SuggestionReplyVO(sugestBrdReNo=193, ..
		  int result = this.suggestService.insertReplyRe(vo);
		  //실행후 : SuggestionReplyVO(sugestBrdReNo=194,..
		  log.info("result -> " +result);
		  
		  //detail.jsp에 대댓글 1행 추가
		  vo = this.suggestService.getNewSuggestionReply(vo);
		  log.info("vo(대댓글 추가 후) -> " +vo);
		  
		  return vo;
	  }
	  
	 

	// 건의 게시글 삭제
	@ResponseBody
	@PostMapping("/list/delete")
	public int deleteSuggestion(@RequestBody SuggestionVO vo) {
		log.info("vo ->", vo);

		int result = this.suggestService.deleteSuggestion(vo);
		log.info("result -> ", result);

		return result;
	}

	// 건의 게시글 등록 페이지
	@GetMapping("/list/insertSuggestion")
	public String insertSuggestion() {
		return "board/suggestion/insert";
	}

	// 건의 게시글 등록
	@PostMapping("/creatSuggest")
	public String createSuggest(@Validated SuggestionVO suggestionVO, BindingResult brResult) {
		log.info("brResult ->" + brResult);

		log.info("createSuggest -> suggestionVO :" + suggestionVO.getUploadfile().length);

		int result = this.suggestService.createSuggest(suggestionVO);

		log.info("result -> ", result);

		return "redirect:/suggestion/list";
	}

	// 건의 게시판 수정페이지로 가기
	@GetMapping("/list/update")
	public String updatepageSuggest(@RequestParam String sugestBrdNo, Model model) {
		// 내용가져오고
		SuggestionVO vo = this.suggestService.detail(sugestBrdNo);
		log.info("내용vo -> " + vo);
		model.addAttribute("vo", vo);
		log.info("여기 -----지남");
		// atchmnflNo의 값이 있다면
		log.info("vo.getAtchmnflNo() -> "+vo.getAtchmnflNo());
		
		if(vo.getAtchmnflNo() != null && !vo.getAtchmnflNo().equals("")) {
			log.info("if문 들어옴");
			String atchmnflNo = vo.getAtchmnflNo();
			List<AttachedFileVO> atfVO = this.suggestService.getSugestFiles(atchmnflNo);
			log.info("atfVO --> "+atfVO);
			model.addAttribute("atfVO", atfVO);
		}
		
		
		log.info("여기지남");
		
		return "board/suggestion/update";
	}

	// 건의 게시판 수정
	@PostMapping("/updateSuggest")
	public String updateSuggest(@Validated SuggestionVO suggestionVO, BindingResult brResult) {

		log.info("updateSuggest -> suggestionVO :" + suggestionVO);

		int result = this.suggestService.upDateSuggest(suggestionVO);

		log.info("result -> ", result);

		return "redirect:/suggestion/list";
	}
	
	// 건의 게시글 댓글 수정
	@ResponseBody
	@PostMapping("/list/reply/update")
	public int updateReSugest(@RequestBody SuggestionReplyVO vo) {
		log.info("updateResugest vo -> "+vo);
		
		int result = this.suggestService.updateReSugest(vo);
		log.info("result -> "+result);
		
		return result;
	}
	
	
	// 대댓글 삭제
	@ResponseBody
	@PostMapping("/list/reply/re/delete")
	public int deleteReSugestReply(@RequestBody SuggestionReplyVO vo) {
		log.info("deleteReSugestReply vo-> "+vo);
		
		int result = this.suggestService.deleteReSugestReply(vo);
		log.info("deleteReSugestReply result -> "+result);
		
		return result;
	}
	
	// 업데이트란에서 기존 파일 삭제
	@ResponseBody
	@PostMapping("/update/fileDelete")
	public int deleteUpdateFile(@RequestBody AttachedFileVO vo) {
		log.info("vo -> "+vo);
		int result = this.suggestService.deleteUpdateFile(vo);
		return result;
	}
	
	
	
	
	
	

}
