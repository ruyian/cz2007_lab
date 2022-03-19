-- Create Tables
CREATE TABLE user
(
    user_id   int          NOT NULL IDENTITY (1,1) PRIMARY KEY,
    user_name varchar(256) NULL
);
CREATE TABLE product
(
    product_name nvarchar(256) NOT NULL PRIMARY KEY,
    category     varchar(256)  NOT NULL,
    maker        nvarchar(256) NOT NULL
);
CREATE TABLE employee
(
    employee_id   int           NOT NULL IDENTITY (1,1) PRIMARY KEY,
    employee_name nvarchar(256) NOT NULL,
    salary        float(24)     NOT NULL DEFAULT 0.0 CHECK (salary >= 0.0)
);

CREATE TABLE shop
(
    shop_name varchar(256) PRIMARY KEY,
);

CREATE TABLE order
(
    order_id                int           NOT NULL IDENTITY (1,1) PRIMARY KEY,
    total_shipping_cost     float(24)     NOT NULL DEFAULT 0.0 CHECK (total_shipping_cost >= 0.0),
    shipping_addr           nvarchar(256) NOT NULL,
    order_placing_timestamp datetime               DEFAULT getdate(),
    user_id                 int FOREIGN KEY REFERENCES user (user_id) ON DELETE CASCADE,
);

CREATE TABLE complaint
(
    complaint_id         int          NOT NULL IDENTITY (1,1) PRIMARY KEY,
    complain_description varchar(max) NOT NULL,
    file_timestamp       datetime     NOT NULL DEFAULT getdate(),
    resolved_timestamp   datetime     NULL,
    assigned_timestamp   datetime     NULL,
    complaint_status     varchar(16)           DEFAULT 'Pending'
        Check (complaint_status = 'Pending' OR
               complaint_status = 'Assigned' OR
               complaint_status = 'Resolved'),
    UserID               int          FOREIGN KEY REFERENCES user (user_id) ON DELETE SET NULL,
    eID                  int          FOREIGN KEY REFERENCES employee (employee_id) ON DELETE SET NULL,
    CHECK (file_timestamp <= assigned_timestamp),
    CHECK (assigned_timestamp <= resolved_timestamp)
);

CREATE TABLE complaint_on_shop
(
    complaint_id int FOREIGN KEY REFERENCES complaint (complaint_id) ON DELETE CASCADE,
    shop_name    varchar(256) FOREIGN KEY REFERENCES shop (shop_name) ON DELETE CASCADE ON UPDATE CASCADE
        PRIMARY KEY (complaint_id),
);

CREATE TABLE complaint_on_product
(
    complaint_id int FOREIGN KEY REFERENCES complaint (complaint_id) ON DELETE CASCADE,
    product_name nvarchar(256) FOREIGN KEY REFERENCES product (product_name) ON DELETE CASCADE ON UPDATE CASCADE,
    shop_name    varchar(256) FOREIGN KEY REFERENCES shop (shop_name) ON DELETE CASCADE ON UPDATE CASCADE,
    order_id     int FOREIGN KEY REFERENCES order (order_id) ON DELETE CASCADE,
    PRIMARY KEY (complaint_id),
);

CREATE TABLE product_in_shop
(
    product_name nvarchar(256) FOREIGN KEY REFERENCES product (product_name) ON DELETE CASCADE ON UPDATE CASCADE,
    shop_name    varchar(256) FOREIGN KEY REFERENCES shop (shop_name) ON DELETE CASCADE ON UPDATE CASCADE,
    quantity     int       NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    price        float(24) NOT NULL DEFAULT 0.0 CHECK (price >= 0.0),
    PRIMARY KEY (product_name, shop_name),
);

CREATE TABLE product_on_order
(
    product_name            nvarchar(500) FOREIGN KEY REFERENCES product (product_name) ON DELETE CASCADE ON UPDATE CASCADE,
    shop_name               varchar(100) FOREIGN KEY REFERENCES shop (shop_name) ON DELETE CASCADE ON UPDATE CASCADE,
    order_id                int FOREIGN KEY REFERENCES [order] (order_id) ON DELETE CASCADE,
    order_quantity          int         NOT NULL DEFAULT 0 CHECK (order_quantity > 0),
    dealing_price           float(24)   NOT NULL DEFAULT 0.0 CHECK (dealing_price >= 0.0),
    product_on_order_status varchar(50) NOT NULL DEFAULT 'being processed'
        Check (product_on_order_status = 'being processed' OR
               product_on_order_status = 'shipped' OR
               product_on_order_status = 'delivered' OR
               product_on_order_status = 'returned'),
    delivery_date           datetime             DEFAULT NULL,

    -- sanity check
    -- being processed / shipped items should not have a delivery date while the rest should have one
    CHECK ((product_on_order_status = 'delivered' AND delivery_date IS NOT NULL)
        OR (product_on_order_status = 'returned' AND delivery_date IS NOT NULL)
        OR (product_on_order_status = 'being processed' AND delivery_date IS NULL)
        OR (product_on_order_status = 'shipped' AND delivery_date IS NULL)),
    PRIMARY KEY (product_name, shop_name, order_id),
);



CREATE TABLE price_history
(
    product_name nvarchar(256) FOREIGN KEY REFERENCES product (product_name) ON DELETE CASCADE ON UPDATE CASCADE,
    shop_name    varchar(256) FOREIGN KEY REFERENCES shop (shop_name) ON DELETE CASCADE ON UPDATE CASCADE,
    start_date   datetime  NOT NULL DEFAULT getdate(),
    end_date     datetime  NULL,
    actual_price float(24) NOT NULL DEFAULT 0.0 CHECK (actual_price >= 0.0),
    PRIMARY KEY (product_name, shop_name, start_date),
    CHECK (start_date < end_date),
);

CREATE TABLE feedback
(
    product_name nvarchar(256) FOREIGN KEY REFERENCES product (product_name) ON DELETE CASCADE ON UPDATE CASCADE,
    shop_name    varchar(256) FOREIGN KEY REFERENCES shop (shop_name) ON DELETE CASCADE ON UPDATE CASCADE,
    order_id     int FOREIGN KEY REFERENCES order (order_id) ON DELETE CASCADE,
    rating       int          NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment      varchar(max) NULL,
    -- user_id      int          NOT NULL,
    -- should not be included because we have performed 3NF decomposition in lab 3
    -- mention in report!

    
    feedbackDate datetime DEFAULT getdate(),
    PRIMARY KEY (product_name, shop_name, order_id),
    --FOREIGN KEY (user_id) REFERENCES user (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
);