param($xmlPath="C:\Russell\Tools\Git\RCWorkflow_Implementation\PIT_Tools\HT_SousChef\CookBooks\Testing Recipes\Testing recursion.Recipe",$syncHash=@{RootDirectory="C:\Russell\Tools\Git\RCWorkflow_Implementation\PIT_Tools\HT_SousChef";Get_Recipe_Variables="C:\Russell\Tools\Git\RCWorkflow_Implementation\PIT_Tools\HT_SousChef\Config\Scripts\Get_Recipe_Variables.ps1"},$Variables=@{ })

### need to get variables, then loop through ingredients to check for more recipes, and if there are more recipes then do this script for them as well.  Get all the root ones first, then override with master ones where exist
[xml]$xml = Get-Content $xmlPath

$Recipes = $xml.RecipeConfig.RecipeIngredients.Ingredient | Where-Object {$_.ScriptType -eq "recipe"}

if($recipes){
    foreach($Ingredient in $recipes){
        $RecipePath = Join-Path $syncHash.RootDirectory $Ingredient.recipePartPath 
        ### returning these variables to a dummy variable since the way powershell works we should add the variables in the next inception of the script 
        ### since this variable has the scope through the script.  Otherwise it will go to console or worse be returned with duplicates
        $dump = & $syncHash.Get_Recipe_Variables -xmlPath $RecipePath.ToString() -syncHash $syncHash -variables $variables
    }
}

### actually adding the variables, doing this last since I want the Parent recipe to overwrite whatever values the children recipes would have provided
foreach($parameter in $xml.RecipeConfig.CustomVariables.Parameter)
{ 
    $variables[$parameter.Name] = $parameter.Value
}

return ,$variables