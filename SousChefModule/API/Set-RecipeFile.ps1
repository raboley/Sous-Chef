
function Set-RecipeFile {
    param (
        [Parameter(ParameterSetName='default',Position=0,Mandatory=1)][string] $recipePath,
        [Parameter(ParameterSetName='default',Position=1,Mandatory=1)][System.Collections.Hashtable] $recipe
    )
    $recipeJson = ConvertTo-Json $recipe
    New-Item -path $recipePath -force -Value $recipeJson
}