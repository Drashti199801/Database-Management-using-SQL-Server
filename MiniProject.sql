USE master
GO
-- 1. Drop the database if it exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'SWC_DB')
    DROP DATABASE SWC_DB;
GO

-- 2. Create the database
CREATE DATABASE SWC_DB;
GO

-- 3. Create tables
USE SWC_DB;
GO

CREATE TABLE Purchasers (
    PurchaserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    StreetNumber NVARCHAR(20),
    StreetName NVARCHAR(100),
    City NVARCHAR(100),
    Province NVARCHAR(100),
    Country NVARCHAR(100),
    PostalCode NVARCHAR(20),
    Phone NVARCHAR(20) NOT NULL
);
GO

CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE PartTypes (
    PartTypeID INT IDENTITY(1,1) PRIMARY KEY,
    PartTypeName NVARCHAR(100) NOT NULL
);
GO


CREATE TABLE Parts (
    PartID INT IDENTITY(1,1) PRIMARY KEY,
    PartNumber NVARCHAR(20) NOT NULL,
    SupplierID INT NOT NULL,
    PartTypeID INT NOT NULL,
    PartDescription NVARCHAR(100) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    CONSTRAINT FK_SupplierID FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    CONSTRAINT FK_PartTypeID FOREIGN KEY (PartTypeID) REFERENCES PartTypes(PartTypeID)
);
GO


CREATE TABLE Purchases (
    PurchaseID INT IDENTITY(1,1) PRIMARY KEY,
    PurchaserID INT NOT NULL,
    PartID INT NOT NULL,
	DesktopBundle NVARCHAR(100),
    PurchaseDate DATE NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Quantity INT NOT NULL,
    CONSTRAINT FK_PurchaserID FOREIGN KEY (PurchaserID) REFERENCES Purchasers(PurchaserID),
    CONSTRAINT FK_PartID FOREIGN KEY (PartID) REFERENCES Parts(PartID)
);
GO


-- 6. Create check constraints
ALTER TABLE Purchasers ADD CONSTRAINT CK_PurchaserFirstName CHECK (LEN(FirstName) >= 3);
GO

ALTER TABLE Purchasers ADD CONSTRAINT CK_PurchaserLastName CHECK (LEN(LastName) >= 3);
GO

ALTER TABLE Parts ADD CONSTRAINT CK_PartDescription CHECK (LEN(PartDescription) >= 3);
GO

ALTER TABLE Parts ADD CONSTRAINT CK_UnitPriceNonNegative CHECK (UnitPrice >= 0);
GO

ALTER TABLE Purchases ADD CONSTRAINT CK_QuantityPositive CHECK (Quantity > 0);
GO


-- 7. Constraint for default country Canada
ALTER TABLE Purchasers ADD CONSTRAINT CK_PurchaserCountry DEFAULT 'Canada' FOR Country;
GO


-- 8. Insert data into tables
INSERT INTO Purchasers (FirstName, LastName, Email, StreetNumber, StreetName, City, Province, PostalCode, Phone)
VALUES 
('Joey', 'Smith', 'joey@example.com', '123', 'Main St', 'Anytown', 'AnyProvince', 'A1B 2C3', '123-456-7890'),
('May', 'Johnson', 'may@example.com', '456', 'Oak Ave', 'Sometown', 'SomeProvince', 'X1Y 3Z5', '234-567-8901'),
('Troy', 'Williams', 'troy@example.com', '789', 'Maple Rd', 'Othertown', 'OtherProvince', 'M4N 1J7', '345-678-9012'),
('Vinh', 'Nguyen', 'vinh@example.com', '1011', 'Cedar Blvd', 'Anothertown', 'AnotherProvince', 'K2P 0B6', '456-789-0123');


INSERT INTO Suppliers (SupplierName)
VALUES ('Dell'), ('HP'), ('Samsung'), ('Lenovo'), ('Max');
GO


INSERT INTO PartTypes (PartTypeName)
VALUES ('Desktop'), ('Monitor'), ('Tablet'), ('Keyboard'), ('Mouse'), ('Camera');
GO


INSERT INTO Parts (PartNumber, SupplierID, PartTypeID, PartDescription, UnitPrice)
VALUES ('DL1010', 1, 1, 'Dell Optiplex 1010', 40.00),
       ('DL5040', 1, 1, 'Dell Optiplex 5040', 150.00),
       ('DLM190', 1, 2, 'Dell 19-inch Monitor', 35.00),
       ('HP400', 2, 1, 'HP Desktop Tower', 60.00),
       ('HP800', 2, 1, 'HP EliteDesk 800G1', 200.00),
       ('HPM270', 2, 2, 'HP 27-inch Monitor', 120.00),
       ('SM330', 3, 3, '7” Android Tablet', 110.00),
       ('LEN101', 4, 4, 'Computer Keyboard', 7.00),
       ('LEN102', 4, 5, 'Lenovo Mouse', 5.00),
       ('DLM240', 1, 2, 'Dell 24-inch Monitor', 80.00),
       ('HPM220', 2, 2, 'HP 22-inch Monitor', 45.00),
       ('MAX901', 5, 6, 'Max Web Camera', 20.00),
       ('HP501', 2, 4, 'Computer Keyboard', 9.00),
       ('HP502', 2, 5, 'HP Mouse', 6.00);
