CREATE DATABASE belajar_mysql_notification;

USE belajar_mysql_notification;

SHOW TABLES;

# User

CREATE TABLE user
(
    id   VARCHAR(100) NOT NULL,
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
) ENGINE = InnoDB;

SHOW TABLES;

INSERT INTO user(id, name)
VALUES ('eko', 'Eko Kurniawan');
INSERT INTO user(id, name)
VALUES ('khannedy', 'Eko Khannedy');

SELECT *
FROM user;

# Notification

CREATE TABLE notification
(
    id        INT          NOT NULL AUTO_INCREMENT,
    title     VARCHAR(255) NOT NULL,
    detail    TEXT         NOT NULL,
    create_at TIMESTAMP    NOT NULL,
    user_id   VARCHAR(100),
    PRIMARY KEY (id)
) ENGINE = InnoDB;

SHOW TABLES;

ALTER TABLE notification
    ADD CONSTRAINT fk_notification_user
        FOREIGN KEY (user_id) REFERENCES user (id);

DESC notification;

INSERT INTO notification(title, detail, create_at, user_id)
VALUES ('Contoh Pesanan', 'Detail Pesanan', CURRENT_TIMESTAMP(), 'eko');
INSERT INTO notification(title, detail, create_at, user_id)
VALUES ('Contoh Promo', 'Detail Promo', CURRENT_TIMESTAMP(), null);
INSERT INTO notification(title, detail, create_at, user_id)
VALUES ('Contoh Pembayaran', 'Detail Pembayaran', CURRENT_TIMESTAMP(), 'khannedy');

SELECT *
FROM notification;

SELECT *
FROM notification
WHERE (user_id = 'eko' OR user_id IS NULL)
ORDER BY create_at DESC;

SELECT *
FROM notification
WHERE (user_id = 'khannedy' OR user_id IS NULL)
ORDER BY create_at DESC;

# Category

CREATE TABLE category
(
    id   VARCHAR(100) NOT NULL,
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
) ENGINE = InnoDB;

SHOW TABLES;

ALTER TABLE notification
    ADD COLUMN category_id VARCHAR(100);

DESCRIBE notification;

ALTER TABLE notification
    ADD CONSTRAINT fk_notification_category
        FOREIGN KEY (category_id) REFERENCES category (id);

DESC notification;

SELECT *
FROM notification;

INSERT INTO category(id, name)
VALUES ('INFO', 'Info');
INSERT INTO category(id, name)
VALUES ('PROMO', 'Promo');

SELECT *
FROM category;

UPDATE notification
SET category_id = 'INFO'
WHERE id = 1;

UPDATE notification
SET category_id = 'PROMO'
WHERE id = 2;

UPDATE notification
SET category_id = 'INFO'
WHERE id = 3;

SELECT *
FROM notification;

SELECT *
FROM notification
WHERE (user_id = 'eko' OR user_id IS NULL)
ORDER BY create_at DESC;

SELECT *
FROM notification n
         JOIN category c ON (n.category_id = c.id)
WHERE (n.user_id = 'eko' OR n.user_id IS NULL)
ORDER BY n.create_at DESC;

SELECT *
FROM notification n
         JOIN category c ON (n.category_id = c.id)
WHERE (n.user_id = 'khannedy' OR n.user_id IS NULL)
ORDER BY n.create_at DESC;

SELECT *
FROM notification n
         JOIN category c ON (n.category_id = c.id)
WHERE (n.user_id = 'khannedy' OR n.user_id IS NULL)
  AND c.id = 'INFO'
ORDER BY n.create_at DESC;

# Notification Read

CREATE TABLE notification_read
(
    id              INT          NOT NULL AUTO_INCREMENT,
    is_read         BOOLEAN      NOT NULL,
    notification_id INT          NOT NULL,
    user_id         VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
) ENGINE = InnoDB;

SHOW TABLES;

ALTER TABLE notification_read
    ADD CONSTRAINT fk_notification_read_notification
        FOREIGN KEY (notification_id) REFERENCES notification (id);

ALTER TABLE notification_read
    ADD CONSTRAINT fk_notification_read_user
        FOREIGN KEY (user_id) REFERENCES user (id);

DESC notification_read;

SELECT *
FROM notification;

INSERT INTO notification_read(is_read, notification_id, user_id)
VALUES (true, 2, 'eko');
INSERT INTO notification_read(is_read, notification_id, user_id)
VALUES (true, 2, 'khannedy');

SELECT *
FROM notification_read;

SELECT *
FROM notification;

SELECT *
FROM notification n
         JOIN category c ON (n.category_id = c.id)
         LEFT JOIN notification_read nr ON (nr.notification_id = n.id)
WHERE (n.user_id = 'eko' OR n.user_id IS NULL)
  AND (nr.user_id = 'eko' OR nr.user_id IS NULL)
ORDER BY n.create_at DESC;

INSERT INTO notification(title, detail, category_id, user_id, create_at)
VALUES ('Contoh Pesanan Lagi', 'Detail Pesanan lagi', 'INFO', 'eko', CURRENT_TIMESTAMP());
INSERT INTO notification(title, detail, category_id, user_id, create_at)
VALUES ('Contoh Promo Lagi', 'Detail Promo lagi', 'PROMO', null, CURRENT_TIMESTAMP());

# Counter

SELECT COUNT(*)
FROM notification n
         JOIN category c ON (n.category_id = c.id)
         LEFT JOIN notification_read nr ON (nr.notification_id = n.id)
WHERE (n.user_id = 'eko' OR n.user_id IS NULL)
  AND (nr.user_id IS NULL)
ORDER BY n.create_at DESC;

SELECT * FROM notification;

INSERT INTO notification_read(is_read, notification_id, user_id)
VALUES (true, 4, 'eko');
INSERT INTO notification_read(is_read, notification_id, user_id)
VALUES (true, 5, 'eko');
INSERT INTO notification_read(is_read, notification_id, user_id)
VALUES (true, 1, 'eko');