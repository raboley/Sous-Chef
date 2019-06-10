Get-Variable -Exclude PWD,*Preference | Remove-Variable -EA 0

$curdir = Split-Path -parent $MyInvocation.MyCommand.Definition
## get syncHash
$syncHash = &"C:\Russell\Tools\Git\RCWorkflow_Implementation\PIT_Tools\HT_SousChef\Config\Scripts\Get-Synchash.ps1" -currentDirectory $curdir

## get all the functions
. "C:\Russell\Tools\Git\RCWorkflow_Implementation\PIT_Tools\HT_SousChef\Config\Scripts\Functions\Function_Library.ps1"


#&$syncHash.Button_Open 
################################################
### Test Variables ######################
################################################
$OpenTestRecipePath = Join-Path $syncHash.RootDirectory "\CookBooks\Testing Recipes\Interface_Tests\Interface_Tests.recipe"

################################################
### Open a recipe ######################
################################################
Update-CurrentRecipe $syncHash $OpenTestRecipePath
$datagridItems = &$syncHash.Button_Open $syncHash

### conditions
if($datagridItems){Write-host "Test Open: Succeeded"}else{
    Write-host "Test Open: failed"
    Write-Debug "HI"
}