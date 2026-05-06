<%
  Response.Charset = "utf-8"
%>
<!--#include file="_config.asp" -->
<%
  bSecure = vbTrue
  If bSecure Then
    If Not(StrComp(Request.ServerVariables("HTTPS"),"on",1)=0) Then
      Dim strSecureURL
      strSecureURL = "https://"
      strSecureURL = strSecureURL & Request.ServerVariables("SERVER_NAME")
      strSecureURL = strSecureURL & Request.ServerVariables("URL")
      If Len(Request.ServerVariables("QUERY_STRING"))>0 Then
        strSecureURL = strSecureURL & "?" & Request.ServerVariables("QUERY_STRING")
      End If
      Response.Redirect strSecureURL
    End If
  End If

  strScript = Replace(Request.ServerVariables("SCRIPT_NAME"), "/TempDev", "")

  Set oWinHttp = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
  oWinHttp.SetTimeouts 59000, 59000, 59000, 59000
  strHeaderMakerPath = strBaseURLS
  If InStr(Request.ServerVariables("SCRIPT_NAME"), "TempDev")<>0 Then
    strHeaderMakerPath = strHeaderMakerPath & "TempDev/"
  End If
  strURL = strHeaderMakerPath & "CommonFiles/get_header.php?d=1&f=" & Server.URLEncode(strScript) & "&t=" & Server.URLEncode(strPageTitle)
  If Len(strHeaderExtras)>0 Then
    strURL = strURL & "&he=" & Server.URLEncode(Base64Encode(strHeaderExtras))
  End If
  oWinHttp.Open "GET", strURL
  oWinHTTP.Send()
  strHeaderText = oWinHTTP.ResponseText
  Set oWinHTTP = Nothing

  Response.Write strHeaderText
  
%>

   
