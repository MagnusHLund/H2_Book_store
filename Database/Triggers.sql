


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
CREATE TRIGGER author_books_log_inserts AFTER INSERT ON AuthorBooks
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('AuthorBooks', NOW(), CONCAT('New Author-book relation inserted. ID:', NEW.ab_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER author_books_log_update AFTER UPDATE ON AuthorBooks
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('AuthorBooks', NOW(), CONCAT('New Author-book relation updated. ID:', OLD.ab_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER author_books_log_delete AFTER DELETE ON AuthorBooks
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('AuthorBooks', NOW(), CONCAT('New Author-book relation deleted. ID:', OLD.ab_id));
END$$
DELIMITER ;











-- This trigger decreases the book stock after an insert inside the orderItems table.
CREATE TRIGGER `decrease_stock` AFTER INSERT ON `OrderItems` FOR EACH ROW BEGIN
   UPDATE Books
   SET stock = stock - NEW.quantity
   WHERE book_id = NEW.book_id;
END

-- This Trigger updates the total price inside of orders, whenever an insert is performed in the OrderItems table.
CREATE TRIGGER `update_total_price` AFTER INSERT ON `OrderItems` FOR EACH ROW BEGIN
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
