param($files,$synchash,$datagridItems) 
    ### getting what the grid is right now
    #$datagridItems = $datagrid.ItemsSource
    function CopyTo-Recipe ($SourcePath,$DestinationPath) {
        if($SourcePath -ne $DestinationPath){
           $null = Copy-Item $SourcePath $DestinationPath -Force
        }
        
    }

    foreach($file in $files){
        
        $dest = (join-path $syncHash.CurrentRecipeFolderPath (Split-Path $file -leaf))
        
        #### if it is a folder containing recipes, or a recipe... don't copy, just add reference
        $item = Get-Item $file
        if ( $item -is [System.IO.DirectoryInfo] ) {
            Write-host "IS a folder"
            $hasRecipe = @()
            
            $hasRecipe += Get-ChildItem $item.FullName -include @("*.xml","*.recipe","*.order") -Recurse | Where-Object {$_.fullname -notlike "*Substitutions*"}
            
            if($hasRecipe.count -gt 0){
                Write-host "Has a recipe"
                ### add references
                foreach($recipe in $hasRecipe){
                $RecipePath = $recipe.FullName
                $RecipePartPath = $RecipePath.Replace($synchash.RootDirectory,"")
                $RecipeName = Split-path $RecipePath -leaf
                
                $RecipePathFolder = Split-Path $RecipePath -Parent
                $recipeSubstitutionsFolderPath =  Join-Path $recipePathFolder "Substitutions"
                
                $destinationParentPath = Split-path $dest -parent
                $destinationSubstitutionsFolderPath = Join-Path $destinationParentPath "Substitutions"
                
                if(Test-Path $recipeSubstitutionsFolderPath){
                    &$syncHash.Copy_Folder -sourcePath $recipeSubstitutionsFolderPath -destinationPath $destinationSubstitutionsFolderPath
                }


                Write-host $destinationSubstitutionsFolderPath
                Write-host $RecipePath

                ### need to send in recipePartPath twice for recursive recipes.  Otherwise it won't save them correctly.
                [System.Data.DataTable]$datagridItems = &$syncHash.Add_Recipe_Items $syncHash $RecipePartPath $datagridItems $RecipeName $RecipePartPath
                #$RecipePartPath = $RecipePath.Replace($synchash.RootDirectory,"")
                
                #$datagridItems += (& $syncHash.Get_Recipe_Items -syncHash $syncHash -recipePartPath $RecipePartPath -maxOrder $datagridItems.count -layer 0).Defaultview
                
                #### Adding Variables
                $variables = @{}
                $variables = & $syncHash.Get_Recipe_Variables -xmlPath $RecipePath -syncHash $syncHash -variables $variables

                foreach($key in $variables.Keys)
                {
                $null = Add-CustomVariable $key $variables.Item($key)
                }

                $TextBoxHelp.appendText(( "`r`n" + (&$syncHash.Get_Recipe_HelpText $RecipePath)))

            }
            }else{
                Write-host "Doesn't Have a recipe"
                ### doesn't have recipe, so want to copy whole folder
                &$synchash.Copy_Folder -sourcePath $item.fullname -destinationPath $dest
                ### now loop through that local folder adding scripts
                $supportedFiles = Get-ChildItem -Path $dest -include @("*.ps1","*.sql") -Recurse | Where-Object {$_.fullname -notlike "*Substitutions*"}
                foreach($supportedFile in $supportedFiles){
                    [System.Data.DataTable]$datagridItems = & $synchash.Add_File $syncHash $supportedFile.fullname $datagridItems 
                }
            }
        }else{
            #### now this is if it is just a file, and not a folder
        
        #### if this is a config, add a reference
        Write-host "Is just a file"
        
        if($syncHash.RecipeExtensions -contains $item.Extension){
            write-host "File is a recipe"
            ### adding Items
            $RecipePath = $item.FullName
            $RecipePartPath = $RecipePath.Replace($synchash.RootDirectory,"")
            $RecipeName = Split-path $RecipePath -leaf
            $recipeSubstitutionsFolderPath = Split-Path $RecipePath -Parent
            
            $RecipePathFolder = Split-Path $RecipePath -Parent
            $recipeSubstitutionsFolderPath =  Join-Path $recipePathFolder "Substitutions"
            
            $destinationParentPath = Split-path $dest -parent
            $destinationSubstitutionsFolderPath = Join-Path $destinationParentPath "Substitutions"

            if(Test-Path $recipeSubstitutionsFolderPath){
                &$syncHash.Copy_Folder -sourcePath $recipeSubstitutionsFolderPath -destinationPath $destinationSubstitutionsFolderPath
            }
            
            Write-host $destinationSubstitutionsFolderPath
            
            [System.Data.DataTable]$datagridItems = &$syncHash.Add_Recipe_Items $syncHash $RecipePartPath $datagridItems $RecipeName $RecipePartPath
            
            Write-host $RecipePath
            #### Adding Variables
            $variables = @{}
            $variables = & $syncHash.Get_Recipe_Variables -xmlPath $RecipePath -syncHash $syncHash -variables $variables

            foreach($key in $variables.Keys)
            {
                $null = Add-CustomVariable $key $variables.Item($key)
            }
            
            $TextBoxHelp.appendText(( "`r`n" + (&$syncHash.Get_Recipe_HelpText $RecipePath)))
        }else {
            Write-host "file is not a recipe"
            ### file is potentially a script to be added
            CopyTo-Recipe $item.FullName $dest
             $supportedFile = Get-ChildItem $dest -include @("*.ps1","*.sql")
            if($supportedFile){
                Write-host "file is a script"
                
                [System.Data.DataTable]$datagridItems = & $synchash.Add_File $syncHash $supportedFile.FullName $datagridItems 
            }else{
                Write-host "File is not a script"
                Write-host "Didn't add file to grid since isn't supported:"$dest
            }
        }
    }
}
#$datagrid.ItemsSource = $datagridItems.Defaultview
return ,$datagridItems