GO


INSERT INTO Purchases (PurchaserID, PartID, DesktopBundle, PurchaseDate, UnitPrice, Quantity)
VALUES (1, 1,'Dell Eco' ,'2022-10-31', 40.00, 25),
       (1, 2,'Dell Biz','2022-10-31', 150.00, 50),
       (1, 3,'Dell Eco','2022-10-31', 35.00, 25),
       (2, 4,'HP Eco','2022-11-10', 60.00, 15),
       (2, 5,'HP Biz','2022-11-20', 200.00, 20),
       (2, 6,'HP Biz','2022-11-20', 120.00, 20),
       (3, 7,'N/A','2022-11-30', 110.00, 10),
       (4, 8,'Dell Eco, Dell Biz ','2022-12-05', 7.00, 50),
       (4, 9,'Dell Eco, Dell Biz ','2022-12-05', 5.00, 50),
       (4, 10,'Dell Biz ','2022-12-05', 80.00, 80),
       (1, 11,'HP Eco','2022-12-10', 45.00, 30),
       (4, 9,'Dell Eco, Dell Biz ','2022-12-15', 5.00, 100),
       (4, 12,'HP Biz','2022-12-15', 20.00, 40),
       (3, 13,'HP Eco, HP Biz','2022-12-20', 9.00, 100),
       (3, 14,'HP Eco, HP Biz','2022-12-20', 6.00, 100);
GO


-- 9. Create indexes
CREATE INDEX IX_PurchaserPhone ON Purchasers(Phone);
GO

CREATE UNIQUE INDEX IX_PurchaserEmail ON Purchasers(Email);
GO


--Testing 9th
INSERT INTO Purchasers (FirstName, LastName, Email, Phone)
VALUES ('Jay', 'Patel', 'joey@example.com', '521-456-5214');
GO



--10 Creating Extended Price View
CREATE VIEW PurchaseDetailsWithExtendedAmount AS
SELECT 
    pr.PurchaseID,
    pu.FirstName,
    pu.LastName,
    pu.Email,
    pu.Phone,
    s.SupplierName,
    pt.PartTypeName,
    prt.PartNumber,
    prt.PartDescription,
    pr.PurchaseDate,
    pr.UnitPrice,
    pr.Quantity,
    pr.UnitPrice * pr.Quantity AS ExtendedAmount
FROM Purchases pr
JOIN Purchasers pu ON pr.PurchaserID = pu.PurchaserID -- Corrected join condition
JOIN Parts prt ON pr.PartID = prt.PartID
JOIN Suppliers s ON prt.SupplierID = s.SupplierID
JOIN PartTypes pt ON prt.PartTypeID = pt.PartTypeID;
GO


SELECT *
FROM PurchaseDetailsWithExtendedAmount
ORDER BY FirstName, PurchaseDate, PartNumber;
GO



--11 Creating Views for total bundle cost

CREATE VIEW DesktopBundleTotalCost AS
SELECT
    BundleNames.BundleName,
    SUM(P.UnitPrice) AS TotalCost
FROM Parts P
JOIN (
    VALUES 
        ('DL1010', 'Dell Eco'),            -- Dell Optiplex 1010 (Dell Eco)
        ('DL5040', 'Dell Biz'),            -- Dell Optiplex 5040 (Dell Biz)
        ('DLM190', 'Dell Eco'),            -- Dell 19-inch Monitor (Dell Eco)
        ('HP400', 'HP Eco'),               -- HP Desktop Tower (HP Eco)
        ('HP800', 'HP Biz'),               -- HP EliteDesk 800G1 (HP Biz)
        ('HPM270', 'HP Biz'),              -- HP 27-inch Monitor (HP Biz)
        ('LEN101', 'Dell Eco'),            -- Lenovo Keyboard (Dell Eco)
        ('LEN101', 'Dell Biz'),            -- Lenovo Keyboard (Dell Biz)
        ('LEN102', 'Dell Eco'),            -- Lenovo Mouse (Dell Eco)
        ('LEN102', 'Dell Biz'),            -- Lenovo Mouse (Dell Biz)
        ('DLM240', 'Dell Biz'),            -- Dell 24-inch Monitor (Dell Biz)
        ('HPM220', 'HP Eco'),              -- HP 22-inch Monitor (HP Eco)              -- HP 22-inch Monitor (HP Biz)
        ('MAX901', 'HP Biz'),              -- Max Web Camera (HP Biz)
        ('HP501', 'HP Eco'),               -- Computer Keyboard (HP Eco)
        ('HP501', 'HP Biz'),               -- Computer Keyboard (HP Biz)
        ('HP502', 'HP Eco'),               -- HP Mouse (HP Eco)
        ('HP502', 'HP Biz')                -- HP Mouse (HP Biz)
) AS BundleNames(PartNumber, BundleName) ON P.PartNumber = BundleNames.PartNumber
GROUP BY BundleNames.BundleName;

