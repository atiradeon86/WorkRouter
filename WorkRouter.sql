-- WorkRouter V0.2  Beta 1

CREATE DATABASE WorkRouter
GO

USE WorkRouter
GO

CREATE TABLE Customer (
  CustomerID int PRIMARY KEY IDENTITY(1, 1),
  FirstName varchar(30),
  MiddleName varchar(30),
  LastName varchar(30),
  Email varchar(90),
  PermitLogin bit DEFAULT 0,
  CustomerPassword varchar(8),
  PhoneNumber varchar(20) UNIQUE,
  SecondPhoneNumber varchar(20),
  IsNewsletter bit,
  HasBuyerCard bit,
  BuyerCardNumber varchar(10),
  isWorker bit DEFAULT 0,
  isSubcontractor bit DEFAULT 0,
  SubcontractorName varchar(100),
  isB2bParnter bit DEFAULT 0,
  B2bPartnerName varchar(100)
)
GO

CREATE TABLE DictCountry (
  CountryCode char(2) PRIMARY KEY,
  CountryName varchar(50) NOT NULL UNIQUE
)
GO

CREATE TABLE DictCounty (
  CountyID int PRIMARY KEY IDENTITY(1, 1),
  CountryCode char(2),
  CountyName varchar(50) NOT NULL UNIQUE
)
GO

CREATE TABLE PostalCode (
  PostalCodeID int PRIMARY KEY IDENTITY(1, 1),
  PostalCode varchar(10),
  CountyID int,
  CityName varchar(50)
)
GO

CREATE TABLE Service (
  ServiceCode int PRIMARY KEY IDENTITY(1, 1),
  ServiceName varchar(100) NOT NULL UNIQUE,
  AddressID int,
  PhoneNumber varchar(20),
  Email varchar(90),
  ServiceFrom date,
  ServiceTo date
)
GO

ALTER TABLE Service WITH CHECK ADD  CONSTRAINT CK_Service_ToDate CHECK  (ServiceTo>ServiceFrom)

CREATE TABLE Site (
  SiteCode smallint PRIMARY KEY,
  ServiceCode int,
  SiteName varchar(100) NOT NULL UNIQUE,
  PhoneNumber varchar(20),
  Email varchar(90),
  AddressID int,
  SiteFrom date,
  SiteTo date
)
GO

ALTER TABLE Site WITH CHECK ADD  CONSTRAINT CK_Site_ToDate CHECK  (SiteTo>SiteFrom)


CREATE TABLE Address (
  AddressId int PRIMARY KEY IDENTITY(1, 1),
  CustomerID int,
  isMailingAddress bit DEFAULT 0,
  isPrimaryAddress bit DEFAULT 0,
  isBillingAddress bit DEFAULT 0,
  CountryCode char(2),
  PostalCode varchar(10),
  CityName varchar(50),
  AddressLine1 varchar(100),
  Addressline2 varchar(100),
  AddressFrom date,
  AddressTo date
)
GO

ALTER TABLE Address WITH CHECK ADD  CONSTRAINT CK_Address_ToDate CHECK  (AddressTo>AddressFrom)

CREATE TABLE Worksheet (
  WorksheetID int PRIMARY KEY IDENTITY(1, 1),
  WorksheetRecorderID smallint,
  CustomerID int,
  SiteCode smallint,
  WorksheetNumber varchar(20) UNIQUE,
  IsExternal bit DEFAULT 0,
  ExternalJobDescription varchar(120),
  TimeOfIssue datetime NOT NULL DEFAULT SYSDATETIME(),
  DeviceName varchar(120),
  DeviceSerialNummber varchar(100),
  JobDescription varchar(120),
  ServiceCode int,
  IsBilled bit DEFAULT 0,
  IsLocked bit DEFAULT 0,
  StatusCode tinyint DEFAULT 0,
  TimeOfCompletion datetime DEFAULT NULL
)

ALTER TABLE Worksheet WITH CHECK ADD  CONSTRAINT CK_Worksheet_IssueDate CHECK (TimeOfCompletion >= SYSDATETIME())

GO

CREATE TABLE WorksheetDetail (
  WorksheetDetailID int PRIMARY KEY IDENTITY(1, 1),
  WorksheetID int NOT NULL,
  WorkerID smallint NOT NULL,
  WorkID smallint,
  Quantity tinyint NOT NULL,
  WorkerDescription varchar(120),
  CompletionTime datetime
)
GO

CREATE TABLE Worker (
  WorkerID smallint PRIMARY KEY IDENTITY(1, 1),
  CustomerID int NOT NULL,
  ServiceCode int NOT NULL,
  isInternalWorker bit DEFAULT 1,
  isExternalWorker bit DEFAULT 0,
  IsActive bit DEFAULT 1 NOT NULL
)
GO

CREATE TABLE WorkerConnection (
  WorkerConnectionID int PRIMARY KEY IDENTITY(1, 1),
  PrincipalWorkerID smallint,
  WorkerID smallint,
  WorksheetID int
)
GO

CREATE TABLE WorkerRight (
  RightID smallint PRIMARY KEY IDENTITY(1, 1),
  ServiceCode int,
  SiteCode smallint,
  ISGlobalAdmin bit DEFAULT 0,
  IsAdmin bit DEFAULT 0,
  IsReader bit DEFAULT 0,
  IsWriter bit DEFAULT 0
)

GO

