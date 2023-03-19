CREATE DATABASE WorkRouter
GO

USE WorkRouter
GO

CREATE TABLE [Customer] (
  [CustomerID] int PRIMARY KEY IDENTITY(1, 1),
  [FirstName] nvarchar(255),
  [MiddleName] nvarchar(255),
  [LastName] nvarchar(255),
  [Email] nvarchar(255),
  [PermitLogin] int,
  [CustomerPassword] nvarchar(255),
  [PhoneNumber] nvarchar(255),
  [SecondPhoneNumber] nvarchar(255),
  [IsNewsletter] int,
  [HasBuyerCard] int,
  [BuyerCardNummer] nvarchar(255),
  [isWorker] int,
  [isSubcontractor] int,
  [SubcontractorName] nvarchar(255),
  [isB2bParnter] int,
  [B2bPartnerName] nvarchar(255)
)
GO

CREATE TABLE [DictCountry] (
  [CountryCode] nvarchar(255) PRIMARY KEY,
  [CountryName] nvarchar(255)
)
GO

CREATE TABLE [DictCounty] (
  [CountyID] int PRIMARY KEY,
  [CountryCode] nvarchar(255),
  [CountyName] nvarchar(255)
)
GO

CREATE TABLE [PostalCode] (
  [PostalCodeID] int PRIMARY KEY IDENTITY(1, 1),
  [PostalCode] nvarchar(255),
  [CountyID] int,
  [CityName] nvarchar(255)
)
GO

CREATE TABLE [Service] (
  [ServiceCode] int PRIMARY KEY IDENTITY(1, 1),
  [ServiceName] nvarchar(255),
  [AddressID] int,
  [PhoneNumber] nvarchar(255),
  [Email] nvarchar(255),
  [ServiceFrom] date,
  [ServiceTo] date
)
GO

CREATE TABLE [Site] (
  [SiteCode] int PRIMARY KEY,
  [ServiceCode] int,
  [SiteName] nvarchar(255),
  [PhoneNumber] nvarchar(255),
  [Email] nvarchar(255),
  [AddressID] int,
  [SiteFrom] date,
  [SiteTo] date
)
GO

CREATE TABLE [Address] (
  [AddressId] int PRIMARY KEY IDENTITY(1, 1),
  [CustomerID] int,
  [CountryCode] nvarchar(255),
  [PostalCode] nvarchar(255),
  [CityName] nvarchar(255),
  [AddressLine1] nvarchar(255),
  [Addressline2] nvarchar(255),
  [AddressFrom] date,
  [AddressTo] date
)
GO

CREATE TABLE [Worksheet] (
  [WorksheetID] int PRIMARY KEY IDENTITY(1, 1),
  [WorksheetRecorderID] int,
  [CustomerID] int,
  [SiteCode] int,
  [WorksheetNummer] nvarchar(255),
  [IsExternal] int,
  [ExternalJobDescription] nvarchar(255),
  [TimeOfIssue] datetime,
  [DeviceName] nvarchar(255),
  [DeviceSerialNummber] nvarchar(255),
  [JobDescription] nvarchar(255),
  [ServiceCode] int,
  [IsBilled] int,
  [IsLocked] int,
  [StatusCode] int,
  [TimeOfCompletion] datetime
)
GO

CREATE TABLE [WorksheetDetail] (
  [WorksheetDetailID] int PRIMARY KEY IDENTITY(1, 1),
  [WorksheetID] int,
  [WorkerID] int,
  [WorkID] int,
  [Quantity] int,
  [WorkerDescription] nvarchar(255),
  [CompletionTime] datetime
)
GO

CREATE TABLE [Worker] (
  [WorkerID] int PRIMARY KEY IDENTITY(1, 1),
  [CustomerID] int,
  [ServiceCode] int,
  [isInternalWorker] int,
  [isExternalWorker] int,
  [IsActive] int
)
GO

CREATE TABLE [WorkerConnection] (
  [WorkerConnectionID] int PRIMARY KEY IDENTITY(1, 1),
  [PrincipalWorkerID] int,
  [WorkerID] int,
  [WorksheetID] int
)
GO

