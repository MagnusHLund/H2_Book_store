USE `BookStore`;

-- This Procedure is to create a Customer account

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS CreateAccount(
    IN PName VARCHAR(50), 
    IN PEmail VARCHAR(256), 
    IN PPassword VARCHAR(256), 
    IN PStreetName VARCHAR(30), 
    IN PHouseNumber VARCHAR(15), 
    IN PCity VARCHAR(30), 
    IN PZipCode INT,
    OUT result_message VARCHAR(256)) -- Declare output parameter
BEGIN
    DECLARE PCityID INT;
    DECLARE PAddressID INT;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SET result_message = 'An error occurred'; -- Set error message
    
    START TRANSACTION; -- Begin a transaction
    
    SELECT CityID INTO PCityID FROM Cities WHERE City = PCity AND ZipCode = PZipCode;
    
    IF PCityID IS NULL THEN
        -- Handle the case where either the city name or zip code (or both) doesn't match
        SET result_message = 'City name or zip code does not match'; -- Set error message
        ROLLBACK; -- Roll back the transaction
    END IF;
    
    -- Use prepared statement for the INSERT operation
    PREPARE stmt FROM 'INSERT INTO Addresses (CityID, StreetName, HouseNumber) VALUES (?, ?, ?)';
    SET @p1 = PCityID, @p2 = PStreetName, @p3 = PHouseNumber;
    EXECUTE stmt USING @p1, @p2, @p3;
    DEALLOCATE PREPARE stmt;
    
    IF FOUND_ROWS() = 0 THEN
        -- Handle the case where the insert operation didn't affect any rows
        SET result_message = 'An error occurred while inserting your address data in database'; -- Set error message
        ROLLBACK; -- Roll back the transaction
    END IF;
    
    SELECT LAST_INSERT_ID() INTO PAddressID; -- Get the last inserted address ID
    
    -- Use prepared statement for the INSERT operation
    PREPARE stmt FROM 'INSERT INTO Customers (AddressID, Name, Password, Email, CreatedAt) VALUES (?, ?, ?, ?, NOW())';
    SET @p1 = PAddressID, @p2 = PName, @p3 = PPassword, @p4 = PEmail;
    EXECUTE stmt USING @p1, @p2, @p3, @p4;
    DEALLOCATE PREPARE stmt;
    
    IF FOUND_ROWS() = 0 THEN
        -- Handle the case where the insert operation didn't affect any rows
        SET result_message = 'An error occurred while creating your account in database'; -- Set error message
        ROLLBACK; -- Roll back the transaction
    ELSE
        -- Return success message along with relevant information
        SET result_message = CONCAT('Your account has been created successfully! CustomerID: ', LAST_INSERT_ID()); -- Set success message
        COMMIT; -- Commit the transaction
    END IF;
    
END //

DELIMITER ;

-- This procedure is for the customer to login

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS Login(
    IN PEmail VARCHAR(256), 
    IN PPassword VARCHAR(256), 
    OUT result_message VARCHAR(256)
)
BEGIN
    DECLARE customer_id INT;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SET result_message = 'An error occurred'; -- Set error message
    
    START TRANSACTION; -- Begin a transaction
    
    -- Use prepared statement for the SELECT operation
    PREPARE stmt FROM 'SELECT CustomerID INTO @customer_id FROM Customers WHERE Email = ? AND Password = ?';
    SET @p1 = PEmail, @p2 = PPassword;
    EXECUTE stmt USING @p1, @p2;
    DEALLOCATE PREPARE stmt;

    SET customer_id = @customer_id;
    
    IF customer_id IS NULL THEN
        -- Handle the case where no matching customer is found
        SET result_message = 'Invalid email or password'; -- Set error message
    ELSE
        -- Return success message along with relevant information
        SET result_message = CONCAT('Login successful! CustomerID: ', customer_id); -- Set success message
    END IF;
    
    COMMIT; -- Commit the transaction
END //

DELIMITER ;

-- This procedure is to show the specific item Customer is looking for

-- This procedure works but is not completed so please wait a bit

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS GetAllBooksBySearch(
    IN searchText VARCHAR(250)
)
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Handle the exception here
        SHOW ERRORS;
    END;

    SET @searchText = CONCAT('%', searchText, '%');

    -- Use prepared statement for the SELECT operation
    PREPARE stmt FROM 'SELECT b.* FROM Books b LEFT JOIN BooksAuthorID ba ON b.BookID = ba.BookID LEFT JOIN Authors a ON ba.AuthorID = a.AuthorID WHERE b.Genre LIKE ? OR b.Category LIKE ? OR b.Name LIKE ? OR b.ISBN LIKE ? OR b.Language LIKE ? OR a.Name LIKE ?';
    EXECUTE stmt USING @searchText, @searchText, @searchText, @searchText, @searchText, @searchText;
    DEALLOCATE PREPARE stmt;
END;
//
DELIMITER ;

-- This procedure is to show all the Books there are 

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS GetAllBooks()
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Handle the exception here
        SHOW ERRORS;
    END;

    -- Attempt to select all records from the Books table
    SELECT * FROM Books;
END //

DELIMITER ;