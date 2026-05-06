<%
strScript = Replace(Request.ServerVariables("SCRIPT_NAME"), "/TempDev", "")

Set oWinHttp = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
oWinHttp.SetTimeouts 59000, 59000, 59000, 59000
strFooterMakerPath = strBaseURLS
If InStr(Request.ServerVariables("SCRIPT_NAME"), "TempDev")<>0 Then
  strFooterMakerPath = strFooterMakerPath & "TempDev/"
End If
oWinHttp.Open "GET", strFooterMakerPath & "CommonFiles/get_footer.php?d=1&f=" & Server.URLEncode(strScript)
oWinHTTP.Send()
strFooterText = oWinHTTP.ResponseText
Set oWinHTTP = Nothing

Response.Write strFooterText


%>
