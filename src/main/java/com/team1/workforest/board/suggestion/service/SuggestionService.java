package com.team1.workforest.board.suggestion.service;

import java.util.List;
import java.util.Map;

import com.team1.workforest.board.suggestion.vo.SuggestionReplyVO;
import com.team1.workforest.board.suggestion.vo.SuggestionVO;
import com.team1.workforest.vo.AttachedFileVO;

public interface SuggestionService {

	// 행의 수
	public int getTotal();

	// 건의 게시판 목록
	public List<SuggestionVO> list(Map<String, Object> map);

	// 조회수
	public int suggestionView(String sugestBrdNo);
	
	// 건의 게시판 상세조회
	public SuggestionVO detail(String sugestBrdNo);
	
	// 건의 게시판 삭제
	public int deleteSuggestion(SuggestionVO vo);
	
	// 댓글 조회
	public List<SuggestionReplyVO> suggestReplylist(SuggestionReplyVO vo);
	
	// 댓글 등록
	public int SuggestionReplyInsert(SuggestionReplyVO vo);
	
	// insert한 날짜 가져오기
	public SuggestionReplyVO insertdate(SuggestionReplyVO vo);
	
	
	// 댓글 입력 완료 후
	public SuggestionReplyVO insertSuggestionReplyVO(SuggestionReplyVO vo);
	
	// 댓글 삭제
	public int deleteSuggestionReplyVO(SuggestionReplyVO vo);
	
	// 게시글 등록
	public int createSuggest(SuggestionVO suggestionVO);
	
	// 대댓글 리스트 출력
	public List<SuggestionReplyVO> suggestionReplyReList(SuggestionReplyVO vo);
	
	// 건의게시판 수정
	public int upDateSuggest(SuggestionVO suggestionVO);
	
	// 검색한 행의 수
	public int getkeywordTotal(Map<String, Object> map);
	
	
	// 해당 게시글의 파일 
	public List<AttachedFileVO> sugestAtchList(String atchmnflNo);
	
	// 대댓글 등록
	public int insertReplyRe(SuggestionReplyVO vo);
	
	// 댓글 개수 
	public int suggestReplyNum(String sugestBrdReNo);

	//detail.jsp에 대댓글 1행 추가
	public SuggestionReplyVO getNewSuggestionReply(SuggestionReplyVO vo);
	
	//댓글 수정
	public int updateReSugest(SuggestionReplyVO vo);
	
	// 대댓글 삭제
	public int deleteReSugestReply(SuggestionReplyVO vo);
	
	// 수정 시 해당 번호의 파일들 정보 얻기
	public List<AttachedFileVO> getSugestFiles(String atchmnflNo);
	
	//업데이트란에서 기존 파일 삭제
	public int deleteUpdateFile(AttachedFileVO vo);
	
	
	
	
}
