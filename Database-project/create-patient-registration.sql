CREATE TABLE patient_registration (
    patient_id INTEGER NOT NULL,
    professional_id INTEGER NOT NULL,
    registration_date DATE,
    
    PRIMARY KEY (patient_id, professional_id),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_no),
    FOREIGN KEY (professional_id) REFERENCES professional(professional_id)
);