CREATE TABLE WorkerRightConnection (
  WorkerRightConnectionID int PRIMARY KEY IDENTITY(1, 1),
  WorkerID smallint NOT NULL,
  RightID smallint NOT NULL
)
GO

CREATE TABLE DictWorksheetStatus (
  StatusCode tinyint PRIMARY KEY IDENTITY(1, 1),
  StatusName varchar(120) NOT NULL UNIQUE,
  StatusNameDE varchar(120) NOT NULL UNIQUE,
  StatusNameEN varchar(120) NOT NULL UNIQUE
)
GO

CREATE TABLE AssetStock (
  AssetID int PRIMARY KEY IDENTITY(1, 1),
  ComponentID smallint NOT NULL,
  PurchaseID int NOT NULL,
  VatID tinyint NOT NULL,
  VatID2 tinyint NOT NULL,
  VatID3 tinyint NOT NULL,
  ServiceCode int,
  SiteCode smallint,
  SerialNumber varchar(100),
  WarrantyYear tinyint NOT NULL DEFAULT 1,
  ListPrice money,
  ListPrice2 money,
  ListPrice3 money,
  Quantity tinyint NOT NULL
)

-- For Stock SiteCode, or Service Code is mandantory!
ALTER TABLE AssetStock WITH CHECK ADD  CONSTRAINT CK_AssetStock_ServiceOrSiteCode CHECK  (ServiceCode IS NOT NULL OR SiteCode IS NOT NULL)

GO

CREATE TABLE AssetPurchase (
  PurchaseID int PRIMARY KEY IDENTITY(1, 1),
  PurchaseDate date DEFAULT SYSDATETIME() NOT NULL,
  BillNumber varchar(40) NOT NULL UNIQUE,
  BuyFrom int NOT NULL
)
GO

CREATE TABLE AssetComponent (
  ComponentID smallint PRIMARY KEY IDENTITY(1, 1),
  ComponentCode varchar(10) NOT NULL UNIQUE,
  ComponentName varchar(120) NOT NULL UNIQUE,
  ComponentNameDE varchar(120) NOT NULL UNIQUE,
  ComponentNameEN varchar(120) NOT NULL UNIQUE,
  SubCategoryID tinyint,
  SellPrice money,
  SellPrice2 money,
  SellPrice3 money,
  ModifiedDate datetime
)
GO

CREATE TABLE AssetComponentCategory (
  AssteCompontentCategoryID tinyint PRIMARY KEY IDENTITY(1, 1),
  CategoryName varchar(120) NOT NULL UNIQUE,
  CategoryNameDE nvarchar(120) NOT NULL UNIQUE,
  CategoryNameEN nvarchar(120) NOT NULL UNIQUE,
  ModifiedDate datetime
)
GO

CREATE TABLE AssetComponentSubcategory (
  SubcategoryID tinyint PRIMARY KEY IDENTITY(1, 1),
  AssteCompontentCategoryID tinyint,
  ComponentSubcategoryName varchar(120) NOT NULL UNIQUE,
  ComponentSubcategoryNameDE varchar(120) NOT NULL UNIQUE,
  ComponentSubcategoryNameEN varchar(120) NOT NULL UNIQUE,
  ModifiedDate datetime
)
GO

CREATE TABLE UsedComponent (
  WorksheetID int PRIMARY KEY,
  WorkerID smallint NOT NULL,
  AssetID int NOT NULL,
  Quantity tinyint NOT NULL
)
GO

CREATE TABLE Work (
  WorkID smallint PRIMARY KEY IDENTITY(1, 1),
  WorkCode varchar(10),
  WorkName varchar(120) NOT NULL UNIQUE,
  WorkNameDE varchar(120) NOT NULL UNIQUE,
  WorkNameEN varchar(120) NOT NULL UNIQUE,
  WorkSubCategoryID tinyint,
  iSHourlyWork bit DEFAULT 0,
  HourlyWorkPrice money,
  HourlyWorkPrice2 money,
  HourlyWorkPrice3 money,
  VatID tinyint NOT NULL,
  VatID2 tinyint NOT NULL,
  VatID3 tinyint NOT NULL,
  Price money,
  Price2 money,
  Price3 money
)
GO

CREATE TABLE WorkSubcategory (
  WorkSubcategoryID tinyint PRIMARY KEY IDENTITY(1, 1),
  WorkCategoryID tinyint,
  SubcategoryName varchar(120),
  SubcategoryNameDE varchar(120),
  SubcategoryNameEN varchar(120),
  ModifiedDate datetime
)
GO

CREATE TABLE WorkCategory (
  WorkCategoryID tinyint PRIMARY KEY IDENTITY(1, 1),
  CategoryName varchar(120),
  CategoryNameDE varchar(120),
  CategoryNameEN varchar(120),
  ModifiedDate datetime
)
GO

CREATE TABLE Bill (
  BillID int PRIMARY KEY IDENTITY(1, 1),
  WorksheetID int NOT NULL,
  SentStatus int DEFAULT 0,
  PaymmentStatus varchar(20),
  TS Timestamp
)
GO

CREATE TABLE DictVAT (
  VATID tinyint PRIMARY KEY IDENTITY(1, 1),
  VATName varchar(120) ,
  VATNameDE varchar(120) ,
  VATNameEN varchar(120) ,
  VATPercent decimal(3,3) NOT NULL UNIQUE,
  DateFrom Date,
  DateTo Date
)

