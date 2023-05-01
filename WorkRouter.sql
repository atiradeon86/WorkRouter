-- WorkRouter V0.4
-- DBdiagram: https://dbdiagram.io/d/63f22373296d97641d82122c
-- This SQL script creates the database structure with randomly generated test data (Unique Customers,Addresses,Worksheets,Works)

CREATE DATABASE WorkRouter
GO

USE WorkRouter
GO

CREATE TABLE Customer (
  CustomerID int PRIMARY KEY IDENTITY(1, 1),
  FirstName varchar(30),
  MiddleName varchar(30),
  LastName varchar(30),
  Email varchar(90) UNIQUE,
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
  VatIdDE tinyint NOT NULL,
  VatIdEN tinyint NOT NULL,
  ServiceCode int,
  SiteCode smallint,
  SerialNumber varchar(100),
  WarrantyYear tinyint NOT NULL DEFAULT 1,
  ListPrice money,
  ListPriceDE money,
  ListPriceEN money,
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
  SellPriceDE money,
  SellPriceEN money,
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
  HourlyWorkPriceDE money,
  HourlyWorkPriceEN money,
  VatID tinyint NOT NULL,
  VatIdDE tinyint NOT NULL,
  VatIdEN tinyint NOT NULL,
  Price money,
  PriceDE money,
  PriceEN money
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
  WorksheetID int PRIMARY KEY,
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

ALTER TABLE Work ADD FOREIGN KEY (VatIdDE) REFERENCES DictVAT (VATID)
GO

ALTER TABLE Work ADD FOREIGN KEY (VatIdEN) REFERENCES DictVAT (VATID)
GO

ALTER TABLE AssetStock ADD FOREIGN KEY (VatIdDE) REFERENCES DictVAT (VATID)
GO

ALTER TABLE AssetStock ADD FOREIGN KEY (VatIdEN) REFERENCES DictVAT (VATID)
GO

/* Trigger */

/* Creating Bill Base Data if we have a new worksheet*/


CREATE OR ALTER TRIGGER BillBaseData  
ON Worksheet  
AFTER INSERT    
AS 
DECLARE @LastWorksheetID int
SET @LastWorksheetID = (SELECT MAX(WorksheetId) FROM Worksheet)
INSERT INTO Bill(WorksheetID,SentStatus) VALUES(@LastWorksheetID,0) 

GO


/* Functions */

-- Generate the next WorksheetNumber
GO

CREATE OR ALTER FUNCTION dbo.GenerateWorksheetNumber (@prefix VARCHAR(5))
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

    RETURN @prefix + RIGHT('000000' + CAST(@counter AS VARCHAR(6)), 6)
END

GO

/* Stored Procedures*/

-- StoredProcedure - CreateWorksheet 
GO

CREATE OR ALTER PROCEDURE CreateWorksheet 
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
	DECLARE @CountryCode char(2)
	SET @CountryCode = (SELECT DISTINCT A.CountryCode FROM Service S 
	INNER JOIN Address A ON A.AddressId = S.AddressID 
	WHERE S.ServiceCode = @ServiceCode)  
	DECLARE @pr varchar(5)
	SET @pr = CONCAT('WS-', @CountryCode)
	DECLARE @Worksheetnumber varchar(12)
	SET @Worksheetnumber = (SELECT dbo.GenerateWorksheetNumber(@pr))
	INSERT INTO dbo.Worksheet VALUES(@Worksheetrecorder,@CustomerID,@SiteCode,@Worksheetnumber,0,@ExteranJobDescription,SYSDATETIME(),@DeviceName,@DeviceSerialNummber,@JobDescription,@ServiceCode,0,0,NULL,NULL)

END


-- Stat Worksheet (Year, Service, Worksheet Number)

GO

CREATE OR ALTER VIEW vStatWorksheet
AS 
SELECT *
FROM (
  SELECT S.ServiceName, YEAR(W.TimeOfIssue) AS Year, COUNT(WorksheetID) AS AllWorksheet 
  FROM Worksheet W 
  INNER JOIN Service S ON S.ServiceCode = W.ServiceCode 
  WHERE YEAR(W.TimeOfIssue) BETWEEN 2015 AND 2023 
  GROUP BY S.ServiceCode, S.ServiceName, YEAR(W.TimeOfIssue)
) AS DataSource
PIVOT (
  SUM(AllWorksheet)
  FOR Year IN ([2015],[2016],[2017],[2018],[2019], [2020], [2021], [2022], [2023])
) AS WorksheetStat;

-- SELECT * FROM vStatWorksheet

-- Stat BuyerCard (Customer, Worksheet Number)

GO

CREATE OR ALTER VIEW vStatCustomerBuyerCard
AS
SELECT  W.CustomerID, CONCAT (C.LastName, ' ', C.FirstName) AS CustomName,CONCAT (A.PostalCode, ' ,', A.CityName, ' ,', A.AddressLine1) AS CustomerAddress, C.Email,C.PhoneNumber, Count(WorksheetID) AS Worksheets,HasBuyerCard AS BuyerCard FROM Worksheet W
INNER JOIN Customer C ON C.CustomerID = W.CustomerID
INNER JOIN Service S ON S.ServiceCode = W.ServiceCode
INNER JOIN Address A ON A.CustomerID = W.CustomerID
GROUP BY W.CustomerID,CONCAT (C.LastName, ' ', C.FirstName), A.PostalCode,A.CityName,A.AddressLine1, C.Email,C.PhoneNumber, C.HasBuyerCard

-- SELECT * FROM vStatCustomerBuyerCard ORDER BY 6 DESC

-- Stat BuyerCard (Customer Number / City)

GO

CREATE OR ALTER VIEW vStatCustomerCity
AS
SELECT PC.CityName, COUNT(C.CustomerID) AS CustomerNumber FROM PostalCode PC
INNER JOIN Address A ON A.PostalCode = PC.PostalCode
INNER JOIN Customer C ON C.CustomerID = A.CustomerID
GROUP BY PC.CityName

-- SELECT * FROM vStatCustomerCity ORDER BY 2 DESC

-- Stat BuyerCard (Customer Number / County)

GO

CREATE OR ALTER VIEW vStatCustomerCounty
AS
SELECT DC.CountyName, COUNT(DISTINCT(C.CustomerID)) AS CustomerNumber FROM PostalCode PC
INNER JOIN Address A ON A.PostalCode = PC.PostalCode
INNER JOIN Customer C ON C.CustomerID = A.CustomerID
INNER JOIN DictCounty DC ON DC.CountyID = PC.CountyID
GROUP BY DC.CountyName

-- SELECT * FROM vStatCustomerCounty ORDER BY 2 DESC

GO

CREATE OR ALTER VIEW vRandomDeviceType
AS SELECT TOP 1 value FROM STRING_SPLIT('Asus PC,Lenovo PC,Acer Nitro5 Notebook,Asus ROG Zephyrus G15,Asus ROG Zephyrus G17', ',') order by newid()

-- SELECT * FROM vRandomDeviceType
GO
CREATE OR ALTER VIEW vRandomJobDescription
AS SELECT TOP 1 value FROM STRING_SPLIT('Nem indul a windows 10,Nem indul a windows 11,Túl lassú a gép,Office telepítést kértek,Linux telepítést kértek adatmentéssel', ',') order by newid()

-- SELECT * FROM vRandomJobDescription

GO
CREATE OR ALTER VIEW vRandomExternalJobDescription
AS SELECT TOP 1 value FROM STRING_SPLIT('Internet bekötés,Fejállomás építés', ',') order by newid()

-- SELECT * FROM vRandomExternalJobDescription

GO
CREATE OR ALTER VIEW vRandomWorkerDescription
AS SELECT TOP 1 value FROM STRING_SPLIT('Valami megjegyzés .,Valami megjegyzés ..,Valami megjegyzés ...', ',') order by newid()

-- SELECT * FROM vRandomWorkerDescription

GO
CREATE OR ALTER VIEW vRandomStreet
AS SELECT TOP 1 value FROM STRING_SPLIT('Kossuth u.,Petõfi u.,Arany János u.,Petõfi u.,Rákóczi u.,József Attila u.,Béke u.,Szabadság u.', ',') order by newid()

-- SELECT * FROM vRandomStreet

GO
CREATE OR ALTER VIEW vRandomMailProvider
AS SELECT TOP 1 value FROM STRING_SPLIT('@gmail.com,@hotmail.com,@citromail.hu,@freemail.hu,@protonmail.com,@outlook.com,@onmicrosoft.com', ',') order by newid()

-- SELECT * FROM vRandomMailProvider


-- Creating Usable random function

GO

CREATE OR ALTER VIEW vRand
AS 
SELECT rand() AS rRand

GO

CREATE OR ALTER FUNCTION dbo.ReturnRand()
RETURNS REAL
AS
BEGIN
	DECLARE @R REAL
	SET @R = (SELECT rRand FROM vRand)
	return @R
END

GO

-- Return Random int Function (in range)
GO

CREATE OR ALTER FUNCTION dbo.ReturnRandFromTo (@From int, @To int)
RETURNS INT
AS
BEGIN
	DECLARE @RandInt int
	SET @RandInt = (SELECT FLOOR(dbo.ReturnRand() * (@To-@From + 1)) + @From)
RETURN (@RandInt)
END

-- SELECT dbo.ReturnRandFromTo(1,5)


GO
-- Create RandomDateTime Function

CREATE OR ALTER FUNCTION dbo.RandomDateTime (@FromDate DATETIME,@ToDate DATETIME) 
RETURNS datetime
AS
BEGIN
	DECLARE @RadomizedDateTime DATETIME
	DECLARE @Seconds INT = DATEDIFF(SECOND, @FromDate, @ToDate)
	DECLARE @Random INT = ROUND(((@Seconds-1) * dbo.ReturnRand()), 0)
	SET @RadomizedDateTime = (SELECT DATEADD(SECOND, @Random, @FromDate))

	RETURN(@RadomizedDateTime)
END

-- Stored Procedure AddRandomWorkToWorksheet ( In this case i need the work completion time. In base case the CompletionTime is the actual SYSDATETIME() )
GO

CREATE OR ALTER PROCEDURE AddRandomWorkToWorksheet
	@WorksheetID int,
	@WorkerID smallint,
	@WorkID smallint,
	@Quantity tinyint,
	@WorkerDescription varchar(120),
	@CompletionTime datetime

AS 

INSERT INTO WorksheetDetail(WorksheetID,WorkerID,WorkID,Quantity,WorkerDescription,CompletionTime) VALUES (@WorksheetId,@WorkerID,@WorkID,@Quantity,@WorkerDescription,@CompletionTime)

GO

-- Stored Procedure CSV Import with Name + Encoding Parameter (CODEPAGE 65001 -> UTF8)

CREATE OR ALTER PROCEDURE CsvImport
@FileName nvarchar(max),
@Codepage nvarchar(5),
@IntoTableName nvarchar(20),
@FormatFile nvarchar(200)
AS

DECLARE @Sql nvarchar(max)

SET @Sql = 'BULK INSERT ' + @IntoTableName + '
FROM ''' + @FileName + '''
WITH (FORMATFILE = ''' +@FormatFile+ ''',
      CODEPAGE = ''' + @Codepage + ''', 
	  firstrow = 2,
	  fieldterminator = '','',
	  rowterminator=''\n'')'

-- Debug SELECT @Sql
EXEC sp_executesql @Sql
GO

-- Stored Procedure CreateRandomWorksheet

-- This SP Generates random worksheets, with random works
-- Based ON:
-- Function: GenerateWorksheetNumber(),RandomDateTime(),ReturnRandFromTo(),ReturnRand()
-- View: vRandomDeviceType, vRandomJobDescription
-- Stored Procedure: AddRandomWorkToWorksheet

CREATE OR ALTER PROCEDURE CreateRandomWorksheet
@count int
AS
	BEGIN
	DECLARE @i int 
	SET @i = 0
	DECLARE @Worksheetrecorder int,@CustomerID int,@SiteCode int,@DeviceName varchar(120),@DeviceSerialNumber varchar(100),@JobDescription varchar(120),@ServiceCode int, @RandomStatusCode tinyint, @isExternal tinyint,@RandomExternalJobDescription varchar(120)
	WHILE @i < @count
	BEGIN
		-- PRINT 'Debug';
		SET @i = @i + 1
		SET @CustomerID = (SELECT dbo.ReturnRandFromTo(7,2900))
		SET @ServiceCode = (SELECT dbo.ReturnRandFromTo(1,3))
		SET @RandomStatusCode = (SELECT dbo.ReturnRandFromTo(1,3))

		-- Creating some more demo data (external worksheet too)
		SET @isExternal = (SELECT dbo.ReturnRandFromTo(0,1))
		DECLARE @wcount int, @RandomWorkId int, @RandomQuantity int
		SET @wcount = 0
			IF @isExternal = 1
			BEGIN
				SET @RandomQuantity =1
				SET @DeviceName = NULL
				SET @DeviceSerialNumber = NULL
				SET @JobDescription = NULL
				SET @wcount = 1
				SET @RandomExternalJobDescription = (SELECT * FROM vRandomExternalJobDescription)
					BEGIN
						-- (@RandomWorkId 6,7 = GPON, DSL internet bekötés )
							IF @RandomExternalJobDescription = 'Internet bekötés'
							BEGIN
								SET @RandomWorkId = (SELECT dbo.ReturnRandFromTo(6,7))
							END
							-- (@RandomWorkId 9  = Fejállomás építés )
							 IF @RandomExternalJobDescription = 'Fejállomás építés'
							 BEGIN
								SET @RandomWorkId = 9
							 END
					END
			END
		ELSE
		BEGIN
		-- If we have internal worksheet
			SET @RandomExternalJobDescription = NULL
			SET @JobDescription = (SELECT * FROM vRandomJobDescription)
			SET @DeviceName = (SELECT * FROM vRandomDeviceType)
			SET @DeviceSerialNumber = (SELECT dbo.ReturnRandFromTo(35000,95000))
		-- (@RandomWorkId 4,5 = Bevizsgálás / Szoftver telepítés )
			SET @RandomWorkId = (SELECT dbo.ReturnRandFromTo(4,5))
		    SET @wcount = (SELECT dbo.ReturnRandFromTo(1,3))
			SET @RandomQuantity = (SELECT dbo.ReturnRandFromTo(1,3))
		 END
		-- Get Country Code for Worksheet Number
		DECLARE @CountryCode char(2)
		SET @CountryCode = (SELECT DISTINCT A.CountryCode FROM Service S 
		INNER JOIN Address A ON A.AddressId = S.AddressID 
		WHERE S.ServiceCode = @ServiceCode)  

		DECLARE @pr varchar(5)
		SET @pr = CONCAT('WS-', @CountryCode)
		
		-- Get the next worksheet number
		DECLARE @Worksheetnumber varchar(12)
		SET @Worksheetnumber = (SELECT dbo.GenerateWorksheetNumber(@pr))
	
		INSERT INTO dbo.Worksheet VALUES(@Worksheetrecorder,@CustomerID,@SiteCode,@Worksheetnumber,@isExternal,@RandomExternalJobDescription, (SELECT dbo.RandomDateTime('2015-01-01 08:00:00','2023-03-26 18:00:00')),@DeviceName,@DeviceSerialNumber,@JobDescription,@ServiceCode,0,0,@RandomStatusCode,NULL)
		
		-- Get the last WorksheetID
		DECLARE @WorksheetId int
		SET @WorksheetId = (SELECT SCOPE_IDENTITY())
		--Debug Print @WorksheetId

		DECLARE @RandomWorkerDescription varchar(120)	
		DECLARE @ModifiedCompletionTime datetime
		DECLARE @TimeOfIssue datetime

		SET @TimeOfIssue  = (SELECT TimeOfIssue FROM Worksheet WHERE WorksheetID = @WorksheetId)
		SET @ModifiedCompletionTime = (SELECT DATEADD(HOUR,-3,@TimeOfIssue))

		-- Add random data to worksheet detail based on worksheetID
		DECLARE @wi int
		SET @wi = 0
		
		WHILE @wi < @wcount
		BEGIN
			SET @wi = @wi + 1
			SET @Worksheetrecorder =  (SELECT dbo.ReturnRandFromTo(1,2))
			SET @RandomWorkerDescription = (SELECT * FROM vRandomWorkerDescription)
			EXEC AddRandomWorkToWorksheet @WorksheetID = @WorksheetId, @WorkerID = @Worksheetrecorder, @WorkID = @RandomWorkId, @Quantity = @RandomQuantity, @WorkerDescription = @RandomWorkerDescription, @CompletionTIme = @ModifiedCompletionTime
		END
	END
END

GO

-- Generating 10 random Worksheet with random works
-- EXEC CreateRandomWorksheet 10

-- SELECT * FROM Worksheet
-- SELECT * FROM Work
-- SELECT * FROM WorksheetDetail

-- Add HU Worksheet
--EXEC CreateWorksheet 1,1,NULL,NULL,'Asus TUF Gaming Notebook','SN-000123','SSD cserét kértek, és windows telepítést',1

-- Add AT Worksheet
--EXEC CreateWorksheet 1,1,NULL,NULL,'Asus TUF Gaming Notebook','SN-000123','SSD cserét kértek, és windows telepítést',3


-- Stored Procedure WorksheetBasicData
GO 

CREATE OR ALTER PROCEDURE GetWorksheetBasicData 
@Worksheetnumber varchar(11)
AS
SELECT TOP 1 W.WorksheetNumber,W.WorksheetID, W.CustomerID, CONCAT (C.LastName, ' ', C.FirstName) AS CustomName,CONCAT (A.PostalCode, ' ,', A.CityName, ' ,', A.AddressLine1) AS CustomerAddress,C.Email,C.PhoneNumber,W.TimeOfIssue, W.DeviceName, W.DeviceSerialNummber,W.JobDescription, S.ServiceName, CONCAT (C2.LastName,' ',C2.FirstName) AS RecordedByWorker,C2.PhoneNumber AS WorkerPhoneNumber FROM Worksheet W
INNER JOIN Service S ON W.ServiceCode = S.ServiceCode
INNER JOIN Worker WK ON WK.WorkerID = WorksheetRecorderID
INNER JOIN Customer C ON C.CustomerID = W.CustomerID
INNER JOIN Customer C2 ON C2.CustomerID = WK.CustomerID AND C2.isWorker =1
INNER JOIN Address A ON A.CustomerID =C.CustomerID
WHERE WorksheetNumber = @Worksheetnumber
GO

-- StoredProcedure GetUsedComponentsByWorksheetNumber
GO

CREATE OR ALTER PROCEDURE GetUsedComponentsByWorksheetNumber
@Worksheetnumber varchar(11)
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
@Worksheetnumber varchar(11)
AS
SELECT
W.WorksheetNumber,CONCAT (C.LastName + ' ', C.MiddleName + ' ' + C.FirstName)  AS Worker,
WO.WorkName AS WorkName, IIF(WO.HourlyWorkPrice IS NULL,WO.Price,WO.HourlyWorkPrice) AS Price,WD.Quantity,
CASE 
	WHEN
	WO.iSHourlyWork = 0 THEN WO.Price
	ELSE WO.HourlyWorkPrice * WD.Quantity
END
AS SubTotal, WD.WorkerDescription
FROM Worksheet W
LEFT JOIN WorksheetDetail WD ON WD.WorksheetID = W.WorksheetID
LEFT JOIN Work WO ON WO.WorkID = WD.WorkID
LEFT JOIN Worker WR ON WR.WorkerID = WD.WorkerID
LEFT JOIN Customer C ON C.CustomerID = WR.CustomerID
WHERE WorksheetNumber = @Worksheetnumber
GO

--StoredProcedure CreateWork

GO

CREATE OR ALTER PROCEDURE CreateWork
@WorkCode varchar(10),
@WorkName varchar(120),
@WorkNameDE varchar(120),
@WorkNameEN varchar(120),
@WorkSubCategoryID tinyint,
@IsHourlyWork bit,
@HourlyWorkPrice money,
@HourlyWorkPriceDE money,
@HourlyWorkPriceEN money,
@VatID tinyint,
@VatIdDE tinyint,
@VatIdEN tinyint,
@Price money,
@PriceDE money,
@PriceEN money

AS
INSERT INTO Work(WorkCode,WorkName,WorkNameDE,WorkNameEN,WorkSubCategoryID,iSHourlyWork,HourlyWorkPrice,HourlyWorkPriceDE,HourlyWorkPriceEN,VatID,VatIdDE,VatIdEN,Price,PriceDE,PriceEN) 
VALUES(
@WorkCode,@WorkName,@WorkNameDE,@WorkNameEN,@WorkSubCategoryID,@IsHourlyWork,@HourlyWorkPrice,@HourlyWorkPriceDE,@HourlyWorkPriceEN,@VatID,@VatIdDE,@VatIdEN, @Price, @PriceDE,@PriceEN)

GO

-- StoredProcedure CreateWorkToWorksheet
GO
CREATE OR ALTER PROCEDURE CreateWorkToWorksheet
	@WorkshhetID int,
	@WorkerID smallint,
	@WorkID smallint,
	@Quantity tinyint,
	@WorkerDescription varchar(120)

AS 
DECLARE @CompletionTime datetime
SET @CompletionTime = (SELECT SYSDATETIME())
INSERT INTO WorksheetDetail(WorksheetID,WorkerID,WorkID,Quantity,WorkerDescription,CompletionTime) VALUES (@WorkshhetID,@WorkerID,@WorkID,@Quantity,@WorkerDescription,@CompletionTime)
GO

-- EXEC CreateWorkToWorksheet @WorkshhetID = 1, @WorkerID = 1, @WorkID = 4, @Quantity = 2, @WorkerDescription = 'Hát igen a Windows az egy csoda'


/* Data upload testing ...*/

GO

INSERT INTO dbo.DictCountry VALUES ('HU','Magyarország')
INSERT INTO dbo.DictCountry VALUES ('AT','Ausztria')
INSERT INTO dbo.DictCountry VALUES ('GB','Anglia')

GO
EXEC CsvImport @Filename ='D:\GoogleDrive\T360\Vizsgaremek\county.csv',@Codepage = '65001',@IntoTableName = 'dbo.DictCounty',@FormatFile ='D:\GoogleDrive\T360\Vizsgaremek\county.xml'

GO
EXEC CsvImport @Filename ='D:\GoogleDrive\T360\Vizsgaremek\postalcode.csv',@Codepage = '65001',@IntoTableName = 'dbo.PostalCode',@FormatFile ='D:\GoogleDrive\T360\Vizsgaremek\postalcode.xml'


GO
INSERT INTO dbo.Address  VALUES (NULL,0,1,0,'HU','8315','Gyenesdiás','Kossuth u. 12.','',GETDATE(),NULL)
INSERT INTO dbo.Address  VALUES (NULL,0,1,0,'HU','8360','Keszthely','Tapolcai út. 74.','',GETDATE(),NULL)
INSERT INTO dbo.Address  VALUES (NULL,0,1,0,'HU','8380','Hévíz','Tavirózsa u. 1.','',GETDATE(),NULL)

-- Add Service
INSERT INTO dbo.Service VALUES ('Visionet Kft.',3,'+36 20 348-1071','info@visionet.hu',GETDATE(),NULL)

-- ADD AT Service

INSERT INTO dbo.Address  VALUES (NULL,0,1,0,'AT','4061','Pasching','Plus-Kauf-Straße 7','',GETDATE(),NULL)
DECLARE @AddressID int 
SET @AddressID = SCOPE_IDENTITY () 
INSERT INTO dbo.Service VALUES ('Electronic4You',@AddressID,'+43 7229 22 358','info@electronic4you.at',GETDATE(),NULL)


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

INSERT INTO Customer VALUES ('Kiss','','István','kiss.istvan@gmail.com','1','123','+3620 148-3070',NULL,'0','0',NULL,1,'0',NULL,'0',NULL)
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

EXEC CreateWork 'SSD-01','SSD csere','SSD Austausch','SSD Replace',1,0,NULL,NULL,NULL,1,2,2,3000,10,10
EXEC CreateWork 'HDD-01','HDD csere','HDD Austausch','HDD Replace',1,0,NULL,NULL,NULL,1,2,2,3000,10,10
EXEC CreateWork 'INS-01','Linux telepítés','Linux Installation','Linux Install',1,0,NULL,NULL,NULL,1,2,2,6000,20,20
EXEC CreateWork 'INS-01','Bevizsgálás','Inspektion','Inspection',1,1,3000,20,20,1,2,2,NULL,NULL,NULL
EXEC CreateWork 'SWI-01','Szoftver telepítés','App Installation','Application Innstal',1,1,3000,20,20,1,2,2,NULL,NULL,NULL

EXEC CreateWork 'GPON-01','GPON Internet bekötés -1 Gigabit/s','GPON Internet installation -1 Gigabit/s','GPON Internet Installation -1 Gigabit/s',2,0,NULL,NULL,NULL,1,2,2,10000,40,40
EXEC CreateWork 'DSL-01','DSL Internet bekötés -10 Megabit/s','DSL Internet installation -10 Megabit/s','DSL Internet Installation -10 Megabit/s',2,0,NULL,NULL,NULL,1,2,2,10000,40,40

EXEC CreateWork 'T-01','Tápegység csere','Netzteils Austausch','Powersupply replacement',3,0,NULL,NULL,NULL,1,2,2,5000,20,20
EXEC CreateWork 'F-01','Fejállomás építés','Kopfstation Bau','Headstation construction',4,0,NULL,NULL,NULL,1,2,2,15000,40,40

-- SELECT * FROM Work

--INSERT INTO Work VALUES('SSD-01','SSD csere','SSD Austausch','SSD Replace',1,0,NULL,NULL,NULL,1,2,2,3000,10,10)
--INSERT INTO Work VALUES('HDD-01','HDD csere','HDD Austausch','HDD Replace',1,0,NULL,NULL,NULL,1,2,2,3000,10,10)
--INSERT INTO Work VALUES('INS-01','Linux telepítés','Linux Installation','Linux Install',1,0,NULL,NULL,NULL,1,2,2,6000,20,20)
--INSERT INTO Work VALUES('INSP-01','Bevizsgálás','Inspektion','Inspection',1,1,3000,20,20,1,2,2,NULL,NULL,NULL)
--INSERT INTO Work VALUES('SWI-01','Szoftver telepítés','App Installation','Application Innstal',1,1,3000,20,20,1,2,2,NULL,NULL,NULL)

--INSERT INTO Work VALUES('GPON-01','GPON Internet bekötés -1 Gigabit/s','GPON Internet installation -1 Gigabit/s','GPON Internet Installation -1 Gigabit/s',2,0,NULL,NULL,NULL,1,2,2,10000,40,40)
--INSERT INTO Work VALUES('DSL-01','DSL Internet bekötés -10 Megabit/s','DSL Internet installation -10 Megabit/s','DSL Internet Installation -10 Megabit/s',2,0,NULL,NULL,NULL,1,2,2,10000,40,40)

--INSERT INTO Work VALUES('T-01','Tápegység csere','Netzteils Austausch','Powersupply replacement',3,0,NULL,NULL,NULL,1,2,2,5000,20,20)
--INSERT INTO Work VALUES('F-01','Fejállomás építés','Kopfstation Bau','Headstation construction',4,0,NULL,NULL,NULL,1,2,2,15000,40,40)

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
EXEC CreateWorksheet 1,1,NULL,NULL,'Acer Nitro Notebook',NULL,'Nem indul a windows, linux telepítést kértek (Debian-t)',1


--INSERT INTO dbo.Worksheet VALUES(1,1,NULL,'WS-000002',0,NULL,SYSDATETIME(),'Asus TUF Gaming Notebook','SN-000123','SSD cserét kértek, és windows telepítést',1,0,0,NULL,NULL)
EXEC CreateWorksheet 1,1,NULL,NULL,'Asus TUF Gaming Notebook','SN-000123','SSD cserét kértek, és windows telepítést',1


GO
--SELECT * FROM Worksheet

-- Get Basic Worksheet Data

EXEC GetWorksheetBasicData @Worksheetnumber='WS-HU000001'
EXEC GetWorksheetBasicData @Worksheetnumber='WS-HU000002'
--EXEC GetWorksheetBasicData @Worksheetnumber='WS-HU000100'
--EXEC GetWorksheetBasicData @Worksheetnumber='WS-AT000056'


SELECT * FROM WorksheetDetail
GO

INSERT INTO WorksheetDetail VALUES(1,1,4,1,'Hát igen a Windows az egy csoda ...',SYSDATETIME())
INSERT INTO WorksheetDetail VALUES(1,1,3,1,'Végre egy értelmes munka ... ',SYSDATETIME())
INSERT INTO WorksheetDetail VALUES(1,2,5,2,'Junior még a kolléga, nemgond legalább lesz bevétel ... :)',SYSDATETIME())

-- WS-02 

INSERT INTO WorksheetDetail VALUES(2,1,1,1,NULL,NULL)
INSERT INTO WorksheetDetail VALUES(2,2,5,2,NULL,NULL)


-- Get Works BY Worksheet Number

EXEC GetWorksByWorksheetNumber @Worksheetnumber ='WS-HU000017'
EXEC GetWorksByWorksheetNumber @Worksheetnumber ='WS-AT000056'

-- SELECT * FROM Worksheet W WHERE W.IsExternal = 1


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

SELECT S.AssetID,C.B2bPartnerName AS BuyFromB2B,AP.PurchaseDate,SR.ServiceName,AP.BillNumber,S.SerialNumber,AC.ComponentName,S.ListPrice,DV.VATName,DV.VATNameDE,DV.VATNameEN, AC.SellPrice 
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

EXEC GetUsedComponentsByWorksheetNumber @Worksheetnumber ='WS-HU000002'


-- EXEC CreateRandomWorksheet 500

EXEC GetWorksByWorksheetNumber 'WS-HU000004'
EXEC GetWorksByWorksheetNumber 'WS-HU001006'
EXEC GetWorksByWorksheetNumber 'WS-AT000405'


SELECT * FROM Customer C WHERE C.isSubcontractor =0 AND C.isWorker =0 AND C.isB2bParnter = 0

SELECT * FROM Worksheet W WHERE YEAR(W.TimeOfIssue) = '2020' ORDER BY W.TimeOfIssue DESC,W.ServiceCode,W.WorksheetNumber
SELECT * FROM Worksheet W WHERE YEAR(W.TimeOfIssue) = '2023' ORDER BY W.TimeOfIssue DESC,W.ServiceCode,W.WorksheetNumber

-- Importing Names from CSV + generate Mail Address 

-- Function AccentConverter (Because of áéíúû characters)
GO
CREATE OR ALTER FUNCTION dbo.AccentConverter (@data varchar(100))
RETURNS VARCHAR(100)
AS
BEGIN
SET @data = (SELECT @data collate SQL_Latin1_General_Cp1251_CS_AS)
RETURN @data
END

GO
-- View for NewID

CREATE OR ALTER VIEW dbo.NewID
AS
SELECT NEWID() AS [NewID]

GO


-- Stored Procedure GenerateRandomPhoneNumber

CREATE OR ALTER FUNCTION dbo.GenerateRandomPhoneNumber()
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @prefix VARCHAR(4)
    DECLARE @number VARCHAR(7)
    
    SELECT TOP 1 @prefix = prefix 
    FROM (VALUES ('20'), ('30'), ('70')) AS prefixes(prefix)
    ORDER BY ( (SELECT [NewId] FROM dbo.NewID))
    
    SET @number = ''
    WHILE LEN(@number) < 7
    BEGIN
        SET @number = @number + CAST(FLOOR(dbo.ReturnRand() * 10) AS VARCHAR(1))
    END
    
    RETURN CONCAT('+36', ' ', @prefix, ' ', SUBSTRING(@number, 1, 3), '-', SUBSTRING(@number, 4, 2), SUBSTRING(@number, 6, 2))
END

GO
SELECT dbo.GenerateRandomPhoneNumber()

GO
CREATE OR ALTER PROCEDURE CreateRandomCustomer
@count int
AS

DECLARE @i int 
SET @i = 0
BEGIN
	DROP TABLE IF EXISTS #Names
	CREATE TABLE #Names (Lastname varchar(100))
	BULK INSERT #Names
			FROM 'D:\GoogleDrive\T360\Vizsgaremek\csaladnevek.csv'
			WITH (FIELDTERMINATOR =';',  ROWTERMINATOR ='\n', CODEPAGE = 'ACP', FIRSTROW = 2)

	-- SELECT * FROM #Names


	DROP TABLE IF EXISTS #Names2
	CREATE TABLE #Names2 (Firstname varchar(100))
	BULK INSERT #Names2
			FROM 'D:\GoogleDrive\T360\Vizsgaremek\utonevek.csv'
			WITH (FIELDTERMINATOR =';',  ROWTERMINATOR ='\n', CODEPAGE = 'ACP', FIRSTROW = 2)

	-- SELECT * FROM #Names2

	
END
WHILE @i < @count

	BEGIN 
	DECLARE @RandomEmailProvider varchar(50), @RandomEmailNumber varchar(3)
	SET @RandomEmailProvider = (SELECT * FROM vRandomMailProvider)
	SET @RandomEmailNumber = (SELECT CAST(dbo.ReturnRandFromTo(0,255) AS VARCHAR(3)))
	SET @i = @i + 1
	DROP TABLE IF EXISTS #TempData
	SELECT TOP 1 N.Lastname,N2.Firstname, CONCAT(dbo.AccentConverter(N.Lastname), + '.', dbo.AccentConverter(Firstname) + @RandomEmailNumber, + @RandomEmailProvider) AS Email,dbo.GenerateRandomPhoneNumber() AS PhoneNumber  
	INTO #TempData
	FROM #Names2 N2
	CROSS JOIN #Names N 
	ORDER BY NEWID()

	DECLARE @FirstName varchar(30), @LastName varchar(20), @PhoneNumber varchar(20), @Email varchar(90)

	SET @FirstName = (SELECT Firstname FROM #TempData)
	SET @LastName = (SELECT Lastname FROM #TempData)
	SET @PhoneNumber = (SELECT PhoneNumber FROM #TempData)
	SET @Email = (SELECT Email FROM #TempData)

	-- Generate Customer Password
	DECLARE @Password VARCHAR(8)
	SET @Password =(SELECT LEFT(NEWID(),8))

	INSERT INTO Customer VALUES (@FirstName,NULL,@LastName,@Email,'1',@Password,@PhoneNumber,NULL,'0','0',NULL,0,0,NULL,0,NULL)

	DECLARE @CustomerID int , @Street varchar(100), @StreetNumber tinyint,@RandomPostalCodeID smallint,@RandomPostalCode varchar(10),@RandomCity varchar(50),@CompleteAddress varchar(200)


	SET @CustomerID = SCOPE_IDENTITY() 
	SET @RandomPostalCodeID = (SELECT dbo.ReturnRandFromTo(1,3570))

	SET @RandomPostalCode = (SELECT PC.PostalCode FROM PostalCode PC WHERE PC.PostalCodeID = @RandomPostalCodeID) 
	SET @RandomCity = (SELECT PC.CityName FROM PostalCode PC WHERE PC.PostalCodeID = @RandomPostalCodeID) 

	SET @Street = (SELECT * FROM vRandomStreet)
	SET @StreetNumber = (SELECT dbo.ReturnRandFromTo(1,120))


	SET @CompleteAddress = CONCAT(@Street, @StreetNumber)


	INSERT INTO dbo.Address (CustomerID,CountryCode,PostalCode,CityName,AddressLine1,Addressline2,AddressFrom,AddressTo) VALUES (@CustomerID,'HU',@RandomPostalCode,@RandomCity,@CompleteAddress,NULL,GETDATE(),NULL)

END


GO
-- Stored Procedure for cretating new customer
-- Return 0 Insert Ok , 1 Empty name or phone or email, 2 Bad E-mail (Based on Regex function)

CREATE OR ALTER PROCEDURE CreateCustomer
 @FirstName varchar(30),@MiddleName varchar(20), @LastName varchar(20), @PhoneNumber varchar(20), @Email varchar(90), @isNewsletter bit
AS
IF (@FirstName ='' OR @LastName ='' OR @PhoneNumber =''  OR @Email ='')
	RETURN 1

DECLARE @password varchar(8)
DECLARE @EmailCheck char(3)
SET @Password =(SELECT LEFT(NEWID(),8))
SET @EmailCheck = dbo.EmailCheck(@Email)

IF @EmailCheck = 'Bad'
	RETURN 2

IF @MiddleName = ''
SET @MiddleName = NULL

INSERT INTO Customer VALUES (@FirstName,@MiddleName,@LastName,@Email,'1',@Password,@PhoneNumber,NULL,@isNewsletter,'0',NULL,0,0,NULL,0,NULL)
RETURN 0


-- Test
DECLARE @Result int
EXEC @Result =  CreateCustomer 'Kiss','Nagy','István','+36 20 358 1751','kiss.gmailcom','0'
SELECT @Result

DECLARE @Result int
EXEC @Result =  CreateCustomer 'Kiss','Nagy','István','+36 20 358 1751','kiss@gmail.com','0'
SELECT @Result

-- SELECT * FROM Customer WHERE email = 'kiss@gmail.com'
-- DELETE FROM Customer WHERE email = 'kiss@gmail.com'

-- Creating some Demo Data ... :)
GO
EXEC CreateRandomCustomer @count = 3000
GO
EXEC CreateRandomWorksheet 3200

-- SELECT * FROM Customer
-- SELECT * FROM Worksheet
-- SELECT * FROM Bill
-- SELECT * FROM Address

SELECT W.WorksheetID ,COUNT(WorksheetDetailID) FROM WorksheetDetail WD
INNER JOIN Worksheet W ON W.WorksheetID = WD.WorksheetID 
GROUP BY WD.WorksheetID,W.WorksheetID
ORDER BY 2 DESC

SELECT * FROM Customer C INNER JOIN Address A ON A.CustomerID = C.CustomerID WHERE isWorker = 0

-- Test Query (Index check)
SELECT * FROM Customer WHERE FirstName = 'Attila'
SELECT * FROM Customer WHERE LastName = 'Horvath'
SELECT * FROM Customer WHERE Firstname ='Attila' AND LastName = 'Horvath'
SELECT * FROM Customer WHERE email ='atiradeon86@gmail.com'
SELECT * FROM Customer WHERE PhoneNumber = '+3620 348-1070'


-- Index

GO

CREATE NONCLUSTERED INDEX IX_Customer_Firstname ON Customer (Firstname) INCLUDE (MiddleName,LastName)
GO

-- DROP INDEX [IX_Customer_Firstname] ON [dbo].[Customer]
GO

CREATE NONCLUSTERED INDEX IX_WorksheetID ON  WorksheetDetail(WorksheetID) INCLUDE(WorkerID,WorkID,Quantity,WorkerDescription)
GO

-- DROP INDEX [IX_WorksheetID] ON [dbo].[WorksheetDetail]
GO


-- Test Query Worksheet Data (Index check)
-- SELECT * FROM Worksheet WHERE WorksheetNumber = 'WS-HU000103'
-- EXEC GetWorksheetBasicData @Worksheetnumber='WS-AT000056'
GO

CREATE NONCLUSTERED INDEX IX_WorksheetID ON  WorksheetDetail(WorksheetID) INCLUDE(WorkerID,WorkID,Quantity,WorkerDescription)
-- DROP INDEX [IX_WorksheetID] ON [dbo].[WorksheetDetail]
GO


-- Get multiple info for testing.
SELECT * FROM Worker W 
INNER JOIN Customer C ON C.CustomerID = W.CustomerID 
INNER JOIN Service S ON S.ServiceCode = W.ServiceCode
INNER JOIN Worksheet WS ON WS.ServiceCode = S.ServiceCode
WHERE C.FirstName = 'Attila' AND W.ServiceCode = 1 AND WS.WorksheetRecorderID='1'

-- Check Index  Usage Stats
SELECT OBJECT_NAME(OBJECT_ID) TableName, *
FROM sys.dm_db_index_usage_stats
WHERE database_id = DB_ID() 
ORDER BY 1,4

-- Check Index  Physical Stats
SELECT OBJECT_NAME(OBJECT_ID) TableName, *
FROM sys.dm_db_index_physical_stats(DB_ID(),NULL,NULL,NULL, 'DETAILED')


--------------- Security ----------------

DROP LOGIN ERPConnection
DROP USER ERPConnection
DROP LOGIN WorkrouterAdmin
DROP USER WorkrouterAdmin
DROP LOGIN Client
DROP USER Client

-- Users 

-- Create ERP Login
USE master
GO
CREATE LOGIN ERPConnection WITH PASSWORD='ERP1234#' , DEFAULT_DATABASE=master

-- Map Login
USE WorkRouter
GO
CREATE USER ERPConnection FOR LOGIN ERPConnection

-- Add right to execute stored procedures on dbo schema
GRANT EXECUTE ON SCHEMA::dbo TO ERPConnection

-- Create Admin Login (WorkrouterAdmin) 

USE master
GO
CREATE LOGIN WorkrouterAdmin WITH PASSWORD='Demo1234' , DEFAULT_DATABASE=master

ALTER SERVER ROLE bulkadmin ADD MEMBER WorkrouterAdmin
ALTER SERVER ROLE securityadmin ADD MEMBER [WorkrouterAdmin]
ALTER SERVER ROLE sysadmin ADD MEMBER WorkrouterAdmin

-- Add WorkrouterAdmin user to WorkRouter Database
USE WorkRouter
GO
CREATE USER WorkrouterAdmin FOR LOGIN WorkrouterAdmin

-- Add db_owner right to WorkrouterAdmin user
ALTER ROLE db_owner ADD MEMBER WorkrouterAdmin
GO

-- Add schema (app)

CREATE SCHEMA app AUTHORIZATION WorkrouterAdmin
GO

-- Create Client Login (without rights, only app schema)

USE master
GO

CREATE LOGIN Client WITH PASSWORD= 'Demo1234'
GO
ALTER USER Client WITH DEFAULT_SCHEMA=app
GO
ALTER AUTHORIZATION ON SCHEMA::app TO Client
GO

-- Map Client Login to WorkrouterDB
USE WorkRouter
CREATE USER Client FOR LOGIN Client WITH DEFAULT_SCHEMA=app
GO

-- Add right to app schema for Client User
ALTER AUTHORIZATION ON SCHEMA::app TO Client

-- Create Application role
USE WorkRouter
CREATE APPLICATION ROLE ClientAppRole WITH DEFAULT_SCHEMA = app, PASSWORD = 'Demo1234'
GO
ALTER AUTHORIZATION ON SCHEMA::app TO ClientAppRole
GO

-- Add SELECT Permission to dbo for ClientAppRole user, because of Stored Procedure
GRANT SELECT ON SCHEMA::dbo TO ClientAppRole

-- Add right to app scheme for ClientAppRole 
ALTER AUTHORIZATION ON SCHEMA::app TO ClientAppRole

-- Create lang specific sp
USE WorkRouter 
GO

CREATE OR ALTER PROCEDURE app.GetWorksByWorksheetNumber
@Worksheetnumber varchar(11)
AS
SELECT
W.WorksheetNumber,CONCAT (C.LastName + ' ', C.MiddleName + ' ' + C.FirstName)  AS Worker,
WO.WorkName AS WorkName, IIF(WO.HourlyWorkPrice IS NULL,WO.Price,WO.HourlyWorkPrice) AS Price,WD.Quantity,
CASE 
	WHEN
	WO.iSHourlyWork = 0 THEN WO.Price
	ELSE WO.HourlyWorkPrice * WD.Quantity
END
AS SubTotal, WD.WorkerDescription
FROM Worksheet W
LEFT JOIN WorksheetDetail WD ON WD.WorksheetID = W.WorksheetID
LEFT JOIN Work WO ON WO.WorkID = WD.WorkID
LEFT JOIN Worker WR ON WR.WorkerID = WD.WorkerID
LEFT JOIN Customer C ON C.CustomerID = WR.CustomerID
WHERE WorksheetNumber = @Worksheetnumber
GO

USE WorkRouter 
GO
CREATE OR ALTER PROCEDURE app.GetWorksByWorksheetNumberDE
@Worksheetnumber varchar(11)
AS
SELECT
W.WorksheetNumber,CONCAT (C.LastName + ' ', C.MiddleName + ' ' + C.FirstName)  AS Worker,
WO.WorkNameDE AS WorkName, IIF(WO.HourlyWorkPriceDE IS NULL,WO.PriceDE,WO.HourlyWorkPriceEN) AS Price,WD.Quantity,
CASE 
	WHEN
	WO.iSHourlyWork = 0 THEN WO.PriceDE
	ELSE WO.HourlyWorkPriceDE * WD.Quantity
END
AS SubTotal, WD.WorkerDescription
FROM Worksheet W
LEFT JOIN WorksheetDetail WD ON WD.WorksheetID = W.WorksheetID
LEFT JOIN Work WO ON WO.WorkID = WD.WorkID
LEFT JOIN Worker WR ON WR.WorkerID = WD.WorkerID
LEFT JOIN Customer C ON C.CustomerID = WR.CustomerID
WHERE WorksheetNumber = @Worksheetnumber
GO

EXEC app.GetWorksByWorksheetNumberDE @Worksheetnumber ='WS-AT000010'


GO
CREATE OR ALTER PROCEDURE app.GetWorksByWorksheetNumberEN
@Worksheetnumber varchar(11)
AS
SELECT
W.WorksheetNumber,CONCAT (C.LastName + ' ', C.MiddleName + ' ' + C.FirstName)  AS Worker,
WO.WorkNameEN AS WorkName, IIF(WO.HourlyWorkPriceEN IS NULL,WO.PriceEN,WO.HourlyWorkPriceEN) AS Price,WD.Quantity,
CASE 
	WHEN
	WO.iSHourlyWork = 0 THEN WO.PriceEN
	ELSE WO.HourlyWorkPriceEN * WD.Quantity
END
AS SubTotal, WD.WorkerDescription
FROM Worksheet W
LEFT JOIN WorksheetDetail WD ON WD.WorksheetID = W.WorksheetID
LEFT JOIN Work WO ON WO.WorkID = WD.WorkID
LEFT JOIN Worker WR ON WR.WorkerID = WD.WorkerID
LEFT JOIN Customer C ON C.CustomerID = WR.CustomerID
WHERE WorksheetNumber = @Worksheetnumber
GO

EXEC app.GetWorksByWorksheetNumber @Worksheetnumber ='WS-AT000010'
EXEC app.GetWorksByWorksheetNumberEN @Worksheetnumber ='WS-AT000010'
EXEC app.GetWorksByWorksheetNumberDE @Worksheetnumber ='WS-AT000010'

------------------------- ClientAppRole PS1 Test Script -------------------------
/*
$SqlServer = "BRYAN-i5-12600K\BRYAN"
    $DB_Name = "Workrouter"
    $DB_username = "Client"
    $DB_password = "Demo1234"
    $query = "
    EXEC sys.sp_setapprole 'ClientAppRole', 'Demo1234'
    EXEC app.GetWorksByWorksheetNumberEN @Worksheetnumber ='WS-AT000010'"

    $data = Invoke-Sqlcmd -Query $query -Username $DB_username -Password $DB_password -ServerInstance $SQLServer -Database $DB_Name

echo $data
*/
--------------------------------------------------------------------------

----------------- DatabaseRoles -----------------

-- WorkRouter (Manage workers rights, worker assignment to works)

USE WorkRouter
GO

CREATE ROLE WorkRouter AUTHORIZATION dbo
GO

GRANT DELETE ON dbo.WorkerRightConnection TO WorkRouter
GRANT INSERT ON dbo.WorkerRightConnection TO WorkRouter
GRANT SELECT ON dbo.WorkerRightConnection TO WorkRouter
GRANT UPDATE ON dbo.WorkerRightConnection TO WorkRouter
GO

GRANT DELETE ON dbo.WorkerRight TO WorkRouter
GRANT INSERT ON dbo.WorkerRight TO WorkRouter
GRANT SELECT ON dbo.WorkerRight TO WorkRouter
GRANT UPDATE ON dbo.WorkerRight TO WorkRouter
GO

GRANT DELETE ON dbo.Worker TO WorkRouter
GRANT INSERT ON dbo.Worker TO WorkRouter
GRANT SELECT ON dbo.Worker TO WorkRouter
GRANT UPDATE ON dbo.Worker TO WorkRouter
GO

GRANT DELETE ON dbo.WorkerConnection TO WorkRouter
GRANT INSERT ON dbo.WorkerConnection TO WorkRouter
GRANT SELECT ON dbo.WorkerConnection TO WorkRouter
GRANT UPDATE ON dbo.WorkerConnection TO WorkRouter
GO

-- AssetAdmin (Manage asset purchases, asset details )

USE WorkRouter
GO

CREATE ROLE AssetAdmin AUTHORIZATION dbo

GRANT DELETE ON dbo.AssetPurchase TO AssetAdmin
GRANT INSERT ON dbo.AssetPurchase TO AssetAdmin
GRANT SELECT ON dbo.AssetPurchase TO AssetAdmin
GRANT UPDATE ON dbo.AssetPurchase TO AssetAdmin
GO

GRANT DELETE ON dbo.AssetStock TO AssetAdmin
GRANT INSERT ON dbo.AssetStock TO AssetAdmin
GRANT SELECT ON dbo.AssetStock TO AssetAdmin
GRANT UPDATE ON dbo.AssetStock TO AssetAdmin
GO

GRANT DELETE ON dbo.AssetComponentSubcategory TO AssetAdmin
GRANT INSERT ON dbo.AssetComponentSubcategory TO AssetAdmin
GRANT SELECT ON dbo.AssetComponentSubcategory TO AssetAdmin
GRANT UPDATE ON dbo.AssetComponentSubcategory TO AssetAdmin
GO

GRANT DELETE ON dbo.AssetComponent TO AssetAdmin
GRANT INSERT ON dbo.AssetComponent TO AssetAdmin
GRANT SELECT ON dbo.AssetComponent TO AssetAdmin
GRANT UPDATE ON dbo.AssetComponent TO AssetAdmin
GO

GRANT DELETE ON dbo.AssetComponentCategory TO AssetAdmin
GRANT INSERT ON dbo.AssetComponentCategory TO AssetAdmin
GRANT SELECT ON dbo.AssetComponentCategory TO AssetAdmin
GRANT UPDATE ON dbo.AssetComponentCategory TO AssetAdmin
GO

-- WorkAdmin (Manage works, categories, prices, vats ... )

USE WorkRouter
GO

CREATE ROLE WorkAdmin AUTHORIZATION dbo
GO

GRANT DELETE ON dbo.WorkSubcategory TO WorkAdmin
GRANT INSERT ON dbo.WorkSubcategory TO WorkAdmin
GRANT SELECT ON dbo.WorkSubcategory TO WorkAdmin
GRANT UPDATE ON dbo.WorkSubcategory TO WorkAdmin
GO

GRANT DELETE ON dbo.WorkCategory TO WorkAdmin
GRANT INSERT ON dbo.WorkCategory TO WorkAdmin
GRANT SELECT ON dbo.WorkCategory TO WorkAdmin
GRANT UPDATE ON dbo.WorkCategory TO WorkAdmin
GO

GRANT DELETE ON dbo.Work TO WorkAdmin
GRANT INSERT ON dbo.Work TO WorkAdmin
GRANT SELECT ON dbo.Work TO WorkAdmin
GRANT UPDATE ON dbo.Work TO WorkAdmin
GO

--- Backup

BACKUP DATABASE [WorkRouter] TO  DISK = N'C:\SQLDATA\Backup\WorkRouter-with-3000-customer.bak' WITH FORMAT, INIT,  MEDIADESCRIPTION = N'WorkRouter With demo data, compressed',  MEDIANAME = N'WorkRouter',  NAME = N'WorkRouter-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
GO



