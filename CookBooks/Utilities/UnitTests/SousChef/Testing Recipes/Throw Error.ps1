Try{
    get-child
}catch{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    $customMessage = "This error was thrown by a custom Try-Catch block in Powershell"
    $message = ""
    $Message += "$customMessage`r`n`r`n"
    $Message += "$ErrorMessage`r`n`r`n"
    $Message += "$FailedItem`r`n`r`n"
    
    Throw $message
}