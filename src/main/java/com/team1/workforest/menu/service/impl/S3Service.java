package com.team1.workforest.menu.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.ListObjectsRequest;
import com.amazonaws.services.s3.model.ObjectListing;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import com.team1.workforest.menu.vo.S3GetResponseDto;
import com.team1.workforest.menu.vo.S3GetResponseDto2;
import com.team1.workforest.util.S3Config;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class S3Service  {
   
	@Autowired
	S3Config s3Config;
    
    public S3GetResponseDto find(String bucket, String prefix) {
        List<String> fileNames = new ArrayList<>();

        String accessKeyId = "AKIAZQ3DREBNLHW5DO7N";
	    String secretAccessKey = "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";

	    // S3 클라이언트를 생성합니다
	    AmazonS3 s3Client = AmazonS3ClientBuilder.standard()
	            .withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKeyId, secretAccessKey)))
	            .withRegion("ap-northeast-2") // 예: "us-east-1"
	            .build();

	    // 업로드할 버킷 이름을 설정합니다
	    String bucketName = "projectawsimg";
       // AmazonS3 s3Client = AmazonS3ClientBuilder.defaultClient(); // AmazonS3의 인스턴스 생성
        ListObjectsRequest listObjectsRequest = new ListObjectsRequest();
        listObjectsRequest.setBucketName(bucketName);
        if (!prefix.equals("")) {
            listObjectsRequest.setPrefix(prefix);
        }
        ObjectListing s3Objects;
        do {
            s3Objects = s3Client.listObjects(listObjectsRequest);
            for (S3ObjectSummary s3ObjectSummary : s3Objects.getObjectSummaries()) {
                fileNames.add(s3ObjectSummary.getKey());
            }
            listObjectsRequest.setMarker(s3Objects.getNextMarker());
        } while (s3Objects.isTruncated());
        return S3GetResponseDto.from(fileNames);
    }
    
    public S3GetResponseDto findOld(String bucket, String prefix) {
        List<String> fileNames = new ArrayList<>();

        String accessKeyId = "AKIAZQ3DREBNLHW5DO7N";
	    String secretAccessKey = "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";

	    // S3 클라이언트를 생성합니다
	    AmazonS3 s3Client = AmazonS3ClientBuilder.standard()
	            .withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKeyId, secretAccessKey)))
	            .withRegion("ap-northeast-2") // 예: "us-east-1"
	            .build();

	    // 업로드할 버킷 이름을 설정합니다
	    String bucketName = "projectawsimg";
      
        ListObjectsRequest listObjectsRequest = new ListObjectsRequest();
        listObjectsRequest.setBucketName(bucketName);
        if (!prefix.equals("")) {
            listObjectsRequest.setPrefix(prefix + "/");
        }
        listObjectsRequest.setDelimiter("/");
        ObjectListing s3Objects;
        String fileName;
        do {
            s3Objects = s3Client.listObjects(listObjectsRequest);
            for (String commonPrefix : s3Objects.getCommonPrefixes()) { // prefix 경로의 디렉토리를 저장 (ex. v1/)
                if (!prefix.equals("")) {
                    fileName = commonPrefix.split(prefix + "/")[1];
                } else {
                    fileName = commonPrefix;
                }
                fileNames.add(fileName);
            }
            
            // 파일 조회 코드 추가
            for (S3ObjectSummary objectSummary : s3Objects.getObjectSummaries()) { // prefix 경로의 파일명이 있다면 저장 (ex. one.wav)
                String key = objectSummary.getKey();
                String[] split = key.split(prefix + "/");
                if (split.length >= 2) {
                    fileNames.add(split[1]);
                }
            }
            listObjectsRequest.setMarker(s3Objects.getNextMarker()); // listObjects()는 1,000건만 조회, 파일 수가 그 이상인 경우를 대비
        } while (s3Objects.isTruncated());
        return S3GetResponseDto.from(fileNames);
    }
    
    public static S3GetResponseDto2 searchOld(String bucket, String prefix) {
        List<String> fileNames = new ArrayList<>();
        List<Long> fileSizes = new ArrayList<>();
        List<String> fileExtensions = new ArrayList<>();
        List<Date> dates= new ArrayList<>();

        // AWS 액세스 키 설정
        String accessKeyId = "AKIAZQ3DREBNLHW5DO7N";
	    String secretAccessKey = "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";


        // S3 클라이언트 생성
        AmazonS3 s3Client = AmazonS3ClientBuilder.standard()
                .withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKeyId, secretAccessKey)))
                .withRegion("ap-northeast-2") // 예: "us-east-1"
                .build();

        // 버킷 이름 설정
	    String bucketName = "projectawsimg";

        // ListObjectsRequest 생성
        ListObjectsRequest listObjectsRequest = new ListObjectsRequest();
        listObjectsRequest.setBucketName(bucketName);
        if (!prefix.equals("")) {
            listObjectsRequest.setPrefix(prefix + "/");
        }
        listObjectsRequest.setDelimiter("/");
        ObjectListing s3Objects;
        do {
            s3Objects = s3Client.listObjects(listObjectsRequest);
            for (S3ObjectSummary objectSummary : s3Objects.getObjectSummaries()) {
                String key = objectSummary.getKey();
                Date lastModified = objectSummary.getLastModified(); // 마지막 수정일 가져오기
                String[] split = key.split(prefix + "/");
                if (split.length >= 2) {
                    fileNames.add(split[1]);

                    // 파일 크기 추가
                    fileSizes.add(objectSummary.getSize());
                    dates.add(lastModified);	
                    // 파일 확장자 추가
                    String extension = split[1].substring(split[1].lastIndexOf('.') + 1);
                    fileExtensions.add(extension);
                }
            }
            listObjectsRequest.setMarker(s3Objects.getNextMarker());
        } while (s3Objects.isTruncated());
        
        // S3GetResponseDto 반환
        return S3GetResponseDto2.searchfrom(fileNames, fileSizes, fileExtensions,dates);
    }
    
    
    
    
    public static S3GetResponseDto2 searchFile(String bucket, String prefix, String keyword) {
        List<String> fileNames = new ArrayList<>();
        List<Long> fileSizes = new ArrayList<>();
        List<String> fileExtensions = new ArrayList<>();
        List<Date> dates= new ArrayList<>();
        // AWS 액세스 키 설정
        String accessKeyId = "AKIAZQ3DREBNLHW5DO7N";
   	    String secretAccessKey = "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";

        // S3 클라이언트 생성
        AmazonS3 s3Client = AmazonS3ClientBuilder.standard()
                .withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKeyId, secretAccessKey)))
                .withRegion("ap-northeast-2") // 예: "us-east-1"
                .build();

        // 버킷 이름 설정
        String bucketName = "projectawsimg";

        // ListObjectsRequest 생성
        ListObjectsRequest listObjectsRequest = new ListObjectsRequest();
        listObjectsRequest.setBucketName(bucketName);
        if (!prefix.equals("")) {
            listObjectsRequest.setPrefix(prefix + "/");
        }
        listObjectsRequest.setDelimiter("/");
        ObjectListing s3Objects;
        log.info("service 에 prefix :"+prefix);
        log.info("service 에 bucketName :"+bucketName);
        do {
            s3Objects = s3Client.listObjects(listObjectsRequest);
            for (S3ObjectSummary objectSummary : s3Objects.getObjectSummaries()) {
                String key = objectSummary.getKey();
                Date lastModified = objectSummary.getLastModified(); // 마지막 수정일 가져오기
                log.info("service 에 key :"+key);
                if (key.contains(keyword)) { // 키워드를 포함하는지 확인
                    String[] split = key.split(prefix + "/");
                    if (split.length >= 2) {
                        fileNames.add(split[1]);

                        // 파일 크기 추가
                        fileSizes.add(objectSummary.getSize());
                        dates.add(lastModified);

                        // 파일 확장자 추가
                        String extension = split[1].substring(split[1].lastIndexOf('.') + 1);
                        fileExtensions.add(extension);
                    }
                }
            }
            listObjectsRequest.setMarker(s3Objects.getNextMarker());
        } while (s3Objects.isTruncated());
        
        // S3GetResponseDto 반환
        return S3GetResponseDto2.searchfrom(fileNames, fileSizes, fileExtensions,dates);
    }
    
}
