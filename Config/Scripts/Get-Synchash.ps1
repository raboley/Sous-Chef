param($syncHash,$currentDirectory)

### if no syncHash, create it
if(!($syncHash)){
    Write-Host "Synchash is null"
    $Global:syncHash = [hashtable]::Synchronized(@{})
    
}


### if current directory not being passed in (should only be passed in for Command line) then use where the original script was invoked
if(!($currentDirectory)){
    $curdir = Split-Path -parent $MyInvocation.MyCommand.Definition
    $syncHash = @{
        RootDirectory = $curdir
    }
}else{
    $syncHash = @{
        RootDirectory = $currentDirectory
    }
}

$ScriptFolder = "$($syncHash.RootDirectory)\DefaultKitchen\"
$synchash.CurrentRecipeFolderPath = $scriptFolder
$syncHash.RecipeExtensions = ".xml",".recipe",".order"


$syncHash.cookbooks =  Join-path $synchash.RootDirectory "cookbooks"

### Functions 
$syncHash.Get_OpenFile = Join-path $syncHash.RootDirectory "\Config\Scripts\Functions\Get-OpenFile.ps1"
#### this script houses all the functions that will be used, this is so command line also has access to them
$syncHash.Get_Function_Library = Join-path $syncHash.RootDirectory "\Config\Scripts\Functions\Function_Library.ps1"

### Buttons
$syncHash.Button_Open = Join-path $syncHash.RootDirectory "\Config\Scripts\Button_Open.ps1"

### commands
$syncHash.Get_Recipe_Items = Join-path $syncHash.RootDirectory "\Config\Scripts\Get_Recipe_Items.ps1"
$syncHash.Get_Recipe_Variables = Join-path $syncHash.RootDirectory "\Config\Scripts\Get_Recipe_Variables.ps1"
$syncHash.Save_Recipe = Join-path $syncHash.RootDirectory "\Config\Scripts\Save_Recipe.ps1"
$syncHash.Add_Recipe_Items = Join-path $syncHash.RootDirectory "\Config\Scripts\Add_Recipe_Items.ps1"
$syncHash.Add_Script = Join-path $syncHash.RootDirectory "\Config\Scripts\Add_Script.ps1"
$syncHash.Add_File = Join-path $syncHash.RootDirectory "\Config\Scripts\Add_File.ps1"
$syncHash.File_Waiter = Join-path $syncHash.RootDirectory "\Config\Scripts\File_Waiter.ps1"
$syncHash.Open_File = Join-path $syncHash.RootDirectory "\Config\Scripts\Open_File.ps1"
$syncHash.Cook_Order = Join-path $syncHash.RootDirectory "\Config\Scripts\Cook_Order.ps1"

######


return ,$syncHash