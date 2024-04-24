-- For the Authors table:

INSERT INTO Authors (Name) VALUES
('Author 1'),
('Author 2'),
('Author 3');

-- For the Books table:

INSERT INTO Books (ReleasedDate, Stock, Genre, Category, Price, Name, ISBN, Language) VALUES
(2020, 100, 'Fiction', 'Novel', 20, 'Book 1', 'ISBN1234567890', 'English'),
(2019, 50, 'Fantasy', 'Novel', 25, 'Book 2', 'ISBN0987654321', 'English'),
(2021, 80, 'Mystery', 'Thriller', 18, 'Book 3', 'ISBN5432167890', 'English');

-- For the AuthorBooks table (assuming each book has one author):

INSERT INTO AuthorBooks (AuthorID, BookID) VALUES
(1, 1),
(2, 2),
(3, 3);

-- For the Coupons table:

INSERT INTO Coupons (Code, DiscountPercent, Expires) VALUES
('CODE123', 10, '2024-12-31'),
('SALE2024', 15, '2024-06-30'),
('DISCOUNT50', 20, '2024-07-31');

-- For the Cities table:

INSERT INTO Cities (City, ZipCode) VALUES
('New York', 10001),
('Los Angeles', 90001),
('Chicago', 60601);

-- For the Addresses table:

INSERT INTO Addresses (CityID, StreetName, HouseNumber) VALUES
(1, 'Broadway', '123'),
(2, 'Hollywood Blvd', '456'),
(3, 'Michigan Ave', '789');

-- For the Customers table:

INSERT INTO Customers (AddressID, Name, Password, Email) VALUES
(1, 'John Doe', 'password123', 'john@example.com'),
(2, 'Jane Smith', 'pass456', 'jane@example.com'),
(3, 'Alice Johnson', 'abc123', 'alice@example.com');

-- For the Orders table:

INSERT INTO Orders (CustomerID, CouponID, TotalPrice) VALUES
(1, 1, 150.50),
(2, NULL, 75.20),
(3, 3, 200.00);

-- For the Orderitems table:

INSERT INTO Orderitems (BookID, OrderID, Price, Quantity) VALUES
(1, 1, 20.50, 5),
(2, 1, 25.00, 2),
(3, 3, 18.00, 10);