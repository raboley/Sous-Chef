# the directory of demo.tests.ps1
$script_dir =  Split-Path -Parent $MyInvocation.MyCommand.Path

# load the script to test into memory
. "$script_dir\Invoke-Recipe.ps1"
. "$script_dir\Get-RecipeFromFile.ps1"


Describe 'Set-RecipeFile takes a recipe object and writes it to a file directory' {
    ### File path variables

    New-Item "$TestDrive\Create_Testjson.ps1" -Value {$null = New-Item "$TestDrive\Test.json" -value "{Test}" -Force} -Force
    New-Item "$TestDrive\Create_Testjson3.ps1" -Value {param($params) 
        $null = New-Item "$TestDrive\Test3.json" -value "$($params.ONTRACDatabase)" -Force} -Force
    New-Item "$TestDrive\Throw_PoopError.ps1" -Value {Command-DoesntExist} -Force

    $recipePath = Join-Path $TestDrive "Test_Recipe.recipe"
    $variables = @{
        TRACDatabase = "TRAC_TEST2"
        PORTALDatabase = "PORTAL_TEST2"
        ONTRACDatabase = "ONTRAC_TEST2"
        testDrive = $testDrive
    }
   
        $ingredients = @()
        $ingredients += @{
            RunOrder = 1
            Name = "Create_Testjson.ps1"
            RelativePath = "\Create_Testjson.ps1"
            ToRun = $true
            ScriptType = 'Powershell'
        }
        $ingredients += @{
          RunOrder = 2
          Name = "Create_Testjson3.ps1"
          RelativePath = "\Create_Testjson3.ps1"
          ToRun = $true
          ScriptType = 'Powershell'
      }

      $recipe = @{
          recipeName = "Test_Recipe"
          variables = $variables
          ingredients = $ingredients
      }
      
      $testjson = Join-Path $testDrive "Test.json"
      $testjson3 = Join-Path $testDrive "Test3.json"
      
    Mock Get-RecipeFromFile {return $recipe }

    it 'Should Execute Powershell files' {

    
    Invoke-Recipe -recipePath $recipePath -logDestination 'Null'

    Test-path $testjson | should be $true
    Test-path $testjson3 | should be $true
  }

  Mock Get-RecipeFromFile {return $recipe }

  it 'Should pass variables from recipe through to powershell scripts' {
  
      Invoke-Recipe -recipePath $recipePath -logDestination 'Null'
      Get-Content $testjson3 | should be 'ONTRAC_TEST2'
  }

  it 'Should error when powershell scripts throw compiler errors' {
    
    $recipe.ingredients += @{
        RunOrder = 3
        Name = "Throw_PoopError.ps1"
        RelativePath = "\Throw_PoopError.ps1"
        ToRun = $true
        ScriptType = 'Powershell'
    }
    Mock Get-RecipeFromFile {return $recipe }
    
    $null = Invoke-recipe -recipePath $recipePath -logDestination 'Null' | Should -BeLike '*Command-DoesntExist*'
  }
}