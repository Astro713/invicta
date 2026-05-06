<!--#include file="vbBarcode.asp"-->
<!--#include file="base64.vbs"-->
<!--#include file="encrypt.asp"-->
<% ' --------------------------------------------------------%>
<% ' --------------------------------------------------------%>
<% Private Sub GoRedirect%>
<HTML>
<META HTTP-EQUIV="refresh" content="0;URL=Login.asp">
<BODY>
</BODY>
</HTML>
<%End Sub%>


<% ' --------------------------------------------------------%>
<% ' --------------------------------------------------------%>
<% Private Function GoCheckFields (aryFieldCheckArray)
  For Each strFieldName IN aryFieldCheckArray
    If (Request.Form(strFieldName)= "" OR IsNull(Request.Form(strFieldName))) then
	  MissingField (strFieldName)
	  GoCheckFields = vbFalse
	  Session("StoreInfo") = "Blocked"
	  Exit Function
	End If
  Next
  GoCheckFields = vbTrue
End Function%>



<% ' --------------------------------------------------------%>
<% ' --------------------------------------------------------%>
<% Private Sub MissingField (strFieldName)%>
   <HTML><BODY>
   <FONT face="sans-serif">There is no data or invalid data entered for the field: <FONT color="red"><%=strFieldName%></FONT><BR>
   Please return to the previous page using the back button on your browser (refresh the page if your browser instructs you to).
   </FONT>
   </BODY></HTML>
<%
Session("Action") = "ViewOnly"
End Sub%>



<% ' --------------------------------------------------------%>
<% ' --------------------------------------------------------%>
<% Private Sub GoError (strModule, strType)
  Set cnnLogin = Server.CreateObject("ADODB.Connection")
  cnnLogin.Open "CAST2000", "CAST2000", "c4st2ooo"
  cnnLogin.Execute("INSERT INTO Errors (Date, Time, Message) VALUES (#" & Date & "#, #" & Time & "#, '" & strModule & "', '" & strType & "')")
  cnnLogin.Close
  Set cnnLogin = Nothing
%>
  <H2>An error in Module <%=strModule%> of type <%=strType%> has occurred.<BR>
  Exit
<%End Sub%>




<% ' -------------------------------------------- %>
<% ' -------------------------------------------- %>
<% Private Function EncodeString (TempStringIn)
   IF (IsNull(TempStringIn) OR TempStringIn = "") Then
     EncodeString = ""
	 Exit Function
   Elseif (IsNumeric(TempStringIn)) Then
     EncodeString = TempStringIn
	 Exit Function
   Else
'     TempString = Replace(TempString,"~!", " ~!")
'     TempString = Replace(TempString,"~",  "~tilde~")
'     TempString = Replace(TempString,"!",  "~excl~")
'     TempString = Replace(TempString,",",  "~comma~")
'     TempString = Replace(TempString,"@",  "~atsign~")
'     TempString = Replace(TempString,"#",  "~pound~")
'     TempString = Replace(TempString,"$",  "~dollar~")
'     TempString = Replace(TempString,"%",  "~percent~")
'     TempString = Replace(TempString,"^",  "~caret~")
'     TempString = Replace(TempString,"&",  "~amp~")
'     TempString = Replace(TempString,"*",  "~ast~")
'     TempString = Replace(TempString,"-",  "~minus~")
'     TempString = Replace(TempString,"=",  "~eq~")
'     TempString = Replace(TempString,"_",  "~us~")
'     TempString = Replace(TempString,"+",  "~plus~")
'     TempString = Replace(TempString,"\",  "~bslash~")
'     TempString = Replace(TempString,"/",  "~slash~")
'     TempString = Replace(TempString,"|",  "~pipe~")
'     TempString = Replace(TempString,":",  "~colon~")
'     TempString = Replace(TempString,";",  "~semicolon~")
'     TempString = Replace(TempString,vbNewLine, "~nl~")
'     TempString = Replace(TempString,vbCrLf, "~nl~")
'     TempString = Replace(TempString,vbCr, "~nl~")
'     TempString = Replace(TempString,vbLf, "~nl~")
'     TempString = Replace(TempString,">",  "~gt~")
'     TempString = Replace(TempString,"<",  "~lt~")
'     TempString = Replace(TempString,"`",  "~agu~")
     'TempString = Replace(TempString,"'",  "~sq~")
     TempString = Replace(TempStringIn,"'",  "''")
'     TempString = Replace(TempString,chr(34), "~dq~")
'     TempString = Replace(TempString,"?",  "~qm~")
'     TempString = Replace(TempString,vbTab,"~tab~")
     EncodeString = TempString
   End If
End Function%>


<% ' -------------------------------------------- %>
<% ' -------------------------------------------- %>
<% Private Function DecodeString (TempStringIn)
   IF (IsNull(TempStringIn) OR TempStringIn = "") Then
     DecodeString = ""
	 Exit Function
   Elseif (IsNumeric(TempStringIn)) Then
     DecodeString = TempStringIn
	 Exit Function
   Else
     TempString = Replace(TempStringIn,"~exclamation~", "!")
     TempString = Replace(TempString,"~comma~",",")
'     TempString = Replace(TempString,"~atsign~","@")
     TempString = Replace(TempString,"~pound~","#")
     TempString = Replace(TempString,"~dollarsign~","$")
     TempString = Replace(TempString,"~dollar~","$")
     TempString = Replace(TempString,"~percent~","%")
     TempString = Replace(TempString,"~carrot~","^")
     TempString = Replace(TempString,"~ampersand~","&amp;")
     TempString = Replace(TempString,"~asterisk~","*")