CREATE TABLE [WorkerRight] (
  [RightID] int PRIMARY KEY IDENTITY(1, 1),
  [ServiceCode] int,
  [SiteCode] int,
  [ISGlobalAdmin] int,
  [IsAdmin] int,
  [IsReader] int,
  [IsWriter] int
)
GO

CREATE TABLE [WorkerRightConnection] (
  [WorkerID] int,
  [RightID] int
)
GO

CREATE TABLE [DictWorksheetStatus] (
  [StatusCode] int PRIMARY KEY IDENTITY(1, 1),
  [StatusName] nvarchar(255),
  [StatusNameDE] nvarchar(255),
  [StatusNameEN] nvarchar(255)
)
GO

CREATE TABLE [AssetStock] (
  [AssetID] int PRIMARY KEY IDENTITY(1, 1),
  [ComponentID] int,
  [PurchaseID] int,
  [VatID] int,
  [VatID2] int,
  [VatID3] int,
  [ServiceCode] int,
  [SiteCode] int,
  [SerialNumber] nvarchar(255),
  [WarrantyYear] int,
  [ListPrice] money,
  [ListPrice2] money,
  [ListPrice3] money,
  [Quantity] int
)
GO

CREATE TABLE [AssetPurchase] (
  [PurchaseID] int PRIMARY KEY IDENTITY(1, 1),
  [PurchaseDate] date,
  [BillNumber] nvarchar(255),
  [BuyFrom] int
)
GO

CREATE TABLE [AssetComponent] (
  [ComponentID] int PRIMARY KEY IDENTITY(1, 1),
  [ComponentCode] nvarchar(255),
  [ComponentName] nvarchar(255),
  [ComponentNameDE] nvarchar(255),
  [ComponentNameEN] nvarchar(255),
  [SubCategoryID] int,
  [SellPrice] money,
  [SellPrice2] money,
  [SellPrice3] money,
  [ModifiedDate] datetime
)
GO

CREATE TABLE [AssetComponentCategory] (
  [AssteCompontentCategoryID] int PRIMARY KEY IDENTITY(1, 1),
  [CategoryName] nvarchar(255),
  [CategoryNameDE] nvarchar(255),
  [CategoryNameEN] nvarchar(255),
  [ModifiedDate] datetime
)
GO

CREATE TABLE [AssetComponentSubcategory] (
  [SubcategoryID] int PRIMARY KEY IDENTITY(1, 1),
  [AssteCompontentCategoryID] int,
  [ComponentSubcategoryName] nvarchar(255),
  [ComponentSubcategoryNameDE] nvarchar(255),
  [ComponentSubcategoryNameEN] nvarchar(255),
  [ModifiedDate] datetime
)
GO

CREATE TABLE [UsedComponent] (
  [WorksheetID] int PRIMARY KEY,
  [WorkerID] int,
  [AssetID] int,
  [Quantity] int
)
GO

CREATE TABLE [Work] (
  [WorkID] int PRIMARY KEY IDENTITY(1, 1),
  [WorkCode] nvarchar(255),
  [WorkName] nvarchar(255),
  [WorkNameDE] nvarchar(255),
  [WorkNameEN] nvarchar(255),
  [WorkSubCategoryID] int,
  [iSHourlyWork] int,
  [HourlyWorkPrice] money,
  [HourlyWorkPrice2] money,
  [HourlyWorkPrice3] money,
  [VatID] int,
  [VatID2] int,
  [VatID3] int,
  [Price] money,
  [Price2] money,
  [Price3] money
)
GO

CREATE TABLE [WorkSubcategory] (
  [WorkSubcategoryID] int PRIMARY KEY IDENTITY(1, 1),
  [WorkCategoryID] int,
  [SubcategoryName] nvarchar(255),
  [SubcategoryNameDE] nvarchar(255),
  [SubcategoryNameEN] nvarchar(255),
  [ModifiedDate] datetime
)
GO

CREATE TABLE [WorkCategory] (
  [WorkCategoryID] int PRIMARY KEY IDENTITY(1, 1),
  [CategoryName] nvarchar(255),
  [CategoryNameDE] nvarchar(255),
  [CategoryNameEN] nvarchar(255),
  [ModifiedDate] datetime
)
GO

