package com.team1.workforest.duty.service.impl;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.imgscalr.Scalr;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import com.team1.workforest.duty.mapper.DutyMapper;
import com.team1.workforest.duty.service.DutyService;
import com.team1.workforest.duty.vo.DutyRecipientVO;
import com.team1.workforest.duty.vo.DutyVO;
import com.team1.workforest.reservation.meetingroom.vo.MtrReservationVO;
import com.team1.workforest.schedulerUtil.controller.ChatHandler;
import com.team1.workforest.util.FileToAwsUtil;

import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnails;

@Slf4j
@Service
public class DutyServiceImpl implements DutyService {
	@Autowired
	DutyMapper dutyMapper;
	
	@Autowired
	String uploadPath;
	
	
	@Override
	public List<DutyVO> getDutyList(Map<String, Object> map) {
		List<DutyVO> list= this.dutyMapper.getDutyList(map);
		getYYMMDDDutyVO(list);
		return list;
	}
	
	





	@Override
	public List<DutyRecipientVO> getPieChart(DutyVO vo) {
		return this.dutyMapper.getPieChart(vo);
	}





	@Override
	public List<DutyVO> todayDoList(DutyVO vo) {
		List<DutyVO> list =this.dutyMapper.todayDoList(vo);
		getYYMMDDDutyVO(list);	
		return list;
	}





	@Override
	public int clickAndDone(DutyVO vo) {
		return this.dutyMapper.clickAndDone(vo);
	}





	@Override
	public List<DutyVO> weekDoList(DutyVO vo) {		
		List<DutyVO> list =this.dutyMapper.weekDoList(vo);
		getYYMMDDDutyVO(list);	
		return list;
	}



	//일을 받은 사람이 클릭할때 (읽음표시되게)
	@Override
	public DutyVO dutyDetail(DutyVO vo) {
		vo= this.dutyMapper.dutyDetail(vo);
		//String dutyCn= convertHtml(vo.getDutyCn());
		//vo.setDutyCn(dutyCn);
		getOneYYMMDDDutyVO(vo);
		if(vo.getCnfirmDate().equals("0")) {
			int result= this.dutyMapper.updateCnfirmDate(vo);
		}
		return vo;
	}





	@Override
	public int detailPrgsUpdate(DutyVO vo) {
		return this.dutyMapper.detailPrgsUpdate(vo);
	}





	@Override
	public List<DutyVO> senderChart1(DutyVO vo) {
		return this.dutyMapper.senderChart1(vo);
	}





	@Override
	public List<DutyVO> senderChart2(DutyVO vo) {	
		List<DutyVO> list= this.dutyMapper.senderChart2(vo);
		getYYMMDDDutyVO(list);
		return list;
	}





	@Override
	public List<DutyVO> senderChart3(DutyVO vo) {
		List<DutyVO> list= this.dutyMapper.senderChart3(vo);
		getYYMMDDDutyVO(list);
		return list;
	}





	@Override
	public List<DutyVO> getDutyListForSender(Map<String, Object> map) {
		List<DutyVO> list= this.dutyMapper.getDutyListForSender(map);
		getYYMMDDDutyVO(list);
		for(int i=0; i<list.size(); i++) {
			String cndate = list.get(i).getCnfirmDate();
			if(cndate.equals("0")) {
				list.get(i).setCnfirmDate("읽지않음"); 
			}else {
				list.get(i).setCnfirmDate("읽음"); 
			}
		}
		return list;
	}





	@Override
	public List<DutyVO> getDutyListCnfirmDate(Map<String, Object> map) {
		List<DutyVO> list= this.dutyMapper.getDutyListCnfirmDate(map);
		getYYMMDDDutyVO(list);
		for(int i=0; i<list.size(); i++) {
			String cndate = list.get(i).getCnfirmDate();
			if(cndate.equals("0")) {
				list.get(i).setCnfirmDate("읽지않음"); 
			}else {
				list.get(i).setCnfirmDate("읽음"); 
			}
		}
		return list;
	}


