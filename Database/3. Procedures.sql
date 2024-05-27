------------------------------------------------------------------------------------------------------------------------ 1

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS BookByID(
    IN PBookID INT
)
BEGIN
    DECLARE vRelease_date DATE;
    DECLARE vStock SMALLINT;
    DECLARE vGenre VARCHAR(35);
	DECLARE	vCategory VARCHAR(35);
	DECLARE vPrice SMALLINT;
	DECLARE vBookName VARCHAR(256);
	DECLARE visbn VARCHAR(23);
	DECLARE vLanguage VARCHAR(20);
	DECLARE vAuthorName VARCHAR(35);
	  
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Log or handle the exception here
        -- For demonstration purposes, I'm using SIGNAL to raise an error
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'An error occurred';
    END;

    -- Validate input (optional, adjust as needed)
    IF PBookID IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid input';
    END IF;

    -- Use parameterized query for SELECT operation
    PREPARE stmt FROM 
	'SELECT b.*, a.name AS author_name FROM Books b 
	JOIN AuthorsBooks ab ON b.book_id = ab.book_id 
	JOIN Authors a ON ab.author_id = a.author_id WHERE b.book_id = ?';
	
    EXECUTE stmt USING PBookID;
    -- Bind result variables
    SET @vRelease_date = vRelease_date;
    SET @vStock = vStock;
    SET @vGenre = vGenre;
    SET @vCategory = vCategory;
    SET @vPrice = vPrice;
    SET @vBookName = vBookName;
    SET @visbn = visbn;
    SET @vLanguage = vLanguage;
    SET @vAuthorName = vAuthorName;
    DEALLOCATE PREPARE stmt;

    -- Use the retrieved values as needed
    -- For demonstration purposes, I'm just selecting them
    SELECT @vRelease_date AS Release_date, 
	@vStock AS Stock, 
	@vGenre AS Genre, 
	@vCategory AS Category, 
	@vPrice AS Price, 
	@vBookName AS BookName, 
	@visbn AS isbn, 
	@vLanguage AS Language, 
	@vAuthorName AS AuthorName;

END //

DELIMITER ;

------------------------------------------------------------------------------------------------------------------------ 2

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS CityByZipCode(
    IN PZipCode INT
)
BEGIN
    DECLARE vCity VARCHAR(255); -- Adjust the size according to your data
	
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Log or handle the exception here
        -- For demonstration purposes, I'm using SIGNAL to raise an error
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'An error occurred';
    END;

    -- Validate input (optional, adjust as needed)
    IF PZipCode IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid input';
    END IF;

    -- Use parameterized query for SELECT operation
    PREPARE stmt FROM 'SELECT City FROM Cities WHERE zip_code = ?';
    EXECUTE stmt USING PZipCode;
    -- Bind result variables
    SET @vCity = vCity;
    DEALLOCATE PREPARE stmt;

    -- Use the retrieved values as needed
    -- For demonstration purposes, I'm just selecting them
    SELECT @vCity AS City;

END //

DELIMITER ;

------------------------------------------------------------------------------------------------------------------------ 3

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS CustomerDiscount(
    IN PCode VARCHAR(30)
)
BEGIN
    DECLARE vDiscountPercent TINYINT;
    DECLARE vExpires DATETIME;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Log or handle the exception here
        -- For demonstration purposes, I'm using SIGNAL to raise an error
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'An error occurred';
    END;

    -- Validate input (optional, adjust as needed)
    IF PCode IS NULL OR LENGTH(PCode) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid input';
    END IF;

    -- Use parameterized query for SELECT operation
    PREPARE stmt FROM 'SELECT discount_percentage, expiration_date FROM Coupons WHERE Code = ?';
    EXECUTE stmt USING PCode;
    -- Bind result variables
    SET @vDiscountPercent = vDiscountPercent;
    SET @vExpires = vExpires;
    DEALLOCATE PREPARE stmt;

    -- Use the retrieved values as needed
    -- For demonstration purposes, I'm just selecting them
    SELECT @vDiscountPercent AS DiscountPercent, @vExpires AS Expires;

END //

DELIMITER ;

------------------------------------------------------------------------------------------------------------------------ 4

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