CREATE TABLE [Bill] (
  [BillID] int PRIMARY KEY IDENTITY(1, 1),
  [WorksheetID] int,
  [SentStatus] int,
  [PaymmentStatus] int,
  [TS] Timestamp
)
GO

CREATE TABLE [DictVAT] (
  [VATID] int PRIMARY KEY IDENTITY(1, 1),
  [VATName] nvarchar(255),
  [VATNameDE] nvarchar(255),
  [VATNameEN] nvarchar(255),
  [VATPercent] int,
  [DateFrom] Date,
  [DateTo] Date
)
GO

ALTER TABLE [Address] ADD FOREIGN KEY ([CountryCode]) REFERENCES [DictCountry] ([CountryCode])
GO

ALTER TABLE [Worksheet] ADD FOREIGN KEY ([ServiceCode]) REFERENCES [Service] ([ServiceCode])
GO

ALTER TABLE [Worker] ADD FOREIGN KEY ([CustomerID]) REFERENCES [Customer] ([CustomerID])
GO

ALTER TABLE [Worker] ADD FOREIGN KEY ([ServiceCode]) REFERENCES [Service] ([ServiceCode])
GO

ALTER TABLE [AssetComponent] ADD FOREIGN KEY ([SubCategoryID]) REFERENCES [AssetComponentSubcategory] ([SubcategoryID])
GO

ALTER TABLE [UsedComponent] ADD FOREIGN KEY ([WorksheetID]) REFERENCES [Worksheet] ([WorksheetID])
GO

ALTER TABLE [WorkerConnection] ADD FOREIGN KEY ([WorkerID]) REFERENCES [Worker] ([WorkerID])
GO

ALTER TABLE [Worksheet] ADD FOREIGN KEY ([CustomerID]) REFERENCES [Customer] ([CustomerID])
GO

ALTER TABLE [AssetPurchase] ADD FOREIGN KEY ([BuyFrom]) REFERENCES [Customer] ([CustomerID])
GO

ALTER TABLE [AssetStock] ADD FOREIGN KEY ([ComponentID]) REFERENCES [AssetComponent] ([ComponentID])
GO

ALTER TABLE [WorkerConnection] ADD FOREIGN KEY ([WorksheetID]) REFERENCES [Worksheet] ([WorksheetID])
GO

ALTER TABLE [PostalCode] ADD FOREIGN KEY ([CountyID]) REFERENCES [DictCounty] ([CountyID])
GO

ALTER TABLE [DictCounty] ADD FOREIGN KEY ([CountryCode]) REFERENCES [DictCountry] ([CountryCode])
GO

ALTER TABLE [Address] ADD FOREIGN KEY ([CustomerID]) REFERENCES [Customer] ([CustomerID])
GO

ALTER TABLE [Service] ADD FOREIGN KEY ([AddressID]) REFERENCES [Address] ([AddressId])
GO

ALTER TABLE [Site] ADD FOREIGN KEY ([AddressID]) REFERENCES [Address] ([AddressId])
GO

ALTER TABLE [AssetStock] ADD FOREIGN KEY ([PurchaseID]) REFERENCES [AssetPurchase] ([PurchaseID])
GO

ALTER TABLE [UsedComponent] ADD FOREIGN KEY ([AssetID]) REFERENCES [AssetStock] ([AssetID])
GO

ALTER TABLE [Site] ADD FOREIGN KEY ([ServiceCode]) REFERENCES [Service] ([ServiceCode])
GO

ALTER TABLE [WorkerRightConnection] ADD FOREIGN KEY ([RightID]) REFERENCES [WorkerRight] ([RightID])
GO

ALTER TABLE [WorkerRightConnection] ADD FOREIGN KEY ([WorkerID]) REFERENCES [Worker] ([WorkerID])
GO

ALTER TABLE [WorksheetDetail] ADD FOREIGN KEY ([WorksheetID]) REFERENCES [Worksheet] ([WorksheetID])
GO

ALTER TABLE [Bill] ADD FOREIGN KEY ([WorksheetID]) REFERENCES [Worksheet] ([WorksheetID])
GO

ALTER TABLE [WorkerConnection] ADD FOREIGN KEY ([PrincipalWorkerID]) REFERENCES [Worker] ([WorkerID])
GO

