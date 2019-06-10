Function Invoke-Recipe
{
<#
.SYNOPSIS
Finds Folder for ID value and returns "Parent/../FolderName".  If Parent is Root (-1 ID), then returns "/FolderName".

.DESCRIPTION
Finds the FolderName for specific ID given and walks folder structure backwards to Root for each parent, returns entire FolderPath string.
Uses "FolderGet" API call.

Exception thscriptn if ID not found (or don't have rights to folder).

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
        [Parameter(ParameterSetName='default',Position=0,Mandatory=1)][string] $recipePath,
        [Parameter(ParameterSetName='default',Position=1,Mandatory=0)][string] $logDestination = 'Console'
    )
    function Send-Log {
        param (
            [Parameter(ParameterSetName='default',Position=0,Mandatory=1)][string] $Message,
            [Parameter(ParameterSetName='default',Position=1,Mandatory=1)][string] $logDestination,
            [Parameter(ParameterSetName='default',Position=3,Mandatory=1)][string] $Color
        )
        if($logDestination -eq 'Console'){
            Write-Host $message -ForegroundColor $Color
        }
    }
    
    $recipe = Get-RecipeFromFile $recipePath
    [system.collections.hashtable]$customVariables = $recipe.variables

    $visualLine = "`r`n---------------------------------------------------`r`n"
    $ingredients = $recipe.ingredients
    $messages = @()
    $VerbosePreference = "Continue" 
    $i = 1
    While ($i -le $ingredients.Count) {
        $error.clear()
        $message = @()
        $script = $ingredients.Where{ $_.RunOrder -eq $i}
        $RecipeFolder = split-path $recipePath -Parent
        $ScriptFullPath = Join-Path $RecipeFolder $script.RelativePath
        
        IF($script.ScriptType -eq 'Powershell')
        {
            try{
                $Output = & $ScriptFullPath $customVariables  | Out-String
            }
            catch{
                $message += $_.Exception.Message
            }
            
            if($Output -ne ""){
                $log += "This is output from $($script.Name): $visualLine $Output $visualLine"
                Send-Log -Message $log -logDestination $logDestination -Color 'blue'
            }

            foreach($er in $error){
                $message += "Message:$($er.Exception.Message)`r`n"
                $message += "ScriptStackTrace:$($er.ScriptStackTrace)`r`n"
            }
            ### Want to output it succeeded if no errors in message
            if($message.count -eq 0){
                $text = "$($script.name):$($message.count) -- Script Succeeded!`r`n"
                Send-Log -Message $text -logDestination $logDestination -Color 'green'
            }else{
                $text = "$($script.name):ErrorCount $($message.count): Error Message: -- $message`r`n"
                Send-Log -Message $text -logDestination $logDestination -Color 'red'
                $messages += $text
            }
        }
        $i++
    }
    return $messages
}