


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
   VALUES ('orderitems', NOW(), CONCAT('New coupons inserted. ID:', NEW.coupon_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER coupons_update AFTER UPDATE ON coupons
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('orderitems', NOW(), CONCAT('New coupons updated. ID:', OLD.coupon_id));
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
   VALUES ('orderitems', NOW(), CONCAT('New address inserted. ID:', NEW.adress_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER address_update AFTER UPDATE ON addresses
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('orderitems', NOW(), CONCAT('New address updated. ID:', OLD.adress_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER address_delete AFTER DELETE ON addresses
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('address', NOW(), CONCAT('New address deleted. ID:', OLD.adress_id));
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
   VALUES ('orderitems', NOW(), CONCAT('New city inserted. ID:', NEW.city_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER city_update AFTER UPDATE ON cities
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('orderitems', NOW(), CONCAT('New city updated. ID:', OLD.city_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER city_delete AFTER DELETE ON cities
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('city', NOW(), CONCAT('New city deleted. ID:', OLD.city_id));
END$$
DELIMITER ;

-- __________               __   .__                                         __         .__                                   
-- \______   \ ____   ____ |  | _|__| _____ _____     ____   ____   ______ _/  |________|__| ____   ____   ___________  ______
--  |    |  _//  _ \ /  _ \|  |/ /  |/     \\__  \   / ___\_/ __ \ /  ___/ \   __\_  __ \  |/ ___\ / ___\_/ __ \_  __ \/  ___/
--  |    |   (  <_> |  <_> )    <|  |  Y Y  \/ __ \_/ /_/  >  ___/ \___ \   |  |  |  | \/  / /_/  > /_/  >  ___/|  | \/\___ \ 
--  |______  /\____/ \____/|__|_ \__|__|_|  (____  /\___  / \___  >____  >  |__|  |__|  |__\___  /\___  / \___  >__|  /____  >
--         \/                   \/        \/     \//_____/      \/     \/                 /_____//_____/      \/           \/ 

DELIMITER $$
CREATE TRIGGER book_image_inserts AFTER INSERT ON cities
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('orderitems', NOW(), CONCAT('New bookimage inserted. ID:', NEW.book_image_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER book_image_update AFTER UPDATE ON cities
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('orderitems', NOW(), CONCAT('New bookimage updated. ID:', OLD.book_image_id));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER book_image_delete AFTER DELETE ON cities
FOR EACH ROW
BEGIN
   INSERT INTO BogredenLog (Log_type, created_at, log_text)
   VALUES ('bookimage', NOW(), CONCAT('New bookimage deleted. ID:', OLD.book_image_id));
END$$
DELIMITER ;

-- This trigger decreases the book stock after an insert inside the orderItems table.
CREATE TRIGGER `decrease_stock` AFTER INSERT ON `OrderItems` FOR EACH ROW BEGIN
   UPDATE Books
   SET stock = stock - NEW.quantity
   WHERE book_id = NEW.book_id;