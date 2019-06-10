param($debug)
#Required to load the XAML form and create the PowerShell Variables
#$global:currentDirectory = "C:\Users\rboley\Documents\UI project"
### getting help on wpf objects
# New-Object System.Windows.Controls.Button | Get-Member -MemberType Property
Add-Type -AssemblyName PresentationFramework
cd c:

### $syncHash gets created in this script, so using Curdir here, then setting $rootDirectory later
$currentDirectory = Split-Path -parent $MyInvocation.MyCommand.Definition
&"$currentDirectory\config\Scripts\LoadDialog.ps1" -XamlPath "$currentDirectory\config\Forms\MyForm.xaml"

##################################################################################
#### %%%%%%%%%%%%%%%%%%%%% Pre-loading variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%####
##################################################################################

#TODO update this to be a control so user can specify
$syncHash.RootDirectory = Split-Path -parent $MyInvocation.MyCommand.Definition
$ScriptFolder = "$($syncHash.RootDirectory)\DefaultKitchen\"
$synchash.CurrentRecipeFolderPath = $scriptFolder

$userConfig = "$($syncHash.RootDirectory)\config\settings\UserSettings.xml"
$syncHash.RecipeExtensions = ".xml",".recipe",".order"
$tempRecipeName = '_Temp_'
$configScriptsPath = Join-Path $synchash.rootdirectory "\Config\Scripts"

$currentUser = whoami.exe
$CurrentuserName = Split-Path $currentUser -leaf
$syncHash.cookbooks =  Join-path $synchash.RootDirectory "cookbooks"
$syncHash.kitchens = Join-path $synchash.RootDirectory "kitchens"
### Functions 
$syncHash.Get_OpenFile = Join-path $syncHash.RootDirectory "\Config\Scripts\Functions\Get-OpenFile.ps1"

#### this script houses all the functions that will be used, this is so command line also has access to them
## Does nothing right now
#$syncHash.Get_FunctionLibrary = Join-path $syncHash.RootDirectory "\Config\Scripts\Functions\Function_Library.ps1"
### Buttons
$syncHash.Button_Open = Join-path $syncHash.RootDirectory "\Config\Scripts\Button_Open.ps1"

### commands
$syncHash.Get_Recipe_Items = Join-path $syncHash.RootDirectory "\Config\Scripts\Get_Recipe_Items.ps1"
$syncHash.Get_Recipe_Variables = Join-path $syncHash.RootDirectory "\Config\Scripts\Get_Recipe_Variables.ps1"
$syncHash.Get_Recipe_HelpText = Join-path $syncHash.RootDirectory "\Config\Scripts\Get_Recipe_HelpText.ps1"
$syncHash.Save_Recipe = Join-path $syncHash.RootDirectory "\Config\Scripts\Save_Recipe.ps1"
$syncHash.Add_Recipe_Items = Join-path $syncHash.RootDirectory "\Config\Scripts\Add_Recipe_Items.ps1"
$syncHash.Add_Script = Join-path $syncHash.RootDirectory "\Config\Scripts\Add_Script.ps1"
$syncHash.Add_File = Join-path $syncHash.RootDirectory "\Config\Scripts\Add_File.ps1"
$syncHash.File_Waiter = Join-path $syncHash.RootDirectory "\Config\Scripts\File_Waiter.ps1"
$syncHash.Open_File = Join-path $syncHash.RootDirectory "\Config\Scripts\Open_File.ps1"
$syncHash.Copy_Folder = Join-path $syncHash.RootDirectory "\Config\Scripts\Copy_Folder.ps1"
$syncHash.New_UserRecipeConfig = Join-Path $syncHash.RootDirectory "\Config\Scripts\Save_User_Recipe_Variables.ps1"

$syncHash.Cook_Order = Join-path $syncHash.RootDirectory "\Config\Scripts\Cook_Order.ps1"

## pull in functions from library files
. "$configScriptsPath\New_UserSettings.ps1"

######
function Update-CurrentRecipe ($synchash,$RecipePath) {
    $synchash.CurrentRecipePath = $RecipePath
    $synchash.CurrentRecipeName = Split-Path $RecipePath -Leaf
    $syncHash.CurrentRecipePartPath = $RecipePath.replace($synchash.rootdirectory,"")
    $synchash.CurrentRecipeFolderPath = Split-Path $RecipePath -Parent
    $synchash.CurrentRecipeFolderPartPath = $synchash.CurrentRecipeFolderPath.replace($syncHash.rootdirectory,"")
    
    $TextBlock_RecipeName.Text = $synchash.CurrentRecipeName
    return $synchash
}
#### loading user config data if it exists
$parameters = @{
    syncHash = $syncHash
    userName = $currentUserName
}
New-UsersSettings @parameters
$userSettings = Get-UsersSettings @parameters

if($userSettings.OpenLastRecipeOnStart){
    if(Test-Path $userConfig){
        [xml]$UserConfigXML = (Get-Content -path $userConfig)
        
        $currentUsersettings = $UserConfigXML.Config.UserSettings.User | Where-Object {$_.name -eq $currentUser.tostring()}
        $UserConfigXML.Config.UserSettings.User | Where-Object {$_.name -eq $currentUser.tostring()}
    
        if($currentUsersettings){
            $config = Join-Path $($syncHash.RootDirectory) $currentUsersettings.LastRecipe
    
            if(Test-path $config){
                write-host $config
            
            $syncHash = Update-CurrentRecipe $synchash $config
            }   
        }
    }
}else {
    [system.collections.hashtable]$TempVariableHashTable = @{
        Database = ''
      }
    $synchash.CurrentRecipeName = $tempRecipeName
    $tempRecipePath = & $syncHash.New_UserRecipeConfig -syncHash $syncHash -variables $TempVariableHashTable -userName $currentUserName
    $syncHash = Update-CurrentRecipe -synchash $synchash -RecipePath $tempRecipePath[0].fullname
    
}

