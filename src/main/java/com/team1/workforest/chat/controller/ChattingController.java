package com.team1.workforest.chat.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.team1.workforest.chat.service.ChattingService;
import com.team1.workforest.chat.vo.ChatRoomEmployeeVO;
import com.team1.workforest.chat.vo.ChatRoomVO;
import com.team1.workforest.chat.vo.MessageVO;
import com.team1.workforest.employee.vo.EmployeeVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/chat")
public class ChattingController {

	@Autowired
	ChattingService chattingService;
	
	@GetMapping("/main")
	public String chatChat() {
		
		return "chat/main2";
	}
	
	@ResponseBody
	@GetMapping("/getAllChatRoom")
	public List<ChatRoomVO> getAllChatRoom() {
		
		List<ChatRoomVO> chatRoomVOList = this.chattingService.getAllChatRoom();
		
		return chatRoomVOList;
	}
	
	@ResponseBody
	@GetMapping("/getChatRoom")
	public List<ChatRoomEmployeeVO> getChatRoom(@RequestParam Map<String, String> map) {
		
		List<ChatRoomEmployeeVO> chatEmpVOList = this.chattingService.getChatRoom(map);
		
		return chatEmpVOList;
	}
	
	@ResponseBody
	@GetMapping("/getOverMsgCount")
	public int getOverMsgCount(@RequestParam Map<String, String> map) {
		
		int count = this.chattingService.getOverMsgCount(map);
		
		return count;
	}
	
	@ResponseBody
	@GetMapping("/getChat")
	public List<MessageVO> getChat(@RequestParam Map<String, String> map) {
		
		List<MessageVO> msgVOList = this.chattingService.getChat(map);
		
		return msgVOList;
	}
	
	@ResponseBody
	@PostMapping("/addChat")
	public int addChat(@RequestParam Map<String, String> map) {
		
		int data = this.chattingService.addChat(map);
		
		return data;
	}
	
	@ResponseBody
	@GetMapping("/getEmp")
	public EmployeeVO getEmp(@RequestParam Map<String, String> map) {
		
		EmployeeVO data = this.chattingService.getEmp(map);
		
		return data;
	}
	
	@ResponseBody
	@GetMapping("/getChatRoomLastChat")
	public MessageVO getChatRoomLastChat(@RequestParam Map<String, String> map) {
		
		MessageVO data = this.chattingService.getChatRoomLastChat(map);
		
		return data;
	}
	
	@ResponseBody
	@GetMapping("/getEmpList")
	public List<EmployeeVO> getEmpList(@RequestParam Map<String, String> map) {
		
		List<EmployeeVO> data = this.chattingService.getEmpList(map);
		
		return data;
	}
	
	@ResponseBody
	@PostMapping("/addNewChatRoom")
	public int addNewChatRoom(@RequestBody Map<String, String[]> map) {
		int data = this.chattingService.addNewChatRoom(map);
		
		return data;
	}
	
	@ResponseBody
	@GetMapping("/getChatRoomEmp")
	public List<ChatRoomEmployeeVO> getChatRoomEmp(@RequestParam Map<String, String> map) {
		List<ChatRoomEmployeeVO> data = this.chattingService.getChatRoomEmp(map);
		
		return data;
	}
	
	@ResponseBody
	@PutMapping("/modChatRoomNm")
	public int modChatRoomNm(@RequestBody Map<String, String> map) {
		
		int data = this.chattingService.modChatRoomNm(map);
		
		return data;
	}
	
	@ResponseBody
	@PutMapping("/modChatEmpDate")
	public int modChatEmpDate(@RequestBody Map<String, String> map) {
		
		int data = this.chattingService.modChatEmpDate(map);
		
		return data;
	}
	
	@ResponseBody
	@DeleteMapping("/deleteChatRoom")
	public int deleteChatRoom(@RequestBody Map<String, String> map) {
		
		int data = this.chattingService.deleteChatRoom(map);
		
		return data;
	}
	
	@ResponseBody
	@PostMapping(value="/fileUpload",produces = "application/text; charset=utf8")
	public String fileUpload(MultipartHttpServletRequest request) {
		MultipartFile file = request.getFile("upload");
		//파일의 오리지널 명
		String originalFileName = file.getOriginalFilename();
		log.info("uploads->originalFileName : " + originalFileName);
		
		//파일의 확장자(개똥이.jpg)
		String ext = originalFileName.substring(originalFileName.indexOf("."));
		log.info("uploads->ext : " + ext);//.jpg
		
		String newFileName = UUID.randomUUID() + "_" + originalFileName; //sadlfkjsafd.jpg
		
		// 업로드할 파일의 경로를 지정합니다
        String filePath = "C:\\upload\\" + newFileName;
        File newFile = new File(filePath);
        log.info("uploads->filePath : " + filePath);//.jpg
        
        try {
			file.transferTo(newFile);
			log.info("uploads->filePath : " + filePath);//.jpg
			uploadToS3(newFile);	// aws s3에 업로드
			log.info("uploads->filePath : " + filePath);//.jpg
			return newFileName;
		} catch (IllegalStateException | IOException e) {
			e.printStackTrace();
			return "error";
		}
        
	}

	private void uploadToS3(File file) {
	    // AWS 자격 증명을 설정합니다
	    String accessKeyId = "AKIAZQ3DREBNLHW5DO7N";
	    String secretAccessKey = "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";

	    // S3 클라이언트를 생성합니다
	    AmazonS3 s3Client = AmazonS3ClientBuilder.standard()
	            .withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKeyId, secretAccessKey)))
	            .withRegion("ap-northeast-2") // 예: "us-east-1"
	            .build();

	    // 업로드할 버킷 이름을 설정합니다
	    String bucketName = "projectawsimg";

	    // 파일을 업로드할 S3 경로와 파일 이름을 지정합니다
	    String keyName = "img/" + file.getName(); // 예: "uploads/example.jpg"

	    try {
	        // S3에 파일을 업로드합니다
	        s3Client.putObject(new PutObjectRequest(bucketName, keyName, file));
	    } catch (AmazonServiceException e) {
	        // 서비스 오류 처리
	        e.printStackTrace();
	    }
	}
	
}