ALTER TABLE DictVAT WITH CHECK ADD  CONSTRAINT CK_DictVAT_DateTo CHECK  (DateTo>DateFrom)


-- Add ForeignKey Constraints

ALTER TABLE Address ADD FOREIGN KEY (CountryCode) REFERENCES DictCountry (CountryCode)
GO

ALTER TABLE Worksheet ADD FOREIGN KEY (ServiceCode) REFERENCES Service (ServiceCode)
GO

ALTER TABLE Worker ADD FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID)
GO

ALTER TABLE Worker ADD FOREIGN KEY (ServiceCode) REFERENCES Service (ServiceCode)
GO

ALTER TABLE AssetComponent ADD FOREIGN KEY (SubCategoryID) REFERENCES AssetComponentSubcategory (SubcategoryID)
GO

ALTER TABLE UsedComponent ADD FOREIGN KEY (WorksheetID) REFERENCES Worksheet (WorksheetID)
GO

ALTER TABLE WorkerConnection ADD FOREIGN KEY (WorkerID) REFERENCES Worker (WorkerID)
GO

ALTER TABLE Worksheet ADD FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID)
GO

ALTER TABLE AssetPurchase ADD FOREIGN KEY (BuyFrom) REFERENCES Customer (CustomerID)
GO

ALTER TABLE AssetStock ADD FOREIGN KEY (ComponentID) REFERENCES AssetComponent (ComponentID)
GO

ALTER TABLE WorkerConnection ADD FOREIGN KEY (WorksheetID) REFERENCES Worksheet (WorksheetID)
GO

ALTER TABLE PostalCode ADD FOREIGN KEY (CountyID) REFERENCES DictCounty (CountyID)
GO

ALTER TABLE DictCounty ADD FOREIGN KEY (CountryCode) REFERENCES DictCountry (CountryCode)
GO

ALTER TABLE Address ADD FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID)
GO

ALTER TABLE Service ADD FOREIGN KEY (AddressID) REFERENCES Address (AddressId)
GO

ALTER TABLE Site ADD FOREIGN KEY (AddressID) REFERENCES Address (AddressId)
GO

ALTER TABLE AssetStock ADD FOREIGN KEY (PurchaseID) REFERENCES AssetPurchase (PurchaseID)
GO

ALTER TABLE UsedComponent ADD FOREIGN KEY (AssetID) REFERENCES AssetStock (AssetID)
GO

ALTER TABLE Site ADD FOREIGN KEY (ServiceCode) REFERENCES Service (ServiceCode)
GO

ALTER TABLE WorkerRightConnection ADD FOREIGN KEY (RightID) REFERENCES WorkerRight (RightID)
GO

ALTER TABLE WorkerRightConnection ADD FOREIGN KEY (WorkerID) REFERENCES Worker (WorkerID)
GO

ALTER TABLE WorksheetDetail ADD FOREIGN KEY (WorksheetID) REFERENCES Worksheet (WorksheetID)
GO

ALTER TABLE Bill ADD FOREIGN KEY (WorksheetID) REFERENCES Worksheet (WorksheetID)
GO

ALTER TABLE WorkerConnection ADD FOREIGN KEY (PrincipalWorkerID) REFERENCES Worker (WorkerID)
GO

ALTER TABLE AssetComponentSubcategory ADD FOREIGN KEY (AssteCompontentCategoryID) REFERENCES AssetComponentCategory (AssteCompontentCategoryID)
GO

ALTER TABLE Worksheet ADD FOREIGN KEY (WorksheetRecorderID) REFERENCES Worker (WorkerID)
GO

ALTER TABLE WorkSubcategory ADD FOREIGN KEY (WorkCategoryID) REFERENCES WorkCategory (WorkCategoryID)
GO

ALTER TABLE Work ADD FOREIGN KEY (WorkSubCategoryID) REFERENCES WorkSubcategory (WorkSubcategoryID)
GO

ALTER TABLE WorksheetDetail ADD FOREIGN KEY (WorkerID) REFERENCES Worker (WorkerID)
GO

ALTER TABLE Worksheet ADD FOREIGN KEY (StatusCode) REFERENCES DictWorksheetStatus (StatusCode)
GO

ALTER TABLE Worksheet ADD FOREIGN KEY (SiteCode) REFERENCES Site (SiteCode)
GO

ALTER TABLE WorksheetDetail ADD FOREIGN KEY (WorkID) REFERENCES Work (WorkID)
GO

ALTER TABLE AssetStock ADD FOREIGN KEY (ServiceCode) REFERENCES Service (ServiceCode)
GO

ALTER TABLE AssetStock ADD FOREIGN KEY (SiteCode) REFERENCES Site (SiteCode)
GO

ALTER TABLE UsedComponent ADD FOREIGN KEY (WorkerID) REFERENCES Worker (WorkerID)
GO

ALTER TABLE AssetStock ADD FOREIGN KEY (VatID) REFERENCES DictVAT (VATID)
GO

ALTER TABLE Work ADD FOREIGN KEY (VatID) REFERENCES DictVAT (VATID)
GO

ALTER TABLE Work ADD FOREIGN KEY (VatID2) REFERENCES DictVAT (VATID)
GO

ALTER TABLE Work ADD FOREIGN KEY (VatID3) REFERENCES DictVAT (VATID)
GO

ALTER TABLE AssetStock ADD FOREIGN KEY (VatID2) REFERENCES DictVAT (VATID)
GO

