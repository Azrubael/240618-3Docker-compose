CREATE DATABASE mydb;
USE mydb;
CREATE TABLE mytable (id int AUTO_INCREMENT PRIMARY KEY, data text, datamodified timestamp DEFAULT NOW());
INSERT INTO mytable (data) VALUES ('testdata01');
INSERT INTO mytable (data) VALUES ('testdata02');
INSERT INTO mytable (data) VALUES ('testdata03');
SELECT * FROM `mytable`;