ALTER TABLE [AssetComponentSubcategory] ADD FOREIGN KEY ([AssteCompontentCategoryID]) REFERENCES [AssetComponentCategory] ([AssteCompontentCategoryID])
GO

ALTER TABLE [Worksheet] ADD FOREIGN KEY ([WorksheetRecorderID]) REFERENCES [Worker] ([WorkerID])
GO

ALTER TABLE [WorkSubcategory] ADD FOREIGN KEY ([WorkCategoryID]) REFERENCES [WorkCategory] ([WorkCategoryID])
GO

ALTER TABLE [Work] ADD FOREIGN KEY ([WorkSubCategoryID]) REFERENCES [WorkSubcategory] ([WorkSubcategoryID])
GO

ALTER TABLE [WorksheetDetail] ADD FOREIGN KEY ([WorkerID]) REFERENCES [Worker] ([WorkerID])
GO

ALTER TABLE [Worksheet] ADD FOREIGN KEY ([StatusCode]) REFERENCES [DictWorksheetStatus] ([StatusCode])
GO

ALTER TABLE [Worksheet] ADD FOREIGN KEY ([SiteCode]) REFERENCES [Site] ([SiteCode])
GO

ALTER TABLE [WorksheetDetail] ADD FOREIGN KEY ([WorkID]) REFERENCES [Work] ([WorkID])
GO

ALTER TABLE [AssetStock] ADD FOREIGN KEY ([ServiceCode]) REFERENCES [Service] ([ServiceCode])
GO

ALTER TABLE [AssetStock] ADD FOREIGN KEY ([SiteCode]) REFERENCES [Site] ([SiteCode])
GO

ALTER TABLE [UsedComponent] ADD FOREIGN KEY ([WorkerID]) REFERENCES [Worker] ([WorkerID])
GO

ALTER TABLE [AssetStock] ADD FOREIGN KEY ([VatID]) REFERENCES [DictVAT] ([VATID])
GO

ALTER TABLE [Work] ADD FOREIGN KEY ([VatID]) REFERENCES [DictVAT] ([VATID])
GO

ALTER TABLE [Work] ADD FOREIGN KEY ([VatID2]) REFERENCES [DictVAT] ([VATID])
GO

ALTER TABLE [Work] ADD FOREIGN KEY ([VatID3]) REFERENCES [DictVAT] ([VATID])
GO

ALTER TABLE [AssetStock] ADD FOREIGN KEY ([VatID2]) REFERENCES [DictVAT] ([VATID])
GO

ALTER TABLE [AssetStock] ADD FOREIGN KEY ([VatID3]) REFERENCES [DictVAT] ([VATID])
GO



/* Data upload testing ...*/

GO

INSERT INTO dbo.DictCountry VALUES ('HU','Magyarország')
INSERT INTO dbo.DictCountry VALUES ('AT','Wels')
INSERT INTO dbo.DictCounty VALUES  ('1','HU', 'Zala')

GO
INSERT INTO dbo.Address  VALUES (NULL,'HU','8315','Gyenesdiás','Kossuth u. 12.','',GETDATE(),NULL)
INSERT INTO dbo.Address  VALUES (NULL,'HU','8360','Keszthely','Tapolcai út. 74.','',GETDATE(),NULL)
INSERT INTO dbo.Address  VALUES (NULL,'HU','8380','Hévíz','Tavirózsa u. 1.','',GETDATE(),NULL)


INSERT INTO dbo.Service VALUES ('Visionet Kft.',3,'+36 20 348-1071','info@visionet.hu',GETDATE(),NULL)

-- Insert Sites
INSERT INTO Site VALUES ('1','1','Visionet 2. - Gyenesdiás','+36 000','gyenes@visionet.hu',1,GETDATE(),NULL)
INSERT INTO Site VALUES ('2','1','Visionet 3. - Keszthely','+36 001','keszthely@visionet.hu',2,GETDATE(),NULL)


-- Add Another Service Maybe Stored Procedure

GO
INSERT INTO dbo.Address (CustomerID,CountryCode,PostalCode,CityName,AddressLine1,Addressline2,AddressFrom,AddressTo) VALUES (NULL,'HU','8360','Keszthely','Deák Ferenc u. 1.','',GETDATE(),NULL)
DECLARE @AddressID int 
SET @AddressID = SCOPE_IDENTITY () 
SELECT @AddressID
INSERT INTO dbo.Service VALUES ('Commtech 96 Kft.',@AddressID,'+36 83 111-222','info@commtech.hu',GETDATE(),NULL)


