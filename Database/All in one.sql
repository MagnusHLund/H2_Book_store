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
    `display` TINYINT(1) NOT NULL CHECK (display BETWEEN 0 AND 1),

    PRIMARY KEY (`book_id`),
    KEY `name_index` (`name`),
    KEY `isbn_index` (`isbn`),
    KEY `genre_index` (`genre`),
    KEY `category_index` (`category`),
    KEY `language_index` (`language`),
    KEY `display` (`display`)
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
    `address_id` INT UNSIGNED,
    `name` VARCHAR(50) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `phone_number` VARCHAR(11) NOT NULL,
    `password` VARCHAR(255),
    `salt` VARCHAR(60),
    `created_at` DATETIME NOT NULL,
    `role` VARCHAR(8) NOT NULL,

    PRIMARY KEY(`user_id`),
    UNIQUE `email_unique` (`email`),
    UNIQUE `phone_number_unique` (`phone_number`),
    KEY `name_index` (`name`),
    KEY `role_index` (`role`),
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
	CONSTRAINT `orders_fk_2` FOREIGN KEY (`coupon_id`) REFERENCES `Coupons` (`coupon_id`) ON DELETE SET NULL ON UPDATE CASCADE,
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
    -- Check if the role is 'User'
    IF userRole <> 'User' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Access denied: Only users can view their own order details';
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
    END IF;
END //

DELIMITER ;

-- ------------------------------------------------------this procedure will return cityname when we tell it the zipcode

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
    IN input_phone_number VARCHAR(11) 
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
    IN input_phone_number VARCHAR(11),
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

-- ----------------------------------------------------------------------------this procedure will return user biling info

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
    DECLARE v_phone_number VARCHAR(11);

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
    IN userPhoneNumber VARCHAR(11),
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
    END IF;
END //

DELIMITER ;

-- ----------------------------------------------------------------------------this procedure will log user in

DROP PROCEDURE IF EXISTS UserLogin;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS UserLogin(
    IN userEmail VARCHAR(255),
    IN userPassword VARCHAR(255)
)
BEGIN
    DECLARE hashedPassword VARCHAR(255);
    DECLARE isValid BOOLEAN DEFAULT FALSE;

    -- Retrieve hashed password for the given email
    SELECT password INTO hashedPassword
    FROM Users
    WHERE email = userEmail;

    -- Check if user exists and password matches
    IF hashedPassword IS NOT NULL AND hashedPassword = userPassword THEN
        SET isValid = TRUE;
    END IF;

    -- Return the isValid flag as a SELECT result
    SELECT isValid AS is_valid_login;
END //

DELIMITER ;


























-- Uses the database
USE `DavidsBookClub`;

-- This query creates dummy data for each of the tables inside of Tables.sql

INSERT INTO Coupons (code, discount_percentage, expiration_date) VALUES
('10OFF', 10, '2025-05-10 22:55:52'),
('25OFF', 25, '2027-12-31 23:59:59'),
('HALF', 50, '2031-10-13 12:00:00'),
('75OFF', 75, '2028-01-01 00:00:00'),
('GUNPOINT_DISCOUNT', 100, '2034-08-14 14:08:04');