	//일을 보낸 사람이 클릭할때 (읽음표시안되게)
	@Override
	public DutyVO senderDetail(DutyVO vo) {
		vo= this.dutyMapper.senderDetail(vo);
		getOneYYMMDDDutyVO(vo);
		//String dutyCn= convertHtml(vo.getDutyCn());
		//vo.setDutyCn(dutyCn);
		String cndate = vo.getCnfirmDate();
		if(cndate.equals("0")) {
			vo.setCnfirmDate("읽지않음"); 
		}else {
			vo.setCnfirmDate("읽음"); 
		}
		return vo;
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
        // MIME(Multipurpose Internet Mail Extensions) : 문서, 파일 또는 바이트 집합의 성격과
        // 형식. 표준화
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
	
	
	
	
	//yymmdd날짜를 변환해주는 함수
	public  List<DutyVO> getYYMMDDDutyVO(List<DutyVO> list){
		for (int i = 0; i < list.size(); i++) {
			String sendDate=list.get(i).getSendDate();			
			String closDate=list.get(i).getClosDate();
			String cnfirmDate=list.get(i).getCnfirmDate();
			
				if(sendDate!=null && !sendDate.equals("0")) {
				LocalDate localDate = LocalDate.parse(sendDate, DateTimeFormatter.ofPattern("yyyyMMdd"));
				DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate = localDate.format(outputFormatter);
				list.get(i).setSendDate(formattedDate);
				}
				if(closDate!=null &&  !closDate.equals("0")) {				
				LocalDate localDate2 = LocalDate.parse(closDate, DateTimeFormatter.ofPattern("yyyyMMdd"));
				DateTimeFormatter outputFormatter2 = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate2 = localDate2.format(outputFormatter2);
				list.get(i).setClosDate(formattedDate2);
				}
				if(cnfirmDate!=null &&  !cnfirmDate.equals("0")) {
				LocalDate localDate3 = LocalDate.parse(cnfirmDate, DateTimeFormatter.ofPattern("yyyyMMdd"));
				DateTimeFormatter outputFormatter3 = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate3 = localDate3.format(outputFormatter3);			
				list.get(i).setCnfirmDate(formattedDate3);
				}
		}

		return list;
	}

	//yymmdd날짜를 변환해주는 함수 한개용
	public  DutyVO getOneYYMMDDDutyVO(DutyVO list){
		
			String sendDate=list.getSendDate();			
			String closDate=list.getClosDate();
			String cnfirmDate=list.getCnfirmDate();
				if(sendDate!=null &&  !sendDate.equals("0")) {
				LocalDate localDate = LocalDate.parse(sendDate, DateTimeFormatter.ofPattern("yyyyMMdd"));
				DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate = localDate.format(outputFormatter);
				list.setSendDate(formattedDate);
				}
				if(closDate!=null &&  !closDate.equals("0")) {				
				LocalDate localDate2 = LocalDate.parse(closDate, DateTimeFormatter.ofPattern("yyyyMMdd"));
				DateTimeFormatter outputFormatter2 = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate2 = localDate2.format(outputFormatter2);
				list.setClosDate(formattedDate2);
				}
				if(cnfirmDate!=null &&  !cnfirmDate.equals("0")) {
				LocalDate localDate3 = LocalDate.parse(cnfirmDate, DateTimeFormatter.ofPattern("yyyyMMdd"));
				DateTimeFormatter outputFormatter3 = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate3 = localDate3.format(outputFormatter3);			
				list.setCnfirmDate(formattedDate3);
				
		}

		return list;
	}
	

	    public static String convertToBase64(MultipartFile file) throws IOException {
	        byte[] bytes = file.getBytes();
	        return Base64.getEncoder().encodeToString(bytes);
	    }


	    public static String thumbnailAndBase64(MultipartFile uploadFile) throws IOException {
	        // 업로드된 파일을 임시 파일로 저장
	        File tempFile = File.createTempFile("temp", null);
	        uploadFile.transferTo(tempFile);

	        // 썸네일 생성
	        BufferedImage originalImage = ImageIO.read(tempFile);
	        BufferedImage thumbnail = Scalr.resize(originalImage, 300);

	        // 썸네일을 파일로 저장 (optional)
	        File thumbnailFile = File.createTempFile("thumbnail", null);
	        ImageIO.write(thumbnail, "jpg", thumbnailFile);

	        // 썸네일을 Base64로 인코딩
	        ByteArrayOutputStream baos = new ByteArrayOutputStream();
	        Thumbnails.of(thumbnailFile)
	                .scale(1)
	                .outputFormat("jpg")
	                .toOutputStream(baos);
	        byte[] thumbnailBytes = baos.toByteArray();
	        String thumbnailBase64 = Base64.getEncoder().encodeToString(thumbnailBytes);

	        // 임시 파일 삭제
	        tempFile.delete();
	        thumbnailFile.delete();
	        
	        return thumbnailBase64;
	    }
	    
	    public String convertText(String text) {
	        return text.replaceAll("(\r\n|\n\r|\r|\n)", "<br>");
	    }

	    public String convertHtml(String text) {
	        return text.replaceAll("<br>","\n");
	    }



	@Override
	public int insertDuty(DutyVO vo) {
		
		File uploadPath1 = new File(uploadPath, getFolder());
		
		 if (uploadPath1.exists() == false) {
	            uploadPath1.mkdirs();
	        }
		String uploadFileName = "";
		 
		MultipartFile uploadFile = vo.getUploadFile();

		uploadFileName = uploadFile.getOriginalFilename();
          
		UUID uuid = UUID.randomUUID();
        uploadFileName = uuid.toString() + "_" + uploadFileName;
        vo.setAtchmnflNo(" ");
        File saveFile =
                new File(uploadPath + "\\" +  uploadFileName);
        String base64="";
        if(!uploadFile.getOriginalFilename().equals("") && uploadFile.getOriginalFilename()!=null) {
        try {
        	uploadFile.transferTo(saveFile);
        	//base64=thumbnailAndBase64(uploadFile);
        	log.info("base64"+base64);      	
        	//vo.setBase64(base64);
        	FileToAwsUtil.uploadToS3(saveFile);
        			
        }catch (IllegalStateException | IOException e) {
        	log.error(e.getMessage());
		}       
		
		vo.setAtchmnflNo( "/" +
		uploadFileName);
        }
		 
		String dutyCn= vo.getDutyCn();
		dutyCn=convertText(dutyCn);
		vo.setDutyCn(dutyCn);
		int result= this.dutyMapper.insertDuty(vo);
		
		
		DutyVO lastVO =this.dutyMapper.selectLast();
		String[] recipient = vo.getRecipientNo();
		String rDutyNo= lastVO.getDutyNo();
		for (int i=0; i<recipient.length; i++) {
			DutyRecipientVO rVo= new DutyRecipientVO();
			rVo.setDutyNo(rDutyNo);
			if (recipient[i] !=null && !recipient[i].equals("")) {
				rVo.setEmpNo(recipient[i]);
				result += this.dutyMapper.insertDutyRecipient(rVo);
			}	
		}
		
		// 수신자에게 업무 알람 보내기
		List<WebSocketSession> list = ChatHandler.list;
		for(String recipientEmpNo : recipient) {
			
			TextMessage message = new TextMessage(" :%" + recipientEmpNo + ":% 새로운 업무가 도착했습니다. :%dutyReceive");
			
			for (WebSocketSession webSocketSession : list) {
				try {
					webSocketSession.sendMessage(message);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			
		}
		
		return result;
	}




	@Override
	public int deleteDuty(DutyVO vo) {
		return this.dutyMapper.deleteDuty(vo);
	}







	@Override
	public int updateDuty(DutyVO vo) {
		int result= this.dutyMapper.updateDuty(vo);
		result += this.dutyMapper.noRead(vo);
		//getOneYYMMDDDutyVO(vo);
		return result;
	}







	@Override
	public List<DutyVO> getDashDuty(DutyVO vo) {
		List<DutyVO> list= this.dutyMapper.getDashDuty(vo);
		getYYMMDDDutyVO(list);		
		return list;
	}







	@Override
	public int getDashTotal(DutyVO vo) {
		return this.dutyMapper.getDashTotal(vo);
	}
    
    

}
