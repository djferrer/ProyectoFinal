package com.netec.medical.repository;

import com.netec.medical.model.DoctorEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IDoctorRepository  extends JpaRepository<DoctorEntity,Long> {

}
