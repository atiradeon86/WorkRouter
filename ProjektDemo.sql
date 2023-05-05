USE WorkRouter
GO

-- Creating Demo Data ...

GO
-- EXEC CreateRandomCustomer @count = 3000
GO
-- EXEC CreateRandomWorksheet 3200

-- Services

SELECT * FROM Service

-- Get All Site by ServiceName for example

SELECT SE.ServiceName,SiteName, S.PhoneNumber, S.Email,A.CountryCode, A.PostalCode, A.CityName,A.AddressLine1 FROM Service SE
INNER JOIN Site S ON S.ServiceCode = S.ServiceCode
INNER JOIN Address A ON A.AddressId = S.AddressID
WHERE SE.ServiceName LIKE '%Visionet%'
ORDER BY SE.ServiceName

-- Multiple Address handling

--Example

SELECT C.CustomerID,CONCAT (C.LastName + ' ', C.MiddleName + ' ' + C.FirstName)  AS Customername, A.PostalCode, A.CityName, A.AddressLine1, A.AddressFrom, A.AddressTo,A.isBillingAddress,A.isMailingAddress,A.isPrimaryAddress FROM Customer C
INNER JOIN dbo.Address A ON A.CustomerID = C.CustomerID 
WHERE C.FirstName = 'Adrienn' and C.LastName = 'Horvath'


-- RightManagement Example

-- Get Worker Rights
SELECT S.ServiceName,CONCAT (C.LastName + ' ', C.MiddleName + ' ' + C.FirstName),WR.IsAdmin,WR.IsGlobalAdmin,WR.IsReader,WR.IsWriter  AS IsWriter,WR.ServiceCode FROM Worker W 
INNER JOIN WorkerRightConnection WRC ON WRC.WorkerID = W.WorkerID
INNER JOIN WorkerRight WR ON WR.RightID = WRC.RightID
INNER JOIN Service S ON S.ServiceCode = WR.ServiceCode
INNER JOIN Customer C ON C.CustomerID = W.CustomerID

-- Works with category handling

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

-- Same worksheet demo data

-- Example internal worksheet SSD Replace with asset

EXEC GetWorksheetBasicData @Worksheetnumber='WS-HU000002'
EXEC GetWorksByWorksheetNumber @Worksheetnumber='WS-HU000002'
EXEC GetUsedComponentsByWorksheetNumber @Worksheetnumber='WS-HU000002'

-- Example external worksheet 
EXEC GetWorksheetBasicData @Worksheetnumber='WS-HU000458'
EXEC GetWorksByWorksheetNumber @Worksheetnumber='WS-HU000458'


EXEC GetWorksheetBasicData @Worksheetnumber='WS-AT000056'
EXEC GetWorksByWorksheetNumber @Worksheetnumber='WS-AT000056'

-- Route work to workers example

--SELECT * FROM worksheet W WHERE W.WorksheetNumber = 'WS-AT000050'

-- INSERT INTO WorkerConnection VALUES(2,1,175)
-- INSERT INTO WorkerConnection VALUES(2,2,175)


EXEC GetWorksheetBasicData @Worksheetnumber='WS-AT000050'
EXEC GetWorksByWorksheetNumber @Worksheetnumber='WS-AT000050'

SELECT WS.WorksheetNumber,WS.ExternalJobDescription,
CONCAT (CU.LastName,+' ', CU.MiddleName + ' ', Cu.FirstName) AS Customer, 
CONCAT (A.PostalCode,+ ',', A.CityName + ' ',A.AddressLine1) AS CustomerAddress,
CU.PhoneNumber,
CONCAT (PR.LastName + ' ', PR.MiddleName + ' ' + PR.FirstName) AS PrincipalWorker,
CONCAT (WORKER.LastName + ' ', WORKER.MiddleName + ' ' + WORKER.FirstName) AS Worker
FROM WorkerConnection WC
INNER JOIN Worker P ON P.WorkerID = WC.WorkerID
INNER JOIN Customer WORKER ON WORKER.CustomerID = P.CustomerID
INNER JOIN Customer PR ON PR.CustomerID = WC.PrincipalWorkerID
INNER JOIN Worksheet WS ON WS.WorksheetID = WC.WorksheetID
INNER JOIN Customer CU ON CU.CustomerID = WS.CustomerID
INNER JOIN Address A ON A.CustomerID = CU.CustomerID
WHERE WS.WorksheetNumber = 'WS-AT000050'