### DataGrid loading with script list
foreach($row in $datagrid.Items) {
    ##getting the current rows index and styling properties
    $index = $datagrid.items.indexof($row)
    $RowStyles = $datagrid.ItemContainerGenerator.ContainerFromIndex($index)
    ### won't work right now because it needs the data grid to be loaded and it isn't yet.
    ## set the cell background color to yellow to indicate a warning
    #$RowStyles.Background = '#FF7077C3'
    #$row.ErrorMessage = $row.Warnings
    ##
    $DataGrid.Selecteditem = $index
    #$DataGrid.RowDetailsVisibilityMode = 2
}
## TODO make it so you can select a folder or something dynamically
##$ScriptsFolder.text = $ScriptFolder


##################################################################################
#### %%%%%%%%%%%%%%%%%%%%%%%% Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%####
##################################################################################

Function Get-OpenFile($defaultPath)
{ 
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

return $OpenFileDialog.FileNames
}

Function Get-AddFile($defaultPath){
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
    return $OpenFileDialog.FileNames
}

Function Get-SaveFile($defaultPath,$fileName = "MyRecipe.xml")
{ 
[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
Out-Null

$SaveChooser = New-Object -Typename System.Windows.Forms.SaveFileDialog
$saveChooser.InitialDirectory = $defaultpath
$savechooser.AddExtension = ".recipe"
$saveChooser.DefaultExt = ".recipe"
$saveChooser.Title = "Save Recipe"
$saveChooser.Filter = “xml files (*.recipe)|*.recipe”
$saveChooser.FileName = $fileName
$SaveChooser.ShowDialog()
return $saveChooser
}
###### Function for running scripts in seperate runspace so UI doesn't freeze up ##########
function exec_Scripts {
$variables = get-customVariables $synchash.CurrentRecipeFolderPath

    ## Adding the default variables that I don't want saved
    $variables = $variables + @{"CurrentKitchen"=$synchash.CurrentRecipeFolderPath}
    ##

$sqlVariables = get-CustomVariablesSQL $variables
RunspaceRun param -syncHash $syncHash -datagrid $DataGrid -currentDirectory $($syncHash.RootDirectory) -run $Button_Run -reload $Button_Reload -edit $button_Edit -stackpanel $Grid_Variables -CustomVariables $variables -CustomVariablesSQL $sqlVariables -retry $Button_Retry -ScriptFolder $synchash.CurrentRecipeFolderPath -logTextBox $logTextBox -stop $Button_Stop
}

### add custom variable button
function Add-CustomVariable($VariableName,$variableValue) {
 
 if($VariableName -ne '')
    {
    $NewDockPanel = New-Object System.Windows.Controls.DockPanel
    $NewDockPanel.name = "c_DockPanel_$($VariableName)"

    $NewLabel = New-Object System.Windows.Controls.label
    $NewLabel.Name = "cLabel_$($VariableName)"
    $NewLabel.Content = "$($VariableName):"
    $NewLabel.margin = "5,2.5"
    $NewLabel.Foreground = "#FFE6E6E6"
    
    $NewTextBox = New-Object System.Windows.Controls.TextBox
    $NewTextBox.Name = "cTextBox_$($VariableName)"
    $NewTextBox.Margin = "10,5,10,5" 
    $NewtextBox.Text = $VariableValue

    $NewButton = New-Object System.Windows.Controls.Button
    $newButton.Name = "cButton_$($VariableName)"
    $newButton.Content = "-"
    $newButton.Background = "#FFDE9191"
    $newButton.Width = '20'
    $newButton.Height = '20'
    $newButton.Margin = "10,2.5,1,2.5"
    $newButton.add_Click({
    
    ### can reference the dynamically created button with $this, then stripping off the button stuff and adding the dock panel to find the dock panel to remove when pushed.
    $dockName = $this.name -replace 'cButton_', ''

    foreach($obj in $Grid_Variables.Children | Where-Object {$_.name -eq "c_DockPanel_$dockName"}) 
    {
        $grid_variables.Children.remove($obj)
    }
    })
if(!($Grid_Variables.Children | Where-object {$_.Name -eq $newDockPanel.name })){
    $NewDockPanel.AddChild($newButton)
    $NewDockPanel.AddChild($NewLabel)
    $NewDockPanel.AddChild($NewTextBox)

    $newDockPanel.UpdateLayout
    $Grid_Variables.AddChild($NewDockPanel)
}
    
    }
    else {
    write-host "Variable needs a name.  Type in a variable name in text box"
    }
}

function get-customVariables($ScriptFolder)  {
    $Custom_parameters = @{}
    foreach($obj in $Grid_Variables.Children) 
    {
       $Arguments =  $obj.Children |Where-Object {$_.name -like 'cTEXTBox_*'}
   

       foreach($argument in $arguments) 
       {
       $name = $argument.Name -replace("cTextBox_","")
       $custom_Parameters = $Custom_parameters + @{$name=$argument.text}
       }
       
    }

    return $custom_Parameters
}

function get-CustomVariablesSQL($custom_Parameters) {
    [string[]]$SQLParameters = @()
    foreach ($key in $custom_Parameters.Keys)
    {
    #SQL likes array of strings for the variables
    #"CITY='$city'"
    ## only want varaibles that have values
    if($custom_Parameters[$key]){
        $SQLParameters += "$($key)=$($custom_Parameters[$key])"
        }
    }
    return $SQLParameters
}


function RunspaceRun {
    param($syncHash,$datagrid,$currentDirectory,$Run,$edit,$reload,$stackpanel,$CustomVariables,$customVariablesSQL,$retry,$scriptFolder,$logTextBox,$stop)
     
     $syncHash.Continue = 0
     $syncHash.Stop = 0
     $syncHash.Retry = 0
     $syncHash.Log = ''
    ### runspace settings
    $syncHash.Host = $host
    $Runspace = [runspacefactory]::CreateRunspace()
    $Runspace.ApartmentState = "STA"
    $Runspace.ThreadOptions = "UseNewThread"
    $Runspace.Open()

    ### pushing variables from main body script to new runspace
    $Runspace.SessionStateProxy.SetVariable("syncHash",$syncHash) ##The runspace itself
    $Runspace.SessionStateProxy.SetVariable("datagrid",$datagrid) ##The Datagrid with the scripts objects
    $Runspace.SessionStateProxy.SetVariable("currentDirectory",$currentDirectory) 
    $Runspace.SessionStateProxy.SetVariable("Run",$run) ## the run button so it can be disabled during runtime
    $Runspace.SessionStateProxy.SetVariable("Edit",$edit) ## the run button so it can be disabled during runtime
    $Runspace.SessionStateProxy.SetVariable("Reload",$reload) ## the run button so it can be disabled during runtime
    $Runspace.SessionStateProxy.SetVariable("StackPanel",$StackPanel) ## the run button so it can be disabled during runtime
    $Runspace.SessionStateProxy.SetVariable("CustomVariables",$CustomVariables) ## the run button so it can be disabled during runtime
    $Runspace.SessionStateProxy.SetVariable("CustomVariablesSQL",$CustomVariablesSQL) ## the run button so it can be disabled during runtime
    $Runspace.SessionStateProxy.SetVariable("retry",$retry) ## the run button so it can be disabled during runtime
    $Runspace.SessionStateProxy.SetVariable("ScriptFolder",$ScriptFolder) ## the run button so it can be disabled during runtime
    $Runspace.SessionStateProxy.SetVariable("logTextBox",$logTextBox) ## the run button so it can be disabled during runtime
    $Runspace.SessionStateProxy.SetVariable("Stop",$Stop)


############ code to be run in the other runpsace
    $code = { 
        $visualLine = "`r`n---------------------------------------------------`r`n"
        function Get-PrintableHashTable ($hash){
            # Need to get a variable that can be ran in powershell for the manual call that goes to the log file
            if($hash){
                $string = "@{`r`n"
                foreach($key in $hash.keys){
                    $string += "$key=""$($hash[$key])""`r`n"
                }
                $string += "}"
            }
            return $string
        }
        $VerbosePreference = "Continue" 
        
        $items = @()
        $Items += $datagrid.Items |Where-Object {$_.ToRun -eq 'True' }
        ### disabling the run button so you can't click it twice
        $syncHash.Window.Dispatcher.invoke(  #this command pushes info to the UI.  so anything that should be updated in the UI while this is running needs to go through the synchash invoke command as an action.
        [action]{$run.IsEnabled = 0;$edit.IsEnabled = 0;$reload.IsEnabled = 0 ;$Stop.IsEnabled = 1})

        #reset the coloring if it hasn't changed
        Foreach($row in $datagrid.items )
        {
        ##getting the current rows index and styling properties
        $index = $datagrid.items.indexof($row)
        $RowStyles = $datagrid.ItemContainerGenerator.ContainerFromIndex($index)
             
        ## Set current row's style to normal 
        $syncHash.Window.Dispatcher.invoke(
            [action]{$RowStyles.Background = '#FF3F3F42';$RowStyles.foreground = '#FFF7FAFF'})
        }
            $x = 0
            while($x -lt $items.count -and $syncHash.Stop -ne 1)
            ##Foreach($row in $Items )
            {
            ##getting the current rows index and styling properties
            $row = $items[$x]
            $index = $datagrid.items.indexof($row)
            $RowStyles = $datagrid.ItemContainerGenerator.ContainerFromIndex($index)
            
            ## creating the logging variables as arrays so they will enumerate properly.
            $message = @() 
            $messages = @()
            $Output = @()
            $StringOutput = ''
            $text = ''
            $errored = 0
            $error.clear()
            ## Set current row's style to purple for running
            $syncHash.Window.Dispatcher.invoke(
                [action]{$RowStyles.Background = '#FFFFFFFF';$RowStyles.foreground = '#FF101011'})
## %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SQL running section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ##
            if($row.ScriptType -eq 'SQL')
            {
                ## running sql scripts, sql script runner should only pass back error information and not results 
                ## if $message is populated that means something errored
                
                if($customVariables.Database){
                    $database = $customVariables.Database
                }
                else{
                    $database = 'Master'
                }
                $stringVar = $customVariablesSQL | Out-String
                $call = '$stringVar = ' + "$stringVar`r`ninvoke-Sqlcmd -InputFile $($row.fullname) -variables "+ '$stringVar' + "-database $($database)"
                $standaloneCall = "$($row.name) - To Execute Manually:`r`n $visualLine $call $visualLine`r`n"
                $syncHash.log += $standaloneCall
                $syncHash.Window.Dispatcher.invoke(
                    [action]{$logTextBox.text = $syncHash.log }) 
                try {
                    $Output = %{ $rows = Invoke-Sqlcmd -InputFile $row.fullname -ServerInstance 'localhost' -Database $database -verbose -ErrorVariable message -Variable $customVariablesSQL -QueryTimeout 65535} 4>&1
                    #[array]$message = &"$currentDirectory\config\Scripts\Run_SQL_Script.ps1" -script $row -variables $CustomVariablesSQL -database $customVariables.Database
                }
                catch{
                    $messages += $_.Exception.Message
                }
                
                function AddTo-Log ($messages,$string){
                    if($messages){
                        if(!($String)){ 
                          $StringBuilder  = ''
                        }else{
                            $stringBuilder = $string
                        }
                        if($message.count -gt 1){
                            foreach($message in $messages){
                            $StringBuilder = $string + $message + "`r`n"

                            }
                        }else{
                            $stringBuilder = $string + $messages + "`r`n"
                        }
                    }
                    return $StringBuilder
                }
                
                $LogText = AddTo-Log $rows
                $LogText += AddTo-Log $Messages $LogText
                $LogText += AddTo-Log $Message $LogText
                
                ### determining if there was an error, and writing to log
                
                if($messages){
                    $text += "$($row.name): -- Script Succeeded!`r`n"
                }else{
                    $text += "$($row.name):ErrorCount $($messages.count): Error Message: -- $messages`r`n"
                }
                if($message.count -eq 0){
                    $text += "$($row.name):$($message.count) -- Script Succeeded!`r`n"
                }else{
                    $text += "$($row.name):ErrorCount $($message.count): Error Message: -- $message`r`n"
                }
                ## getting the print and Raiserror statements
                
                if($Output -ne $null){
                    foreach($line in $Output){
                        $StringOutput += "$line`r`n"
                    }
                    Write-host $Output
                    $syncHash.log += "This is output from $($row.Name): $visualLine $StringOutput $visualLine"
                }
<#  Maybe use in future.  this is to output select statement info #>
                if($rows -ne $null){
                    foreach($line in $rows){
                        $StringOutput += "$line`r`n"
                    }
                    
                    $syncHash.log += "This is output from $($row.Name): $visualLine $StringOutput $visualLine"
                }
<##>
                $syncHash.log += $LogText
                $syncHash.Window.Dispatcher.invoke(
                    [action]{$logTextBox.text = $syncHash.log}) 

            }
            ## %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Powershell running section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ##
            ELSEIF($row.ScriptType -eq 'Powershell')
            {
                
                ## running powershell scripts, any output will populate 
                ## scripts should be written to not produce any output.
                try{
                    $stringVar =  '$paramaters = ' + (Get-PrintableHashTable $customVariables ) + "`r`n"
                    $standaloneCall = "$stringVar `r`n & ""$($row.fullName)""" + ' $paramaters | Out-string'
                    $syncHash.log += $standaloneCall
                    $syncHash.Window.Dispatcher.invoke(
                        [action]{$logTextBox.text = $syncHash.log})
                    
                    $Output = & $row.FullName $customVariables  | Out-String

                    if($Output -ne $null){
                        $syncHash.log += "This is output from $($row.Name): $visualLine $Output $visualLine"
                    }
                    
                    foreach($er in $error){
                        $message += "Message:$($er.Exception.Message)`r`n"

                        $message += "ScriptStackTrace:$($er.ScriptStackTrace)`r`n"
                        
                    } 
                }
                catch{
                    $message += $_.Exception.Message
                }
                $standaloneCall = "$($row.name) - To Execute Manually:`r`n $visualLine $call $visualLine`r`n"
                $syncHash.log += $standaloneCall

                ### Want to output it succeeded if no errors in message
                if($message.count -eq 0){
                    $text = "$($row.name):$($message.count) -- Script Succeeded!`r`n"
                }else{
                    $text = "$($row.name):ErrorCount $($message.count): Error Message: -- $message`r`n"
                }

                $syncHash.log += $text
                $syncHash.Window.Dispatcher.invoke(
                    [action]{$logTextBox.text = $syncHash.log}) 
            }
            $error.clear()
            ###### Setting Error Info in the table, $error is returned as an array for sql scripts atleast so the count should be zero if no error occured.
            [String]$AllErrorMessages = ''
            if($message.Count -eq 0 -and $messages.count -eq 0)
            {
                $errored = 0
                ## Set current row's style to green to show succeeded
                $syncHash.Window.Dispatcher.invoke(
                    [action]{$rowStyles.Background = '#FF33E292';$RowStyles.foreground = '#FF101011'}) 
            }
            ELSE
            {
                $errored = 1
                $i = 0
                #### Building a string out of the array of errors
                while($i -lt $message.count){
                [String]$AllErrorMessages += $message[$i].ToString()
                [String]$AllErrorMessages += $messages[$i].ToString()
                $i++
                }
                ## Set current row's style to red to indicate an error
                $syncHash.Window.Dispatcher.invoke(
                    [action]{$rowStyles.Background = '#FFEEA3A3';$RowStyles.foreground = '#FF101011'}) 
                ## Allowing the user to view details by clicking on a specific row since there was an error
                $syncHash.Window.Dispatcher.invoke(
                    [action]{$datagrid.RowDetailsVisibilityMode = 2})
            }

            #### setting the table values for the error message and errored for this row
                    $syncHash.Window.Dispatcher.invoke(
            [action]{$row.Errored =$errored; $row.HasRun = 1;$row.ErrorMessage =$AllErrorMessages})
            #$syncHash.Window.Dispatcher.invoke([action]{$logTextBox.SelectionColor ="Red"}, "Normal")
            #$syncHash.Window.Dispatcher.invoke([action]{$logTextBox.Text=$logTextBox..("COLORED:")}, "Normal")
            ### now I want to pause until user cancels or clicks continue if there was an error
            if($errored -eq 1) {
                $syncHash.Window.Dispatcher.invoke([action]{$run.Content = "Continue"; $run.IsEnabled = 1; $retry.isenabled = 1})
                While ($syncHash.continue -ne 1 -and $syncHash.Stop -ne 1 ) {
                    $syncHash.Window.Dispatcher.invoke([action]{$run.foreground = "Black"; $run.background = "#FFFFFFFF"})
                    Start-Sleep 1
                    $syncHash.Window.Dispatcher.invoke([action]{$run.foreground = "Black"; $run.background = "#FF41BF8B"})
                }
                $syncHash.Window.Dispatcher.invoke([action]{$run.Content = "Run"; $run.IsEnabled = 0; $run.background = "#FF41BF8B"; $run.foreground = "Black";$retry.isenabled = 0})
                $syncHash.continue = 0
            }
            ### if the retry button was clicked then set I back one and try that script again
             If($syncHash.retry -eq 1){
                
                $syncHash.Retry = 0
                continue
             }
            $x++
        }
        ##Allowing use of the run button again
    $syncHash.Window.Dispatcher.invoke([action]{$run.Content = "Run";$run.background = "#FF41BF8B"; $run.foreground = "Black";$retry.isenabled = 0})
    $syncHash.Window.Dispatcher.invoke([action]{$run.IsEnabled = 1;$edit.IsEnabled = 1;$reload.IsEnabled = 1;$Stop.IsEnabled = 0})
    $Runspace.Close() | Out-Null
    $Runspace.Dispose() | Out-Null
    }    

    ### creating and running the commands in the seperate runspace
    $PS = [powershell]::Create()
    $PSinstance = $ps.AddScript($Code)
    $PSinstance.Runspace = $Runspace
    $Handle = $PSinstance.BeginInvoke()
    
    if ($PSBoundParameters['Verbose'].IsPresent) {
        $pipeline.AddScript({ $VerbosePreference = "Continue" }, $false).Invoke()
        $pipeline.Commands.Clear()
    }
    
    #$syncHash.log = $Object
}


#### Check powershell version ###
IF ($PSVersionTable.PSVersion.Major -lt 4)
    {
        Add-PSSnapin SqlServerCmdletSnapin100 # here live Invoke-SqlCmd
        Add-PSSnapin SqlServerProviderSnapin100
    }
##################################################################################
#### %%%%%%%%%%%%%%%%%%%% Loading the Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%####
##################################################################################

### add the default database variables
Add-CustomVariable "Database"
if(Test-Path $synchash.CurrentRecipePath) 
{
    #$syncHash = Update-CurrentRecipe $synchash $synchash.CurrentRecipePath
    [System.Data.DataTable]$datagridItems = &$syncHash.Open_File $synchash
   $datagrid.ItemsSource = $datagriditems.Defaultview
}
<#
else{
    #$syncHash = Update-CurrentRecipe $synchash $synchash.CurrentRecipePath
    [System.Data.DataTable]$datagridItems = &$syncHash.File_Waiter $synchash.CurrentRecipeFolderPath $synchash $null
    $DataGrid.ItemsSource = $DatagridItems.Defaultview
    #$DataGrid.ItemsSource = (&"$($syncHash.RootDirectory)\config\Scripts\Get_ScriptList.ps1" -ScriptFolder $synchash.CurrentRecipeFolderPath -currentDirectory $synchash.CurrentRecipeFolderPath).Defaultview
}
#>

$DataGrid.RowDetailsVisibilityMode = 0
############## loading the treeview
Function Add-TreeItem{
    Param(
          $item,
          $Parent,
          $Tag
          )

    #Add new TreeViewItem
    [System.Windows.Controls.TreeViewItem]$ChildItem = New-Object System.Windows.Controls.TreeViewItem
    $ChildItem.Header = $item.name
    $ConvertedBaseName = $item.baseName.replace(" ","_").replace("-","hyphen").replace(".","dot").replace("(","lparen").replace(")","rparen")
    try{
        $ChildItem.Name = $ConvertedBaseName
    }catch{
        Write-host "Cookbooks Treeview Doesn't Like[$ConvertedBaseName] as a treeview Name" -ForegroundColor Yellow
    }
    $ChildItem.Tag = $item.fullname
    $childitem.Foreground="#FFB3B3B3"
    [Void]$Parent.Items.Add($ChildItem)



    if ( $item -is [System.IO.DirectoryInfo] ) {
        $FSObjSub = $item |
                Get-ChildItem -include @("*.xml", "*.recipe", "*.order") <#-Directory<##> -ErrorAction SilentlyContinue
        foreach ( $FSObj in $FSObjSub ) {
            Add-TreeItem $FSObj $ChildItem $item.name
        }
    }
}

#### add the roots.
$cookbooks = Get-ChildItem  $syncHash.CookBooks 
foreach($item in $cookbooks)
{

    Add-TreeItem -item $item -Parent $Treeview_Cookbooks -Tag "cookbooks"
}
$kitchens = Get-ChildItem  $syncHash.kitchens
foreach($item in $kitchens)
{

    Add-TreeItem -item $item -Parent $Treeview_Kitchens -Tag "kitchens"
}
#### adding messages to datagrid
foreach($row in $datagrid.items){
    if($row.Warnings -ne ""){
        ##getting the current rows index and styling properties
        $index = $datagrid.items.indexof($row)
        $RowStyles = $datagrid.ItemContainerGenerator.ContainerFromIndex($index)

        ## Set current row's style to red to indicate an error
        <#
            $syncHash.Window.Dispatcher.invoke(
                [action]{$rowStyles.Background = '#FFEEA3A3';$RowStyles.foreground = '#FF101011'}) 
        #>

        ## Allowing the user to view details by clicking on a specific row since there was an error
        $syncHash.Window.Dispatcher.invoke(
            [action]{$datagrid.RowDetailsVisibilityMode = 2})

        $syncHash.Window.Dispatcher.invoke(
            [action]{$row.ErrorMessage =$row.Warnings})
    }
}


$DataGrid.Selecteditem = $null

##################################################################################
#### %%%%%%%%%%%%%%%%%%%% Loading the Environment Settings %%%%%%%%%%%%%%%%%%%####
##################################################################################
$TextBlock_ServerName.text = $env:COMPUTERNAME
#$TextBlock_RecipeName.Text = $syncHash.RecipeName
##################################################################################
#### %%%%%%%%%%%%%%%%%%%% Log View Testing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##
##################################################################################

##################################################################################
#### %%%%%%%%%%%%%%%%%%%% Event Handlers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%####
##################################################################################
#####################################################
# &&&&&&&&&&&&&& File Menu Items &&&&&&&&&&&&&&&&&& #
#####################################################
### add new recipe button
$Button_New.add_Click({

    $ConfigFileName = Split-path $synchash.CurrentRecipePath -leaf
    $save = get-SaveFile  $synchash.CurrentRecipeFolderPath $ConfigFileName
    $savePath = $save.FileName.ToString()
    if($savePath){
        ## remove current variables
        foreach($obj in $Grid_Variables.Children | Where-Object {$_.name -like 'c_DockPanel_*'}) 
        {
            $null =  $grid_variables.Children.remove($obj)
        }
        ### remove current grid
        remove-variable datagriditems -ErrorAction SilentlyContinue
        ## Add default variable of database to new recipe
        Add-CustomVariable "Database"
        $Custom_parameters = get-customVariables
        ## update current recipe and save this one.
        $syncHash = Update-CurrentRecipe $synchash $SavePath
        & $syncHash.Save_Recipe $synchash $null $Custom_parameters
        
        ### updating the users config
        &"$($syncHash.RootDirectory)\config\Scripts\Create_User_Settings_XML.ps1" -Path $userConfig -LastRecipe $SavePath -currentDirectory $($syncHash.RootDirectory)    

        ### reload grid from config
        [System.Data.DataTable]$datagridItems = &$syncHash.Open_File $synchash
        $datagrid.ItemsSource = $datagriditems.Defaultview
    }
})

$Button_Open.add_Click({
    $xmlPath = &$syncHash.Get_OpenFile  $synchash.CurrentRecipeFolderPath  

    if($xmlPath) 
    {
    
        $syncHash = Update-CurrentRecipe $synchash $xmlPath
        [System.Data.DataTable]$datagridItems = &$syncHash.Open_File $synchash
        $datagrid.ItemsSource = $datagriditems.Defaultview
    
    }
})
###### Save Button
$Button_Save.add_Click({
    write-host $synchash.CurrentRecipePath
if((Test-Path $synchash.CurrentRecipePath) -And $synchash.CurrentRecipeName -ne $tempRecipeName){
    $SavePath = $synchash.CurrentRecipePath
}
else{
    $ConfigFileName = Split-path $synchash.CurrentRecipePath -leaf
    $save = get-SaveFile  $synchash.CurrentRecipeFolderPath $ConfigFileName
    if($save[0] -eq 'Cancel'){
        $savePath = $null
    }else {
        $savePath = $save.FileName.ToString()
    }
    
}
    Write-host $savePath
    if($SavePath){

        Write-host $TextBoxHelp.text
        # get custom variables
        $Custom_parameters = get-customVariables
        $syncHash = Update-CurrentRecipe $synchash $SavePath

        [System.Data.DataTable]$datagridItems = $datagrid.itemssource.ToTable()
        & $syncHash.Save_Recipe $synchash $datagridItems $Custom_parameters $TextBoxHelp.text
        ### updating the users config
        &"$($syncHash.RootDirectory)\config\Scripts\Create_User_Settings_XML.ps1" -Path $userConfig -LastRecipe $SavePath -currentDirectory $syncHash.RootDirectory  
    }
    })
###### Save as Button
$Button_Save_As.add_Click({

$ConfigFileName = Split-path $synchash.CurrentRecipePath -leaf
$save = get-SaveFile  $synchash.CurrentRecipeFolderPath $ConfigFileName
$savePath = $save.FileName.ToString()
if($savePath){
    [System.Data.DataTable]$datagridItems = $datagrid.itemssource.ToTable()
    $Custom_parameters = get-customVariables
    $syncHash = Update-CurrentRecipe $synchash $SavePath
    & $syncHash.Save_Recipe $synchash $datagridItems $Custom_parameters $TextBoxHelp.text
    
    ### updating the users config
    &"$($syncHash.RootDirectory)\config\Scripts\Create_User_Settings_XML.ps1" -Path $userConfig -LastRecipe $SavePath -currentDirectory $($syncHash.RootDirectory)    
}
})

###### Add Files Button
$Button_AddFiles.add_Click({
    
    $files = Get-AddFile($synchash.CurrentRecipePath)
    [System.Data.DataTable]$datagridItems = $datagrid.itemssource.ToTable()
    [System.Data.DataTable]$datagridItems = &$syncHash.File_Waiter $files $synchash $datagridItems
    
    $datagrid.ItemsSource = $datagriditems.Defaultview
})

###### During Run Buttons
$Button_Retry.add_Click({
    $DataGrid.Selecteditem = $null
    $syncHash.retry = 1
    $syncHash.continue = 1
})

$Button_Stop.add_Click({

    Write-host "Stop Button Pushed"
    $DataGrid.Selecteditem = $null
    $syncHash.Stop = 1
    #$syncHash.Window.Dispatcher.invoke([action]{$run.IsEnabled = 1;$edit.IsEnabled = 1;$reload.IsEnabled = 1})
    #$syncHash.Window.Dispatcher.invoke([action]{$run.Content = "Run"; $run.IsEnabled = 0; $run.background = "#FF41BF8B"; $run.foreground = "Black";$retry.isenabled = 0;$Stop.isenabled = 0})
    #$syncHash.continue = 0
    #$Runspace.Close() | Out-Null
    #$Runspace.Dispose() | Out-Null
})

#####################################################
# &&&&&&&&&&&&&& Settings Tab Items &&&&&&&&&&&&&&& #
#####################################################
$Button_Add_Variable.add_Click({
    Add-CustomVariable $TextBox_Add_Variable_Name.Text
    $TextBox_Add_Variable_Name.Text = ""
 })
### adding key binding
 $TextBox_Add_Variable_Name.add_KeyDown{
    param
    (
      [Parameter(Mandatory)][Object]$sender,
      [Parameter(Mandatory)][Windows.Input.KeyEventArgs]$e
    )
    
    if($e.Key -eq 'Enter')
    {
        Add-CustomVariable $TextBox_Add_Variable_Name.Text
        $TextBox_Add_Variable_Name.Text = ""
    }
}
#####################################################
# &&&&&&&&&&&&&& Execute Buttons &&&&&&&&&&&&&&&&&& #
#####################################################
$Button_Run.add_Click({
    $DataGrid.Selecteditem = $null
    if($button_Run.Content -eq "Run")
    {
    ## Executes the function that creates a runspace and runs all the scripts in the designated folders
    exec_Scripts
    }
    elseIf($button_Run.Content -eq "Continue")
    {
        $syncHash.continue = 1
    }

})

#####################################################
# &&&&&&&&&&&&&& CookBook Items &&&&&&&&&&&&&&&&&& #
#####################################################

$treeview_cookbooks.Add_DragOver({
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
    $_.Effects = [System.Windows.DragDropEffects]::Copy
    #Write-host "is a drop"
    }
    #Write-host "not a drop"
})



    $Button_Add_Recipe.add_click({
        Write-host $Treeview_Cookbooks.SelectedItem.Tag
        $files = $Treeview_Cookbooks.SelectedItem.Tag
        [System.Data.DataTable]$datagridItems = $datagrid.itemssource.ToTable()
        [System.Data.DataTable]$datagridItems = &$syncHash.File_Waiter $files $synchash $datagridItems
        $datagrid.ItemsSource = $datagriditems.Defaultview
    })
    #####################################################
