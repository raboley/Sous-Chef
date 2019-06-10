# the directory of demo.tests.ps1
$script_dir =  Split-Path -Parent $MyInvocation.MyCommand.Path

# load the script to test into memory
. "$script_dir\Set_Recipe_Ingredients.ps1"

Describe 'Create xml object with user config data function' {
$Recipe = @"
<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Recipe Config file
Generated 06/07/2018 10:31:27
v1.0
 -->
<RecipeConfig Name="ConvertExcelToSQL">
  <CustomVariables>
    <Parameter Name="ExelBookFolder" Value="" />
    <Parameter Name="ExcelBookName" Value="" />
    <Parameter Name="Database" Value="" />
  </CustomVariables>
  <RecipeIngredients>
    <Ingredient pkScript="" ToRun="True" fullName="C:\Russell\Tools\Git\RCWorkflow_Implementation\PIT_Tools\HT_SousChef\CookBooks\Utilities\Excel Management\Convert ExcelBook to CSV.ps1" Name="Convert ExcelBook to CSV.ps1" PartPath="\Convert ExcelBook to CSV.ps1" Order="1" ScriptType="Powershell" warnings="" ParentPartPath="\CookBooks\Utilities\Excel Management\ConvertExcelToSQL.recipe" RecipePartPath="\CookBooks\Utilities\Excel Management\ConvertExcelToSQL.recipe" OwningRecipe="convertExcel_OneDrive.recipe" />
    <Ingredient pkScript="" ToRun="True" fullName="C:\Russell\Tools\Git\RCWorkflow_Implementation\PIT_Tools\HT_SousChef\CookBooks\Utilities\Excel Management\Convert CSVs to SQL Tables.ps1" Name="Convert CSVs to SQL Tables.ps1" PartPath="\Convert CSVs to SQL Tables.ps1" Order="2" ScriptType="Powershell" warnings="" ParentPartPath="\CookBooks\Utilities\Excel Management\ConvertExcelToSQL.recipe" RecipePartPath="\CookBooks\Utilities\Excel Management\ConvertExcelToSQL.recipe" OwningRecipe="convertExcel_OneDrive.recipe" />
  </RecipeIngredients>
</RecipeConfig>
"@

$recipeObject = @{
  RecipeName = 'ConvertExcelToSQL';
  RecipePartPath = '\PartPath\ConvertExcelToSQL.Recipe'
}
  it 'Returns an object of xml type' {
    New-UserConfigObject | Should -BeOfType System.Xml.XmlDocument
  }

  it 'has an xml declaration' {
    $xmlDeclaration = '<?xml version="1.0" encoding="UTF-8"?>'
    $testInnerXml = (New-UserConfigObject).InnerXml
    
    $testInnerXml | Should -Match ([regex]::Escape($xmlDeclaration))
  }

  It "has a username attribute at the root" {
    [xml]$xml = New-UserConfigObject -userName 'testUser'
    
    $xml.RecipeConfig.User | Should -Match ([regex]::Escape('testUser'))
  }
  
  It "has a recipeName attribute at the root" {
    [xml]$xml = New-UserConfigObject -userName 'testUser' -recipeName 'testRecipe'
    
    $xml.RecipeConfig.recipeName | Should -Match ([regex]::Escape('testRecipe'))
  }
  
}