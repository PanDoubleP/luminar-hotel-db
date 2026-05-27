DROP DATABASE IF EXISTS LuminarBoutique;
CREATE DATABASE LuminarBoutique;
USE LuminarBoutique;

CREATE TABLE Guest (
	GuestID varchar(20) PRIMARY KEY,
    FirstName varchar(50) NOT NULL,
    LastName varchar(50) NOT NULL,
    IdentificationNumber varchar(50) UNIQUE NOT NULL,
    Nationality varchar(20)
);

CREATE TABLE Staff (
	StaffID varchar(20) PRIMARY KEY,
    FirstName varchar(50) NOT NULL,
    LastName varchar(50) NOT NULL,
    Gender char(1),
    Role varchar(20) NOT NULL
);

CREATE TABLE GuestPhoneNumber (
    GuestID     varchar(20) NOT NULL,
    PhoneNumber varchar(15) NOT NULL,
    PRIMARY KEY (GuestID, PhoneNumber),
    CONSTRAINT fk_GuestPhone_Guest FOREIGN KEY (GuestID) REFERENCES Guest(GuestID)
);

CREATE TABLE StaffPhoneNumber (
    StaffID     varchar(20) NOT NULL,
    PhoneNumber varchar(15) NOT NULL,
    PRIMARY KEY (StaffID, PhoneNumber),
    CONSTRAINT fk_StaffPhone_Staff FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

CREATE TABLE GuestEmail (
    GuestID varchar(20)  NOT NULL,
    Email   varchar(100) NOT NULL,
    PRIMARY KEY (GuestID, Email),
    CONSTRAINT fk_GuestEmail_Guest FOREIGN KEY (GuestID) REFERENCES Guest(GuestID)
);

CREATE TABLE StaffEmail (
    StaffID varchar(20)  NOT NULL,
    Email   varchar(100) NOT NULL,
    PRIMARY KEY (StaffID, Email),
    CONSTRAINT fk_StaffEmail_Staff FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

CREATE TABLE RoomType(
	RoomTypeID int PRIMARY KEY,
    RoomTypeName varchar(50) NOT NULL,
    Description varchar(255),
    MaxOccupancy int NOT NULL,
    PricePerNight decimal(10,2) NOT NULL
);

CREATE TABLE Room(
	RoomNumber int PRIMARY KEY,
    RoomStatus varchar(20) NOT NULL,
    CHECK (RoomStatus IN ('Available', 'Occupied', 'Maintenance')),
	RoomTypeID int NOT NULL,
    CONSTRAINT fk_Room_RoomTypeID FOREIGN KEY (RoomTypeID) REFERENCES RoomType(RoomTypeID)
);

-- BookingSource Parent Table
CREATE TABLE BookingSource(
	SourceID varchar(20) PRIMARY KEY,
    SourceType varchar(20) NOT NULL
);

-- Child 1
CREATE TABLE DirectBooking(
    SourceID       varchar(20) PRIMARY KEY,
    BookingChannel varchar(20) NOT NULL,
    CONSTRAINT chk_BookingChannel CHECK (BookingChannel IN ('Walk-in', 'Phone', 'Email')),
    CONSTRAINT fk_Direct_SourceID FOREIGN KEY (SourceID) REFERENCES BookingSource(SourceID)
);

-- Child 2
CREATE TABLE ThirdPartyBookingPlatform(
	SourceID varchar(20) PRIMARY KEY,
    PlatformName varchar(50) NOT NULL,
    ContactInfo varchar(100),
    CommissionRate decimal(5,2),
    CONSTRAINT fk_ThirdParty_SourceID FOREIGN KEY (SourceID) REFERENCES BookingSource(SourceID)
);

CREATE TABLE Booking(
	BookingID varchar(20) PRIMARY KEY,
    BookingDate date NOT NULL,
    CheckInDate date NOT NULL,
    CheckOutDate date NOT NULL,
    BookingStatus varchar(20) NOT NULL,
    CHECK (BookingStatus IN ('Confirmed', 'Cancelled', 'Completed')),
    GuestID varchar(20) NOT NULL,
    StaffID varchar(20) NULL,
    SourceID varchar(20) NOT NULL,
    CONSTRAINT fk_Booking_GuestID FOREIGN KEY (GuestID) REFERENCES Guest(GuestID),
    CONSTRAINT fk_Booking_StaffID FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    CONSTRAINT fk_Booking_BookingSource FOREIGN KEY (SourceID) REFERENCES BookingSource(SourceID)
);

CREATE TABLE BookingRoom (
    BookingID varchar(20) NOT NULL,
    RoomNumber int NOT NULL,
    PRIMARY KEY (BookingID, RoomNumber),
    CONSTRAINT fk_BookingRoom_Booking FOREIGN KEY (BookingID) REFERENCES Booking(BookingID),
    CONSTRAINT fk_BookingRoom_Room FOREIGN KEY (RoomNumber) REFERENCES Room(RoomNumber)
);

-- Payment Parent Table
CREATE TABLE Payment(
	PaymentID varchar(20) PRIMARY KEY,
    PaymentDate datetime NOT NULL,
    PaymentMethod varchar(50) NOT NULL,
    Amount decimal(10,2) NOT NULL,
    PaymentStatus varchar(20) NOT NULL,
    CHECK (PaymentStatus IN ('Pending', 'Completed', 'Refunded')),
    BookingID varchar(20) NOT NULL,
    CONSTRAINT fk_Payment_BookingID FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
);

-- Child 1
CREATE TABLE Cash(
	PaymentID varchar(20) PRIMARY KEY,
    CONSTRAINT fk_CashPaymentID FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)
);

ALTER TABLE Cash
ADD AmountTendered DECIMAL(10,2) NOT NULL DEFAULT 0,
ADD ChangeGiven    DECIMAL(10,2) NOT NULL DEFAULT 0;

-- Child 2
CREATE TABLE BankTransfer(
	PaymentID varchar(20) PRIMARY KEY,
    BankName varchar(50) NOT NULL,
    AccountNumber varchar(20) NOT NULL,
    TransferReference varchar(50) NOT NULL,
    CONSTRAINT fk_BankTransfer_PaymentID FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)
);

