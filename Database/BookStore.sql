CREATE DATABASE IF NOT EXISTS 'BookStore';
USE 'BookStore';

CREATE TABLE IF NOT EXISTS 'Coupons' (
    'CouponID' INT(11) NOT NULL AUTO_INCREMENT,
    'Code' VARCHAR(30) NOT NULL,
    'Expires' DATETIME NOT NULL,
    PRIMARY KEY ('CouponID'),
    KEY 'Code' ('Code'),
)

CREATE TABLE IF NOT EXISTS 'Customers' (
    'CustomerID' INT(11) NOT NULL AUTO_INCREMENT,
    'AddressID' INT(11) NOT NULL,
    'Name' VARCHAR(50) NOT NULL,
    'Password' VARCHAR(256) NOT NULL,
    'Email' VARCHAR(256) NOT NULL,
    'CreatedAt' DATETIME NOT NULL,
    PRIMARY KEY ('CustomerID'),
    KEY 'AddressID' ('AddressID'),
    CONSTRAINT 'Customer_ibfk_1' FOREIGN KEY ('AddressID') REFERENCES 'Addresses' ('AddressID')
)

CREATE TABLE IF NOT EXISTS 'Cities' (
    'CityID' INT(11) NOT NULL AUTO_INCREMENT,
    'City' VARCHAR(30) NOT NULL,
    'ZipCode' INT(11) NOT NULL
    PRIMARY KEY ('CityID'),
    KEY 'ZipCode' ('ZipCode'),
)

CREATE TABLE IF NOT EXISTS 'Authors' (
    'AuthorID' INT(11) NOT NULL AUTO_INCREMENT,
    'City' VARCHAR(30) NOT NULL,
    'ZipCode' INT(11) NOT NULL
    PRIMARY KEY ('CityID'),
    KEY 'ZipCode' ('ZipCode'),
)

CREATE TABLE IF NOT EXISTS 'Books' (
    'BookID' INT(11) NOT NULL AUTO_INCREMENT,
    'ReleasedOn' DATETIME NOT NULL,
    'Stock' INT(11) NOT NULL,
    'Genre' VARCHAR(20) NOT NULL,
    'Category' VARCHAR(20) NOT NULL,
    'Price' INT(11) NOT NULl,
    'Name' INT(11) NOT NULL,
    'ISBN' INT(11) NOT NULL,
    'Language' VARCHAR(30) NOT NULL,
    PRIMARY KEY ('BookID'),
)

CREATE TABLE IF NOT EXISTS 'Addresses' (
    'AddressID' INT(11) NOT NULL AUTO_INCREMENT,
    'CityID' INT(11) NOT NULL,
    'StreetName' VARCHAR(30) NOT NULL,
    'HouseNumber' VARCHAR(15) NOT NULL,
    PRIMARY KEY ('CityID'),
    KEY 'ZipCode' ('ZipCode'),
    CONSTRAINT 'Addresses_ibfk_1' FOREIGN KEY ('CityID') REFERENCES 'Cities' ('CityID')
)

CREATE TABLE IF NOT EXISTS 'AuthorsBooks' (
    'AuthorsBooksID' INT(11) NOT NULL AUTO_INCREMENT,
    'CityID' INT(11) NOT NULL,
    'StreetName' VARCHAR(30) NOT NULL,
    'HouseNumber' VARCHAR(15) NOT NULL,
    PRIMARY KEY ('CityID'),
    KEY 'ZipCode' ('ZipCode'),
    CONSTRAINT 'Addresses_ibfk_1' FOREIGN KEY ('CityID') REFERENCES 'Cities' ('CityID')
)

CREATE TABLE IF NOT EXISTS 'Orders' (
    'OrderID' INT(11) NOT NULL AUTO_INCREMENT,
    'CustomerID' INT(11) NOT NULL,
    'BookID' INT(11) NOT NULL,
    'CouponID' INT(11) NOT NULL,
    'CreatedAt' DATETIME NOT NULL,
    'TotalPrice' DOUBLE NOT NULL,
    PRIMARY KEY ('OrderID'),
    KEY 'CustomerID' ('CustomerID'),
    KEY 'BookID' ('BookID'),
    KEY 'CouponID' ('CouponID'),
    CONSTRAINT 'Addresses_ibfk_1' FOREIGN KEY ('CityID') REFERENCES 'Cities' ('CityID')
)