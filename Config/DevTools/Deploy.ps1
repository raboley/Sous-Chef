#Required to load the XAML form and create the PowerShell Variables
#cd "C:\Russell\Tools\Deployer\scripts"

./Deployer/scripts/LoadDialog.ps1 -XamlPath '.\Deployer\Forms\MyForm.xaml'
 
#EVENT Handler
$Deploy.add_Click({
   $currentDirectory = pwd
   $currentParent = Split-Path -parent $currentDirectory
   $currentParentParent = Split-Path -parent $currentParent
   $path = Join-Path $currentDirectory "\WpfApp1\WpfApp1\MainWindow.xaml"
   $dest = Join-Path $currentParent "\Forms\MyForm.xaml"

   $replaces = @()
   $replaces += @{Find = 'x:Class="WpfApp1.MainWindow"'; Replace = ''}
   $replaces += @{Find = 'xmlns:d="http://schemas.microsoft.com/expression/blend/2008"'; Replace = ''}
   $replaces += @{Find = 'xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"'; Replace = ''}
   $replaces += @{Find = 'xmlns:local="clr-namespace:WpfApp1"'; Replace = ''}
   $replaces += @{Find = 'mc:Ignorable="d"'; Replace = ''}
   $replaces += @{Find = 'x:Name='; Replace = 'Name='}


   $text = [IO.File]::ReadAllText($path) 
   

   foreach ($replace in $replaces)
   {
        $find = $replace.find
        $repl = $replace.replace
        $text = $text -replace [regex]::escape($find), $repl
        
   }
   [IO.File]::WriteAllText($dest, $text) 

&"$currentParentParent\Sous Chef.ps1"
})
########Loading before the window #####################



#Launch the window
$xamGUI.ShowDialog() | out-null





