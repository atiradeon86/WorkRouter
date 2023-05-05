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

CREATE TABLE #AdImport
(
id INT PRIMARY KEY IDENTITY(1, 1), 
firstname VARCHAR(30),
lastname VARCHAR(30),
email VARCHAR(30),
postalcode VARCHAR(10),
cityname VARCHAR(50),
AddressLine1 VARCHAR(100),
PhoneNumber VARCHAR(20)
)

-- LDAP query testing add the requiered data to temp table

SELECT * INTO #AdTemp
FROM OPENQUERY(ADSI, 'SELECT displayName,sn,givenname, sAMAccountName, mail,postalCode,l,streetAddress,telephoneNumber FROM ''LDAP://bryan.local/DC=bryan,DC=local'' WHERE objectCategory=''user''')

-- #Creating a sorted temp table for check, and import

INSERT INTO #AdImport (firstname, lastname, email,postalcode,cityname,AddressLine1,PhoneNumber)
SELECT sn,givenname,mail,postalCode,l,streetAddress,telephoneNumber
FROM #AdTemp

SELECT * FROM #AdImport

DROP TABLE #AdTemp
DROP TABLE #AdImport




