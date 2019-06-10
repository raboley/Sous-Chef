Param(  
[Parameter(Mandatory=$true)]  
[string]$sourcePath,  
[Parameter(Mandatory=$true)]  
[string]$destinationPath  
)  
  
  
$files = Get-ChildItem -Path $sourcePath -Recurse -Filter "*.*"  
  
foreach($file in $files){  
    $sourcePathFile = $file.FullName  
    $destinationPathFile = $file.FullName.Replace($sourcePath,  $destinationPath)  
  
    $exists = Test-Path $destinationPathFile  
  
    if(!$exists){  
        $dir = Split-Path -parent $destinationPathFile  
        if (!(Test-Path($dir))) { New-Item -ItemType directory -Path $dir }  
        Copy-Item -Path $sourcePathFile -Destination $destinationPathFile -Recurse -Force  
    }  
    else{  
        $isFile = Test-Path -Path $destinationPathFile -PathType Leaf  
         
        if($isFile){  
            $null = Compare-Object -ReferenceObject $(Get-Content $sourcePathFile) -DifferenceObject $(Get-Content $destinationPathFile)  
            if(Compare-Object -ReferenceObject $(Get-Content $sourcePathFile) -DifferenceObject $(Get-Content $destinationPathFile)){  
            $dir = Split-Path -parent $destinationPathFile  
            if (!(Test-Path($dir))) { New-Item -ItemType directory -Path $dir }  
  
                Copy-Item -Path $sourcePathFile -Destination $destinationPathFile -Recurse -Force  
            }  
        }  
    }  
}  