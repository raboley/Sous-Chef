#### setting up the $synchash which will hold all the Order specific variables


#### should be the ht_souschef folder
<#
$syncHash = @{
    RootDirectory  = Split-Path -parent $MyInvocation.MyCommand.Definition
    scriptFolder = 1
    currentconfig   = 'w2hatever that is'
    Continue = 2
    Retry   = 'whatever that is'
    Log = 1
    Host   = 'w2hatever that is'
    Window = 2
    RecipeFolderPath   = 'w2hatever that is'
    RecipePartPath = 2
    Get_Recipe   = 'whatever that is'
    Save_Recipe = 1
    }
#>

$syncHash = @{
    RootDirectory = "C:\Russell\Tools\Git\RCWorkflow_Implementation\PIT_Tools\HT_SousChef" #Split-Path -parent $MyInvocation.MyCommand.Definition
    RecipeFolderPath = Join-Path $syncHash.RootDirectory "\CookBooks\Testing Recipes\"
    Get_Recipe = Join-path $syncHash.RootDirectory "\Config\Scripts\Get_Recipe.ps1"
    Save_Recipe = Join-path $syncHash.RootDirectory "\Config\Scripts\Save_Recipe.ps1"
}
#>

$syncHash.RootDirectory = Split-Path -parent $MyInvocation.MyCommand.Definition
$synchash.RecipeFolderPath = Join-Path $syncHash.RootDirectory "\CookBooks\Testing Recipes\"
$syncHash.RecipePartPath = "\CookBooks\Testing Recipes\Testing recursion.recipe"


$syncHash.Get_Recipe_Items = Join-path $syncHash.RootDirectory "\Config\Scripts\Get_Recipe_Items.ps1"
$syncHash.Get_Recipe_Variables = Join-path $syncHash.RootDirectory "\Config\Scripts\Get_Recipe_Variables.ps1"
$syncHash.Save_Recipe = Join-path $syncHash.RootDirectory "\Config\Scripts\Save_Recipe.ps1"
$syncHash.Add_Script = Join-path $syncHash.RootDirectory "\Config\Scripts\Add_Script.ps1"


$Recipes = (& $syncHash.Get_Recipe_Items -SyncHash $syncHash -RecipePartPath $syncHash.RecipePartPath).Defaultview




###### TEST Cases
### missing recipes
$MissingRecipes = $Recipes | Where-Object {$_.missing -eq 1}

if($MissingRecipes){
    $MissingRecipesString = "Fail a recipe is missing:`r`n"
    foreach($recipe in $MissingRecipes){
        $MissingRecipesString += $recipe.name + ",`r`n" 
    }
    write-host $MissingRecipesString -ForegroundColor Yellow
}

#### getting the scripts to run along with the order
foreach($ingredient in $recipes){
    #Write-host $ingredient.name $ingredient.RunOrder $ingredient.RecipeName $ingredient.Parent
}

#### saving the config to a new .recipe
$NewRecipePath = Join-path $syncHash.RootDirectory "\CookBooks\Testing Recipes\Testing Saving.recipe"

Write-host $NewRecipePath
### setting parameters
$parameters = @{
    Param1   = 'whatever that is'
    intParam = 1
    Param2   = 'w2hatever that is'
    intParam2 = 2
}

#& $syncHash.Save_Recipe -Path $NewRecipePath -parameters $parameters -items $Recipes -SyncHash $synchash

#Remove-Variable ScriptsToRun

#$Recipes = (& $syncHash.Get_Recipe_Items -SyncHash $syncHash -RecipePartPath "\CookBooks\Testing Recipes\Testing Saving.recipe").Defaultview

## break
$variables  = @{}
$variables = & $syncHash.Get_Recipe_Variables -xmlPath  $NewRecipePath -syncHash $syncHash -variables $variables