ALTER TABLE AssetStock ADD FOREIGN KEY (VatID3) REFERENCES DictVAT (VATID)
GO

/* Functions */

-- Generate the next WorksheetNumber
GO

CREATE FUNCTION dbo.GenerateWorksheetNumber (@prefix VARCHAR(3))
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @counter INT
    SELECT @counter = MAX(CAST(RIGHT(WorksheetNumber, LEN(WorksheetNumber) - LEN(@prefix)) AS INT))
    FROM dbo.Worksheet
    WHERE LEFT(WorksheetNumber, LEN(@prefix)) = @prefix

    IF @counter IS NULL
        SET @counter = 1
    ELSE
        SET @counter = @counter + 1

    RETURN @prefix + RIGHT('0000000' + CAST(@counter AS VARCHAR(7)), 7)
END

GO
SELECT dbo.GenerateWorksheetNumber('WS-')

/* Stored Procedures*/

-- StoredProcedure - CreateInternalWorksheet 
GO

CREATE OR ALTER PROCEDURE CreateInternalWorksheet 
@Worksheetrecorder int,
@CustomerID int,
@SiteCode int,
@ExteranJobDescription varchar(120),
@DeviceName varchar(120),
@DeviceSerialNummber varchar(100),
@JobDescription varchar(120),
@ServiceCode int

AS
BEGIN
	DECLARE @Worksheetnumber varchar(10)
	SET @Worksheetnumber = (SELECT dbo.GenerateWorksheetNumber('WS-'))
	INSERT INTO dbo.Worksheet VALUES(@Worksheetrecorder,@CustomerID,@SiteCode,@Worksheetnumber,0,@ExteranJobDescription,SYSDATETIME(),@DeviceName,@DeviceSerialNummber,@JobDescription,@ServiceCode,0,0,NULL,NULL)
END

-- Stored Procedure WorksheetBasicData
GO 

CREATE OR ALTER PROCEDURE WorksheetBasicData 
@Worksheetnumber varchar(10)
AS
SELECT * FROM Worksheet W
INNER JOIN Service S ON W.ServiceCode = S.ServiceCode
INNER JOIN Worker WK ON WK.WorkerID = WorksheetRecorderID
INNER JOIN Customer C ON C.CustomerID = W.CustomerID
WHERE WorksheetNumber = @Worksheetnumber

GO

-- StoredProcedure GetUsedComponentsByWorksheetNumber
GO

CREATE OR ALTER PROCEDURE GetUsedComponentsByWorksheetNumber
@Worksheetnumber varchar(10)
AS
SELECT
W.WorksheetNumber ,CONCAT (C.LastName + ' ', C.MiddleName + ' ' + C.FirstName)  AS WorkerName, AC.ComponentName ,AST.SerialNumber
FROM Worksheet W
INNER JOIN UsedComponent UC ON UC.WorksheetID = W.WorksheetID
INNER JOIN AssetStock AST ON AST.AssetID = UC.AssetID
INNER JOIN AssetComponent AC ON AC.ComponentID = AST.ComponentID
INNER JOIN Worker WR ON WR.WorkerID = UC.WorkerID
INNER JOIN Customer C ON C.CustomerID = WR.CustomerID
WHERE WorksheetNumber = @Worksheetnumber
GO

-- Stored Procedure GetWorksByWorksheetNumber
GO

CREATE OR ALTER PROCEDURE GetWorksByWorksheetNumber
@Worksheetnumber varchar(10)
AS
SELECT
W.WorksheetNumber,CONCAT (C.LastName + ' ', C.MiddleName + ' ' + C.FirstName)  AS WorkerName,
WO.WorkName AS WorkName, WO.Price,WO.HourlyWorkPrice,WD.Quantity,
CASE 
	WHEN
	WO.iSHourlyWork = 0 THEN WO.Price
	ELSE WO.HourlyWorkPrice * WD.Quantity
END
AS Price, WD.WorkerDescription
FROM Worksheet W
LEFT JOIN WorksheetDetail WD ON WD.WorksheetID = W.WorksheetID
LEFT JOIN Work WO ON WO.WorkID = WD.WorkID
LEFT JOIN Worker WR ON WR.WorkerID = WD.WorkerID
LEFT JOIN Customer C ON C.CustomerID = WR.CustomerID
WHERE WorksheetNumber = @Worksheetnumber
GO

/* Data upload testing ...*/

GO

INSERT INTO dbo.DictCountry VALUES ('HU','Magyarország')
INSERT INTO dbo.DictCountry VALUES ('AT','Ausztria')
INSERT INTO dbo.DictCountry VALUES ('GB','Anglia')

INSERT INTO dbo.DictCounty VALUES  ('HU', 'Zala')


GO
INSERT INTO dbo.Address  VALUES (NULL,0,1,0,'HU','8315','Gyenesdiás','Kossuth u. 12.','',GETDATE(),NULL)
INSERT INTO dbo.Address  VALUES (NULL,0,1,0,'HU','8360','Keszthely','Tapolcai út. 74.','',GETDATE(),NULL)
INSERT INTO dbo.Address  VALUES (NULL,0,1,0,'HU','8380','Hévíz','Tavirózsa u. 1.','',GETDATE(),NULL)

-- Add Service
INSERT INTO dbo.Service VALUES ('Visionet Kft.',3,'+36 20 348-1071','info@visionet.hu',GETDATE(),NULL)

