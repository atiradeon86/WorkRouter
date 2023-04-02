-- WorkRouter V0.3
-- DBdiagram: https://dbdiagram.io/d/63f22373296d97641d82122c

Table Customer {
  CustomerID int [pk, increment]
  FirstName varchar(30)
  MiddleName varchar(30)
  LastName varchar(30)
  Email varchar(90)
  PermitLogin bit
  CustomerPassword varchar(8)
  PhoneNumber varchar(20)
  SecondPhoneNumber varchar(20)
  IsNewsletter bit
  HasBuyerCard bit
  BuyerCardNumber varchar(10)
  isWorker bit
  isSubcontractor bit
  SubcontractorName varchar(100)
  isB2bParnter bit
  B2bPartnerName varchar(100)
 }

Table DictCountry {
  CountryCode char(2) [pk]
  CountryName varchar(50) 
}

Table DictCounty{
  CountyID int [pk,increment]
  CountryCode char(2) 
  CountyName varchar(50)
}

Table PostalCode{
 PostalCodeID int [pk, increment]
 PostalCode varchar(10)
 CountyID int
 CityName varchar(50)
}

 Table Service {
  ServiceCode int [pk,increment]
  ServiceName varchar(100)
  AddressID int
  PhoneNumber varchar(20)
  Email varchar(90)
  ServiceFrom date
  ServiceTo date
 }

 Table Site{
  SiteCode smallint [pk]
  ServiceCode int 
  SiteName varchar(100)
  PhoneNumber varchar(20)
  Email varchar(90)
  AddressID int
  SiteFrom date
  SiteTo date
}

Table Address{
  AddressId int [pk, increment]
  CustomerID int
  isMailingAddress bit
  isPrimaryAddress bit
  isBillingAddress bit
  CountryCode char(2)
  PostalCode varchar(10)
  CityName varchar(50)
  AddressLine1 varchar(100)
  Addressline2 varchar(100)
  AddressFrom date
  AddressTo date

}

Table Worksheet{
  WorksheetID int [pk, increment]
  WorksheetRecorderID smallint
  CustomerID int
  SiteCode smallint
  WorksheetNumber varchar(20)
  IsExternal bit
  ExternalJobDescription varchar(120)
  TimeOfIssue datetime
  DeviceName varchar(120)
  DeviceSerialNumber varchar(100)
  JobDescription varchar(120)
  ServiceCode int
  IsBilled bit
  IsLocked bit
  StatusCode tinyint
  TimeOfCompletion datetime
}

Table WorksheetDetail {
  WorksheetDetailID smallint [pk, increment]
  WorksheetID int
  WorkerID smallint 
  WorkID smallint 
  Quantity tinyint
  WorkerDescription varchar
  CompletionTime datetime
}

Table Worker {
  WorkerID smallint [pk, increment]
  CustomerID int
  ServiceCode int
  isInternalWorker bit
  isExternalWorker bit
  IsActive bit
}

Table WorkerConnection {
  WorkerConnectionID int [pk, increment]
  PrincipalWorkerID smallint
  WorkerID smallint
  WorksheetID int
}

Table WorkerRight {
  RightID smallint [pk, increment]
  ServiceCode int
  SiteCode smallint
  ISGlobalAdmin bit
  IsAdmin bit
  IsReader bit
  IsWriter bit
}

Table WorkerRightConnection {
  WorkerRightConnectionID int [pk, increment]
  WorkerID smallint
  RightID smallint
}

Table DictWorksheetStatus {
  StatusCode tinyint [pk, increment]
  StatusName varchar(120)
  StatusNameDE varchar(120)
  StatusNameEN varchar(120)
}

Table AssetStock {
  AssetID int [pk,increment]
  ComponentID smallint 
  PurchaseID int
  VatID tinyint
  VatID2 tinyint
  VatID3 tinyint
  ServiceCode int
  SiteCode smallint
  SerialNumber varchar(100)
  WarrantyYear tinyint
  ListPrice money
  ListPrice2 money
  ListPrice3 money
  Quantity tinyint
}

Table AssetPurchase
{
  PurchaseID int [pk, increment]
  PurchaseDate date
  BillNumber varchar(40)
  BuyFrom int
}

Table AssetComponent {
  ComponentID smallint [pk, increment] 
  ComponentCode varchar(10)
  ComponentName varchar(120)
  ComponentNameDE varchar(120)
  ComponentNameEN varchar(120)
  SubCategoryID tinyint
  SellPrice money
  SellPrice2 money
  SellPrice3 money
  ModifiedDate datetime
}

Table AssetComponentCategory{
  AssteCompontentCategoryID tinyint [pk, increment]
  CategoryName varchar(120)
  CategoryNameDE varchar(120)
  CategoryNameEN varchar(120)
  ModifiedDate datetime
}

Table AssetComponentSubcategory {
  SubcategoryID tinyint [pk, increment] 
  AssteCompontentCategoryID tinyint
  ComponentSubcategoryName varchar(120)
  ComponentSubcategoryNameDE varchar(120)
  ComponentSubcategoryNameEN varchar(120)
  ModifiedDate datetime
}

