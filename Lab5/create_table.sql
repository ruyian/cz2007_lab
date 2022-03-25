-- Create Tables
CREATE TABLE users
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
    shop_name nvarchar(256) NOT NULL PRIMARY KEY,
);

CREATE TABLE orders
(
    order_id                int           NOT NULL IDENTITY (1,1) PRIMARY KEY,
    total_shipping_cost     float(24)     NOT NULL DEFAULT 0.0 CHECK (total_shipping_cost >= 0.0),
    shipping_addr           nvarchar(256) NOT NULL,
    order_placing_timestamp datetime               DEFAULT getdate(),
    user_id                 int FOREIGN KEY REFERENCES users (user_id) ON DELETE CASCADE,
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
    user_id               int          FOREIGN KEY REFERENCES users (user_id) ON DELETE SET NULL,
    employee_id                  int          FOREIGN KEY REFERENCES employee (employee_id) ON DELETE SET NULL,
    CHECK (file_timestamp <= assigned_timestamp AND
           assigned_timestamp <= resolved_timestamp)
);

CREATE TABLE complaint_on_shop
(
    complaint_id int FOREIGN KEY REFERENCES complaint (complaint_id) ON DELETE CASCADE,
    shop_name    nvarchar(256) FOREIGN KEY REFERENCES shop (shop_name) ON DELETE CASCADE ON UPDATE CASCADE
        PRIMARY KEY (complaint_id),
);

CREATE TABLE complaint_on_product
(
    complaint_id int FOREIGN KEY REFERENCES complaint (complaint_id) ON DELETE CASCADE,
    product_name nvarchar(256) FOREIGN KEY REFERENCES product (product_name) ON DELETE CASCADE ON UPDATE CASCADE,
    shop_name    nvarchar(256) FOREIGN KEY REFERENCES shop (shop_name) ON DELETE CASCADE ON UPDATE CASCADE,
    order_id     int FOREIGN KEY REFERENCES orders (order_id) ON DELETE CASCADE,
    PRIMARY KEY (complaint_id),
);

CREATE TABLE product_in_shop
(
    product_name nvarchar(256) FOREIGN KEY REFERENCES product (product_name) ON DELETE CASCADE ON UPDATE CASCADE,
    shop_name    nvarchar(256) FOREIGN KEY REFERENCES shop (shop_name) ON DELETE CASCADE ON UPDATE CASCADE,
    quantity     int       NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    price_in_shop        float(24) NOT NULL DEFAULT 0.0 CHECK (price_in_shop >= 0.0),
    PRIMARY KEY (product_name, shop_name),
);

/* error: used to be 500 and 100 does not match with previous*/
CREATE TABLE product_on_order
(
    product_name            nvarchar(256) FOREIGN KEY REFERENCES product (product_name) ON DELETE CASCADE ON UPDATE CASCADE,
    shop_name               nvarchar(256) FOREIGN KEY REFERENCES shop (shop_name) ON DELETE CASCADE ON UPDATE CASCADE,
    order_id                int FOREIGN KEY REFERENCES [orders] (order_id) ON DELETE CASCADE,
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
    shop_name    nvarchar(256) FOREIGN KEY REFERENCES shop (shop_name) ON DELETE CASCADE ON UPDATE CASCADE,
    start_date   datetime  NOT NULL DEFAULT getdate(),
    end_date     datetime  NULL,
    actual_price float(24) NOT NULL DEFAULT 0.0 CHECK (actual_price >= 0.0),
    PRIMARY KEY (product_name, shop_name, start_date),
    CHECK (start_date < end_date),
);

CREATE TABLE feedback
(
    product_name nvarchar(256) FOREIGN KEY REFERENCES product (product_name) ON DELETE CASCADE ON UPDATE CASCADE,
    shop_name    nvarchar(256) FOREIGN KEY REFERENCES shop (shop_name) ON DELETE CASCADE ON UPDATE CASCADE,
    order_id     int FOREIGN KEY REFERENCES orders (order_id) ON DELETE CASCADE,
    rating       int          NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment      varchar(max) NULL,
    -- user_id      int          NOT NULL,
    -- should not be included because we have performed 3NF decomposition in lab 3
    -- mention in report!
    feedbackDate datetime DEFAULT getdate(),
    PRIMARY KEY (product_name, shop_name, order_id),
    --FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
);








--- TRIGGERS
--Table Triggers
GO --syntax to define a batch of statements

