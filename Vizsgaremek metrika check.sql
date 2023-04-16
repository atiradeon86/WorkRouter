
	DECLARE @StudentName varchar(50) = 'Horváth Attila'
	
	--DELETE Training.dbo.Vizsgaremek
	--WHERE StudentName = @StudentName

	--INSERT dbo.Vizsgaremek
-- Táblák száma >= 9, plusz info: sorok száma az egyes táblákban
	SELECT @StudentName StudentName, 1 ItemNo, 'Tables' Item, COUNT(1) Qty, 
		CASE WHEN COUNT(1) > 15 THEN 'Very good' WHEN COUNT(1) >= 9 THEN 'Good' ELSE 'Bad' END Result,
		(SELECT TABLE_NAME "Name", P.rows NoOfRows 
		 FROM INFORMATION_SCHEMA.TABLES "Table"
		 INNER JOIN sys.partitions P ON "Table".TABLE_NAME = OBJECT_NAME(P.object_id) AND index_id IN (0,1)
		 WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_NAME <> 'sysdiagrams'
		 ORDER BY 1
		 FOR XML RAW, ROOT('Tables'), TYPE) Details
	FROM INFORMATION_SCHEMA.TABLES T
	WHERE T.TABLE_TYPE = 'BASE TABLE' AND T.TABLE_NAME <> 'sysdiagrams'

-- Az adatbázis összes oszlopának száma	>= 40
	UNION ALL
	SELECT @StudentName StudentName, 2, 'Columns', COUNT(1), 
		CASE WHEN COUNT(1) > 70 THEN 'Very good' WHEN COUNT(1) >= 40 THEN 'Good' ELSE 'Bad' END Result,
		NULL
	FROM INFORMATION_SCHEMA.COLUMNS C
	INNER JOIN INFORMATION_SCHEMA.TABLES T ON C.TABLE_NAME = T.TABLE_NAME
	WHERE T.TABLE_TYPE = 'BASE TABLE' AND T.TABLE_NAME <> 'sysdiagrams'

-- Check constraint	>= 3
	UNION ALL
	SELECT @StudentName StudentName, 3, 'Check constraints', COUNT(1),
		CASE WHEN COUNT(1) > 5 THEN 'Very good' WHEN COUNT(1) >= 3 THEN 'Good' ELSE 'Bad' END Result,
		(SELECT CONSTRAINT_NAME, CHECK_CLAUSE  
		 FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS "Check_Constraint" 
		 ORDER BY 1
		 FOR XML AUTO, ROOT('Check_Constraints'), TYPE) Details
	FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS

-- Elsõdleges kulcs	minden táblán legyen
	UNION ALL
	SELECT @StudentName StudentName, 4, 'Primary Keys', COUNT(1), NULL, 
		(SELECT TABLE_NAME, CONSTRAINT_NAME
		 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS "Primary_Key" 
		 WHERE CONSTRAINT_TYPE = 'PRIMARY KEY' AND TABLE_NAME <> 'sysdiagrams'
		 ORDER BY 1
		 FOR XML AUTO, ROOT('Primary_Keys'), TYPE) Details
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
	WHERE CONSTRAINT_TYPE = 'PRIMARY KEY' AND TABLE_NAME <> 'sysdiagrams'

-- Hiányzó elsõdleges kulcsok
	UNION ALL
	SELECT @StudentName StudentName, 5, 'Missing Primary Keys', COUNT(1), NULL,
		(SELECT T.TABLE_NAME
		 FROM INFORMATION_SCHEMA.TABLES T
		 LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS C ON T.TABLE_NAME = C.TABLE_NAME AND
			C.CONSTRAINT_TYPE = 'PRIMARY KEY' AND T.TABLE_NAME <> 'sysdiagrams'
		 WHERE T.TABLE_TYPE = 'BASE TABLE' AND T.TABLE_NAME <> 'sysdiagrams' AND C.TABLE_NAME IS NULL
		 ORDER BY 1
		 FOR XML AUTO, ROOT('Missing_Primary_Keys'), TYPE) Details
	FROM INFORMATION_SCHEMA.TABLES T
	LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS C ON T.TABLE_NAME = C.TABLE_NAME AND
		C.CONSTRAINT_TYPE = 'PRIMARY KEY' AND T.TABLE_NAME <> 'sysdiagrams'
	WHERE T.TABLE_TYPE = 'BASE TABLE' AND T.TABLE_NAME <> 'sysdiagrams' AND C.TABLE_NAME IS NULL

--	Idegen kulcsok használata
	UNION ALL
	SELECT @StudentName StudentName, 6, 'Foreign Keys', COUNT(1), NULL,
		(SELECT TABLE_NAME, CONSTRAINT_NAME
		 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS "Foreign_Key" 
		 WHERE CONSTRAINT_TYPE = 'FOREIGN KEY' AND TABLE_NAME <> 'sysdiagrams'
		 ORDER BY 1
		 FOR XML AUTO, ROOT('Foreign_Keys'), TYPE) Details
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
	WHERE CONSTRAINT_TYPE = 'FOREIGN KEY' AND TABLE_NAME <> 'sysdiagrams'

