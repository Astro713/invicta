<%
'----------------------
Function ChargePayment(PaymentID)

Dim bTestMode
bTestMode = vbFalse

'IGARSS 2020: Gateway ID 2177294
strAuthNetLogin = "8U9mJnv2N3Fx"
strAuthNetTranKey = "3Jf76N7Z5paaH2Yt"

Set oEncryptor2 = Server.Createobject("Dynu.Encrypt")

'-----Authorize.net Form Result Fields-----
x_response_code           = 0
x_response_subcode        = 1
x_response_reason_code    = 2
x_response_reason_text    = 3
x_auth_code               = 4
x_avs_code                = 5
x_trans_id                = 6
x_invoice_num             = 7
x_description             = 8
x_amount                  = 9
x_method                  = 10
x_type                    = 11
x_cust_id                 = 12
x_first_name              = 13
x_last_name               = 14
x_company                 = 15
x_address                 = 16
x_city                    = 17
x_state                   = 18
x_zip                     = 19
x_country                 = 20
x_phone                   = 21
x_fax                     = 22
x_email                   = 23
x_ship_to_first_name      = 24
x_ship_to_last_name       = 25
x_ship_to_company         = 26
x_ship_to_address         = 27
x_ship_to_city            = 28
x_ship_to_state           = 29
x_ship_to_zip             = 30
x_ship_to_country         = 31
x_tax                     = 32
x_duty                    = 33
x_freight                 = 34
x_tax_exempt              = 35
x_po_num                  = 36
x_md5_hash                = 37
x_cvv2_resp_code          = 38
'-----END Authorize.net Form Result Fields-----

Set rstTempPmt = cnn.Execute("SELECT Payments.*, Registrants.NameFirst, Registrants.NameLast, Registrants.Email, Registrants.AddressStreet1, Registrants.AddressStreet2, Registrants.Phone, Registrants.AddressCity, Registrants.AddressState, Registrants.AddressZip, Registrants.AddressCountry FROM Payments INNER JOIN Registrants ON Payments.RegistrantID=Registrants.RegistrantID WHERE Payments.PaymentID='" & PaymentID & "'")
If rstTempPmt.EOF Then
  ChargePayment="99^99^99^There is no Payment record to match."
  Exit Function
ElseIf rstTempPmt("PaymentMethod")<>"Credit Card" Then
  ChargePayment="99^99^99^This is not a Credit Card payment."
  Exit Function
ElseIf rstTempPmt("Received") Then
  ChargePayment="99^99^99^This payment record has already been received."
  Exit Function
End If

Set rstTempAmtDue = cnn.Execute("EXECUTE PaymentAmountDue @s_PaymentID=" & rstTempPmt("PaymentID"))

If rstTempAmtDue("AmtDue")=0.00 Then
' If rstTempAmtDue("AmtDue")=0.00 Then
  ChargePayment = "1^0^0^Amount to charge is $0.00. Did not attempt to charge."
  strSQL = "UPDATE Payments SET AmtReceived=" & "CONVERT(money,0.00)" & ", Received=1, ReceivedTimeStamp='" & Date & " " & Time & "', AuthCode='" & "000" & "', TransactionID='" & "000" & "' WHERE PaymentID=" & rstTempPmt("PaymentID")
  cnn.Execute(strSQL)
  strSQL = "UPDATE Registrants SET Status='Submitted' WHERE RegistrantID='" & rstTempPmt("RegistrantID") & "'"
  cnn.Execute(strSQL)
  strSQL = "INSERT INTO RegComments (Comment, Color, Type, Priority, CreatedByUser, CreatedByIP, CreatedTimeStamp, RegistrantID) VALUES ('CC not charged - amount is zero.','Green','Payment',3,'AutoCharge','" & Request.ServerVariables("REMOTE_ADDR") & "','" & Date & " " & Time & "','" & rstTempPmt("RegistrantID") & "')"
  cnn.Execute(strSQL)
  Exit Function
End If

Set oWinHttp = Server.CreateObject("WinHttp.WinHttpRequest.5.1")

