USE `davidsbookclub`;

CREATE USER IF NOT EXISTS 'MrDavid'@'%' IDENTIFIED BY 'SuperStrongPassword!';
GRANT ALL PRIVILEGES ON `davidsbookclub`.* TO 'MrDavid'@'%';

CREATE USER IF NOT EXISTS 'BookClub'@'%' IDENTIFIED BY 'StrongPassword';
GRANT EXECUTE ON `davidsbookclub`.* TO 'BookClub'@'%';