-- Multifunction Customer data handling for example B2BPartners

-- Get All B2B Partner
SELECT C.B2bPartnerName, C.PhoneNumber, C.Email, CONCAT(A.PostalCode,+ ' ' ,A.CityName + ' ', A.AddressLine1) 
FROM Customer C 
INNER JOIN Address A ON A.CustomerID = C.CustomerID WHERE isB2bParnter =  1

-- Assets with category management, based on bill and S/N

-- Get all Assetcategory with Subcategory

SELECT AC.AssteCompontentCategoryID AS CategoryID,AC.CategoryName,AC.CategoryNameDE,AC.CategoryNameEN,ACS.SubcategoryID,ACS.ComponentSubcategoryName,ACS.ComponentSubcategoryNameDE,ACS.ComponentSubcategoryNameEN 
FROM AssetComponentSubcategory ACS 
INNER JOIN AssetComponentCategory AC ON ACS.AssteCompontentCategoryID = AC.AssteCompontentCategoryID 
ORDER BY 1,3

-- Get Stock elements By Component ID (For exampl 1 = WD SN750 NVMe 1TB SSD) 

SELECT S.AssetID,C.B2bPartnerName AS BuyFromB2B,AP.PurchaseDate,SR.ServiceName,AP.BillNumber,S.SerialNumber,AC.ComponentName,S.ListPrice,DV.VATName,DV.VATNameDE,DV.VATNameEN, AC.SellPrice 
FROM AssetStock S
INNER JOIN AssetComponent AC ON AC.ComponentID = S.ComponentID
INNER JOIN AssetPurchase AP ON AP.PurchaseID = S.PurchaseID
INNER JOIN Service SR ON SR.ServiceCode = S.ServiceCode
INNER JOIN Customer C ON C.CustomerID = AP.BuyFrom
INNER JOIN DictVAT DV ON DV.VATID = S.VatID
WHERE Quantity <> 0 AND AC.ComponentID = 1


-- Index demo ---

SELECT * FROM customer
SELECT COUNT (1) FROM customer

SELECT * FROM Customer WHERE FirstName = 'Attila'
SELECT * FROM Customer WHERE LastName = 'Horvath'
SELECT * FROM Customer WHERE Firstname ='Attila' AND LastName = 'Horvath'
SELECT * FROM Customer WHERE email ='atiradeon86@gmail.com'
SELECT * FROM Customer WHERE PhoneNumber = '+3620 348-1070'

-- Creating indexes

GO
CREATE NONCLUSTERED INDEX IX_Customer_Firstname
   ON Customer (Firstname) INCLUDE (MiddleName,LastName)

GO
DROP INDEX [IX_Customer_Firstname] ON [dbo].[Customer]

CREATE NONCLUSTERED INDEX IX_WorksheetID ON  WorksheetDetail(WorksheetID) INCLUDE(WorkerID,WorkID,Quantity,WorkerDescription)

GO
DROP INDEX [IX_WorksheetID] ON [dbo].[WorksheetDetail]
GO

-- Statistic (Views)

-- Stat Worksheet (Year, Service, Worksheet Number)
SELECT * FROM vStatWorksheet

-- Stat BuyerCard (Customer, Worksheet Number)
SELECT * FROM vStatCustomerBuyerCard ORDER BY 6 DESC

-- Stat BuyerCard (Customer Number / City)
SELECT * FROM vStatCustomerCity ORDER BY 2 DESC

-- Stat BuyerCard (Customer Number / County)
SELECT * FROM vStatCustomerCounty ORDER BY 2 DESC

-- E-mail Test Demo
DECLARE @Result int
EXEC @Result =  CreateCustomer 'Kiss','Nagy','István','+36 20 358 1751','kiss.gmailcom','0'
SELECT @Result

DECLARE @Result int
EXEC @Result =  CreateCustomer 'Kiss','Nagy','István','+36 20 358 1751','kiss@gmail.com','0'
SELECT @Result

-- SELECT * FROM Customer WHERE email = 'kiss@gmail.com'
-- DELETE FROM Customer WHERE email = 'kiss@gmail.com'