Table Customer {
  CustomerID int [pk, increment]
  FirstName varchar
  MiddleName varchar
  LastName varchar
  Email varchar
  PermitLogin int
  CustomerPassword varchar
  PhoneNumber varchar
  SecondPhoneNumber varchar
  IsNewsletter int
  HasBuyerCard int
  BuyerCardNummer varchar
  isWorker int
  isSubcontractor int
  SubcontractorName varchar
  isB2bParnter int
  B2bPartnerName varchar
 }

Table DictCountry {
  CountryCode varchar [pk]
  CountryName varchar 
}

Table DictCounty{
  CountyID int [pk,increment]
  CountryCode varchar 
  CountyName varchar
}

Table PostalCode{
 PostalCodeID int [pk, increment]
 PostalCode varchar
 CountyID int
CityName varchar
}

 Table Service {
  ServiceCode int [pk,increment]
  ServiceName varchar
  AddressID int
  PhoneNumber varchar
  Email varchar
  ServiceFrom date
  ServiceTo date
 }

 Table Site{
  SiteCode int [pk]
  ServiceCode int 
  SiteName varchar
  PhoneNumber varchar
  Email varchar
  AddressID int
  SiteFrom date
  SiteTo date
}

Table Address{
  AddressId int [pk, increment]
  CustomerID int
  CountryCode varchar
  PostalCode varchar
  CityName varchar
  AddressLine1 varchar
  Addressline2 varchar
  AddressFrom date
  AddressTo date

}

Table Worksheet{
  WorksheetID int [pk, increment]
  WorksheetRecorderID int
  CustomerID int
  SiteCode int
  WorksheetNummer varchar
  IsExternal int
  ExternalJobDescription varchar
  TimeOfIssue datetime
  DeviceName varchar
  DeviceSerialNummber varchar
  JobDescription varchar
  ServiceCode int
  IsBilled int
  IsLocked int
  StatusCode int
  TimeOfCompletion datetime
}

Table WorksheetDetail {
  WorksheetDetailID int [pk, increment]
  WorksheetID int
  WorkerID int 
  WorkID int 
  Quantity int
  WorkerDescription varchar
  CompletionTime datetime
}

Table Worker {
  WorkerID int [pk, increment]
  CustomerID int
  ServiceCode int
  isInternalWorker int
  isExternalWorker int
  IsActive int
}

Table WorkerConnection {
  WorkerConnectionID int [pk, increment]
  PrincipalWorkerID int
  WorkerID int
  WorksheetID int
}

Table WorkerRight {
  RightID int [pk, increment]
  ServiceCode int
  SiteCode int
  ISGlobalAdmin int
  IsAdmin int
  IsReader int
  IsWriter int
}

Table WorkerRightConnection {
  WorkerRightConnectionID int [pk, increment]
  WorkerID int
  RightID int
}

Table DictWorksheetStatus {
  StatusCode int [pk, increment]
  StatusName varchar
  StatusNameDE varchar
  StatusNameEN varchar
}

Table AssetStock {
  AssetID int [pk,increment]
  ComponentID int 
  PurchaseID int
  VatID int
  VatID2 int
  VatID3 int
  ServiceCode int
  SiteCode int
  SerialNumber varchar
  WarrantyYear int
  ListPrice money
  ListPrice2 money
  ListPrice3 money
  Quantity int
}

Table AssetPurchase
{
  PurchaseID int [pk, increment]
  PurchaseDate date
  BillNumber varchar
  BuyFrom int
}

Table AssetComponent {
  ComponentID int [pk, increment] 
  ComponentCode varchar
  ComponentName varchar
  ComponentNameDE varchar
  ComponentNameEN varchar
  SubCategoryID int
  SellPrice money
  SellPrice2 money
  SellPrice3 money
  ModifiedDate datetime
}

Table AssetComponentCategory{
  AssteCompontentCategoryID int [pk, increment]
  CategoryName varchar
  CategoryNameDE varchar
  CategoryNameEN varchar
  ModifiedDate datetime
}


Table AssetComponentSubcategory {
  SubcategoryID int [pk, increment] 
  AssteCompontentCategoryID int
  ComponentSubcategoryName varchar
  ComponentSubcategoryNameDE varchar
  ComponentSubcategoryNameEN varchar
  ModifiedDate datetime
}

Table UsedComponent {
  WorksheetID int [pk]
  WorkerID int
  AssetID int
  Quantity int
}

Table Work {
  WorkID int [pk, increment] 
  WorkCode varchar
  WorkName varchar
  WorkNameDE varchar
  WorkNameEN varchar
  WorkSubCategoryID int
  iSHourlyWork int
  HourlyWorkPrice money
  HourlyWorkPrice2 money
  HourlyWorkPrice3 money
  VatID int
  VatID2 int
  VatID3 int
  Price money
  Price2 money
  Price3 money
}

Table WorkSubcategory {
  WorkSubcategoryID int [pk, increment] 
  WorkCategoryID int
  SubcategoryName varchar
  SubcategoryNameDE varchar
  SubcategoryNameEN varchar
  ModifiedDate datetime
}

Table WorkCategory {
  WorkCategoryID int [pk, increment]
  CategoryName varchar
  CategoryNameDE varchar
  CategoryNameEN varchar
  ModifiedDate datetime
}


Table Bill {
  BillID int [pk, increment]
  WorksheetID int
  SentStatus int
  PaymmentStatus int
  TS Timestamp
}

Table DictVAT {
  VATID int [pk, increment]
  VATName varchar
  VATNameDE varchar
  VATNameEN varchar
  VATPercent int
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