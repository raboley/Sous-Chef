param($syncHash,$FilePath,$datagridItems) 
###################################### 
# Variables
######################################


###################################### 
# Data table creation
######################################
if($datagridItems.count -eq 0){
    $datagridItems = New-Object system.Data.DataTable
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('PKSqlScript', 'int')))
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('ToRun', 'string')))
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('FullName', 'string')))
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('Name', 'string')))
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('PartPath', 'string')))
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('RunOrder', 'int')))
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('ScriptType', 'string')))
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('Warnings', 'string')))
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('RecipeIdentifier', 'string')))
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('RecipeName', 'string')))
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('RecipePartPath', 'string')))
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('Missing', 'int')))
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('Parent', 'int')))
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('ParentPartPath', 'string')))
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('OwningRecipe', 'string')))
    
    ### properties used in the UI
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('Errored', 'int')))
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('ErrorMessage', 'string')))
    $datagridItems.Columns.Add((New-Object System.Data.DataColumn('HasRun', 'int')))
    Write-host "no datagridItems"
    [int]$order = 1
}else{
    
    [int]$order = [int]$datagridItems.DefaultView.count + 1
}

#### add the if part path stuff here
$parentPartPath =  $synchash.CurrentRecipePath.Replace($syncHash.RootDirectory,"")
$parent = 0



###################################### 
# Reading the config/folder path
######################################
    $file = Get-ChildItem $FilePath  

            $pkScript = $order
            $fullName = $file.fullName
            $Name = $file.Name
            $runOrder = $order
    
            if($Name -like '*.sql') {$scriptType = 'SQL'}ELSEIF($Name -like '*.ps1'){$scriptType = 'Powershell'}
            ### redundant code in case something has to change, and keeps the add statement the same between methods.
            $ToRun = $true
            $warnings = ""

            ### actually adding this row to the datatable
            if($syncHash.CurrentRecipePath){
                $ConfigParent = Split-Path $synchash.CurrentRecipePath -Parent
                
                $recipe = Get-ChildItem $syncHash.CurrentRecipePath
                $partPath = $fullName.Replace($ConfigParent,"")
                $recipeName = $recipe.Name
                $RecipePartPath = $recipe.FullName.Replace($syncHash.RootDirectory,"")
                if(test-path $fullName){
                    $missing = 0 
                }   else{
                    $missing = 1
                }
                
                $null=$datagridItems.Rows.Add($order,$ToRun,$fullName,$Name,$partPath,$RunOrder,$ScriptType,$warnings,$recipeName,$recipeName,$recipePartPath,$missing,$parent,$parentPartPath,$recipeName)
            }else {
                $partPath = $fullName.Replace($currentDirectory,"")
                $null=$datagridItems.Rows.Add($pkScript,$ToRun,$fullName,$Name,$partPath,$runOrder,$ScriptType,$warnings,"","","",0,$parent,$parentPartPath)
            }   

            
            
   
return ,$datagridItems

