package com.netec.medical.controller;

import com.netec.medical.controller.docs.IDoctorDoc;
import com.netec.medical.model.DoctorEntity;
import com.netec.medical.service.IDoctorsService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/doctor")
@AllArgsConstructor
@CrossOrigin(origins = "*")
public class DoctorController  implements IDoctorDoc {

    private final IDoctorsService doctorsService;

    @Override
    public ResponseEntity<List<DoctorEntity>> listAll() {
        return this.doctorsService.listAll();
    }
}