oWinHttp.Open "POST", "https://secure2.authorize.net/gateway/transact.dll"
strPOST = ""

strPOST = strPOST & FF("x_login",strAuthNetLogin) & "&"

strPOST = strPOST & FF("x_tran_key",strAuthNetTranKey) & "&"

strPOST = strPOST & FF("x_version","3.1") & "&"

%><!--<%'=rstTempPmt("NameLast")%>--><%
If rstTempPmt("NameLast")="Googledygock" Then
  strPOST = strPOST & FF("x_test_request","TRUE") & "&"
ElseIf bTestMode Then
  strPOST = strPOST & FF("x_test_request","TRUE") & "&"
End If

strPOST = strPOST & FF("x_delim_data","TRUE") & "&"

strPOST = strPOST & FF("x_delim_char","^") & "&"

strPOST = strPOST & FF("x_relay_response","FALSE") & "&"

strCCName = DecodeString(rstTempPmt("CCName"))
intTempPos = InStrRev(strCCName, " ")
If Not intTempPos=0 Then
  strNameFirst = Left(strCCName, intTempPos-1)
  strNameLast = Right(strCCName, Len(strCCName)-intTempPos)
Else
  strNameFirst = ""
  strNameLast = strCCName
End If

'Response.Write("'" & strNameFirst & "','" & strNameLast & "'")
strPOST = strPOST & FF("x_first_name",strNameFirst) & "&"

strPOST = strPOST & FF("x_last_name",strNameLast) & "&"

If rstTempPmt("CCType")="American Express" And rstTempPmt("CCBillingCountry")<>"United States" Then
Else
  strPOST = strPOST & FF("x_address",DecodeToText(rstTempPmt("CCBillingAddress1"))) & "&"

  strPOST = strPOST & FF("x_city", DecodeToText(rstTempPmt("CCBillingCity"))) & "&"

  strPOST = strPOST & FF("x_state", DecodeToText(rstTempPmt("CCBillingState"))) & "&"

  strPOST = strPOST & FF("x_zip", DecodeToText(rstTempPmt("CCBillingZip"))) & "&"

  strPOST = strPOST & FF("x_country", DecodeToText(rstTempPmt("CCBillingCountry"))) & "&"
End If

strPOST = strPOST & FF("x_phone", DecodeToText(rstTempPmt("Phone"))) & "&"

strPOST = strPOST & FF("x_cust_id",strDSNName) & "&"

strPOST = strPOST & FF("x_email",DecodeToText(rstTempPmt("Email"))) & "&"

strPOST = strPOST & FF("x_invoice_num",rstTempPmt("RegistrantID")) & "&"

strPOST = strPOST & FF("x_description",strDSNName & "Conf.Reg") & "&"

If rstTempAmtDue("AmtDue")<0 Then
  strPOST = strPOST & FF("x_amount",FormatNumber(Abs(CSng(rstTempAmtDue("AmtDue"))),2,-1,0,0)) & "&"
  strPOST = strPOST & FF("x_type","CREDIT") & "&"
  strPOST = strPOST & FF("x_trans_id",rstTempPmt("RefundTransID")) & "&"
Else
  strPOST = strPOST & FF("x_amount",FormatNumber(CSng(rstTempAmtDue("AmtDue")),2,-1,0,0)) & "&"
  strPOST = strPOST & FF("x_type","AUTH_CAPTURE") & "&"
End If

strPOST = strPOST & FF("x_card_num",oEncryptor2.Decrypt(rstTempPmt("CCNumber"),strCCEncrypt)) & "&"

strPOST = strPOST & FF("x_card_code",rstTempPmt("CCCVV2")) & "&"

strPOST = strPOST & FF("x_exp_date",rstTempPmt("CCMonth") & "/" & rstTempPmt("CCYear")) & "&"

strPOST = strPOST & FF("x_method","CC") & "&"

strPOST = Left(strPOST, Len(strPOST)-1)

oWinHTTP.Send(strPOST)

