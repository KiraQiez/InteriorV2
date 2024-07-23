-- Create the USERS table
CREATE TABLE USERS (
    userID VARCHAR(8) PRIMARY KEY NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    userType VARCHAR(50) NOT NULL,
    userImage BLOB
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



CREATE TABLE PAYMENT (
    paymentID VARCHAR(8) PRIMARY KEY NOT NULL,
    paymentStatus VARCHAR(255) NOT NULL
);



-- Create the STAFF table
CREATE TABLE STAFF (
    staffID VARCHAR(8) PRIMARY KEY NOT NULL,
    staffName VARCHAR(255) NOT NULL,
    staffType VARCHAR(30) NOT NULL,

    FOREIGN KEY (staffID) REFERENCES USERS(userID)
);
-- Create the BLOCK table
CREATE TABLE BLOCK (
    blockID VARCHAR(2) PRIMARY KEY NOT NULL,
    blockName VARCHAR(255) NOT NULL,
    blockDesc VARCHAR(255)
);
-- Create the ROOM table
CREATE TABLE ROOM (
    roomID VARCHAR(8) PRIMARY KEY NOT NULL,
    blockID VARCHAR(2),
    roomType VARCHAR(8),
    maxCapacity INT,
    availability VARCHAR(20),
    FOREIGN KEY (blockID) REFERENCES BLOCK(blockID)
);

--NEW TABLE SESSION
-- Step 1: Create the SESSION table
CREATE TABLE SESSION (
    sessionID INT PRIMARY KEY,
    sessionName VARCHAR(30),
    sessionStatus VARCHAR(10)
);


-- Create the REPORT table
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
    staffID VARCHAR(8) NOT NULL,
    roomID VARCHAR(8) NOT NULL,
    sessionID INT,

    FOREIGN KEY (stdID) REFERENCES STUDENT(stdID),
    FOREIGN KEY (staffID) REFERENCES STAFF(staffID),
    FOREIGN KEY (roomID) REFERENCES ROOM(roomID),
    FOREIGN KEY (sessionID) REFERENCES SESSION(sessionID)
);


-- Insert data into the Payment table
INSERT INTO PAYMENT (paymentID, paymentStatus) VALUES ('P0000001', 'Completed');
INSERT INTO PAYMENT (paymentID, paymentStatus) VALUES ('P0000002', 'Completed');
INSERT INTO PAYMENT (paymentID, paymentStatus) VALUES ('P0000003', 'Completed');
INSERT INTO PAYMENT (paymentID, paymentStatus) VALUES ('P0000004', 'Completed');
INSERT INTO PAYMENT (paymentID, paymentStatus) VALUES ('P0000005', 'Completed');


-- Insert data into the BILL table
INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000001', 'Hostel', 2000, 'U0000001', 'P0000001');
INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000002', 'Tuition', 1500, 'U0000002', 'P0000002');
INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000003', 'Miscellaneous', 500, 'U0000003', 'P0000003');
INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000004', 'Hostel', 2000, 'U0000004', 'P0000004');
INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000005', 'Tuition', 1500, 'U0000005', 'P0000005');

INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000006', 'Miscellaneous', 500, 'U0000006', NULL);
INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000007', 'Hostel', 2000, 'U0000007', NULL);
INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000008', 'Tuition', 1500, 'U0000008', NULL);
INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000009', 'Miscellaneous', 500, 'U0000009', NULL);
INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000010', 'Hostel', 2000, 'U0000010', NULL);

INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000011', 'Tuition', 1500, 'U0000001', NULL);
INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000012', 'Miscellaneous', 500, 'U0000002', NULL);
INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000013', 'Hostel', 2000, 'U0000003', NULL);
INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000014', 'Tuition', 1500, 'U0000004', NULL);
INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000015', 'Miscellaneous', 500, 'U0000005', NULL);

INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000016', 'Hostel', 2000, 'U0000006', NULL);
INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000017', 'Tuition', 1500, 'U0000007', NULL);
INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000018', 'Miscellaneous', 500, 'U0000008', NULL);
INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000019', 'Hostel', 2000, 'U0000009', NULL);
INSERT INTO BILL (billID, billType, totalAmount, stdID, paymentID) VALUES ('B0000020', 'Tuition', 1500, 'U0000010', NULL);
