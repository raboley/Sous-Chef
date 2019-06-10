param($Substitutions)


########
## Sous Chef Variables ##
$curdir = $substitutions.CurrentKitchen

######## hard Coded variables
$liveFolderPath = "C:\Program Files\Huron Consulting Group\RCWorkflow"
$DestFolder = Join-Path $curdir "\Substitutions\Backups"

#### TESTING
#$curdir = Split-Path -parent $MyInvocation.MyCommand.Definition
####

#### Paste Config files into live directory
$configs = Get-ChildItem $DestFolder -Recurse | ? { $_.PsIsContainer -eq $false }

## Get parent folder and Name, then join path with production path, and copy the backup folder config, to the live folder
foreach($config in $configs){
    if($config.Length  -gt 1){
        $parentFolderName = Split-Path (Split-Path "$($config.FullName)" -Parent) -Leaf
        $ParentAndConfig = Join-path $parentFolderName $config.name
        $liveConfigFullPath = join-path $liveFolderPath $ParentAndConfig
        
        Copy-Item -path $config.FullName -Destination $liveConfigFullPath -force
    }  
}