-- Child 3
CREATE TABLE CreditCard(
	PaymentID varchar(20) PRIMARY KEY,
    CardNumber varchar(20) NOT NULL,
    CardType varchar(20) NOT NULL,
    ApprovalCode varchar(20) NOT NULL,
    CONSTRAINT fk_CreditCard_PaymentID FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)
);


INSERT INTO RoomType VALUES
(1, 'Standard', 'Basic room with essential amenities', 2, 1500),
(2, 'Deluxe', 'Spacious room with city view', 2, 2500),
(3, 'Family', 'Large room for family stay', 5, 3500),
(4, 'Suite', 'Luxury suite with living area', 4, 6000);

INSERT INTO Room VALUES
(101, 'Occupied', 1),
(102, 'Occupied', 1),
(103, 'Occupied', 1),
(104, 'Occupied', 1),
(105, 'Occupied', 1),
(106, 'Occupied', 1),
(107, 'Occupied', 1),
(108, 'Occupied', 1),
(109, 'Occupied', 1),
(110, 'Occupied', 1),
(111, 'Occupied', 1),
(112, 'Occupied', 1),
(113, 'Occupied', 1),
(114, 'Occupied', 1),
(115, 'Occupied', 1),
(116, 'Occupied', 1),
(117, 'Occupied', 1),
(118, 'Occupied', 1),
(119, 'Occupied', 1),
(120, 'Occupied', 1),
(121, 'Occupied', 1),
(122, 'Occupied', 1),
(123, 'Available', 1),
(124, 'Available', 1),
(125, 'Available', 1),
(126, 'Available', 1),
(127, 'Available', 1),
(128, 'Available', 1),
(129, 'Available', 1),
(130, 'Available', 1),
(131, 'Available', 1),
(132, 'Available', 1),
(133, 'Available', 1),
(134, 'Available', 1),
(135, 'Available', 1),
(136, 'Available', 1),
(137, 'Available', 1),
(138, 'Maintenance', 1),
(139, 'Maintenance', 1),
(140, 'Maintenance', 1),
(201, 'Occupied', 2),
(202, 'Occupied', 2),
(203, 'Occupied', 2),
(204, 'Occupied', 2),
(205, 'Occupied', 2),
(206, 'Occupied', 2),
(207, 'Occupied', 2),
(208, 'Occupied', 2),
(209, 'Occupied', 2),
(210, 'Occupied', 2),
(211, 'Available', 2),
(212, 'Available', 2),
(213, 'Available', 2),
(214, 'Available', 2),
(215, 'Available', 2),
(216, 'Available', 2),
(217, 'Available', 2),
(218, 'Available', 2),
(219, 'Maintenance', 2),
(220, 'Maintenance', 2),
(301, 'Occupied', 3),
(302, 'Occupied', 3),
(303, 'Occupied', 3),
(304, 'Occupied', 3),
(305, 'Occupied', 3),
(306, 'Occupied', 3),
(307, 'Occupied', 3),
(308, 'Occupied', 3),
(309, 'Available', 3),
(310, 'Available', 3),
(311, 'Available', 3),
(312, 'Available', 3),
(313, 'Available', 3),
(314, 'Available', 3),
(315, 'Available', 3),
(316, 'Available', 3),
(317, 'Available', 3),
(318, 'Available', 3),
(319, 'Available', 3),
(320, 'Maintenance', 3),
(401, 'Occupied', 4),
(402, 'Occupied', 4),
(403, 'Occupied', 4),
(404, 'Occupied', 4),
(405, 'Available', 4),
(406, 'Available', 4),
(407, 'Available', 4),
(408, 'Available', 4),
(409, 'Available', 4),
(410, 'Maintenance', 4);

