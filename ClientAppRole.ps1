#Workrouter
#This is a test script for ClientAppRole

$SqlServer = "BRYAN-i5-12600K\BRYAN"
    $DB_Name = "Workrouter"
    $DB_username = "Client"
    $DB_password = "Demo1234"
    $query = "
    EXEC sys.sp_setapprole 'ClientAppRole', 'Demo1234'
    EXEC app.GetWorksByWorksheetNumber @Worksheetnumber ='WS-AT000010'
    EXEC app.GetWorksByWorksheetNumberDE @Worksheetnumber ='WS-AT000010'
    EXEC app.GetWorksByWorksheetNumberEN @Worksheetnumber ='WS-AT000010'
    "

    $data = Invoke-Sqlcmd -Query $query -Username $DB_username -Password $DB_password -ServerInstance $SQLServer -Database $DB_Name

echo $data