-- Get All Service
SELECT * FROM Service

-- Get All Site by Service
SELECT SE.ServiceName,SiteName, S.PhoneNumber, S.Email,A.CountryCode, A.PostalCode, A.CityName,A.AddressLine1 FROM Service SE
INNER JOIN Site S ON S.ServiceCode = S.ServiceCode
INNER JOIN Address A ON A.AddressId = S.AddressID
WHERE SE.ServiceName LIKE '%Visionet%'
ORDER BY SE.ServiceName

-- Customer Create Procedure Maybe

INSERT INTO Customer VALUES ('Adrienn','','Horvath','hadri83@gmail.com','1','1234','+3620 348-1072',NULL,'0','0',NULL,0,'0',NULL,'0',NULL)
DECLARE @CustomerID int 
SET @CustomerID = SCOPE_IDENTITY ()
INSERT INTO dbo.Address (CustomerID,CountryCode,PostalCode,CityName,AddressLine1,Addressline2,AddressFrom,AddressTo) VALUES (@CustomerID,'HU','8315','Gyenesdiás','Lõtéri u. 9.','',GETDATE(),NULL)

GO

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

-- More Address for customer
INSERT INTO dbo.Address (CustomerID,CountryCode,PostalCode,CityName,AddressLine1,Addressline2,AddressFrom,AddressTo) VALUES ('2','HU','8313','Balatongyörök','Kossuth u. 42.','',GETDATE(),NULL)

--Debug (CustomerID2 = Horváth Attila)
SELECT C.CustomerID,CONCAT (C.LastName + ' ', C.MiddleName + ' ' + C.FirstName)  AS Customername, A.PostalCode, A.CityName, A.AddressLine1, A.AddressFrom, A.AddressTo FROM Customer C
INNER JOIN dbo.Address A ON A.CustomerID = C.CustomerID 
WHERE C.FirstName = 'Attila'

--SELECT * FROM Customer
--SELECT * FROM Address

-- Worker Registration Procedure Maybe 

GO

-- Finishing Worker Create (Worker ID 2 = Horváth Attila), Pl. Dropdonw + Select -> CustomerID

INSERT INTO Worker VALUES (2,1,1,0,1)

-- Finishing Worker Create (Worker ID 2 = Kiss  István), Pl. Dropdonw + Select -> CustomerID

INSERT INTO Worker VALUES (4,1,1,0,1)

--SELECT * FROM Worker

-- Create Right (Global Admin)

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

--- Create antoher Right to user

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

-- Create Work category

GO
INSERT INTO WorkCategory VALUES ('Informatika','IT','EDV',NULL)
INSERT INTO WorkCategory VALUES ('Elektronika','Electronics','Elektronik',NULL)

-- Create Work Subcategory

INSERT INTO WorkSubCategory VALUES (1,'Belsõ','Interne Dienstleistungen','Internal Services',NULL)
INSERT INTO WorkSubCategory VALUES (1,'Külsõ','Externe Dienstleistungen','External Services',NULL)


INSERT INTO WorkSubCategory VALUES (2,'Belsõ','Interne Dienstleistungen','Internal Services',NULL)
INSERT INTO WorkSubCategory VALUES (2,'Külsõ','Externe Dienstleistungen','External Services',NULL)


-- SELECT * FROM WorkSubcategory WHERE WorkSubcategory.WorkCategoryID =2

-- Create DictVat
INSERT INTO DictVAT VALUES ('25%',NULL,NULL,0.250,'1988-01-01',NULL)
INSERT INTO DictVAT VALUES ('20%',NULL,NULL,0.200,'1988-01-01',NULL)

-- Create Works

