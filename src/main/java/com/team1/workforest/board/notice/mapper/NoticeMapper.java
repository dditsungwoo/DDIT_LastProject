package com.team1.workforest.board.notice.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.board.notice.vo.NoticeBoardReplyVO;
import com.team1.workforest.board.notice.vo.NoticeBoardVO;
import com.team1.workforest.vo.AttachedFileVO;

public interface NoticeMapper {
	
	//검색한 키워드 수
	public int getkeywordTotal(Map<String, Object> map);
	
	// 공지게시판 목록
	public List<NoticeBoardVO> list(Map<String, Object> map);
	
	// 조회수 증가
	public int noticeView(String noticeBrdNo);
	
	// 업로드한 파일 첨부파일 번호
	public String attachmnflNo();
	
	// 파일 입력
	public int insertAttachedFile(AttachedFileVO attachFileVO);

	// 파일있는 등록
	public int createNotice(NoticeBoardVO noticeVO);
	
	//파일 없는 등록
	public int createNoticeNoFile(NoticeBoardVO noticeVO);
	
	// 상세 조회
	public NoticeBoardVO detail(String noticeBrdNo);
	
	
	// 게시판 파일 목록
	public List<AttachedFileVO> noticeAtchList(String atchmnflNo);
	
	// 댓글 대댓글 조회
	public List<NoticeBoardReplyVO> noticeReplyList(String noticeBrdNo);
	
	
	// 댓글 등록
	public int insertNoticeReply(NoticeBoardReplyVO vo);
	
	// 댓글 등록 후 최신 페이지
	public NoticeBoardReplyVO noticeNewInsert(NoticeBoardReplyVO vo);
	
	// 댓글 대댓글 업데이트
	public int updateNoticeReply(NoticeBoardReplyVO vo);
	
	
	// 대댓글 입력
	public int insertNoticeReReply(NoticeBoardReplyVO vo);
	
	//댓글만 삭제
	public int deleteNoticeReply(NoticeBoardReplyVO vo);
	
	//대댓글 삭제
	public int deleteNoticeReReply(NoticeBoardReplyVO vo);
	
	// 파일 가져오기
	public List<AttachedFileVO> getNoticeFiles(String atchmnflNo);
	
	//선택한 파일 삭제
	public int deleteFile(AttachedFileVO vo);
	
	
	//파일 있는거
	public int updateNotice(NoticeBoardVO vo);
	
	//파일 없는거 
	public int updateNoFileNotice(NoticeBoardVO vo);
	
	// 게시글 삭제
	public int deleteNotice(NoticeBoardVO vo);
	
	//댓글 전체 삭제
	public int deleteNoticeAllReply(NoticeBoardVO vo);
	
	//fishing 시간 업데이트
	public int updateTimeNotice(NoticeBoardVO vo);
	
	// 홈 
	public List<NoticeBoardVO> homeNoticeList();

	public NoticeBoardVO getEmpRspn(NoticeBoardVO vo);

}
