# the directory of demo.tests.ps1
$script_dir =  Split-Path -Parent $MyInvocation.MyCommand.Path

# load the script to test into memory
. "$script_dir\Set-RecipeFile.ps1"


Describe 'Set-RecipeFile takes a recipe object and writes it to a file directory' {
    ### File path variables
    BeforeEach {
      [system.collections.hashtable]$syncHash = @{
        RootDirectory = $TestDrive
        RecipeName = 'Test.recipe'
      }
    
      $userName = 'raboley'
      $recipePath = Join-Path $TestDrive "kitchens\$userName\$($syncHash.CurrentRecipeName)\$($syncHash.recipeName)"

      $variables = @{
        TRACDatabase = "TRAC_TEST2"
        PORTALDatabase = "PORTAL_TEST2"
        ONTRACDatabase = "ONTRAC_TEST2"
    }
   
        $ingredients = @()
        $ingredients += @{
            RunOrder = 1
            Name = "Test.txt"
            RelativePath = "\test.txt"
            ToRun = $true
        }
        $ingredients += @{
          RunOrder = 2
          Name = "Tes2.txt"
          RelativePath = "\test2.txt"
          ToRun = $true
      }

      $recipe = @{
          recipeName = "Test_Recipe"
          variables = $variables
          ingredients = $ingredients
      }
    }
    


  it 'Should save a file to a path' {
    $paramaters = @{
      recipePath = $recipePath
      recipe = $recipe
    }
    Set-RecipeFile @paramaters 
    
    Test-Path $paramaters.recipePath | Should Be $true
  }

  it 'Should have a json property of name in it' {
    $paramaters = @{
      recipePath = $recipePath
      recipe = $recipe
    }
    Set-RecipeFile @paramaters 
    $string = Get-Content $paramaters.recipePath | Out-String
    
    $TestRecipe = ConvertFrom-Json $string
    $TestRecipe.ingredients.Where{ $_.RunOrder -eq 2}.Name | Should Be 'Tes2.txt'
  }
}