INSERT INTO Staff VALUES
-- Manager
('STF001', 'Somsak', 	'Charoenwong', 	'M', 'Manager'),
-- Receptionist
('STF002', 'Naphat',    'Siriwan',      'M', 'Receptionist'),
('STF003', 'Ploy',      'Meetham',      'F', 'Receptionist'),
('STF004', 'Kannika',   'Thongdee',     'F', 'Receptionist'),
-- Housekeeping
('STF005', 'Malee',     'Suwanpat',     'F', 'Housekeeping'),
('STF006', 'Somjit',    'Kaewmala',     'F', 'Housekeeping'),
('STF007', 'Rattana',   'Phromma',      'F', 'Housekeeping'),
('STF008', 'Lek',       'Somboon',      'F', 'Housekeeping'),
('STF009', 'Chaiya',    'Nakorn',       'M', 'Housekeeping'),
-- Maintenance
('STF010', 'Prasit',    'Wongkham',     'M', 'Maintenance'),
('STF011', 'Somchai',   'Rungrot',      'M', 'Maintenance'),
('STF012', 'Anuwat',    'Thippayang',   'M', 'Maintenance'),
-- Concierge
('STF013', 'Nattawut',  'Saelee',       'M', 'Concierge'),
('STF014', 'Siriporn',  'Jaidee',       'F', 'Concierge'),
-- Restaurant
('STF015', 'Pensri',    'Khamdi',       'F', 'Restaurant'),
('STF016', 'Krit',      'Phakdee',      'M', 'Restaurant'),
-- Security
('STF017', 'Wichai',    'Saengjan',     'M', 'Security'),
('STF018', 'Mongkol',   'Duangdee',     'M', 'Security');