strResults = oWinHTTP.ResponseText
Set oWinHTTP = Nothing
'Response.Write "<!--" & strResults & "<br><br>" & "-->"
If Err.Number <> 0 Then
  ChargePayment="99^99^99^Unable to contact credit card authorization service."
  strSQL = "INSERT INTO RegComments (Comment, Color, Type, Priority, CreatedByUser, CreatedByIP, CreatedTimeStamp, RegistrantID) VALUES ('CC Error, bad results: " & EncodeString(strResults) & "','Red','Payment',3,'AutoCharge','" & Request.ServerVariables("REMOTE_ADDR") & "','" & Date & " " & Time & "','" & rstTempPmt("RegistrantID") & "')"
  cnn.Execute(strSQL)
  Err.Clear
  Exit Function
End If

If Len(strResults)>1 Then
  aryResults = Split(strResults,"^")
  If rstTempAmtDue("AmtDue")<0 Then
    aryResults(x_amount)=(-1)*aryResults(x_amount)
  End If
Else
  aryResults = Split("98^98^98^Unexpected response from authorization service","^")
  strSQL = "INSERT INTO RegComments (Comment, Color, Type, Priority, CreatedByUser, CreatedByIP, CreatedTimeStamp, RegistrantID) VALUES ('CC Error, bad results: " & EncodeString(strResults) & "','Red','Payment',3,'AutoCharge','" & Request.ServerVariables("REMOTE_ADDR") & "','" & Date & " " & Time & "','" & rstTempPmt("RegistrantID") & "')"
  cnn.Execute(strSQL)
End If

If Not IsNumeric(aryResults(0)) Then
  ChargePayment="99^99^99^Unable to contact credit card authorization service."
  strSQL = "INSERT INTO RegComments (Comment, Color, Type, Priority, CreatedByUser, CreatedByIP, CreatedTimeStamp, RegistrantID) VALUES ('CC Error, bad results: " & EncodeString(strResults) & "','Red','Payment',3,'AutoCharge','" & Request.ServerVariables("REMOTE_ADDR") & "','" & Date & " " & Time & "','" & rstTempPmt("RegistrantID") & "')"
  cnn.Execute(strSQL)
  Exit Function
End If

Set CCcnn = Server.CreateObject("ADODB.Connection")
strCCConnStr = "Provider=SQLNCLI11;Server=" & strDSNServer & ";Database=" & strCCDSNname & ";UID=" & strCCDSNuser & ";PWD=" & strCCDSNpass & ";"
CCcnn.Open strCCConnStr 'strCCDSNname, strCCDSNuser, strCCDSNpass

If aryResults(x_response_code)=98 Then
  strCCSQL = "INSERT INTO CCMaster"
  strCCSQL = strCCSQL & " (ConferenceName,PaymentID,CCName,CCNumber,CCMonth,CCYear,CCType,Amount,ResponseCode,ResponseSubCode,ResponseReasonCode,ResponseReasonText,AuthCode,TransactionID,CustomerID,TimeStamp,CreatedByIP)"
  strCCSQL = strCCSQL & " VALUES ("
  strCCSQL = strCCSQL & "'" & EncodeString(strConferenceName) & "',"
  strCCSQL = strCCSQL & "'" & rstTempPmt("PaymentID") & "',"
  strCCSQL = strCCSQL & "'" & EncodeString(rstTempPmt("CCName")) & "',"
  strCCSQL = strCCSQL & "'" & EncodeString(rstTempPmt("CCNumber")) & "',"
  strCCSQL = strCCSQL & "'" & EncodeString(rstTempPmt("CCMonth")) & "',"
  strCCSQL = strCCSQL & "'" & EncodeString(rstTempPmt("CCYear")) & "',"
  strCCSQL = strCCSQL & "'" & EncodeString(rstTempPmt("CCType")) & "',"
  strCCSQL = strCCSQL & "CONVERT(money,'" & 0 & "'),"
  strCCSQL = strCCSQL & "'" & aryResults(x_response_code) & "',"
  strCCSQL = strCCSQL & "'" & aryResults(x_response_subcode) & "',"
  strCCSQL = strCCSQL & "'" & aryResults(x_response_reason_code) & "',"
  strCCSQL = strCCSQL & "'" & EncodeString(aryResults(x_response_reason_text)) & "',"
  strCCSQL = strCCSQL & "'" & "000000" & "',"
  strCCSQL = strCCSQL & "'" & "0000000000" & "',"
  strCCSQL = strCCSQL & "'" & strDSNName & "',"
  strCCSQL = strCCSQL & "'" & Date & " " & Time & "',"
  strCCSQL = strCCSQL & "'" & Request.ServerVariables("REMOTE_ADDR") & "')"
