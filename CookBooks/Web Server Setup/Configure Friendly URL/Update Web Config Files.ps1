param($Substitutions)
<#  Instructions to update the friendly URL manually.  If it still isn't working after this check to make sure these steps were completed. 
	1) Modify Portal.dbo.siMenuItems.ItemHyperlink to link out to the friendly URLs, not the server alias URLs.Example for NYCHH Manhattan:
		UPDATE simi
		SET ItemHyperlink = REPLACE(ItemHyperlink, 'mpnychh2tp1.hcanalytics', 'nychhmanhattan.huronconsultinggroup')
		-- SELECT REPLACE(ItemHyperlink, 'mpnychh2tp1.hcanalytics', 'nychhmanhattan.huronconsultinggroup')
		FROM dbo.siMenuItems AS simi
		WHERE PKMenuItems IN (36, 50, 51) -- New UI Financial Clearance, Follow-up, Billing
	2) Modify app-settings.json located at C:\Program Files\Huron Consulting Group\RCWorkflow\Huron.Worklists.UI
		a. Change webApiServer to appropriate friendly URL endpoint:Example for NYCHH Manhattan: "webApiServer": "nychhmanhattan.huronconsultinggroup.com\\Huron.Worklists.WebAPI",
		b. Ensure loginUrl is a relative URL: "loginUrl": "/WebUI/Security%20Pages/Login.aspx"
	3) Modify web.config located at C:\Program Files\Huron Consulting Group\RCWorkflow\Huron.Worklists.UI
		a. Change Access-Control-Allow-Origin to the fully qualified friendly URL, with no trailing slashExample for NYCHH Manhattan: <add name="Access-Control-Allow-Origin" value="https://nychhmanhattan.huronconsultinggroup.com" />
	4) Modify web.config located at C:\Program Files\Huron Consulting Group\RCWorkflow\Huron.Worklists.WebAPI
		a. Change Origins value to fully qualified friendly URL, with no trailing slashExample for NYCHH Manhattan: <add key="Origins" value="https://nychhmanhattan.huronconsultinggroup.com" />
		b. Change forms loginUrl to be a relative URLExample for NYCHH Manhattan: <forms name=".RCWPORTALLOGIN" loginUrl="/WebUI/Security%20Pages/Login.aspx" […etc…]
Also modify PortalEntry.asp file located at C:\Program Files\Huron Consulting Group\RCWorkflow\Worklists for the one link at the very bottom of the file
#>
$CurrentDirectory = $Substitutions.CurrentKitchen

######## hard Coded variables for friendly URL related config file paths
$configPaths = @()
$configPaths += "C:\Program Files\Huron Consulting Group\RCWorkflow\Huron.Worklists.UI\app-settings.json"
$configPaths += "C:\Program Files\Huron Consulting Group\RCWorkflow\Huron.Worklists.UI\web.config"
$configPaths += "C:\Program Files\Huron Consulting Group\RCWorkflow\Huron.Worklists.WebAPI\web.config"
$configPaths += "C:\Program Files\Huron Consulting Group\RCWorkflow\Worklists\PortalEntry.asp"

$Replaces = @()
## ORDER Matters! changing the login url to be relative has to be first, otherwise it will get altered to something else and will not match up
$Replaces += @{Find = "https://$($Substitutions.ServerNameURL)/WebUI/Security%20Pages/Login.aspx";Replace = "/WebUI/Security%20Pages/Login.aspx" }
$Replaces += @{Find = $Substitutions.ServerNameURL;Replace = $Substitutions.FriendlyURL }
$replaces += @{Find = "https://$($Substitutions.DBServerNameURL)";Replace = "https://$($Substitutions.FriendlyURL)" }

##### functions - String replacer to replace strings in target files
function StringReplacer ($file,$Find,$Replace)
{
    $text = [IO.File]::ReadAllText($file) -replace [regex]::Escape($Find), $Replace
[IO.File]::WriteAllText($file, $text)
}

###############################################################
######### MAIN ################################################
###############################################################

### Only do replaces if both variables are populated
if($Substitutions.ServerNameURL -and $Substitutions.FriendlyURL){

    foreach($path in $configPaths){
        foreach($Replace in $Replaces){
            StringReplacer -file $path -Find $Replace.Find -Replace $Replace.Replace
        }
    }
}else {
    ### if either variables are null this will trigger instead.  Don't want to update everything to friendly url, or the servername url to nothing.
   'Error, $ServerNameURL, or $FriendlyURL are null'
}