INSERT INTO StaffPhoneNumber (StaffID, PhoneNumber) VALUES
('STF001', '0812345001'),
('STF002', '0812345002'),
('STF003', '0812345003'),
('STF004', '0812345004'),
('STF005', '0812345005'),
('STF006', '0812345006'),
('STF007', '0812345007'),
('STF008', '0812345008'),
('STF009', '0812345009'),
('STF010', '0812345010'),
('STF011', '0812345011'),
('STF012', '0812345012'),
('STF013', '0812345013'),
('STF014', '0812345014'),
('STF015', '0812345015'),
('STF016', '0812345016'),
('STF017', '0812345017'),
('STF018', '0812345018');

INSERT INTO StaffEmail (StaffID, Email) VALUES
('STF001', 'somsak.c@luminarboutique.com'),
('STF002', 'naphat.s@luminarboutique.com'),
('STF003', 'ploy.m@luminarboutique.com'),
('STF004', 'kannika.t@luminarboutique.com'),
('STF005', 'malee.s@luminarboutique.com'),
('STF006', 'somjit.k@luminarboutique.com'),
('STF007', 'rattana.p@luminarboutique.com'),
('STF008', 'lek.s@luminarboutique.com'),
('STF009', 'chaiya.n@luminarboutique.com'),
('STF010', 'prasit.w@luminarboutique.com'),
('STF011', 'somchai.r@luminarboutique.com'),
('STF012', 'anuwat.t@luminarboutique.com'),
('STF013', 'nattawut.s@luminarboutique.com'),
('STF014', 'siriporn.j@luminarboutique.com'),
('STF015', 'pensri.k@luminarboutique.com'),
('STF016', 'krit.p@luminarboutique.com'),
('STF017', 'wichai.s@luminarboutique.com'),
('STF018', 'mongkol.d@luminarboutique.com');

INSERT INTO BookingSource (SourceID, SourceType) VALUES
('SRC001', 'Direct'),
('SRC002', 'Direct'),
('SRC003', 'ThirdParty'),
('SRC004', 'ThirdParty'),
('SRC005', 'ThirdParty');

INSERT INTO DirectBooking (SourceID, BookingChannel) VALUES
('SRC001', 'Walk-in'),
('SRC002', 'Phone');


INSERT INTO ThirdPartyBookingPlatform (SourceID, PlatformName, ContactInfo, CommissionRate) VALUES
('SRC003', 'Agoda',       'support@agoda.com',   15.00),
('SRC004', 'Booking.com', 'support@booking.com', 14.00),
('SRC005', 'Expedia',     'support@expedia.com', 18.00);

-- Imported GUEST data

-- Imported BOOKING data

-- Imported BookingRoom data

-- Imported Payment data

-- Import Cash/BankTransfer/CreditCard data

-- PHASE 5
-- 3 SELECTED QUERIES
-- Q1: Monthly guest nationality analysis for 2024 (MODIFIED)
SELECT
    g.Nationality,
    MONTH(b.BookingDate)        AS BookingMonth,
    COUNT(b.BookingID)          AS TotalBookings,
    COUNT(DISTINCT g.GuestID)   AS UniqueGuests,
    SUM(p.Amount)               AS TotalRevenue
FROM Guest g
JOIN Booking b  ON g.GuestID   = b.GuestID
JOIN Payment p  ON b.BookingID = p.BookingID
WHERE b.BookingDate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY g.Nationality, MONTH(b.BookingDate)
ORDER BY BookingMonth, TotalRevenue DESC;

-- Q3: Weekly room occupancy rate by room type
SELECT
    rt.RoomTypeName,
    WEEK(b.CheckInDate)         AS WeekNumber,
    COUNT(br.RoomNumber)        AS RoomsBooked,
    MAX(rt.PricePerNight)       AS PricePerNight,
    SUM(p.Amount)               AS WeeklyRevenue