INSERT INTO Work VALUES('SSD-01','SSD csere','SSD Austausch','SSD Replace',1,0,NULL,NULL,NULL,1,2,2,3000,10,10)
INSERT INTO Work VALUES('HDD-01','HDD csere','HDD Austausch','HDD Replace',1,0,NULL,NULL,NULL,1,2,2,3000,10,10)
INSERT INTO Work VALUES('INS-01','Linux telepítés','Linux Installation','Linux Install',1,0,NULL,NULL,NULL,1,2,2,6000,20,20)
INSERT INTO Work VALUES('INSP-01','Bevizsgálás',NULL,NULL,1,1,3000,20,20,1,2,2,NULL,NULL,NULL)
INSERT INTO Work VALUES('SWI-01','Szoftver telepítés','App Installation','Application Innstal',1,1,3000,20,20,1,2,2,NULL,NULL,NULL)

INSERT INTO Work VALUES('GPON-01','GPON Internet bekötés','NULL','NULL',2,0,NULL,NULL,NULL,1,2,2,10000,40,40)
INSERT INTO Work VALUES('DSL-01','DSL Internet bekötés','NULL','NULL',2,0,NULL,NULL,NULL,1,2,2,15000,50,50)


INSERT INTO Work VALUES('T-01','Tápegység csere',NULL,NULL,3,0,NULL,NULL,NULL,1,2,2,5000,20,20)
INSERT INTO Work VALUES('F-01','Fejállomás építés',NULL,NULL,4,0,NULL,NULL,NULL,1,2,2,15000,40,40)

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


-- Create new Worksheet (Worker ID1 = Horváth Attila)
GO

INSERT INTO dbo.Worksheet VALUES(1,3,NULL,'WS-01',0,NULL,GETDATE(),'Acer Nitro Notebook',NULL,'Nem indul a windows, linux telepítést kértek (Debian-t)',1,0,0,NULL,GETDATE())

INSERT INTO dbo.Worksheet VALUES(1,3,NULL,'WS-02',0,NULL,GETDATE(),'Asus TUF Gamin Notebook',NULL,'SSD cserét kértek, és windows telepítést',1,0,0,NULL,GETDATE())

SELECT * FROM Worksheet

-- Get Basic Worksheet Data

SELECT * FROM Worksheet W
INNER JOIN Service S ON W.ServiceCode = S.ServiceCode
INNER JOIN Worker WK ON WK.WorkerID = WorksheetRecorderID
INNER JOIN Customer C ON C.CustomerID = W.CustomerID
WHERE WorksheetNummer = 'WS-01'

SELECT * FROM Worksheet W
INNER JOIN Service S ON W.ServiceCode = S.ServiceCode
INNER JOIN Worker WK ON WK.WorkerID = WorksheetRecorderID
INNER JOIN Customer C ON C.CustomerID = W.CustomerID
WHERE WorksheetNummer = 'WS-02'


SELECT * FROM WorksheetDetail

INSERT INTO WorksheetDetail VALUES(1,1,4,1,'Hát igen a Windows az egy csoda ...',NULL)
INSERT INTO WorksheetDetail VALUES(1,1,3,1,'Végre egy értelmes munka ... ',NULL)
INSERT INTO WorksheetDetail VALUES(1,2,5,2,'Junior még a kolléga, nemgond legalább lesz bevétel ... :)',NULL)

-- WS-02 

INSERT INTO WorksheetDetail VALUES(2,1,1,1,NULL,NULL)
INSERT INTO WorksheetDetail VALUES(2,2,5,2,NULL,NULL)


-- Get Works BY Worksheet Number
GO

CREATE PROCEDURE GetWorksByWorksheetNumber
@Worksheetnumber varchar(10)
AS
SELECT
W.WorksheetNummer,CONCAT (C.LastName + ' ', C.MiddleName + ' ' + C.FirstName)  AS WorkerName,
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
WHERE WorksheetNummer = @Worksheetnumber
GO

exec GetWorksByWorksheetNumber @Worksheetnumber ='WS-01'
exec GetWorksByWorksheetNumber @Worksheetnumber ='WS-02'


-- Add B2B Partner


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

-- Asset Category 

INSERT INTO AssetComponentCategory VALUES ('Informatikai alkatrész',NULL,NULL,NULL)
INSERT INTO AssetComponentCategory VALUES ('Szerviz alkatrész',NULL,NULL,NULL)

