#$RelocateData = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("NORTHWND", "D:\DB Files\Northwind 2\NORTHWND.mdf")
#$RelocateLog = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("NORTHWND_log", "D:\DB Files\Northwind 2\NORTHWND_log.ldf")
#$file = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile($RelocateData,$RelocateLog) 
#$myarr=@($RelocateData,$RelocateLog)
#Restore-SqlDatabase -ServerInstance "win7-j4pvjm1" -Database "NORTHWND_2" -BackupFile "D:\Bkp\NORTHWND_2.bak" -RelocateFile $myarr

#$srv = new-object Microsoft.SqlServer.Management.Smo.Server("win7-j4pvjm1")
#$res = new-object Microsoft.SqlServer.Management.Smo.Restore
#$backup = new-object Microsoft.SqlServer.Management.Smo.Backup

#$backup.Devices.AddDevice("C:\AdventureWorks2012Backup.bak", [Microsoft.SqlServer.Management.Smo.DeviceType]::File)
#$backup.Database = "AdventureWorks2012"
#$backup.Action = [Microsoft.SqlServer.Management.Smo.BackupActionType]::Database
#$backup.Initialize = $TRUE
#$backup.SqlBackup($srv)
#$srv.Databases["AdventureWorks2012"].Drop()

#$res.Devices.AddDevice("D:\Bkp\NORTHWND_2.bak", [Microsoft.SqlServer.Management.Smo.DeviceType]::File)
#$res.Database = "NORTHWND_2"
#$res.ReplaceDatabase = $TRUE
#$res.SqlRestore($srv)

# We're holding the server names and database names that we want to deploy to in a database table.  
# We need to connect to that server to read these details
$serverName = "win7-j4pvjm1"
$databaseName = "ServerDB"
$authentication = "User id='demo';PWD='demo'"
#$authentication = "User id="xxx;PWD=xxx""  # If you are using database authentication instead of Windows authentication.
 
# Path to the scripts folder we want to deploy to the databases
$scriptsPath = "D:\Git"
 
# Path to SQLCompare.exe
$SQLComparePath = "D:\Red Gate\SQL Compare 12\sqlcompare.exe"
 
# Create SQL connection string, and connection
$ServerConnectionString = "Data Source=$serverName;Initial Catalog=$databaseName;$authentication"
$ServerConnection = new-object system.data.SqlClient.SqlConnection($ServerConnectionString);
 
# Create a Dataset to hold the DataTable 
$dataSet = new-object "System.Data.DataSet" "ServerList"
 
# Create a query
$query =  "SET NOCOUNT ON;"
$query += "SELECT serverName, environment, databaseName "
$query += "FROM   dbo.Servers; "
 
# Create a DataAdapter to populate the DataSet with the results
$dataAdapter = new-object "System.Data.SqlClient.SqlDataAdapter" ($query, $ServerConnection)
$dataAdapter.Fill($dataSet) | Out-Null
 
# Close the connection
$ServerConnection.Close()
 
# Populate the DataTable
$dataTable = new-object "System.Data.DataTable" "Servers"
$dataTable = $dataSet.Tables[0]
 
#For every row in the DataTable
$dataTable | FOREACH-OBJECT {
  "Server Name:  $($_.serverName)"
  "Database Name:  $($_.databaseName)"
  "Environment:  $($_.environment)"
 

  $srv = new-object Microsoft.SqlServer.Management.Smo.Server($($_.serverName))
  $res = new-object Microsoft.SqlServer.Management.Smo.Restore
  
  $res.Devices.AddDevice("D:\Bkp\$($_.databaseName).bak", [Microsoft.SqlServer.Management.Smo.DeviceType]::File)
  $res.Database = $($_.databaseName)
  $res.ReplaceDatabase = $TRUE
  $res.SqlRestore($srv)
  # Compare the scripts folder to the database and synchronize the database to match
  # NB. Have set SQL Compare to abort on medium level warnings.  
  $arguments = @("/scripts1:$($scriptsPath)", "/server2:$($_.serverName)", "/database2:$($_.databaseName)", "/AbortOnWarnings:Medium") + @("/sync" ) # Commented out the 'sync' parameter for safety, 
  
  write-host $arguments
  & $SQLComparePath $arguments
  "Exit Code: $LASTEXITCODE"
 }