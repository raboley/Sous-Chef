
param($Script,$ScriptsConfig,$currentDirectory,$MaxOrder,$synchash) 


###################################### 
# Variables
######################################
[int]$order = $MaxOrder + 1

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
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('ParentPartPath', 'string')))

### properties used in the UI
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('Errored', 'int')))
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('ErrorMessage', 'string')))
$ScriptsToRun.Columns.Add((New-Object System.Data.DataColumn('HasRun', 'int')))

#### add the if part path stuff here
$parentPartPath =  $synchash.currentConfig.Replace($currentDirectory,"")
$RecipePartPath = $ScriptsConfig.replace($currentDirectory,"")

if($parentPartPath -eq $RecipePartPath){
    $parent = 1
}else {
    $parent = 0
}

###################################### 
# Reading the config/folder path
######################################
    $file = Get-ChildItem $script   

            $pkScript = $order
            $fullName = $file.fullName
            $Name = $file.Name
            $runOrder = $order
    
            if($Name -like '*.sql') {$scriptType = 'SQL'}ELSEIF($Name -like '*.ps1'){$scriptType = 'Powershell'}
            ### redundant code in case something has to change, and keeps the add statement the same between methods.
            $ToRun = 1
            
            ### order is done incrementally because there may be scripts missing or removed so numbering may have to change.
            $RunOrder = $Order
            $warnings = ""

            ### actually adding this row to the datatable
            if($ScriptsConfig){
                $ConfigParent = Split-Path $scriptsconfig -Parent
                
                $recipe = Get-ChildItem $ScriptsConfig
                $partPath = $fullName.Replace($ConfigParent,"")
                $recipeName = $recipe.Name
                $RecipePartPath = $recipe.FullName
                $missing = Test-Path $file.FullName
                $null=$ScriptsToRun.Rows.Add($order,$ToRun,$fullName,$Name,$partPath,$RunOrder,$ScriptType,$warnings,$recipeName,$recipeName,$recipePartPath,$missing,$parent,$parentPartPath)
            }else {
                $partPath = $fullName.Replace($currentDirectory,"")
                $null=$ScriptsToRun.Rows.Add($pkScript,$ToRun,$fullName,$Name,$partPath,$runOrder,$ScriptType,$warnings,"","","",0,$parent,$parentPartPath)
            }   

            
            
   
return ,$ScriptsToRun

