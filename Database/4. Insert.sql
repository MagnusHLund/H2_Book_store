
-- Uses the database
USE `davidsbookclub`;

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
(8, 1, 'c:/davidsBookClub/images/8/1.png');
(9, 1, 'c:/davidsBookClub/images/9/1.png');
(10, 1, 'c:/davidsBookClub/images/10/1.png');
(11, 1, 'c:/davidsBookClub/images/11/1.png');
(12, 1, 'c:/davidsBookClub/images/12/1.png');
(13, 1, 'c:/davidsBookClub/images/13/1.png');
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