Else
  strCCSQL = "INSERT INTO CCMaster"
  strCCSQL = strCCSQL & " (ConferenceName,PaymentID,CCName,CCNumber,CCMonth,CCYear,CCType,Amount,ResponseCode,ResponseSubCode,ResponseReasonCode,ResponseReasonText,AuthCode,TransactionID,CVV2Response,CustomerID,TimeStamp,CreatedByIP)"
  strCCSQL = strCCSQL & " VALUES ("
  strCCSQL = strCCSQL & "'" & EncodeString(strConferenceName) & "',"
  strCCSQL = strCCSQL & "'" & rstTempPmt("PaymentID") & "',"
  strCCSQL = strCCSQL & "'" & EncodeString(rstTempPmt("CCName")) & "',"
  strCCSQL = strCCSQL & "'" & EncodeString(rstTempPmt("CCNumber")) & "',"
  strCCSQL = strCCSQL & "'" & EncodeString(rstTempPmt("CCMonth")) & "',"
  strCCSQL = strCCSQL & "'" & EncodeString(rstTempPmt("CCYear")) & "',"
  strCCSQL = strCCSQL & "'" & EncodeString(rstTempPmt("CCType")) & "',"
  strCCSQL = strCCSQL & "CONVERT(money,'" & aryResults(x_amount) & "'),"
  strCCSQL = strCCSQL & "'" & aryResults(x_response_code) & "',"
  strCCSQL = strCCSQL & "'" & aryResults(x_response_subcode) & "',"
  strCCSQL = strCCSQL & "'" & aryResults(x_response_reason_code) & "',"
  strCCSQL = strCCSQL & "'" & EncodeString(aryResults(x_response_reason_text)) & "',"
  strCCSQL = strCCSQL & "'" & aryResults(x_auth_code) & "',"
  strCCSQL = strCCSQL & "'" & aryResults(x_trans_id) & "',"
  strCCSQL = strCCSQL & "'" & Left(aryResults(x_cvv2_resp_code),1) & "',"
  strCCSQL = strCCSQL & "'" & aryResults(x_cust_id) & "',"
  strCCSQL = strCCSQL & "'" & Date & " " & Time & "',"
  strCCSQL = strCCSQL & "'" & Request.ServerVariables("REMOTE_ADDR") & "')"
End If
'Response.Write("<!--" & strCCSQL & "<br>" & "-->")

CCcnn.Execute(strCCSQL)

'-------------------------
If aryResults(x_response_code)=1 Then 'Approved
 strSQL = "UPDATE Payments SET AmtReceived=" & aryResults(x_amount) & ", Received=1, ReceivedTimeStamp='" & Date & " " & Time & "', AuthCode='" & aryResults(x_auth_code) & "', TransactionID='" & aryResults(x_trans_id) & "' WHERE PaymentID=" & rstTempPmt("PaymentID")
 cnn.Execute(strSQL)
 strSQL = "UPDATE Registrants SET Status='Submitted' WHERE RegistrantID='" & rstTempPmt("RegistrantID") & "'"
 cnn.Execute(strSQL)
 If aryResults(x_amount)<0 Then
   strSQL = "INSERT INTO RegComments (Comment, Color, Type, Priority, CreatedByUser, CreatedByIP, CreatedTimeStamp, RegistrantID) VALUES ('CC Refunded Successfully, Transaction ID: " & aryResults(x_trans_id) &", Amount: $" & aryResults(x_amount) & "','Green','Payment',3,'AutoCharge','" & Request.ServerVariables("REMOTE_ADDR") & "','" & Date & " " & Time & "','" & rstTempPmt("RegistrantID") & "')"
 Else
   strSQL = "INSERT INTO RegComments (Comment, Color, Type, Priority, CreatedByUser, CreatedByIP, CreatedTimeStamp, RegistrantID) VALUES ('CC Charged Successfully, Authorization: " & aryResults(x_auth_code) & ", Transaction ID: " & aryResults(x_trans_id) & ", CVV2 Response: " & aryResults(x_cvv2_resp_code) & ", AVS Response: " & aryResults(x_avs_code) & ", Amount: $" & aryResults(x_amount) & "','Green','Payment',3,'AutoCharge','" & Request.ServerVariables("REMOTE_ADDR") & "','" & Date & " " & Time & "','" & rstTempPmt("RegistrantID") & "')"
 End If
 cnn.Execute(strSQL)
