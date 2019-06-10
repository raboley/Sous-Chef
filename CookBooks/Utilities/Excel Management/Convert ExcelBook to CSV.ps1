param($variables)
# GET Excel Data without Excel  -  https://blogs.technet.microsoft.com/pstips/2014/06/02/get-excel-data-without-excel/#comment-1055
# Download ACE.OLEDB provider   -  https://www.microsoft.com/en-us/download/confirmation.aspx?id=13255

$excelBooks = @()
#$excelBooks=($substitutions.ExcelBookName).split(',')

### changing where the excel book should be based on one drive location.  TODO: update in environment settings
$currentDirectory = $variables.CurrentKitchen
$ExcelBookFolder = $variables.ExelBookFolder
$excelBookName = $variables.ExcelBookName

######################################################################
#Uncomment to Download File from SharePoint
<#$siteURL = "https://huroncg.sharepoint.com/sites/07645-002"
$sharePointFilePathURL ="shared documents/tool/specs/$excelBookName"

#Connect to sharepoint using custom app that was created to connect to this site (see Robbert vanAndel for more info)
connect-pnponline -Url $siteURL -AppId "004ccd9c-7e44-4ed1-8a65-086f62c4ac08" -AppSecret "OPDQDUc8EsvgZ1Ax3k6HeUEWef+khikZFjFy8TL4CyA=";

#retrieves file from sharepoint and downloads it to desired folder
#$file =get-pnpfile -url $sharePointFilePathURL #using site relative url instead of server relative

Try {
           $local_path = ($ExcelBookFolder +'\'+ $excelBookName )
           #test for the local file first and rename it
           if( Test-Path ( $local_path  ) -PathType Leaf ){
               Rename-Item $local_path ($local_path + '.old' )
           }

           #get the file
           get-pnpfile -Url $sharePointFilePathURL -path $ExcelBookFolder -FileName $excelBookName -AsFile

            #remove the old file
           if( Test-Path ( $local_path+'.old') -PathType Leaf ){

                Remove-Item ($local_path + '.old' )
           }
    }
    Catch {
           #handle error and continue
    }
 #>
 
 ##########################################################


<#
$currentDirectory = 'I:\DailyDataFiles\PIT_Tools\ht_souschef\Kitchen\RAB\Billing Module'
$ExcelBookFolder = 'C:\Users\rboley\Huron Consulting Group\RC Workflow - Ventura Documents'
$excelBookName = 'TRAC functional specifications Ventura.xlsx,RCPA Shared Specs Ventura.xlsx'
#>
function New-Folder($folder,$message)
{
if(!(Test-Path -Path $folder)) 
    {
        IF($message)
        {
       # Write-Host $message -ForegroundColor Green
        }
        ELSE
        {
        Write-Host "Created folder $folder" -ForegroundColor Green
        }
        
        New-Item $folder -Type Directory -force | Out-null 
    } 
}

$excelBooks = $excelBookName.split(',')
$CSVFolderPath = Join-Path $currentDirectory "Substitutions\CSVs"
foreach ($excelBookName in $excelBooks){

$excelFile = Get-ChildItem $ExcelBookFolder -Filter "*$excelBookName*" -Recurse
#### if there is no excel book then throw that can't find excel book
if(!($excelFile)){
    throw "Can't find excel book in ($ExcelBookFolder) name '$excelbookName'"
}

New-Folder $csvFolderPath

function Get-ExcelData ($path, $outputFolder) {

    $Provider = 'Microsoft.ACE.OLEDB.12.0'
    $ExtendedProperties = 'Excel 12.0;HDR=YES'
            
    # Build the connection string and connection object
    $ConnectionString = 'Provider={0};Data Source={1};Extended Properties="{2}"' -f $Provider, $Path, $ExtendedProperties
    $Connection = New-Object System.Data.OleDb.OleDbConnection $ConnectionString

    try {
        # Open the connection to the file, and fill the datatable
        $Connection.Open()
        $tables = $Connection.GetSchema("tables").TableName
        
            
        foreach ($table in $connection.GetSchema("tables")) {
            Write-Host $table.TABLE_NAME
            if($table.TABLE_NAME -notmatch '\$')
            {
                continue
            }
            $Query = 'SELECT * FROM [{0}]' -f $table.TABLE_NAME 
                
            $scrubName = $table.TABLE_NAME -replace '\$', ""
            $scrubName = $scrubName -replace ' ', ""
            $scrubName = $scrubName -replace "'", ""
            $scrubName = "$scrubName.csv"

            $Adapter = New-Object -TypeName System.Data.OleDb.OleDbDataAdapter $Query, $Connection
            $DataTable = New-Object System.Data.DataTable
            $Adapter.Fill($DataTable) | Out-Null

            $columnsToDelete = @()
            foreach ($column in $DataTable.Columns)
            {
                if(($column -match 'F[0-9].*') -or ($column -eq ''))
                {
                    $columnsToDelete += $column
                }
            }

            foreach ($column in $columnsToDelete)
            {
                $DataTable.Columns.Remove($column)
            }

            Write-Host "Datatable:$($scrubname) has:$($datatable.rows.Count) Rows"
            $newname = Join-Path $outputfolder $scrubName
            if($datatable.rows.Count -gt 1)
            {
                $DataTable | Export-csv -Path $newname -NoTypeInformation -Delimiter "," -force  
            }
        }
        #>

    }
    catch {
        # something went wrong 🙁
        Write-Error $_.Exception.Message
    }
    finally {
        # Close the connection
        if ($Connection.State -eq 'Open') {
            $Connection.Close()
        }
    }

    # Return the results as an array
    return ,$DataTable
}


$output = Get-ExcelData -Path $excelFile.FullName -OutputFolder $CSVFolderPath
}