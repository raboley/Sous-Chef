$datagridItems = New-Object system.Data.DataTable
  $datagridItems.Columns.Add((New-Object System.Data.DataColumn('Name', 'string')))
  $datagridItems.Columns.Add((New-Object System.Data.DataColumn('ScriptType', 'string')))
  $datagridItems.Columns.Add((New-Object System.Data.DataColumn('PartPath', 'string')))
  
  $datagridItems.Columns.Add((New-Object System.Data.DataColumn('OwningRecipeName', 'string')))
  $datagridItems.Columns.Add((New-Object System.Data.DataColumn('OwningRecipeRecipePartPath', 'string')))
  $datagridItems.Columns.Add((New-Object System.Data.DataColumn('OwningRecipe', 'string')))

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

 ConvertTo-Json $datagridItems.DefaultView