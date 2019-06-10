function New-UsersSettings {
    param (
        [Parameter(ParameterSetName='default',Position=0,Mandatory=1)][system.collections.hashtable] $syncHash,
        [Parameter(ParameterSetName='default',Position=1,Mandatory=0)][system.collections.hashtable] $userSettings = @{ OpenLastRecipeOnStart = $false },
        [Parameter(ParameterSetName='default',Position=2,Mandatory=0)][string] $userName = (Split-Path (whoami.exe) -leaf)
    )
    
    $userSettingsPath = Join-path $syncHash.rootDirectory "kitchens\$userName\$username.json"
    
    if(test-path $userSettingsPath){
        Write-Host "User Settings already exist at $userSettingsPath so not going to overwrite"
    }
    else {
        $userSettingsJson = ConvertTo-Json $UserSettings
        New-Item -Path $userSettingsPath -Value $userSettingsJson -Force -ItemType file
    }

}

function Get-UsersSettings {
    param (
        [Parameter(ParameterSetName='default',Position=0,Mandatory=1)][system.collections.hashtable] $syncHash,
        [Parameter(ParameterSetName='default',Position=1,Mandatory=0)][system.collections.hashtable] $userSettings = @{ OpenLastRecipeOnStart = $false },
        [Parameter(ParameterSetName='default',Position=2,Mandatory=0)][string] $userName = (Split-Path (whoami.exe) -leaf)
    )

    $userSettingsPath = Join-path $syncHash.rootDirectory "kitchens\$userName\$username.json"
    $userSettingsJson = Get-Content $userSettingsPath -Raw
    $readUserSettings = ConvertFrom-Json -InputObject $userSettingsJson

    return $readUserSettings 
}