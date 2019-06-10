###################################### 
# Sql preview section
######################################
param([int]$debug,[system.object]$dbs,[String]$FolderWithSql) 

    
    $currentDirectorySQL = $FolderWithSql
    <#
    $currentDirectorySQL = "C:\Russell\Tools\UI project\SQL\"
    $dbs = @()
    $dbs += @{dbname = "RCAnalytics";runorder = 1}
    $dbs += @{dbname = "DB";runorder =2}
    $debug = 0
    #>
    if(Test-Path $currentDirectorySQL)
    {
        
        [array]$sqlScripts = Get-ChildItem -Path $currentDirectorySQL -Filter *.sql -Recurse | Select-Object Fullname,Name
        
    }
    if($sqlScripts)
    {
       
       ############################### Creating a dataTable to store the properties needed for scripts #############################
        $global:sqlScriptsToRun = New-Object system.Data.DataTable
        $sqlScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('PKSqlScript', 'int')))
        $sqlScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('ToRun', 'string')))
        $sqlScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('FullName', 'string')))
        $sqlScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('Name', 'string')))
        $sqlScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('PartPath', 'string')))
        $sqlScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('Database', 'string')))
        $sqlScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('RunOrder', 'int')))
        $sqlScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('Errored', 'int')))
        $sqlScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('ErrorMessage', 'string')))
        $sqlScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('HasRun', 'int')))

       

       $count = 1
        ### Adding a row for each script and all needed info to the data table
        FOREACH($script in $sqlScripts){
            
            $pkSqlScript = $count
            $ToRun = 'True'
            $fullName = $script.fullName
            $Name = $script.Name
            $partPath = $script.FullName.Replace($currentDirectorySQL,"")
            $Database = $partPath -replace "\\(.*)", ""
            $runOrder = $count
            $count++
            
            ### actually adding this row to the datatable
            $null=$sqlScriptsToRun.Rows.Add($pkSqlScript,$ToRun,$fullName,$Name,$partPath,$Database,$runOrder)
            #Write-host $sqlScriptsToRun
        }

    ### confirm to run and list the order and if there are rollbacks ###
    #Write-Host "Here is the order the scripts will run in:" -BackgroundColor White -ForegroundColor Black
     ##FOREach ($script in $sqlScriptsToRun){
     $ordercount = 1
     While($ordercount -le $sqlscriptsToRun.Rows.Count)
     {
       $script = $sqlscriptsToRun | Where-Object {$_.runorder -eq $ordercount}
       $rollback = Get-Content $script.FullName | Select-String "rollback"
       
       
       If ($rollback -ne $null){
      # Write-Host $script.runorder $script.PartPath "Has a rollback" -ForegroundColor Red
       }
       ELSE {
      #Write-Host $script.runorder $script.PartPath "on" $script.db
       }
       

       $ordercount++
    } 
    ## Confirm then go 
    #Write-Host "Is this order correct? press enter to proceeed or close this to cancel" -BackgroundColor White -ForegroundColor Black
    IF($debug -ne 1){
        
        }
    } 
return ,$sqlScriptsToRun