INSERT INTO Books (release_date, stock, genre, category, price, name, isbn, language, display) VALUES
('2012-02-01', 6, 'Romance', 'Women', 59, 'The lover boyz', 1234567890, 'English', 1),
('2022-05-22', 8, 'Fiction', 'Teenagers', 29, 'No facts', 1234567891, 'English', 1),
('2024-03-04', 15, 'Sci-fi', 'Boys', 39, 'Star claws', 1234567892, 'English', 1),
('2021-11-14', 22, 'Fiction', 'Boys', 69, 'Doomsday', 1234567893, 'English', 1),
('2018-12-19', 5, 'Horror', 'Adults', 100, 'Zombies in spaceland', 1234567894, 'English', 1),
('2020-11-05', 9, 'History', 'PBL lovers', 99, 'The book of david', 8392754021, 'Danish', 1),
('2024-10-03', 10, 'History', 'Adults', 1000, 'Rise of Kroells bank', 7483949532, 'English', 1),
('2013-12-05', 1, 'Self-help', 'Teenagers', 50, 'How to live with a small penis', 4832914563, 'English', 1),
('2010-04-02', 2, 'Self-help', 'Boys', 50, 'How to live with a HUGE penis', 7493853124, 'English', 1),
('2015-04-07', 5, 'Drama', 'Girls', 0, 'Britney Spears - Min egen stemme', 1235398756, 'Danish', 1),
('2017-06-02', 2, 'Self-help', 'Adults', 139, 'Usårlig', 8573657365, 'Danish', 1),
('2022-11-21', 7, 'Novel', 'Adults', 110, 'Showman', 8492754395, 'English', 1),
('1950-05-03', 4, 'History', 'Grandparents', 300, 'Hamlet - Prince of Denmark', 1853920544, 'English', 1),
('2021-05-18', 10, 'Science Fiction', 'Novel', 14.99, 'Project Hail Mary', '9780593135204', 'English', 'Paperback'),
('2020-10-06', 15, 'Fantasy', 'Novel', 16.99, 'The Invisible Life of Addie LaRue', '9780765387561', 'English', 'Hardcover'),
('2018-04-24', 12, 'Biography', 'Non-Fiction', 18.00, 'Educated: A Memoir', '9780399590504', 'English', 'Paperback'),
('2019-11-19', 20, 'Historical Fiction', 'Novel', 12.99, 'The Nightingale', '9781250080400', 'English', 'Paperback'),
('2015-10-06', 5, 'Mystery', 'Novel', 9.99, 'The Girl on the Train', '9781594634024', 'English', 'Paperback'),
('2003-04-01', 25, 'Fantasy', 'Novel', 8.99, 'Harry Potter and the Order of the Phoenix', '9780439358071', 'English', 'Paperback'),
('2018-07-31', 7, 'Self-Help', 'Non-Fiction', 15.99, 'Atomic Habits', '9780735211292', 'English', 'Hardcover'),
('2017-02-21', 14, 'Romance', 'Novel', 11.99, 'The Hating Game', '9780062439598', 'English', 'Paperback'),
('2020-03-03', 8, 'Thriller', 'Novel', 13.99, 'The Silent Patient', '9781250301697', 'English', 'Paperback'),
('2016-06-28', 18, 'Fantasy', 'Novel', 13.99, 'A Court of Mist and Fury', '9781619635197', 'English', 'Paperback'),
('2011-08-30', 30, 'Science Fiction', 'Novel', 9.99, 'Ready Player One', '9780307887443', 'English', 'Paperback'),
('2005-03-01', 22, 'Fantasy', 'Novel', 8.99, 'The Name of the Wind', '9780756404741', 'English', 'Paperback'),
('2021-02-16', 16, 'Historical Fiction', 'Novel', 15.99, 'The Four Winds', '9781250178602', 'English', 'Hardcover'),
('2019-05-14', 9, 'Biography', 'Non-Fiction', 16.99, 'Becoming', '9781524763138', 'English', 'Paperback'),
('2014-06-03', 13, 'Mystery', 'Novel', 10.99, 'The Silkworm', '9780316206877', 'English', 'Paperback'),
('2012-08-28', 11, 'Fantasy', 'Novel', 9.99, 'The Hobbit', '9780547928227', 'English', 'Paperback'),
('2009-09-01', 6, 'Science Fiction', 'Novel', 8.99, 'The Hunger Games', '9780439023528', 'English', 'Paperback');

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
(5, 5),
(1, 6),
(2, 7),
(3, 8),
(4, 9),
(5, 10),
(1, 11),
(2, 12),
(3, 13),
(4, 14),
(5, 15),
(1, 16),
(2, 17),
(3, 18),
(4, 19),
(5, 20),
(1, 21),
(2, 22),
(3, 23),
(4, 24),
(5, 25),
(1, 26),
(2, 27),
(3, 28),
(4, 29),
(5, 30);

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

