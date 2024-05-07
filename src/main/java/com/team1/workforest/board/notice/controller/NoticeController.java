package com.team1.workforest.board.notice.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import com.team1.workforest.board.notice.service.NoticeService;
import com.team1.workforest.board.notice.vo.NoticeBoardReplyVO;
import com.team1.workforest.board.notice.vo.NoticeBoardVO;
import com.team1.workforest.board.suggestion.vo.SuggestionVO;
import com.team1.workforest.util.ArticlePageSearchOption;
import com.team1.workforest.util.ArticlePagebrdCd;
import com.team1.workforest.vo.AttachedFileVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/notice")
public class NoticeController {
	
	
	@Autowired
	NoticeService noticeService;
	
	
	// 공지사항 리스트 페이지(메인)
	@GetMapping("/list")
	public String getNoticeBrdList (Model model,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
			@RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
			@RequestParam(value = "searchOption", required = false, defaultValue = "") String searchOption,
			@RequestParam(value ="brdCd", required = false,defaultValue="") String brdCd ) {
		
		Map<String, Object> map = new HashMap<String,Object>();
		
		// 페이지 번호
		map.put("currentPage", currentPage);
		map.put("keyword", keyword);
		map.put("searchOption", searchOption);
		map.put("brdCd", brdCd);
		
		log.info("getSuggestList->map : " + map);

		// 전체 행의 수 (total) 또는
		// 검색한 키워드의 행 수
		int total = this.noticeService.getkeywordTotal(map);
		log.info("getkeywordTotal -> "+total);
		
		// 한 화면에 보여지는 행의 수 (기본 10행)
		int size = 10;

		List<NoticeBoardVO> NoticeBoardVOList = this.noticeService.list(map);
		
		log.info("list -> NoticeBoardVOList : " + NoticeBoardVOList);

		ArticlePagebrdCd<NoticeBoardVO> data = new ArticlePagebrdCd<NoticeBoardVO>(total, currentPage, size,
				NoticeBoardVOList, keyword, searchOption ,brdCd);

		String url = "/notice/list";
		data.setUrl(url);

		model.addAttribute("noticedata", data);
		return "board/notice/list";
	}
	

	// 공지 게시판 검색 기능
		@ResponseBody
		@PostMapping("/list")
		public ArticlePagebrdCd<NoticeBoardVO> listAjax(@RequestBody(required = false) Map<String, Object> map) {
			log.info("map: " + map);

			List<NoticeBoardVO> noticeVOList = this.noticeService.list(map);
			log.info("list -> noticeVOList : " + noticeVOList);

			// 검색한 키워드의 행 수
			int total = this.noticeService.getkeywordTotal(map);

			log.info("listAjax->list -> total : " + total);

			int size = 10;

			String currentPage = map.get("currentPage").toString();

			String keyword = map.get("keyword").toString();
			String searchOption = map.get("searchOption").toString();
			String brdCd = map.get("brdCd").toString();
			
			
			log.info("total : " + total + ", currentPage : " + currentPage + ", size : " + size + ", keyword : " + keyword
					+ ", searchOption : " + searchOption +", brdCd : " + brdCd);

			ArticlePagebrdCd<NoticeBoardVO> data = new ArticlePagebrdCd<NoticeBoardVO>(total,
					Integer.parseInt(currentPage), size, noticeVOList, keyword, searchOption , brdCd);

			log.info("listAjax->data : " + data);

			String url = "/notice/list";

			data.setUrl(url);

			return data;
		}
	
	// 공지 게시판 등록 페이지
	@GetMapping("/list/insertNotice")
	public String insertNotice() {
		return "board/notice/insert";
	}
	
	// 공지 게시판 등록
	@PostMapping("/creatNotice")
	public String createNotice(@Validated NoticeBoardVO noticeVO, BindingResult brResult) {
		log.info("createNotice -> noticeVO :"+noticeVO);
		log.info("createNotice -> noticeVO.getUploadfile().length :"+noticeVO.getUploadfile()[0]);
		
		int result = this.noticeService.createNotice(noticeVO);
		log.info("result -> "+result);
		
		return "redirect:/notice/list";
	}
	
	
		
		
	// 공지 게시판 상세 조회
	@RequestMapping(value ="/list/detail", method=RequestMethod.GET)
	public String detailNoticeBoard(Model model, @RequestParam String noticeBrdNo,HttpSession session) {
		
		log.info("noticeBrdNo ---> "+noticeBrdNo);
		
		// 조회수 증가
		int noticeView = this.noticeService.noticeView(noticeBrdNo);
		
		NoticeBoardVO noticeVO = this.noticeService.detail(noticeBrdNo);
		log.info("noticeVO -> "+noticeVO);
		
		model.addAttribute("noticeDetail",noticeVO);
		
		// 댓글 대댓글 조회
		List<NoticeBoardReplyVO> Replylist = this.noticeService.noticeReplyList(noticeBrdNo);
		log.info("Replylist--> "+Replylist);
		model.addAttribute("replyList",Replylist);
		String sessionEmpNo= (String)session.getAttribute("empNo");
		model.addAttribute("sessionEmpNo",sessionEmpNo);
		
		// 해당 게시글에 파일이 있다면
				if (noticeVO.getAtchmnflNo() != null) {
					log.info("파일 -> 번호 " + noticeVO.getAtchmnflNo());
					List<AttachedFileVO> list = this.noticeService.noticeAtchList(noticeVO.getAtchmnflNo());
					log.info("파일의 목록 -> " + list);
					model.addAttribute("attachdata", list);
				} else {
					log.info("해당 게시글은 파일이 없습니다.");
				}
		
		return "board/notice/detail";
	}
		
	
	
	
	// 댓글 등록
	@ResponseBody
	@PostMapping("/detail/reply/insert")
	public NoticeBoardReplyVO insertNoticeReply(@RequestBody NoticeBoardReplyVO vo) {
		log.info("vo -> "+vo);
		 
		
		 int result = this.noticeService.insertNoticeReply(vo);
		log.info("result -> "+result);
		
		// 댓글 입력 완료 후
		NoticeBoardReplyVO noticeNewVO = this.noticeService.noticeNewInsert(vo);
		log.info("noticeNewVO --> "+noticeNewVO);
		
		
		return noticeNewVO;
	}
	
	
	// 댓글 업데이트 (대댓글 포함)
	@ResponseBody
	@PostMapping("/detail/reply/update")
	public int updateNoticeReply(@RequestBody NoticeBoardReplyVO vo) {
		log.info("vo --> "+vo);
		
		int result = this.noticeService.updateNoticeReply(vo);
		
		return result;
	}
	
