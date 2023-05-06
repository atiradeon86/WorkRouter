-- Connect to Active Directory Domain Controller (AD Domain - bryan.local / User: bryan.local\Administrator Pass: Demo1234#)

EXEC master.dbo.sp_addlinkedserver @server = N'ADSI', @srvproduct=N'Active Directory Services 2.5', @provider=N'ADsDSOObject', @datasrc=N'adsdatasource'

EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'ADSI',@useself=N'False',@locallogin=NULL,@rmtuser=N'bryan\Administrator',@rmtpassword='Demo1234#'
GO
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'collation compatible',  @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'rpc', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'rpc out', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'lazy schema validation',  @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'use remote collation',  @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

USE WorkRouter
GO

CREATE TABLE AdImport
(
id INT PRIMARY KEY IDENTITY(1, 1), 
sAMAccountName VARCHAR(30),
firstname VARCHAR(30),
lastname VARCHAR(30),
email VARCHAR(30),
country CHAR(2),
postalcode VARCHAR(10),
cityname VARCHAR(50),
AddressLine1 VARCHAR(100),
PhoneNumber VARCHAR(20),
ImportDate datetime,
ModifiedDate datetime,
CustomerID int
)

-- StoredProcedure LDAP Import
--DROP TABLE AdImport

GO
CREATE OR ALTER PROC LDAPImport
AS

DROP TABLE ##AdTemp
DROP TABLE ##AdImport

CREATE TABLE ##AdImport
(
id INT PRIMARY KEY IDENTITY(1, 1), 
sAMAccountName VARCHAR(30),
firstname VARCHAR(30),
lastname VARCHAR(30),
email VARCHAR(30),
country CHAR(2),
postalcode VARCHAR(10),
cityname VARCHAR(50),
AddressLine1 VARCHAR(100),
PhoneNumber VARCHAR(20)
)

SELECT * INTO ##AdTemp
FROM OPENQUERY(ADSI, 'SELECT c,displayName,sn,givenname, sAMAccountName, mail,postalCode,l,streetAddress,telephoneNumber FROM ''LDAP://bryan.local/DC=bryan,DC=local'' WHERE objectCategory=''user''')

INSERT INTO ##AdImport (country,sAMAccountName,firstname, lastname, email,postalcode,cityname,AddressLine1,PhoneNumber)
SELECT c,sAMAccountName,sn,givenname,mail,postalCode,l,streetAddress,telephoneNumber
FROM ##AdTemp WHERE sAMAccountName NOT IN('Gast','krbtgt','Administrator')

SELECT * FROM ##AdImport

DECLARE @CustomerID int
DECLARE @SAM VARCHAR(30)
DECLARE @FirstName VARCHAR(30)
DECLARE @MiddleName VARCHAR(30)
DECLARE @LastName VARCHAR(30)
DECLARE @Email VARCHAR(90)
DECLARE @PhoneNumber VARCHAR(20)
DECLARE @Country VARCHAR(10)
DECLARE @Postalcode VARCHAR(10)
DECLARE @CityName VARCHAR(50)
DECLARE @AddressLine1 VARCHAR(100)
DECLARE @UserCheck tinyint
DECLARE @Password varchar(8)
DECLARE @ImportDate datetime
DECLARE @ModifiedDate datetime
DECLARE @AdimportID int
DECLARE @AddressID int
DECLARE @PreCheck int

DECLARE db_cursor CURSOR FOR 
SELECT sAMAccountName 
FROM ##AdImport

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @SAM  

WHILE @@FETCH_STATUS = 0  
BEGIN  
      SET @FirstName = (SELECT firstname FROM ##AdImport WHERE sAMAccountName = @SAM)
	  SET @LastName = (SELECT lastname FROM ##AdImport WHERE sAMAccountName = @SAM)
	  SET @Email = (SELECT email FROM ##AdImport WHERE sAMAccountName = @SAM)
	  SET @PhoneNumber = (SELECT PhoneNumber FROM ##AdImport WHERE sAMAccountName = @SAM)
	  SET @Postalcode = (SELECT postalcode FROM ##AdImport WHERE sAMAccountName = @SAM)
	  SET @CityName = (SELECT cityname FROM ##AdImport WHERE sAMAccountName = @SAM)
	  SET @AddressLine1 = (SELECT AddressLine1 FROM ##AdImport WHERE sAMAccountName = @SAM)
	  SET @Country = (SELECT country FROM ##AdImport WHERE sAMAccountName = @SAM)
	  SET @MiddleName = NULL
	  SET @Password =(SELECT LEFT(NEWID(),8))
	  SET @ImportDate =(SELECT SYSDATETIME ())
	  SET @ModifiedDate =(SELECT SYSDATETIME ())

	  --PreCheck
	  -- If User is imported We need to update

	  SET @PreCheck = (SELECT count(id) FROM Adimport WHERE sAMAccountName = @SAM)
	  SELECT @PreCheck

	  IF @PreCheck = 1 
	  BEGIN
	    
		SET @CustomerID = (SELECT CustomerID FROM Adimport WHERE sAMAccountName = @SAM)
		SET @AdimportID = (SELECT id FROM Adimport WHERE sAMAccountName = @SAM)

		SET @AddressID = (SELECT AddressID FROM Address A WHERE A.CustomerID  = @CustomerID)
		SELECT @AddressID

		-- Update  the real customer table, update tehe Adimport set modification date, and update address table
		UPDATE Customer SET FirstName = @FirstName, LastName = @LastName,Email = @Email,PhoneNumber = @PhoneNumber WHERE CustomerID = @CustomerID 
		UPDATE Adimport SET FirstName = @FirstName, LastName = @LastName,Email = @Email, country = @Country, postalcode = @Postalcode, AddressLine1 = @AddressLine1, PhoneNumber = @PhoneNumber, ModifiedDate = @ModifiedDate  WHERE id = @AdimportID 
		UPDATE Address SET CountryCode = @Country, PostalCode = @Postalcode, CityName = @CityName, AddressLine1 = @AddressLine1 WHERE AddressId = @AddressID
	  
	  END

	  ELSE IF @PreCheck = 0
		BEGIN

		  SET @UserCheck = (SELECT count(CustomerID) FROM Customer C WHERE C.FirstName = @Firstname and C.LastName = @LastName and C.Email = @Email)
		  SELECT @UserCheck

		  IF @UserCheck = 0
			BEGIN
				EXEC CreateCustomer @FirstName,@MiddleName,@LastName,@PhoneNumber,@Email,'0'
				SET @CustomerID = (SELECT CustomerID FROM Customer C WHERE C.FirstName = @Firstname and C.LastName = @LastName and C.Email = @Email)
				INSERT INTO AdImport (sAMAccountName,firstname ,lastname ,email ,postalcode ,country,cityname,AddressLine1,PhoneNumber,ImportDate,CustomerID)
				VALUES (@SAM,@LastName,@FirstName,@Email,@Postalcode,@Country,@CityName,@AddressLine1,@PhoneNumber,@ImportDate,@CustomerID)
				INSERT INTO dbo.Address (CustomerID,CountryCode,PostalCode,CityName,AddressLine1,Addressline2,AddressFrom,AddressTo) VALUES (@CustomerID,@Country,@Postalcode,@CityName,@AddressLine1,NULL,SYSDATETIME(),NULL)
			END

		END

      FETCH NEXT FROM db_cursor INTO @SAM 
END 

CLOSE db_cursor  
DEALLOCATE db_cursor

-- Import Testing

GO
USE WorkRouter

GO
EXEC LDAPImport

SELECT * FROM Customer ORDER BY CustomerID DESC
SELECT * FROM AdImport

SELECT C.FirstName, C.LastName, Email, CountryCode, PostalCode, CityName,AddressLine1,PhoneNumber FROM Customer C
INNER JOIN Address A ON A.CustomerID = C.CustomerID
WHERE C.Firstname='ADUser'


