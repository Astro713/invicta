<!--METADATA TYPE="TypeLib" UUID="{B72DF063-28A4-11D3-BF19-009027438003}"-->
<%
Public Function Encrypt(strKey, strPlaintext)
  Randomize()
  '------
  Set CM = Server.CreateObject("Persits.CryptoManager")
  ' Set Context = CM.OpenContext("", vbTrue)
  Set Context = CM.OpenContextEx("Microsoft Enhanced RSA and AES Cryptographic Provider", "", vbTrue)
  ' Set key = Context.GenerateKeyFromPassword(strKey, calgSHA, calgDES, 64)
  Set key = Context.GenerateKeyFromPassword(strKey, calgSHA256, calgAES128)

  Set IVblob = CM.CreateBlob
  strIV = ""
  ' While (Len(strIV)<16)
  While (Len(strIV)<32)
    strIV = strIV & Right("00" & Hex((255-0+1)*Rnd+0), 2)
  Wend
  IVblob.Hex = strIV
  key.SetIV IVblob
  ' strIVLen = Right("00" & Hex(08), 2) '' 08 Bytes => 16 Chars HEX
  strIVLen = Right("00" & Hex(016), 2) '' 16 Bytes => 32 Chars HEX

  ' On Error Resume Next
  '------
  '------
  Set blob = key.EncryptText(strPlaintext)
  strEncryptedCode = blob.Hex
  strEncryptedCode = strIVLen & strIV & strEncryptedCode
  '------
  '------
  ' On Error Goto 0
  Set Blob = Nothing
  Set key = Nothing
  Set Context = Nothing
  Set CM = Nothing
  '------
  Encrypt = strEncryptedCode
End Function

Public Function Decrypt(strKey, strCipherText)

  '------
  intIVLen = Mid(strCipherText, 1, 2) '' Bytes
  intIVLen = Abs("&H" & intIVLen)
  intIVLen = intIVLen*2 '' Characters

  If Len(intIVLen)>0 Then
    strIV = Mid(strCipherText, 3, intIVLen)
  Else
    strIV = ""
  End If

  If (Len(strCipherText)-2-intIVLen) <= 0 Then
    strEncryptedInput = strCipherText
  Else
    strEncryptedInput = Mid(strCipherText, 1+2+intIVLen)
  End If

  '------
  Set CM = Server.CreateObject("Persits.CryptoManager")
  If intIVLen=16 Then
    Set Context = CM.OpenContext("", vbTrue)
    Set key = Context.GenerateKeyFromPassword(strKey, calgSHA, calgDES, 64)
  Else
    Set Context = CM.OpenContextEx("Microsoft Enhanced RSA and AES Cryptographic Provider", "", vbTrue)
    Set key = Context.GenerateKeyFromPassword(strKey, calgSHA256, calgAES128)
  End If

  '' Set up IV
  Set Hash = Context.CreateHash(calgSHA)
  Set IVblob = CM.CreateBlob
  IVblob.Hex = strIV
  key.SetIV IVblob
  Set Hash = Nothing

  ' On Error Resume Next

  Set Blob = CM.CreateBlob
  Blob.Hex = strEncryptedInput
  Decrypt = key.DecryptText(Blob)

  Set Blob = Nothing
  Set key = Nothing
  Set Context = Nothing
  Set CM = Nothing

End Function

%>
