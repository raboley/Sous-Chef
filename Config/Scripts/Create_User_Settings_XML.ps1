Param($Path="C:\Users\rboley\Desktop\git\RCWorkflow_Implementation\PIT_Tools\HT_SousChef\Config\Settings\UserSettings.xml",$LastRecipe="C:\Users\rboley\Desktop\git\RCWorkflow_Implementation\PIT_Tools\HT_SousChef\DefaultKitchen\TeachingRecipe.xml",$currentDirectory="C:\Users\rboley\Desktop\git\RCWorkflow_Implementation\PIT_Tools\")
<#
### logic
$parameters = @{
    Param1   = 'whatever that is'
    intParam = 1
    Param2   = 'w2hatever that is'
    intParam2 = 2
}

##
$global:currentDirectory = "C:\Russell\Tools\UI project"
$ScriptFolder = "$currentDirectory\ScriptsToRun\"
$Datagrid = New-Object System.Windows.Controls.DataGrid
$DataGrid.ItemsSource = (&"$currentDirectory\config\Scripts\Get_ScriptList.ps1" -ScriptFolder $ScriptFolder).Defaultview
$runOrderStuff = $datagrid.Items


###> 
## getting who the current user is
$username =  whoami.exe

## setting the part path
$partPath = $LastRecipe.Replace($currentDirectory,"")

### if there is a XML config already, append or update it
if(test-path $Path){
    [xml]$doc = (Get-Content -Path $path)
    
    if($doc.Config.UserSettings.User | Where-Object {$_.name -eq $username}){
        ### if the user already exists in the xml config update their last recipe
        ($doc.Config.UserSettings.User | Where-Object {$_.name -eq $username}).LastRecipe = $partPath
    }
    else{
        if($doc.config.UserSettings.user[0]){
            $new = $doc.config.UserSettings.user[0].clone()
        }else{
            $new = $doc.config.UserSettings.user.clone()
        }
        ### if the user doesn't exist in the xml config then add them
        
        $new.name = $username.ToString()
        $new.LastRecipe = $partPath.ToString()
        $doc.config.UserSettings.AppendChild($new)
    }

    $doc.save($Path)
}
### if there isn't an xml config then create one
else{
    ### boiler plate XML file creation code
    [xml]$Doc = New-Object System.Xml.XmlDocument
    $dec = $Doc.CreateXmlDeclaration("1.0","UTF-8",$null)
    $doc.AppendChild($dec) | Out-Null

## adding a comment
$text = @"
 
User Settings Config file
Generated $(Get-Date)
v1.0
 
"@
    $doc.AppendChild($doc.CreateComment($text)) | Out-Null
    ### creating config and user setting
    $root = $doc.CreateNode("element","Config",$null)
    $CustomVariables = $doc.CreateNode("element","UserSettings",$null)

    ### adding this users settings
        $c = $doc.createNode("element","User",$null) 
        $c.SetAttribute("Name",$username)
        $c.SetAttribute("LastRecipe",$partPath)
        $customVariables.AppendChild($c)| Out-Null
    
    ### writing to the actual nodes

    $root.AppendChild($customVariables)  | Out-Null
    $doc.AppendChild($root) | Out-Null

    #save file
    Write-Host "Saving the XML document to $Path" -ForegroundColor Green
    $parentPath = Split-Path $path -Parent
    if(!(Test-Path $parentPath)){
        New-Item -Path $parentPath -ItemType directory -Force
    }
    $doc.save($Path)
}