Param($synchash,$datagridItems,$variables,$HelpText)
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

function Save-Recipe ($synchash,$datagridItems,$variables,$HelpText) {
    $RecipeName = $syncHash.CurrentRecipeName
    
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
    $root.SetAttribute("Name",$RecipeName)
    $CustomVariables = $doc.CreateNode("element","CustomVariables",$null)
    
    ### adding global variables
    foreach ($key in $variables.Keys)
    {
       
        $c = $doc.createNode("element","Parameter",$null) 
        $c.SetAttribute("Name",$key)
        $c.SetAttribute("Value",$variables[$key])
        $customVariables.AppendChild($c)| Out-Null
    }
    
    ##### execute details
    $IngredientsList = $doc.CreateNode("element","RecipeIngredients",$null)
    
    foreach($item in $datagridItems)
    {
        $r = $doc.createNode("element","Ingredient",$null) 
        $r.SetAttribute("OwningRecipe",$item.OwningRecipe)
        $r.SetAttribute("Name",$item.name)
        $r.SetAttribute("PartPath",$item.PartPath)
        $r.SetAttribute("ParentPartPath",$item.ParentPartPath)
        $r.SetAttribute("RecipePartPath",$item.RecipePartPath)
        $r.SetAttribute("Order",$item.runOrder)
        $r.SetAttribute("fullName",$item.FullName)
        $r.SetAttribute("ToRun",$item.ToRun)
        $r.SetAttribute("ScriptType",$item.ScriptType)
        $r.SetAttribute("warnings",$item.warnings)
        $r.SetAttribute("pkScript",$item.pkScript)
        
        $IngredientsList.AppendChild($r)| Out-Null
    }
    write-host $HelpText
    #### Adding help text
    $HelpTextNode = $doc.CreateNode("element","HelpText",$null)
    $HelpTextNode.SetAttribute("Text",$HelpText)
    #$RawText = $doc.createNode("element","Text",$HelpText) 
    #$HelpTextNode.AppendChild($RawText)| Out-Null
    
    ### writing to the actual nodes
    
    ## custom variables
    
    $root.AppendChild($customVariables)  | Out-Null
    $root.AppendChild($HelpTextNode)  | Out-Null
    $doc.AppendChild($root) | Out-Null
    
    ### execute details
    $root.AppendChild($IngredientsList)| Out-Null
    
    Write-host "------ DOC BElow -----"
    
    $Doc
    
    #save file
    Write-Host "Saving the XML document to $($syncHash.CurrentRecipePath)" -ForegroundColor Green
    $doc.save($syncHash.CurrentRecipePath)
}

Save-Recipe $synchash $datagridItems $variables $HelpText