-- Hiányzó idegen kulcsok, azaz "levegõben lógó" táblák
	UNION ALL
	SELECT @StudentName StudentName, 7, 'Missing Foreign Keys', COUNT(1), NULL,
		(SELECT T.TABLE_NAME
		 FROM INFORMATION_SCHEMA.TABLES T
		 LEFT JOIN sys.foreign_keys PT ON T.TABLE_NAME = OBJECT_NAME(PT.parent_object_id)
		 LEFT JOIN sys.foreign_keys RT ON T.TABLE_NAME = OBJECT_NAME(RT.referenced_object_id)
		 WHERE T.TABLE_TYPE = 'BASE TABLE' AND T.TABLE_NAME <> 'sysdiagrams' AND 
			PT.object_id IS NULL AND RT.object_id IS NULL
		 ORDER BY 1
		 FOR XML AUTO, ROOT('Missing_Foreign_Keys'), TYPE) Details
	FROM INFORMATION_SCHEMA.TABLES T
	LEFT JOIN sys.foreign_keys PT ON T.TABLE_NAME = OBJECT_NAME(PT.parent_object_id)
	LEFT JOIN sys.foreign_keys RT ON T.TABLE_NAME = OBJECT_NAME(RT.referenced_object_id)
	WHERE T.TABLE_TYPE = 'BASE TABLE' AND T.TABLE_NAME <> 'sysdiagrams' AND 
		PT.object_id IS NULL AND RT.object_id IS NULL

-- Skalár függvény >= 1
	UNION ALL
	SELECT @StudentName StudentName, 8, 'Scalar functions', COUNT(1),
		CASE WHEN COUNT(1) > 2 THEN 'Very good' WHEN COUNT(1) >= 1 THEN 'Good' ELSE 'Bad' END Result,
		(SELECT name, 
			(SELECT REPLACE(REPLACE(X.value, CHAR(9), ' '),CHAR(13), ' ') V
			 FROM STRING_SPLIT(OBJECT_DEFINITION(Scalar_Function.object_id), CHAR(10)) X
			 FOR XML RAW ('R'), TYPE) definition
		 FROM sys.objects Scalar_Function
		 WHERE type_desc = 'SQL_SCALAR_FUNCTION' AND name NOT LIKE '%diagram%'
		 FOR XML AUTO, ROOT('Scalar_Functions'), TYPE) Details
	FROM sys.objects o
	WHERE type_desc = 'SQL_SCALAR_FUNCTION' AND name NOT LIKE '%diagram%'

-- TVF opcionális
	UNION ALL
	SELECT @StudentName StudentName, 9, 'Table valued functions', COUNT(1),
		IIF(COUNT(1) >= 1, 'Very good',''),
		(SELECT name, 
			(SELECT REPLACE(REPLACE(X.value, CHAR(9), ' '),CHAR(13), ' ') V
			 FROM STRING_SPLIT(OBJECT_DEFINITION(TVF.object_id), CHAR(10)) X
			 FOR XML RAW ('R'), TYPE) definition
		 FROM sys.objects TVF
		 WHERE type_desc = 'SQL_INLINE_TABLE_VALUED_FUNCTION' AND name NOT LIKE '%diagram%'
		 FOR XML AUTO, ROOT('TVFs'), TYPE) Details
	FROM sys.objects o
	WHERE type_desc = 'SQL_INLINE_TABLE_VALUED_FUNCTION' AND name NOT LIKE '%diagram%'

-- DML trigger >= 1
	UNION ALL
	SELECT @StudentName StudentName, 10, 'Triggers', COUNT(1), 
		CASE WHEN COUNT(1) > 2 THEN 'Very good' WHEN COUNT(1) >= 1 THEN 'Good' ELSE 'Bad' END Result,
		(SELECT name, 
			(SELECT REPLACE(REPLACE(X.value, CHAR(9), ' '),CHAR(13), ' ') V
			 FROM STRING_SPLIT(OBJECT_DEFINITION(DML_Trigger.object_id), CHAR(10)) X
			 FOR XML RAW ('R'), TYPE) definition
		 FROM sys.objects DML_Trigger
		 WHERE type_desc = 'SQL_TRIGGER'
		 FOR XML AUTO, ROOT('DML_Triggers'), TYPE) Details
	FROM sys.objects o
	WHERE type_desc = 'SQL_TRIGGER'

-- Tárolt eljárás >= 3, amibõl egy külsõ fájl felolvasása, ellenõrzése, és adatok betöltése, a továbbiak CRUD mûveletekhez kapcsolódhatnak
	UNION ALL
	SELECT @StudentName StudentName, 11, 'Stored Procedures', COUNT(1), 
		CASE WHEN COUNT(1) > 5 THEN 'Very good' WHEN COUNT(1) >= 3 THEN 'Good' ELSE 'Bad' END Result,
		(SELECT name, 
			(SELECT REPLACE(REPLACE(X.value, CHAR(9), ' '),CHAR(13), ' ') V
			 FROM STRING_SPLIT(OBJECT_DEFINITION(Stored_Procedure.object_id), CHAR(10)) X
			 FOR XML RAW ('R'), TYPE) definition
		 FROM sys.objects Stored_Procedure
		 WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name NOT LIKE '%diagram%'
		 FOR XML AUTO, ROOT('Stored_Procedures'), TYPE) Details
	FROM sys.objects o
	WHERE type_desc = 'SQL_STORED_PROCEDURE' AND name NOT LIKE '%diagram%'

