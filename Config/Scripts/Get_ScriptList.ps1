
param([Array]$ScriptFolder,$ScriptsConfig,$currentDirectory) 


###################################### 
# Variables
######################################
[int]$order = 1
$notInList = @()

###################################### 
# Data table creation
######################################
$ScriptsToRun = New-Object system.Data.DataTable
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('PKSqlScript', 'int')))
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('ToRun', 'string')))
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('FullName', 'string')))
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('Name', 'string')))
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('PartPath', 'string')))
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('RunOrder', 'int')))
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('ScriptType', 'string')))
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('Warnings', 'string')))
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('RecipeIdentifier', 'string')))
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('RecipeName', 'string')))
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('RecipePartPath', 'string')))
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('Missing', 'int')))
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('Parent', 'int')))

### properties used in the UI
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('Errored', 'int')))
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('ErrorMessage', 'string')))
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('HasRun', 'int')))

###################################### 
# Reading the config/folder path
######################################
    if($ScriptsConfig){
        $ConfiguredScripts = $ScriptsConfig #|Sort-Object -Property Order
        #$Recipe = Get-ChildItem $ScriptsConfig
        ### setting the order, to run and full name properties
        
        foreach($script in $ConfiguredScripts){
            ### Only set properties for things that exist
            $fullpath = join-path $currentDirectory $script.PartPath
            if(test-path $fullpath){
                
                ### redundant code in case something has to change, and keeps the add statement the same between methods.
                $ToRun = $script.ToRun
                $fullName = $fullpath
                $Name = $script.Name
                $partPath = $Script.partPath
                ### order is done incrementally because there may be scripts missing or removed so numbering may have to change.
                $RunOrder = $Order
                $ScriptType= $script.ScriptType
                $warnings = ""
                $recipeName = $recipe.BaseName
                $RecipePartPath = $recipe.FullName
                ### actually adding this row to the datatable
                $null=$ScriptsToRun.Rows.Add($order,$ToRun,$fullName,$Name,$partPath,$RunOrder,$ScriptType,$warnings,$recipeName,$recipePartPath)
            
            $order++

            ### adding to not in list so that we can exclude items that have already been loaded from the check below
            $notInList += $name
            }
        }
        
    }
    ### Now searching for files in the folder that don't exist in the config and putting them at the bottom
    if(Test-Path $ScriptFolder){
        [array]$NewScripts = Get-ChildItem -Path $ScriptFolder -include @("*.ps1","*.sql") -Recurse | Where-Object {$_.fullname -notlike "*Substitutions*"}| Select-Object Fullname,Name    
    }

    if($NewScripts){
    ### removing the scripts that are covered by the config
    [array]$scripts = $NewScripts | Where-Object {$notInList -notcontains $_.name}
        ###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#########
        ### Need to make this based off of full path, or part path, but can't figure out how to do it. Not working so 
        ### doing it based on name for now. I know that will probably be a problem later.
        ###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#########

    
    
    #### if numbers are in front of the name getting the order correctly.
    foreach ($Script in $Scripts)
    {
        try 
        {
            [int]$prefix = $script.Name -replace '(^\d\S*)(.*)','$1'
            
        }
        catch
        {
        #Write-Host "$($script.name) does not have a number in front of it so it will be run last"
        }
        $script = $script |Add-Member -type NoteProperty -Name prefix -Value $order    -force
    }
     
     $scripts = $scripts |Sort-Object -Property prefix,name
       
     ### Starting the actual addition of rows to the datatable
        ### Adding a row for each script and all needed info to the data table
        FOREACH($script in $Scripts){

            $pkScript = $order
            $fullName = $script.fullName
            $Name = $script.Name
            $partPath = $script.FullName.Replace($currentDirectory,"")
            #$Database = ''
            $runOrder = $order
    
            if($Name -like '*.sql') {$scriptType = 'SQL'}ELSEIF($Name -like '*.ps1'){$scriptType = 'Powershell'}
            <#
            if($ScriptType -eq 'SQL')
            {
                $rollback = if(Get-Content $script.FullName | Select-String "rollback") {"Script has a rollback statement"} ELSE {$null}
                $UseStatement = if(Get-Content $script.FullName | Select-String "USE") {"Script has a use statement"} ELSE {$null}
                $warnings = $rollback + $UseStatement

                $dbreplace = $ScriptFolder + $ScriptType + "\"
                $partPath = $script.FullName.Replace($dbreplace,"")
                $Database = $partPath -replace "\\(.*)", ""
            }
            #>
            $order++

            ### actually adding this row to the datatable
            $null=$ScriptsToRun.Rows.Add($pkScript,$ToRun,$fullName,$Name,$partPath,$runOrder,$ScriptType,$warnings)
        }
       <#    
     $orderorder = 1
     While($orderorder -le $ScriptsToRun.Rows.order)
     {
       $script = $ScriptsToRun | Where-Object {$_.runorder -eq $orderorder}

       $rollback = Get-Content $script.FullName | Select-String "rollback"
       If ($rollback -ne $null){
      # Write-Host $script.runorder $script.PartPath "Has a rollback" -ForegroundColor Red
       }
       ELSE {
      #Write-Host $script.runorder $script.PartPath "on" $script.db
       }


       $orderorder++
    } 
           #>
}
return ,$ScriptsToRun