INSERT INTO AssetComponentSubcategory VALUES(1,'Alaplap',NULL,NULL,NULL)
INSERT INTO AssetComponentSubcategory VALUES(1,'CPU',NULL,NULL,NULL)
INSERT INTO AssetComponentSubcategory VALUES(1,'Memória',NULL,NULL,NULL)
INSERT INTO AssetComponentSubcategory VALUES(1,'SSD',NULL,NULL,NULL)
INSERT INTO AssetComponentSubcategory VALUES(1,'Kiegészítõk/Kábelek/Átalakítók',NULL,NULL,NULL)

INSERT INTO AssetComponentSubcategory VALUES(2,'Alapvetõ',NULL,NULL,NULL)
INSERT INTO AssetComponentSubcategory VALUES(2,'Speciális',NULL,NULL,NULL)

-- Get all Assetcategory with Subcategory

SELECT AC.AssteCompontentCategoryID AS CategoryID,AC.CategoryName,ACS.SubcategoryID AS SubCategoryID,ACS.ComponentSubcategoryName 
FROM AssetComponentSubcategory ACS 
INNER JOIN AssetComponentCategory AC ON ACS.AssteCompontentCategoryID = AC.AssteCompontentCategoryID 
ORDER BY 1,4

-- Asset Component

INSERT INTO AssetComponent VALUES ('SSD-001','WD SN750 NVMe 1TB SSD meghajtó','WD SN750 NVMe 1TB SSD laufwerk', 'WD SN750 NVMe 1TB SSD Drive',4,60000,150,150,NULL)

SELECT * FROM AssetComponent

-- Asset Buy

INSERT INTO AssetPurchase VALUES ('20230318','SZLA007',5)
INSERT INTO AssetPurchase VALUES ('20230318','SZLA008',6)
INSERT INTO AssetPurchase VALUES ('20230318','VMI006',5)

-- SELECT * FROM AssetPurchase
-- SELECT * FROM Customer


-- Inseret Asset Stock (WD SN750 NVMe 1TB SSD meghajtó, Commtech Service) 

INSERT INTO AssetStock VALUES (1,1,1,2,2,2,NULL,123456,3,20000,50,50,1)
INSERT INTO AssetStock VALUES (1,1,1,2,2,2,NULL,7891011,3,20000,50,50,1)
INSERT INTO AssetStock VALUES (1,2,1,2,2,2,NULL,7891011,3,20000,50,50,1)


SELECT S.AssetID,C.B2bPartnerName AS BuyFromB2B,AP.PurchaseDate,SR.ServiceName,AP.BillNumber,S.SerialNumber,AC.ComponentName,S.ListPrice,S.VatID,S.VatID2,S.VatID3, AC.SellPrice 
FROM AssetStock S
INNER JOIN AssetComponent AC ON AC.ComponentID = S.ComponentID
INNER JOIN AssetPurchase AP ON AP.PurchaseID = S.PurchaseID
INNER JOIN Service SR ON SR.ServiceCode = S.ServiceCode
INNER JOIN Customer C ON C.CustomerID = AP.BuyFrom
INNER JOIN DictVAT DV ON DV.VATID = S.VatID
WHERE Quantity <> 0

-- Add used asset to worksheet, and update stock value

INSERT INTO UsedComponent VALUES (2,1,2,1)
UPDATE AssetStock SET Quantity =0 WHERE AssetID = 2 

-- SELECT * FROM UsedComponent

-- Get Used Asset Data - with used asset)

GO

CREATE PROCEDURE GetUsedComponentsByWorksheetNumber
@Worksheetnumber varchar(10)
AS
SELECT
W.WorksheetNummer ,CONCAT (C.LastName + ' ', C.MiddleName + ' ' + C.FirstName)  AS WorkerName, AC.ComponentName ,AST.SerialNumber
FROM Worksheet W
INNER JOIN UsedComponent UC ON UC.WorksheetID = W.WorksheetID
INNER JOIN AssetStock AST ON AST.AssetID = UC.AssetID
INNER JOIN AssetComponent AC ON AC.ComponentID = AST.ComponentID
INNER JOIN Worker WR ON WR.WorkerID = UC.WorkerID
INNER JOIN Customer C ON C.CustomerID = WR.CustomerID
WHERE WorksheetNummer = @Worksheetnumber
GO

exec GetUsedComponentsByWorksheetNumber @Worksheetnumber ='WS-02'