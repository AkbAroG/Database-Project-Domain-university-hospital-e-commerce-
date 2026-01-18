CREATE DATABASE UniDB;
USE UniDB;

CREATE TABLE Student (
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DOB DATE,
    Gender VARCHAR(10),
    Address VARCHAR(200)
);

CREATE TABLE StudentEmails (
    StudentID INT FOREIGN KEY REFERENCES Student(StudentID),
    Email VARCHAR(100)
);

CREATE TABLE StudentPhones (
    StudentID INT FOREIGN KEY REFERENCES Student(StudentID),
    Phone VARCHAR(20)
);

-- 
--  DEPARTMENT
-- 
CREATE TABLE Department (
    DeptID INT IDENTITY(1,1) PRIMARY KEY,
    DeptName VARCHAR(100),
    OfficeLocation VARCHAR(100)
);

CREATE TABLE DeptPhones(
    DeptID INT FOREIGN KEY REFERENCES Department(DeptID),
    Phone VARCHAR(20)
);

CREATE TABLE DeptEmails(
    DeptID INT FOREIGN KEY REFERENCES Department(DeptID),
    Email VARCHAR(100)
);

-- 
--  INSTRUCTOR
-- 
CREATE TABLE Instructor (
    InstructorID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    HireDate DATE,
    DeptID INT FOREIGN KEY REFERENCES Department(DeptID)
);

CREATE TABLE InstructorEmails(
    InstructorID INT FOREIGN KEY REFERENCES Instructor(InstructorID),
    Email VARCHAR(100)
);

CREATE TABLE InstructorPhones(
    InstructorID INT FOREIGN KEY REFERENCES Instructor(InstructorID),
    Phone VARCHAR(20)
);

-- 
--  HOSTEL
-- 
CREATE TABLE Hostel (
    HostelID INT IDENTITY(1,1) PRIMARY KEY,
    HostelName VARCHAR(100),
    Capacity INT
);

-- 
--  ROOM
-- 
CREATE TABLE Room (
    RoomID INT IDENTITY(1,1) PRIMARY KEY,
    HostelID INT FOREIGN KEY REFERENCES Hostel(HostelID),
    RoomNumber VARCHAR(20),
    TotalBeds INT
);

-- 
--  LIBRARY
-- 
CREATE TABLE Library (
    LibraryID INT IDENTITY(1,1) PRIMARY KEY,
    LibraryName VARCHAR(100),
    Location VARCHAR(100)
);

-- LIBRARY TRANSACTION

CREATE TABLE LibraryTransaction (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT FOREIGN KEY REFERENCES Student(StudentID),
    BookID INT,
    IssueDate DATE,
    ReturnDate DATE
);

-- 
--  COURSE
-- 
CREATE TABLE Course (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    CourseCode VARCHAR(20),
    Title VARCHAR(100),
    Credits INT
);

 
--  SCHOLARSHIP
 
CREATE TABLE Scholarship (
    ScholarshipID INT IDENTITY(1,1) PRIMARY KEY,
    ScholarshipName VARCHAR(100),
    Amount INT
);


--  EVENT

CREATE TABLE Event (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    EventName VARCHAR(100),
    Location VARCHAR(100),
    EventDate DATE
);


--  CLUB

CREATE TABLE Club (
    ClubID INT IDENTITY(1,1) PRIMARY KEY,
    ClubName VARCHAR(100),
    President VARCHAR(100)
);


-- TRANSPORT
CREATE TABLE Transport (
    TransportID INT IDENTITY(1,1) PRIMARY KEY,
    VehicleNumber VARCHAR(20),
    Capacity INT
);


-- SECTION
CREATE TABLE Section (
    SectionID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT FOREIGN KEY REFERENCES Course(CourseID),
    Semester VARCHAR(20),
    Year INT,
    InstructorID INT FOREIGN KEY REFERENCES Instructor(InstructorID)
);

 
--  ALUMNI
CREATE TABLE Alumni (
    AlumniID INT IDENTITY(1,1) PRIMARY KEY,
    StudentName VARCHAR(100),
    GraduationYear INT
);

-- 
--  BOOK
-- 
CREATE TABLE Book (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    PublishedYear INT
);