FROM Booking b
JOIN BookingRoom br ON b.BookingID   = br.BookingID
JOIN Room r         ON br.RoomNumber = r.RoomNumber
JOIN RoomType rt    ON r.RoomTypeID  = rt.RoomTypeID
JOIN Payment p      ON b.BookingID   = p.BookingID
WHERE b.CheckInDate BETWEEN '2024-01-01' AND '2024-12-31'
  AND b.BookingStatus = 'Completed'
GROUP BY rt.RoomTypeName, WEEK(b.CheckInDate)
ORDER BY WeekNumber, RoomsBooked DESC;

-- Q10: Retrieve payment history for a specific guest across all bookings
SELECT *
FROM (
    SELECT
        g.GuestID,
        g.FirstName,
        g.LastName,
        b.BookingID,
        b.CheckInDate,
        b.CheckOutDate,
        p.PaymentID,
        p.PaymentDate,
        p.PaymentMethod,
        p.Amount,
        p.PaymentStatus,
        SUM(p.Amount) OVER (PARTITION BY g.GuestID) AS TotalSpent
    FROM Guest g
    JOIN Booking b ON g.GuestID = b.GuestID
    JOIN Payment p ON b.BookingID = p.BookingID
    WHERE g.GuestID = 'GST0201'
) AS sub
ORDER BY PaymentDate DESC;

-- Q1 BEFORE
EXPLAIN SELECT
    g.Nationality,
    MONTH(b.BookingDate)        AS BookingMonth,
    COUNT(b.BookingID)          AS TotalBookings,
    COUNT(DISTINCT g.GuestID)   AS UniqueGuests,
    SUM(p.Amount)               AS TotalRevenue
FROM Guest g		
JOIN Booking b  ON g.GuestID   = b.GuestID
JOIN Payment p  ON b.BookingID = p.BookingID
WHERE b.BookingDate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY g.Nationality, MONTH(b.BookingDate)
ORDER BY BookingMonth, TotalRevenue DESC;

-- CREATE VIEW for Q3
CREATE VIEW vw_WeeklyOccupancy AS
SELECT
    b.BookingID,
    b.CheckInDate,
    b.BookingStatus,
    WEEK(b.CheckInDate)     AS WeekNumber,
    rt.RoomTypeName,
    rt.PricePerNight,
    p.Amount
FROM Booking b
JOIN BookingRoom br  ON b.BookingID   = br.BookingID
JOIN Room r          ON br.RoomNumber = r.RoomNumber
JOIN RoomType rt     ON r.RoomTypeID  = rt.RoomTypeID
JOIN Payment p       ON b.BookingID   = p.BookingID;
-- Q3 BEFORE
EXPLAIN
SELECT
    RoomTypeName,
    WeekNumber,
    COUNT(*)            AS RoomsBooked,
    MAX(PricePerNight)  AS PricePerNight,
    SUM(Amount)         AS WeeklyRevenue
FROM vw_WeeklyOccupancy
WHERE CheckInDate BETWEEN '2024-01-01' AND '2024-12-31'
  AND BookingStatus = 'Completed'
GROUP BY RoomTypeName, WeekNumber
ORDER BY WeekNumber, RoomsBooked DESC;

-- Q10 BEFORE
EXPLAIN SELECT *
FROM (
    SELECT
        g.GuestID,
        g.FirstName,
        g.LastName,
        b.BookingID,
        b.CheckInDate,
        b.CheckOutDate,
        p.PaymentID,
        p.PaymentDate,
        p.PaymentMethod,
        p.Amount,
        p.PaymentStatus,
        SUM(p.Amount) OVER (PARTITION BY g.GuestID) AS TotalSpent
    FROM Guest g
    JOIN Booking b ON g.GuestID = b.GuestID
    JOIN Payment p ON b.BookingID = p.BookingID
    WHERE g.GuestID = 'GST0201'
) AS sub
ORDER BY PaymentDate DESC;

-- For Q1 and Q3 and Q10
CREATE INDEX idx_Booking_GuestID
    ON Booking(GuestID);

-- For Q1 and Q3
CREATE INDEX idx_BookingRoom_BookingID
    ON BookingRoom(BookingID);

