package com.team1.workforest.menu.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.menu.service.MenuService;
import com.team1.workforest.vo.MenuVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/menu")
public class MenuController {
	@Autowired
	MenuService menuService;
	

	@Autowired
	String uploadPath;
	
	@GetMapping("/glance")
	public String glance() {
		return "menu/glance";
	}
	
	
	@ResponseBody	
	@GetMapping("/selectMenu")
	public List<MenuVO> selectMenu(){
		
		 List<MenuVO> list= this.menuService.selectMenu();
		 
		 return list;
	}
	
	
	@ResponseBody
	@PostMapping("/insertGlance")
	public int insertGlance(@RequestBody MenuVO vo) {
		log.info("insertGlance"+vo);
		log.info("insertGlance",vo);
		int result=this.menuService.insertGlance(vo);
		return result;
	}
	
	@ResponseBody	
	@PostMapping("/selectGlance")
	public List<MenuVO> selectGlance(@RequestBody MenuVO vo){
		
		 List<MenuVO> list= this.menuService.selectGlance(vo);
		 
		 return list;
	}
	
	
	@ResponseBody	
	@PostMapping("/selectEmail")
	public List<MenuVO> selectEmail(@RequestBody EmployeeVO vo){
		
		 List<MenuVO> list= this.menuService.selectEmail(vo);
		 
		 return list;
	}
	
	@GetMapping("/archive")
	public String archive(@RequestParam(required = false) String deptNo, Model model) {
		
		model.addAttribute("deptNo",deptNo);
		return "menu/archive";
	}
	
	@GetMapping("/archive2")
	public String archive2(@RequestParam(required = false) String deptNo, Model model) {
		
		model.addAttribute("deptNo",deptNo);
		return "menu/archive2";
	}
	
	@PostMapping("/uploadFile")
	public String uploadFile(MenuVO vo) throws IOException {
	    String accessKeyId = "AKIAZQ3DREBNLHW5DO7N";
	    String secretAccessKey = "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";
	    
	    // S3 클라이언트를 생성합니다
	    AmazonS3 s3Client = AmazonS3ClientBuilder.standard()
	            .withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKeyId, secretAccessKey)))
	            .withRegion("ap-northeast-2") // 예: "us-east-1"
	            .build();

	    // 업로드할 버킷 이름을 설정합니다
	    String bucketName = "projectawsimg";
		log.info("uploadFilevo",vo);
		String uploadFileName="";
		String deptNo= vo.getMenuNm();
		MultipartFile[] uploadFile = vo.getUploadFile();
		for (MultipartFile multipartFile : uploadFile) {
        log.info("원본 파일명 : " + multipartFile.getOriginalFilename());
        uploadFileName = multipartFile.getOriginalFilename();
        UUID uuid = UUID.randomUUID();
        uploadFileName = uuid.toString() + "_" + uploadFileName;
        
	    String keyName = "img/" +deptNo+"/"+ uploadFileName; // 예: "uploads/example.jpg"
	    File file= new File(uploadPath + "\\" + uploadFileName);
	    try {
	        // S3에 파일을 업로드합니다
	    	multipartFile.transferTo(file);
	        s3Client.putObject(new PutObjectRequest(bucketName, keyName, file));
	    } catch (AmazonServiceException e) {
	        // 서비스 오류 처리
	        e.printStackTrace();
	    }
	}
		return "redirect:/menu/archive?deptNo="+deptNo;
	}
	
	@ResponseBody
	@PostMapping("/deleteFile")
	public String deleteFile(@RequestBody MenuVO vo) {
		String accessKeyId = "AKIAZQ3DREBNLHW5DO7N";
	    String secretAccessKey = "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";
	    log.info("deleteFile"+vo.getPageUrl());
	    // S3 클라이언트를 생성합니다
	    AmazonS3 s3Client = AmazonS3ClientBuilder.standard()
	            .withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKeyId, secretAccessKey)))
	            .withRegion("ap-northeast-2") // 예: "us-east-1"
	            .build();

	    // 업로드할 버킷 이름을 설정합니다
	    String bucketName = "projectawsimg";
	    String path= "img/"+vo.getPageUrl().trim();
	    log.info("deleteFile"+path);
	    s3Client.deleteObject(bucketName,path);
		return "success";
	}
	
	
	
}