# &&&&&&&&&&&&&& Kitchen Items &&&&&&&&&&&&&&&&&& #
#####################################################

$Treeview_Kitchens.Add_DragOver({
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
    $_.Effects = [System.Windows.DragDropEffects]::Copy
    #Write-host "is a drop"
    }
    #Write-host "not a drop"
})



    $Button_Add_Recipe_Kitchen.add_click({
        Write-host $Treeview_Kitchens.SelectedItem.Tag
        $files = $Treeview_Kitchens.SelectedItem.Tag
        [System.Data.DataTable]$datagridItems = $datagrid.itemssource.ToTable()
        [System.Data.DataTable]$datagridItems = &$syncHash.File_Waiter $files $synchash $datagridItems
        $datagrid.ItemsSource = $datagriditems.Defaultview
    })

#####################################################
# &&&&&&&&&&&&&& Edit Grid Tab Items &&&&&&&&&&&&&& #
#####################################################
$Button_Reload.add_Click({
   
   ## re-runs the command to populate the $datagrid.  
   ## Can be useful to clear coloring, and view new files added to the folders.
   #$ScriptFolder = $ScriptsFolder.Text
       
    if($synchash.CurrentRecipePath) 
    {

        [System.Data.DataTable]$datagridItems = &$syncHash.Open_File $synchash
        $datagrid.ItemsSource = $datagriditems.Defaultview
        

   }else{
    Write-host "else"    
    $datagridItems = &"$($syncHash.RootDirectory)\config\Scripts\Get_ScriptList.ps1" -ScriptFolder $synchash.CurrentRecipeFolderPath -currentDirectory $syncHash.RootDirectory
        $DataGrid.ItemsSource = $datagridItems.Defaultview
   }
   $DataGrid.RowDetailsVisibilityMode = 0

})

