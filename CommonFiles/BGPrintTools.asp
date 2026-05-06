<!--#include file="ChargeActive.prefs"-->
<%
Function PrintBG ( strPDFBuf, strPrintType, strJobName )
  Dim strPrinterTray, strPrinterPaperType, strTimeStamp, strFileName, strFileBasePath, FSO, oSocket, prps, prfile, WshShellObj, strMain, strPrefix
  strTimeStamp = DateOutput(Now(), "%Y%m%d%h%i%s")
  strFileBasePath = Server.MapPath("./tmp/")
  strFileName = strJobName & "_T" & strTimeStamp & ".pdf"

  Select Case strPrintType
    Case "Full"
      strPrinterTray = strPrinterTrayFull
      strPrinterTrayPS = strPrinterTrayFullPS
      strPrinterPaperType = strPrinterPaperTypeFull
      strPrinterPaperTypePS = strPrinterPaperTypeFullPS
    Case "NewTicketsHalf"
      strPrinterTray = strPrinterTrayHalf
      strPrinterTrayPS = strPrinterTrayHalfPS
      strPrinterPaperType = strPrinterPaperTypeHalf
      strPrinterPaperTypePS = strPrinterPaperTypeHalfPS
    Case "NewTicketsFull"
      strPrinterTray = strPrinterTrayFull
      strPrinterTrayPS = strPrinterTrayFullPS
      strPrinterPaperType = strPrinterPaperTypeFull
      strPrinterPaperTypePS = strPrinterPaperTypeFullPS
    Case "NewName"
      strPrinterTray = strPrinterTrayHalf
      strPrinterTrayPS = strPrinterTrayHalfPS
      strPrinterPaperType = strPrinterPaperTypeHalf
      strPrinterPaperTypePS = strPrinterPaperTypeHalfPS
    Case "Receipt"
      strPrinterTray = strPrinterTrayReceipt
      strPrinterTrayPS = strPrinterTrayReceiptPS
      strPrinterPaperType = strPrinterPaperTypeReceipt
      strPrinterPaperTypePS = strPrinterPaperTypeReceiptPS
    Case Else
      strPrinterTray = strPrinterTrayReceipt
      strPrinterTrayPS = strPrinterTrayReceiptPS
      strPrinterPaperType = strPrinterPaperTypeReceipt
      strPrinterPaperTypePS = strPrinterPaperTypeReceiptPS
  End Select


  If bDirectPDFPrint Then
    'Start Printer Direct Send
    strPJLCode = ""
    strPJLCodePost = ""
    strPJLCode = strPJLCode & "%-12345X@PJL" & vbCrLf
    'strPJLCode = strPJLCode & "@PJL JOB NAME = """ & strJobName & """ DISPLAY = """ & strJobName & """" & vbCrLf
    strPJLCode = strPJLCode & "@PJL JOB" & vbCrLf
    strPJLCode = strPJLCode & "@PJL SET MEDIATYPE = " & strPrinterPaperTypePS & "" & vbCrLf
    strPJLCode = strPJLCode & "@PJL SET SOURCETRAY = " & strPrinterTrayPS & "" & vbCrLf
    'strPJLCode = strPJLCode & "@PJL SET XPCLTRAYSWITCH = OFF" & vbCrLf
    'strPJLCode = strPJLCode & "@PJL SET XMEDIASOURCE = " & strPrinterTray & "" & vbCrLf
    'strPJLCode = strPJLCode & "@PJL SET XMEDIATYPE = " & strPrinterPaperType & "" & vbCrLf
    strPJLCode = strPJLCode & "@PJL ENTER LANGUAGE = PDF" & vbCrLf

    strPJLCodePost = strPJLCodePost & "%-12345X@PJL" & vbCrLf
    strPJLCodePost = strPJLCodePost & "@PJL RESET" & vbCrLf
    strPJLCodePost = strPJLCodePost & "@PJL EOJ NAME = """ & strJobName & """" & vbCrLf
    strPJLCodePost = strPJLCodePost & "%-12345X@PJL" & vbCrLf

    Response.ContentType="text/plain"

    If vbTrue Then
      Set oSocket = Server.CreateObject("Socket.TCP")
      oSocket.DoTelnetemulation = vbFalse
      osocket.Timeout = 1000
      oSocket.Host = strPrinterIP & ":" & intPrinterPort
      oSocket.Open
      'oSocket.SendLine("GET /" & vbCrLf)

      oSocket.SendText strPJLCode
      oSocket.SendText RSBinaryToString(strPDFBuf)
      oSocket.SendText strPJLCodePost

      oSocket.Close
    Else
      Response.Write RSBinaryToString(buf)
    End If
  Else
    'Send PS direct
    strPJLCode = ""
    strPJLCodePost = ""
    strPJLCode = strPJLCode & "%-12345X@PJL" & vbCrLf
    strPJLCode = strPJLCode & "@PJL JOB NAME = """ & "Badge-" & intRegistrantID & """ DISPLAY = """ & "Badge " & intRegistrantID & """" & vbCrLf
    'strPJLCode = strPJLCode & "@PJL SET PERSONALITY = POSTSCRIPT" & vbCrLf
    strPJLCode = strPJLCode & "@PJL SET MEDIATYPE = " & strPrinterPaperTypePS & "" & vbCrLf
    strPJLCode = strPJLCode & "@PJL SET SOURCETRAY = " & strPrinterTrayPS & "" & vbCrLf
    'strPJLCode = strPJLCode & "@PJL SET XPCLTRAYSWITCH = OFF" & vbCrLf
    'strPJLCode = strPJLCode & "@PJL SET XMEDIASOURCE = " & strPrinterTray & "" & vbCrLf
    'strPJLCode = strPJLCode & "@PJL SET XMEDIATYPE = " & strPrinterPaperType & "" & vbCrLf
    strPJLCode = strPJLCode & "@PJL ENTER LANGUAGE = POSTSCRIPT" & vbCrLf
    'strPJLCode = strPJLCode & "@PJL ENTER LANGUAGE = PCL" & vbCrLf
    'strPJLCode = strPJLCode & "@PJL ENTER LANGUAGE = PCLXL" & vbCrLf

    strPJLCodePost = strPJLCodePost & "%-12345X@PJL" & vbCrLf
    strPJLCodePost = strPJLCodePost & "@PJL RESET" & vbCrLf
    strPJLCodePost = strPJLCodePost & "@PJL EOJ NAME = """ & "Badge-" & intRegistrantID & """" & vbCrLf
    strPJLCodePost = strPJLCodePost & "%-12345X@PJL" & vbCrLf

    Set FSO = Server.CreateObject("Scripting.FileSystemObject")

    strFileName = strFileBasePath & "\" & strFileName

    Set prpdf = FSO.CreateTextFile(strFileName, vbTrue, vbTrue)
    prpdf.Write strPDFBuf
    prpdf.Close
    Set prpdf = Nothing
    Response.End

    Set WshShellObj = CreateObject("WScript.Shell")
    'Response.Write strFileBasePath & " "
    'Response.Write strFileName

    'WshShellObj.Run "C:\gs\gs9.21\bin\gswin64c.exe -dNOPAUSE -dBATCH -dQUIET -sDEVICE=djet500c -sOutputFile=" & strFileName & ".pcl" & " " & strFileName, 0, vbTrue
    'WshShellObj.Run "C:\gs\gs9.21\bin\gswin64c.exe -dNOPAUSE -dBATCH -dQUIET -sDEVICE=pxlcolor -sOutputFile=" & strFileName & ".pxl" & " " & strFileName, 0, vbTrue

    'WshShellObj.Run "C:\gs\gs9.21\bin\gswin64c.exe -dNOPAUSE -dBATCH -dQUIET -sDEVICE=ps2write -sOutputFile=" & strFileName & ".ps" & " " & strFileName, 0, vbTrue
    WshShellObj.Run "C:\gs\gs9.21\bin\gswin64c.exe -dNOPAUSE -dBATCH -dQUIET -sDEVICE=ps2write -sOutputFile=" & strFileName & ".ps" & " " & strFileName, 0, vbTrue

    'WshShellObj.Run "C:\bin\pdftops.exe -level3sep -q """ & strFileName & """ """ & strFileName & ".ps""", 0, vbTrue

    'WshShellObj.Run "C:\bin\mutool.exe draw -o """ & strFileName & ".ps"" """ & strFileName & """", 0, vbTrue
    'WshShellObj.Run "cmd", 0, vbTrue
    Set FSO = Server.CreateObject("Scripting.FileSystemObject")
    If FSO.FileExists(strFileName & ".ps") Then
      Set prfile = FSO.OpenTextFile(strFileName & ".ps", 1, vbFalse, 0)
      prps = prfile.ReadAll()
      prfile.Close
      Set prfile = Nothing

      'strPrefix = Left(prps, 500)
      'strMain = Right(prps,Len(prps)-500)
      '
      'i = 3
      'Do While i>0
      '  strPrefix = Right(strPrefix, Len(strPrefix)-InStr(strPrefix,Chr(10)))
      '  i=i-1
      'Loop

      'Response.Write strPrefix
      'Response.End

      'prps = strPrefix & strMain

      'If StrComp(strPrinterTrayPS, "null")=0 Then
      '  prps = Replace(prps, "%%BeginDefaults", "%%BeginDefaults" & vbCrLf & "<</MediaPosition " & strPrinterTrayPS & ">> setpagedevice" & vbCrLf & "<</TraySwitch false>> setpagedevice" & vbCrLf & "<</ManualFeed true>> setpagedevice" & vbCrLf & "<</MediaType (" & strPrinterPaperTypePS & ")>> setpagedevice" & vbCrLf & "<</PageSize [335 792]>> setpagedevice")
      'Else
      '  prps = Replace(prps, "%%BeginDefaults", "%%BeginDefaults" & vbCrLf & "<</MediaPosition " & strPrinterTrayPS & ">> setpagedevice" & vbCrLf & "<</TraySwitch false>> setpagedevice" & vbCrLf & "<</ManualFeed false>> setpagedevice" & vbCrLf & "<</MediaType (" & strPrinterPaperTypePS & ")>> setpagedevice")
      'End If

      If vbTrue Then
        Set oSocket = Server.CreateObject("Socket.TCP")
        oSocket.DoTelnetemulation = vbFalse
        osocket.Timeout = 1000
        oSocket.Host = strPrinterIP & ":" & intPrinterPort
        oSocket.Open

        oSocket.SendText strPJLCode

        'Response.write output
        'oSocket.SendText RSBinaryToString(buf)
        oSocket.SendText prps
        'oSocket.SendText strMain

        oSocket.SendText strPJLCodePost

        oSocket.Close
      Else
        Response.ContentType="text/plain"
        Response.Write prps
      End If

    Else
      Response.Write "FILE DOESN'T EXIST"
    End If
    Set WshShellObj = Nothing
    If FSO.FileExists(strFileName) Then
      'FSO.DeleteFile strFileName
    End If
    If FSO.FileExists(strFileName & ".ps") Then
      'FSO.DeleteFile strFileName & ".pcl"
    End If
    Set FSO = Nothing

  End If

