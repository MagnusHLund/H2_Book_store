-- This trigger decreases the book stock after an insert inside the orderItems table.
CREATE DEFINER=`BookClub`@`%` TRIGGER `decrease_stock` AFTER INSERT ON `OrderItems` FOR EACH ROW BEGIN
   UPDATE Books
   SET stock = stock - NEW.quantity
   WHERE book_id = NEW.book_id;
END

-- This Trigger updates the total price inside of orders, whenever an insert is performed in the OrderItems table.
CREATE DEFINER=`BookClub`@`%` TRIGGER `update_total_price` AFTER INSERT ON `OrderItems` FOR EACH ROW BEGIN
   DECLARE discount TINYINT;
   DECLARE total FLOAT;

   -- Get the discount of the coupon used in the order, if any
   SELECT discount_percentage INTO discount
   FROM Coupons
   JOIN Orders ON Coupons.coupon_id = Orders.coupon_id
   WHERE Orders.order_id = NEW.order_id;

   -- Calculate the total price of the new order item
   SET total = NEW.quantity * NEW.price;

   -- Apply the discount, if any
   IF discount IS NOT NULL THEN
      SET total = total * (1 - discount / 100);
   END IF;

   -- Update the total price of the order
   UPDATE Orders
   SET total_price = total_price + total
   WHERE order_id = NEW.order_id;
END;
