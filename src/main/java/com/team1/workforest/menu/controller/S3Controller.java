package com.team1.workforest.menu.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.team1.workforest.menu.service.impl.S3Service;
import com.team1.workforest.menu.vo.S3GetResponseDto;
import com.team1.workforest.menu.vo.S3GetResponseDto2;
import com.team1.workforest.vo.MenuVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequiredArgsConstructor

@RequestMapping("/s3")
public class S3Controller {
	@Autowired
	S3Service s3Service;

	
	  @GetMapping("/folder/{bucket}/**") 
	  public ResponseEntity<S3GetResponseDto>find(@PathVariable String bucket, HttpServletRequest request) { 
		  String[] split = request.getRequestURI().split("/s3/" + bucket);
		  String prefix = split.length < 2 ? "" : split[1].substring(1); 
		  S3GetResponseDto s3GetResponseDto = s3Service.find(bucket, prefix); 
		  return new ResponseEntity<>(s3GetResponseDto, HttpStatus.OK); 
		  }
	 
	
	@GetMapping("/{bucket}/**")
	public ResponseEntity<S3GetResponseDto2> searchOld(@PathVariable String bucket, HttpServletRequest request) {
		String[] split = request.getRequestURI().split("/s3/" + bucket);
		String prefix = split.length < 2 ? "" : split[1].substring(1);
	
		   log.info("findbucket: "+prefix);
		S3GetResponseDto2 s3GetResponseDto2 = s3Service.searchOld (bucket, prefix);
		return new ResponseEntity<>(s3GetResponseDto2, HttpStatus.OK);
	}
	
	@PostMapping("/find/{bucket}/**")
	public ResponseEntity<S3GetResponseDto2> searchFile(@PathVariable String bucket,@RequestBody MenuVO vo, HttpServletRequest request) {
		 String[] split = request.getRequestURI().split("/s3/find/" + bucket);
		 String prefix = split.length < 2 ? "" : split[1].substring(1); 
	   

	    
	   
	   log.info("findbucket prefix: "+prefix);
	

		S3GetResponseDto2 s3GetResponseDto2 = s3Service.searchFile(bucket, prefix, vo.getMenuNm());
		log.info("s3GetResponseDto2: "+s3GetResponseDto2);
		return new ResponseEntity<>(s3GetResponseDto2, HttpStatus.OK);
	}
}
