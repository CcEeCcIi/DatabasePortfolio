/* Data Definition Queries and INSERT Queries */
/* Authors: TingTing Fang and Ian Docherty */


DROP TABLE IF EXISTS `Orders`, `Customers`, `Vinyls`, `Coupons`, `OrderProducts`;


/* Define the Customers table */
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

/* Data dump for Customers table */
LOCK TABLES `Customers` WRITE;

INSERT INTO `Customers` (`firstName`, `lastName`, `streetAddress`, `city`, `state`, `zipCode`, `phoneNumber`, `email`)
    VALUES ("Amy", "McDonald", "Ap#1 Sodales Av.", "Tamuning", "PA", "10855", "(654) 393-5734", "abc@mail.com"), 
            ("Kyla", "Olsen", "101 Integer Rd.", "Muskegon", "KY", "12482", "(314) 244-6306", "erg@mail.com"),
            ("Davis", "Patrick", "P.O. Box 147 Sociosqu Rd.", "Bethlehem", "UT", "02913", "(939) 353-1107", "dvi@mail.com"),
            ("Bryar ", "Pitts", "3 Aliquet St.", "Fort Dodge", "GA", "20783", "(717) 450-4729", "efb@mail.com"),
            ("Rahim", "Henderson", "5370 Diam Rd.", "Daly City", "OH", "90255", "(453) 391-4650", "rah@mail.com");
            
UNLOCK TABLES;

/* Define the Vinyls table */
CREATE TABLE `Vinyls` (
	`productID` int auto_increment not null,
    `albumName` varchar(255) not null,
    `artistName` varchar(255) not null,
    `genre` varchar(255) not null,
    `price` decimal(7, 2) not null, -- 7 digits total with 2 decimal places
    `quantityAvailable` int not null,
    primary key (`productID`)    
) ENGINE=InnoDB;

/* Data dump for Vinyls table */
LOCK TABLES `Vinyls` WRITE;

INSERT INTO `Vinyls` (`albumName`, `artistName`, `genre`, `price`, `quantityAvailable`)
    VALUES ("BACH: THE ART OF LIFE", "Daniil Trifonov", "Classical", 38.98, 32),
            ("HOROWITZ AT HOME", "Vladimir Horowitz", "Classical", 22.98, 14),
            ("STAND BY ME", "Various Artists", "Rock", 25.5, 11),
            ("EXPERIENCE HENDRIX: THE BEST OF JIMI HENDRIX", "Jimi Hendrix", "Rock", 22.06, 56),
            ("NIRVANA - The complete BBC Radio One sessions 1989-91", "Nirvana", "Rock", 16.28, 30); 
            
UNLOCK TABLES;


/* Define the Coupons table */
CREATE TABLE `Coupons` (
    `couponID` VARCHAR(255) NOT NULL,
    `percentDiscount` DECIMAL NOT NULL,
    `expirationDate` DATE NOT NULL,
    PRIMARY KEY (`couponID`)
) ENGINE=InnoDB;

/* Data dump for the Coupons table */
LOCK TABLES `Coupons` WRITE;

INSERT INTO `Coupons` VALUES ("THANKYOU", 85, "2021-11-30"),
                            ("HAPPYHOLIDAYS", 80, "2021-12-30"),
                            ("NEWYEAR", 80, "2022-01-05"),
                            ("COMEBACK", 95, "2022-06-01"),
                            ("FREESHIP", 100, "2022-01-10");
                            
UNLOCK TABLES;                            
        

/* Define the Orders table */
CREATE TABLE `Orders` (
    `orderID` int AUTO_INCREMENT NOT NULL,
    `orderDate` datetime NOT NULL,
    `customerID` int NOT NULL,
    `couponID` VARCHAR(255),
    `orderStatus` VARCHAR(255) NOT NULL,
    CONSTRAINT `fk_orders_customerID` 
        FOREIGN KEY (`customerID`) REFERENCES `Customers`(`customerID`)
            ON DELETE RESTRICT -- Don't allow a Customer to be delted if there is an Order related to that Customer
            ON UPDATE CASCADE,
    CONSTRAINT `fk_orders_couponID` 
        FOREIGN KEY (`couponID`) REFERENCES `Coupons`(`couponID`)
            ON DELETE SET NULL -- If a couponID is deleted and is related to an Order, this FK will be changed to NULL
            ON UPDATE CASCADE,
    PRIMARY KEY (`orderID`)
) ENGINE=InnoDB;

/* Data dump for the Orders table */
LOCK TABLES `Orders` WRITE;

INSERT INTO `Orders` (`orderDate`,`customerID`, `couponID`, `orderStatus`)
    VALUES ("2021-10-12 12:03:35", 1, "THANKYOU", "in process"),
            ("2021-10-20 16:40:23", 4, NULL, "in process"),
            ("2021-11-1 19:00:21", 2, NULL, "in process"),
            ("2021-11-3 02:05:45", 3, "NEWYEAR", "in process"),
            ("2021-11-5 10:54:01", 5, NULL, "in process");
            
UNLOCK TABLES;            


/* Define the OrderProducts table */
CREATE TABLE `OrderProducts` (
    `orderID` INT NOT NULL,
    `productID` INT NOT NULL,
    `quantity` INT NOT NULL,
    PRIMARY KEY (`orderID`, `productID`),
    FOREIGN KEY (`orderID`) REFERENCES `Orders` (`orderID`)
        ON DELETE CASCADE  -- If an orderID is deleted from the Orders table, it will also be deleted in the OrderProducts table
        ON UPDATE CASCADE,
    FOREIGN KEY (`productID`) REFERENCES `Vinyls` (`productID`)  
        ON DELETE RESTRICT -- Don't allow a Vinyl to be deleted if there is an OrderProduct related to that Vinyl
        ON UPDATE CASCADE  
) ENGINE=InnoDB;

/* Data dump for the OrderProducts table */
LOCK TABLES `OrderProducts` WRITE;

INSERT INTO `OrderProducts` VALUES (1, 2, 1), 
								   (1, 3, 1), 
								   (2, 3, 1), 
								   (3, 1, 2), 
								   (4, 5, 1), 
								   (4, 2, 1), 
								   (4, 1, 2), 
								   (4, 3, 6), 
								   (5, 4, 1);

UNLOCK TABLES;



