Function Get-RecipeFromFile
{
<#
.SYNOPSIS
Finds Folder for ID value and returns "Parent/../FolderName".  If Parent is Root (-1 ID), then returns "/FolderName".

.DESCRIPTION
Finds the FolderName for specific ID given and walks folder structure backwards to Root for each parent, returns entire FolderPath string.
Uses "FolderGet" API call.

Exception thrown if ID not found (or don't have rights to folder).

.PARAMETER SSWebserviceURLString
The sswebservice.asmx URL string to use as endpoint for the Secret Server API.

.PARAMETER FolderId
The ID to specific FolderName.

.PARAMETER SessionToken
(Optional) Secret Server session token value obtained with New-HssSession cmdlet.  If this value isn't present, Windows Authentication is assumed.

.NOTES

.EXAMPLE
Get-HssFolderPathById -FolderId 333 `
    -SSWebserviceURLString "https://secret.huronconsultinggroup.com/secretServer/webservices/sswebservice.asmx" `
    -SessionToken $SessionToken

Find the folder ID 333, and if found return its Name along with its Parent (format "ParentFolderName/FolderName").

.EXAMPLE
Get-HssFolderPathById -FolderId 333

Find the folder ID 333, and if found return its Name along with its Parent (format "ParentFolderName/FolderName").

.LINK
New-HssSession

#>

########################################################################################################################
# Author: Russell Boley
# Created: 8/15/2018
#
#
#
# Change History:
# ---------------	
# MM/DD/YYYY   Initials   PBI/BUG   Description
# 
########################################################################################################################

    #[CmdletBinding(DefaultParametersetName='default')] 
    #[OutputType([int])]
    Param(
        [Parameter(ParameterSetName='default',Position=0,Mandatory=1)][string] $recipePath
    )
    $recipeJson = Get-Content $recipePath -Raw
    $recipeObject = ConvertFrom-Json $recipeJson
    $ingredients = $recipeObject.Ingredients
    foreach($ingredient in $ingredients){
        
    }
    return $recipeObject
}