param($syncHash)
    
    $TextBoxHelp.Text =  &$syncHash.Get_Recipe_HelpText $synchash.CurrentRecipePath
    
    # removing the current variables
    foreach($obj in $Grid_Variables.Children | Where-Object {$_.name -like 'c_DockPanel_*'}) 
    {
        $null =  $grid_variables.Children.remove($obj)
    }

    ### get the variables from the recipe
    $variables = @{}
    $variables = & $syncHash.Get_Recipe_Variables -xmlPath $synchash.CurrentRecipePath -syncHash $syncHash -variables $variables

    ### have to loop through the hash table since I didn't think about doing it a different way
    ### pulling each key from the hash table, do a for each loop on them and then return the values to the grid

    foreach($key in $variables.Keys)
    {
       $null=Add-CustomVariable $key $variables.Item($key)
    }
    
    if($dataGridItems){
       remove-variable datagridItems -ErrorAction SilentlyContinue
    }
    
    [System.Data.DataTable]$datagridItems = &$syncHash.Get_Recipe_Items $syncHash $syncHash.CurrentRecipePartPath $null $synchash.CurrentRecipeName $syncHash.CurrentRecipePartPath

return ,$datagridItems
