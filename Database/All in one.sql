-- Creates the database if it does not already exist
CREATE DATABASE IF NOT EXISTS `davidsbookclub`;

-- Uses the database
USE `davidsbookclub`;

-- Overall information:
-- Each table only attempts to get created, if it does not already exist.
-- Almost all columns do not allow null values.
-- Every primary key is an ID, that gets auto incremented. 
-- All IDs are unsigned, because we are not interested in having negative IDs.
-- While just writing "Primary key", or another constraint type, would also work, we have specified key constraints at the bottom.
-- Foreign keys have also been specified a name, while other constraints haven`t.

-- The Coupons table consists of 4 columns, of which "coupon_id" is the primary key.
-- The discount_percentage makes sure that the value is always between 0 and 100.
-- The table is used for handling discount codes, applied in the checkout.
-- The coupon code has been indexed, because its much more common to use a coupon than to create one.
CREATE TABLE IF NOT EXISTS `Coupons`(
    `coupon_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(30) NOT NULL,
    `discount_percentage` TINYINT UNSIGNED NOT NULL CHECK (discount_percentage BETWEEN 0 AND 100),
    `expiration_date` DATETIME NOT NULL,
    
    PRIMARY KEY (`coupon_id`),
    KEY `code_index` (`code`)
);

-- The Books table has 9 columns, of which book_id is the primary key.
-- There are 2 checks, to ensure that the stock and price are not below 0.
-- The table is used to keep track of the books in the store.
CREATE TABLE IF NOT EXISTS `Books`(
    `book_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `release_date` DATE NOT NULL,
    `stock` SMALLINT UNSIGNED NOT NULL,
    `genre` VARCHAR(35) NOT NULL,
    `category` VARCHAR(35) NOT NULL,
    `price` SMALLINT UNSIGNED NOT NULL,
    `name` VARCHAR(256) NOT NULL,
    `isbn` VARCHAR(13) NOT NULL,
    `language` VARCHAR(20) NOT NULL,

    PRIMARY KEY (`book_id`),
    KEY `name_index` (`name`),
    KEY `isbn_index` (`isbn`),
    KEY `genre_index` (`genre`),
    KEY `category_index` (`category`),
    KEY `language_index` (`language`)
);

-- The Authors table has 3 columns, of which author_id is the primary key.
-- This table is responsible for handling data related to a specific author.
CREATE TABLE IF NOT EXISTS `Authors`(
    `author_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(35) NOT NULL,

    PRIMARY KEY(`author_id`),
    KEY `name_index` (`name`)
);

