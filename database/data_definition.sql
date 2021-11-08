--Data Definition Queries and INSERT Queries:

--
-- Table structure for table `Customers`
--

DROP TABLE IF EXISTS `Orders`, `Customers`, `Vinyls`, `Coupons`, `OrderProducts`;

CREATE TABLE `Customers` (
	`customerID` int auto_increment not null,
    `firstName` varchar(255) not null,
    `lastName` varchar(255) not null,
    `streetAddress` varchar(255) not null,
    `city` varchar(255) not null,
    `state` varchar(2) not null,  -- Two letter abbreviation for states
    `zipCode` varchar(255) not null,
    `phoneNumber` varchar(255),
    `email` varchar(255) not null,
    primary key (`customerID`)    
) ENGINE=InnoDB;
--
-- Dumping data for table `Customers`
--

LOCK TABLES `Customers` WRITE;

INSERT INTO `Customers` (`firstName`, `lastName`, `streetAddress`, `city`, `state`, `zipCode`, `phoneNumber`, `email`)
    VALUES ("Amy", "McDonald", "Ap#1 Sodales Av.", "Tamuning", "PA", "10855", "(654) 393-5734", "abc@mail.com"), 
            ("Kyla", "Olsen", "101 Integer Rd.", "Muskegon", "KY", "12482", "(314) 244-6306", "erg@mail.com"),
            ("Davis", "Patrick", "P.O. Box 147 Sociosqu Rd.", "Bethlehem", "UT", "02913", "(939) 353-1107", "dvi@mail.com"),
            ("Bryar ", "Pitts", "3 Aliquet St.", "Fort Dodge", "GA", "20783", "(717) 450-4729", "efb@mail.com"),
            ("Rahim", "Henderson", "5370 Diam Rd.", "Daly City", "OH", "90255", "(453) 391-4650", "rah@mail.com")


--
-- Table structure for table `Vinyls`
--


CREATE TABLE `Vinyls` (
	`productID` int auto_increment not null,
    `albumName` varchar(255) not null,
    `artistName` varchar(255) not null,
    `genre` varchar(255) not null,
    `price` decimal(7, 2) not null, -- 7 digits total with 2 decimal places
    `quantityAvailable` int not null,
    primary key (`productID`)    
) ENGINE=InnoDB;


--
-- Dumping data for table `Vinyls`
--

LOCK TABLES `Vinyls` WRITE;

INSERT INTO `Vinyls` (`albumName`, `artistName`, `genre`, `price`, `quantityAvailable`)
    VALUES ("BACH: THE ART OF LIFE", "Daniil Trifonov", "Classical", 38.98, 32),
            ("HOROWITZ AT HOME", "Vladimir Horowitz", "Classical", 22.98, 14),
            ("STAND BY ME", "Various Artists", "Rock", 25.5, 11),
            ("EXPERIENCE HENDRIX: THE BEST OF JIMI HENDRIX", "Jimi Hendrix", "Rock", 22.06, 56),
            ("NIRVANA-The complete bbc radio one seesions 1989-91", "Nirvana", "Rock", 16.28, 30) 


--
-- Table structure for table `Coupons`
--

DROP TABLE IF EXISTS `Coupons`;
CREATE TABLE `Coupons` (
    `couponID` VARCHAR(255) NOT NULL,
    `percentDiscount` DECIMAL NOT NULL,
    `expirationDate` DATETIME NOT NULL,
    PRIMARY KEY (`couponID`)
) ENGINE=InnoDB;

--
-- Dumping data for table `Coupons`
--

LOCK TABLES `Coupons` WRITE;

INSERT INTO `Coupons` VALUES ("THANKYOU", 85, "2021-11-31 00:00:00"),
                            ("HAPPYHOLIDAYS", 80, "2021-12-30 00:00:00"),
                            ("NEWYEAR", 80, "2022-1-5 00:00:00"),
                            ("COMEBACK", 95, "2022-06-01 00:00:00"),
                            ("FREESHIP", 100, "2022-1-10 00:00:00")
        

--
-- Table structure for table `Orders`
--

CREATE TABLE `Orders` (
    `orderID` int AUTO_INCREMENT NOT NULL,
    `orderDate` datetime NOT NULL,
    `customerID` int NOT NULL,
    `couponID` VARCHAR(255),
    `orderStatus` VARCHAR(255) NOT NULL,
    CONSTRAINT `fk_orders_customerID` 
        FOREIGN KEY (`customerID`) REFERENCES `Customers`(`customerID`)
            ON DELETE RESTRICT --not allow delete of customers if there is an order related to this customer
            ON UPDATE CASCADE,
    CONSTRAINT `fk_orders_couponID` 
        FOREIGN KEY (`couponID`) REFERENCES `Coupons`(`couponID`)
            ON DELETE SET NULL 
            ON UPDATE CASCADE,
    PRIMARY KEY (`orderID`)
) ENGINE=InnoDB;


--
-- Dumping data for table `Orders`
--

LOCK TABLES `Orders` WRITE;

INSERT INTO `Orders` (`orderDate`,`customerID`, `couponID`, `orderStatus`)
    VALUES ("2021-10-12 12:03:35", 1, "THANKYOU", "in process"),
            ("2021-10-20 16:40:23", 4, NULL, "in process"),
            ("2021-11-1 19:00:21", 2, NULL, "in process"),
            ("2021-11-3 02:05:45", 3, "NEWYEAR", "in process"),
            ("2021-11-5 10:54:01", 5, NULL, "in process")


--
-- Table structure for table `OrderProducts`
--

CREATE TABLE `OrderProducts` (
    `orderID` INT NOT NULL,
    `productID` INT NOT NULL,
    `quantity` INT NOT NULL,
    PRIMARY KEY (`orderID`, `productID`),
    FOREIGN KEY (`orderID`) REFERENCES `Orders` (`orderID`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`productID`) REFERENCES `Vinyls` (`productID`)  
        ON DELETE RESTRICT -- not allow delete of product if there is an OrderProduct related to this product
        ON UPDATE CASCADE  
) ENGINE=InnoDB;

--
-- Dumping data for table `OrderProducts`
--

LOCK TABLES `OrderProducts` WRITE;

INSERT INTO `OrderProducts` VALUES (1, 2, 1), 
                                    (1, 3, 1), 
                                    (2, 3, 1), 
                                    (3, 1, 2), 
                                    (4, 5, 1), 
                                    (4, 2, 1), 
                                    (4, 1, 2), 
                                    (4, 3, 6), 
                                    (5, 4, 1)