INSERT INTO Student (FirstName, LastName, DOB, Gender, Address) VALUES
('Ali', 'Khan', '2002-05-12', 'Male', 'Lahore'),
('Sara', 'Ahmed', '2001-11-23', 'Female', 'Karachi'),
('Bilal', 'Hussain', '2003-01-03', 'Male', 'Islamabad'),
('Ayesha', 'Malik', '2000-08-17', 'Female', 'Multan'),
('Hamza', 'Raza', '2002-02-21', 'Male', 'Peshawar'),
('Fatima', 'Shah', '2001-03-10', 'Female', 'Quetta'),
('Usman', 'Farooq', '2003-07-29', 'Male', 'Rawalpindi'),
('Hina', 'Yousaf', '2000-09-14', 'Female', 'Faisalabad'),
('Zain', 'Ali', '2001-06-18', 'Male', 'Sargodha'),
('Mina', 'Siddiqui', '2002-04-05', 'Female', 'Hyderabad');
INSERT INTO StudentEmails VALUES
(1, 'ali@example.com'),
(2, 'sara@example.com'),
(3, 'bilal@example.com'),
(4, 'ayesha@example.com'),
(5, 'hamza@example.com'),
(6, 'fatima@example.com'),
(7, 'usman@example.com'),
(8, 'hina@example.com'),
(9, 'zain@example.com'),
(10, 'mina@example.com');
INSERT INTO StudentPhones VALUES
(1, '03001111111'),
(2, '03002222222'),
(3, '03003333333'),
(4, '03004444444'),
(5, '03005555555'),
(6, '03006666666'),
(7, '03007777777'),
(8, '03008888888'),
(9, '03009999999'),
(10, '03100000000');

INSERT INTO StudentPhones VALUES
(1, '03001111111'),
(2, '03002222222'),
(3, '03003333333'),
(4, '03004444444'),
(5, '03005555555'),
(6, '03006666666'),
(7, '03007777777'),
(8, '03008888888'),
(9, '03009999999'),
(10, '03100000000');

INSERT INTO Department (DeptName, OfficeLocation) VALUES
('Computer Science', 'Block A - 1st Floor'),
('Electrical Engineering', 'Block B - Ground Floor'),
('Business Administration', 'Block C - 2nd Floor'),
('Mechanical Engineering', 'Block D - 1st Floor'),
('Civil Engineering', 'Block E - Ground Floor');

INSERT INTO DeptPhones VALUES
(1, '04211110001'),
(2, '04211110002'),
(3, '04211110003'),
(4, '04211110004'),
(5, '04211110005');

INSERT INTO DeptEmails VALUES
(1, 'cs@university.com'),
(2, 'ee@university.com'),
(3, 'bba@university.com'),
(4, 'me@university.com'),
(5, 'ce@university.com');



 
 
INSERT INTO Instructor (FirstName, LastName, HireDate, DeptID) VALUES
('Ali','Khan','2015-08-01',1),
('Sara','Ahmed','2018-02-15',2),
('Omar','Hussain','2017-06-12',3),
('Zara','Qureshi','2019-09-23',4),
('Ahmed','Raza','2016-11-05',5),
('Hina','Shah','2020-01-10',1),
('Usman','Ali','2018-04-19',2),
('Nida','Khalid','2017-12-01',3),
('Bilal','Aslam','2019-03-14',4),
('Ayesha','Farooq','2016-07-20',5);

INSERT INTO InstructorEmails (InstructorID, Email) VALUES
(1,'ali.khan@serif.edu'),(2,'sara.ahmed@serif.edu'),(3,'omar.hussain@serif.edu'),
(4,'zara.qureshi@serif.edu'),(5,'ahmed.raza@serif.edu'),(6,'hina.shah@serif.edu'),
(7,'usman.ali@serif.edu'),(8,'nida.khalid@serif.edu'),(9,'bilal.aslam@serif.edu'),
(10,'ayesha.farooq@serif.edu');

INSERT INTO InstructorPhones (InstructorID, Phone) VALUES
(1,'03001234501'),(2,'03001234502'),(3,'03001234503'),(4,'03001234504'),
(5,'03001234505'),(6,'03001234506'),(7,'03001234507'),(8,'03001234508'),
(9,'03001234509'),(10,'03001234510');


