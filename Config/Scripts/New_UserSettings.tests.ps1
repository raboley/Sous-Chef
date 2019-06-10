# the directory of demo.tests.ps1
$script_dir =  Split-Path -Parent $MyInvocation.MyCommand.Path

# load the script to test into memory
. "$script_dir\New_UserSettings.ps1"

Describe "New-UserRecipeConfig" {
  [system.collections.hashtable]$syncHash = @{
    RootDirectory = $TestDrive
    RecipeName = 'Test.recipe'
  }

  [system.collections.hashtable]$testVariableHashTable = @{
    Database = 'TRAC'
  }
  $userName = 'rboley'
  $MyUserSettingsPath = Join-Path $syncHash.RootDirectory "kitchens\$userName\$username.json"
 
  it "Creates a new folder and settings file" {
    $parameters = @{
        syncHash = $syncHash
    }
    New-UsersSettings @parameters

    Test-Path $MyUserSettingsPath | Should Be $true
  }

  it "It won't overwrite already present user settings" {
    $parameters = @{
        syncHash = $syncHash
    }
    New-UsersSettings @parameters
    $parameters = @{
        syncHash = $syncHash
        userSettings = @{ OpenLastRecipeOnStart = $true }
    }
    New-UsersSettings @parameters
    $userSettings = Get-UsersSettings @parameters

    $userSettings.OpenLastRecipeOnStart | Should Be $false
  }

  it "can read the Json back into an object" {
    $parameters = @{
        syncHash = $syncHash
    }
    New-UsersSettings @parameters
    $userSettings = Get-UsersSettings @parameters
    
    $userSettings.OpenLastRecipeOnStart | Should Be $false
  }
}