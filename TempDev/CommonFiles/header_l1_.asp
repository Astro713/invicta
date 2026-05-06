<!--#include file="_config.asp" -->
<%
  bSecure = vbTrue
  If bSecure Then
    If Not(StrComp(Request.ServerVariables("HTTPS"),"on",1)=0) Then
      'For Each Item in Request.ServerVariables
      '  Response.Write Item & "=" & Request.ServerVariables(Item) & "<br />"
      'Next
      'Response.End
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

  strScript = Replace(Request.ServerVariables("SCRIPT_NAME"), "/TempDev/", "")

  Set oWinHttp = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
  oWinHttp.SetTimeouts 59000, 59000, 59000, 59000
  strMenuMakerPath = strBaseURLS
  If InStr(Request.ServerVariables("SCRIPT_NAME"), "TempDev")<>0 Then
    strMenuMakerPath = strMenuMakerPath & "TempDev/"
  End If
  oWinHttp.Open "GET", strMenuMakerPath & "CommonFiles/get_menu.php?d=2&f=" & Server.URLEncode(strScript)
  oWinHTTP.Send()
  strMenuText = oWinHTTP.ResponseText
  Set oWinHTTP = Nothing
  
%>

<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <title><%=strConferenceName%> || <%=strConferenceLocation%> || <%=strConferenceDate%></title>

    <link href="../css/bootstrap.min.css" rel="stylesheet">
    <link href="../css/bootstrap-icons.css" rel="stylesheet">
    <link href="../css/cms.css" rel="stylesheet">
    <link href="../css/other.css" rel="stylesheet">
    <script src="../js/jquery-3.6.3.min.js"></script>
    <script src="../js/bootstrap.bundle.min.js"></script>

    <link href="../css/<%=LCase(Replace(strShortConferenceName, " ", ""))%>.css" rel="stylesheet" type="text/css" />

<%=strHeaderExtras%>

  </head>

  <body class="" id="html-body">

  <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">

      <strong><a class="navbar-brand" href="../home.php"><%=strConferenceName%></a></strong>

      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse justify-content-stretch" id="navbarCollapse">
      <%= strMenuText %>
      </div>
    </div><!--./container-->
  </nav>

  <div class="container" id="main-content">
