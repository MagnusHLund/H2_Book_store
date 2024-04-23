-- Inserting dummy data into the Authors table
INSERT INTO Authors (Name, Published) VALUES
('Manike 1', '2022-01-01'),
('Manike½ 2', '2021-12-15'),
('Manike1½ 3', '2020-11-20');

-- Inserting dummy data into the Books table
INSERT INTO Books (ReleasedOn, Stock, Genre, Category, Price, Name, ISBN, Language) VALUES
(2022, 100, 'Fiction', 'Novel', 20, 'Book 1', 1234567890, 'English'),
(2021, 50, 'Non-Fiction', 'Biography', 25, 'Book 2', 9876543210, 'English'),
(2020, 75, 'Mystery', 'Thriller', 18, 'Book 3', 5678901234, 'English');

-- Inserting dummy data into the BooksAuthorID table
INSERT INTO BooksAuthorID (AuthorID, BookID) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserting dummy data into the Coupons table
INSERT INTO Coupons (Code, Expires) VALUES
('SAVE10', '2024-06-30'),
('FREESHIP', '2024-05-31');

-- Inserting dummy data into the Cities table
INSERT INTO Cities (City, ZipCode) VALUES
('New York', 10001),
('Los Angeles', 90001),
('Chicago', 60601);

-- Inserting dummy data into the Addresses table
INSERT INTO Addresses (CityID, StreetName, HouseNumber) VALUES
(1, 'Broadway', '123'),
(2, 'Hollywood Blvd', '456'),
(3, 'Michigan Ave', '789');

-- Inserting dummy data into the Customers table
INSERT INTO Customers (AddressID, Name, Password, Email, CreatedAt) VALUES
(1, 'John Doe', 'password123', 'john@example.com', '2024-04-23 12:00:00'),
(2, 'Jane Smith', 'qwerty456', 'jane@example.com', '2024-04-23 13:00:00');

-- Inserting dummy data into the Orders table
INSERT INTO Orders (CustomerID, CouponID, Created, TotalPrice) VALUES
(1, NULL, '2024-04-23 14:00:00', 20),
(2, 1, '2024-04-23 15:00:00', 25);

-- Inserting dummy data into the Orderitems table
INSERT INTO Orderitems (BookID, OrderID, Price, Quantity) VALUES
(1, 1, 20, 1),
(2, 2, 25, 1);
