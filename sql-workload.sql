EXEC GetWorksheetBasicData @Worksheetnumber='WS-AT000056'
EXEC GetWorksByWorksheetNumber 'WS-HU000004'

SELECT * FROM Customer WHERE FirstName = 'Attila'
SELECT * FROM Customer WHERE LastName = 'Horvath'
SELECT * FROM Customer WHERE Firstname ='Attila' AND LastName = 'Horvath'
SELECT * FROM Customer WHERE email ='atiradeon86@gmail.com'
SELECT * FROM Customer WHERE PhoneNumber = '+3620 348-1070'