$Button_Edit.add_Click({

    ###Toggle button to enable or disable editing of cells.
    if($DataGrid.IsReadOnly -eq 1)
    {
        
        $DataGrid.IsReadOnly = 0
        $Button_Edit.Foreground = "#FF101119"
        $DataGrid.RowDetailsVisibilityMode = 0
        
    }
    ELSEif($DataGrid.IsReadOnly -eq 0)
    {
        
        $DataGrid.IsReadOnly = 1
        $Button_Edit.Foreground="#FFEEE4E4"
        $DataGrid.RowDetailsVisibilityMode = 2
    }
})

############## Controls for sorting the datagrid #############
$button_MoveUp.add_Click({

    if($datagrid.SelectedItems){
        $min = ($datagrid.SelectedItems | measure-object -Property RunOrder -Minimum).Minimum
        $max = ($datagrid.SelectedItems | measure-object -Property RunOrder -maximum).maximum

        ##don't let the run order go negative
        if($min -gt 1){
            

            ### next find the row that is right above these rows, and make it have the run order of the last row
            $moveThisItem = $datagrid.Items  | ? { $_.RunOrder -eq ($min -1)}
                if($moveThisItem){
                    $moveThisItem.runorder = $max
                }
            ### now updating each selected row's run order to be one above what it was
            foreach($item in $datagrid.SelectedItems){
                $item.RunOrder = $item.Runorder -1
            }
        }
    }
})


