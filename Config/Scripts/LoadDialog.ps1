[CmdletBinding()]
Param(
[Parameter(Mandatory=$True,Position=1)]
[string]$XamlPath
)
 #$xamlpath = "C:\Russell\Tools\UI project\config\Forms\MyForm.xaml" ##test

[xml]$Global:xmlWPF = Get-Content -Path $XamlPath
 
#Add WPF and Windows Forms assemblies
try{
Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase,system.windows.forms
} catch {
Throw “Failed to load Windows Presentation Framework assemblies.”
}

###### Creating the UI in a hash table so multiple threads can be used and the UI doesn't freeze up
$Global:syncHash = [hashtable]::Synchronized(@{}) 

#Create the XAML reader using a new XML node reader
$reader = new-object System.Xml.XmlNodeReader $xmlWPF
$syncHash.window = [Windows.Markup.XamlReader]::Load( $reader )

#Create hooks to each named object in the XAML
$xmlWPF.SelectNodes(“//*[@Name]”) | %{
Set-Variable -Name ($_.Name) -Value $syncHash.window.FindName($_.Name) -Scope Global
}
