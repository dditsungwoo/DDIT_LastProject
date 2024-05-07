package com.team1.workforest.util;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class UploadController {
	
	@Autowired
	String uploadFolderDirect;
	
	//ckeditor이미지업로드
	@ResponseBody
	@PostMapping("/upload/uploads")
	public Map<String,Object> uploads(MultipartHttpServletRequest request) throws IllegalStateException, IOException{
		// ckeditor 에서 파일을 보낼 때 {upload:[파일]} 형식으로 해서 
		//		넘어오기 때문에 upload라는 키의 밸류를 받아서 uploadFile에 저장함
		MultipartFile uploadFile = request.getFile("upload");
		log.info("uploads->uploadFile : " + uploadFile);
		
		//파일의 오리지널 명
		String originalFileName = uploadFile.getOriginalFilename();
		log.info("uploads->originalFileName : " + originalFileName);
		
		//파일의 확장자(개똥이.jpg)
		String ext = originalFileName.substring(originalFileName.indexOf("."));
		log.info("uploads->ext : " + ext);//.jpg
		
		String newFileName = UUID.randomUUID() + ext; //sadlfkjsafd.jpg
		
		// 이미지를 현재 경로와 연관된 파일에 저장하기 위해 현재 경로를 알아냄
		// String realPath = request.getServletContext().getRealPath("/");
		String url = request.getRequestURL().toString();
		log.info("uploads->url(bef) : " + url);
		// http://localhost/
		// http://192.168.93.73/
		url = url.substring(0, url.indexOf("/", 7));
		log.info("uploads->url(aft) : " + url);
		
		//물리적 저장 경로 .../upload + "\\" + sadlfkjsafd.jpg
		String savePath = this.uploadFolderDirect + "\\" + newFileName;
		log.info("uploads->savePath : " + savePath);
		
		//웹 경로
		String uploadPath = "/resources/upload/chatPhoto/" + newFileName;
		log.info("uploads->uploadPath : " + uploadPath);
		
		
		//설계
		File file = new File(savePath);
		//파일 업로드 처리
		uploadFile.transferTo(file);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("uploaded", true);
		map.put("url", url + uploadPath);
		//map : {uploaded=true, url=http://localhost/resources/upload/b8baefc3-34c0-44c8-af3b-4a9464a61e7c.jpg}
		log.info("uploads->map : " + map);
		
		return map;
	}
	
}