-- View >= 3
	UNION ALL
	SELECT @StudentName StudentName, 12, 'Views', COUNT(1), 
		CASE WHEN COUNT(1) > 5 THEN 'Very good' WHEN COUNT(1) >= 3 THEN 'Good' ELSE 'Bad' END Result,
		(SELECT name, 
			(SELECT REPLACE(REPLACE(X.value, CHAR(9), ' '),CHAR(13), ' ') V
			 FROM STRING_SPLIT(OBJECT_DEFINITION("View".object_id), CHAR(10)) X
			 FOR XML RAW ('R'), TYPE) definition
		 FROM sys.objects "View"
		 WHERE type_desc = 'VIEW' --AND name NOT LIKE '%diagram%'
		 FOR XML AUTO, ROOT('Views'), TYPE) Details
	FROM sys.objects o
	WHERE type_desc = 'VIEW' --AND name NOT LIKE '%diagram%'

-- Indexek - kivéve a PRIMARY KEY indexek, mert azok már szerepeltek korábban
	UNION ALL
	SELECT @StudentName StudentName, 13, 'Indexes', COUNT(1),
		CASE WHEN COUNT(1) > 5 THEN 'Very good' WHEN COUNT(1) >= 3 THEN 'Good' ELSE 'Bad' END Result,
		(SELECT OBJECT_NAME([Index].object_id) TableName, [Index].name IndexName, 
			[Index].type_desc + IIF([Index].is_unique=1,', UNIQUE', '') + IIF([Index].has_filter=1, ', FILTERED', '') IndexType,
			(SELECT STRING_AGG(COL_NAME(ic.object_id,ic.column_id), ', ') 
			 FROM sys.index_columns ic
			 WHERE ic.object_id = [Index].object_id AND ic.index_id = [Index].index_id) IndexColumns 
		 FROM sys.indexes [Index]
		 INNER JOIN sys.objects SO ON [Index].object_id = SO.object_id AND SO.name NOT LIKE '%diagram%'
		 WHERE is_primary_key = 0 AND [Index].index_id <> 0 AND SO.is_ms_shipped = 0
		 ORDER BY 1, index_id
		 FOR XML RAW, ROOT('Indexes'), TYPE) Details
	FROM sys.indexes I
	INNER JOIN sys.objects O ON I.object_id = O.object_id AND O.name NOT LIKE '%diagram%'
	WHERE I.is_primary_key = 0 AND I.index_id <> 0 AND O.is_ms_shipped = 0

-- A Login nem jön át a .bak fájllal, ezért azt nem tudjuk tesztelni, csak implicit módon a User mentén
	UNION ALL
	SELECT @StudentName StudentName, 14, 'Users', COUNT(1),
		CASE WHEN COUNT(1) > 5 THEN 'Very good' WHEN COUNT(1) >= 3 THEN 'Good' ELSE 'Bad' END Result,
		(SELECT name UserName, type_desc UserType  
		 FROM sys.database_principals [User]
		 WHERE type IN ('S','U') AND is_fixed_role = 0 AND
			name NOT IN ('dbo','guest','sys','INFORMATION_SCHEMA')
		 ORDER BY 1
		 FOR XML RAW, ROOT('Users'), TYPE) Details
	FROM sys.database_principals U
	WHERE U.type IN ('S','U') AND is_fixed_role = 0 AND
		name NOT IN ('dbo','guest','sys','INFORMATION_SCHEMA')

-- Database role >= 3
	UNION ALL
	SELECT @StudentName StudentName, 15, 'Database Roles', COUNT(1),
		CASE WHEN COUNT(1) > 5 THEN 'Very good' WHEN COUNT(1) >= 3 THEN 'Good' ELSE 'Bad' END Result,
		(SELECT name RoleName
		 FROM sys.database_principals Database_Role
		 WHERE type_desc = 'DATABASE_ROLE' AND is_fixed_role = 0 AND name <> 'public'
		 ORDER BY 1
		 FOR XML RAW, ROOT('Database_Roles'), TYPE) Details
	FROM sys.database_principals
	WHERE type_desc = 'DATABASE_ROLE' AND is_fixed_role = 0 AND name <> 'public'

-- Application role
	UNION ALL
	SELECT @StudentName StudentName, 16, 'Application Roles', COUNT(1),
		IIF(COUNT(1) >= 1, 'Very good',''),
		(SELECT name RoleName
		 FROM sys.database_principals Application_Role
		 WHERE type_desc = 'APPLICATION_ROLE'
		 ORDER BY 1
		 FOR XML RAW, ROOT('Application_Roles'), TYPE) Details
	FROM sys.database_principals
	WHERE type_desc = 'APPLICATION_ROLE'