$button_MoveDown.add_Click({

    if($datagrid.SelectedItems){
        $min = ($datagrid.SelectedItems | measure-object -Property RunOrder -Minimum).Minimum
        $max = ($datagrid.SelectedItems | measure-object -Property RunOrder -maximum).maximum

        ##don't let the run order go higher than there are items
        if($max -lt $datagrid.items.Count){
            
            ### next find the row that is right above these rows, and make it have the run order of the last row
            $moveThisItem = $datagrid.Items  | ? { $_.RunOrder -eq ($max +1)}
            if($moveThisItem){
                $moveThisItem.runorder = $min
                }
            ### now updating each selected row's run order to be one above what it was
            foreach($item in $datagrid.SelectedItems){
                $item.RunOrder = $item.Runorder +1
            }
        }
    }
})

### Move top

## for this one I will need to move all of the selected items to run order 1, descending and move all items that are above them, to a place below them.

$button_MoveTop.add_Click({
    if($datagrid.SelectedItems){
        ### need the max and min to figure out how to iterate through.
        $min = ($datagrid.SelectedItems | measure-object -Property RunOrder -Minimum).Minimum
        $max = ($datagrid.SelectedItems | measure-object -Property RunOrder -maximum).maximum
        ### we need this many slots on the top
        $count = $datagrid.SelectedItems.Count

        ### First move everything above the min value for the group
        $i = $min - 1
        While($i -ge 1){
            $moveThisItem = $datagrid.Items  | ? { $_.RunOrder -eq ($i)}
            if($moveThisItem){
                $moveThisItem.runorder = $i + $count
                $i = $i - 1
                }
        }


        ### Now move all the selected items to the top
        $i = $min
        $y = 1
        while($i -le $max){
            $moveThisItem = $datagrid.SelectedItems  | ? { $_.RunOrder -eq ($i)}
            $moveThisItem.runorder = $y
            $y++
            $i++
        }
    }
})

