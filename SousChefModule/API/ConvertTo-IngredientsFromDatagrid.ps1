function ConvertTo-IngredientsFromDatagrid {
    Param(
        [Parameter(ParameterSetName='default',Position=0,Mandatory=1)][system.Data.DataView] $dataGridItemsView
    )
    $objects = @()

    foreach ($row in $dataGridItemsView){
        $objects += @{
            name = $dataGridItemsView.name
            ScriptType = $dataGridItemsView.ScriptType
            PartPath = $dataGridItemsView.PartPath
            OwningRecipeName = $dataGridItemsView.OwningRecipeName
            OwningRecipeRecipePartPath = $dataGridItemsView.OwningRecipeRecipePartPath
            OwningRecipe = $dataGridItemsView.OwningRecipe
        }
    }
    

    return $objects
}
