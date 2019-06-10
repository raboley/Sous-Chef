param($syncHash,$recipePartPath, $datagridItems,$parentName, $parentPartPath,$layer=0)
#param($syncHash,$RecipePartPath,$MaxOrder,$parentName,$Layer) 
###################################### 
# Variables
######################################

$recipePath = Join-Path $syncHash.RootDirectory $RecipePartPath 
[XML]$file = get-content $RecipePath
$recipeBaseName = split-path $recipePath -leaf
$ingredients = $file.RecipeConfig.RecipeIngredients.Ingredient
$RecipeParentFolder = Split-Path $RecipePath -Parent


### Root Directory + Recipe Directory + Part Path = Full Path of Script

###################################### 
# Data table creation
######################################
if($datagridItems.count -eq 0){
    [int]$order =  1
    
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
    ### trying to figure out how to add recipes, but make them unique

    $RecipeIncrement = 1
}else{
    [int]$order = [int]$datagridItems.DefaultView.count + 1
}
if(!($layer)){
    $layer = 0
}
## allowing multiple recipes in the same one
[array]$alreadyPresent =  $datagridItems.DefaultView |Where-Object {$_.RecipeName -eq $parentName }
Write-host $datagridItems
if($alreadyPresent){
    $parentName = "$parentName$($AlreadyPresent.count)"
}

###################################### 
# Reading the config/folder path
######################################
if($ingredients){
    foreach($script in $ingredients){
        if($script.ScriptType -eq "recipe"){
            

            
            $ChildRecipePartPath = $script.RecipePartPath
            $layer++

            if($layer -eq 1){

                $LoadedparentPartPath = $script.ParentPartPath
                $parentName = $script.Name
                
            }
            
            ### if the recipe contains another recipe, start the process again for that recipe
            $datagridItems = & $syncHash.Get_Recipe_Items -SyncHash $syncHash -RecipePartPath $ChildRecipePartPath -datagridItems $datagridItems -parentName $parentName -parentPartPath $parentPartPath -layer $layer
            $layer--
            [int]$order = [int]$datagridItems.DefaultView.count +1
            $RecipeIncrement++
        }else{
            #### must just be a script that is in the recipe.
            ## Alert user if the script doesn't exist
            if($parentName -eq $script.OwningRecipe){
                $fullName = join-path $RecipeParentFolder $script.PartPath
                $partPath = $Script.partPath

                $LoadedparentPartPath = $parentPartPath
                $LoadedrecipePartPath = $recipePartPath
            }else{
                $OwningRecipeFolderPartPath = split-path $script.RecipePartPath
                $ScriptPartPathRelativeToOwningRecipe = Join-path $OwningRecipeFolderPartPath $script.partPath
                $fullName = join-path $syncHash.RootDirectory $ScriptPartPathRelativeToOwningRecipe

                $partPath = $Script.partPath
                $LoadedparentPartPath = $script.ParentPartPath
                $LoadedrecipePartPath = $script.recipePartPath
            }
            
            $warnings = ""
        if(test-path $fullName){
            $missing = 0 
        }   else{
            $missing = 1
            $warnings = "Error, this script is missing. Expected to be at relateive path `r`n($($script.partPath)) `r`n and for this run, it should be `r`n($fullname)"
        }
            ### redundant code in case something has to change, and keeps the add statement the same between methods.
            $ToRun = $script.ToRun
            $Name = $script.Name
            ### order is done incrementally because there may be scripts missing or removed so numbering may have to change.
            $RunOrder = $Order
            $ScriptType= $script.ScriptType

            ### recipe Level settings
            $recipeName = $script.OwningRecipe

            $RecipeIdentifier = $script.parentName
            $parent = $layer
            $OwningRecipe = $script.OwningRecipe
            ### actually adding this row to the datatable
            $null=$datagridItems.Rows.Add($order,$ToRun,$fullName,$Name,$partPath,$RunOrder,$ScriptType,$warnings,$RecipeIdentifier,$recipeName,$LoadedrecipePartPath,$missing,$parent,$LoadedparentPartPath,$OwningRecipe)
        }
        $order++
    }
}      
return ,$datagridItems