-- Add Site for service
INSERT INTO Site VALUES ('1','1','Visionet 2. - Gyenesdiás','+36 000','gyenes@visionet.hu',1,GETDATE(),NULL)
INSERT INTO Site VALUES ('2','1','Visionet 3. - Keszthely','+36 001','keszthely@visionet.hu',2,GETDATE(),NULL)

-- Add another service maybe StoredProcedure later ...

GO
INSERT INTO dbo.Address (CustomerID,CountryCode,PostalCode,CityName,AddressLine1,Addressline2,AddressFrom,AddressTo) VALUES (NULL,'HU','8360','Keszthely','Deák Ferenc u. 1.','',GETDATE(),NULL)
DECLARE @AddressID int 
SET @AddressID = SCOPE_IDENTITY () 
SELECT @AddressID
INSERT INTO dbo.Service VALUES ('Commtech 96 Kft.',@AddressID,'+36 83 111-222','info@commtech.hu',GETDATE(),NULL)


-- Get All Service
--SELECT * FROM Service

-- Get All Site by ServiceName for example

SELECT SE.ServiceName,SiteName, S.PhoneNumber, S.Email,A.CountryCode, A.PostalCode, A.CityName,A.AddressLine1 FROM Service SE
INNER JOIN Site S ON S.ServiceCode = S.ServiceCode
INNER JOIN Address A ON A.AddressId = S.AddressID
WHERE SE.ServiceName LIKE '%Visionet%'
ORDER BY SE.ServiceName

-- CustomerCreate Procedure later ...

-- Multiple Address with different AddressType

INSERT INTO Customer VALUES ('Adrienn','','Horvath','hadri83@gmail.com','1','1234','+3620 348-1072',NULL,'0','0',NULL,0,'0',NULL,'0',NULL)
DECLARE @CustomerID int 
SET @CustomerID = SCOPE_IDENTITY ()
INSERT INTO dbo.Address (CustomerID,isMailingAddress,isPrimaryAddress,isBillingAddress,CountryCode,PostalCode,CityName,AddressLine1,Addressline2,AddressFrom,AddressTo) VALUES (@CustomerID,0,1,0,'HU','8315','Gyenesdiás','Lõtéri u. 9.','',GETDATE(),NULL)
INSERT INTO dbo.Address (CustomerID,isMailingAddress,isPrimaryAddress,isBillingAddress,CountryCode,PostalCode,CityName,AddressLine1,Addressline2,AddressFrom,AddressTo) VALUES (@CustomerID,1,0,0,'HU','8360','Keszthely','Petõfi u. 10.','',GETDATE(),NULL)
INSERT INTO dbo.Address (CustomerID,isMailingAddress,isPrimaryAddress,isBillingAddress,CountryCode,PostalCode,CityName,AddressLine1,Addressline2,AddressFrom,AddressTo) VALUES (@CustomerID,0,0,1,'HU','8315','Gyenesdiás','Faludy u. 11.','',GETDATE(),NULL)
GO

-- Check it

-- AllAddress
SELECT * FROM Address A INNER JOIN Customer C ON C.CustomerID = A.CustomerID WHERE C.CustomerID=1

-- Billing Address
SELECT * FROM Address A INNER JOIN Customer C ON C.CustomerID = A.CustomerID WHERE C.CustomerID=1 AND A.isBillingAddress =1

-- Mailing Address
SELECT * FROM Address A INNER JOIN Customer C ON C.CustomerID = A.CustomerID WHERE C.CustomerID=1 AND A.isMailingAddress =1


INSERT INTO Customer VALUES ('Attila','','Horvath','atiradeon86@gmail.com','1','12345','+3620 348-1070',NULL,'0','0',NULL,1,'0',NULL,'0',NULL)
DECLARE @CustomerID int 
SET @CustomerID = SCOPE_IDENTITY () 
SELECT @CustomerID
INSERT INTO dbo.Address (CustomerID,CountryCode,PostalCode,CityName,AddressLine1,Addressline2,AddressFrom,AddressTo) VALUES (@CustomerID,'HU','8360','Keszthely','Kossuth u. 9.','',GETDATE(),NULL)

GO

INSERT INTO Customer VALUES ('Elek','','Teszt','tesz.elek@gmail.com','1','123','+3620 148-1070',NULL,'0','0',NULL,0,'0',NULL,'0',NULL)
DECLARE @CustomerID int 
SET @CustomerID = SCOPE_IDENTITY () 
SELECT @CustomerID
INSERT INTO dbo.Address (CustomerID,CountryCode,PostalCode,CityName,AddressLine1,Addressline2,AddressFrom,AddressTo) VALUES (@CustomerID,'HU','8315','Gyenesdiás','Petõfi u. 9.','',GETDATE(),NULL)

GO

INSERT INTO Customer VALUES ('Kiss','','István','kiss.istvan@gmail.com','1','123','+3620 148-3070',NULL,'0','0',NULL,0,'0',NULL,'0',NULL)
DECLARE @CustomerID int 
SET @CustomerID = SCOPE_IDENTITY () 
SELECT @CustomerID
INSERT INTO dbo.Address (CustomerID,CountryCode,PostalCode,CityName,AddressLine1,Addressline2,AddressFrom,AddressTo) VALUES (@CustomerID,'HU','8315','Gyenesdiás','Petõfi u. 9.','',GETDATE(),NULL)

