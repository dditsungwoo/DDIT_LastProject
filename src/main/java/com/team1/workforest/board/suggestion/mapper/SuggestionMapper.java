package com.team1.workforest.board.suggestion.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.board.suggestion.vo.SuggestionReplyVO;
import com.team1.workforest.board.suggestion.vo.SuggestionVO;
import com.team1.workforest.vo.AttachedFileVO;

public interface SuggestionMapper {
	
	// 조회수
	public int suggestionView(String sugestBrdNo);


	// 건의 게시판 목록
	public List<SuggestionVO> list(Map<String, Object> map);
	
	
	//전체 행의 수
	public int getTotal();

	
	// 건의 게시판 상세조회
	public SuggestionVO detail(String sugestBrdNo);


	// 댓글 조회
	public List<SuggestionReplyVO> suggestReplylist(SuggestionReplyVO vo);

	
	
	// 댓글 등록
	public int SuggestionReplyInsert(SuggestionReplyVO vo);

	
	// insert 날짜시간 가져오기
	public SuggestionReplyVO insertdate(SuggestionReplyVO vo);

	// 건의 게시판 삭제
	public int deleteSuggestion(SuggestionVO vo);

	// 건의 게시판 댓글 입력 후 입력한 값 보여주기
	public SuggestionReplyVO insertSuggestionReplyVO(SuggestionReplyVO vo);

	// 건의 게시판 댓글 삭제
	public int deleteSuggestionReplyVO(SuggestionReplyVO vo);

	// 파일 있는 건의 게시판 추가
	public int createSuggest(SuggestionVO suggestionVO);
	
	// 파일입력
	public int insertAttachedFile(AttachedFileVO attachFileVO);

	// 업로드한 파일 첨부파일 번호
	public String attachmnflNo();

	// 대댓글 리스트 출력
	public List<SuggestionReplyVO> suggestionReplyReList(SuggestionReplyVO vo);

	// 업로드 파일이 없는 경우 insert
	public int createSuggestNoFile(SuggestionVO suggestionVO);

	// 파일 있는 게시글 수정
	public int updateSuggest(SuggestionVO suggestionVO);

	// 파일 없는 게시글 수정
	public int updateNoFileSuggest(SuggestionVO suggestionVO);

	// 검색한 행의 수
	public int getkeywordTotal(Map<String, Object> map);

	// 상세 게시판 파일 리스트
	public List<AttachedFileVO> sugestAtchList(String atchmnflNo);

	// 대댓글 등록
	public int insertReplyRe(SuggestionReplyVO vo);

	
	// 대댓글 개수
	public int suggestReplyNum(String sugestBrdReNo);

	//detail.jsp에 대댓글 1행 추가
	public SuggestionReplyVO getNewSuggestionReply(SuggestionReplyVO vo);

	// 댓글 수정
	public int updateReSugest(SuggestionReplyVO vo);

	// 대댓글 삭제
	public int deleteReSugestReply(SuggestionReplyVO vo);

	// 수정 시 해당 번호의 파일들 정보 얻기
	public List<AttachedFileVO> getSugestFiles(String atchmnflNo);

	//업데이트란에서 기존 파일 삭제
	public int deleteUpdateFile(AttachedFileVO vo);

	
	
	
	
}