-- The AuthorBooks table is a many to many table.
-- ab_id (aka author_book_id) is the primary key.
-- author_id and book_id are foreign keys from the Authors table and Books table.
CREATE TABLE IF NOT EXISTS `AuthorsBooks`(
    `ab_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `author_id` INT UNSIGNED NOT NULL,
    `book_id` INT UNSIGNED NOT NULL,

    PRIMARY KEY(`ab_id`),
    CONSTRAINT `authors_books_fk_1` FOREIGN KEY(`author_id`) REFERENCES `Authors` (`author_id`) ON DELETE CASCADE,
    CONSTRAINT `authors_books_fk_2` FOREIGN KEY(`book_id`) REFERENCES `Books` (`book_id`) ON DELETE CASCADE
);

-- The Cities table has zip codes and cities, from Denmark.
-- The city_id is the primary key.
-- zip_code is only 4 characters long, because Danish zip codes don`t use more than 4 characters. It is also indexed.
-- The table is used to automatically fill out the city name, when the user writes the zip code in the checkout.
-- It is also used to keep track of where a user lives.
CREATE TABLE IF NOT EXISTS `Cities`(
    `city_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `city` VARCHAR(18) NOT NULL,
    `zip_code` VARCHAR(4) NOT NULL, 

    PRIMARY KEY(`city_id`),
    KEY `zip_code_index` (`zip_code`)
);

-- The Addresses table includes 4 columns.
-- address_id is the primary key.
-- city_id is a foreign key from the Cities table.
-- This table is used to hold the address of a user.
CREATE TABLE IF NOT EXISTS `Addresses`(
    `address_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `city_id` INT UNSIGNED NOT NULL,
    `street_name` VARCHAR(34) NOT NULL,
    `house_number` VARCHAR(15) NOT NULL,

    PRIMARY KEY(`address_id`),
    CONSTRAINT `addresses_fk_1` FOREIGN KEY (`city_id`) REFERENCES `Cities` (`city_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- The users table has 7 columns, user_id is the primary key.
-- The email column has a unique key, to avoid duplicate emails.
-- address_id is a foreign key, from the Addresses table.
-- is_admin works as a boolean. 0 indicates its a normal user, 1 means its an admin.
-- is_admin is indexed. It can help performance when 1 of the 2 boolean values are much more common than the other.
CREATE TABLE IF NOT EXISTS `Users`(
    `user_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `address_id` INT UNSIGNED NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `password` VARCHAR(256) NOT NULL,
    `email` VARCHAR(256) NOT NULL,
    `created_at` DATETIME NOT NULL,
    `is_admin` TINYINT NOT NULL CHECK (is_admin BETWEEN 0 and 1),

    PRIMARY KEY(`user_id`),
    KEY `name_index` (`name`),
    UNIQUE `email_unique` (`email`),
    KEY `is_admin_index` (`is_admin`),
    KEY `password_index` (`password`),
    KEY `created_at_index` (`created_at`),
    CONSTRAINT users_fk_1 FOREIGN KEY (`address_id`) REFERENCES `Addresses` (`address_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- The Orders table keeps track of all orders made.
-- order_id is the primary key.
-- coupon_id is a foreign key, from the Coupons table. It is also nullable.
-- total_price is a float, because the price might include decimal points.
CREATE TABLE IF NOT EXISTS `Orders`(
    `order_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `address_id` INT UNSIGNED NOT NULL,
    `user_id` INT UNSIGNED NOT NULL,
    `coupon_id` INT UNSIGNED,
    `total_price` FLOAT UNSIGNED NOT NULL,
    `created_at` DATETIME NOT NULL,

    PRIMARY KEY(`order_id`),
    CONSTRAINT `orders_fk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `orders_fk_2` FOREIGN KEY (`coupon_id`) REFERENCES `Coupons` (`coupon_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `orders_fk_3` FOREIGN KEY (`address_id`) REFERENCES `Addresses` (`address_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- OrderItems is a table with 5 columns. order_items_id is the primary key.
-- book_id and order_id are foreign keys, from Books and Orders.
-- OrderItems keeps track of the products added to an order.
CREATE TABLE IF NOT EXISTS `OrderItems`(
    `order_items_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `book_id` INT UNSIGNED NOT NULL,
    `order_id` INT UNSIGNED NOT NULL,
    `price` FLOAT UNSIGNED NOT NULL,
    `quantity` SMALLINT UNSIGNED NOT NULL,

    PRIMARY KEY(`order_items_id`),
    CONSTRAINT `order_items_fk_1` FOREIGN KEY (`book_id`) REFERENCES `Books` (`book_id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `order_items_fk_2` FOREIGN KEY (`order_id`) REFERENCES `Orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- The bookImages holds information about which images should be shown for a book.
-- It also keeps track of which order the images should be shown.
-- book_image_id is the primary key and book_id is a foreign key from the Books table.
CREATE TABLE IF NOT EXISTS `BookImages`(
    `book_image_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `book_id` INT UNSIGNED NOT NULL,
    `display_order` TINYINT UNSIGNED NOT NULL,
    `file_path` VARCHAR(256) NOT NULL,

    PRIMARY KEY(`book_image_id`),
    CONSTRAINT `book_images_fk_1` FOREIGN KEY (`book_id`) REFERENCES `Books` (`book_id`) ON DELETE CASCADE
);

-- This table is responsible for keeping track of logs, regarding what happens within the database.
-- It has a primary key called bogreden_log_id.
-- log_type and created_at has been indexed, to quickly find a specific log.
CREATE TABLE IF NOT EXISTS `BogredenLog` (
    `bogreden_log_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `log_type` VARCHAR(30) NOT NULL,
    `created_at` DATETIME NOT NULL,
    `log_text` TEXT NOT NULL,

    PRIMARY KEY (`bogreden_log_id`),
    KEY `log_type_index` (`log_type`),
    KEY `created_at_index` (`created_at`)
);

































--  __  __   __  _  __ __   _____ ___ _  __  __ ___ ___   __  
-- |  \/__\ /__\| |/ /' _/ |_   _| _ \ |/ _]/ _] __| _ \/' _/ 
-- | -< \/ | \/ |   <`._`.   | | | v / | [/\ [/\ _|| v /`._`. 
-- |__/\__/ \__/|_|\_\___/   |_| |_|_\_|\__/\__/___|_|_\|___/ 

DELIMITER $$
CREATE TRIGGER book_log_inserts AFTER INSERT ON Books
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('Books', NOW(), CONCAT('New book inserted. ID:', NEW.book_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER book_log_update AFTER UPDATE ON Books
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('Books', NOW(), CONCAT('New book updated. ID:', OLD.book_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER book_log_delete AFTER DELETE ON Books
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('Books', NOW(), CONCAT('New book deleted. ID:', OLD.book_id));
END$$
DELIMITER ;

--    _____          __  .__                     __         .__                                   
--   /  _  \  __ ___/  |_|  |__   ___________  _/  |________|__| ____   ____   ___________  ______
--  /  /_\  \|  |  \   __\  |  \ /  _ \_  __ \ \   __\_  __ \  |/ ___\ / ___\_/ __ \_  __ \/  ___/
-- /    |    \  |  /|  | |   Y  (  <_> )  | \/  |  |  |  | \/  / /_/  > /_/  >  ___/|  | \/\___ \ 
-- \____|__  /____/ |__| |___|  /\____/|__|     |__|  |__|  |__\___  /\___  / \___  >__|  /____  >
--         \/                 \/                              /_____//_____/      \/           \/

DELIMITER $$
CREATE TRIGGER author_log_inserts AFTER INSERT ON Authors
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('Authors', NOW(), CONCAT('New Author inserted. ID:', NEW.author_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER author_log_update AFTER UPDATE ON authors
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('authors', NOW(), CONCAT('New author updated. ID:', OLD.author_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER author_log_delete AFTER DELETE ON authors
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('authors', NOW(), CONCAT('New author deleted. ID:', OLD.author_id));
END$$
DELIMITER ;

--    _____          __  .__                __________               __               __         .__                                   
--   /  _  \  __ ___/  |_|  |__   __________\______   \ ____   ____ |  | __  ______ _/  |________|__| ____   ____   ___________  ______
--  /  /_\  \|  |  \   __\  |  \ /  _ \_  __ \    |  _//  _ \ /  _ \|  |/ / /  ___/ \   __\_  __ \  |/ ___\ / ___\_/ __ \_  __ \/  ___/
-- /    |    \  |  /|  | |   Y  (  <_> )  | \/    |   (  <_> |  <_> )    <  \___ \   |  |  |  | \/  / /_/  > /_/  >  ___/|  | \/\___ \ 
-- \____|__  /____/ |__| |___|  /\____/|__|  |______  /\____/ \____/|__|_ \/____  >  |__|  |__|  |__\___  /\___  / \___  >__|  /____  >
--         \/                 \/                    \/                   \/     \/                 /_____//_____/      \/           \/ 

DELIMITER $$
CREATE TRIGGER author_books_log_inserts AFTER INSERT ON AuthorsBooks
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('AuthorsBooks', NOW(), CONCAT('New Author-book relation inserted. ID:', NEW.ab_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER author_books_log_update AFTER UPDATE ON AuthorsBooks
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('AuthorsBooks', NOW(), CONCAT('New Author-book relation updated. ID:', OLD.ab_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER author_books_log_delete AFTER DELETE ON AuthorsBooks
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('AuthorsBooks', NOW(), CONCAT('New Author-book relation deleted. ID:', OLD.ab_id));
END$$
DELIMITER ;

--  ____ ___                       __         .__                                   
-- |    |   \______ ___________  _/  |________|__| ____   ____   ___________  ______
-- |    |   /  ___// __ \_  __ \ \   __\_  __ \  |/ ___\ / ___\_/ __ \_  __ \/  ___/
-- |    |  /\___ \\  ___/|  | \/  |  |  |  | \/  / /_/  > /_/  >  ___/|  | \/\___ \ 
-- |______//____  >\___  >__|     |__|  |__|  |__\___  /\___  / \___  >__|  /____  >
--              \/     \/                       /_____//_____/      \/           \/ 

DELIMITER $$
CREATE TRIGGER user_log_inserts AFTER INSERT ON Users
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('Users', NOW(), CONCAT('New user inserted. ID:', NEW.user_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER user_log_update AFTER UPDATE ON Users
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('Users', NOW(), CONCAT('New user updated. ID:', OLD.user_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER user_log_delete AFTER DELETE ON Users
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('Users', NOW(), CONCAT('New user deleted. ID:', OLD.user_id));
END$$
DELIMITER ;

-- ________            .___                      __         .__                                   
-- \_____  \_______  __| _/___________  ______ _/  |________|__| ____   ____   ___________  ______
--  /   |   \_  __ \/ __ |/ __ \_  __ \/  ___/ \   __\_  __ \  |/ ___\ / ___\_/ __ \_  __ \/  ___/
-- /    |    \  | \/ /_/ \  ___/|  | \/\___ \   |  |  |  | \/  / /_/  > /_/  >  ___/|  | \/\___ \ 
-- \_______  /__|  \____ |\___  >__|  /____  >  |__|  |__|  |__\___  /\___  / \___  >__|  /____  >
--         \/           \/    \/           \/                 /_____//_____/      \/           \/ 

DELIMITER $$
CREATE TRIGGER order_log_inserts AFTER INSERT ON orders
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('orders', NOW(), CONCAT('New order inserted. ID:', NEW.order_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER order_log_update AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('orders', NOW(), CONCAT('New order updated. ID:', OLD.order_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER order_log_delete AFTER DELETE ON orders
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('orders', NOW(), CONCAT('New order deleted. ID:', OLD.order_id));
END$$
DELIMITER ;

-- ________            .___           .__  __                            __         .__                                   
-- \_____  \_______  __| _/___________|__|/  |_  ____   _____   ______ _/  |________|__| ____   ____   ___________  ______
--  /   |   \_  __ \/ __ |/ __ \_  __ \  \   __\/ __ \ /     \ /  ___/ \   __\_  __ \  |/ ___\ / ___\_/ __ \_  __ \/  ___/
-- /    |    \  | \/ /_/ \  ___/|  | \/  ||  | \  ___/|  Y Y  \\___ \   |  |  |  | \/  / /_/  > /_/  >  ___/|  | \/\___ \ 
-- \_______  /__|  \____ |\___  >__|  |__||__|  \___  >__|_|  /____  >  |__|  |__|  |__\___  /\___  / \___  >__|  /____  >
--         \/           \/    \/                    \/      \/     \/                 /_____//_____/      \/           \/ 

DELIMITER $$
CREATE TRIGGER order_items_inserts AFTER INSERT ON orderitems
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('orderitems', NOW(), CONCAT('New order items relation inserted. ID:', NEW.order_items_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER orderitem_items_update AFTER UPDATE ON orderitems
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('orderitems', NOW(), CONCAT('New order items relation updated. ID:', OLD.order_items_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER orderitem_items_delete AFTER DELETE ON orderitems
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('orderitems', NOW(), CONCAT('New order items relation deleted. ID:', OLD.order_items_id));
END$$
DELIMITER ;

-- _________                                              __         .__                                   
-- \_   ___ \  ____  __ ________   ____   ____   ______ _/  |________|__| ____   ____   ___________  ______
-- /    \  \/ /  _ \|  |  \____ \ /  _ \ /    \ /  ___/ \   __\_  __ \  |/ ___\ / ___\_/ __ \_  __ \/  ___/
-- \     \___(  <_> )  |  /  |_> >  <_> )   |  \\___ \   |  |  |  | \/  / /_/  > /_/  >  ___/|  | \/\___ \ 
--  \______  /\____/|____/|   __/ \____/|___|  /____  >  |__|  |__|  |__\___  /\___  / \___  >__|  /____  >
--         \/             |__|               \/     \/                 /_____//_____/      \/           \/ 

DELIMITER $$
CREATE TRIGGER coupons_inserts AFTER INSERT ON coupons
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('coupons', NOW(), CONCAT('New coupons inserted. ID:', NEW.coupon_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER coupons_update AFTER UPDATE ON coupons
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('coupons', NOW(), CONCAT('New coupons updated. ID:', OLD.coupon_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER coupons_delete AFTER DELETE ON coupons
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('coupons', NOW(), CONCAT('New coupons deleted. ID:', OLD.coupon_id));
END$$
DELIMITER ;

--    _____       .___  .___                                              __         .__                                   
--   /  _  \    __| _/__| _/______   ____   ______ ______ ____   ______ _/  |________|__| ____   ____   ___________  ______
--  /  /_\  \  / __ |/ __ |\_  __ \_/ __ \ /  ___//  ___// __ \ /  ___/ \   __\_  __ \  |/ ___\ / ___\_/ __ \_  __ \/  ___/
-- /    |    \/ /_/ / /_/ | |  | \/\  ___/ \___ \ \___ \\  ___/ \___ \   |  |  |  | \/  / /_/  > /_/  >  ___/|  | \/\___ \ 
-- \____|__  /\____ \____ | |__|    \___  >____  >____  >\___  >____  >  |__|  |__|  |__\___  /\___  / \___  >__|  /____  >
--         \/      \/    \/             \/     \/     \/     \/     \/                 /_____//_____/      \/           \/ 

DELIMITER $$
CREATE TRIGGER address_inserts AFTER INSERT ON addresses
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('addresses', NOW(), CONCAT('New address inserted. ID:', NEW.address_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER address_update AFTER UPDATE ON addresses
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('addresses', NOW(), CONCAT('New address updated. ID:', OLD.address_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER address_delete AFTER DELETE ON addresses
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('addresses', NOW(), CONCAT('New address deleted. ID:', OLD.address_id));
END$$
DELIMITER ;

-- _________ .__  __  .__                  __         .__                                   
-- \_   ___ \|__|/  |_|__| ____   ______ _/  |________|__| ____   ____   ___________  ______
-- /    \  \/|  \   __\  |/ __ \ /  ___/ \   __\_  __ \  |/ ___\ / ___\_/ __ \_  __ \/  ___/
-- \     \___|  ||  | |  \  ___/ \___ \   |  |  |  | \/  / /_/  > /_/  >  ___/|  | \/\___ \ 
--  \______  /__||__| |__|\___  >____  >  |__|  |__|  |__\___  /\___  / \___  >__|  /____  >
--         \/                 \/     \/                 /_____//_____/      \/           \/ 

DELIMITER $$
CREATE TRIGGER city_inserts AFTER INSERT ON cities
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('cities', NOW(), CONCAT('New city inserted. ID:', NEW.city_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER city_update AFTER UPDATE ON cities
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('cities', NOW(), CONCAT('New city updated. ID:', OLD.city_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER city_delete AFTER DELETE ON cities
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('cities', NOW(), CONCAT('New city deleted. ID:', OLD.city_id));
END$$
DELIMITER ;

-- __________               __   .__                                         __         .__                                   
-- \______   \ ____   ____ |  | _|__| _____ _____     ____   ____   ______ _/  |________|__| ____   ____   ___________  ______
--  |    |  _//  _ \ /  _ \|  |/ /  |/     \\__  \   / ___\_/ __ \ /  ___/ \   __\_  __ \  |/ ___\ / ___\_/ __ \_  __ \/  ___/
--  |    |   (  <_> |  <_> )    <|  |  Y Y  \/ __ \_/ /_/  >  ___/ \___ \   |  |  |  | \/  / /_/  > /_/  >  ___/|  | \/\___ \ 
--  |______  /\____/ \____/|__|_ \__|__|_|  (____  /\___  / \___  >____  >  |__|  |__|  |__\___  /\___  / \___  >__|  /____  >
--         \/                   \/        \/     \//_____/      \/     \/                 /_____//_____/      \/           \/ 

DELIMITER $$
CREATE TRIGGER book_image_inserts AFTER INSERT ON BookImages
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('BookImages', NOW(), CONCAT('New bookimage inserted. ID:', NEW.book_image_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER book_image_update AFTER UPDATE ON BookImages
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('BookImages', NOW(), CONCAT('New bookimage updated. ID:', OLD.book_image_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER book_image_delete AFTER DELETE ON BookImages
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('BookImages', NOW(), CONCAT('New bookimage deleted. ID:', OLD.book_image_id));
END$$
DELIMITER ;
































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


























-- Uses the database
USE `DavidsBookClub`;

-- This query creates dummy data for each of the tables inside of Tables.sql

INSERT INTO Coupons (code, discount_percentage, expiration_date) VALUES
('10OFF', 10, '2025-05-10 22:55:52'),
('20OFF', 25, '2027-12-31 23:59:59'),
('HALF', 50, '2031-10-13 12:00:00'),
('75OFF', 75, '2028-01-01 00:00:00'),
('GUNPOINT_DISCOUNT', 100, '2034-08-14 14:08:04');

INSERT INTO Books (release_date, stock, genre, category, price, name, isbn, language) VALUES
('2012-02-01', 6, 'Romance', 'Women', 59, 'The lover boyz', 1234567890, 'English'),
('2022-05-22', 8, 'Fiction', 'Teenagers', 29, 'No facts', 1234567891, 'English'),
('2024-03-04', 15, 'Sci-fi', 'Boys', 39, 'Star claws', 1234567892, 'English'),
('2021-11-14', 22, 'Fiction', 'Boys', 69, 'Doomsday', 1234567893, 'English'),
('2018-12-19', 5, 'Horror', 'Adults', 100, 'Zombies in spaceland', 1234567894, 'English');

INSERT INTO Authors (name) VALUES
('Michael Hansen'),
('Tom Stevns'),
('David Svarrer'),
('Yordan Yapster'),
('Mikkel Krøll');

INSERT INTO AuthorsBooks (author_id, book_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO Cities (city, zip_code) VALUES
('Slagelse', 4200),
('Amagerbro', 2300),
('Sorø', 4180),
('Hellerup', 2900),
('Albertslund', 2620);

INSERT INTO Addresses (city_id, street_name, house_number) VALUES
(1, 'Sorøvej', '1'),
(2, 'Store mølle vej', '2'),
(3, 'Slagelsevej', '3'),
(4, 'Forårsvej', '4'),
(5, 'Teglmosevej', '5');

INSERT INTO Users (address_id, name, password, email, created_at, is_admin) VALUES
(1, 'Shazil Shahid', 'hashedvalue', 'terrorist@techtonic.com', NOW(), 0),
(2, 'Marcus Lystrup', 'hashedvalue', 'Marcusse@gmail.com', NOW(), 0),
(3, 'Yordan Mitov', 'hashedvalue', 'linuxlover@gmail.com', NOW(), 0),
(4, 'Lucas Bangsborg', 'hashedvalue', 'LucasBangersborg@outlook.com', NOW(), 1),
(5, 'Magnus Lund', 'hashedvalue', 'magussy@hotmail.com', NOW(), 0);

INSERT INTO Orders (address_id, user_id, coupon_id, created_at, total_price) VALUES
(1, 1, 1, '2024-10-03 16:14:32', 90),
(2, 2, 2, '2027-01-21 07:25:27', 180),
(3, 3, 3, '2033-11-05 12:17:54', 270),
(4, 4, 4, '2034-06-06 16:25:31', 360),
(5, 5, 5, '2028-07-16 18:21:53', 450);

INSERT INTO OrderItems (book_id, order_id, price, quantity) VALUES
(1, 1, 59, 2),
(2, 1, 29, 1),
(2, 2, 29, 1),
(3, 3, 39, 1),
(4, 4, 69, 1),
(5, 5, 100, 1);

INSERT INTO BookImages (book_id, display_order, file_path) VALUES 
(1, 1, 'c:/davidsBookClub/images/1/1.jpg'),
(1, 2, 'c:/davidsBookClub/images/1/2.jpg'),
(2, 1, 'c:/davidsBookClub/images/2/1.jpg'),
(3, 1, 'c:/davidsBookClub/images/3/1.jpg'),
(4, 1, 'c:/davidsBookClub/images/4/1.jpg'),
(5, 1, 'c:/davidsBookClub/images/5/1.jpg');