#### need to move all the items selected to the bottom
$button_MoveBottom.add_Click({
    if($datagrid.SelectedItems){
        ### need the max and min to figure out how to iterate through.
        $min = ($datagrid.SelectedItems | measure-object -Property RunOrder -Minimum).Minimum
        $max = ($datagrid.SelectedItems | measure-object -Property RunOrder -maximum).maximum
        ### we need this many slots needed at the bottom
        $count = $datagrid.SelectedItems.Count
        if($max -lt $datagrid.items.count){
            ### First move everything below the max value for the group
            $i = $max + 1
            While($i -le $datagrid.Items.count){
                $moveThisItem = $datagrid.Items  | ? { $_.RunOrder -eq ($i)}
                $moveThisItem.runorder = $i - $count
                $i = $i + 1
            }


            ### Now move all the selected items to the bottom
            $i = $max
            $y = $datagrid.items.count
            while($i -ge $min){
                $moveThisItem = $datagrid.SelectedItems  | ? { $_.RunOrder -eq ($i)}
                $moveThisItem.runorder = $y
                $y = $y - 1
                $i = $i - 1
            }
        }
    }
})

### check or uncheck selected grid items
$Button_CheckSelected.add_click({
    if($datagrid.SelectedItems){
        if($datagrid.SelectedItems[0].ToRun -eq $false){
            foreach($item in $datagrid.SelectedItems){
                $item.toRun = $true
            }
        }else{
            foreach($item in $datagrid.SelectedItems){
                $item.toRun = $false
            }
        }
    }
})

