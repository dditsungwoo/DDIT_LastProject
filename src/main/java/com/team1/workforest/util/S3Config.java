package com.team1.workforest.util;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;

@Configuration
public class S3Config {
    @Value("${cloud.aws.credentials.access-key}")
    private String accessKey;
 
    @Value("${cloud.aws.credentials.secret-key}")
    private String secretKey;
 
    @Value("${cloud.aws.region.static}")
    private String region;
 
    @Bean
    @Primary
    public BasicAWSCredentials awsCredentialsProvider(){
        BasicAWSCredentials basicAWSCredentials = new BasicAWSCredentials(accessKey, secretKey);
        return basicAWSCredentials;
    }
 
    @Bean
    public AmazonS3 amazonS3() {
        AmazonS3 s3Builder = AmazonS3ClientBuilder.standard()
                .withRegion(region)
                .withCredentials(new AWSStaticCredentialsProvider(awsCredentialsProvider()))
                .build();
        return s3Builder;
    }
    
    public static  String connectToS3() {
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
	    return bucketName;

    }
    
    
}