INSERT INTO Users (address_id, name, password, salt, email, phone_number, created_at, role) VALUES
(null, 'Shazil Shahid', 'hashedvalue', 'saltyValue', 'terrorist@techtonic.com', "12312312", NOW(), "guest"),
(2, 'Marcus Lystrup', 'hashedvalue', 'saltyValue', 'Marcusse@gmail.com', "87654321", NOW(), "customer"),
(3, 'Yordan Mitov', 'hashedvalue', 'saltyValue', 'linuxlover@gmail.com', "12341234", NOW(), "customer"),
(4, 'David Svarre', 'hashedvalue', 'saltyValue', 'MrDavid@outlook.com', "12345678", NOW(), "admin"),
(5, 'Magnus Lund', 'hashedvalue', 'saltyValue', 'magussy@hotmail.com', "43214321", NOW(), "customer");

INSERT INTO Orders (address_id, user_id, coupon_id, created_at, total_price) VALUES
(1, 1, 1, '2024-10-03 16:14:32', 132.3),
(2, 2, 2, '2027-01-21 07:25:27', 21.75),
(3, 3, 3, '2033-11-05 12:17:54', 19.5),
(4, 4, 4, '2034-06-06 16:25:31', 17.25),
(5, 5, 5, '2028-07-16 18:21:53', 0);

INSERT INTO OrderItems (book_id, order_id, price, quantity) VALUES
(1, 1, 59, 2),
(2, 1, 29, 1),
(2, 2, 29, 1),
(3, 3, 39, 1),
(4, 4, 69, 1),
(5, 5, 100, 1);

INSERT INTO BookImages (book_id, display_order, file_path) VALUES 
(1, 1, 'c:/davidsBookClub/images/1/1.png'),
(2, 1, 'c:/davidsBookClub/images/2/1.png'),
(3, 1, 'c:/davidsBookClub/images/3/1.png'),
(4, 1, 'c:/davidsBookClub/images/4/1.png'),
(5, 1, 'c:/davidsBookClub/images/5/1.png'),
(6, 1, 'c:/davidsBookClub/images/6/1.png'),
(7, 1, 'c:/davidsBookClub/images/7/1.png'),
(8, 1, 'c:/davidsBookClub/images/8/1.png'),
(9, 1, 'c:/davidsBookClub/images/9/1.png'),
(10, 1, 'c:/davidsBookClub/images/10/1.png'),
(11, 1, 'c:/davidsBookClub/images/11/1.png'),
(12, 1, 'c:/davidsBookClub/images/12/1.png'),
(13, 1, 'c:/davidsBookClub/images/13/1.png'),
(14, 1, 'c:/davidsBookClub/images/14/1.jpg'),
(15, 1, 'c:/davidsBookClub/images/15/1.jpg'),
(16, 1, 'c:/davidsBookClub/images/16/1.jpg'),
(17, 1, 'c:/davidsBookClub/images/17/1.jpg'),
(18, 1, 'c:/davidsBookClub/images/18/1.jpg'),
(19, 1, 'c:/davidsBookClub/images/19/1.jpg'),
(20, 1, 'c:/davidsBookClub/images/20/1.jpg'),
(21, 1, 'c:/davidsBookClub/images/21/1.jpg'),
(22, 1, 'c:/davidsBookClub/images/22/1.jpg'),
(23, 1, 'c:/davidsBookClub/images/23/1.jpg'),
(24, 1, 'c:/davidsBookClub/images/24/1.jpg'),
(25, 1, 'c:/davidsBookClub/images/25/1.jpg'),
(26, 1, 'c:/davidsBookClub/images/26/1.jpg'),
(27, 1, 'c:/davidsBookClub/images/27/1.jpg'),
(28, 1, 'c:/davidsBookClub/images/28/1.jpg'),
(29, 1, 'c:/davidsBookClub/images/29/1.jpg'),
(30, 1, 'c:/davidsBookClub/images/30/1.jpg');












LOAD DATA INFILE 'C:/bulk.csv'
INTO TABLE Cities 
FIELDS TERMINATED  BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(zip_code, city);













CREATE USER IF NOT EXISTS 'MrDavid'@'%' IDENTIFIED BY 'SuperStrongPassword!';
GRANT ALL PRIVILEGES ON `davidsbookclub`.* TO 'MrDavid'@'%';

CREATE USER IF NOT EXISTS 'BookClub'@'%' IDENTIFIED BY 'StrongPassword';
GRANT EXECUTE ON `davidsbookclub`.* TO 'BookClub'@'%';