### remove rows
$Button_Remove_Rows.add_click({
    $RowsToRemove = New-Object system.Data.DataTable 
    foreach($row in $datagrid.SelectedItems){
        $RowsToRemove += $row
    }
            
    foreach($row in $rowsToremove){
        $datagrid.itemsSource.remove($row)
    }
    $i = 1
    foreach($row in $datagrid.items){
        $row.RunOrder = $i
        $i++
    }
})

$Button_Renumber_Rows.add_click({
    $i = 1
    foreach($row in $datagrid.items){
        $row.RunOrder = $i
        $i++
    }
})

### adding drag and drop from file explorer
$datagrid.add_Drop({
    ### type [System.Windows.Forms.DragEventHandler]
    #Event Argument: $_ = [System.Windows.Forms.DragEventArgs]
    #$bmp = $_.Data.GetData('Bitmap')
    #$pictureBox2.Image = $bmp
    ### getting the dropped data
    [System.Windows.DragEventArgs]$dropped = $_
    [array]$files  = $dropped.Data.GetData('FileDrop')
    [System.Data.DataTable]$datagridItems = $datagrid.itemssource.ToTable()
    [System.Data.DataTable]$datagridItems = &$syncHash.File_Waiter $files $synchash $datagridItems
    $datagrid.ItemsSource = $datagriditems.Defaultview
})

