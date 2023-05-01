#Workrouter
#This is a test script for ClientAppRole

$SqlServer = "BRYAN-Work\BRYAN"
    $DB_Name = "Workrouter"
    $DB_username = "Client"
    $DB_password = "Demo1234"
    $query = "
    EXEC sys.sp_setapprole 'ClientAppRole', 'Demo1234'
    EXEC app.GetWorksByWorksheetNumber @Worksheetnumber ='WS-HU001394'
    EXEC app.GetWorksByWorksheetNumberDE @Worksheetnumber ='WS-HU001394'
    EXEC app.GetWorksByWorksheetNumberEN @Worksheetnumber ='WS-HU001394'
    "

    $data = Invoke-Sqlcmd -Query $query -Username $DB_username -Password $DB_password -ServerInstance $SQLServer -Database $DB_Name

echo $data