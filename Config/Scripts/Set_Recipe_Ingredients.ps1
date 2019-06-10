function New-UserConfigObject ($userName, $recipeName, $variables) {
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
    $root.SetAttribute("RecipeName",$recipeName)
    $root.SetAttribute("User",$userName)

    $CustomVariables = $doc.CreateNode("element","CustomVariables",$null)

    foreach ($key in $variables.Keys)
    {
        $c = $doc.createNode("element","Parameter",$null) 
        $c.SetAttribute("Name",$key)
        $c.SetAttribute("Value",$variables[$key])
        $customVariables.AppendChild($c)| Out-Null
    }
    
    $root.AppendChild($customVariables)  | Out-Null
    $doc.AppendChild($root) | Out-Null
 
    return $Doc
}

function New-UserRecipeConfig ($synchash, $variables, $userName) {
    if(-not($synchash)) { Throw "You must supply a value for the synchash" }

    $KitchensFolder = Join-Path $synchash.RootDirectory 'kitchens'
    $userSettingsFolder = Join-Path $KitchensFolder $userName
    $userSettingsRecipePath = Join-path $userSettingsFolder $synchash.CurrentRecipeName
    
    [xml]$doc = New-UserConfigObject -userName $userName -recipeName $synchash.CurrentRecipeName -variables $variables
    Write-Host $userSettingsRecipePath
    New-Item $userSettingsRecipePath -Force
    $doc.save($userSettingsRecipePath)
    
    return ,$userSettingsRecipePath
}