$datagrid.add_DragEnter({
    #Event Argument: $_ = [System.Windows.Forms.DragEventArgs]
#        if ($_.Data.GetDataPresent('Bitmap')) {
        $_.Effects = [System.Windows.Forms.DragDropEffects]::Copy
#       }
})
### End drag and drop from file explorer

$CollapseRight.add_click({
    if($CollapseRight.IsChecked -eq $true){
        $CollapseRight.IsChecked = $true
        $syncHash.Window.Dispatcher.invoke(  #this command pushes info to the UI.  so anything that should be updated in the UI while this is running needs to go through the synchash invoke command as an action.
        [action]{$ExpanderRight.IsExpanded = $true })

        
    }else{
        $CollapseRight.IsChecked = $false
        $syncHash.Window.Dispatcher.invoke(  #this command pushes info to the UI.  so anything that should be updated in the UI while this is running needs to go through the synchash invoke command as an action.
        [action]{$ExpanderRight.IsExpanded = $false })
        
    }
})

$CollapseLeft.add_click({
    if($CollapseLeft.IsChecked -eq $true){
        $CollapseLeft.IsChecked = $true
        $syncHash.Window.Dispatcher.invoke(  #this command pushes info to the UI.  so anything that should be updated in the UI while this is running needs to go through the synchash invoke command as an action.
        [action]{$ExpanderLeft.IsExpanded = $true })

        
    }else{
        $CollapseLeft.IsChecked = $false
        $syncHash.Window.Dispatcher.invoke(  #this command pushes info to the UI.  so anything that should be updated in the UI while this is running needs to go through the synchash invoke command as an action.
        [action]{$ExpanderLeft.IsExpanded = $false })
        
    }
})


#################### Global ####################################

#### code to make it so when the mouse clicks outside the datagrid no row is selected
$syncHash.window.Add_MouseDown({
    $DataGrid.Selecteditem = $null
})

## TODO: Add event to handle stuff when window closes
<#
$Window.Add_Closed({
    Write-Verbose "Performing cleanup"
})
#>
$syncHash.window.add_KeyDown{
    param
    (
      [Parameter(Mandatory)][Object]$sender,
      [Parameter(Mandatory)][Windows.Input.KeyEventArgs]$e
    )
    
    if($e.Key -eq 'Enter' -and $e.Key -eq 'Control' )
    {
        Write-host "Enter key pressed"
        Add-CustomVariable $TextBox_Add_Variable_Name.Text
        $TextBox_Add_Variable_Name.Text = ""
    }
    $e
}

#################### TESTING ##########################


########################################################################
##Launch the window
$syncHash.Window.ShowDialog()| out-null
