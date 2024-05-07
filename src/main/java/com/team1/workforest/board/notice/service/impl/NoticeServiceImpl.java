package com.team1.workforest.board.notice.service.impl;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.team1.workforest.board.notice.mapper.NoticeMapper;
import com.team1.workforest.board.notice.service.NoticeService;
import com.team1.workforest.board.notice.vo.NoticeBoardReplyVO;
import com.team1.workforest.board.notice.vo.NoticeBoardVO;
import com.team1.workforest.util.FileToAwsUtil;
import com.team1.workforest.vo.AttachedFileVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class NoticeServiceImpl implements NoticeService {

	@Autowired
	String uploadFolderDirect;

	@Autowired
	NoticeMapper noticeMapper;

	// 키워드 검색
	@Override
	public int getkeywordTotal(Map<String, Object> map) {
		return this.noticeMapper.getkeywordTotal(map);
	}

	// 리스트 조회
	@Override
	public List<NoticeBoardVO> list(Map<String, Object> map) {
		return this.noticeMapper.list(map);
	}

	// 조회수 증가
	@Override
	public int noticeView(String noticeBrdNo) {
		return this.noticeMapper.noticeView(noticeBrdNo);
	}

	// 공지게시글 등록
	@Transactional("txManager")
	@Override
	public int createNotice(NoticeBoardVO noticeVO) {
		int result = 0;
		int flag = 0;
		int attachmnflNo = 0;
		File uploadPath = new File(uploadFolderDirect, getFolder());

		// ATTACHMNFL_NO 최댓값
		attachmnflNo = Integer.parseInt(this.noticeMapper.attachmnflNo());
		attachmnflNo++;

		// 연월일 폴더 생성
		if (!uploadPath.exists()) {
			uploadPath.mkdirs();
		}

		String uploadFileName = "";
		long size = 0;

		MultipartFile[] uploadFile = noticeVO.getUploadfile();
		log.info("uploadFile -> " + uploadFile.length);
		log.info("uploadFile -> " + uploadFile[0]);
		log.info("uploadFile -> " + uploadFile[0].getOriginalFilename());
		log.info("uploadFile -> " + uploadFile[0].getName());
		log.info("uploadFile -> " + uploadFile[0].getSize());
		String FileCheck = uploadFile[0].getOriginalFilename();
		// 파일 존재여부 확인
		if (!FileCheck.equals("") && !FileCheck.equals(null)) {
			// 원본 파일명이 있을 때만 파일 입력 처리
			log.info("파일이 있음");
			for (MultipartFile multipartFile : uploadFile) {
				String orginalFileName = multipartFile.getOriginalFilename();
				log.info("원본 파일명 : " + orginalFileName);
				log.info("파일 크기    : " + multipartFile.getSize());
				log.info("MIME타입  : " + multipartFile.getContentType());

				uploadFileName = multipartFile.getOriginalFilename();
				size = multipartFile.getSize(); // 파일 크기
				String mime = multipartFile.getContentType(); // mime타입
				String ext = orginalFileName.substring(orginalFileName.lastIndexOf("."));
				/*
				 * String ext = ""; int lastIndex = orginalFileName.lastIndexOf("."); if
				 * (lastIndex != -1) { ext = orginalFileName.substring(lastIndex); }
				 */

				UUID uuid = UUID.randomUUID();
				uploadFileName = uuid.toString() + "_" + ext;
				log.info("uploadFileName : " + uploadFileName);

				File saveFile = new File(uploadFolderDirect + File.separator +  uploadFileName);

				try {
					// 파일 복사 실행
					multipartFile.transferTo(saveFile);
					FileToAwsUtil.uploadToS3(saveFile);
					AttachedFileVO attachFileVO = new AttachedFileVO();
					attachFileVO.setAtchmnflSize(size);
					attachFileVO.setAtchmnflNm(uploadFileName);
					attachFileVO.setAtchmnflOriginNm(orginalFileName);
					attachFileVO.setAtchmnflUrl("/"+ uploadFileName);
					log.info("attachmnflNo :" + attachmnflNo);

					attachFileVO.setAtchmnflNo(String.valueOf(attachmnflNo));

					log.info("attachFileVO : " + attachFileVO);

					// 파일 정보 데이터베이스에 저장
					result = this.noticeMapper.insertAttachedFile(attachFileVO);
					log.info("file result -> " + result);

					flag = 1;

				} catch (IllegalStateException | IOException e) {
					log.error("파일이 없음" + e.getMessage());
				}
			}
		}

		// 파일이 있을 경우에만 파일 정보를 설정한 후 suggestMapper.createSuggest 호출
		if (flag == 1) {
			log.info("File noticeVO -> " + noticeVO);
			result = this.noticeMapper.createNotice(noticeVO);
			return result;
		} else {
			log.info("NoFile noticeVO -> " + noticeVO);
			result = this.noticeMapper.createNoticeNoFile(noticeVO); // 파일이 없는 경우 호출
			return result;
		}
	}

	// 연/월/일 폴더 생성
	public String getFolder() {
		// 2024-01-30 형식(format) 지정
		// 간단한 날짜 형식
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		// 날짜 객체 생성(java.util 패키지)
		Date date = new Date();
		// 2024-01-30
		String str = sdf.format(date);
		// 2024-01-30 -> 2024\\01\\30
		return str.replace("-", File.separator);
	}

	// 이미지인지 판단. 썸네일은 이미지만 가능하므로..
	public boolean checkImageType(File file) {
		// MIME(Multipurpose Internet Mail Extensions) : 문서, 파일 또는 바이트 집합의 성격과 형식. 표준화
		// MIME 타입 알아냄. .jpeg / .jpg의 MIME(ContentType)타입 : image/jpeg
		String contentType;
		try {
			contentType = Files.probeContentType(file.toPath());
			log.info("contentType : " + contentType);
			// image/jpeg는 image로 시작함->true
			return contentType.startsWith("image");
		} catch (IOException e) {
			e.printStackTrace();
		}
		// 이 파일이 이미지가 아닐 경우
		return false;
	}

	@Override
	public NoticeBoardVO detail(String noticeBrdNo) {
		return this.noticeMapper.detail(noticeBrdNo);
	}

	// 상세정보 파일 목록
	@Override
	public List<AttachedFileVO> noticeAtchList(String atchmnflNo) {
		return this.noticeMapper.noticeAtchList(atchmnflNo);
	}

	// 댓글 대댓글 조회
	@Override
	public List<NoticeBoardReplyVO> noticeReplyList(String noticeBrdNo) {
		return this.noticeMapper.noticeReplyList(noticeBrdNo);
	}

	// 댓글 등록
	@Override
	public int insertNoticeReply(NoticeBoardReplyVO vo) {
		return this.noticeMapper.insertNoticeReply(vo);
	}

	// 댓글 등록 최신 페이지
	@Override
	public NoticeBoardReplyVO noticeNewInsert(NoticeBoardReplyVO vo) {
		return this.noticeMapper.noticeNewInsert(vo);
	}

	// 댓글 업데이트 (대댓글 포함)
	@Override
	public int updateNoticeReply(NoticeBoardReplyVO vo) {
		return this.noticeMapper.updateNoticeReply(vo);
	}

	// 대댓글 입력
	@Override
	public int insertNoticeReReply(NoticeBoardReplyVO vo) {
		return this.noticeMapper.insertNoticeReReply(vo);
	}

	// 댓글만 삭제
	@Override
	public int deleteNoticeReply(NoticeBoardReplyVO vo) {
		return this.noticeMapper.deleteNoticeReply(vo);
	}

	// 대댓글 삭제
	@Override
	public int deleteNoticeReReply(NoticeBoardReplyVO vo) {
		return this.noticeMapper.deleteNoticeReReply(vo);
	}

	// 보유한 파일 가져오기
	@Override
	public List<AttachedFileVO> getNoticeFiles(String atchmnflNo) {
		return this.noticeMapper.getNoticeFiles(atchmnflNo);
	}

	// 선택한 파일 삭제
	@Override
	public int deleteFile(AttachedFileVO vo) {
		return this.noticeMapper.deleteFile(vo);
	}

	// 게시글 업데이트
	@Transactional("txManager")
	@Override
	public int updateNoticeSet(NoticeBoardVO vo) {
		log.info("vo--------->" + vo);

		int result = 0;
		int flag = 0;
		int attachmnflNo = 0;
		File uploadPath = new File(uploadFolderDirect, getFolder());

		// ATTACHMNFL_NO 최댓값
		attachmnflNo = Integer.parseInt(this.noticeMapper.attachmnflNo());
		attachmnflNo++;

		log.info("attachmnflNo -> " + attachmnflNo);

		// 연월일 폴더 생성
		if (!uploadPath.exists()) {
			uploadPath.mkdirs();
		}

		String uploadFileName = "";
		long size = 0;

		MultipartFile[] uploadFile = vo.getUploadfile();
		log.info("uploadFile -> " + uploadFile.length);
		log.info("uploadFile -> " + uploadFile[0]);
		log.info("uploadFile -> " + uploadFile[0].getOriginalFilename());
		log.info("uploadFile -> " + uploadFile[0].getName());
		log.info("uploadFile -> " + uploadFile[0].getSize());
		String FileCheck = uploadFile[0].getOriginalFilename();
		// 파일 존재여부 확인
		if (!FileCheck.equals("") && !FileCheck.equals(null)) {
			// 원본 파일명이 있을 때만 파일 입력 처리
			log.info("파일이 있음");
			// 기존 파일이 없을 경우

			log.info("suggestionVO.getAtchmnflNo() -> " + vo.getAtchmnflNo());

			if (vo.getAtchmnflNo() == null || vo.getAtchmnflNo().isEmpty()) {
				log.info("기존 파일이 존재하지 않습니다. 그래서 조건문을 들어옵니다");
				vo.setAtchmnflNo(Integer.toString(attachmnflNo));
				log.info("새롭게 파일 번호번호를 부여합니다." + attachmnflNo);
			}

			// 기존에 있던 파일 번호로 추가
			attachmnflNo = Integer.parseInt(vo.getAtchmnflNo());
			log.info("attachmnflNo --> " + attachmnflNo);
			for (MultipartFile multipartFile : uploadFile) {
				String orginalFileName = multipartFile.getOriginalFilename();
				log.info("원본 파일명 : " + orginalFileName);
				log.info("파일 크기    : " + multipartFile.getSize());
				log.info("MIME타입  : " + multipartFile.getContentType());

				uploadFileName = multipartFile.getOriginalFilename();
				size = multipartFile.getSize(); // 파일 크기
				String mime = multipartFile.getContentType(); // mime타입
				String ext = orginalFileName.substring(orginalFileName.lastIndexOf("."));

				UUID uuid = UUID.randomUUID();
				uploadFileName = uuid.toString() + "_" + ext;
				log.info("uploadFileName : " + uploadFileName);

				File saveFile = new File(uploadFolderDirect + File.separator + uploadFileName);

				try {
					// 파일 복사 실행
					multipartFile.transferTo(saveFile);
					FileToAwsUtil.uploadToS3(saveFile);
					
					AttachedFileVO attachFileVO = new AttachedFileVO();
					attachFileVO.setAtchmnflSize(size);
					attachFileVO.setAtchmnflNm(uploadFileName);
					attachFileVO.setAtchmnflOriginNm(orginalFileName);
					attachFileVO.setAtchmnflUrl( "/" + uploadFileName);
					log.info("attachmnflNo :" + attachmnflNo);

					attachFileVO.setAtchmnflNo(String.valueOf(attachmnflNo));

					log.info("attachFileVO : " + attachFileVO);

					// 파일 정보 데이터베이스에 저장
					result = this.noticeMapper.insertAttachedFile(attachFileVO);
					log.info("file result -> " + result);

					flag = 1;

				} catch (IllegalStateException | IOException e) {
					log.error("파일이 없음" + e.getMessage());
				}
			}
		}
		// 파일이 있을 경우에만 파일 정보를 설정한 후 suggestMapper.createSuggest 호출
		if (flag == 1) {
			log.info("파일이 있음");
			log.info("suggestionVO -> " + vo);
			return this.noticeMapper.updateNotice(vo);
		} else

		{
			log.info("파일이 없음");
			return this.noticeMapper.updateNoFileNotice(vo); // 파일이 없는 경우 호출
		}
	}
	
	
	// 게시글 삭제
	@Override
	public int deleteNotice(NoticeBoardVO vo) {
		return this.noticeMapper.deleteNotice(vo);
	}
	
	//댓글 전체 삭제
	@Override
	public int deleteNoticeAllReply(NoticeBoardVO vo) {
		return this.noticeMapper.deleteNoticeAllReply(vo);
	}
	
	//fishing시간 업데이트
	@Override
	public int updateTimeNotice(NoticeBoardVO vo) {
		return this.noticeMapper.updateTimeNotice(vo);
	}
	
	
	// 홈 공지사항
	@Override
	public List<NoticeBoardVO> homeNoticeList() {
		return this.noticeMapper.homeNoticeList();
	}

	@Override
	public NoticeBoardVO getEmpRspn(NoticeBoardVO vo) {
		return this.noticeMapper.getEmpRspn(vo);
	}

}