------------------------------------------------------------------------------------------------------------------------ 5

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS GetAllBooksByText(
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
    PREPARE stmt FROM 'SELECT b.* FROM Books b LEFT JOIN authorsbooks ba ON b.book_id = ba.book_id LEFT JOIN Authors a ON ba.author_id = a.author_id WHERE b.genre LIKE ? OR b.category LIKE ? OR b.name LIKE ? OR b.isbn LIKE ? OR b.language LIKE ? OR a.name LIKE ?';
    EXECUTE stmt USING @searchText, @searchText, @searchText, @searchText, @searchText, @searchText;
    DEALLOCATE PREPARE stmt;
END;
//
DELIMITER ;

------------------------------------------------------------------------------------------------------------------------ 6

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS Login(
    IN PEmail VARCHAR(256), 
    IN PPassword VARCHAR(256), 
    OUT result_message VARCHAR(256)
)
BEGIN
    DECLARE user_id INT;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SET result_message = 'An error occurred'; -- Set error message
    
    START TRANSACTION; -- Begin a transaction
    
    -- Use prepared statement for the SELECT operation
    PREPARE stmt FROM 'SELECT user_id INTO @user_id FROM Users WHERE email = ? AND password = ?';
    SET @p1 = PEmail, @p2 = PPassword;
    EXECUTE stmt USING @p1, @p2;
    DEALLOCATE PREPARE stmt;

    SET user_id = @user_id;
    
    IF user_id IS NULL THEN
        -- Handle the case where no matching customer is found
        SET result_message = 'Invalid email or password'; -- Set error message
    ELSE
        -- Return success message along with relevant information
        SET result_message = CONCAT('Login successful! userID: ', user_id); -- Set success message
    END IF;
    
    COMMIT; -- Commit the transaction
END //

DELIMITER ;

------------------------------------------------------------------------------------------------------------------------ 7

DELIMITER //

CREATE PROCEDURE CreateUser(
    IN PName VARCHAR(50), 
    IN PEmail VARCHAR(256), 
    IN PPassword VARCHAR(256), 
    IN PStreet_name VARCHAR(30), 
    IN PHouse_number VARCHAR(15), 
    IN PCity VARCHAR(30), 
    IN PZip_code VARCHAR(4),
    IN PIs_admin TINYINT,
    OUT result_message VARCHAR(256)) -- Declare output parameter
BEGIN
    DECLARE PCityID INT;
    DECLARE PAddressID INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            -- An error occurred, rollback the transaction and set the result_message
            ROLLBACK;
            SET result_message = 'An error occurred while creating your account in database';
        END;

    START TRANSACTION; -- Begin a transaction
    
    -- Check if the city exists
    SET @city = PCity;
    SET @zip = PZip_code;
    PREPARE stmt FROM 'SELECT city_id FROM Cities WHERE city = ? AND zip_code = ?';
    EXECUTE stmt USING @city, @zip;
    DEALLOCATE PREPARE stmt;
    SELECT city_id INTO PCityID FROM Cities WHERE city = PCity AND zip_code = PZip_code;
    
    IF PCityID IS NULL THEN
        -- Handle the case where either the city name or zip code (or both) doesn't match
        SET result_message = 'City name or zip code does not match'; -- Set error message
        ROLLBACK; -- Roll back the transaction
    ELSE
        -- Insert into Addresses table
        SET @city_id = PCityID, @street = PStreet_name, @house = PHouse_number;
        PREPARE stmt FROM 'INSERT INTO Addresses (city_id, street_name, house_number) VALUES (?, ?, ?)';
        EXECUTE stmt USING @city_id, @street, @house;
        DEALLOCATE PREPARE stmt;
        
        -- Get the last inserted address ID
        SELECT LAST_INSERT_ID() INTO PAddressID;
        
        -- Insert into Users table
        SET @address_id = PAddressID, @name = PName, @password = PPassword, @email = PEmail, @is_admin = PIs_admin;
        PREPARE stmt FROM 'INSERT INTO Users (address_id, name, password, email, created_at, is_admin) VALUES (?, ?, ?, ?, NOW(), ?)';
        EXECUTE stmt USING @address_id, @name, @password, @email, @is_admin;
        DEALLOCATE PREPARE stmt;

        -- Return success message along with relevant information
        SET result_message = CONCAT('Your account has been created successfully! User_id: ', LAST_INSERT_ID()); -- Set success message
        COMMIT; -- Commit the transaction
    END IF;
END //

DELIMITER ;

