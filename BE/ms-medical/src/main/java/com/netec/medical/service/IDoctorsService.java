package com.netec.medical.service;

import com.netec.medical.model.DoctorEntity;
import org.springframework.http.ResponseEntity;

import java.util.List;

public interface IDoctorsService {

    ResponseEntity<List<DoctorEntity>> listAll();
}