End Function

Function RSBinaryToString(xBinary)
  'Antonin Foller, http://www.motobit.com
  'RSBinaryToString converts binary data (VT_UI1 | VT_ARRAY Or MultiByte string)
  'to a string (BSTR) using ADO recordset

  Dim Binary
  'MultiByte data must be converted To VT_UI1 | VT_ARRAY first.
  If vartype(xBinary)=8 Then Binary = MultiByteToBinary(xBinary) Else Binary = xBinary

  Dim RS, LBinary
  Const adLongVarChar = 201
  Set RS = CreateObject("ADODB.Recordset")
  LBinary = LenB(Binary)

  If LBinary>0 Then
    RS.Fields.Append "mBinary", adLongVarChar, LBinary
    RS.Open
    RS.AddNew
      RS("mBinary").AppendChunk Binary
    RS.Update
    RSBinaryToString = RS("mBinary")
  Else
    RSBinaryToString = ""
  End If
End Function

Function MultiByteToBinary(MultiByte)
  ' 2000 Antonin Foller, http://www.motobit.com
  ' MultiByteToBinary converts multibyte string To real binary data (VT_UI1 | VT_ARRAY)
  ' Using recordset
  Dim RS, LMultiByte, Binary
  Const adLongVarBinary = 205
  Set RS = CreateObject("ADODB.Recordset")
  LMultiByte = LenB(MultiByte)
  If LMultiByte>0 Then
    RS.Fields.Append "mBinary", adLongVarBinary, LMultiByte
    RS.Open
    RS.AddNew
      RS("mBinary").AppendChunk MultiByte & ChrB(0)
    RS.Update
    Binary = RS("mBinary").GetChunk(LMultiByte)
  End If
  MultiByteToBinary = Binary
End Function

%>
