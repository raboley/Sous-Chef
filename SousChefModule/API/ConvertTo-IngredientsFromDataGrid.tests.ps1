# the directory of demo.tests.ps1
$script_dir =  Split-Path -Parent $MyInvocation.MyCommand.Path

# load the script to test into memory
. "$script_dir\ConvertTo-IngredientsFromDatagrid.ps1"

Describe 'ConvertTo-IngredientsFromDatagrid Converts a DatagridView to a powershell object' {

BeforeEach {
  $datagridItems = New-Object system.Data.DataTable
  $datagridItems.Columns.Add((New-Object System.Data.DataColumn('Name', 'string')))
  $datagridItems.Columns.Add((New-Object System.Data.DataColumn('ScriptType', 'string')))
  $datagridItems.Columns.Add((New-Object System.Data.DataColumn('PartPath', 'string')))
  
  $datagridItems.Columns.Add((New-Object System.Data.DataColumn('OwningRecipeName', 'string')))
  $datagridItems.Columns.Add((New-Object System.Data.DataColumn('OwningRecipeRecipePartPath', 'string')))
  $datagridItems.Columns.Add((New-Object System.Data.DataColumn('OwningRecipe', 'string')))
}
  

  it 'Has the Name Property with value Name_Test' {
    $null=$datagridItems.Rows.Add(
      'Name_Test'
     ,'ScriptType_Test'
     ,'PartPath_Test'
     ,'OwningRecipeName_Test'
     ,'OwningRecipePartPath_Test'
     ,'OwningRecipe'
   )
   $datagridItemsView = $datagridItems.defaultView
    
    $paramaters = @{
      dataGridItemsView = $datagridItemsView
    }
    
    $json = ConvertTo-IngredientsFromDatagrid @paramaters 
    
    $json.name | should be $paramaters.dataGridItemsView.name
  }

  it 'Has the Name Property with value ConvertToExcel' {
    $null=$datagridItems.Rows.Add(
      'ConvertToExcel'
     ,'ScriptType_Test'
     ,'PartPath_Test'
     ,'OwningRecipeName_Test'
     ,'OwningRecipePartPath_Test'
     ,'OwningRecipe'
   )
   $datagridItemsView = $datagridItems.defaultView
    
    $paramaters = @{
      dataGridItemsView = $datagridItemsView
    }
    
    $json = ConvertTo-IngredientsFromDatagrid @paramaters 
    
    $json.name | should be $paramaters.dataGridItemsView.name
  }

  it 'Has the same properties as data grid being passed in' {
    $null=$datagridItems.Rows.Add(
      'Name_Test'
     ,'ScriptType_Test'
     ,'PartPath_Test'
     ,'OwningRecipeName_Test'
     ,'OwningRecipePartPath_Test'
     ,'OwningRecipe'
   )
   $datagridItemsView = $datagridItems.defaultView
    
    $paramaters = @{
      dataGridItemsView = $datagridItemsView
    }
    
    $json = ConvertTo-IngredientsFromDatagrid @paramaters 
    
    $json.name | should be $paramaters.dataGridItemsView.name
    $json.ScriptType | should be $paramaters.dataGridItemsView.ScriptType
    $json.PartPath | should be $paramaters.dataGridItemsView.PartPath
    $json.OwningRecipeName | should be $paramaters.dataGridItemsView.OwningRecipeName
    $json.OwningRecipeRecipePartPath | should be $paramaters.dataGridItemsView.OwningRecipeRecipePartPath
    $json.OwningRecipe | should be $paramaters.dataGridItemsView.OwningRecipe
  }

  it 'Has the same properties as data grid being passed in' {
    $null=$datagridItems.Rows.Add(
      'Name_Test'
     ,'ScriptType_Test'
     ,'PartPath_Test'
     ,'OwningRecipeName_Test'
     ,'OwningRecipePartPath_Test'
     ,'OwningRecipe'
   )
   $datagridItemsView = $datagridItems.defaultView
    
    $paramaters = @{
      dataGridItemsView = $datagridItemsView
    }
    
    $json = ConvertTo-IngredientsFromDatagrid @paramaters 
    
    $json.name | should be $paramaters.dataGridItemsView.name
    $json.ScriptType | should be $paramaters.dataGridItemsView.ScriptType
    $json.PartPath | should be $paramaters.dataGridItemsView.PartPath
    $json.OwningRecipeName | should be $paramaters.dataGridItemsView.OwningRecipeName
    $json.OwningRecipeRecipePartPath | should be $paramaters.dataGridItemsView.OwningRecipeRecipePartPath
    $json.OwningRecipe | should be $paramaters.dataGridItemsView.OwningRecipe
  }

  it 'Has can find Name_test2 when there are two rows' {
    $null=$datagridItems.Rows.Add(
      'Name_Test'
     ,'ScriptType_Test'
     ,'PartPath_Test'
     ,'OwningRecipeName_Test'
     ,'OwningRecipePartPath_Test'
     ,'OwningRecipe'
   )
   $null=$datagridItems.Rows.Add(
    'Name_Test2'
   ,'ScriptType_Test2'
   ,'PartPath_Test2'
   ,'OwningRecipeName_Test2'
   ,'OwningRecipePartPath_Test2'
   ,'OwningRecipe2'
 )
   $datagridItemsView = $datagridItems.defaultView
    
    $paramaters = @{
      dataGridItemsView = $datagridItemsView
    }
    
    $json = ConvertTo-IngredientsFromDatagrid @paramaters 
    $NameWeAreTesting = $json | Where-Object { $_.name -eq 'Name_Test2'} | Select-Object -ExpandProperty name
    
    $NameWeAreTesting | should be 'Name_Test2'
  }
}

