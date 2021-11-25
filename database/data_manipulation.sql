--Data Manipulation Queries:

-- get all customers and their information for the Customers page
SELECT * FROM `Customers`;

-- get all vinyls and their information for the Vinyls page
SELECT * FROM `Vinyls`;

-- get all orders and their information for the Orders page
SELECT * FROM `Orders`;

-- get all coupons and their information for the Coupons page
SELECT * FROM `Coupons`;

-- get all OrderProducts and their information for the OrderProducts page
SELECT * FROM `OrderProducts`;

-- get all customerIDs and names for the drop down menu on the Orders page
SELECT `customerID`, `firstName`, `lastName` FROM `Customers`;

-- get all couponIDs for the drop down menu on the Orders page
SELECT `couponID` FROM `Coupons`;

-- add a new customer
INSERT INTO `Customers` (`firstName`, `lastName`, `streetAddress`, `city`, `state`, `zipCode`, `phoneNumber`, `email`)
    VALUES (:firstName, :lastName, :streetAddress, :city, :state, :zipCode, :phoneNumber, :email);

-- add a new vinyl
INSERT INTO `Vinyls` (`albumName`, `artistName`, `genre`, `price`, `quantityAvailable`)
    VALUES (:albumName, :artistName, :genre, :price, :quantityAvailable);

-- add a new coupon
INSERT INTO `Coupons` VALUES (:couponID, :percentDiscount, :expirationDate);

-- add a new order
INSERT INTO `Orders` (`orderDate`,`customerID`, `couponID`, `orderStatus`)
    VALUES (:orderDate, :customerID, :couponID, :orderStatus);

-- add a new OrderProduct
INSERT IGNORE INTO `OrderProducts` VALUES (:orderID, :productID, :quantity);

-- filter orders by user's input
SELECT * FROM `Orders` WHERE `customerID` = :customerID_input;

-- clear the filter of orders
SELECT * FROM `Orders`;

-- delete an order
DELETE FROM `Orders` WHERE `orderID` = :orderID_input;

-- update an order's orderStatus and couponID
UPDATE `Orders` 
SET `orderStatus` = :orderStatus_input, `couponID` = :couponID_input
WHERE `orderID` = :orderID_input;

-- delete an OrderProduct
DELETE FROM `OrderProdcuts` WHERE `orderID` = :orderID_input AND `productID` = :productID_input;
