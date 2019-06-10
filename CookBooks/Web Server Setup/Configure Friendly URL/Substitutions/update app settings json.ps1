param($Substitutions)
if(!($Substitutions)){
    $Substitutions = @{ FriendlyURL = "vchcaworkflow.huronconsultinggroup.com";
        ServerNameURL = "MPVCHCAWEBP1.HCANALYTICS.COM";
        CurrentKitchen = "c:\users\rboley\desktop";
    }
}

$ConfigPathAppSettings = Get-ChildItem "C:\Program Files\Huron Consulting Group\RCWorkflow\Huron.Worklists.UI\app-settings.json"

$CurrentDirectory = $Substitutions.CurrentKitchen
$FriendlyURL = $Substitutions.FriendlyURL
$ServerNameURL = $Substitutions.ServerNameURL
if($FriendlyURL -and $ServerNameURL){

    $dest = Join-Path $CurrentDirectory $ConfigPathAppSettings.Name

    ############### UPDATING app-settings.json #############
    <# Manual instructions:
	    2) Modify app-settings.json located at C:\Program Files\Huron Consulting Group\RCWorkflow\Huron.Worklists.UI
		    a. Change webApiServer to appropriate friendly URL endpoint:Example for NYCHH Manhattan: "webApiServer": "nychhmanhattan.huronconsultinggroup.com\\Huron.Worklists.WebAPI",
		    b. Ensure loginUrl is a relative URL: "loginUrl": "/WebUI/Security%20Pages/Login.aspx"
    #>

    ### creating backup
    Copy-Item $ConfigPathAppSettings.FullName $dest

    ### storing the file as a powreshell object 
    $AppSettingsJSON = Get-Content -Raw -Path $ConfigPathAppSettings.FullName |ConvertFrom-Json

    #### step a. change the web url from servername url to use the friendly url
    $AppSettingsJSON.webApiServer = $AppSettingsJSON.webApiServer -replace $ServerNameURL,$FriendlyURL
    #### Step b. changing login URL to a relative URL
    $AppSettingsJSON.loginUrl = "/WebUI/Security%20Pages/Login.aspx"
    
    #### converting the powershell object back to JSON and actually updating the config file with new config.
    $appSettingsRAWJSON = ConvertTo-Json $AppSettingsJSON
    Set-content -Path $ConfigPathAppSettings.FullName -value $appSettingsRAWJSON

}else {
    ### if either variables are null this will trigger instead.  Don't want to update everything to friendly url, or the servername url to nothing.
    Write-Host 'Error, $ServerNameURL, or $FriendlyURL are null'
}