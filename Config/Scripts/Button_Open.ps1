param($syncHash,$commandLine)

$xmlPath = &$syncHash.Get_OpenFile  $synchash.CurrentRecipeFolderPath  

if($xmlPath) 
{

    $syncHash = Update-CurrentRecipe $synchash $xmlPath
    [System.Data.DataTable]$datagridItems = &$syncHash.Open_File $synchash
    $datagrid.ItemsSource = $datagriditems.Defaultview

}