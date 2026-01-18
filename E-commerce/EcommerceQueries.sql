CREATE DATABASE EcommerceDatabase;
USE EcommerceDatabase;


CREATE TABLE Customer(
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    BillingAddress VARCHAR(200) NOT NULL,
    DateOfBirth DATE NULL,
    FullName AS (FirstName + ' ' + LastName),
    IsVIP AS (CASE WHEN CustomerID <= 5 THEN 1 ELSE 0 END),
    CONSTRAINT UQ_Customer_FullName UNIQUE (FirstName, LastName)
);
CREATE TABLE CustomerEmails(CustomerID INT NOT NULL, Email VARCHAR(100) NOT NULL, PRIMARY KEY(CustomerID, Email),
    FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE);
CREATE TABLE CustomerPhones(CustomerID INT NOT NULL, Phone VARCHAR(20) NOT NULL, PRIMARY KEY(CustomerID, Phone),
    FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE);
CREATE TABLE CustomerAddresses(CustomerID INT NOT NULL, Address VARCHAR(200) NOT NULL,
    PRIMARY KEY(CustomerID, Address),
    FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE);

CREATE TABLE Vendor(
    VendorID INT IDENTITY(1,1) PRIMARY KEY,
    VendorName VARCHAR(100) NOT NULL,
    ContactPerson VARCHAR(50) NOT NULL,
    AvgDeliveryTime INT,
    Rating DECIMAL(3,2),
    Address VARCHAR(200)
);
CREATE TABLE VendorEmails(VendorID INT NOT NULL, Email VARCHAR(100) NOT NULL, PRIMARY KEY(VendorID, Email),
    FOREIGN KEY(VendorID) REFERENCES Vendor(VendorID) ON DELETE CASCADE);
CREATE TABLE VendorPhones(VendorID INT NOT NULL, Phone VARCHAR(20) NOT NULL, PRIMARY KEY(VendorID, Phone),
    FOREIGN KEY(VendorID) REFERENCES Vendor(VendorID) ON DELETE CASCADE);

CREATE TABLE Category(
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL,
    ParentCategoryID INT NULL,
    Description VARCHAR(200),
    FullCategoryPath AS (CategoryName),
    HasChildren AS (CASE WHEN ParentCategoryID IS NULL THEN 1 ELSE 0 END)
);
ALTER TABLE Category
ADD CONSTRAINT FK_Category_Parent FOREIGN KEY(ParentCategoryID) REFERENCES Category(CategoryID);

CREATE TABLE CategoryAttributes(CategoryID INT NOT NULL, AttributeName VARCHAR(100) NOT NULL, PRIMARY KEY(CategoryID, AttributeName),
    FOREIGN KEY(CategoryID) REFERENCES Category(CategoryID) ON DELETE CASCADE);

CREATE TABLE Product(
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    SKU VARCHAR(50) NOT NULL UNIQUE,
    CategoryID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK(Price >= 0),
    Weight DECIMAL(5,2) NOT NULL,
    IsInStock AS (CASE WHEN Price > 0 THEN 1 ELSE 0 END),
    DiscountedPrice AS (Price * 0.9),
    FOREIGN KEY(CategoryID) REFERENCES Category(CategoryID)
);
CREATE TABLE ProductImages(ProductID INT NOT NULL, ImageURL VARCHAR(200) NOT NULL, PRIMARY KEY(ProductID, ImageURL),
    FOREIGN KEY(ProductID) REFERENCES Product(ProductID) ON DELETE CASCADE);
CREATE TABLE ProductTags(ProductID INT NOT NULL, Tag VARCHAR(50) NOT NULL, PRIMARY KEY(ProductID, Tag),
    FOREIGN KEY(ProductID) REFERENCES Product(ProductID) ON DELETE CASCADE);

CREATE TABLE Inventory(
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    WarehouseLocation VARCHAR(50) NOT NULL,
    QtyOnHand INT NOT NULL CHECK(QtyOnHand >= 0),
    ReorderLevel INT NOT NULL CHECK(ReorderLevel >= 0),
    FOREIGN KEY(ProductID) REFERENCES Product(ProductID)
);
CREATE TABLE InventoryBatches(InventoryID INT NOT NULL, BatchNo VARCHAR(50) NOT NULL, PRIMARY KEY(InventoryID, BatchNo),
    FOREIGN KEY(InventoryID) REFERENCES Inventory(InventoryID) ON DELETE CASCADE);

