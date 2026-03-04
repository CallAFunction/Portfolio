CREATE TABLE patient_registration (
   INTEGER NOT NULL,
  mission_id INTEGER NOT NULL,
  -- role TEXT, --

  PRIMARY KEY (astronaut_id, mission_id),
  FOREIGN KEY (astronaut_id) REFERENCES astronauts(astronaut_id),
  FOREIGN KEY (mission_id) REFERENCES missions(mission_id)
);

