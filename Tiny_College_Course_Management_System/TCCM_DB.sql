/*
CISS 311 - ADVANCED AGILE SOFTWARE DEVELOPMENT
Instructor: Michael Miracle
 
Team 2: The Agile Minds
Members: Audrey Gamble, Jahmai Hawkins, Sandrin Tebo, Tiny Walters, Jacob Decker, Joe Fague
Course Project 2: Tiny College Course Mgmt database
 
11/25/2025
*/

USE master;

IF DB_ID(N'TinyCollegeCourseMgmtDB') IS NOT NULL DROP DATABASE TinyCollegeCourseMgmtDB;
-- Create the database
CREATE DATABASE TinyCollegeCourseMgmtDB;
GO

-- Use the database
USE TinyCollegeCourseMgmtDB;
GO

-- Create Instructors table: Administrators can add instructors here. Each instructor has a unique ID, name, and email.
CREATE TABLE Instructors 
(
    InstructorID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL
);
GO

-- Create Students table:  Administrators can add students here. Each student has a unique ID, name, and email.
CREATE TABLE Students 
(
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL
);
GO

-- Create Courses table:  Administrators can add courses, assign an instructor, set max seats, available seats (initially equal to max seats), credit hours, and whether it's active for registration. Available seats are decremented upon registration.
--For checking to see if a student is eligible for graduation, we will need to query the registrations with something like WHERE grade IN ('A','B','C') and sum credit hours >120 to accumulate them correctly.
CREATE TABLE Courses 
(
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    InstructorID INT NOT NULL,
    MaxSeats INT NOT NULL CHECK (MaxSeats > 0),
    AvailableSeats INT NOT NULL CHECK (AvailableSeats >= 0),-- Seats must be positive
    IsActive BIT NOT NULL DEFAULT 0,  -- 1 for open for registration, 0 for closed
    CreditHours INT NOT NULL CHECK (CreditHours > 0),-- Credit hours must be positive
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);
GO

-- Create Registrations table:  Students can register for multiple courses and instructors can assign grades. (many-to-many between Students and Courses, with Grade)
CREATE TABLE Registrations 
(
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    Grade CHAR(1) NULL CHECK (Grade IN ('A', 'B', 'C', 'D', 'F')),--Grades are A-F
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
GO


-- Insert our Team 2 as students
INSERT INTO Students (FirstName, LastName, Email)
VALUES 
    ('Audrey', 'Gamble', 'amgamble2@cougars.ccis.edu'),
	('Jahmai','Hawkins','jahawkins2@cougars.ccis.edu'),
    ('Sandrin', 'Tebo', 'stebo2@cougars.ccis.edu'),
    ('Tiny', 'Walters', 'tnwalters1@cougars.ccis.edu'),
    ('Jacob', 'Decker', 'jdecker2@cougars.ccis.edu'),
    ('Joe', 'Fague', 'ljfague1@cougars.ccis.edu');
GO


-- Insert some fictional instructors
INSERT INTO Instructors (FirstName, LastName, Email)
VALUES 
    ('Alice', 'Johnson', 'alice.johnson@tinycollege.edu'),
    ('Bob', 'Smith', 'bob.smith@tinycollege.edu'),
    ('Carol', 'Williams', 'carol.williams@tinycollege.edu'),
    ('David', 'Brown', 'david.brown@tinycollege.edu'),
    ('Eve', 'Davis', 'eve.davis@tinycollege.edu');
GO


-- Insert sample courses with 5 max seats to check availability
-- The instructorId's are auto-generated, so 1-5 below are for 1-Alice, 2-Bob, 3-Carol, 4-David, 5-Eve
INSERT INTO Courses (Title, InstructorID, MaxSeats, AvailableSeats, IsActive, CreditHours)
VALUES 
    ('Introduction to Computer Science', 1, 5, 5, 1, 3),
    ('Data Structures', 1, 5, 5, 1, 4),
    ('Calculus I', 2, 4, 4, 1, 4),
    ('Physics Fundamentals', 3, 2, 2, 1, 3),
    ('English Literature', 4, 5, 5, 1, 3),
    ('Statistics', 2, 3, 3, 1, 3),
    ('History of Art', 5, 5, 5, 1, 2),
    ('Biology Basics', 3, 5, 5, 1, 3),
	('Advanced Algorithms', 1, 5, 5, 0, 4);  -- Not active for registration
GO


-- Insert sample registrations

-- The studentId's are auto-generated, so 1-6 below are for 1-Audrey, 2-Jahmai, 3-Sandrin, 4-Tiny, 5-Jacob, 6-Joe 

INSERT INTO Registrations (StudentID, CourseID, Grade)
VALUES 
    (1, 1, 'A'),  -- Audrey in Intro CS
    (1, 3, 'B'),  -- Audrey in Calculus
    (1, 8, NULL), -- Audrey in History of Art, no grade yet
	
	(2, 1, 'A'),  -- Jahmai in Intro CS
    (2, 3, 'B'),  -- Jahmai in Calculus
    (2, 8, NULL), -- Jahmai in History of Art, no grade yet
	
    (3, 1, NULL), -- Sandrin in Intro CS, no grade yet
    (3, 4, 'C'),  -- Sandrin in Physics
    (3, 7, 'A'),  -- Sandrin in Statistics
	
    (4, 2, 'A'),  -- Tiny in Data Structures
    (4, 5, NULL), -- Tiny in English Lit, no grade yet
    (4, 9, 'B'),  -- Tiny in Biology Basics
	
    (5, 3, 'B'),  -- Jacob in Calculus
    (5, 7, 'C'),  -- Jacob in Statistics
    (5, 8, 'A'),  -- Jacob in History of Art
	
    (6, 4, NULL), -- Joe in Physics, no grade yet
    (6, 5, 'D'),  -- Joe in English Lit
    (6, 9, NULL); -- Joe in Biology Basics, no grade yet
GO