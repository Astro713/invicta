<%
Function SendConfirmationEmail(byVal intRegID, byVal intPmtID, byRef strContent)

  Dim rstReg, rstPmt, rstItem, rstTemp, intPaymentID, oEncryptor, strCCEncrypt, BodyText, cnn

  Set cnn = Server.CreateObject("ADODB.Connection")
  cnn.Open strConnStr

  Set oEncryptor = Server.Createobject("Dynu.Encrypt")
  strCCEncrypt = strConferenceName & "nowait445"

  Set rstReg = cnn.Execute("SELECT * FROM Registrants WHERE RegistrantID='" & EncodeString(intRegID) & "'")
  If IsNull(intPmtID) Then
    intPaymentID = 0
  Else
    intPaymentID = intPmtID
  End If

  If intPaymentID=0 Then
    Set rstPmt = cnn.Execute("SELECT * FROM Payments WHERE RegistrantID='" & EncodeString(rstReg("RegistrantID")) & "' ORDER BY PaymentID DESC")
  Else
    Set rstPmt = cnn.Execute("SELECT * FROM Payments WHERE PaymentID='" & EncodeString(intPaymentID) & "' ORDER BY PaymentID ASC")
  End If

  If intPaymentID=0 Then
    Set rstItems = cnn.Execute("SELECT RegItems.*, RegRates.* FROM RegItems INNER JOIN RegRates ON RegItems.RegItemID=RegRates.RegItemID WHERE RegItems.RegistrantID='" & EncodeString(rstReg("RegistrantID")) & "' ORDER BY RegItems.PaymentID, RegItems.ItemID")
  Else
    Set rstItems = cnn.Execute("SELECT RegItems.*, RegRates.* FROM RegItems INNER JOIN RegRates ON RegItems.RegItemID=RegRates.RegItemID WHERE RegItems.RegistrantID='" & EncodeString(rstReg("RegistrantID")) & "' AND RegItems.PaymentID='" & EncodeString(rstPmt("PaymentID")) & "' ORDER BY RegItems.ItemID")
  End If
  ' Set rstTemp = cnn.Execute("EXECUTE PaymentAmountDue @s_PaymentID=" & rstPmt("PaymentID"))


  'Generate Invitation Letter URL
  Set CM = Server.CreateObject("Persits.CryptoManager")
  Set Context = CM.OpenContext("", vbTrue)
  Set key = Context.GenerateKeyFromPassword(strInvitationEncryptionCode, calgSHA, calgDES, 64)

  Set blob = key.EncryptText(rstReg("RegistrantID") & ":" & Trim(rstReg("Password")))
  strEncryptedCode = blob.Hex

  If InStr(1, Request.ServerVariables("SCRIPT_NAME"), "tempdev", 1)<>0 Then
    strInvitationURL = strInvitationGenTempURL
  Else
    strInvitationURL = strInvitationGenURL
  End If
  strInvitationURLFull = strInvitationURL & "?q=" & strEncryptedCode

  Set blob = Nothing
  Set key = Nothing
  Set Context = Nothing
  Set CM = Nothing

  ' Send Email Confirmation:
  BodyText = "This email was automatically sent to you upon completion of the " & DecodeString(strConferenceName) & " Registration process." & vbCrLf
  BodyText = BodyText & vbCrLf
  BodyText = BodyText & "Registration Receipt" & vbCrLf
  BodyText = BodyText & vbCrLf
  BodyText = BodyText & "If you need to make a correction, addition, or cancellation, please reply to this email." & vbCrLf
  BodyText = BodyText & vbCrLf
  BodyText = BodyText & "Sold By: IEEE International, LLC" & vbCrLf
  BodyText = BodyText & "445 Hoes Lane" & vbCrLf
  BodyText = BodyText & "Piscataway - USA" & vbCrLf
  BodyText = BodyText & "" & vbCrLf
  BodyText = BodyText & "All fees include 8% JCT (Japan Consumption Tax), pursuant to Japan law." & vbCrLf
  BodyText = BodyText & "" & vbCrLf
  BodyText = BodyText & vbCrLf & "Confirmation Number: " & rstReg("RegistrantID")
  BodyText = BodyText & vbCrLf & "TimeStamp: " & rstReg("CreatedTimeStamp")
  BodyText = BodyText & vbCrLf & vbCrLf & "Registration details:" & vbCrLf & "---------------" & vbCrLf
  BodyText = BodyText & vbCrLf & "First (Personal) Name: " & DecodeToText(rstReg("NameFirst"))
  BodyText = BodyText & vbCrLf & "Middle Name: " & DecodeToText(rstReg("NameMiddle"))
  BodyText = BodyText & vbCrLf & "Last (Family) Name: " & DecodeToText(rstReg("NameLast"))
  BodyText = BodyText & vbCrLf & "Name on Badge: " & DecodeToText(rstReg("NameBadge"))
  BodyText = BodyText & vbCrLf & "Phone: " & DecodeToText(rstReg("Phone"))
  BodyText = BodyText & vbCrLf & "Fax: " & DecodeToText(rstReg("Fax"))
  BodyText = BodyText & vbCrLf & "Email Address: " & DecodeToText(rstReg("Email"))
  BodyText = BodyText & vbCrLf & "Affiliation: " & DecodeToText(rstReg("Affiliation"))
  BodyText = BodyText & vbCrLf & "Title: " & DecodeToText(rstReg("Title"))
  BodyText = BodyText & vbCrLf & "Dept.: " & DecodeToText(rstReg("Department"))
  BodyText = BodyText & vbCrLf & "Address 1: " & DecodeToText(rstReg("AddressStreet1"))
  BodyText = BodyText & vbCrLf & "Address 2: " & DecodeToText(rstReg("AddressStreet2"))
  BodyText = BodyText & vbCrLf & "City: " & DecodeToText(rstReg("AddressCity"))
  BodyText = BodyText & vbCrLf & "State: " & DecodeToText(rstReg("AddressState"))
  BodyText = BodyText & vbCrLf & "Zip Code: " & DecodeToText(rstReg("AddressZip"))
  BodyText = BodyText & vbCrLf & "Country: " & DecodeToText(rstReg("AddressCountry"))
  If Len(rstReg("SpecialNeeds"))>0 Then
  BodyText = BodyText & vbCrLf
  BodyText = BodyText & vbCrLf & "Special Needs: " & DecodeToText(rstReg("SpecialNeeds"))
  End If
  If Len(rstReg("PresentPaperList"))>1 Then
  BodyText = BodyText & vbCrLf
  BodyText = BodyText & "Papers presenting: " & rstReg("PresentPaperList") & vbCrLf
  BodyText = BodyText & "" & vbCrLf
  BodyText = BodyText & "Registration Confirmation Number: " & rstReg("RegistrantID") & vbCrLf
  BodyText = BodyText & "Registration Access Code: " & Trim(rstReg("Password")) & vbCrLf
  BodyText = BodyText & "" & vbCrLf
  BodyText = BodyText & "To be published in the IEEE " & strConferenceName & " Conference Proceedings and IEEE Xplore®, an author of an accepted paper is required to register for the conference and the paper must be presented by an author of that paper at the conference unless the TPC Chair grants permission for a substitute presenter arranged in advance of the event and who is qualified both to present and answer questions. Accepted and presented papers will be published in the IEEE " & strConferenceName & " Conference Proceedings and submitted to IEEE Xplore®." & vbCrLf
  End If

  BodyText = BodyText & "" & vbCrLf
  BodyText = BodyText & "Registration Confirmation Number: " & rstReg("RegistrantID") & vbCrLf
  BodyText = BodyText & "Password: " & Trim(rstReg("Password")) & vbCrLf

  BodyText = BodyText & "" & vbCrLf
  BodyText = BodyText & "== Invitation Letter / Visa Request ==" & vbCrLf
  BodyText = BodyText & "If you would like our visa support to enter Japan, you may request it by emailing visa@igarss2019.org. The visa application form will be available to attendees that complete a registration and submit payment. More details are found at " & strBaseURLS & "Visa.asp" & vbCrLf
  BodyText = BodyText & "" & vbCrLf
  BodyText = BodyText & "== List of Items Purchased ==" & vbCrLf

  intAmtDue = 0
  ' rstPmt.MoveFirst
  Do While Not rstPmt.EOF
  BodyText = BodyText & vbCrLf
  BodyText = BodyText & "----------------"

  Set rstItem = cnn.Execute("SELECT RegItems.*, RegRates.* FROM RegItems INNER JOIN RegRates ON RegItems.RegItemID=RegRates.RegItemID WHERE PaymentID='" & rstPmt("PaymentID") & "' ORDER BY RegItems.ItemID")

  Do While Not rstItem.EOF
  If rstItem("Refund") Then
    strDescription = "Refund: " & DecodeToText(rstItem("ShortName"))
    strPrice = FormatNumber(-1*(rstItem("Rate")-rstItem("Discount")),2,-1,0,-1)
    strExtPrice = FormatNumber(-1*rstItem("Quantity")*(rstItem("Rate")-rstItem("Discount")),2,-1,0,-1)
    intAmtDue = intAmtDue + (-1*rstItem("Quantity")*(rstItem("Rate")-rstItem("Discount")))
    BodyText = BodyText & vbCrLf & "" & DecodeToText(strDescription) & ", Qty. " & rstItem("Quantity") & ", Price: US$ " & strExtPrice & vbCrLf
  ElseIf rstItem("Deleted") Then
    strDescription = DecodeToText(rstItem("ShortName")) & " (Deleted)"
    strPrice = FormatNumber((rstItem("Rate")-rstItem("Discount")),2,-1,0,-1)
    strExtPrice = FormatNumber(rstItem("Quantity")*(rstItem("Rate")-rstItem("Discount")),2,-1,0,-1)
    intAmtDue = intAmtDue + (rstItem("Quantity")*(rstItem("Rate")-rstItem("Discount")))
    BodyText = BodyText & vbCrLf & "" & DecodeToText(strDescription) & ", Qty. " & rstItem("Quantity") & ", Price: US$ " & strExtPrice & vbCrLf
  Else
    strDescription = DecodeToText(rstItem("ShortName"))
    strPrice = FormatNumber((rstItem("Rate")-rstItem("Discount")),2,-1,0,-1)
    strExtPrice = FormatNumber(rstItem("Quantity")*(rstItem("Rate")-rstItem("Discount")),2,-1,0,-1)
    intAmtDue = intAmtDue + (rstItem("Quantity")*(rstItem("Rate")-rstItem("Discount")))
    BodyText = BodyText & vbCrLf & "" & DecodeToText(strDescription) & ", Qty. " & rstItem("Quantity") & ", Price: US$ " & strExtPrice & vbCrLf
  End If
  strQuantity = rstItem("Quantity")
  rstItem.MoveNext
  Loop

  BodyText = BodyText & "----------------" & vbCrLf
  BodyText = BodyText & vbCrLf

  Set rstTemp = cnn.Execute("EXECUTE PaymentAmountDue @s_PaymentID=" & rstPmt("PaymentID"))
  BodyText = BodyText & vbCrLf & "Amt Due (this payment): US$ " & FormatNumber(rstTemp("AmtDue"),2,-1,0,-1) & "" & vbCrLf
    BodyText = BodyText & vbCrLf & "Method of Payment: " & DecodeToText(rstPmt("PaymentMethod")) & vbCrLf
    If (rstPmt("PaymentMethod")="Credit Card") Then
      BodyText = BodyText & "Credit Card Type: " & DecodeToText(rstPmt("CCType")) & ",  Account: ..." & DecodeToText(Right(oEncryptor.Decrypt(rstPmt("CCNumber"),strCCEncrypt),4)) & vbCrLf
      BodyText = BodyText & "If a credit card was used to pay registration fees, the charge will appear on your bill as ""IEEE WEB REGISTRATION""." & vbCrLf
    ElseIf (rstPmt("PaymentMethod")="Check") Then
      BodyText = BodyText & "Account Holder's Name: " & DecodeToText(rstPmt("CKName")) & ", Check Number: " & DecodeToText(rstPmt("CKNumber")) & vbCrLf
      ' BodyText = BodyText & "IEEE's Federal Tax ID Number: 13-1656633" & vbCrLf
      BodyText = BodyText & "" & vbCrLf
      BodyText = BodyText & "Make checks payable to '" & strPayableTo & "' and mail to:" & vbCrLf
      BodyText = BodyText & strConferenceName & " Registration" & vbCrLf
      BodyText = BodyText & "c/o Conference Management Services" & vbCrLf
      BodyText = BodyText & "2711 Pierre PL" & vbCrLf
      BodyText = BodyText & "College Station, TX 77845" & vbCrLf
      BodyText = BodyText & "USA" & vbCrLf
      BodyText = BodyText & "" & vbCrLf
      BodyText = BodyText & "Please include '" & strConferenceName & "' and the Registration Confirmation (" & rstReg("RegistrantID") & ") on the Memo line of the check." & vbCrLf
    ElseIf (rstPmt("PaymentMethod")="Money Order") Then
      BodyText = BodyText & "Account Holder's Name: " & DecodeToText(rstPmt("CKName")) & ", Money Order Number: " & DecodeToText(rstPmt("CKNumber")) & vbCrLf
      ' BodyText = BodyText & "IEEE's Federal Tax ID Number: 13-1656633" & vbCrLf
      BodyText = BodyText & "" & vbCrLf
      BodyText = BodyText & "Make checks payable to '" & strPayableTo & "' and mail to:" & vbCrLf
      BodyText = BodyText & strConferenceName & " Registration" & vbCrLf
      BodyText = BodyText & "c/o Conference Management Services" & vbCrLf
      BodyText = BodyText & "2711 Pierre PL" & vbCrLf
      BodyText = BodyText & "College Station, TX 77845" & vbCrLf
      BodyText = BodyText & "USA" & vbCrLf
    ElseIf (rstPmt("PaymentMethod")="Wire Transfer") Then
      BodyText = BodyText & "You will need the information below in order to initiate the wire transfer with your bank." & vbCrLf
      BodyText = BodyText & "" & vbCrLf
      BodyText = BodyText & "Bank Name: Wells Fargo Bank" & vbCrLf
      BodyText = BodyText & "Branch Name: Main Banking Office" & vbCrLf
      BodyText = BodyText & "Branch Address: 123 South Broad Street, Philadelphia, PA 19109" & vbCrLf
      BodyText = BodyText & "Account Name: Institute of Electrical and Electronics Engineers" & vbCrLf
      BodyText = BodyText & "Account #: " & "21570000000" & strHOPnum & "" & vbCrLf
      BodyText = BodyText & "ABA#: 121000248" & vbCrLf
      BodyText = BodyText & "Swift Address: WFBIUS6S" & vbCrLf
      BodyText = BodyText & "" & vbCrLf
      BodyText = BodyText & "Please be sure to include your FULL name, event/meeting name (" & strConferenceName & "), and registration number (four-digits) in the description of your bank (wire) transfer. *If the requested information is not included, then it could take 30 days or more to confirm payment was received.*" & vbCrLf
      BodyText = BodyText & "" & vbCrLf
      BodyText = BodyText & "Please provide us with documentation that the bank transfer has been processed. You may send us the confirmation either via fax (+1-979-846-6900) or e-mail  (wiretransfers@cmsworldwide.com - INCLUDE THE CONFERENCE NAME AND YOUR REGISTRATION CONFIRMATION NUMBER IN THE SUBJECT LINE). Once IEEE has confirmed successfully receiving your electronic transaction, an e-mail confirmation and PDF registration receipt will be sent for your records." & vbCrLf
    Else
    End If

  rstPmt.MoveNext
  Loop
  BodyText = BodyText & vbCrLf & "----------------"
  BodyText = BodyText & vbCrLf & "Total Cost: US$ " & FormatNumber(intAmtDue,2,-1,0,-1) & ""

  BodyText = BodyText & vbCrLf & "----------------" & vbCrLf
  BodyText = BodyText & strFinePrintText & vbCrLf
  BodyText = BodyText & "" & vbCrLf
  BodyText = BodyText & "IEEE Privacy Policy" & vbCrLf
  BodyText = BodyText & "https://www.ieee.org/security-privacy.html" & vbCrLf
  BodyText = BodyText & "" & vbCrLf
  BodyText = BodyText & "IEEE Event Terms & Conditions" & vbCrLf
  BodyText = BodyText & "https://www.ieee.org/conferences/event-terms-and-conditions.html" & vbCrLf
  BodyText = BodyText & "" & vbCrLf
  BodyText = BodyText & "Thank you for participating in " & DecodeString(strConferenceName) & "." & vbCrLf & vbCrLf & "-------------" & vbCrLf & "Conference Management Services, Inc." & vbCrLf & strRegSupport & vbCrLf & "phone: +1-979-846-6800 (USA)" & vbCrLf & "fax: +1-979-846-6900 (USA)" & vbCrLf & strBaseURLS

  strContent = BodyText

  Set Mail = Server.CreateObject("Persits.MailSender")
  Mail.Queue = vbTrue
  Mail.CharSet = "UTF-8"
  Mail.ContentTransferEncoding = "Quoted-Printable"

  strFromAddress = strRegSupport
  strFromName = strConferenceName & " Registration"
  strCCAddress = strRegSupport
  If (Request.Form("InvoiceOnly")=0) Then
    strSubject = DecodeString(strConferenceName) & " Registration Confirmation: " & rstReg("RegistrantID")
  Else
    strSubject = DecodeString(strConferenceName) & " Invoice Confirmation: " & rstReg("RegistrantID")
  End If
  strToAddress = ""
  aryAddresses = Split(DecodeToText(rstReg("Email")), ",")
  For Each Addr In aryAddresses
  aryTemp = Split(Addr,";")
  For Each Addr2 In aryTemp
    If Mail.ValidateAddress(Trim(Addr2))=0 Then
      Mail.AddAddress Trim(Addr2)
    End If
  Next
  Next

  Mail.From = strFromAddress
  Mail.FromName = strFromName
  Mail.Subject = strSubject
  'Mail.Priority = 1 '1=high 3=normal 5=low
  'Mail.AddReplyTo strReplyToAddress
  Mail.AddBCC strCCAddress

  Mail.Body = BodyText
  Mail.Send

  Set Mail = Nothing
  cnn.Close
  Set cnn = Nothing
End Function

%>