--Update DeliveryDateTime when DeliveryStatus changed.
--If DeliveryStatus changed to 'Delivered', then DeliveryDateTime=GETDATE()
--If DeliveryStatus changed to 'Pending', then DeliveryDateTime=NULL
--One trigger, one batch of statements
CREATE TRIGGER UpdateDelivery
    ON product_on_order
    AFTER UPDATE
    NOT FOR REPLICATION
    AS
BEGIN
    UPDATE product_on_order
        --DeliveryDateTime will not be updated unless DeliveryStatus changes from 'shipped' to 'delivered'
    SET delivery_date= CASE
        --If previous DeliveryStatus='shipped' and is changed to 'delivered', then DeliveryDateTime=GETDATE().
                          WHEN d.product_on_order_status = 'shipped' AND i.product_on_order_status = 'delivered'
                              THEN GETDATE()
        --DeliveryDateTime retains the old value
                          ELSE
                              d.delivery_date
        END
      --DeliveryStatus will not be updated unless if follows the sequence: 'being processed'->'shipped'->'delivered'->'returned'
      , product_on_order_status= CASE
        --If previous DeliveryStatus='being processed'. It can only be changed to 'shipped'.
                            WHEN d.product_on_order_status = 'being processed' AND i.product_on_order_status <> 'shipped'
                                THEN 'being processed'
        --If previous DeliveryStatus='shipped'. It can only be changed to 'delivered'.
                            WHEN d.product_on_order_status = 'shipped' AND i.product_on_order_status <> 'delivered'
                                THEN 'shipped'
        --If previous DeliveryStatus='delivered'. It can only be changed to 'returned'.
                            WHEN d.product_on_order_status = 'delivered' AND i.product_on_order_status <> 'returned'
                                THEN 'delivered' --DeliveryStatus retains updated value
                            WHEN d.product_on_order_status = 'returned'
                                THEN 'returned'

                            ELSE
                                i.product_on_order_status
        END
    FROM product_on_order o,
         inserted i,
         deleted d
         --Get all the records that have just been updated, and find the previous value (inserted gives the updated rows, and deleted gives the previous values for these rows)
    WHERE o.shop_name = i.shop_name
      AND o.product_name = i.product_name
      AND o.order_id = i.order_id
      AND o.shop_name = d.shop_name
      AND o.product_name = d.product_name
      AND o.order_id = d.order_id;
END
GO

GO
CREATE TRIGGER ComplainStatus
    ON complaint
    AFTER UPDATE
    NOT FOR REPLICATION
    AS
BEGIN
    UPDATE complaint
        SET complaint_status= CASE
                            WHEN d.complaint_status = 'Pending' AND i.complaint_status = 'Assigned' AND i.employee_id IS NULL
                                THEN 'Pending'

                            WHEN d.complaint_status= 'Pending' AND i.complaint_status = 'Assigned' AND
                                 i.employee_id  IS NOT NULL
                                THEN 'Assigned'

                            WHEN d.complaint_status = 'Assigned' AND i.complaint_status <> 'Resolved'
                                THEN 'Assigned'

                            WHEN d.complaint_status = 'Pending' AND i.complaint_status <> 'Assigned'
                                THEN 'Pending'
                            WHEN d.complaint_status = 'Resolved'
                                THEN 'Resolved'
                            ELSE
                                i.complaint_status
        END,
        resolved_timestamp= CASE
                            WHEN d.complaint_status = 'Assigned' AND i.complaint_status = 'Resolved'
                                THEN getdate()
                            ELSE
                                d.resolved_timestamp
            END
    FROM complaint o,
         inserted i,
         deleted d
    WHERE o.complaint_id = i.complaint_id
      AND o.complaint_id = d.complaint_id

END
GO
CREATE TRIGGER NoUserUpdate
    ON users
    AFTER UPDATE
    AS
    IF UPDATE(user_id)
        BEGIN
            ;THROW 51000, 'You cannot update the primary key user_id', 1;
        END
GO
CREATE TRIGGER NoEmployeeUpdate
    ON employee
    AFTER UPDATE
    AS
    IF UPDATE(employee_id)
        BEGIN
            ;THROW 51000, 'You cannot update the primary key employeemployee_id', 1;
        END
GO
CREATE TRIGGER NoOrderUpdate
    ON orders
    AFTER UPDATE
    AS
    IF UPDATE(order_id)
        BEGIN
            ;THROW 51000, 'You cannot update the primary key orderID', 1;
        END