-- Add More Address for customer
INSERT INTO dbo.Address (CustomerID,CountryCode,PostalCode,CityName,AddressLine1,Addressline2,AddressFrom,AddressTo) VALUES ('2','HU','8313','Balatongyörök','Kossuth u. 42.','',GETDATE(),NULL)

--Debug - Check it! (CustomerID2 = Horváth Attila)
SELECT C.CustomerID,CONCAT (C.LastName + ' ', C.MiddleName + ' ' + C.FirstName)  AS Customername, A.PostalCode, A.CityName, A.AddressLine1, A.AddressFrom, A.AddressTo FROM Customer C
INNER JOIN dbo.Address A ON A.CustomerID = C.CustomerID 
WHERE C.FirstName = 'Attila'

-- SELECT * FROM Customer
-- SELECT * FROM Address

-- Worker Registration (From existing customer, customer basedata required for Worker registration!)
-- Add Worker (Worker ID 2 = Horváth Attila), Pl. Dropdonw + Select -> CustomerID

INSERT INTO Worker VALUES (2,1,1,0,1)
INSERT INTO Worker VALUES (4,1,1,0,1)

--SELECT * FROM Worker

-- Create Worker Right (Global Admin)

INSERT INTO WorkerRight VALUES(1,NULL,1,0,0,0)
DECLARE @RightID int 
SET @RightID = SCOPE_IDENTITY () 
SELECT @RightID

-- Insert to WorkeRightConnection
GO
DECLARE @WorkRightID int 
SET @WorkRightID = SCOPE_IDENTITY () 
SELECT @WorkRightID
INSERT INTO WorkerRightConnection VALUES (1,@WorkRightID)

--- Create antoher Worke Right to user
-- Create Right ( Read for Comtech ServiceCode -> 2)

INSERT INTO WorkerRight VALUES(2,NULL,0,0,1,0)
DECLARE @RightID int 
SET @RightID = SCOPE_IDENTITY () 
SELECT @RightID

-- Insert to WorkeRightConnection
GO
DECLARE @WorkRightID int 
SET @WorkRightID = SCOPE_IDENTITY () 
SELECT @WorkRightID
INSERT INTO WorkerRightConnection VALUES (1,@WorkRightID)

-- Debug - Get User Rights
SELECT S.ServiceName,CONCAT (C.LastName + ' ', C.MiddleName + ' ' + C.FirstName),WR.IsAdmin,WR.IsGlobalAdmin,WR.IsReader,WR.IsWriter  AS IsWriter,WR.ServiceCode FROM Worker W 
INNER JOIN WorkerRightConnection WRC ON WRC.WorkerID = W.WorkerID
INNER JOIN WorkerRight WR ON WR.RightID = WRC.RightID
INNER JOIN Service S ON S.ServiceCode = WR.ServiceCode
INNER JOIN Customer C ON C.CustomerID = W.CustomerID

-- Create status codes

INSERT INTO DictWorksheetStatus VALUES('Nyitott','Offen','Open')
INSERT INTO DictWorksheetStatus VALUES('Zárt','Gesperrt','Closed')
INSERT INTO DictWorksheetStatus VALUES('Folyamatban','In Bearbeitung','In progress')

--SELECT * FROM DictWorksheetStatus

-- Createting Work categories

GO
INSERT INTO WorkCategory VALUES ('Informatika','IT','EDV',NULL)
INSERT INTO WorkCategory VALUES ('Elektronika','Electronics','Elektronik',NULL)

-- Createting Work Subcategories

INSERT INTO WorkSubCategory VALUES (1,'Belsõ','Interne Dienstleistungen','Internal Services',NULL)
INSERT INTO WorkSubCategory VALUES (1,'Külsõ','Externe Dienstleistungen','External Services',NULL)


INSERT INTO WorkSubCategory VALUES (2,'Belsõ','Interne Dienstleistungen','Internal Services',NULL)
INSERT INTO WorkSubCategory VALUES (2,'Külsõ','Externe Dienstleistungen','External Services',NULL)


-- SELECT * FROM WorkCategory W INNER JOIN WorkSubcategory WS ON WS.WorkCategoryID = W.WorkCategoryID

-- Creating Vat data
INSERT INTO DictVAT VALUES ('25%',NULL,NULL,0.250,'1988-01-01',NULL)
INSERT INTO DictVAT VALUES ('20%',NULL,NULL,0.200,'1988-01-01',NULL)

-- SELECT * FROM DictVAT

-- Createing Works

INSERT INTO Work VALUES('SSD-01','SSD csere','SSD Austausch','SSD Replace',1,0,NULL,NULL,NULL,1,2,2,3000,10,10)
INSERT INTO Work VALUES('HDD-01','HDD csere','HDD Austausch','HDD Replace',1,0,NULL,NULL,NULL,1,2,2,3000,10,10)
INSERT INTO Work VALUES('INS-01','Linux telepítés','Linux Installation','Linux Install',1,0,NULL,NULL,NULL,1,2,2,6000,20,20)
INSERT INTO Work VALUES('INSP-01','Bevizsgálás','Inspektion','Inspection',1,1,3000,20,20,1,2,2,NULL,NULL,NULL)
INSERT INTO Work VALUES('SWI-01','Szoftver telepítés','App Installation','Application Innstal',1,1,3000,20,20,1,2,2,NULL,NULL,NULL)

