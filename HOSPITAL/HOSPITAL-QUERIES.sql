CREATE DATABASE HospitalDataBase;
USE HospitalDataBase;

CREATE TABLE Department(
 DeptID INT PRIMARY KEY,
 DeptName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Patient(
 PatientID INT PRIMARY KEY,
 FirstName VARCHAR(50) NOT NULL,
 LastName VARCHAR(50) NOT NULL,
 DOB DATE NOT NULL,
 Gender VARCHAR(10) CHECK (Gender IN ('Male','Female')),
 Address VARCHAR(200),
 FullName AS (FirstName + ' ' + LastName),
 Age AS (DATEDIFF(YEAR, DOB, GETDATE()))
);

CREATE TABLE PatientPhones(
 PhoneID INT IDENTITY PRIMARY KEY,
 PatientID INT NOT NULL,
 Phone VARCHAR(20) NOT NULL UNIQUE,
 FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);

CREATE TABLE PatientEmails(
 EmailID INT IDENTITY PRIMARY KEY,
 PatientID INT NOT NULL,
 Email VARCHAR(100) NOT NULL UNIQUE,
 FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);


CREATE TABLE Doctor(
 DoctorID INT PRIMARY KEY,
 FirstName VARCHAR(50) NOT NULL,
 LastName VARCHAR(50) NOT NULL,
 Specialty VARCHAR(50),
 LicenseNo VARCHAR(50) UNIQUE,
 DeptID INT NOT NULL,
 FullName AS (FirstName + ' ' + LastName),
 FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

CREATE TABLE DoctorPhones(
 PhoneID INT IDENTITY PRIMARY KEY,
 DoctorID INT,
 Phone VARCHAR(20) UNIQUE,
 FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);

CREATE TABLE DoctorEmails(
 EmailID INT IDENTITY PRIMARY KEY,
 DoctorID INT,
 Email VARCHAR(100) UNIQUE,
 FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);

CREATE TABLE Nurse(
 NurseID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL,
 HireDate DATE NOT NULL,
 YearsOfService AS (DATEDIFF(YEAR, HireDate, GETDATE()))
);

CREATE TABLE NursePhones(
 PhoneID INT IDENTITY PRIMARY KEY,
 NurseID INT,
 Phone VARCHAR(20) UNIQUE,
 FOREIGN KEY (NurseID) REFERENCES Nurse(NurseID)
);

CREATE TABLE NurseEmails(
 EmailID INT IDENTITY PRIMARY KEY,
 NurseID INT,
 Email VARCHAR(100) UNIQUE,
 FOREIGN KEY (NurseID) REFERENCES Nurse(NurseID)
);


CREATE TABLE Ward(
 WardID INT PRIMARY KEY,
 WardName VARCHAR(50) NOT NULL UNIQUE,
 Floor INT CHECK (Floor >= 0),
 BedCount INT CHECK (BedCount > 0)
);

CREATE TABLE WardFacilities(
 WardID INT,
 Facility VARCHAR(50),
 PRIMARY KEY (WardID, Facility),
 FOREIGN KEY (WardID) REFERENCES Ward(WardID)
);


CREATE TABLE Appointment(
 AppointmentID INT PRIMARY KEY,
 PatientID INT NOT NULL,
 DoctorID INT NOT NULL,
 ApptDateTime DATETIME NOT NULL,
 Reason VARCHAR(200),
 Status VARCHAR(20) CHECK (Status IN ('Pending','Done','Cancelled')),
 IsPast AS (CASE WHEN ApptDateTime < GETDATE() THEN 1 ELSE 0 END),
 FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
 FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);

CREATE TABLE AppointmentNotes(
 NoteID INT IDENTITY PRIMARY KEY,
 AppointmentID INT,
 Note VARCHAR(200),
 FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID)
);


CREATE TABLE Medication(
 MedicineID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL UNIQUE,
 Stock INT CHECK (Stock >= 0),
 IsLowStock AS (CASE WHEN Stock < 50 THEN 1 ELSE 0 END)
);

CREATE TABLE MedicationSideEffects(
 MedicineID INT,
 SideEffect VARCHAR(100),
 PRIMARY KEY (MedicineID, SideEffect),
 FOREIGN KEY (MedicineID) REFERENCES Medication(MedicineID)
);

CREATE TABLE MedicationIngredients(
 MedicineID INT,
 Ingredient VARCHAR(100),
 PRIMARY KEY (MedicineID, Ingredient),
 FOREIGN KEY (MedicineID) REFERENCES Medication(MedicineID)
);


CREATE TABLE MedicalRecord(
 RecordID INT PRIMARY KEY,
 PatientID INT NOT NULL,
 CreatedDate DATE NOT NULL,
 FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);

CREATE TABLE RecordDiagnoses(
 RecordID INT,
 Diagnosis VARCHAR(100),
 PRIMARY KEY (RecordID, Diagnosis),
 FOREIGN KEY (RecordID) REFERENCES MedicalRecord(RecordID)
);

CREATE TABLE RecordAllergies(
 RecordID INT,
 Allergy VARCHAR(100),
 PRIMARY KEY (RecordID, Allergy),
 FOREIGN KEY (RecordID) REFERENCES MedicalRecord(RecordID)
);


CREATE TABLE Invoice(
 InvoiceID INT PRIMARY KEY,
 PatientID INT NOT NULL,
 TotalAmount DECIMAL(10,2) CHECK (TotalAmount >= 0),
 PaidAmount DECIMAL(10,2) CHECK (PaidAmount >= 0),
 BalanceDue AS (TotalAmount - PaidAmount),
 IsPaidFully AS (CASE WHEN PaidAmount >= TotalAmount THEN 1 ELSE 0 END),
 FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);

CREATE TABLE InvoiceLines(
 LineID INT IDENTITY PRIMARY KEY,
 InvoiceID INT,
 Description VARCHAR(100),
 Amount DECIMAL(10,2) CHECK (Amount > 0),
 FOREIGN KEY (InvoiceID) REFERENCES Invoice(InvoiceID)
);





INSERT INTO Department VALUES
(1,'Emergency'),(2,'Cardiology'),(3,'Neurology'),(4,'Orthopedics'),(5,'Pediatrics');


INSERT INTO Patient(PatientID,FirstName,LastName,DOB,Gender,Address) VALUES
(1,'Ali','Khan','1995-05-10','Male','Karachi'),
(2,'Sara','Ahmed','1998-03-12','Female','Lahore'),
(3,'Usman','Raza','1990-11-01','Male','Islamabad'),
(4,'Ayesha','Malik','2000-02-20','Female','Rawalpindi'),
(5,'Bilal','Hussain','1988-07-07','Male','Faisalabad'),
(6,'Hina','Sheikh','1997-09-14','Female','Multan'),
(7,'Kamran','Iqbal','1992-01-30','Male','Sialkot'),
(8,'Nida','Khan','1999-12-05','Female','Quetta'),
(9,'Asad','Ali','1985-06-18','Male','Hyderabad'),
(10,'Zara','Noor','2001-04-25','Female','Peshawar'),
(11,'Farhan','Latif','1993-08-08','Male','Karachi'),
(12,'Maham','Rauf','1996-10-19','Female','Lahore'),
(13,'Saad','Butt','1989-02-02','Male','Gujranwala'),
(14,'Iqra','Javed','2002-05-15','Female','Sargodha'),
(15,'Hamza','Shah','1994-09-09','Male','Abbottabad'),
(16,'Anum','Saleem','1998-11-11','Female','Bahawalpur'),
(17,'Danish','Mehmood','1987-03-03','Male','Kasur'),
(18,'Hoor','Fatima','2000-07-21','Female','Okara'),
(19,'Imran','Akhtar','1991-12-12','Male','Mardan'),
(20,'Laiba','Asif','2003-01-01','Female','Swat');


INSERT INTO Doctor(DoctorID,FirstName,LastName,Specialty,LicenseNo,DeptID) VALUES
(1,'Dr','Saleem','Emergency','LIC101',1),
(2,'Dr','Hassan','Cardiology','LIC102',2),
(3,'Dr','Amir','Neurology','LIC103',3),
(4,'Dr','Faisal','Orthopedics','LIC104',4),
(5,'Dr','Naveed','Pediatrics','LIC105',5),
(6,'Dr','Tariq','Emergency','LIC106',1),
(7,'Dr','Uzma','Cardiology','LIC107',2),
(8,'Dr','Rehan','Neurology','LIC108',3),
(9,'Dr','Adeel','Orthopedics','LIC109',4),
(10,'Dr','Sadia','Pediatrics','LIC110',5);


INSERT INTO Nurse VALUES
(1,'Nurse A','2015-01-01'),(2,'Nurse B','2016-02-02'),(3,'Nurse C','2017-03-03'),
(4,'Nurse D','2018-04-04'),(5,'Nurse E','2019-05-05'),(6,'Nurse F','2020-06-06'),
(7,'Nurse G','2014-07-07'),(8,'Nurse H','2013-08-08'),(9,'Nurse I','2012-09-09'),
(10,'Nurse J','2011-10-10');


INSERT INTO Ward VALUES
(1,'Ward-A',1,20),(2,'Ward-B',2,25),(3,'Ward-C',3,30),(4,'Ward-D',4,15),(5,'Ward-E',5,10);

INSERT INTO Appointment VALUES
(1,1,1,'2024-01-01 10:00','Checkup','Done'),
(2,2,2,'2024-01-02 11:00','Heart Pain','Done'),
(3,3,3,'2024-01-03 12:00','Migraine','Done'),
(4,4,4,'2024-01-04 09:00','Fracture','Done'),
(5,5,5,'2024-01-05 08:30','Child Fever','Done'),
(6,6,6,'2024-01-06 10:30','Emergency','Pending'),
(7,7,7,'2024-01-07 11:30','ECG','Pending'),
(8,8,8,'2024-01-08 12:30','MRI','Pending'),
(9,9,9,'2024-01-09 13:30','Bone Pain','Pending'),
(10,10,10,'2024-01-10 14:30','Vaccination','Pending'),
(11,11,1,'2024-01-11 10:00','Checkup','Done'),
(12,12,2,'2024-01-12 11:00','BP Issue','Done'),
(13,13,3,'2024-01-13 12:00','Headache','Done'),
(14,14,4,'2024-01-14 09:00','Sprain','Done'),
(15,15,5,'2024-01-15 08:30','Child Cold','Done'),
(16,16,6,'2024-01-16 10:30','Emergency','Pending'),
(17,17,7,'2024-01-17 11:30','Heart Test','Pending'),
(18,18,8,'2024-01-18 12:30','CT Scan','Pending'),
(19,19,9,'2024-01-19 13:30','Joint Pain','Pending'),
(20,20,10,'2024-01-20 14:30','Injection','Pending');


INSERT INTO Medication VALUES
(1,'Panadol',500),(2,'Brufen',300),(3,'Disprin',200),(4,'Augmentin',150),(5,'Calpol',400),
(6,'Insulin',100),(7,'Ventolin',250),(8,'Aspirin',350),(9,'Cough Syrup',180),(10,'Antibiotic',220);


INSERT INTO Invoice(InvoiceID,PatientID,TotalAmount,PaidAmount) VALUES
(1,1,5000,5000),(2,2,7000,4000),(3,3,3000,3000),(4,4,9000,6000),(5,5,2000,2000),
(6,6,8000,2000),(7,7,4500,4500),(8,8,6500,3000),(9,9,10000,5000),(10,10,2500,2500);


--update
SELECT * FROM Patient
SELECT * FROM Doctor
SELECT * FROM Nurse
SELECT * FROM Appointment
SELECT *FROM Medication
SELECT * FROM Invoice
SELECT * FROM Ward
UPDATE Patient
SET Address = 'Karachi, Gulshan-e-Iqbal'
WHERE PatientID = 1;
UPDATE Patient
SET FirstName = 'Alee', LastName = 'Kha'
WHERE PatientID = 2;


UPDATE Doctor
SET Specialty = 'General Medicine'
WHERE DoctorID = 3;


UPDATE Nurse
SET HireDate = '2010-01-01'
WHERE NurseID = 5;

UPDATE Appointment
SET ApptDateTime = '2024-02-01 10:00'
WHERE AppointmentID = 6;

UPDATE Appointment
SET Status = 'Done'
WHERE AppointmentID = 7;

UPDATE Medication
SET Stock = Stock + 50
WHERE MedicineID = 4; 

UPDATE Invoice
SET PaidAmount = 7000
WHERE InvoiceID = 2;

UPDATE Invoice
SET TotalAmount = 7500
WHERE InvoiceID = 6;

UPDATE Ward
SET BedCount = 35
WHERE WardID = 3;


--INDEX

CREATE INDEX IDX_Patient_Name ON Patient(LastName, FirstName);
CREATE INDEX IDX_Doctor_Specialty ON Doctor(Specialty);
CREATE INDEX IDX_Appointment_Date ON Appointment(ApptDateTime);
CREATE INDEX IDX_Invoice_Patient ON Invoice(PatientID);

--VIEW


SELECT * FROM vw_PatientDetails;
SELECT * FROM vw_DoctorSchedule;
SELECT * FROM vw_LowStockMedications;
SELECT * FROM vw_OutstandingInvoices;
SELECT * FROM vw_WardFacilities ;


CREATE VIEW vw_PatientDetails AS
SELECT 
    p.PatientID,
    p.FirstName,
    p.LastName,
    p.FullName,
    p.DOB,
    p.Age,
    p.Gender,
    p.Address,
    ph.Phone,
    em.Email
FROM Patient p
LEFT JOIN PatientPhones ph ON p.PatientID = ph.PatientID
LEFT JOIN PatientEmails em ON p.PatientID = em.PatientID;

CREATE VIEW vw_DoctorSchedule AS
SELECT 
    d.DoctorID,
    d.FullName AS DoctorName,
    d.Specialty,
    a.AppointmentID,
    a.ApptDateTime,
    a.Status,
    p.FullName AS PatientName
FROM Doctor d
INNER JOIN Appointment a ON d.DoctorID = a.DoctorID
INNER JOIN Patient p ON a.PatientID = p.PatientID;

CREATE VIEW vw_OutstandingInvoices AS
SELECT 
    i.InvoiceID,
    p.FullName AS PatientName,
    i.TotalAmount,
    i.PaidAmount,
    i.BalanceDue,
    i.IsPaidFully
FROM Invoice i
INNER JOIN Patient p ON i.PatientID = p.PatientID
WHERE i.BalanceDue > 0;

CREATE VIEW vw_LowStockMedications AS
SELECT 
    MedicineID,
    Name,
    Stock,
    IsLowStock
FROM Medication
WHERE Stock < 50;

CREATE VIEW vw_WardFacilities AS
SELECT 
    w.WardID,
    w.WardName,
    w.Floor,
    w.BedCount,
    f.Facility
FROM Ward w
LEFT JOIN WardFacilities f ON w.WardID = f.WardID;
