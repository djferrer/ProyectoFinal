package com.netec.medical.service.impl;

import com.netec.medical.model.DoctorEntity;
import com.netec.medical.repository.IDoctorRepository;
import com.netec.medical.service.IDoctorsService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class DoctorsServiceImpl implements IDoctorsService {

    private final IDoctorRepository iDoctorRepository;

    @Override
    public ResponseEntity<List<DoctorEntity>> listAll() {
        List<DoctorEntity> doctors = this.iDoctorRepository.findAll();
        return ResponseEntity.ok(doctors);
    }
}
