###################################### 
# Sql preview section
######################################
param([int]$debug,[String]$FolderWithScripts) 

    
    $currentDirectorySQL = $FolderWithScripts
    <#
    $currentDirectorySQL = "C:\Russell\Tools\UI project\SQL\"
    $dbs = @()
    $dbs += @{dbname = "RCAnalytics";runorder = 1}
    $dbs += @{dbname = "DB";runorder =2}
    $debug = 0
    #>
    if(Test-Path $currentDirectorySQL)
    {
        
        [array]$sqlScripts = Get-ChildItem -Path $currentDirectorySQL -Filter *.ps1 -Recurse | Select-Object Fullname,Name
        
    }
    if($sqlScripts)
    {
       
       ############################### Creating a dataTable to store the properties needed for scripts #############################
        $global:ScriptsToRun = New-Object system.Data.DataTable
        $ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('PKScript', 'int')))
        $ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('ToRun', 'string')))
        $ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('FullName', 'string')))
        $ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('Name', 'string')))
        $ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('PartPath', 'string')))
        $ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('Database', 'string')))
        $ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('RunOrder', 'int')))
        $ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('Errored', 'int')))
        $ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('ErrorMessage', 'string')))
        $ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('HasRun', 'int')))

       

       $count = 1
        ### Adding a row for each script and all needed info to the data table
        FOREACH($script in $sqlScripts){
            
            $pkSqlScript = $count
            $ToRun = 'True'
            $fullName = $script.fullName
            $Name = $script.Name
            $partPath = $script.FullName.Replace($currentDirectorySQL,"")
            $Database = $partPath -replace "\\(.*)", ""
            ##since we don't need DB really
            if($Database -eq $name) {$Database = 'NA'}
            $runOrder = $count
            $count++
            
            ### actually adding this row to the datatable
            $null=$ScriptsToRun.Rows.Add($pkScript,$ToRun,$fullName,$Name,$partPath,$Database,$runOrder)
            #Write-host $ScriptsToRun
        }

    ### confirm to run and list the order and if there are rollbacks ###
    #Write-Host "Here is the order the scripts will run in:" -BackgroundColor White -ForegroundColor Black
     ##FOREach ($script in $ScriptsToRun){
     $ordercount = 1
     While($ordercount -le $scriptsToRun.Rows.Count)
     {
       $script = $scriptsToRun | Where-Object {$_.runorder -eq $ordercount}
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
return ,$ScriptsToRun

