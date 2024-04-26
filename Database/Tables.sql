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
-- book_images_id is the primary key and book_id is a foreign key from the Books table.
CREATE TABLE IF NOT EXISTS `BookImages`(
    `book_images_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `book_id` INT UNSIGNED NOT NULL,
    `file_path` VARCHAR(256) NOT NULL,
    `display_order` TINYINT UNSIGNED NOT NULL,

    PRIMARY KEY(`book_images_id`),
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
)