-- For Q3
CREATE INDEX idx_Booking_BookingDate
    ON Booking(BookingDate);

-- For Q3
CREATE INDEX idx_Room_RoomTypeID
    ON Room(RoomTypeID);

-- For Q10
CREATE INDEX idx_Payment_BookingID
    ON Payment(BookingID);

-- For Q10
CREATE INDEX idx_Payment_PaymentDate
    ON Payment(PaymentDate);

-- Index for Q3's CheckInDate + BookingStatus filter
CREATE INDEX idx_Booking_CheckIn_Status ON Booking(CheckInDate, BookingStatus);

-- Composite index for Q10 — covers both JOIN and ORDER BY in one index
CREATE INDEX idx_Payment_BookingID_Date
    ON Payment(BookingID, PaymentDate);
    
-- Q1 AFTER
EXPLAIN SELECT
    g.Nationality,
    MONTH(b.BookingDate)        AS BookingMonth,
    COUNT(b.BookingID)          AS TotalBookings,
    COUNT(DISTINCT g.GuestID)   AS UniqueGuests,
    SUM(p.Amount)               AS TotalRevenue
FROM Guest g
JOIN Booking b  ON g.GuestID   = b.GuestID
JOIN Payment p  ON b.BookingID = p.BookingID
WHERE b.BookingDate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY g.Nationality, MONTH(b.BookingDate)
ORDER BY BookingMonth, TotalRevenue DESC;

-- Q3 AFTER: query through the view normally
EXPLAIN
SELECT
    RoomTypeName,
    WeekNumber,
    COUNT(*)            AS RoomsBooked,
    MAX(PricePerNight)  AS PricePerNight,
    SUM(Amount)         AS WeeklyRevenue
FROM vw_WeeklyOccupancy
WHERE CheckInDate BETWEEN '2024-01-01' AND '2024-12-31'
  AND BookingStatus = 'Completed'
GROUP BY RoomTypeName, WeekNumber
ORDER BY WeekNumber, RoomsBooked DESC;

-- Q10 AFTER
EXPLAIN SELECT *
FROM (
    SELECT
        g.GuestID,
        g.FirstName,
        g.LastName,
        b.BookingID,
        b.CheckInDate,
        b.CheckOutDate,
        p.PaymentID,
        p.PaymentDate,
        p.PaymentMethod,
        p.Amount,
        p.PaymentStatus,
        SUM(p.Amount) OVER (PARTITION BY g.GuestID) AS TotalSpent
    FROM Guest g
    JOIN Booking b ON g.GuestID = b.GuestID
    JOIN Payment p ON b.BookingID = p.BookingID
    WHERE g.GuestID = 'GST0201'
) AS sub
ORDER BY PaymentDate DESC;

-- Check Data Size
SELECT
    table_name                                          AS TableName,
    table_rows                                          AS EstimatedRows,
    ROUND(data_length / 1024, 2)                        AS DataSize_KB,
    ROUND(index_length / 1024, 2)                       AS IndexSize_KB,
    ROUND((data_length + index_length) / 1024, 2)       AS TotalSize_KB,
    ROUND(data_length / NULLIF(table_rows, 0), 2)       AS AvgRowSize_Bytes
FROM information_schema.tables
WHERE table_schema = 'LuminarBoutique'
ORDER BY data_length DESC;

SELECT
    c.TABLE_NAME,
    c.COLUMN_NAME,
    c.DATA_TYPE,
    c.CHARACTER_MAXIMUM_LENGTH,
    c.NUMERIC_PRECISION,
    c.NUMERIC_SCALE
FROM information_schema.COLUMNS c
WHERE c.TABLE_SCHEMA = 'LuminarBoutique'
AND c.TABLE_NAME IN ('Guest','Booking','BookingRoom','Room','RoomType','Payment')
ORDER BY c.TABLE_NAME, c.ORDINAL_POSITION;