CREATE TABLE [Order](
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL DEFAULT GETDATE(),
    Status VARCHAR(20) NOT NULL CHECK(Status IN ('Processing','Shipped','Delivered','Cancelled')),
    TotalAmount DECIMAL(10,2) NOT NULL CHECK(TotalAmount >= 0),
    FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE
);
CREATE TABLE OrderLines(
    OrderLineID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Qty INT NOT NULL CHECK(Qty > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK(UnitPrice >= 0),
    FOREIGN KEY(OrderID) REFERENCES [Order](OrderID) ON DELETE CASCADE,
    FOREIGN KEY(ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Payment(
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    PaymentDate DATE NOT NULL DEFAULT GETDATE(),
    Amount DECIMAL(10,2) NOT NULL CHECK(Amount >= 0),
    PaymentMethod VARCHAR(50) NOT NULL,
    TransactionRef VARCHAR(50) NOT NULL,
    FOREIGN KEY(OrderID) REFERENCES [Order](OrderID)
);

CREATE TABLE Delivery(
    DeliveryID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    Carrier VARCHAR(50) NOT NULL,
    TrackingNo VARCHAR(50) NOT NULL,
    ShipDate DATE NOT NULL,
    DeliveryDate DATE NULL,
    Status VARCHAR(20) NOT NULL CHECK(Status IN ('Shipped','In Transit','Delivered')),
    FOREIGN KEY(OrderID) REFERENCES [Order](OrderID)
);
CREATE TABLE DeliveryNotes(DeliveryID INT NOT NULL, Note VARCHAR(200) NOT NULL,
    PRIMARY KEY(DeliveryID, Note),
    FOREIGN KEY(DeliveryID) REFERENCES Delivery(DeliveryID) ON DELETE CASCADE);

CREATE TABLE ReturnRequest(
    ReturnID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ReturnDate DATE NOT NULL,
    Reason VARCHAR(200) NOT NULL,
    RefundAmount DECIMAL(10,2) NOT NULL CHECK(RefundAmount >= 0),
    FOREIGN KEY(OrderID) REFERENCES [Order](OrderID)
);

CREATE TABLE Cart(
    CartID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID)
);
CREATE TABLE CartLines(CartID INT NOT NULL, ProductID INT NOT NULL, Qty INT NOT NULL CHECK(Qty > 0), UnitPrice DECIMAL(10,2) NOT NULL,
    PRIMARY KEY(CartID, ProductID),
    FOREIGN KEY(CartID) REFERENCES Cart(CartID),
    FOREIGN KEY(ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Wishlist(
    WishlistID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID)
);
CREATE TABLE WishlistProducts(WishlistID INT NOT NULL, ProductID INT NOT NULL, Notes VARCHAR(200),
    PRIMARY KEY(WishlistID, ProductID),
    FOREIGN KEY(WishlistID) REFERENCES Wishlist(WishlistID),
    FOREIGN KEY(ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Coupon(
    CouponID INT IDENTITY(1,1) PRIMARY KEY,
    Code VARCHAR(50) NOT NULL UNIQUE,
    Discount DECIMAL(5,2) NOT NULL CHECK(Discount >= 0),
    TotalUses INT NOT NULL CHECK(TotalUses >= 0)
);
CREATE TABLE CouponConditions(CouponID INT NOT NULL, Condition VARCHAR(100) NOT NULL,
    PRIMARY KEY(CouponID, Condition),
    FOREIGN KEY(CouponID) REFERENCES Coupon(CouponID)
);
CREATE TABLE CouponApplicableProducts(CouponID INT NOT NULL, ProductID INT NOT NULL,
    PRIMARY KEY(CouponID, ProductID),
    FOREIGN KEY(CouponID) REFERENCES Coupon(CouponID),
    FOREIGN KEY(ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE ProductReview(
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    CustomerID INT NOT NULL,
    Rating INT NOT NULL CHECK(Rating BETWEEN 1 AND 5),
    ReviewText VARCHAR(500),
    FOREIGN KEY(ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID)
);
CREATE TABLE ProductReviewComments(ReviewID INT NOT NULL, Comment VARCHAR(200) NOT NULL,
    PRIMARY KEY(ReviewID, Comment),
    FOREIGN KEY(ReviewID) REFERENCES ProductReview(ReviewID)
);
CREATE TABLE ProductReviewImages(ReviewID INT NOT NULL, ImageURL VARCHAR(200) NOT NULL,
    PRIMARY KEY(ReviewID, ImageURL),
    FOREIGN KEY(ReviewID) REFERENCES ProductReview(ReviewID)
);

CREATE TABLE Supplier(
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    AvgDeliveryTime INT,
    Rating DECIMAL(3,2)
);
CREATE TABLE SupplierEmails(SupplierID INT NOT NULL, Email VARCHAR(100) NOT NULL,
    PRIMARY KEY(SupplierID, Email),
    FOREIGN KEY(SupplierID) REFERENCES Supplier(SupplierID)
);
CREATE TABLE SupplierPhones(SupplierID INT NOT NULL, Phone VARCHAR(20) NOT NULL,
    PRIMARY KEY(SupplierID, Phone),
    FOREIGN KEY(SupplierID) REFERENCES Supplier(SupplierID)
);

CREATE TABLE DiscountCampaign(
    CampaignID INT IDENTITY(1,1) PRIMARY KEY,
    CampaignName VARCHAR(100) NOT NULL,
    TotalDiscountGiven DECIMAL(10,2) NOT NULL CHECK(TotalDiscountGiven >= 0)
);
CREATE TABLE DiscountProducts(CampaignID INT NOT NULL, ProductID INT NOT NULL,
    PRIMARY KEY(CampaignID, ProductID),
    FOREIGN KEY(CampaignID) REFERENCES DiscountCampaign(CampaignID),
    FOREIGN KEY(ProductID) REFERENCES Product(ProductID)
);
CREATE TABLE DiscountTerms(CampaignID INT NOT NULL, Term VARCHAR(200) NOT NULL,
    PRIMARY KEY(CampaignID, Term),
    FOREIGN KEY(CampaignID) REFERENCES DiscountCampaign(CampaignID)
);

INSERT INTO Customer(FirstName, LastName, BillingAddress, DateOfBirth) VALUES
('John','Doe','123 Main St','1985-01-01'),
('Jane','Smith','456 Oak St','1990-02-15'),
('Alice','Johnson','789 Pine St','1988-03-20'),
('Bob','Williams','321 Maple St','1975-04-05'),
('Eve','Brown','654 Elm St','1992-05-10'),
('Charlie','Davis','987 Cedar St','1980-06-25'),
('Grace','Miller','147 Birch St','1995-07-30'),
('Henry','Wilson','258 Spruce St','1983-08-17'),
('Ivy','Moore','369 Walnut St','1991-09-12'),
('Jack','Taylor','159 Chestnut St','1987-10-08');

INSERT INTO CustomerEmails(CustomerID, Email) VALUES
(1,'john@example.com'),(2,'jane@example.com'),(3,'alice@example.com'),(4,'bob@example.com'),
(5,'eve@example.com'),(6,'charlie@example.com'),(7,'grace@example.com'),(8,'henry@example.com'),
(9,'ivy@example.com'),(10,'jack@example.com');

INSERT INTO CustomerPhones(CustomerID, Phone) VALUES
(1,'111-111-1111'),(2,'222-222-2222'),(3,'333-333-3333'),(4,'444-444-4444'),
(5,'555-555-5555'),(6,'666-666-6666'),(7,'777-777-7777'),(8,'888-888-8888'),
(9,'999-999-9999'),(10,'000-000-0000');

INSERT INTO Vendor(VendorName, ContactPerson, AvgDeliveryTime, Rating, Address) VALUES
('Vendor A','Alice',5,4.5,'100 Vendor St'),
('Vendor B','Bob',6,4.2,'200 Vendor St'),
('Vendor C','Charlie',7,4.0,'300 Vendor St'),
('Vendor D','David',4,4.7,'400 Vendor St'),
('Vendor E','Eve',8,3.9,'500 Vendor St');

INSERT INTO VendorEmails(VendorID, Email) VALUES
(1,'alice@vendor.com'),(2,'bob@vendor.com'),(3,'charlie@vendor.com'),
(4,'david@vendor.com'),(5,'eve@vendor.com');

INSERT INTO VendorPhones(VendorID, Phone) VALUES
(1,'101-101-1010'),(2,'202-202-2020'),(3,'303-303-3030'),(4,'404-404-4040'),(5,'505-505-5050');

INSERT INTO Supplier(SupplierName, AvgDeliveryTime, Rating) VALUES
('Supplier X',5,4.5),('Supplier Y',6,4.0),('Supplier Z',7,4.2),('Supplier W',4,4.7),('Supplier V',8,3.8);

INSERT INTO SupplierEmails(SupplierID, Email) VALUES
(1,'x@supplier.com'),(2,'y@supplier.com'),(3,'z@supplier.com'),(4,'w@supplier.com'),(5,'v@supplier.com');

INSERT INTO SupplierPhones(SupplierID, Phone) VALUES
(1,'111-000-1111'),(2,'222-000-2222'),(3,'333-000-3333'),(4,'444-000-4444'),(5,'555-000-5555');

INSERT INTO Category(CategoryName, ParentCategoryID, Description) VALUES
('Electronics',NULL,'Electronic Items'),
('Mobiles',1,'Smartphones and Accessories'),
('Laptops',1,'All Laptops'),
('Fashion',NULL,'Clothing and Accessories'),
('Men',4,'Mens Fashion');

INSERT INTO CategoryAttributes(CategoryID, AttributeName) VALUES
(1,'Brand'),(1,'Warranty'),(2,'OS'),(3,'Processor'),(4,'Size'),(5,'Color');

INSERT INTO Product(ProductName, SKU, CategoryID, Price, Weight) VALUES
('iPhone 14','SKU001',2,999.99,0.5),
('Samsung Galaxy S23','SKU002',2,899.99,0.5),
('Dell XPS 13','SKU003',3,1200.00,1.2),
('HP Pavilion','SKU004',3,850.00,1.5),
('T-Shirt','SKU005',5,25.00,0.2),
('Jeans','SKU006',5,50.00,0.7),
('Smartwatch','SKU007',2,199.00,0.1),
('MacBook Pro','SKU008',3,1500.00,1.3),
('Headphones','SKU009',1,150.00,0.3),
('Shoes','SKU010',5,80.00,0.8);

INSERT INTO ProductImages(ProductID, ImageURL) VALUES
(1,'iphone.jpg'),(2,'galaxy.jpg'),(3,'dellxps.jpg'),(4,'hp.jpg'),(5,'tshirt.jpg'),
(6,'jeans.jpg'),(7,'watch.jpg'),(8,'macbook.jpg'),(9,'headphones.jpg'),(10,'shoes.jpg');

INSERT INTO ProductTags(ProductID, Tag) VALUES
(1,'smartphone'),(2,'smartphone'),(3,'laptop'),(4,'laptop'),(5,'clothing'),
(6,'clothing'),(7,'wearable'),(8,'laptop'),(9,'audio'),(10,'footwear');

INSERT INTO Inventory(ProductID, WarehouseLocation, QtyOnHand, ReorderLevel) VALUES
(1,'WH1',50,10),(2,'WH1',40,10),(3,'WH2',30,5),(4,'WH2',25,5),
(5,'WH3',100,20),(6,'WH3',90,20),(7,'WH1',60,15),(8,'WH2',20,5),
(9,'WH1',80,10),(10,'WH3',70,15);

INSERT INTO InventoryBatches(InventoryID, BatchNo) VALUES
(1,'B001'),(2,'B002'),(3,'B003'),(4,'B004'),(5,'B005'),(6,'B006'),
(7,'B007'),(8,'B008'),(9,'B009'),(10,'B010');

INSERT INTO [Order](CustomerID, OrderDate, Status, TotalAmount) VALUES
(1,'2025-12-01','Processing',999.99),(2,'2025-12-02','Shipped',899.99),
(3,'2025-12-03','Delivered',1200.00),(4,'2025-12-04','Cancelled',850.00),
(5,'2025-12-05','Processing',25.00),(6,'2025-12-06','Shipped',50.00),
(7,'2025-12-07','Delivered',199.00),(8,'2025-12-08','Processing',1500.00),
(9,'2025-12-09','Delivered',150.00),(10,'2025-12-10','Processing',80.00);

INSERT INTO OrderLines(OrderID, ProductID, Qty, UnitPrice) VALUES
(1,1,1,999.99),(2,2,1,899.99),(3,3,1,1200.00),(4,4,1,850.00),(5,5,1,25.00),
(6,6,1,50.00),(7,7,1,199.00),(8,8,1,1500.00),(9,9,1,150.00),(10,10,1,80.00);

INSERT INTO Payment(OrderID, PaymentDate, Amount, PaymentMethod, TransactionRef) VALUES
(1,'2025-12-01',999.99,'Card','TXN001'),(2,'2025-12-02',899.99,'Card','TXN002'),
(3,'2025-12-03',1200.00,'PayPal','TXN003'),(4,'2025-12-04',850.00,'Card','TXN004'),
(5,'2025-12-05',25.00,'Cash','TXN005'),(6,'2025-12-06',50.00,'Card','TXN006'),
(7,'2025-12-07',199.00,'PayPal','TXN007'),(8,'2025-12-08',1500.00,'Card','TXN008'),
(9,'2025-12-09',150.00,'Cash','TXN009'),(10,'2025-12-10',80.00,'Card','TXN010');

INSERT INTO Cart(CustomerID) VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);
INSERT INTO CartLines(CartID, ProductID, Qty, UnitPrice) VALUES
(1,1,1,999.99),(2,2,1,899.99),(3,3,1,1200.00),(4,4,1,850.00),(5,5,1,25.00),
(6,6,1,50.00),(7,7,1,199.00),(8,8,1,1500.00),(9,9,1,150.00),(10,10,1,80.00);

INSERT INTO Wishlist(CustomerID) VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);
INSERT INTO WishlistProducts(WishlistID, ProductID, Notes) VALUES
(1,2,'Note'),(2,3,'Note'),(3,4,'Note'),(4,5,'Note'),
(5,6,'Note'),(6,7,'Note'),(7,8,'Note'),(8,9,'Note'),
(9,10,'Note'),(10,1,'Note');

INSERT INTO Coupon(Code, Discount, TotalUses) VALUES
('CUP10',10,50),('CUP20',20,40),('CUP30',30,30),('CUP40',40,20),('CUP50',50,10);
INSERT INTO CouponConditions(CouponID, Condition) VALUES
(1,'Min $50'),(2,'Min $100'),(3,'Min $150'),(4,'Min $200'),(5,'Min $250');
INSERT INTO CouponApplicableProducts(CouponID, ProductID) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5);

INSERT INTO ProductReview(ProductID, CustomerID, Rating, ReviewText) VALUES
(1,1,5,'Excellent'),(2,2,4,'Good'),(3,3,5,'Highly recommended'),
(4,4,3,'Average'),(5,5,4,'Nice'),(6,6,5,'Great'),(7,7,4,'Good'),
(8,8,5,'Excellent'),(9,9,3,'Okay'),(10,10,4,'Good');

INSERT INTO ProductReviewComments(ReviewID, Comment) VALUES
(1,'Agree'),(2,'Thanks'),(3,'Helpful'),(4,'Noted'),(5,'Good'),
(6,'Great'),(7,'Thanks'),(8,'Excellent'),(9,'Okay'),(10,'Nice');

INSERT INTO ProductReviewImages(ReviewID, ImageURL) VALUES
(1,'img1.jpg'),(2,'img2.jpg'),(3,'img3.jpg'),(4,'img4.jpg'),(5,'img5.jpg'),
(6,'img6.jpg'),(7,'img7.jpg'),(8,'img8.jpg'),(9,'img9.jpg'),(10,'img10.jpg');

INSERT INTO DiscountCampaign(CampaignName, TotalDiscountGiven) VALUES
('XMas Sale',500),('New Year',400),('Black Friday',600),('Cyber Monday',300),('Summer Sale',200);
INSERT INTO DiscountProducts(CampaignID, ProductID) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5);
INSERT INTO DiscountTerms(CampaignID, Term) VALUES
(1,'10 days'),(2,'7 days'),(3,'5 days'),(4,'3 days'),(5,'2 days');




--UPDATE QUERIES

SELECT * FROM Customer;
SELECT * FROM Product;
SELECT * FROM [Order];
SELECT * FROM Payment;
SELECT * FROM Inventory;
SELECT * FROM Delivery;
SELECT * FROM Cart;
SELECT * FROM WishlistProducts;
SELECT * FROM Coupon;
SELECT * FROM ProductReview;

UPDATE Customer
SET BillingAddress = '999 New Skyline Ave, New York, NY'
WHERE CustomerID = 1;

UPDATE [Order]
SET Status = 'Shipped'
WHERE OrderID = 5;

UPDATE Product
SET Price = Price + 50.00
WHERE ProductID = 1;

UPDATE Inventory
SET QtyOnHand = QtyOnHand + 100
WHERE ProductID = 5;

UPDATE Delivery
SET Status = 'Delivered', 
    DeliveryDate = GETDATE()
WHERE OrderID = 2;

UPDATE Payment
SET PaymentMethod = 'Card'
WHERE PaymentID = 5;

UPDATE CartLines
SET Qty = 2
WHERE CartID = 1 AND ProductID = 1;

UPDATE Vendor
SET Rating = 4.9
WHERE VendorName = 'Vendor A';

UPDATE Coupon
SET TotalUses = TotalUses - 1
WHERE Code = 'CUP10';

UPDATE WishlistProducts
SET Notes = 'Buy for Mom birthday'
WHERE WishlistID = 2 AND ProductID = 3;


--indexes

CREATE NONCLUSTERED INDEX IDX_Order_Date_Customer
ON [Order] (OrderDate, CustomerID);

CREATE NONCLUSTERED INDEX IDX_Inventory_ProductID
ON Inventory (ProductID);

CREATE NONCLUSTERED INDEX IDX_Product_Category_Price
ON Product (CategoryID, Price);

--view

SELECT * FROM v_OrderDetails;
SELECT * FROM v_DailySalesSummary;
SELECT * FROM v_LowInventoryAlerts;
SELECT * FROM v_ProductReviewSummary;
SELECT * FROM v_CustomerCartTotals;

CREATE VIEW v_OrderDetails
AS
SELECT
    O.OrderID,
    O.OrderDate,
    O.Status AS OrderStatus,
    O.TotalAmount,
    C.CustomerID,
    C.FullName AS CustomerName,
    C.BillingAddress
FROM
    [Order] O
JOIN
    Customer C ON O.CustomerID = C.CustomerID;

CREATE VIEW v_DailySalesSummary
AS
SELECT
    CAST(OrderDate AS DATE) AS SaleDate,
    COUNT(OrderID) AS TotalOrders,
    SUM(TotalAmount) AS TotalRevenue
FROM
    [Order]
WHERE
    Status IN ('Shipped', 'Delivered') -- Only count completed/shipped orders
GROUP BY
    CAST(OrderDate AS DATE);

CREATE VIEW v_LowInventoryAlerts
AS
SELECT
    P.ProductID,
    P.ProductName,
    I.WarehouseLocation,
    I.QtyOnHand,
    I.ReorderLevel,
    (I.ReorderLevel - I.QtyOnHand) AS QtyNeeded
FROM
    Inventory I
JOIN
    Product P ON I.ProductID = P.ProductID
WHERE
    I.QtyOnHand <= I.ReorderLevel;


CREATE VIEW v_ProductReviewSummary
AS
SELECT
    P.ProductID,
    P.ProductName,
    AVG(CAST(R.Rating AS DECIMAL(3, 2))) AS AverageRating,
    COUNT(R.ReviewID) AS TotalReviews
FROM
    Product P
JOIN
    ProductReview R ON P.ProductID = R.ProductID
GROUP BY
    P.ProductID, P.ProductName;

CREATE VIEW v_CustomerCartTotals
AS
SELECT
    C.CustomerID,
    C.FullName AS CustomerName,
    CR.CartID,
    SUM(CL.Qty * CL.UnitPrice) AS CartTotalPrice
FROM
    Customer C
JOIN
    Cart CR ON C.CustomerID = CR.CustomerID
JOIN
    CartLines CL ON CR.CartID = CL.CartID
GROUP BY
    C.CustomerID, C.FullName, CR.CartID;
