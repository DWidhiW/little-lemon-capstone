-- 1. Create Database
CREATE DATABASE IF NOT EXISTS little_lemon_db;
USE little_lemon_db;

-- 2. Create Customers Table
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(255),
    City VARCHAR(100),
    Country VARCHAR(100),
    ContactNumber VARCHAR(20)
);

-- 3. Create Bookings Table
CREATE TABLE IF NOT EXISTS Bookings (
    BookingID INT PRIMARY KEY,
    CustomerID INT,
    BookingDate DATE,
    TableNumber INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 4. Create Orders Table
CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    BookingID INT,
    OrderDate DATE,
    Quantity INT,
    TotalCost DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

-- ==========================================
-- 5. IMPLEMENT STORED PROCEDURES
-- ==========================================

-- A. GetMaxQuantity
DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT MAX(Quantity) AS MaxQuantity FROM Orders;
END //
DELIMITER ;

-- B. AddBooking
DELIMITER //
CREATE PROCEDURE AddBooking(
    IN booking_id INT,
    IN customer_id INT,
    IN booking_date DATE,
    IN table_number INT
)
BEGIN
    INSERT INTO Bookings (BookingID, CustomerID, BookingDate, TableNumber)
    VALUES (booking_id, customer_id, booking_date, table_number);
    SELECT 'New booking added successfully' AS Confirmation;
END //
DELIMITER ;

-- C. UpdateBooking
DELIMITER //
CREATE PROCEDURE UpdateBooking(
    IN booking_id INT,
    IN booking_date DATE
)
BEGIN
    UPDATE Bookings
    SET BookingDate = booking_date
    WHERE BookingID = booking_id;
    SELECT CONCAT('Booking ', booking_id, ' updated') AS Confirmation;
END //
DELIMITER ;

-- D. CancelBooking
DELIMITER //
CREATE PROCEDURE CancelBooking(
    IN booking_id INT
)
BEGIN
    DELETE FROM Bookings WHERE BookingID = booking_id;
    SELECT CONCAT('Booking ', booking_id, ' cancelled') AS Confirmation;
END //
DELIMITER ;

-- E. ManageBooking
DELIMITER //
CREATE PROCEDURE ManageBooking(IN booking_date DATE, IN table_no INT)
BEGIN
    DECLARE status_msg VARCHAR(50);
    IF EXISTS (SELECT * FROM Bookings WHERE BookingDate = booking_date AND TableNumber = table_no) THEN
        SET status_msg = CONCAT('Table ', table_no, ' is already booked - booking cancelled');
    ELSE
        SET status_msg = CONCAT('Table ', table_no, ' is available');
    END IF;
    SELECT status_msg AS Status;
END //
DELIMITER ;
