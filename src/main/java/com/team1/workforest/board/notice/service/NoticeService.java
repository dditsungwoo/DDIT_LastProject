package com.team1.workforest.board.notice.service;

import java.util.List;
import java.util.Map;

import com.team1.workforest.board.notice.vo.NoticeBoardReplyVO;
import com.team1.workforest.board.notice.vo.NoticeBoardVO;
import com.team1.workforest.vo.AttachedFileVO;

public interface NoticeService {
	
	// 검색한 키워드의 행수
	public int getkeywordTotal(Map<String, Object> map);
	
	// 목록 창
	public List<NoticeBoardVO> list(Map<String, Object> map);
	
	
	// 조회수 증가
	public int noticeView(String noticeBrdNo);
	
	// 공지게시글 등록
	public int createNotice(NoticeBoardVO noticeVO);
	
	
	// 상세 조회
	public NoticeBoardVO detail(String noticeBrdNo);
	
	// 파일 존재 여부
	public List<AttachedFileVO> noticeAtchList(String atchmnflNo);
	
	//댓글 대댓글 조회
	public List<NoticeBoardReplyVO> noticeReplyList(String noticeBrdNo);
	
	// 댓글 등록
	public int insertNoticeReply(NoticeBoardReplyVO vo);
	
	// 댓글 등록 후 최신꺼 보여주기
	public NoticeBoardReplyVO noticeNewInsert(NoticeBoardReplyVO vo);
	
	// 댓글 업데이트 (대댓글 포함)
	public int updateNoticeReply(NoticeBoardReplyVO vo);
	
	//대댓글만 insert
	public int insertNoticeReReply(NoticeBoardReplyVO vo);
	
	// 댓글만 삭제
	public int deleteNoticeReply(NoticeBoardReplyVO vo);
	
	// 대댓글 삭제
	public int deleteNoticeReReply(NoticeBoardReplyVO vo);
	
	// 파일 가져오기
	public List<AttachedFileVO> getNoticeFiles(String atchmnflNo);
	
	//선택한 파일 삭제
	public int deleteFile(AttachedFileVO vo);
	
	// 게시글 업데이트
	public int updateNoticeSet(NoticeBoardVO vo);
	
	// 게시글 삭제
	public int deleteNotice(NoticeBoardVO vo);
	
	// 댓글도 삭제
	public int deleteNoticeAllReply(NoticeBoardVO vo);
	
	// fixing시간 업데이트
	public int updateTimeNotice(NoticeBoardVO vo);
	
	// 홈 공지사항
	public List<NoticeBoardVO> homeNoticeList();

	public NoticeBoardVO getEmpRspn(NoticeBoardVO vo);

}
