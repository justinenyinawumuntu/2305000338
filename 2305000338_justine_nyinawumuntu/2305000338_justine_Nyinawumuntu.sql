show databases;

-- 7.SQL(CRUD/COUNT,AVG,SUM) for each table
-- DATABASE CREATION

CREATE DATABASE Event_Management_System;

use Event_Management_System;
-- TABLES CREATON
-- Event Table

CREATE TABLE Event (
    EventID INT PRIMARY KEY AUTO_INCREMENT,
    EventName VARCHAR(255) NOT NULL,
    EventType VARCHAR(100),
    StartDate DATE NOT NULL,
    EndDate DATE,
    Location VARCHAR(255)
);

--  Venue Table

CREATE TABLE Venue (
    VenueID INT PRIMARY KEY AUTO_INCREMENT,
    VenueName VARCHAR(255) NOT NULL,
    Address TEXT NOT NULL,
    Capacity INT NOT NULL,
    ContactInfo VARCHAR(100)
);
--  creation table Organizer 

CREATE TABLE Organizer (
    OrganizerID INT PRIMARY KEY AUTO_INCREMENT,
    OrganizerName VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(100),
    Email VARCHAR(255) UNIQUE
);

-- CREATION TABLE  Attendee Table

CREATE TABLE Attendee (
    AttendeeID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(20)
);
-- CREATE TABLE Ticket 

CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY AUTO_INCREMENT,
    TicketType VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    EventID INT,
    AttendeeID INT,
    FOREIGN KEY (EventID) REFERENCES Event(EventID) ON DELETE CASCADE,
    FOREIGN KEY (AttendeeID) REFERENCES Attendee(AttendeeID) ON DELETE SET NULL
);
-- Payment Table

CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    AttendeeID INT NOT NULL,
    EventID INT NOT NULL,
    AmountPaid DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(50),
    PaymentDate DATE NOT NULL,
    FOREIGN KEY (AttendeeID) REFERENCES Attendee(AttendeeID) ON DELETE CASCADE,
    FOREIGN KEY (EventID) REFERENCES Event(EventID) ON DELETE CASCADE
);
-- Insert Data into table

INSERT INTO Event (EventName, EventType, StartDate, EndDate, Location) VALUES ('Tech Conference', 'Technology', '2025-06-01', '2025-06-03', 'Kigali Convention Center');

INSERT INTO Venue (VenueName, Address, Capacity, ContactInfo) VALUES ('Kigali Convention Center', 'KG 2 Roundabout, Kigali', 500, 'venue@example.com');

INSERT INTO Organizer (OrganizerName, ContactInfo, Email) VALUES ('John Doe', '0781234567', 'john@example.com');

INSERT INTO Attendee (FullName, Email, PhoneNumber) VALUES ('Jane Smith', 'jane@example.com', '0788765432');

INSERT INTO Ticket (TicketType, Price, EventID, AttendeeID) VALUES ('VIP', 50.00, 1, 1);

INSERT INTO Payment (AttendeeID, EventID, AmountPaid, PaymentMethod, PaymentDate) VALUES (1, 1, 50.00, 'Credit Card', '2025-06-01');
-- Read Data

SELECT * FROM Event;

SELECT * FROM Venue;

SELECT * FROM Organizer;

SELECT * FROM Attendee;

SELECT * FROM Ticket;

SELECT * FROM Payment;

-- Update Data

UPDATE Event SET Location = 'Radisson Blu Hotel' WHERE EventID = 1;

UPDATE Attendee SET PhoneNumber = '0781112233' WHERE AttendeeID = 1;

UPDATE Ticket SET Price = 55.00 WHERE TicketID = 1;

-- Delete Data

DELETE FROM Payment WHERE PaymentID = 1;

DELETE FROM Ticket WHERE TicketID = 1;

DELETE FROM Attendee WHERE AttendeeID = 1;

-- Aggregate Queries

SELECT COUNT(*) AS TotalEvents FROM Event;

SELECT AVG(Price) AS AverageTicketPrice FROM Ticket;

SELECT SUM(AmountPaid) AS TotalRevenue FROM Payment;

-- PL/SQL Views

CREATE VIEW EventDetails AS
SELECT EventID, EventName, EventType, StartDate, EndDate, Location FROM Event;

CREATE VIEW AttendeeList AS
SELECT AttendeeID, FullName, Email FROM Attendee;

CREATE VIEW TicketSales AS
SELECT TicketType, COUNT(*) AS TotalSold, SUM(Price) AS TotalRevenue FROM Ticket GROUP BY TicketType;

CREATE VIEW PaymentSummary AS
SELECT EventID, SUM(AmountPaid) AS TotalRevenue FROM Payment GROUP BY EventID;

CREATE VIEW OrganizerDetails AS
SELECT OrganizerID, OrganizerName, Email FROM Organizer;

CREATE VIEW VenueCapacity AS
SELECT VenueName, Capacity FROM Venue;

-- PL/SQL Stored Procedures

DELIMITER $$
CREATE PROCEDURE AddEvent(IN eventName VARCHAR(255), IN eventType VARCHAR(100), IN startDate DATE, IN endDate DATE, IN location VARCHAR(255))
BEGIN
    INSERT INTO Event (EventName, EventType, StartDate, EndDate, Location) VALUES (eventName, eventType, startDate, endDate, location);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE GetTotalRevenue(OUT total DECIMAL(10,2))
BEGIN
    SELECT SUM(AmountPaid) INTO total FROM Payment;
END $$
DELIMITER ;

-- PL/SQL Triggers

DELIMITER $$
CREATE TRIGGER after_event_insert
AFTER INSERT ON Event
FOR EACH ROW
BEGIN
    INSERT INTO LogTable (Description, CreatedAt) VALUES (CONCAT('New Event Added: ', NEW.EventName), NOW());
END $$
DELIMITER ;
-- 9.Creating a user and granting permissions

CREATE USER 'event_admin'@'localhost' IDENTIFIED BY 'securepassword';
GRANT SELECT, INSERT, UPDATE, DELETE ON EventManagementDB.* TO 'event_admin'@'localhost';
FLUSH PRIVILEGES;