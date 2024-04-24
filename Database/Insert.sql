
-- Uses the database
USE `DavidsBookClub`;

-- This query creates dummy data for each of the tables inside of Tables.sql

INSERT INTO Coupons (code, discount_percentage, expiration_date) VALUES
('10OFF', 10, '2025-05-10 22:55:52'),
('20OFF', 25, '2027-12-31 23:59:59'),
('HALF', 50, '2031-10-13 12:00:00'),
('75OFF', 75, '2028-01-01 00:00:00'),
('GUNPOINT_DISCOUNT', 100, '2034-08-14 14:08:04');

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


INSERT INTO Authors (name) VALUES
('Michael Hansen'),
('Tom Stevns'),
('David Svarrer'),
('Yordan Yapster'),
('Mikkel Krøll');

INSERT INTO Books (release_date, stock, genre, category, price, name, isbn, language) VALUES
('2012-02-01', 6, 'Romance', 'Women', 59, 'The lover boyz', 1234567890, 'English'),
('2022-05-22', 8, 'Fiction', 'Teenagers', 29, 'No facts', 1234567891, 'English'),
('2024-03-04', 15, 'Sci-fi', 'Boys', 39, 'Star claws', 1234567892, 'English'),
('2021-11-14', 22, 'Fiction', 'Boys', 69, 'Doomsday', 1234567893, 'English'),
('2018-12-19', 5, 'Horror', 'Adults', 100, 'Zombies in spaceland', 1234567894, 'English');

INSERT INTO AuthorsBooks (author_id, book_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO Orders (user_id, coupon_id, created_at, total_price) VALUES
(1, 1, '2024-10-03 16:14:32', 90),
(2, 2, '2027-01-21 07:25:27', 180),
(3, 3, '2033-11-05 12:17:54', 270),
(4, 4, '2034-06-06 16:25:31', 360),
(5, 5, '2028-07-16 18:21:53', 450);

INSERT INTO OrderItems (book_id, order_id, price, quantity) VALUES
(1, 1, 59, 2),
(2, 1, 29, 1),
(2, 2, 29, 1),
(3, 3, 39, 1),
(4, 4, 69, 1),
(5, 5, 100, 1);
