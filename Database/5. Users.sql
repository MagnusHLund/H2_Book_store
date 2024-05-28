CREATE USER 'MrDavid'@'%' IDENTIFIED BY 'SuperStrongPassword!';
GRANT ALL PRIVILEGES ON davidsbookclub.* TO 'MrDavid'@'%';

CREATE USER 'BookClub'@'%' IDENTIFIED BY 'StrongPassword';
GRANT EXECUTE ON davidsbookclub.* TO 'BookClub'@'%';