INSERT INTO Hostel (HostelName, Capacity) VALUES
('Ibn-e-Sina',120),
('Al-Farabi',100),
('Rumi',80),
('Ghazzali',60),
('Avicenna',50);


INSERT INTO Room (HostelID, RoomNumber, TotalBeds) VALUES
(1,'101',4),(1,'102',4),(2,'201',3),(2,'202',3),(3,'301',2),
(3,'302',2),(4,'401',2),(4,'402',2),(5,'501',1),(5,'502',1);


INSERT INTO Library (LibraryName, Location) VALUES
('Main Library','Block A'),
('Science Library','Block B'),
('Engineering Library','Block C');


INSERT INTO LibraryTransaction (StudentID, BookID, IssueDate, ReturnDate) VALUES
(1,1,'2025-01-10','2025-01-20'),
(2,2,'2025-01-11','2025-01-21'),
(3,3,'2025-01-12','2025-01-22'),
(4,4,'2025-01-13','2025-01-23'),
(5,5,'2025-01-14','2025-01-24');


INSERT INTO Course (CourseCode, Title, Credits) VALUES
('CS101','Introduction to CS',3),
('CS102','Data Structures',4),
('CS103','Algorithms',4),
('EE101','Circuits',3),
('EE102','Electronics',4),
('ME101','Thermodynamics',3),
('ME102','Fluid Mechanics',4),
('BA101','Economics',3),
('BA102','Accounting',3),
('BA103','Marketing',3);


INSERT INTO Scholarship (ScholarshipName, Amount) VALUES
('Merit Scholarship',5000),
('Need Based',3000),
('Sports Excellence',4000),
('Arts Excellence',3500),
('Research Grant',4500);


INSERT INTO Event (EventName, Location, EventDate) VALUES
('Science Fair','Auditorium','2025-03-10'),
('Cultural Night','Main Hall','2025-04-15'),
('Sports Day','Playground','2025-05-20'),
('Tech Expo','Lab Block','2025-06-12'),
('Alumni Meet','Conference Room','2025-07-18');


INSERT INTO Club (ClubName, President) VALUES
('Drama Club','Sara Ahmed'),
('Music Club','Ali Khan'),
('Debate Club','Zara Qureshi'),
('Photography Club','Hina Shah'),
('Robotics Club','Omar Hussain');


INSERT INTO Transport (VehicleNumber, Capacity) VALUES
('ABC-123',40),
('DEF-456',30),
('GHI-789',50),
('JKL-012',20),
('MNO-345',35);


INSERT INTO Section (CourseID, Semester, Year, InstructorID) VALUES
(1,'Fall',2025,1),(2,'Fall',2025,2),(3,'Fall',2025,3),(4,'Fall',2025,4),
(5,'Spring',2025,5),(6,'Spring',2025,6),(7,'Spring',2025,7),(8,'Spring',2025,8),
(9,'Fall',2025,9),(10,'Fall',2025,10);


INSERT INTO Alumni (StudentName, GraduationYear) VALUES
('Ali Khan',2020),
('Sara Ahmed',2019),
('Omar Hussain',2018),
('Zara Qureshi',2021),
('Ahmed Raza',2020);


INSERT INTO Book (Title, Author, PublishedYear) VALUES
('Programming Basics','John Doe',2015),
('Data Structures','Jane Smith',2017),
('Algorithms','Alan Turing',2016),
('Circuits Theory','Nikola Tesla',2014),
('Thermodynamics','James Watt',2013),
('Economics 101','Adam Smith',2012),
('Marketing Strategies','Philip Kotler',2018);

SELECT * FROM Student WHERE StudentID = 1;
Select * From Student;
SELECT * FROM Course WHERE CourseID =3;
SELECT * FROM Course;
SELECT* FROM Instructor WHERE InstructorID =10;
SELECT * FROM Instructor
SELECT* FROM LibraryTransaction WHERE BookID= 2;
SELECT * FROM LibraryTransaction
SELECT* FROM Section WHERE InstructorID= 5;
SELECT * FROM Section
SELECT* FROM Alumni WHERE AlumniID= 1;
SELECT * FROM Alumni
SELECT* FROM Student WHERE StudentID= 10;
SELECT * FROM Student
SELECT* FROM Library WHERE LibraryID= 1;
SELECT * FROM Student
SELECT* FROM Book WHERE BookID= 10;
SELECT * FROM Book
SELECT* FROM Club WHERE ClubID= 1;
SELECT * FROM Club 

