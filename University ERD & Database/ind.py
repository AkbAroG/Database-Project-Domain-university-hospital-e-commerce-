import random
from datetime import datetime, timedelta
f = open("university_data.sql", "w")
# ============================
# 1. Departments Data
# ============================
f.write("INSERT INTO Department (DeptName, OfficeLocation) VALUES\n")
f.write("('Computer Science', 'Block A'),\n")
f.write("('Business Administration', 'Block B'),\n")
f.write("('Electrical Engineering', 'Block C');\n\n")
# ============================
# 2. Students Data (2000 Students)
# ============================
f.write("-- Students\n")
for i in range(1, 2001):
    first_name = f"Student{i}"
    last_name = f"Lname{i}"
    dob = f"2000-{random.randint(1,12):02d}-{random.randint(1,28):02d}"
    gender = random.choice(['Male','Female'])
    address = f"Address_{i}"
    f.write(f"INSERT INTO Student (FirstName, LastName, DOB, Gender, Address) VALUES ('{first_name}','{last_name}','{dob}','{gender}','{address}');\n")
    f.write(f"INSERT INTO StudentEmails (StudentID, Email) VALUES ({i}, '{first_name.lower()}.{last_name.lower()}@uni.edu');\n")
    f.write(f"INSERT INTO StudentPhones (StudentID, Phone) VALUES ({i}, '03{random.randint(10000000,99999999)}');\n")
# ============================
# 3. Courses Data (10 Courses)
# ============================
f.write("\n-- Courses\n")
for i in range(1, 11):
    code = f"CS{i+100}"
    title = f"Course_{i}"
    credits = random.randint(2,4)
    f.write(f"INSERT INTO Course (CourseCode, Title, Credits) VALUES ('{code}','{title}',{credits});\n")
# ============================
# 4. Instructors (10 Teachers)
# ============================
f.write("\n-- Instructors\n")
for i in range(1, 11):
    first_name = f"Instructor{i}"
    last_name = f"Lname{i}"
    hire_date = f"2015-{random.randint(1,12):02d}-{random.randint(1,28):02d}"
    dept_id = random.randint(1,3)
    f.write(f"INSERT INTO Instructor (FirstName, LastName, HireDate, DeptID) VALUES ('{first_name}','{last_name}','{hire_date}',{dept_id});\n")
    f.write(f"INSERT INTO InstructorEmails (InstructorID, Email) VALUES ({i}, '{first_name.lower()}.{last_name.lower()}@uni.edu');\n")
    f.write(f"INSERT INTO InstructorPhones (InstructorID, Phone) VALUES ({i}, '03{random.randint(10000000,99999999)}');\n")
# ============================
# 5. Sections (10 Sections)
# ============================
f.write("\n-- Sections\n")
for i in range(1, 11):
    course_id = i
    semester = random.choice(['Fall','Spring'])
    year = 2025
    instructor_id = i
    f.write(f"INSERT INTO Section (CourseID, Semester, Year, InstructorID) VALUES ({course_id},'{semester}',{year},{instructor_id});\n")
# ============================
# 6. Books (7 Books)
# ============================
f.write("\n-- Books\n")
for i in range(1, 8):
    title = f"Book_Title_{i}"
    author = f"Author_{i}"
    published_year = random.randint(2010,2025)
    f.write(f"INSERT INTO Book (Title, Author, PublishedYear) VALUES ('{title}','{author}',{published_year});\n")
# ================================================
# TRANSACTIONAL DATA (TARGET: 20,000 RECORDS)
# ================================================
# A. ENROLLMENT (Target: 12,000 Records)
f.write("\n-- Enrollments\n")
enrollment_id = 1
for student_id in range(1, 2001):
    for _ in range(6):  
        section_id = random.randint(1, 10)
        f.write(f"INSERT INTO SectionEnrollment (StudentID, SectionID) VALUES ({student_id}, {section_id});\n")
        enrollment_id += 1
# B. LIBRARY TRANSACTIONS (Target: 8,000 Records)
f.write("\n-- Library Transactions\n")
for trans_id in range(1, 8001):
    student_id = random.randint(1, 2000)
    book_id = random.randint(1, 7)
    issue_date = datetime(2024,1,1) + timedelta(days=random.randint(0,730))
    return_date = issue_date + timedelta(days=random.randint(7,30))
    f.write(f"INSERT INTO LibraryTransaction (StudentID, BookID, IssueDate, ReturnDate) VALUES ({student_id}, {book_id}, '{issue_date.date()}', '{return_date.date()}');\n")
f.close()
print("SQL file generated successfully!")