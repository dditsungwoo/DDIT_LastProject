package com.team1.workforest.admin.reservation.service.impl;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.team1.workforest.admin.reservation.mapper.AdminResourcesMapper;
import com.team1.workforest.admin.reservation.service.AdminResourcesService;
import com.team1.workforest.reservation.car.vo.CarVO;
import com.team1.workforest.reservation.meetingroom.vo.MtrEquipmentVO;
import com.team1.workforest.reservation.meetingroom.vo.MtrVO;
import com.team1.workforest.util.FileToAwsUtil;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AdminResourcesServiceImpl implements AdminResourcesService{
		
	@Autowired
	AdminResourcesMapper adminResourcesMapper;
		
	@Override
	public List<MtrVO> getMtrList() {
		return adminResourcesMapper.getMtrList();
	}
	
	@Override
	public int createMtr(MtrVO mtrVO) {
		MultipartFile uploadFile = mtrVO.getUploadFile();		
		String uploadFileName = uploadFileAndReturnFilename(uploadFile);

		mtrVO.setPhotoUrl(uploadFileName);

		int result = adminResourcesMapper.createMtr(mtrVO);

		// 장비 테이블에 insert
		List<MtrEquipmentVO> mtrEquipmentList = new ArrayList<MtrEquipmentVO>();

		String[] equipments = mtrVO.getEquipments();
		List<String> equipmentList = Arrays.asList(equipments);

		for (int i = 1; i <= 4; i++) {
			MtrEquipmentVO mtrEquipmentVO = new MtrEquipmentVO();
			mtrEquipmentVO.setMtrNo(mtrVO.getMtrNo());
			mtrEquipmentVO.setEqpmnNo(String.valueOf(i));

			if (equipmentList.contains(String.valueOf(i))) {
				mtrEquipmentVO.setEquipYnCd("1");

			} else {
				mtrEquipmentVO.setEquipYnCd("0");

			}

			result += adminResourcesMapper.createMtrEquipment(mtrEquipmentVO);
		}
		
		return result;
	}

	@Override
	public int updateMtr(MtrVO mtrVO) {
		if (mtrVO.getUploadFile() != null) {
			MultipartFile uploadFile = mtrVO.getUploadFile();
			String uploadFileName = uploadFileAndReturnFilename(uploadFile);

			mtrVO.setPhotoUrl(uploadFileName);
		}

		int result = adminResourcesMapper.updateMtr(mtrVO);

		// 장비 테이블 update
		List<MtrEquipmentVO> mtrEquipmentList = new ArrayList<MtrEquipmentVO>();

		String[] equipments = mtrVO.getEquipments();
		List<String> equipmentList = Arrays.asList(equipments);

		for (int i = 1; i <= 4; i++) {
			MtrEquipmentVO mtrEquipmentVO = new MtrEquipmentVO();
			mtrEquipmentVO.setMtrNo(mtrVO.getMtrNo());
			mtrEquipmentVO.setEqpmnNo(String.valueOf(i));

			if (equipmentList.contains(String.valueOf(i))) {
				mtrEquipmentVO.setEquipYnCd("1");

			} else {
				mtrEquipmentVO.setEquipYnCd("0");

			}

			result += adminResourcesMapper.updateMtrEquipment(mtrEquipmentVO);
		}

		return result;

	}

	@Override
	public int deleteMtr(String mtrNo) {
		int result = adminResourcesMapper.deleteMtr(mtrNo);
		
		result += adminResourcesMapper.deleteMtrEquipment(mtrNo);
		
		return result;
	}

	@Override
	public List<CarVO> getCarList() {
		return adminResourcesMapper.getCarList();
	}

	@Override
	public int createCar(CarVO carVO) {
		MultipartFile uploadFile = carVO.getUploadFile();
		String uploadFileName = uploadFileAndReturnFilename(uploadFile);

		carVO.setPhotoUrl(uploadFileName);

		int result = adminResourcesMapper.createCar(carVO);
	
		return result;
	}

	@Override
	public int updateCar(CarVO carVO) {
		if(carVO.getUploadFile() != null) {			
			MultipartFile uploadFile = carVO.getUploadFile();
			String uploadFileName = uploadFileAndReturnFilename(uploadFile);

			carVO.setPhotoUrl(uploadFileName);			
		}
		
		int result = adminResourcesMapper.updateCar(carVO);
		
		return result;
	}

	@Override
	public int deleteCar(String carNo) {
		return adminResourcesMapper.deleteCar(carNo);
	}

	@Override
	public String createMtrNo() {
		return adminResourcesMapper.createMtrNo();
	}
	
	// 파일을 업로드하고 업로드 파일 이름을 반환
	public String uploadFileAndReturnFilename(MultipartFile uploadFile) {
		// 파일 원래 이름
		String originalFileName = uploadFile.getOriginalFilename();
		log.info("uploads->originalFileName : ", originalFileName);

		// 파일 이름 중복 방지
		UUID uuid = UUID.randomUUID();
		String uploadFileName = uuid.toString() + "_" + originalFileName;

		// 업로드할 파일 경로 지정
		String filePath = "C:\\upload\\" + uploadFileName;
		File newFile = new File(filePath);
		log.info("uploads->filePath : " + filePath);

		// 파일 복사, 파일 업로드
		try {
			uploadFile.transferTo(newFile);
			FileToAwsUtil.uploadToS3(newFile);

		} catch (IllegalStateException e) {
			log.error(e.getMessage());
		} catch (IOException e) {
			log.error(e.getMessage());
		}
		
		return uploadFileName;
	}

}
