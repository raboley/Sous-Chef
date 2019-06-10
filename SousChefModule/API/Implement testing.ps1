$script_dir =  Split-Path -Parent $MyInvocation.MyCommand.Path

. "$script_dir\Invoke-Recipe.ps1"
. "$script_dir\Get-RecipeFromFile.ps1"

Invoke-Recipe 