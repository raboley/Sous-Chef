$args = @{
    CurrentKitchen = 'C:\Users\rboley\Desktop\git\RCWorkflow_Implementation\Tools\Sous Chef\Tutorial'
}
try {
    & "C:\Users\rboley\Desktop\git\RCWorkflow_Implementation\Tools\Sous Chef\Tutorial\Using Custom Variables in PS Example.ps1" $args -errorVariable myerrors


}
catch {
    write-host "Script Errored"
}

