<###param is a function that must go at the top of your script and captures any parameters passed in.
 an example of running this script to create the training files in a different place
 
 & '.\CopyPasteTraining.ps1' -path 'c:\Favorites'


 ='c:\' 
 gives it a default value
#>
param($substitutions)

$path = $substitutions.FolderPath


### this creates the $paths variable as an empty array.  
# Necessary for re-running this script multiple times
# OR for doing a foreach loop if there is only one item in the array
$Folderpaths = @()

$Folderpaths += Join-Path $path 'PowershellTraining'
$Folderpaths += Join-Path $path 'PowershellTraining\CopyPasteTraining\DeliverHere'
$Folderpaths += Join-Path $path 'PowershellTraining\CopyPasteTraining\RawFiles'
$Folderpaths += Join-Path $path 'PowershellTraining\PowershellScripts'

##### Create all the folders stored in the $paths array
foreach($Folderpath in $Folderpaths){
    
    ### new item commandlet takes two parameters
    # -path which is a filepath of type string
    # -ItemType which is a type of item to create
    New-Item -Path $Folderpath -ItemType directory
}

######### Create sample text files
$RawFilesPath = Join-Path $path 'PowershellTraining\CopyPasteTraining\RawFiles'
$powershellScriptPath = Join-Path $path 'PowershellTraining\PowershellScripts'
### Creates an array of hash tables
# allows you to store items with two properties use dot notation to reference those properties
# and iterate through them with a foreach loop
$files = @()
$files += @{ 
             Path = $rawFilesPath; 
             name = 'HospitalFile.txt';
             text = "HospitalFile with some data"
           }

$files += @{ 
             Path = $rawFilesPath; 
             name = 'ProfeeFile.txt';
             text = "ProfeeFile with some data"
           }

$files += @{ 
             Path = $rawFilesPath; 
             name = 'Visits.txt';
             text = "Visits File with some data"
           }
$files += @{ 
             Path = $powershellScriptPath; 
             name = 'CopyFilesAsARecipe.ps1';
             text = @'
             param($Substitutions)

$SourceFilePath = $Substitutions.SourceFolder
$destinationFolder = $Substitutions.destinationFolder

###########  Now copy and paste all the files in the folder ############
$AllOurFiles = Get-ChildItem $SourceFilePath

$destinationFolder = $destinationFolder

### file can be whatever you want
foreach($file in $AllOurFiles) {
    $destination = Join-Path $destinationFolder $file.Name

    Copy-Item -Path $file.FullName -Destination $destination
}
'@
           }



foreach($file in $files){
    New-Item -Path $file.Path -Name $file.name  -ItemType "file" -Value $file.text
}

