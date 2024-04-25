-- This trigger decreases the book stock after an insert inside the orderItems table.
CREATE DEFINER=`BookClub`@`%` TRIGGER `decrease_stock` AFTER INSERT ON `OrderItems` FOR EACH ROW BEGIN
   UPDATE Books
   SET stock = stock - NEW.quantity
   WHERE book_id = NEW.book_id;
END