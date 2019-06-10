param($defaultPath)

[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
Out-Null

$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog

$OpenFileDialog.validateNames = $false
$OpenFileDialog.CheckFileExists = $false
$OpenFileDialog.checkpathExists = $true
$OpenFileDialog.Multiselect = $true
#$OpenFileDialog.Filter = “xml files (*.xml)|*.xml”
$openFileDialog.InitialDirectory = $defaultPath


$OpenFileDialog.ShowDialog() | Out-Null

#$OpenFileDialog.filename
$OpenFileDialog.ShowHelp = $true

return ,$OpenFileDialog.FileNames
