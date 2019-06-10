# the directory of demo.tests.ps1
$script_dir =  Split-Path -Parent $MyInvocation.MyCommand.Path

# load the script to test into memory
. "$script_dir\Get-RecipeFromFile.ps1"


Describe -tags ('unit') "Get-RecipeVariables gets the variables associated with a recipe and runs them" {
    Context "Get-RecipeVariables" {
$recipeJson = @'
{
    "recipeName":  "Test_Recipe",
    "ingredients":  [
                        {
                            "RunOrder":  1,
                            "Name":  "Test.txt",
                            "ToRun":  true,
                            "RelativePath":  "\\test.txt"
                        },
                        {
                            "RunOrder":  2,
                            "Name":  "Tes2.txt",
                            "ToRun":  true,
                            "RelativePath":  "\\test2.txt"
                        }
                    ],
    "variables":  {
                      "TRACDatabase":  "TRAC_TEST2",
                      "PORTALDatabase":  "PORTAL_TEST2",
                      "ONTRACDatabase":  "ONTRAC_TEST2"
                  }
}
'@
$recipeName = "Test_Recipe.recipe"
$recipePath = Join-Path $TestDrive "$recipeName"

New-Item -Path $recipePath -Value $recipeJson


        It "Should return object with variables" {
            $testRecipe = Get-RecipeFromFile $recipePath
            $TestRecipe.ingredients.Where{ $_.RunOrder -eq 2}.Name | Should Be 'Tes2.txt'
        }
    }
}
