$global:currentDirectory = Split-Path -parent $MyInvocation.MyCommand.Definition
$ScriptsFolder = "C:\Users\rboley\Desktop\UI project\ScriptsToRun\SQL"
$scripts = & "C:\Users\rboley\Desktop\UI project\Config\Scripts\Get_ScriptList.ps1" $ScriptsFolder

foreach($Script in $scripts)
    {
        $script
        & "C:\Users\rboley\Desktop\UI project\Config\Scripts\Run_SQL_Script.ps1" -script $Script
    }