'--------------------------
ElseIf aryResults(x_response_code)=2 Then 'Declined
 If aryResults(x_amount)<0 Then
   strSQL = "INSERT INTO RegComments (Comment, Color, Type, Priority, CreatedByUser, CreatedByIP, CreatedTimeStamp, RegistrantID) VALUES ('CC Refund Declined, Transaction ID: " & aryResults(x_trans_id) &", Amount: $" & aryResults(x_amount) & "','Red','Payment',3,'AutoCharge','" & Request.ServerVariables("REMOTE_ADDR") & "','" & Date & " " & Time & "','" & rstTempPmt("RegistrantID") & "')"
 Else
   strSQL = "INSERT INTO RegComments (Comment, Color, Type, Priority, CreatedByUser, CreatedByIP, CreatedTimeStamp, RegistrantID) VALUES ('CC Charge Declined, Transaction ID: " & aryResults(x_trans_id) & ", CVV2 Response: " & aryResults(x_cvv2_resp_code) & ", AVS Response: " & aryResults(x_avs_code) & ", Amount: $" & aryResults(x_amount) & "','Red','Payment',3,'AutoCharge','" & Request.ServerVariables("REMOTE_ADDR") & "','" & Date & " " & Time & "','" & rstTempPmt("RegistrantID") & "')"
 End If
 cnn.Execute(strSQL)
'--------------------------
Else 'Error
 strSQL = "INSERT INTO RegComments (Comment, Color, Type, Priority, CreatedByUser, CreatedByIP, CreatedTimeStamp, RegistrantID) VALUES ('CC Error: " & EncodeString(aryResults(x_response_reason_text)) & "','Red','Payment',3,'AutoCharge','" & Request.ServerVariables("REMOTE_ADDR") & "','" & Date & " " & Time & "','" & rstTempPmt("RegistrantID") & "')"
 cnn.Execute(strSQL)
End If
'--------------------------
'Response.Write("Reponse Code: " & aryResults(x_response_code) & "<br>" & vbCrLf)
'Response.Write("Reason Code: " & aryResults(x_response_reason_code) & ", " & aryResults(x_response_reason_text) & "<br>" & vbCrLf)
'Response.Write("Authorization Code: " & aryResults(x_auth_code) & "<br>" & vbCrLf)
'Response.Write("Transaction ID: " & aryResults(x_trans_id) & "<br>" & vbCrLf)
'Response.Write("Amount: " & aryResults(x_amount) & "<br>" & vbCrLf)

ChargePayment = aryResults(x_response_code) & "^" & aryResults(x_response_subcode) & "^" & aryResults(x_response_reason_code) & "^" & EncodeString(aryResults(x_response_reason_text))

Set oEncryptor2 = Nothing
Set oWinHttp = Nothing

End Function
'----------------------
Function FF(byVal strName, byVal strValue)
  strTemp = ""
  If IsNull(strName) Then
    strName = ""
  End If
  If IsNull(strValue) Then
    strValue = ""
  End If
  strTemp = Server.URLEncode(strName) & "=" & Server.URLEncode(strValue)
  FF = strTemp
End Function

%>