INSERT INTO Work VALUES('GPON-01','GPON Internet bekötés -1 Gigabit/s','GPON Internet installation -1 Gigabit/s','GPON Internet Installation -1 Gigabit/s',2,0,NULL,NULL,NULL,1,2,2,10000,40,40)
INSERT INTO Work VALUES('DSL-01','DSL Internet bekötés -10 Megabit/s','DSL Internet installation -10 Megabit/s','DSL Internet Installation -10 Megabit/s',2,0,NULL,NULL,NULL,1,2,2,10000,40,40)

INSERT INTO Work VALUES('T-01','Tápegység csere','Netzteils Austausch','Powersupply replacement',3,0,NULL,NULL,NULL,1,2,2,5000,20,20)
INSERT INTO Work VALUES('F-01','Fejállomás építés','Kopfstation Bau','Headstation construction',4,0,NULL,NULL,NULL,1,2,2,15000,40,40)

GO

-- IT Works
SELECT * FROM Work W 
INNER JOIN WorkSubcategory WS ON WS.WorkSubcategoryID = W.WorkSubCategoryID
INNER JOIN WorkCategory WC ON WC.WorkCategoryID = WS.WorkCategoryID
WHERE WC.WorkCategoryID = 1

-- All Intern IT Works

SELECT * FROM Work W 
INNER JOIN WorkSubcategory WS ON WS.WorkSubcategoryID = W.WorkSubCategoryID
INNER JOIN WorkCategory WC ON WC.WorkCategoryID = WS.WorkCategoryID
WHERE WC.WorkCategoryID = 1 AND WS.WorkSubcategoryID = 1

-- All External IT Works

SELECT * FROM Work W 
INNER JOIN WorkSubcategory WS ON WS.WorkSubcategoryID = W.WorkSubCategoryID
INNER JOIN WorkCategory WC ON WC.WorkCategoryID = WS.WorkCategoryID
WHERE WC.WorkCategoryID = 1 AND WS.WorkSubcategoryID = 2

-- Electronic Works
SELECT * FROM Work W 
INNER JOIN WorkSubcategory WS ON WS.WorkSubcategoryID = W.WorkSubCategoryID
INNER JOIN WorkCategory WC ON WC.WorkCategoryID = WS.WorkCategoryID
WHERE WC.WorkCategoryID = 2

-- Intern Electronic Works
SELECT * FROM Work W 
INNER JOIN WorkSubcategory WS ON WS.WorkSubcategoryID = W.WorkSubCategoryID
INNER JOIN WorkCategory WC ON WC.WorkCategoryID = WS.WorkCategoryID
WHERE WC.WorkCategoryID = 2 AND WS.WorkSubcategoryID = 3

-- External Electronic Works
SELECT * FROM Work W 
INNER JOIN WorkSubcategory WS ON WS.WorkSubcategoryID = W.WorkSubCategoryID
INNER JOIN WorkCategory WC ON WC.WorkCategoryID = WS.WorkCategoryID
WHERE WC.WorkCategoryID = 2 AND WS.WorkSubcategoryID = 4


-- Createing new Worksheet (Worker ID1 = Horváth Attila)

GO

--INSERT INTO dbo.Worksheet VALUES(1,1,NULL,'WS-000001',0,NULL,SYSDATETIME(),'Acer Nitro Notebook',NULL,'Nem indul a windows, linux telepítést kértek (Debian-t)',1,0,0,NULL,NULL)
EXEC CreateInternalWorksheet 1,1,NULL,NULL,'Acer Nitro Notebook',NULL,'Nem indul a windows, linux telepítést kértek (Debian-t)',1


--INSERT INTO dbo.Worksheet VALUES(1,1,NULL,'WS-000002',0,NULL,SYSDATETIME(),'Asus TUF Gaming Notebook','SN-000123','SSD cserét kértek, és windows telepítést',1,0,0,NULL,NULL)
EXEC CreateInternalWorksheet 1,1,NULL,NULL,'Asus TUF Gaming Notebook','SN-000123','SSD cserét kértek, és windows telepítést',1


GO
--SELECT * FROM Worksheet

-- Get Basic Worksheet Data

EXEC WorksheetBasicData @Worksheetnumber='WS-0000001'
EXEC WorksheetBasicData @Worksheetnumber='WS-0000002'


SELECT * FROM WorksheetDetail

INSERT INTO WorksheetDetail VALUES(1,1,4,1,'Hát igen a Windows az egy csoda ...',SYSDATETIME())
INSERT INTO WorksheetDetail VALUES(1,1,3,1,'Végre egy értelmes munka ... ',SYSDATETIME())
INSERT INTO WorksheetDetail VALUES(1,2,5,2,'Junior még a kolléga, nemgond legalább lesz bevétel ... :)',SYSDATETIME())

-- WS-02 

INSERT INTO WorksheetDetail VALUES(2,1,1,1,NULL,NULL)
INSERT INTO WorksheetDetail VALUES(2,2,5,2,NULL,NULL)


-- Get Works BY Worksheet Number

EXEC GetWorksByWorksheetNumber @Worksheetnumber ='WS-0000001'
EXEC GetWorksByWorksheetNumber @Worksheetnumber ='WS-0000002'

-- Adding B2B Partners

GO

INSERT INTO Customer VALUES (NULL,NULL,NULL,'sales@caseking.hu',NULL,NULL,'+36 1 270-9393',NULL,0,0,NULL,0,0,NULL,'1','Caseking Hungary Kft.')
DECLARE @CustomerID int 
SET @CustomerID = SCOPE_IDENTITY () 
SELECT @CustomerID
INSERT INTO dbo.Address (CustomerID,CountryCode,PostalCode,CityName,AddressLine1,Addressline2,AddressFrom,AddressTo) VALUES (@CustomerID,'HU','1139','Budapest','Váci út 95','',GETDATE(),NULL)

