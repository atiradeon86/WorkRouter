-- Enable .Net Clr
EXEC sp_configure 'clr enabled',1
RECONFIGURE; 

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

EXEC sp_configure 'clr strict security', 0;
RECONFIGURE;

-- Creating Assembly 
USE Workrouter
GO

CREATE ASSEMBLY Regex FROM 'E:\GitHub\vizsgaremek-atiradeon86\Regex.dll' 
WITH PERMISSION_SET = SAFE
GO 

-- Creating EmailRegex function from EmailRegex Assembly
CREATE FUNCTION EmailCheck(@S nvarchar(max)) RETURNS nvarchar(max)   
AS EXTERNAL NAME Regex.[Bryan.Regex4Sql].EmailTesting
GO

-- Creating Regex function (Universal) from EmailRegex Assembly
CREATE FUNCTION Regex(@RegEx nvarchar(max), @S nvarchar(max)) RETURNS nvarchar(max)   
AS EXTERNAL NAME Regex.[Bryan.UniversalRegex4Sql].Regex
GO

SELECT dbo.EmailCheck('atiradeon86@gmail.com')

-- Universal Regex testing

DECLARE @RegEx varchar(1000) = '(?:[a-z0-9!#$%&''*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*|"' + 
		'(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")' + 
		'@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])' +
		'?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.)' +
		'{3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:' +
		'[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])'

SELECT dbo.Regex(LOWER('Atiradeon86@gmail.com'),@RegEx)
GO

DROP FUNCTION IF EXISTS dbo.EmailCheck
DROP FUNCTION IF EXISTS dbo.Regex

GO
DROP ASSEMBLY IF EXISTS Regex
