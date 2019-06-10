param($xmlPath="C:\Russell\Tools\Git\RCWorkflow_Implementation\PIT_Tools\HT_SousChef\CookBooks\Testing Recipes\Testing recursion.Recipe")

### getting the help text from the file
[xml]$xml = Get-Content $xmlPath

$HelpText = $xml.RecipeConfig.HelpText.Text

return ,$helpText