GO

INSERT INTO Customer VALUES (NULL,NULL,NULL,'info@ipon.hu',NULL,NULL,'+36 1 556 6565',NULL,0,0,NULL,0,0,NULL,'1','iPon Computer Kft.')
DECLARE @CustomerID int 
SET @CustomerID = SCOPE_IDENTITY () 
SELECT @CustomerID
INSERT INTO dbo.Address (CustomerID,CountryCode,PostalCode,CityName,AddressLine1,Addressline2,AddressFrom,AddressTo) VALUES (@CustomerID,'HU','1134','Budapest','Tüzér u. 13','',GETDATE(),NULL)

-- Get All B2B Partner
SELECT C.B2bPartnerName, C.PhoneNumber, C.Email, CONCAT(A.PostalCode,+ ' ' ,A.CityName + ' ', A.AddressLine1) 
FROM Customer C 
INNER JOIN Address A ON A.CustomerID = C.CustomerID WHERE isB2bParnter =  1

-- Creating Asset Categories 

INSERT INTO AssetComponentCategory VALUES ('Informatikai alkatrész','IT-Komponente','IT component',NULL)
INSERT INTO AssetComponentCategory VALUES ('Szerviz alkatrész','Service Komponent','Service part',NULL)

INSERT INTO AssetComponentSubcategory VALUES(1,'Alaplap','Mainboard','Motherboard',NULL)
INSERT INTO AssetComponentSubcategory VALUES(1,'Processzor','Prozessoren','Central Processing Unit',NULL)
INSERT INTO AssetComponentSubcategory VALUES(1,'Memória','Speicher','Memory',NULL)
INSERT INTO AssetComponentSubcategory VALUES(1,'SSD','SSD Laufwerk','SSD Drive',NULL)
INSERT INTO AssetComponentSubcategory VALUES(1,'Kiegészítõ','Zusätzlich','Additional',NULL)

INSERT INTO AssetComponentSubcategory VALUES(2,'Alapvetõ','Basis','Basic',NULL)
INSERT INTO AssetComponentSubcategory VALUES(2,'Speciális','Speziell','Special',NULL)

-- Get all Assetcategory with Subcategory

SELECT AC.AssteCompontentCategoryID AS CategoryID,AC.CategoryName,AC.CategoryNameDE,AC.CategoryNameEN,ACS.SubcategoryID,ACS.ComponentSubcategoryName,ACS.ComponentSubcategoryNameDE,ACS.ComponentSubcategoryNameEN 
FROM AssetComponentSubcategory ACS 
INNER JOIN AssetComponentCategory AC ON ACS.AssteCompontentCategoryID = AC.AssteCompontentCategoryID 
ORDER BY 1,3

-- Createing AssetComponent

INSERT INTO AssetComponent VALUES ('SSD-001','WD SN750 NVMe 1TB SSD meghajtó','WD SN750 NVMe 1TB SSD laufwerk', 'WD SN750 NVMe 1TB SSD Drive',4,60000,150,150,NULL)

SELECT * FROM AssetComponent

-- Creating Asset Buy data

INSERT INTO AssetPurchase VALUES ('20230318','SZLA007',5)
INSERT INTO AssetPurchase VALUES ('20230318','SZLA008',6)
INSERT INTO AssetPurchase VALUES ('20230318','VMI006',5)

-- SELECT * FROM AssetPurchase
-- SELECT * FROM Customer


-- Insereting Asset Stock (WD SN750 NVMe 1TB SSD Drive, Commtech Service) 

INSERT INTO AssetStock VALUES (1,1,1,2,2,2,NULL,123456,3,20000,50,50,1)
INSERT INTO AssetStock VALUES (1,1,1,2,2,2,NULL,7891011,3,20000,50,50,1)
INSERT INTO AssetStock VALUES (1,2,1,2,2,2,NULL,7891011,3,20000,50,50,1)


-- Get Stock elements By Component ID (For exampl 1 = WD SN750 NVMe 1TB SSD)

SELECT S.AssetID,C.B2bPartnerName AS BuyFromB2B,AP.PurchaseDate,SR.ServiceName,AP.BillNumber,S.SerialNumber,AC.ComponentName,S.ListPrice,S.VatID,S.VatID2,S.VatID3, AC.SellPrice 
FROM AssetStock S
INNER JOIN AssetComponent AC ON AC.ComponentID = S.ComponentID
INNER JOIN AssetPurchase AP ON AP.PurchaseID = S.PurchaseID
INNER JOIN Service SR ON SR.ServiceCode = S.ServiceCode
INNER JOIN Customer C ON C.CustomerID = AP.BuyFrom
INNER JOIN DictVAT DV ON DV.VATID = S.VatID
WHERE Quantity <> 0 AND AC.ComponentID = 1

-- Add used asset to worksheet, and update stock value

INSERT INTO UsedComponent VALUES (2,1,2,1)
UPDATE AssetStock SET Quantity =0 WHERE AssetID = 2 

-- SELECT * FROM UsedComponent

-- Get Used Asset Data - with used asset)

EXEC GetUsedComponentsByWorksheetNumber @Worksheetnumber ='WS-0000002'