Table UsedComponent {
  WorksheetID int [pk]
  WorkerID smallint
  AssetID int
  Quantity tinyint
}

Table Work {
  WorkID smallint [pk, increment] 
  WorkCode varchar(10)
  WorkName varchar(120)
  WorkNameDE varchar(120)
  WorkNameEN varchar(120)
  WorkSubCategoryID tinyint
  iSHourlyWork bit
  HourlyWorkPrice money
  HourlyWorkPrice2 money
  HourlyWorkPrice3 money
  VatID tinyint
  VatID2 tinyint
  VatID3 tinyint
  Price money
  Price2 money
  Price3 money
}

Table WorkSubcategory {
  WorkSubcategoryID tinyint [pk, increment] 
  WorkCategoryID tinyint
  SubcategoryName varchar(120)
  SubcategoryNameDE varchar(120)
  SubcategoryNameEN varchar(120)
  ModifiedDate datetime
}

Table WorkCategory {
  WorkCategoryID tinyint [pk, increment]
  CategoryName varchar(120)
  CategoryNameDE varchar(120)
  CategoryNameEN varchar(120)
  ModifiedDate datetime
}


Table Bill {
  WorksheetID int [pk]
  SentStatus int
  PaymmentStatus varchar(20)
  TS Timestamp
}

Table DictVAT {
  VATID tinyint [pk, increment]
  VATName varchar(120)
  VATNameDE varchar(120)
  VATNameEN varchar(120)
  VATPercent decimal(3,3)
  DateFrom Date
  DateTo Date
}

Ref: "DictCountry"."CountryCode" < "Address"."CountryCode"

Ref: "Service"."ServiceCode" < "Worksheet"."ServiceCode"

Ref: "Customer"."CustomerID" < "Worker"."CustomerID"

Ref: "Service"."ServiceCode" < "Worker"."ServiceCode"

Ref: "AssetComponentSubcategory"."SubcategoryID" < "AssetComponent"."SubCategoryID"

Ref: "Worksheet"."WorksheetID" < "UsedComponent"."WorksheetID"

Ref: "Worker"."WorkerID" < "WorkerConnection"."WorkerID"

Ref: "Customer"."CustomerID" < "Worksheet"."CustomerID"

Ref: "Customer"."CustomerID" < "AssetPurchase"."BuyFrom"

Ref: "AssetComponent"."ComponentID" < "AssetStock"."ComponentID"

Ref: "Worksheet"."WorksheetID" < "WorkerConnection"."WorksheetID"

Ref: "DictCounty"."CountyID" < "PostalCode"."CountyID"

Ref: "DictCountry"."CountryCode" < "DictCounty"."CountryCode"

Ref: "Customer"."CustomerID" < "Address"."CustomerID"

Ref: "Address"."AddressId" < "Service"."AddressID"

Ref: "Address"."AddressId" < "Site"."AddressID"

Ref: "AssetPurchase"."PurchaseID" < "AssetStock"."PurchaseID"

Ref: "AssetStock"."AssetID" < "UsedComponent"."AssetID"

Ref: "Service"."ServiceCode" < "Site"."ServiceCode"

Ref: "WorkerRight"."RightID" < "WorkerRightConnection"."RightID"

Ref: "Worker"."WorkerID" < "WorkerRightConnection"."WorkerID"

Ref: "Worksheet"."WorksheetID" < "WorksheetDetail"."WorksheetID"

Ref: "Worksheet"."WorksheetID" < "Bill"."WorksheetID"

Ref: "Worker"."WorkerID" < "WorkerConnection"."PrincipalWorkerID"

Ref: "AssetComponentCategory"."AssteCompontentCategoryID" < "AssetComponentSubcategory"."AssteCompontentCategoryID"

Ref: "Worker"."WorkerID" < "Worksheet"."WorksheetRecorderID"

Ref: "WorkCategory"."WorkCategoryID" < "WorkSubcategory"."WorkCategoryID"

Ref: "WorkSubcategory"."WorkSubcategoryID" < "Work"."WorkSubCategoryID"

Ref: "Worker"."WorkerID" < "WorksheetDetail"."WorkerID"

Ref: "DictWorksheetStatus"."StatusCode" < "Worksheet"."StatusCode"

Ref: "Site"."SiteCode" < "Worksheet"."SiteCode"

Ref: "Work"."WorkID" < "WorksheetDetail"."WorkID"

Ref: "Service"."ServiceCode" < "AssetStock"."ServiceCode"

Ref: "Site"."SiteCode" < "AssetStock"."SiteCode"

Ref: "Worker"."WorkerID" < "UsedComponent"."WorkerID"

Ref: "DictVAT"."VATID" < "AssetStock"."VatID"

Ref: "DictVAT"."VATID" < "Work"."VatID"

Ref: "DictVAT"."VATID" < "Work"."VatID2"

Ref: "DictVAT"."VATID" < "Work"."VatID3"

Ref: "DictVAT"."VATID" < "AssetStock"."VatID2"

Ref: "DictVAT"."VATID" < "AssetStock"."VatID3"