function Update-CurrentRecipe ($synchash,$RecipePath) {
    write-host "UPDATED Current recipe"
    $synchash.CurrentRecipePath = $RecipePath
    $synchash.CurrentRecipeName = Split-Path $RecipePath -Leaf
    $syncHash.CurrentRecipePartPath = $RecipePath.replace($synchash.rootdirectory,"")
    $synchash.CurrentRecipeFolderPath = Split-Path $RecipePath -Parent
    $synchash.CurrentRecipeFolderPartPath = $synchash.CurrentRecipeFolderPath.replace($syncHash.rootdirectory,"")
    
    return $synchash
}