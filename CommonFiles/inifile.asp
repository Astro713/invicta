<%
Function SearchIncludePath(strSearchFileName)
  Dim FSO: Set FSO = Server.CreateObject("Scripting.FileSystemObject")
  Dim strScriptPath: strScriptPath = Request.ServerVariables("SCRIPT_NAME")
  Dim strScriptPathParent: strScriptPathParent = FSO.GetParentFolderName(strScriptPath)
  Dim strCurrPath
  If Len(strScriptPathParent)>0 Then
    strCurrPath = Server.MapPath(strScriptPathParent)
  Else
    strCurrPath = Server.MapPath("/")
  End If
  Dim bFound: bFound = vbFalse
  Dim intDepthMax: intDepthMax = 4
  While Not(bFound) And (intDepthMax>=0)
    intDepthMax = intDepthMax - 1
    'Response.Write " [" & strCurrPath & "/" & strSearchFileName & "] " & "<br/>"
    'Response.Write " [" & strCurrPath & "/" & "CommonFiles" & "/" & strSearchFileName & "] " & "<br/>"
    If FSO.FileExists(strCurrPath & "/" & strSearchFileName) Then
      'Response.Write "*"
      bFound = vbTrue
      SearchIncludePath = strCurrPath & "/" & strSearchFileName
    ElseIf FSO.FileExists(strCurrPath & "/" & "CommonFiles" & "/" & strSearchFileName) Then
      'Response.Write "*"
      bFound = vbTrue
      SearchIncludePath = strCurrPath & "/" & "CommonFiles" & "/" & strSearchFileName
    ElseIf FSO.FileExists(strCurrPath & "/" & "Common" & "/" & strSearchFileName) Then
      'Response.Write "*"
      bFound = vbTrue
      SearchIncludePath = strCurrPath & "/" & "Common" & "/" & strSearchFileName
    End If
    If Len(FSO.GetParentFolderName(strCurrPath))>0 Then
      strCurrPath = FSO.GetParentFolderName(strCurrPath)
    End If
  WEnd
  If Not(bFound) Then
    SearchIncludePath = ""
  End If
End Function


Set IniFileDictionary = CreateObject("Scripting.Dictionary")

Sub IniFileLoad(ByVal FilSpc)
  Dim aryBuf, j
  IniFileDictionary.RemoveAll
  FilSpc = lcase(FilSpc)
  if left(FilSpc, 1) = "p" then
    'Physical path
    PhyPth = mid(FilSpc, instr(FilSpc, "=") + 1)
  else
    'Virtual path
    PhyPth = Server.MapPath(mid(FilSpc, instr(FilSpc, "=") + 1))
  end if

  set FilSys = CreateObject("Scripting.FileSystemObject")
  set IniFil = FilSys.OpenTextFile(PhyPth, 1)
  do while not IniFil.AtEndOfStream
    StrBuf = IniFil.ReadLine
    if StrBuf <> "" then
      'There is data on this line
      if left(StrBuf, 1) <> ";" then
        'It's not a comment
        if left(StrBuf, 1) = "[" then
          'It's a section header
          HdrBuf = mid(StrBuf, 2, len(StrBuf) - 2)
        else
          'It's a value
          StrPtr = instr(StrBuf, "=")
          'Set aryBuf = RegExResults(strBuf, "(\w+)(\s*[= ]\s*)(?:"")(.*)(?:"")")
          'Set aryBuf = RegExResults(strBuf, "(\w+)[\s]*=[\s]*((?:[^""'\s]+)|'(?:[^']*)'|""(?:[^""]*)"")")
          'Set aryBuf = RegExResults(strBuf, "^\s?([^=]+)\s?=\s?(""([^""]*)""|\'([^\']*)\')\s?")
          Set aryBuf = RegExResults(strBuf, "(\w+)\s*=\s*(['""]?)((?:(?!\2)[^\\]|\\.|\w)+)\2")
          For j = 0 to aryBuf.Count-1
            'Response.Write "0=>" & aryBuf.Item(j).Submatches(0) & "<" & vbCrLf
            'Response.Write "1=>" & aryBuf.Item(j).Submatches(1) & "<"  & vbCrLf
            'Response.Write "2=>" & aryBuf.Item(j).Submatches(2) & "<"  & vbCrLf
            'Response.Write "3=>" & aryBuf.Item(j).Submatches(3) & vbCrLf
            AltBuf = lcase(HdrBuf & "|" & Trim(aryBuf.Item(j).SubMatches(0)))
            do while IniFileDictionary.Exists(AltBuf)
              AltBuf = AltBuf & "_"
            loop
            IniFileDictionary.Add AltBuf, aryBuf.Item(j).SubMatches(2)
          Next
        end if
      end if
    end if
  loop
  IniFil.Close
  set IniFil = nothing
  set FilSys = nothing
End Sub

Function IniFileValue(ByVal ValSpc)
  dim ifarray
  StrPtr = instr(ValSpc, "|")
  ValSpc = lcase(ValSpc)
  if StrPtr = 0 then
    'They want the whole section
    StrBuf = ""
    StrPtr = len(ValSpc) + 1
    ValSpc = ValSpc + "|"
    ifarray = IniFileDictionary.Keys
    for i = 0 to IniFileDictionary.Count - 1
      if left(ifarray(i), StrPtr) = ValSpc then
        'This is from the section
        if StrBuf <> "" then
          StrBuf = StrBuf & "~"
        end if
        StrBuf = StrBuf & ifarray(i) & "=" & IniFileDictionary(ifarray(i))
      end if
    next
  else
    'They want a specific value
    StrBuf = IniFileDictionary(ValSpc)
    'Response.Write ValSpc
  end if
  IniFileValue = StrBuf
End Function
%>