'     TempString = Replace(TempString,"~minus~","-")
     TempString = Replace(TempString,"~equals~","=")
     TempString = Replace(TempString,"~underscore~","_")
     TempString = Replace(TempString,"~us~","_")
     TempString = Replace(TempString,"~plus~","+")
     TempString = Replace(TempString,"~backslash~","\")
     TempString = Replace(TempString,"~forwardslash~","/")
     TempString = Replace(TempString,"~bslash~","\")
     TempString = Replace(TempString,"~slash~","/")
     TempString = Replace(TempString,"~pipe~","|")
     TempString = Replace(TempString,"~colon~",":")
     TempString = Replace(TempString,"~semicolon~",";")
     TempString = Replace(TempString,"~sc~", ";")
     TempString = Replace(TempString,"~newline~", "<br>")
     TempString = Replace(TempString,"~nl~", "<br>")
     TempString = Replace(TempString,vbCrLf, "<br>")
     TempString = Replace(TempString,vbLf, "<br>")
     TempString = Replace(TempString,vbCr, "<br>")
     TempString = Replace(TempString,"~gt~","&gt;")
     TempString = Replace(TempString,"~lt~","&lt;")
     TempString = Replace(TempString,"~agu~","`")
     TempString = Replace(TempString,"~singlequote~","'")
     TempString = Replace(TempString,"~doublequote~", "&quot;")
     TempString = Replace(TempString,"~sq~","'")
     TempString = Replace(TempString,"~dq~", "&quot;")
     TempString = Replace(TempString,"~questionmark~","?")
     TempString = Replace(TempString,"~qm~","?")
     TempString = Replace(TempString,"~tab~","&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
     TempString = Replace(TempString,"~tilde~", "~")
     DecodeString = TempString
   End If
End Function%>



<% ' -------------------------------------------- %>
<% ' -------------------------------------------- %>
<% Private Function DecodeStringNoBreak (TempString)
   IF (IsNull(TempString) OR TempString = "") Then
     DecodeStringNoBreak = ""
	 Exit Function
   Elseif (IsNumeric(TempString)) Then
     DecodeStringNoBreak = TempString
	 Exit Function
   Else
     TempString = Replace(TempString,"~exclamation~", "!")
     TempString = Replace(TempString,"~comma~",",")
'     TempString = Replace(TempString,"~atsign~","@")
     TempString = Replace(TempString,"~pound~","#")
     TempString = Replace(TempString,"~dollarsign~","$")
     TempString = Replace(TempString,"~dollar~","$")
     TempString = Replace(TempString,"~percent~","%")
     TempString = Replace(TempString,"~carrot~","^")
     TempString = Replace(TempString,"~ampersand~","&amp;")
     TempString = Replace(TempString,"~asterisk~","*")
'     TempString = Replace(TempString,"~minus~","-")
     TempString = Replace(TempString,"~equals~","=")
     TempString = Replace(TempString,"~underscore~","_")
     TempString = Replace(TempString,"~us~","_")
     TempString = Replace(TempString,"~plus~","+")
     TempString = Replace(TempString,"~backslash~","\")
     TempString = Replace(TempString,"~forwardslash~","/")
     TempString = Replace(TempString,"~bslash~","\")
     TempString = Replace(TempString,"~slash~","/")
     TempString = Replace(TempString,"~pipe~","|")
     TempString = Replace(TempString,"~colon~",":")
     TempString = Replace(TempString,"~semicolon~",";")
     TempString = Replace(TempString, "~sc~", ";")
     TempString = Replace(TempString,"~newline~", " ")
     TempString = Replace(TempString,"~nl~", " ")
     TempString = Replace(TempString,"~gt~","&gt;")
     TempString = Replace(TempString,"~lt~","&lt;")
     TempString = Replace(TempString,"~agu~","`")
     TempString = Replace(TempString,"~singlequote~","'")
     TempString = Replace(TempString,"~doublequote~", "&quot;")
     TempString = Replace(TempString,"~sq~","'")
     TempString = Replace(TempString,"~dq~", "&quot;")
     TempString = Replace(TempString,"~questionmark~","?")
     TempString = Replace(TempString,"~qm~","?")
     TempString = Replace(TempString,"~tab~","&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
     TempString = Replace(TempString,"~tilde~", "~")
     DecodeStringNoBreak = TempString
   End If
End Function%>



<% ' -------------------------------------------- %>
<% ' -------------------------------------------- %>
<% Private Function SQLEncodeString (TempString)
   IF (IsNull(TempString) OR TempString = "") Then
     SQLEncodeString = ""
	 Exit Function
   Elseif (IsNumeric(TempString)) Then
     SQLEncodeString = TempString
	 Exit Function
   Else
     TempString = Replace(TempString,"~!", " ")
'     TempString = Replace(TempString,"~",  "~tilde~")
'     TempString = Replace(TempString,"!",  "~exclamation~")
'     TempString = Replace(TempString,"@",  "~atsign~")
     TempString = Replace(TempString,"#",  "")
'     TempString = Replace(TempString,"$",  "~dollarsign~")
     TempString = Replace(TempString,"%",  "~percent~")
'     TempString = Replace(TempString,"^",  "~carrot~")
     TempString = Replace(TempString,"&",  "")
     TempString = Replace(TempString,"*",  "%")
'     TempString = Replace(TempString,"-",  "~minus~")
     TempString = Replace(TempString,"=",  "")
     TempString = Replace(TempString,"_",  "~underscore~")
     TempString = Replace(TempString,"+",  "")
     TempString = Replace(TempString,"\",  "")
     TempString = Replace(TempString,"/",  "")
     TempString = Replace(TempString,"|",  "")
'     TempString = Replace(TempString,":",  "~colon~")
     TempString = Replace(TempString,";",  "")
     TempString = Replace(TempString,vbNewLine, "")
     TempString = Replace(TempString,vbCrLf, "")
     TempString = Replace(TempString,vbCr, "")
     TempString = Replace(TempString,vbLf, "")
     TempString = Replace(TempString,">",  "")
     TempString = Replace(TempString,"<",  "")
     TempString = Replace(TempString,"`",  "")
     TempString = Replace(TempString,"'",  "")
     TempString = Replace(TempString,chr(34), "")
     TempString = Replace(TempString,"?",  "_")
     TempString = Replace(TempString,vbTab,"")
     SQLEncodeString = TempString
   End If
End Function%>


<% ' -------------------------------------------- %>
<% ' -------------------------------------------- %>
<% Private Function DecodeToText (TempString)
   IF (IsNull(TempString) OR TempString = "") Then
     DecodeToText = ""
	 Exit Function
   Elseif (IsNumeric(TempString)) Then
     DecodeToText = TempString
	 Exit Function
   Else
     TempString = Replace(TempString,"~exclamation~", "!")
     TempString = Replace(TempString,"~comma~", ",")
     TempString = Replace(TempString,"~atsign~","@")
     TempString = Replace(TempString,"~pound~","#")
     TempString = Replace(TempString,"~dollarsign~","$")
     TempString = Replace(TempString,"~dollar~","$")
     TempString = Replace(TempString,"~percent~","%")
     TempString = Replace(TempString,"~carrot~","^")
     TempString = Replace(TempString,"~ampersand~","&")
     TempString = Replace(TempString,"~asterisk~","*")
     TempString = Replace(TempString,"~minus~","-")
     TempString = Replace(TempString,"~equals~","=")
     TempString = Replace(TempString,"~underscore~","_")
     TempString = Replace(TempString,"~us~","_")
     TempString = Replace(TempString,"~plus~","+")
     TempString = Replace(TempString,"~backslash~","\")
     TempString = Replace(TempString,"~forwardslash~","/")
     TempString = Replace(TempString,"~bslash~","\")
     TempString = Replace(TempString,"~slash~","/")
     TempString = Replace(TempString,"~pipe~","|")
     TempString = Replace(TempString,"~colon~",":")
     TempString = Replace(TempString,"~semicolon~",";")
     TempString = Replace(TempString, "~sc~", ";")
     TempString = Replace(TempString,"~newline~", vbCrLf)
     TempString = Replace(TempString,"~nl~", vbCrLf)
     TempString = Replace(TempString,"~gt~",">")
     TempString = Replace(TempString,"~lt~","<")
     TempString = Replace(TempString,"<BR>", vbCrLf)
     TempString = Replace(TempString,"<br>", vbCrLf)
     TempString = Replace(TempString,"~agu~","`")
     TempString = Replace(TempString,"~singlequote~","'")
     TempString = Replace(TempString,"~doublequote~", """")
     TempString = Replace(TempString,"~questionmark~","?")
     TempString = Replace(TempString,"~sq~","'")
     TempString = Replace(TempString,"~dq~", """")
     TempString = Replace(TempString,"~qm~","?")
     TempString = Replace(TempString,"~tab~", vbTab)
     TempString = Replace(TempString,"~tilde~", "~")
     DecodeToText = TempString
   End If
End Function

Private Function DecodeToTextNoBreak (TempString)
   IF (IsNull(TempString) OR TempString = "") Then
     DecodeToTextNoBreak = ""
	 Exit Function
   Elseif (IsNumeric(TempString)) Then
     DecodeToTextNoBreak = TempString
	 Exit Function
   Else
     TempString = Replace(TempString,"~exclamation~", "!")
     TempString = Replace(TempString,"~comma~", ",")
     TempString = Replace(TempString,"~atsign~","@")
     TempString = Replace(TempString,"~pound~","#")
     TempString = Replace(TempString,"~dollarsign~","$")
     TempString = Replace(TempString,"~dollar~","$")
     TempString = Replace(TempString,"~percent~","%")
     TempString = Replace(TempString,"~carrot~","^")
     TempString = Replace(TempString,"~ampersand~","&")
     TempString = Replace(TempString,"~asterisk~","*")
     TempString = Replace(TempString,"~minus~","-")
     TempString = Replace(TempString,"~equals~","=")
     TempString = Replace(TempString,"~underscore~","_")
     TempString = Replace(TempString,"~us~","_")
     TempString = Replace(TempString,"~plus~","+")
     TempString = Replace(TempString,"~backslash~","\")
     TempString = Replace(TempString,"~forwardslash~","/")
     TempString = Replace(TempString,"~bslash~","\")
     TempString = Replace(TempString,"~slash~","/")
     TempString = Replace(TempString,"~pipe~","|")
     TempString = Replace(TempString,"~colon~",":")
     TempString = Replace(TempString,"~semicolon~",";")
     TempString = Replace(TempString,"~sc~", ";")
     TempString = Replace(TempString,"~newline~", " ")
     TempString = Replace(TempString,vbCrLf, " ")
     TempString = Replace(TempString,vbLf, " ")
     TempString = Replace(TempString,vbCr, " ")
     TempString = Replace(TempString,"~nl~", " ")
     TempString = Replace(TempString,"~gt~",">")
     TempString = Replace(TempString,"~lt~","<")
     TempString = Replace(TempString,"<BR>", " ")
     TempString = Replace(TempString,"<br>", " ")
     TempString = Replace(TempString,"~agu~","`")
     TempString = Replace(TempString,"~singlequote~","'")
     TempString = Replace(TempString,"~doublequote~", """")
     TempString = Replace(TempString,"~questionmark~","?")
     TempString = Replace(TempString,"~sq~","'")
     TempString = Replace(TempString,"~dq~", """")
     TempString = Replace(TempString,"~qm~","?")
     TempString = Replace(TempString,"~tab~", " ")
     TempString = Replace(TempString,vbTab, "   ")
     TempString = Replace(TempString,"~tilde~", "~")
     DecodeToTextNoBreak = TempString
   End If
End Function


Function DecodeForInDesign(TempString)
   If (IsNull(TempString) Or TempString = "") Then
     DecodeToTextExport = ""
     Exit Function
   ElseIf (IsNumeric(TempString)) Then
     DecodeToTextExport = TempString
     Exit Function
   Else
     TempString = Replace(TempString, "~exclamation~", "!")
     TempString = Replace(TempString, "~comma~", ",")
     TempString = Replace(TempString, "~atsign~", "@")
     TempString = Replace(TempString, "~pound~", "#")
     TempString = Replace(TempString, "~dollarsign~", "$")
     TempString = Replace(TempString, "~ds~", "$")
     TempString = Replace(TempString, "~percent~", "%")
     TempString = Replace(TempString, "~carrot~", "^")
     TempString = Replace(TempString, "~ampersand~", "&")
     TempString = Replace(TempString, "~and~", "&")
     TempString = Replace(TempString, "~asterisk~", "*")
     TempString = Replace(TempString, "~minus~", "-")
     TempString = Replace(TempString, "~equals~", "=")
     TempString = Replace(TempString, "~underscore~", "_")
     TempString = Replace(TempString, "~plus~", "+")
     TempString = Replace(TempString, "~backslash~", "\\")
     TempString = Replace(TempString, "~forwardslash~", "/")
     TempString = Replace(TempString, "~slash~", "/")
     TempString = Replace(TempString, "~pipe~", "|")
     TempString = Replace(TempString, "~colon~", ":")
     TempString = Replace(TempString, "~sc~", ";")
     TempString = Replace(TempString, "~semicolon~", ";")
     TempString = Replace(TempString, "~sc~", ";")
     TempString = Replace(TempString, "~gt~", "\>")
     TempString = Replace(TempString, "~lt~", "\<")
     TempString = Replace(TempString, "<BR>", " ")
     TempString = Replace(TempString, "<br>", " ")
     TempString = Replace(TempString, "~newline~", " ")
     TempString = Replace(TempString, "~nl~", " ")
     TempString = Replace(TempString, "~agu~", "`")
     TempString = Replace(TempString, "~singlequote~", "'")
     TempString = Replace(TempString, "~sq~", "'")
     TempString = Replace(TempString, "~doublequote~", """")
     TempString = Replace(TempString, "~dq~", """")
     TempString = Replace(TempString, "~questionmark~", "?")
     TempString = Replace(TempString, "~qm~", "?")
     TempString = Replace(TempString, "~tab~", " ")
     TempString = Replace(TempString, "~tilde~", "~")
     DecodeForInDesign = TempString
   End If
End Function


'----------------------
Private Function IsIn(strSource, strItemToFind, strDelimiter)
  aryFields = Split(strSource,strDelimiter)
  bFound = vbFalse
  For Each Thing in aryFields
    If Thing=CStr(strItemToFind) Then
      bFound = vbTrue
    End If
  Next
  IsIn=bFound
End Function
'----------------------

'----------------------
Private Function LargerOf(intFirst, intSecond)
  If intFirst<intSecond Then
    LargerOf = intSecond
  Else
    LargerOf = intFirst
  End if
End Function
'----------------------

'----------------------
Private Function SmallerOf(intFirst, intSecond)
  If intFirst>intSecond Then
    SmallerOf = intSecond
  Else
    SmallerOf = intFirst
  End if
End Function
'----------------------

'----------------------
Function PadLeftString ( Astring, width )
    Dim a 
    Dim TempString
    TempString = Astring
	
    If Len(Astring) < width Then
        For a = 1 To (width - Len(Astring))
            TempString = "0" & TempString
        Next
    ElseIf Len(Astring) > width Then
        TempString = SizeString(Astring, width)
    End If
    
    PadLeftString = TempString
End Function
'----------------------

'----------------------
Function CatExtract( strCatList, FieldName )
  aryCats = Split(strCatList,",")
  CatExtract = ""
  For Each Cat in aryCats
    If (Cat Mod 100)=0 Then
      CatExtract = CatExtract & "(" & FieldName & ">='" & Cat & "' AND " & FieldName & "<'" & Cat+100 & "') OR "
	  Else
	    CatExtract = CatExtract & "(" & FieldName & "='" & Cat & "') OR "
	  End If
  Next
  If Len(CatExtract)>0 Then
    CatExtract = "(" & Left(CatExtract,Len(CatExtract)-4) & ")"
  End If
'  CatExtract = strCatFilter
End Function
'----------------------

'----------------------
Function CatExtract_New( strCatList, FieldName )
  aryCats = Split(strCatList,",")
  CatExtract_New = ""
  For Each Cat in aryCats
    'If (Cat Mod 100)=0 Then
    '  CatExtract = CatExtract & "(" & FieldName & ">='" & Cat & "' AND " & FieldName & "<'" & Cat+100 & "') OR "
	  'Else
	    CatExtract_New = CatExtract_New & "(" & FieldName & "='" & Cat & "') OR "
	  'End If
  Next
  If Len(CatExtract_New)>0 Then
    CatExtract_New = "(" & Left(CatExtract_New,Len(CatExtract_New)-4) & ")"
  End If
'  CatExtract = strCatFilter
End Function
'----------------------

'----------------------
Function CatExtract2( strCatList, FieldName )
  CatExtract2 = ""
  aryCats = Split(strCatList,",")
  For Each Cat in aryCats
    If (Cat Mod 100)=0 Then
	    'For k = 0 to 99 Step 1
        'CatExtract2 = CatExtract2 & "((" & FieldName & " LIKE '" & k+Cat & ",%') OR (" & FieldName & " LIKE '%," & k+Cat & "') OR (" & FieldName & " LIKE '%," & k+Cat & ",%') OR (" & FieldName & " LIKE '" & k+Cat & "')) OR "
        CatExtract2 = CatExtract2 & "((" & FieldName & " LIKE '" & Cat/100 & "[0-9][0-9]" & ",%') OR (" & FieldName & " LIKE '%," & Cat/100 & "[0-9][0-9]" & "') OR (" & FieldName & " LIKE '%," & Cat/100 & "[0-9][0-9]" & ",%') OR (" & FieldName & " LIKE '" & Cat/100 & "[0-9][0-9]" & "')) OR "
      'Next
	  Else
      CatExtract2 = CatExtract2 & "((" & FieldName & " LIKE '" & Cat & ",%') OR (" & FieldName & " LIKE '%," & Cat & "') OR (" & FieldName & " LIKE '%," & Cat & ",%') OR (" & FieldName & " LIKE '" & Cat & "')) OR "
	  End If
  Next
  If Len(CatExtract2)>0 Then
    CatExtract2 = "(" & Left(CatExtract2,Len(CatExtract2)-4) & ")"
  End If
End Function
'----------------------

'----------------------
Function CatExtract3( strCatList, FieldName )
  CatExtract3 = ""
  aryCats = Split(strCatList,",")
  For Each Cat in aryCats
    CatExtract3 = CatExtract3 & "((" & FieldName & " LIKE '" & Cat & ",%') OR (" & FieldName & " LIKE '%," & Cat & "') OR (" & FieldName & " LIKE '%," & Cat & ",%') OR (" & FieldName & " LIKE '" & Cat & "')) OR "
  Next
  If Len(CatExtract3)>0 Then
    CatExtract3 = "(" & Left(CatExtract3,Len(CatExtract3)-4) & ")"
  End If
End Function
'----------------------

'----------------------
Function CatExtract2_New( strCatList, FieldName )
  CatExtract2_New = ""
  aryCats = Split(strCatList,",")
  For Each Cat in aryCats
    CatExtract2_New = CatExtract2_New & "(" & FieldName & " IN (SELECT UniqueID FROM PaperTopics WHERE UniqueID IN (" & Cat & ") OR Parent IN (" & Cat & ") OR GParent IN (" & Cat & ")) ) OR "
  Next
  If Len(CatExtract2_New)>0 Then
    CatExtract2_New = "(" & Left(CatExtract2_New,Len(CatExtract2_New)-4) & ")"
  End If
End Function
'----------------------

'----------------------
Function CatExtract5( strCatList, FieldName )
  CatExtract5 = ""
  aryCats = Split(strCatList,",")
  For Each Cat in aryCats
    CatExtract5 = CatExtract5 & "(" & FieldName & " IN (SELECT UniqueID FROM PaperTopics WHERE UniqueID IN (" & Cat & ") OR Parent IN (" & Cat & ") OR GParent IN (" & Cat & ")) ) OR "
  Next
  If Len(CatExtract5)>0 Then
    CatExtract5 = "(" & Left(CatExtract5,Len(CatExtract5)-4) & ")"
  End If
End Function
'----------------------

'----------------------
Function CatExtract4 ( strCatList, FieldName, ConnObj )
  Set rstT = ConnObj.Execute("SELECT UniqueID FROM PaperTopics WHERE " & CatExtract2_New(strCatList, "PaperTopics.UniqueID") & "")
  if not rstT.EOF then
    aryT = rstT.GetRows()
    rstT.Close
    Set rstT = Nothing
    strAllTopics = ""
    For i = 0 to UBound(aryT, 2)
      strAllTopics = strAllTopics & aryT(0,i) & ","
    Next
    strAllTopics = TrimLeft(strAllTopics, 1)
    CatExtract4 = CatExtract3(strAllTopics, FieldName)
  else
    CatExtract4=" 1=1 "
  end if	
End Function
'----------------------

'----------------------
Function TrimLeft ( strInput, intTrimCount )
  If Len(strInput)>intTrimCount Then
    TrimLeft = Left(strInput, Len(strInput)-intTrimCount)
  Else
    TrimLeft = ""
  End If
End Function
'----------------------

'----------------------
Function TrimRight ( strInput, intTrimCount )
  If Len(strInput)>intTrimCount Then
    TrimRight = Right(strInput, Len(strInput)-intTrimCount)
  Else
    TrimRight = ""
  End If
End Function
'----------------------

'----------------------
Function TrimFromLeft ( strInput, intTrimCount )
  If Len(strInput)>intTrimCount Then
    TrimFromLeft = Right(strInput, Len(strInput)-intTrimCount)
  Else
    TrimFromLeft = ""
  End If
End Function
'----------------------

'----------------------
Function TrimFromRight ( strInput, intTrimCount )
  If Len(strInput)>intTrimCount Then
    TrimFromRight = Left(strInput, Len(strInput)-intTrimCount)
  Else
    TrimFromRight = ""
  End If
End Function
'----------------------

'----------------------
Function FormatDateEmail ( CurrentDate )
  If IsNull(CurrentDate) Then
    FormatDateEmail = "Error"
  Else
    strDate = WeekDayName(Weekday(CurrentDate), vbTrue)
    strDate = strDate & ", " & Day(CurrentDate)
    strDate = strDate & " " & MonthName(Month(CurrentDate), vbTrue)
    strDate = strDate & " " & Year(CurrentDate)
    strDate = strDate & " " & PadLeftString(Hour(CurrentDate),2) & ":" & PadLeftString(Minute(CurrentDate),2) & ":" & PadLeftString(Second(CurrentDate),2)
    strDate = strDate & " " & "-0600"
    FormatDateEmail = strDate
  End If
End Function
'----------------------
'----------------------
Function DateOutput(dDate, sFormat)
  'Formats a VBScript date into defined format
  If Not isDate(dDate) Then
    DateOutput = ""
    Exit Function
  Else
    dDate = cDate(dDate)
  End If
  
  Dim iYear, iYear2, iMonth, iMonth2, iDay, iDay2, iHour, iHour2, iMinute, iMinute2, iSecond, iSecond2
  
  iYear = Year(dDate)
  iYear2 = Right(cStr(iYear),2)
  iMonth = Month(dDate)
  If iMonth < 10 Then iMonth2 = "0" & CStr(iMonth) Else iMonth2 = iMonth
  iDay = Day(dDate)
  If iDay < 10 Then iDay2 = "0" & CStr(iDay) Else iDay2 = iDay
  
  iHour = Hour(dDate)
  If iHour < 10 Then iHour2 = "0" & CStr(iHour) Else iHour2 = iHour
  iMinute = Minute(dDate)
  If iMinute < 10 Then iMinute2 = "0" & CStr(iMinute) Else iMinute2 = iMinute
  iSecond = Second(dDate)
  If iSecond < 10 Then iSecond2 = "0" & CStr(iSecond) Else iSecond2 = iSecond
  
  Dim sDate : sDate = sFormat
  'ACCEPTED FORMATS
  'Day:
  '%d  Day of the month, 2 digits with leading zeros  01 to 31
  sDate = Replace(sDate,"%d",iDay2,1,-1,0)
  '%D  A textual representation of a day, three letters  Sun through Sat
  sDate = Replace(sDate,"%D",WeekdayName(WeekDay(dDate,1),TRUE),1,-1,0)
  '%j  Day of the month without leading zeros  1 to 31
  sDate = Replace(sDate,"%j",iDay,1,-1,0)
  '%l (lowercase 'L')  A full textual representation of the day of the week  Sunday through Saturday
  sDate = Replace(sDate,"%l",WeekdayName(WeekDay(dDate),FALSE),1,-1,0)
  '%N  ISO-8601 numeric representation of the day of the week  1 (for Monday) through 7 (for Sunday)
  sDate = Replace(sDate,"%N",WeekDay(dDate,2),1,-1,0)
  '%S  English ordinal suffix for the day of the month, 2 characters  st, nd, rd or th. Works well with j
  Dim sOrdinal
  Select Case iDay
    Case 11,12,13:
      sOrdinal = "th"
    Case Else:
      Select Case Right(cStr(iDay),1)
        Case "1":
          sOrdinal = "st"
        Case "2":
          sOrdinal = "nd"
        Case "3":
          sOrdinal = "rd"
        Case Else:
          sOrdinal = "th"
      End Select
  End Select
  sDate = Replace(sDate,"%S",sOrdinal,1,-1,0)
  '%w  Numeric representation of the day of the week  0 (for Sunday) through 6 (for Saturday)
  sDate = Replace(sDate,"%w",WeekDay(dDate,1)-1,1,-1,0)
  '%z  The day of the year (starting from 0)  0 through 365
  sDate = Replace(sDate,"%z",DateDiff("d",DateSerial(Year(dDate),1,1),dDate),1,-1,0)
  '
  'Week
  '%W  ISO-8601 week number of year, weeks starting on Monday  Example: 42 (the 42nd week in the year)
  sDate = Replace(sDate,"%W",DateDiff("ww",DateSerial(Year(dDate),1,1),dDate,2,3),1,-1,0)
  '
  'Month:
  '%F  A full textual representation of a month, such as January or March  January through December
  sDate = Replace(sDate,"%F",MonthName(iMonth,False),1,-1,0)
  '%m  Numeric representation of a month, with leading zeros  01 through 12
  sDate = Replace(sDate,"%m",iMonth2,1,-1,0)
  '%M  A short textual representation of a month, three letters  Jan through Dec
  sDate = Replace(sDate,"%M",MonthName(iMonth,True),1,-1,0)
  '%n  Numeric representation of a month, without leading zeros  1 through 12
  sDate = Replace(sDate,"%n",iMonth,1,-1,0)
  '%t  Number of days in the given month  28 through 31
  sDate = Replace(sDate,"%t",Day(DateAdd("d",-1,DateSerial(Year(dDate),Month(dDate)+1,1))),1,-1,0)
  '
  'Year
  '%L  Whether it's a leap year  1 if it is a leap year, 0 otherwise.
  Dim iLeapYear : iLeapYear = 0
  If Day(DateAdd("d",-1,DateSerial(Year(dDate),3,1))) = 29 Then iLeapYear = 1
  sDate = Replace(sDate,"%L",iLeapYear,1,-1,0)
  '%o  ISO-8601 year number. This has the same value as Y, except that if the ISO week number (W) belongs to the previous or next year, that year is used instead.  Examples: 1999 or 2003
  'sDate = Replace(sDate,"%o",replacewith,1,-1,0) - Not sure how to calculate this
  '%Y  A full numeric representation of a year, 4 digits  Examples: 1999 or 2003
  sDate = Replace(sDate,"%Y",iYear,1,-1,0)
  '%y  A two digit representation of a year  Examples: 99 or 03
  sDate = Replace(sDate,"%y",iYear2,1,-1,0)
  '
  'Time
  '%a  Lowercase Ante meridiem and Post meridiem  am or pm
  Dim sAmPm : sAmPm = "am"
  If iHour > 11 Then sAmPm = "pm"
  sDate = Replace(sDate,"%a",sAmPm,1,-1,0)
  '%A  Uppercase Ante meridiem and Post meridiem  AM or PM
  sDate = Replace(sDate,"%A",UCase(sAmPm),1,-1,0)
  '%B  Swatch Internet time  000 through 999
  'sDate = Replace(sDate,"%B",replacewith,1,-1,0) - Not sure how to calculate this since we can't get timezone from VBScript
  '%g  12-hour format of an hour without leading zeros  1 through 12
  Dim iHour12 : iHour12 = iHour
  If iHour12 > 12 Then
    iHour12 = iHour - 12
  ElseIf iHour12 = 0 Then
    iHour12 = 12
  End If
  sDate = Replace(sDate,"%g",iHour12,1,-1,0)
  '%G  24-hour format of an hour without leading zeros  0 through 23
  sDate = Replace(sDate,"%G",iHour,1,-1,0)
  '%h  12-hour format of an hour with leading zeros  01 through 12
  Dim iHour122 : iHour122 = iHour12
  If iHour122 < 9 Then iHour122 = "0" & iHour122
  sDate = Replace(sDate,"%h",iHour122,1,-1,0)
  '%H  24-hour format of an hour with leading zeros  00 through 23
  sDate = Replace(sDate,"%H",iHour2,1,-1,0)
  '%i  Minutes with leading zeros  00 to 59
  sDate = Replace(sDate,"%i",iMinute2,1,-1,0)
  '%s  Seconds, with leading zeros  00 through 59
  sDate = Replace(sDate,"%s",iSecond2,1,-1,0)
  '%U
  sDate = Replace(sDate,"%U",DateDiff("s","01/01/1970 00:00:00",dDate),1,-1,0)
  DateOutput = sDate
End Function
'----------------------

'----------------------
Function CheckIEEEMembership(strMemberNumber, strLastName, arySocietyCheck, aryGrades, ByRef strFoundLastName, ByRef strFoundGrade, cnnMemb)
  '0 0 0 0
  '| | | |--Member Number Matches (Mask with 1)
  '| | |----Name Matches (Mask with 2)
  '| |------Society Matches (Mask with 4)
  '|--------Grade Matches (Mask with 8)
  'strMemberNumber = Incoming Member Number to check
  'strLastName = Incoming last name to check (can be longer than 5 chars)
  'arySocietyCheck = Array of strings, society codes to check membership in. Match found if at least one society matches.
  'aryGrades = Array of strings, Incoming Member Grades to check. Match found if at least one grade matches.
  'strFoundLastName = Outgoing First 5 chars of last name found in a matching record
  'strFoundGrade = Outgoing grade found in a matching record
  'cnnMemb = OLEDB Connection object
  CheckIEEEMembership = 0
  strFoundLastName = ""
  strFoundGrade = ""
  If Not(IsEmpty(strMemberNumber)) Then
    Set rstVerf = cnnMemb.Execute("SELECT IEEEMembership.dbo.IEEEMembership.MemberNumber, IEEEMembership.dbo.IEEEMembership.NameLast, IEEEMembership.dbo.IEEEMembership.NameFirst, IEEEMembership.dbo.Grades.GradeName, IEEEMembership.dbo.Societies.SocietyCode FROM IEEEMembership.dbo.IEEEMembership INNER JOIN IEEEMemberShip.dbo.Grades ON IEEEMembership.dbo.IEEEMembership.GradeID=IEEEMembership.dbo.Grades.GradeID LEFT JOIN IEEEMembership.dbo.MemberSocieties ON IEEEMembership.dbo.IEEEMembership.MemberID=IEEEMembership.dbo.MemberSocieties.MemberID LEFT JOIN IEEEMembership.dbo.Societies ON IEEEMembership.dbo.MemberSocieties.SocietyID=IEEEMembership.dbo.Societies.SocietyID WHERE IEEEMembership.dbo.IEEEMembership.MemberNumber='" & EncodeString(Trim(strMemberNumber)) & "'")
    If Not rstVerf.EOF Then
      strFoundLastName = Left(rstVerf("NameLast"), 5)
      strFoundGrade = rstVerf("GradeName")
      'Valid Member Number
      CheckIEEEMembership = CheckIEEEMembership + 1
      'Check Name
      If StrComp(Left(strLastName, 5), Left(rstVerf("NameLast"), 5), VBTextCompare)=0 Then
        'Match Name
        CheckIEEEMembership = CheckIEEEMembership + 2
      End If
      'Check Grade
      bGradeMatch = vbFalse
      For Each Grd In aryGrades
        If StrComp(Grd, rstVerf("GradeName"), vbTextCompare)=0 Then
          'Match Grade
          bGradeMatch = vbTrue
        End If
      Next
      If bGradeMatch Then
        CheckIEEEMembership = CheckIEEEMembership + 8
      End If
      'If strComp(strGrade, rstVerf("GradeName"), VBTextCompare)=0 Then
      '  'Match Grade
      '  CheckIEEEMembership = CheckIEEEMembership + 8
      'End If
      'Check Society Membership
      bSocietyMatch = vbFalse
      Do While Not rstVerf.EOF
        For Each Soc In arySocietyCheck
          If StrComp(Soc, rstVerf("SocietyCode"))=0 Then
            bSocietyMatch = vbTrue
            Exit Do
          End If
        Next
        rstVerf.MoveNext
      Loop
      If bSocietyMatch Then
        CheckIEEEMembership = CheckIEEEMembership + 4
      End If
    Else
      'No match
    End If
    rstVerf.Close
    Set rstVerf = Nothing
  Else
    'No number entered
  End If
End Function

 Function FileLastMod()
  ' Local variables
  Dim loFs, lsFile, lsPath, loFile, ldLast

  ' Create an instance of FileSystemObject object
  Set loFs = CreateObject("Scripting.FileSystemObject")

  ' Get the logical path of the current file
  ' (i.e. the file in which this code runs)
  lsFile = Request.ServerVariables("SCRIPT_NAME")

  ' Get the physical path of the file
  lsPath = Server.MapPath(lsFile)

  ' Get a handle/pointer to this file
  Set loFile = loFs.GetFile(lsPath)

  ' Get the "Last Modified" property of this file
  ldLast = loFile.DateLastModified

  ' Release the objects
  Set loFile = Nothing
  Set loFs = Nothing

  ' Write out the date in the long date
  ' format e.g. "MM/DD/YY"
  FileLastMod = CStr(FormatDateTime(ldLast, 1))
End Function
'----------------------

'----------------------
function addReviewTopic(ReviewerID, PaperTopicID, AccountType)
 strTimeStamp = Request.Form("TimeStamp")
 IPAddr =  Request.ServerVariables("REMOTE_ADDR")
 sql="INSERT INTO ReviewerTopics (AccountType, PaperTopicID, ReviewerID, CreatedTimestamp, CreatedByIP) VALUES (" & EncodeString(AccountType) & ", " & EncodeString(PaperTopicID) & ", " & EncodeString(ReviewerID) & ", " & EncodeString(strTimeStamp) & ", " & EncodeString(IPAddr) & ")"
 rstQuery = cnn.execute(sql)  
end function
'----------------------

'----------------------
function deleteReviewTopic(ReviewerID, PaperTopicID)
 sql="DELETE FROM ReviewerTopics WHERE ReviewerID=" & ReviewerID & " AND PaperTopicID=" & PaperTopicID
 rstQuery = cnn.execute(sql) 
end function
'----------------------

'----------------------
function addReviewPapers(ReviewerID, PaperNum, AccountType)
 strTimeStamp = Request.Form("TimeStamp")
 IPAddr =  Request.ServerVariables("REMOTE_ADDR")
 sql="INSERT INTO ReviewerPapers (AccountType, PaperNum, ReviewerID, CreatedTimestamp, CreatedByIP) VALUES (" & EncodeString(AccountType) & ", " & EncodeString(PaperNum) & ", " & EncodeString(ReviewerID) & ", " & strTimeStamp & ", " & IPAddr & ")"
 rstQuery = cnn.execute(sql)  
end function
'----------------------

'----------------------
function deleteReviewPapers(ReviewerID, PaperNum)
 sql="DELETE FROM ReviewerPapers WHERE ReviewerID=" & ReviewerID & " AND PaperNum=" & PaperNum
 rstQuery = cnn.execute(sql) 
end function
'----------------------

'----------------------
function addAccountType(ReviewerID, AccountType)
 strTimeStamp = Request.Form("TimeStamp")
 IPAddr =  Request.ServerVariables("REMOTE_ADDR")
 sql="INSERT INTO AccountTypes (ReviewerID, AccountType, CreatedTimestamp, CreatedByIP) VALUES (" & EncodeString(ReviewerID) & ", " & EncodeString(AccountType) & ", " & strTimeStamp & ", " & IPAddr & ")"
 rstQuery = cnn.execute(sql)  
end function
'----------------------

'----------------------
function deleteAccountType(ReviewerID, AccountType)
 sql="DELETE FROM ReviewerPapers WHERE ReviewerID=" & ReviewerID & " AND AccountType=" & AccountType
 rstQuery = cnn.execute(sql) 
end function
'----------------------

'----------------------
function PDF_Check(InFileMapped)
  PDF_Check=0 '0=DNE, 1=PDF,-1=Exists but not PDF
  dim FSO
  Set FSO = Server.CreateObject("scripting.FileSystemObject")	
  If FSO.FileExists(InFileMapped) Then
	dim fs,f,ts
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	Set f=fs.GetFile(InFileMapped)
	Set ts=f.OpenAsTextStream(1)
	line=ts.ReadLine
	PDF=TrimLeft(line, len(line)-5)
	ts.Close
	set ts=nothing
	set f=nothing
	set fs=nothing
	if PDF="%PDF-" then 'PDF File
	 PDF_Check=1
	Else 'Not A PDF
	 PDF_Check=-1
	End if
  Else 'File Does Not Exist
	PDF_Check=0
  End if  'Response.write(PDF_Check)  
end function

Function RegExResults(strTarget, strPattern)

  Set regEx = New RegExp
  regEx.Pattern = strPattern
  regEx.Global = true
  Set RegExResults = regEx.Execute(strTarget)
  Set regEx = Nothing

End Function

Function RegExReplace(strTarget, strNewString, strPattern)

  Set regEx = New RegExp
  regEx.Pattern = strPattern
  regEx.Global = true
  RegExReplace = regEx.Replace(strTarget, strNewString)
  Set regEx = Nothing

End Function

Function RegExTest(strTarget, strPattern)

  Set regEx = New RegExp
  regEx.Pattern = strPattern
  regEx.Global = true
  RegExTest = regEx.Test(strTarget)
  Set regEx = Nothing

End Function


%>
<!--#include file="ConfirmationEmailFunction.asp"-->
