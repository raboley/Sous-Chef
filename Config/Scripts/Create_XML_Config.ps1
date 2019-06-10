Param($Path="C:\Work\MyInventory.xml",$parameters,$items,$currentDirectory)
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
$recipeName = (Get-ChildItem $Path).BaseName

[xml]$Doc = New-Object System.Xml.XmlDocument

$dec = $Doc.CreateXmlDeclaration("1.0","UTF-8",$null)
$doc.AppendChild($dec) | Out-Null

## adding a comment
$text = @"
 
Recipe Config file
Generated $(Get-Date)
v1.0
 
"@
$doc.AppendChild($doc.CreateComment($text)) | Out-Null

$root = $doc.CreateNode("element","RecipeConfig",$null)
$root.createNode("element","Name",$recipeName)
$CustomVariables = $doc.CreateNode("element","CustomVariables",$null)

### adding global variables
foreach ($key in $parameters.Keys)
{
   
    $c = $doc.createNode("element","Parameter",$null) 
    $c.SetAttribute("Name",$key)
    $c.SetAttribute("Value",$parameters[$key])
    $customVariables.AppendChild($c)| Out-Null
}

##### execute details
$IngredientsList = $doc.CreateNode("element","RecipeIngredients",$null)

foreach($item in $items)
{
    $curDirPath = $item.fullname -replace([Regex]::Escape($currentDirectory),'')
    $r = $doc.createNode("element","Ingredient",$null) 
    $r.SetAttribute("pkScript",$item.pkScript)
    $r.SetAttribute("ToRun",$item.ToRun)
    $r.SetAttribute("fullName",$item.FullName)
    $r.SetAttribute("Name",$item.name)
    $r.SetAttribute("PartPath",$item.PartPath)
    $r.SetAttribute("Order",$item.runOrder)
    $r.SetAttribute("ScriptType",$item.ScriptType)
    $r.SetAttribute("warnings",$item.warnings)

    

    $IngredientsList.AppendChild($r)| Out-Null

     #$null=$ScriptsToRun.Rows.Add($pkScript,$ToRun,$fullName,$Name,$partPath,$Database,$runOrder,$ScriptType,$warnings)
}
### writing to the actual nodes

## custom variables

$root.AppendChild($customVariables)  | Out-Null
$doc.AppendChild($root) | Out-Null

### execute details
$root.AppendChild($IngredientsList)| Out-Null

Write-host "------ DOC BElow -----"

$Doc

#save file
Write-Host "Saving the XML document to $Path" -ForegroundColor Green
$doc.save($Path)