param($Substitutions)

######## hard Coded variables
$configPaths = @()
$configPaths += "C:\Program Files\Huron Consulting Group\RCWorkflow\Huron.Worklists.UI\app-settings.json"
$configPaths += "C:\Program Files\Huron Consulting Group\RCWorkflow\Huron.Worklists.UI\web.config"
$configPaths += "C:\Program Files\Huron Consulting Group\RCWorkflow\Huron.Worklists.WebAPI\web.config"
$configPaths += "C:\Program Files\Huron Consulting Group\RCWorkflow\TRACWeb\web.config"
$configPaths += "C:\Program Files\Huron Consulting Group\RCWorkflow\WebUI\web.config"
$configPaths += "C:\Program Files\Huron Consulting Group\RCWorkflow\Worklists\web.config"
$configPaths += "C:\Program Files\Huron Consulting Group\RCWorkflow\Worklists\PortalEntry.asp"

########

$curdir = $substitutions.CurrentKitchen

#### TESTING
#$curdir = Split-Path -parent $MyInvocation.MyCommand.Definition
####

$DestFolder = Join-Path $curdir "\Substitutions\Backups"

###### Functions
function Create-Folder($folder,$message)
{
if(!(Test-Path -Path $folder)) 
    {
        IF($message)
        {
        Write-Host $message -ForegroundColor Green
        }
        ELSE
        {
        Write-Host "Created folder $folder" -ForegroundColor Green
        }
        try {
                New-Item $folder -Type Directory | Out-null 
            }
        catch { 
            $parent = Split-Path $folder -Parent
                New-Item $parent -Type Directory | Out-null 
                New-Item $folder -Type Directory | Out-null 
            }
    } 
}
#### Copy backup config files

Create-Folder $DestFolder

foreach($config in $configPaths){
    ## create a folder to emulate the structure from web, so no configs are overwritten
    $parentFolder = Split-Path (Split-Path "$config" -Parent) -Leaf
    $BackupParentFolder = join-path $DestFolder $parentFolder
    Create-folder $BackupParentFolder

    ### copy the file to the backup folder
    $configObject = Get-ChildItem $config
    $BackupDestFullName = Join-Path $BackupParentFolder $configObject.Name
    Copy-Item -Path $config -Destination $BackupDestFullName
}