SELECT *
FROM DesktopBundleTotalCost
GO


--Trigger

CREATE TRIGGER CheckPostalCode
ON Purchasers
AFTER INSERT
AS
BEGIN
    -- Check if the PostalCode value is NULL or empty
    IF (SELECT COUNT(*) FROM inserted WHERE PostalCode IS NULL OR PostalCode = '') > 0
    BEGIN
        -- If PostalCode is NULL or empty, insert 'N/A'
        UPDATE Purchasers
        SET PostalCode = 'N/A'
        WHERE PurchaserID IN (SELECT PurchaserID FROM inserted WHERE PostalCode IS NULL OR PostalCode = '');
    END
END;
GO


--Testing Triggers
INSERT INTO Purchasers (FirstName, LastName, Email, StreetNumber, StreetName, City, Province, Country, Phone)
VALUES ('John', 'Doe', 'johndoe@example.com', '123', 'Main Street', 'City', 'Province', 'Country', '123-456-7890');
GO


Select * from Purchasers
GO



--Trigger 2
--trigger to calculate extended amount when inserting new data
ALTER TABLE Purchases
ADD ExtendedAmount DECIMAL(10, 2);
GO


-- Create trigger to calculate extended amount
CREATE TRIGGER CalculateExtendedAmountTrigger
ON Purchases 
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update ExtendedAmount column for newly inserted records
    UPDATE p
    SET ExtendedAmount = ISNULL(i.UnitPrice, 0) * ISNULL(i.Quantity, 0)
    FROM Purchases p
    JOIN inserted i ON p.PurchaseID = i.PurchaseID;
END;
GO

-- Testing
INSERT INTO Purchases (PurchaserID, PartID, PurchaseDate,UnitPrice, Quantity)
VALUES (1, 1,'2022-10-31', 60.00, 25);
GO

SELECT * FROM Purchases

--Store Procedure
CREATE PROCEDURE CalculateBundleTotalCost
    @BundleName NVARCHAR(50)
AS
BEGIN
    DECLARE @TotalCost DECIMAL(10, 2);

    -- Calculate total cost for the specified bundle
    SELECT @TotalCost = SUM(P.UnitPrice * P.Quantity)
    FROM Purchases P
    JOIN Parts PT ON P.PartID = PT.PartID
    JOIN PartTypes PTy ON PT.PartTypeID = PTy.PartTypeID
    WHERE PTy.PartTypeName = @BundleName;

    -- Output the total cost
    SELECT @TotalCost AS TotalCost;
END;
GO

EXEC CalculateBundleTotalCost @BundleName = 'Mouse';
GO

--Store Procedure 2
CREATE PROCEDURE UpdatePartUnitPrice
    @PartID INT,
    @NewUnitPrice DECIMAL(10, 2)
AS
BEGIN
    -- Update the UnitPrice for the specified PartID
    UPDATE Parts
    SET UnitPrice = @NewUnitPrice
    WHERE PartID = @PartID;

    -- Output a success message
    SELECT 'UnitPrice updated successfully.' AS Message;
END;
GO

EXEC UpdatePartUnitPrice @PartID = 1, @NewUnitPrice = 55.00;
GO
SELECT * FROM Parts



--Print Every thing
SELECT
    Parts.PartNumber AS Part_Number,
    S.SupplierName AS Supplier,
    PT.PartTypeName AS Part_Type,
    Parts.PartDescription AS Part_Description,
    P.FirstName AS Purchaser_FirstName,
    P.LastName AS Purchaser_LastName,
	pur.DesktopBundle,
    Pur.PurchaseDate,
    Pur.UnitPrice,
    Pur.Quantity AS Qty
FROM
    Purchases Pur
JOIN Purchasers P ON Pur.PurchaserID = P.PurchaserID
JOIN Parts ON Pur.PartID = Parts.PartID
JOIN Suppliers S ON Parts.SupplierID = S.SupplierID
JOIN PartTypes PT ON Parts.PartTypeID = PT.PartTypeID
ORDER BY Pur.PurchaseDate;



