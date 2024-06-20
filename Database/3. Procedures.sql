-- -----------------------------This procedure is going to take 3 values and will return the data that is needed for admin to see orders details

DROP PROCEDURE IF Exists GetOrdersDetails;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS GetOrdersDetails(
    IN totalReceivedItems INT UNSIGNED,
    IN orderLimit INT UNSIGNED,
    IN userRole VARCHAR(8)
)
BEGIN
    -- Check if the role is 'Admin'
    IF userRole <> 'Admin' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Access denied: Only admin can view order details';
    ELSE
        -- Prepare the SQL statement using parameterized query
        SET @sql = CONCAT('
            SELECT 
                oi.book_id AS item_book_id,
                b.name AS item_name,
                b.price AS item_price,
                oi.quantity AS item_quantity,
                a.street_name,
                a.house_number,
                c.zip_code,
                c.city,
                o.total_price,
                COALESCE(coupon.code, "None") AS coupon_used,
                o.order_id,
                o.created_at AS order_creation_date
            FROM 
                Orders o
            JOIN 
                OrderItems oi ON o.order_id = oi.order_id
            JOIN 
                Books b ON oi.book_id = b.book_id
            JOIN 
                Addresses a ON o.address_id = a.address_id
            JOIN 
                Cities c ON a.city_id = c.city_id
            LEFT JOIN 
                Coupons coupon ON o.coupon_id = coupon.coupon_id
            ORDER BY 
                o.created_at DESC 
            LIMIT ?, ?');
        
        -- Execute the prepared statement with parameters
        PREPARE stmt FROM @sql;
        SET @totalReceivedItems = totalReceivedItems;
        SET @orderLimit = orderLimit;
        EXECUTE stmt USING @totalReceivedItems, @orderLimit;
        
        -- Cleanup
        DEALLOCATE PREPARE stmt;
    END IF;
END //

DELIMITER ;

-- -------------------------------------------------------------------this procedure is to verify coupon insert by user

DROP PROCEDURE IF EXISTS VerifyCoupon;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS VerifyCoupon(
    IN couponCode VARCHAR(30)
)
BEGIN
    DECLARE couponExists INT;

    -- Check if the coupon exists and is not expired
    SELECT COUNT(*)
    INTO couponExists
    FROM Coupons
    WHERE code = couponCode AND expiration_date > NOW();

    IF couponExists = 0 THEN
        -- Coupon is not valid
        SELECT 0 AS isValid;
    ELSE
        -- Coupon is valid
        SELECT 1 AS isValid;
    END IF;
END //

DELIMITER ;

-- ------------------------------------This procedure is going to take 4 values and will return the data that is needed for admin to see orders details

DROP PROCEDURE IF EXISTS GetFilteredOrdersDetails;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS GetFilteredOrdersDetails(
    IN totalReceivedItems INT UNSIGNED,
    IN orderLimit INT UNSIGNED,
    IN userRole VARCHAR(8),
    IN filterValue VARCHAR(50)
)
BEGIN
    -- Check if the role is 'Admin'
    IF userRole <> 'Admin' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Access denied: Only admin can view order details';
    ELSE
        -- Prepare the SQL statement using parameterized query
        SET @sql = '
            SELECT 
                oi.book_id AS item_book_id,
                b.name AS item_name,
                b.price AS item_price,
                oi.quantity AS item_quantity,
                a.street_name,
                a.house_number,
                c.zip_code,
                c.city,
                o.total_price,
                COALESCE(coupon.code, "None") AS coupon_used,
                o.order_id,
                o.created_at AS order_creation_date
            FROM 
                Orders o
            JOIN 
                OrderItems oi ON o.order_id = oi.order_id
            JOIN 
                Books b ON oi.book_id = b.book_id
            JOIN 
                Addresses a ON o.address_id = a.address_id
            JOIN 
                Cities c ON a.city_id = c.city_id
            LEFT JOIN 
                Coupons coupon ON o.coupon_id = coupon.coupon_id
            JOIN 
                Users u ON o.user_id = u.user_id
            WHERE 
                u.name = ? OR o.order_id = ? OR DATE(o.created_at) = ?
            ORDER BY 
                o.created_at DESC 
            LIMIT ?, ?';
        
        -- Execute the prepared statement with parameters
        PREPARE stmt FROM @sql;
        SET @customerName = filterValue;
        SET @orderID = CAST(filterValue AS UNSIGNED);
        SET @orderDate = STR_TO_DATE(filterValue, '%Y-%m-%d');
        SET @totalReceivedItems = totalReceivedItems;
        SET @orderLimit = orderLimit;
        EXECUTE stmt USING @customerName, @orderID, @orderDate, @totalReceivedItems, @orderLimit;
        
        -- Cleanup
        DEALLOCATE PREPARE stmt;
    END IF;
END //

DELIMITER ;

-- -----------------------------------------------------this procedure will take user id and return all orders for that user id

DROP PROCEDURE IF EXISTS GetUserOrdersDetails;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS GetUserOrdersDetails(
    IN totalReceivedItems INT UNSIGNED,
    IN orderLimit INT UNSIGNED,
    IN userRole VARCHAR(8),
    IN userID INT UNSIGNED
)
BEGIN
        -- Prepare the SQL statement using parameterized query
        SET @sql = '
            SELECT 
                oi.book_id AS item_book_id,
                b.name AS item_name,
                b.price AS item_price,
                oi.quantity AS item_quantity,
                a.street_name,
                a.house_number,
                c.zip_code,
                c.city,
                o.total_price,
                COALESCE(coupon.code, "None") AS coupon_used,
                o.order_id,
                o.created_at AS order_creation_date
            FROM 
                Orders o
            JOIN 
                OrderItems oi ON o.order_id = oi.order_id
            JOIN 
                Books b ON oi.book_id = b.book_id
            JOIN 
                Addresses a ON o.address_id = a.address_id
            JOIN 
                Cities c ON a.city_id = c.city_id
            LEFT JOIN 
                Coupons coupon ON o.coupon_id = coupon.coupon_id
            JOIN 
                Users u ON o.user_id = u.user_id
            WHERE 
                o.user_id = ?
            ORDER BY 
                o.created_at DESC 
            LIMIT ?, ?';
        
        -- Execute the prepared statement with parameters
        PREPARE stmt FROM @sql;
        SET @totalReceivedItems = totalReceivedItems;
        SET @orderLimit = orderLimit;
        EXECUTE stmt USING userID, @totalReceivedItems, @orderLimit;
        
        -- Cleanup
        DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

-- ------------------------------------------------------this procedure will return cityName when we tell it the zipCode

DROP PROCEDURE IF EXISTS GetCityByZipCode;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS GetCityByZipCode(
    IN input_zip_code VARCHAR(4)
)
BEGIN
    DECLARE city_not_found CONDITION FOR SQLSTATE '02000';

    DECLARE CONTINUE HANDLER FOR city_not_found
        SELECT 'Not Found' AS city_name;

    -- Use a prepared statement to further ensure safety against SQL injection
    SET @sql = 'SELECT city FROM Cities WHERE zip_code = ? LIMIT 1';

    PREPARE stmt FROM @sql;
    SET @input_zip_code = input_zip_code;

    EXECUTE stmt USING @input_zip_code;

    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

-- ------------------------------------------------------------this is to check if the product id and quantity is valid

DROP PROCEDURE IF EXISTS ValidateProduct;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS ValidateProduct(
    IN input_product_id INT UNSIGNED,
    IN input_quantity INT UNSIGNED
)
BEGIN
    DECLARE product_not_found CONDITION FOR SQLSTATE '02000';
    
    DECLARE CONTINUE HANDLER FOR product_not_found
        SELECT FALSE AS is_valid;

    -- Use a prepared statement for SQL injection protection
    SET @sql = 'SELECT stock >= ? FROM Books WHERE book_id = ?';

    PREPARE stmt FROM @sql;
    SET @input_quantity = input_quantity;
    SET @input_product_id = input_product_id;

    EXECUTE stmt USING @input_quantity, @input_product_id;

    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;


-- -- -----------------------------------------------------------this procedure checks if user exists

-- DROP PROCEDURE IF EXISTS CheckUserExists;

-- DELIMITER //

-- CREATE PROCEDURE IF NOT EXISTS CheckUserExists(
--     IN input_email VARCHAR(255)
-- )
-- BEGIN
--     DECLARE user_not_found CONDITION FOR SQLSTATE '02000';

--     DECLARE CONTINUE HANDLER FOR user_not_found
--         SELECT FALSE AS user_exists;

--     -- Use a prepared statement for SQL injection protection
--     SET @sql = 'SELECT EXISTS(SELECT 1 FROM Users WHERE email = ?) AS user_exists';

--     PREPARE stmt FROM @sql;
--     SET @input_email = input_email;

--     EXECUTE stmt USING @input_email;

--     DEALLOCATE PREPARE stmt;
-- END //

-- DELIMITER ;

-- -----------------------------------------------------------this procedure checks if user phone number exists

DROP PROCEDURE IF EXISTS CheckUserPhoneExists;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS CheckUserPhoneExists(
    IN input_phone_number VARCHAR(255) 
)
BEGIN
    DECLARE user_not_found CONDITION FOR SQLSTATE '02000';

    DECLARE CONTINUE HANDLER FOR user_not_found
        SELECT FALSE AS user_exists;

    -- Use a prepared statement for SQL injection protection
    SET @sql = 'SELECT EXISTS(SELECT 1 FROM Users WHERE phone_number = ?) AS user_exists';

    PREPARE stmt FROM @sql;
    SET @input_phone_number = input_phone_number;

    EXECUTE stmt USING @input_phone_number;

    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

-- --------------------------------------------------this procedure will create a guest account if user does not exists

DROP PROCEDURE IF EXISTS CreateGuestAccount;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS CreateGuestAccount(
    IN input_name VARCHAR(50),
    IN input_email VARCHAR(255),
    IN input_phone_number VARCHAR(255),
    IN input_role VARCHAR(8),
    IN input_created_at DATETIME
)
BEGIN
    -- Check that all input parameters are provided
    IF input_name IS NULL OR input_email IS NULL OR input_phone_number IS NULL OR input_role IS NULL OR input_created_at IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'All parameters (name, email, phone_number, role, created_at) must be provided';
    END IF;

    -- Use a prepared statement for SQL injection protection
    SET @sql = 'INSERT INTO Users (name, email, phone_number, role, created_at) VALUES (?, ?, ?, ?, ?)';

    PREPARE stmt FROM @sql;
    SET @input_name = input_name;
    SET @input_email = input_email;
    SET @input_phone_number = input_phone_number;
    SET @input_role = input_role;
    SET @input_created_at = input_created_at;

    EXECUTE stmt USING @input_name, @input_email, @input_phone_number, @input_role, @input_created_at;

    -- Get the last inserted ID
    SELECT LAST_INSERT_ID() AS guest_id;

    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

-- --------------------------------------------------this procedure will store user order data into the table

DROP PROCEDURE IF EXISTS InsertOrder;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS InsertOrder(
    IN p_user_id INT UNSIGNED,
    IN p_address_id INT UNSIGNED,
    IN p_coupon_id INT UNSIGNED,
    IN p_total_price FLOAT UNSIGNED,
    IN p_order_items JSON
)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE n INT;
    DECLARE item JSON;
    DECLARE book_id INT UNSIGNED;
    DECLARE price FLOAT UNSIGNED;
    DECLARE quantity SMALLINT UNSIGNED;
    DECLARE item_json VARCHAR(1024); -- Adjust the size based on your JSON structure
    DECLARE order_id INT UNSIGNED; -- Variable to store order ID

    -- Calculate the number of items in the JSON array
    SET n = JSON_LENGTH(p_order_items);

    -- Start a transaction
    START TRANSACTION;

    -- Insert the order
    INSERT INTO Orders (user_id, address_id, coupon_id, total_price, created_at)
    VALUES (p_user_id, p_address_id, p_coupon_id, p_total_price, NOW());

    -- Get the last inserted order ID
    SET order_id = LAST_INSERT_ID();

    -- Prepare the statement for inserting order items
    SET @stmt = 'INSERT INTO OrderItems (order_id, book_id, price, quantity) VALUES (?, ?, ?, ?)';
    PREPARE stmt FROM @stmt;

    -- Loop through the JSON array and insert each order item
    WHILE i < n DO
        SET item = JSON_EXTRACT(p_order_items, CONCAT('$[', i, ']'));
        SET book_id = JSON_UNQUOTE(JSON_EXTRACT(item, '$.book_id'));
        SET price = JSON_UNQUOTE(JSON_EXTRACT(item, '$.price'));
        SET quantity = JSON_UNQUOTE(JSON_EXTRACT(item, '$.quantity'));

        -- Execute the prepared statement with parameters
        EXECUTE stmt USING order_id, book_id, price, quantity;

        SET i = i + 1;
    END WHILE;

    -- Deallocate the prepared statement
    DEALLOCATE PREPARE stmt;

    -- Commit the transaction
    COMMIT;

    -- Select the order_id at the end of the procedure
    SELECT order_id AS new_order_id;

    -- No need to return anything explicitly
END //

DELIMITER ;

-- ----------------------------------------------------------------------------this procedure will get all products

DROP PROCEDURE IF EXISTS GetProducts;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS GetProducts(
    IN totalReceivedItems INT UNSIGNED,
    IN orderLimit INT UNSIGNED,
    IN userRole VARCHAR(8)
)
BEGIN
    -- Check if the role is 'Admin'
    IF userRole <> 'Admin' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Access denied: Only admin can view order details';
    ELSE
        -- Prepare the SQL statement using parameterized query
        SET @sql = CONCAT('
            SELECT 
                oi.book_id AS item_book_id,
                b.name AS item_name,
                b.price AS item_price,
                oi.quantity AS item_quantity,
                a.street_name,
                a.house_number,
                c.zip_code,
                c.city,
                o.total_price,
                COALESCE(coupon.code, "None") AS coupon_used,
                o.order_id,
                o.created_at AS order_creation_date
            FROM 
                Orders o
            JOIN 
                OrderItems oi ON o.order_id = oi.order_id
            JOIN 
                Books b ON oi.book_id = b.book_id
            JOIN 
                Addresses a ON o.address_id = a.address_id
            JOIN 
                Cities c ON a.city_id = c.city_id
            LEFT JOIN 
                Coupons coupon ON o.coupon_id = coupon.coupon_id
            ORDER BY 
                o.created_at DESC 
            LIMIT ?, ?');
        
        -- Execute the prepared statement with parameters
        PREPARE stmt FROM @sql;
        SET @totalReceivedItems = totalReceivedItems;
        SET @orderLimit = orderLimit;
        EXECUTE stmt USING @totalReceivedItems, @orderLimit;
        
        -- Cleanup
        DEALLOCATE PREPARE stmt;
    END IF;
END //

DELIMITER ;

-- ----------------------------------------------------------------------------this procedure will get product regarding it's id

DROP PROCEDURE IF EXISTS GetProductById;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS GetProductById(
    IN productId INT UNSIGNED
)
BEGIN
    -- Prepare the SQL statement using parameterized query
    SET @sql = '
        SELECT b.book_id AS product_id,
               b.name,
               b.price,
               bi.file_path AS image
        FROM Books b
        LEFT JOIN BookImages bi ON b.book_id = bi.book_id
        WHERE b.book_id = ?';
    
    -- Execute the prepared statement with parameter
    PREPARE stmt FROM @sql;
    EXECUTE stmt USING productId;
    
    -- Cleanup
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

-- ----------------------------------------------------------------------------this procedure will search products regarding insert value

DROP PROCEDURE IF EXISTS SearchProducts;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS SearchProducts(
    IN totalReceivedProducts INT UNSIGNED,
    IN productLimit INT UNSIGNED,
    IN search VARCHAR(255)
)
BEGIN
    -- Prepare the SQL statement using parameterized query
    SET @sql = '
        SELECT b.book_id AS product_id,
               b.name,
               b.genre,
               b.release_date AS date,
               b.isbn,
               GROUP_CONCAT(DISTINCT a.name ORDER BY a.name ASC SEPARATOR \', \') AS author_names,
               bi.file_path AS image
        FROM Books b
        LEFT JOIN BookImages bi ON b.book_id = bi.book_id
        LEFT JOIN AuthorsBooks ab ON b.book_id = ab.book_id
        LEFT JOIN Authors a ON ab.author_id = a.author_id
        WHERE (a.name LIKE CONCAT(\'%\', ?, \'%\')
               OR b.book_id = ?
               OR b.name LIKE CONCAT(\'%\', ?, \'%\')
               OR b.genre LIKE CONCAT(\'%\', ?, \'%\')
               OR b.release_date LIKE CONCAT(\'%\', ?, \'%\')
               OR b.isbn LIKE CONCAT(\'%\', ?, \'%\'))
        GROUP BY b.book_id
        ORDER BY b.book_id ASC
        LIMIT ?, ?';

    -- Execute the prepared statement with parameters
    PREPARE stmt FROM @sql;
    SET @search = search;
    SET @totalReceivedProducts = totalReceivedProducts;
    SET @productLimit = productLimit;
    EXECUTE stmt USING @search, @search, @search, @search, @search, @search, @totalReceivedProducts, @productLimit;
    
    -- Cleanup
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

-- ----------------------------------------------------------------------------this procedure will toggle product visibility

DROP PROCEDURE IF EXISTS ToggleProductVisibility;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS ToggleProductVisibility(
    IN productId INT UNSIGNED
)
BEGIN
    DECLARE currentDisplay TINYINT;
    
    -- Retrieve the current display value of the product
    SELECT `display` INTO currentDisplay
    FROM Books
    WHERE book_id = productId;
    
    -- Check if product exists
    IF currentDisplay IS NOT NULL THEN
        -- Toggle the display value
        UPDATE Books
        SET `display` = CASE WHEN currentDisplay = 0 THEN 1 ELSE 0 END
        WHERE book_id = productId;
        
        SELECT CONCAT('Product with ID ', productId, ' visibility toggled successfully.') AS message;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product does not exist.';
    END IF;
    
END //

DELIMITER ;

-- ----------------------------------------------------------------------------this procedure will return user billing info

DROP PROCEDURE IF EXISTS GetUserInformation;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS GetUserInformation (
    IN user_id_param INT UNSIGNED
)
BEGIN
    DECLARE v_username VARCHAR(50);
    DECLARE v_email VARCHAR(255);
    DECLARE v_address VARCHAR(34);
    DECLARE v_zip_code VARCHAR(4);
    DECLARE v_city VARCHAR(18);
    DECLARE v_phone_number VARCHAR(255);

    -- Declare variables to hold the results
    SELECT
        u.name, u.email, CONCAT(a.street_name, ', ', c.zip_code, ' ', ci.city) AS address,
        c.zip_code, ci.city, u.phone_number
    INTO
        v_username, v_email, v_address, v_zip_code, v_city, v_phone_number
    FROM
        Users u
        LEFT JOIN Addresses a ON u.address_id = a.address_id
        LEFT JOIN Cities c ON a.city_id = c.city_id
        LEFT JOIN Cities ci ON a.city_id = ci.city_id
    WHERE
        u.user_id = user_id_param;

    -- Return the results
    SELECT
        v_username AS username,
        v_email AS email,
        v_address AS address,
        v_zip_code AS zip_code,
        v_city AS city,
        v_phone_number AS phone_number;
END //

DELIMITER ;

-- ----------------------------------------------------------------------------this procedure will check if the email is unique or not

DROP PROCEDURE IF EXISTS CheckEmailUnique;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS CheckEmailUnique(
    IN userEmail VARCHAR(255)
)
BEGIN
    DECLARE emailCount INT;
    DECLARE isUnique BOOLEAN;

    -- Sanitize and validate input (if necessary, depending on your application's context)

    -- Use prepared statement to avoid SQL injection
    SET @query = 'SELECT COUNT(*) FROM Users WHERE email = ?';
    PREPARE stmt FROM @query;
    EXECUTE stmt USING userEmail;
    SELECT COUNT(*) INTO emailCount;
    DEALLOCATE PREPARE stmt;

    -- Check uniqueness
    IF emailCount = 0 THEN
        SET isUnique = TRUE;
    ELSE
        SET isUnique = FALSE;
    END IF;

    -- Return the isUnique flag as a SELECT result
    SELECT isUnique AS is_email_unique;
END //

DELIMITER ;

-- ----------------------------------------------------------------------------this procedure will create an account for user

DROP PROCEDURE IF EXISTS CreateUser;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS CreateUser(
    IN userName VARCHAR(50),
    IN userEmail VARCHAR(255),
    IN userPhoneNumber VARCHAR(255),
    IN userPassword VARCHAR(255),
    IN userSalt VARCHAR(60),
    IN userRole VARCHAR(8),
    IN userAddressId INT UNSIGNED
)
BEGIN
    DECLARE emailCount INT;

    -- Check if email already exists
    SELECT COUNT(*) INTO emailCount FROM Users WHERE email = userEmail;

    IF emailCount > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email already exists';
    ELSE
        -- Use prepared statement to avoid SQL injection
        SET @query = 'INSERT INTO Users (name, email, phone_number, password, salt, role, address_id, created_at)
                      VALUES (?, ?, ?, ?, ?, ?, ?, NOW())';
        PREPARE stmt FROM @query;
        EXECUTE stmt USING userName, userEmail, userPhoneNumber, userPassword, userSalt, userRole, userAddressId;
        DEALLOCATE PREPARE stmt;

        SELECT LAST_INSERT_ID() AS user_id;

    END IF;
END //

DELIMITER ;

-- ----------------------------------------------------------------------------this procedure will log user in

DROP PROCEDURE IF EXISTS GetUserCredentials;

DELIMITER //

CREATE PROCEDURE GetUserCredentials(IN userEmail VARCHAR(255))
BEGIN
    DECLARE userPassword VARCHAR(255);
    DECLARE userSalt VARCHAR(60);
    DECLARE userId INT UNSIGNED;

    -- Assuming your Users table has columns 'password' and 'salt'
    SELECT password, salt, user_id INTO userPassword, userSalt, userId
    FROM Users
    WHERE email = userEmail;

    -- Return the password and salt
    SELECT userPassword AS Password, userSalt AS Salt, userId AS user_id;
END //

DELIMITER ;

-- -------------------------------------------------this procedure will insert an address and return it's id

DROP PROCEDURE IF EXISTS InsertAddress;

DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS InsertAddress(
    IN zipCode VARCHAR(4), 
    IN streetName VARCHAR(34), 
    IN houseNumber VARCHAR(15)
)
BEGIN
    DECLARE cityId INT UNSIGNED;

    -- Sanitize input to prevent SQL injection
    SET zipCode = TRIM(REPLACE(REPLACE(REPLACE(zipCode, "'", "''"), ";", ""), "--", ""));
    SET streetName = TRIM(REPLACE(REPLACE(REPLACE(streetName, "'", "''"), ";", ""), "--", ""));
    SET houseNumber = TRIM(REPLACE(REPLACE(REPLACE(houseNumber, "'", "''"), ";", ""), "--", ""));
    
    -- Check if the city exists based on zip code
    SELECT city_id INTO cityId 
    FROM Cities 
    WHERE zip_code = zipCode;
    
    IF cityId IS NULL THEN
        -- City does not exist, return a message
        SELECT 'City does not exist in the Cities table.' AS message;
    ELSE
        -- City exists, insert data into Addresses table
        INSERT INTO Addresses (city_id, street_name, house_number)
        VALUES (cityId, streetName, houseNumber);

        -- Return the newly inserted address_id
        SELECT LAST_INSERT_ID() AS address_id;
    END IF;
END$$

DELIMITER ;