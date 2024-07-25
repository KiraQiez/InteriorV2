-- Create the USERS table
CREATE TABLE USERS (
    userID VARCHAR(8) PRIMARY KEY NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    userType VARCHAR(50) NOT NULL,
    userImage BLOB
);


CREATE TABLE PAYMENT (
    paymentID VARCHAR(8) PRIMARY KEY NOT NULL,
    paymentStatus VARCHAR(255) NOT NULL,
    paymentdate DATE,
    paymentProof BLOB
);


-- Create the STUDENT table
CREATE TABLE STUDENT (
    stdID VARCHAR(8) PRIMARY KEY NOT NULL,
    stdName VARCHAR(255) NOT NULL,
    stdIC VARCHAR(12) NOT NULL,
    stdPhone VARCHAR(20) ,
    stdAddress VARCHAR(255) ,
    stdIncome DECIMAL(10, 2) ,
    stdParentPhoneNum VARCHAR(30),
    StdStatus VARCHAR(50) NOT NULL
    FOREIGN KEY (stdID) REFERENCES USERS(userID)
);



CREATE TABLE BILL (
    billID VARCHAR(8) PRIMARY KEY NOT NULL,
    billType VARCHAR(255) NOT NULL ,
    totalAmount INT NOT NULL ,
    stdID VARCHAR(8) NOT NULL,
    paymentID VARCHAR(8), 
    FOREIGN KEY (stdID) REFERENCES STUDENT(stdID),
    FOREIGN KEY (paymentID) REFERENCES PAYMENT(paymentID)
);



CREATE TABLE STAFF (
    staffID VARCHAR(8) PRIMARY KEY NOT NULL,
    staffName VARCHAR(255) NOT NULL,
    staffType VARCHAR(30) NOT NULL,

    FOREIGN KEY (staffID) REFERENCES USERS(userID)
);


CREATE TABLE BLOCK (
    blockID VARCHAR(2) PRIMARY KEY NOT NULL,
    blockName VARCHAR(255) NOT NULL,
    blockDesc VARCHAR(255)
);


CREATE TABLE ROOM (
    roomID VARCHAR(8) PRIMARY KEY NOT NULL,
    blockID VARCHAR(2),
    roomType VARCHAR(8),
    maxCapacity INT,
    availability INT,
    FOREIGN KEY (blockID) REFERENCES BLOCK(blockID)
);


CREATE TABLE SESSION (
    sessionID INT PRIMARY KEY,
    sessionName VARCHAR(30),
    sessionStatus VARCHAR(10)
);


CREATE TABLE REPORT (
    reportID VARCHAR(8) PRIMARY KEY NOT NULL,
    reportTitle VARCHAR(255) NOT NULL,
    reportDesc VARCHAR(255) NOT NULL,
    reportStatus VARCHAR(50) NOT NULL,
    studentID VARCHAR(8) NOT NULL,
    handledByStaffID VARCHAR(8),
    checkedByStaffID VARCHAR(8),
    FOREIGN KEY (studentID) REFERENCES STUDENT(stdID),
    FOREIGN KEY (handledByStaffID) REFERENCES STAFF(staffID),
    FOREIGN KEY (checkedByStaffID) REFERENCES STAFF(staffID)
);


-- Create the BOOKING table
CREATE TABLE BOOKING (
    bookingID VARCHAR(8) PRIMARY KEY NOT NULL,
    bookingDate DATE NOT NULL,
    bookstatus VARCHAR(10) NOT NULL,
    stdID VARCHAR(8) NOT NULL,
    staffID VARCHAR(8),
    roomID VARCHAR(8) NOT NULL,
    sessionID INT,
    BOOKINGCHECKOUT DATE,
    FOREIGN KEY (stdID) REFERENCES STUDENT(stdID),
    FOREIGN KEY (staffID) REFERENCES STAFF(staffID),
    FOREIGN KEY (roomID) REFERENCES ROOM(roomID),
    FOREIGN KEY (sessionID) REFERENCES SESSION(sessionID)
);
