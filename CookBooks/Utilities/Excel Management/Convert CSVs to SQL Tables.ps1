param($variables)
cd c:

function Scrub-WorksheetName ($fileName) {
    $scrubName = $fileName -replace '\$', ""
    $scrubName = $scrubName -replace ' ', ""
    $scrubName = $scrubName -replace "'", ""
    $scrubName = $scrubName -replace '"', ""
    $scrubName = $scrubName -replace ".csv", ""
    $scrubName = "$scrubName.csv"
    return $scrubName
}

$schema = $variables.Schema
if($schema -eq 'SPEC'){
    $prefix = 'SPEC.SPEC_'
}
else{
    $prefix = "$schema."
}

$currentDirectory = $variables.CurrentKitchen
$excelBookFolder = $variables.ExelBookFolder
$databases = ($variables.Database).split(',')
$csvFolder = Get-ChildItem $excelBookFolder -Recurse -Directory -Filter "*CSVs"
$FolderBrowser =  $csvFolder.FullName
$insertSQLScript = Join-path  $FolderBrowser "\spec_insert_script.sql"

$worksheets = ($variables.WorksheetNames).split(',') #| Scrub-WorksheetName
$csvNames = @()
foreach ($worksheet in $worksheets) {
    $csvNames += Scrub-WorksheetName $worksheet
}


$files = Get-ChildItem $FolderBrowser -Filter "*.csv" |Where-Object {$_.name -in $csvNames}

###############################################################################################
#$f = Import-Csv C:\Users\jgroen\Documents\HuronSync\MHS\SpecOutput\TRAC_FunctionalSpecifications_Orig\Shared_Major_Patient_Types.csv
 $z = ''
    $a = @()
    $drops = @()
$tableName =''
$fileName=''
forEach ($csvFile in $files)
{
    $f = Import-Csv $csvFile.FullName
    if ($csvFile.Name -match '\d\d-.*')
    {
        $fileName=($csvFile.Name).Substring(3,($csvFile.Name).Length -3)
    }
    else
    {
    $fileName=$csvFile.Name
    }
    switch($fileName)
    {
     "Responsibilities_&_Areas.csv"{$fileName="Responsibilities.csv"}
     "Payer_Groups_And_Types.csv"{$fileName="Payer_Groups.csv"}
     "Major_and_Minor_TCodes.csv"{$fileName="Minor_Transaction_Codes.csv"}
     "Major_and_Minor_Denial_Codes.csv"{$fileName="Minor_Denial_Codes.csv"}
    }
    $tableName=$prefix+($fileName).Substring(0,($fileName).Length -4)
    $drops += "IF OBJECT_ID('$tableName') IS NOT NULL DROP TABLE $tableName"
$a += "CREATE TABLE $tableName ("
    
    $headers = $f | Get-Member -MemberType "NoteProperty"
    $headCount = $headers.Count-1 

$headersTop = $headers| Select-object  -First $headCount 
$headerBottom = $headers| Select-object -last 1



        #making the Create table variables
        foreach ($header in $headersTop)
        {
            ###Filtering out special characters from the table name (based on worksheet name)
        
            if($header.name -like '*value*')
            {
                $string = "[" + $header.Name + "] VARCHAR(MAX) NULL,"
                $a += $string
            }
            ELSE
            {
                $string = "[" + $header.Name + "] VARCHAR(MAX) NULL,"
                $a += $string
            }
        }

        ## Making last create thing
        if($headerBottom.name -like '*value*')
        {
            $string = "[" + $headerBottom.Name + "] VARCHAR(MAX) NULL"
            $a += $string
        }
        ELSE
        {
            $string = "[" + $headerBottom.Name + "] VARCHAR(MAX) NULL"
            $a += $string
        }
        $a += ")"
    








##### doing a per worksheet thing


########## sql will only insert 1000 rows.  Need to add a solution to do inserts in chunks if there are > 1000 rows. ##############

$i = 0
## top rows (including 0)
$RowsTop = if($f.Count){$f.Count}ELSE{0}




    While ($i -le $RowsTop)
    {
        ### my variable to count how many rows have been added to this insert statement
        $r = 0 

        ####### INSERT Section header####################################################################
        $a += "INSERT INTO $tableName ("


        #making the Create table variables
        foreach ($header in $headersTop)
        {
        $string = "[" + $header.Name + "],"
        $a += $string
        }

        ## Making last create thing
        $string = "[" + $headerBottom.Name + "]"
        $a += $string
        $a += ")"

        #### Actual Specs #################################################################################

            While ($i -le $RowsTop -and $r -lt 1000)  #added logic ($r less than 1000) to account for the 1000 row count max
                {
                    ### beggining setup
                    $string = 'SELECT '
                    ### Going through each row until right before the last one
                    $allnull = ""
                    foreach ($header in $headersTop)
                {

                    $value = $f[$i] |Select-object -Property $header.Name -ExpandProperty $header.Name
                    $value = $value -replace "'", ""
                    $allnull += $value
                    $string += "LTRIM(RTRIM('" + $value + "')),"
                }
                ## Making last create thing
                $value = $f[$i] |Select-object -Property $headerBottom.Name -ExpandProperty $headerBottom.Name
                $value = $value -replace "'", ""
                $string += "LTRIM(RTRIM('" + $value + "')) UNION"
                ## checking to see if all values are null or empty
                $allnull += $value
                if($allnull -ne "")
                {
                    $a += $string
                }
                    ### Row added
                    $i++
                    $r++
                   
            }

            ### Now gotta do the last row without Union

            
            ### setting up the beginning of the row
            $string = 'SELECT '
            ### getting the contents of the cells for the row based on i and sheet based on w.
            foreach ($header in $headersTop)
                {

                    $value = $f[$i] |Select-object -Property $header.Name -ExpandProperty $header.Name
                    $value = $value -replace "'", ""
                    $string += "'" + $value + "',"
                }
            ## setting up the last part where there shouldn't be a union
            $value = $f[$i] |Select-object -Property $headerBottom.Name -ExpandProperty $headerBottom.Name
            $value = $value -replace "'", ""
            $string += "'" + $value + "'"
            $a += $string
        ### last row of the current 1k rows or end of the worksheet.  incrimenting i if it is just the end of the current 1k rows we are looking at.
        $i++
        }
### Row added
$w++
    
}





$SQLText = @()
$SQLText += "IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = '$schema')
BEGIN
EXEC('CREATE SCHEMA $schema')
END"
$SQLText += '-- all the drops statements'
$SQLText += $drops
$SQLDropsonly = $SQLText |Out-String
$SQLText += '-- Now the inserts'
$SQLText += $a

#$SQLText hiding output
$SQLText > $insertSQLScript

IF ($PSVersionTable.PSVersion.Major -lt 4)
        {
            write-host "Installing PSSNapins for SQL Since powershell version is less than 4"
            Add-PSSnapin SqlServerCmdletSnapin100 # here live Invoke-SqlCmd
            Add-PSSnapin SqlServerProviderSnapin100
        }
        ELSE 
        {
            Write-host "Installing sqlps module since Powershell version is >= 4."
            Import-Module “sqlps” -DisableNameChecking
        }

## running the drops first, so compiler doesn't get mad.
forEach ($database in $databases){
Invoke-Sqlcmd -Query $SQLDropsonly  -ServerInstance 'localhost' -Database $database -QueryTimeout 99 # -ErrorVariable myerror1 | Out-Null
invoke-sqlcmd -InputFile $insertSQLScript  -serverinstance "localhost" -Database $database -QueryTimeout 99 # -ErrorVariable myerror2 | Out-Null
}

#return ,$myerror1,$myerror2