	// 대댓글만 insert
	@ResponseBody
	@PostMapping("/detail/reply/re/insert")
	public NoticeBoardReplyVO insertNoticeReReply(@RequestBody NoticeBoardReplyVO vo) {
		log.info("vo --> "+vo);
		
		int result = this.noticeService.insertNoticeReReply(vo);
		
		//insert 후 최신 댓글 뽑기
		NoticeBoardReplyVO noticeNewReVo = this.noticeService.noticeNewInsert(vo);
		
		
		return noticeNewReVo;
	}
	
	
	// 댓글 삭제 핸들러
	@ResponseBody
	@PostMapping("/detail/reply/delete")
	public int deleteNoticeReply(@RequestBody NoticeBoardReplyVO vo) {
		log.info("vo---> "+vo);
		
		int result = this.noticeService.deleteNoticeReply(vo);
		return result;
	}
	
	@ResponseBody
	@PostMapping("/detail/reply/re/delete")
	public int deleteNoticeReReply(@RequestBody NoticeBoardReplyVO vo) {
		log.info("vo ------> "+ vo);
		int result = this.noticeService.deleteNoticeReReply(vo);
		return result;
	}
	
	
	@PostMapping("/update")
	public String updateNotice(NoticeBoardVO vo,Model model,HttpSession session) {
		log.info("여기 들어옴");
		NoticeBoardVO noticeVO = this.noticeService.detail(vo.getNoticeBrdNo());
		log.info("noticeVO ----> "+noticeVO);
		//모델 
		model.addAttribute("noticeVO",noticeVO);
		//atchmnflNo 체크
		log.info("noticeVO.getAtchmnflNo --->"+noticeVO.getAtchmnflNo());
		
		String sessionEmpNo= (String)session.getAttribute("empNo");
		model.addAttribute("sessionEmpNo",sessionEmpNo);
		
		// atchmnflNo의 값이 있다면
		if(noticeVO.getAtchmnflNo() != null && !noticeVO.getAtchmnflNo().equals("")) {
			log.info("파일이 있을 떄 if문 들어옴");
			String atchmnflNo = noticeVO.getAtchmnflNo();
			List<AttachedFileVO> fileVO = this.noticeService.getNoticeFiles(atchmnflNo);
			
			log.info("fileVO --> "+ fileVO);
			model.addAttribute("fileVO",fileVO);
		}
		
		
		return "board/notice/update";
	}
	
	
	//선택한 파일 삭제
	@ResponseBody
	@PostMapping("/deletefile")
	public int deleteFile(@RequestBody AttachedFileVO vo) {
		log.info("vo------>"+vo);
		int result = this.noticeService.deleteFile(vo);
		return result;
	}
	
	@PostMapping("/updateNotice")
	public String updateNoticeSet(@Validated NoticeBoardVO vo, BindingResult brResult) {
		log.info("vo-------> "+vo);		
		int result = this.noticeService.updateNoticeSet(vo);
		
		if(result == 1) {
			log.info("업데이트 성공");
		}else {
			log.info("업데이트 실패");
		}
		return "redirect:/notice/list";
	}
	
	@ResponseBody
	@PostMapping("/detail/delete")
	public int deleteListAndReply(@RequestBody NoticeBoardVO vo) {
		log.info("vo--------->"+vo);
		//게시글 삭제
		int result = this.noticeService.deleteNotice(vo);
		//게시글이 삭제가 완료되면
		 if(result == 1) {
			 int result2 = this.noticeService.deleteNoticeAllReply(vo);
			 log.info("삭제 완료");
		 }
		
		return result;
	}
	
	// 시간 삭제
	@ResponseBody
	@PostMapping("/list/time/delete")
	public int updateTimeNotice(@RequestBody NoticeBoardVO vo) {
		log.info("vo-------> "+vo);
		int result = this.noticeService.updateTimeNotice(vo);
		return result;
	}
	
	
	// 메인페이지 공지사항
	@ResponseBody
	@GetMapping("/home/list")
	public List<NoticeBoardVO> noticeVO(){
		int sum = 10;
		List<NoticeBoardVO> list = this.noticeService.homeNoticeList();
		log.info("list------> "+list);
		return list;
	}
	
	
	//해당 로그인한 사람 권한 찾기
	@ResponseBody
	@PostMapping("/getEmpRspn")
	public NoticeBoardVO getEmpRspn(@RequestBody NoticeBoardVO vo) {
		 NoticeBoardVO result = this.noticeService.getEmpRspn(vo);
		log.info("직급 result ------> "+result);
		return result;
	}
	
	
	

}
