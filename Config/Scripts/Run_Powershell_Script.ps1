###########################################################################
###### 2 SQL Runner Section                                        ########
###########################################################################
#### Script built to run sql queries into specified db ####################
#### To use make folder structure                      ####################
#### Database\"DBName"\folderOrder\Scripts             ####################
#### Scripts should be named to run in alphanumeric asc####################
###########################################################################
param([int]$debug,[PSObject[]]$script)
## create results file
"{0}`t{1}`t{2}`t{3}`t{4}`t{5}" -f "Date","ServerName","Database","ScriptLocation","Status","Error"| Out-File "$currentDirectory\Results.txt" -force
############################## Starting the function #####################
#### Get the the list of scripts to be run in what order ###
############ Function to run sql scripts #######################
#This function will run all .sql scripts contained in the filepath specified to the db specified by the filepath ex scripts contained
#Within the reportingdw folder will run in the reportingDW database
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
$archiveDestination = $archiveDest
$server = 'localhost'

try {
    invoke-sqlcmd -InputFile $script.fullname -serverinstance $server -database $script.Database -ErrorVariable myerror |Out-null
} catch {
foreach($err in $error){Write-Host $err}
Write-Host $script.Name "Failed to run on" $script.Database  -ForegroundColor Red 
Write-host $myerror -ForegroundColor DarkMagenta
    "{0}`t{1}`t{2}`t{3}`t{4}`t{5}" -f $date,$server,$script.Database,$outputscriptname,"Failed",$myerror | Out-File "$currentDirectory\Results.txt" -Append

}
$sqlExitcode = $LASTEXITCODE

$outputscriptname = $script.PartPath 
$date = Get-Date -Format yyyy-MM-dd_HH_mm
cd "C:"
Write-Host  $script.Name "file run on "$script.Database -ForegroundColor Gray
##echo $script.partPath $myerror >> "$currentDirectory\Results.txt"
    
    
#Move the script to Archive if after it runs
<#
if(!(Test-Path -Path $archiveDestination)) 
{
Write-Host "Created New folder $date in folder Archive" -ForegroundColor Green; 
New-Item $archiveDestination -Type Directory | Out-null 
} 
    
if(!($myerror))
{
        
    if($debug -ne 1)
    {
    Move-Item -Path $script.FullName -Destination $archiveDestination\$out -Force
    }
ELSE 
    {
    Copy-Item -Path $script.FullName -Destination $archiveDestination\$out -Force
    }
#>
if(!($myerror)){
Write-Host $script.Name "Completed Successfully on " $script.Database  -ForegroundColor Green
    "{0}`t{1}`t{2}`t{3}`t{4}`t{5}" -f $date,$server,$script.Database,$outputscriptname,"succeeded","" | Out-File "$currentDirectory\Results.txt" -Append
}
ELSE
{
Write-Host $script.Name "Failed to run on" $script.Database -ForegroundColor Red 
    "{0}`t{1}`t{2}`t{3}`t{4}`t{5}" -f $date,$server,$script.Database,$outputscriptname,"Failed",$myerror | Out-File "$currentDirectory\Results.txt" -Append
}
return @(,$myerror)