--UPDATE QUERIES
UPDATE Student
SET Address = 'Skardu'
WHERE StudentID = 1;


UPDATE Course 
SET Credits = '10'
WHERE CourseID = 3


UPDATE Instructor
SET DeptID =1
WHERE InstructorID =10;


UPDATE LibraryTransaction
SET ReturnDate ='2025-05-01'
WHERE BookID =10;


UPDATE Section
SET InstructorID =5
WHERE SectionID =10;


UPDATE Alumni
SET GraduationYear =5
WHERE AlumniID =1;


UPDATE Student
SET Gender ='Male'
WHERE StudentID =10;


UPDATE Library
SET Location ='Skardu'
WHERE LibraryID =1;


UPDATE Book
SET Title ='DBMS'
WHERE BookID =10;

UPDATE CLUB
SET President='AKBARO'
WHERE  ClubID=1;


--index


CREATE INDEX idx_studentName ON Student (FirstName)
CREATE INDEX idx_Book ON Book (Title)
CREATE INDEX idx_Alumni ON Alumni (StudentName)

--view

SELECT * FROM v_Student
SELECT * FROM V_HostelRoomSummary;
SELECT * FROM V_Fall2025CourseSchedule;
SELECT * FROM V_LibraryOverdueBooks;
SELECT * FROM  V_InstructorTeachingLoad;


CREATE VIEW v_Student AS
SELECT
    S.StudentID,
    S.FirstName + ' ' + S.LastName AS StudentName,
    S.Address,
    STUFF(
        (SELECT ', ' + Email FROM StudentEmails SE WHERE SE.StudentID = S.StudentID FOR XML PATH('')), 1, 2, ''
    ) AS AllEmails,
    STUFF(
        (SELECT ', ' + Phone FROM StudentPhones SP WHERE SP.StudentID = S.StudentID FOR XML PATH('')), 1, 2, ''
    ) AS AllPhones
FROM
    Student S;

CREATE VIEW V_HostelRoomSummary AS
SELECT
    H.HostelName,
    COUNT(R.RoomID) AS TotalRooms,
    SUM(R.TotalBeds) AS TotalCapacity
FROM
    Hostel H
JOIN
    Room R ON H.HostelID = R.HostelID
GROUP BY
    H.HostelName;

CREATE VIEW V_Fall2025CourseSchedule AS
SELECT
    C.CourseCode,
    C.Title AS CourseTitle,
    S.Semester,
    S.[Year],
    I.FirstName + ' ' + I.LastName AS InstructorName,
    D.DeptName AS Department
FROM
    Section S
JOIN
    Course C ON S.CourseID = C.CourseID
JOIN
    Instructor I ON S.InstructorID = I.InstructorID
JOIN
    Department D ON I.DeptID = D.DeptID
WHERE
    S.Semester = 'Fall' AND S.[Year] = 2025;

CREATE VIEW V_LibraryOverdueBooks AS
SELECT
    LT.TransactionID,
    S.StudentID,
    S.FirstName + ' ' + S.LastName AS StudentName,
    B.Title AS BookTitle,
    LT.IssueDate,
    LT.ReturnDate AS DueDate 
FROM
    LibraryTransaction LT
JOIN
    Student S ON LT.StudentID = S.StudentID
JOIN
    Book B ON LT.BookID = B.BookID 
WHERE
    LT.ReturnDate < GETDATE()
    AND LT.ReturnDate IS NOT NULL 


CREATE VIEW V_InstructorTeachingLoad AS
SELECT
    I.InstructorID,
    I.FirstName + ' ' + I.LastName AS InstructorName,
    D.DeptName AS Department,
    COUNT(S.SectionID) AS NumberOfSections
FROM
    Instructor I
JOIN
    Department D ON I.DeptID = D.DeptID
LEFT JOIN
    Section S ON I.InstructorID = S.InstructorID
GROUP BY
    I.InstructorID, I.FirstName, I.LastName, D.DeptName;