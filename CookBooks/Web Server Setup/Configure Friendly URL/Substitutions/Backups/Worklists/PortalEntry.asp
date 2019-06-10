<%@  language="VBScript" %>
<% Option Explicit %>

<%
Dim oLogin
Dim cookie
Dim cookieKey 

Set oLogin = Server.CreateObject("SALogin_Bypass.clsSALogin_Bypass")

Session("Live.Portal") = "Server=MPVCHCADBP1.HCANALYTICS.COM;Database=Portal"
Session("Test.Portal") = "Server=.HCANALYTICS.COM;Database=Portal"
   
for each cookie in Request.Cookies
    Response.AddHeader "Set-Cookie", cookie & "=" & Request.Cookies(cookie) & "; path=/; Secure; HttpOnly"
next

Dim strRetValue

strRetValue = oLogin.LogUserOnToSystem(Request.QueryString("GUID"))

Session("PortalURLPrefix")="https://MPVCHCADBP1.HCANALYTICS.COM"

Set oLogin = Nothing

' Add an access datetime to Session for comparing against a user's password change date time
Session("WorklistLoginDt") = Now()

' The following connection strings must match the settings in the Portal's
' dataConfiguration.config

Response.Redirect(strRetValue & "?id=" & CDbl(Now()) * 86400000)
%>
