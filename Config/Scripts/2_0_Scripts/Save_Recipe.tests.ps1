# the directory of demo.tests.ps1
$script_dir =  Split-Path -Parent $MyInvocation.MyCommand.Path

# load the script to test into memory
. "$script_dir\Save_Recipe.ps1"

Describe 'Create xml object with user config data function' {

  it 'Returns an object of xml type' {
    New-UserConfigObject | Should -BeOfType System.Xml.XmlDocument
  }

  it 'has an xml declaration' {
    $xmlDeclaration = '<?xml version="1.0" encoding="UTF-8"?>'
    $testInnerXml = (New-UserConfigObject).InnerXml
    
    $testInnerXml | Should -Match ([regex]::Escape($xmlDeclaration))
  } -Skip

  It "has a username attribute at the root" {
    [xml]$xml = New-UserConfigObject -userName 'testUser'
    
    $xml.RecipeConfig.User | Should -Match ([regex]::Escape('testUser'))
  }
  
  It "has a recipeName attribute at the root" {
    [xml]$xml = New-UserConfigObject -userName 'testUser' -recipeName 'testRecipe'
    
    $xml.RecipeConfig.recipeName | Should -Match ([regex]::Escape('testRecipe'))
  }
  
}

Describe "New-UserRecipeConfig" {
  [system.collections.hashtable]$syncHash = @{
    RootDirectory = $TestDrive
    RecipeName = 'Test.recipe'
  }

  [system.collections.hashtable]$testVariableHashTable = @{
    Database = 'TRAC'
  }
  $userName = 'raboley'
  $reicpePath = Join-Path $TestDrive "kitchens\$userName\$($syncHash.CurrentRecipeName)"

  it 'throws an error when there is no user passed in' {
    New-UserRecipeConfig | Should Throw 'You must supply a value for the synchash'
  }
  
  it "Creates a new folder and settings file" {
    New-UserRecipeConfig -syncHash $syncHash -variables $testVariableHashTable -userName $userName
    Test-Path $reicpePath | Should Be $true
  }

  it "has parameter nodes with names and values" {
    New-UserRecipeConfig -syncHash $syncHash -variables $testVariableHashTable -userName $userName
    [xml]$xml = get-content $reicpePath 
    Write-host $xml
    $xml.recipeconfig.CustomVariables.Parameter.value | Should -Match 'TRAC'
  }
}