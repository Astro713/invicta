<%
' THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT
' WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
' INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES
' OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
' PURPOSE.

' Copyright 2000 - 2001. All rights reserved.
' Lewis Moten
' http://www.lewismoten.com
' email: lewis@moten.com

' If you use this code on your site and wish to be listed
' as one of the sites on my webpage that use my code, please
' email me the URL, Title, a short description, and a 100x30 
' image button if you have one.

' I ask that you please help me promote my site in
' exchange. This can be done simply by sending a friend
' of yours an email, posting a link on your site to mine,
' or even posting a message in a news group, forum, IRC, etc.
' You can even do it by nominating it for sites that give
' out awards. If do help me, plese make the link go back
' to my home page at http://www.lewismoten.com
' ------------------------------------------------------------------------------
Function ValidateCreditCard(ByRef pStrNumber, ByRef pStrType)
    
    ValidateCreditCard = False ' Initialize negative results
    
    ' Clean Credit Card Number (Removes dashes and spaces)
    pStrNumber = ParseDigits(pStrNumber)
    
    ' Validate number with LUHN Formula
    If Not LUHN(pStrNumber) Then Exit Function
    
    ' Apply rules based on type of card
    Select Case pStrType
        Case "American Express"
            Select Case Left(pStrNumber, 2)
                Case "34", "37"
                    ' Do Nothing
                Case Else
                    Exit Function
            End Select
            If Not Len(pStrNumber) = 15 Then Exit Function
        Case "Diners Club"
            Select Case Left(pStrNumber, 2)
                Case "30" ,"36" , "38"
                    ' Do Nothing
                Case Else
                    Exit Function
            End Select
            If Not Len(pStrNumber) = 14 Then Exit Function
        Case "Discover"
            If Not Left(pStrNumber, 4) = "6011" Then Exit Function
            If Not Len(pStrNumber) = 16 Then Exit Function
        Case "JCB"
            If Left(pStrNumber, 1) = "3" And Len(pStrNumber) = 16 Then
                ' Do Nothing
            ElseIf Left(pStrNumber, 14) = "2131" And Len(pStrNumber) = 15 Then
                ' Do Nothing
            ElseIf Left(pStrNumber, 14) = "1800" And Len(pStrNumber) = 15 Then
                ' Do Nothing
            Else
                Exit Function
            End If
        Case "Mastercard"
            Select Case Left(pStrNumber, 2)
                Case "51", "52", "53", "54", "55"
                    ' Do Nothing
                Case Else
                    Exit Function
            End Select
            If Not Len(pStrNumber) = 16 Then Exit Function
        Case "Visa"
            If Not Left(pStrNumber, 1) = "4" Then Exit Function
            If Not (Len(pStrNumber) = 13 Or Len(pStrNumber) = 16) Then Exit Function
        Case Else
            ' Unknown Card Type
            Exit Function
    End Select
    
    ' We got this far so the number passed all the rules!
    ValidateCreditCard = True
    
End Function
' ------------------------------------------------------------------------------
Function LUHN(ByRef pStrDigits)
    
    Dim lLngMaxPosition
    Dim lLngPosition
    Dim lLngSum                ' Sum of all positions
    Dim lLngDigit            ' Current digit in specified position
    
    ' Initialize
    lLngMaxPosition = Len(pStrDigits)
    lLngSum = 0
    
    ' Read from right to left
    For lLngPosition = lLngMaxPosition To 1 Step -1
        
        ' If we are working with an even digit (from the right)
        If (lLngMaxPosition - lLngPosition) Mod 2 = 0 Then
        
            lLngSum = lLngSum + CInt(Mid(pStrDigits, lLngPosition, 1))
        
        Else
        
            ' Double the digit
            lLngDigit = CInt(Mid(pStrDigits, lLngPosition, 1)) * 2
            
            ' shortcut adding sum of digits
            If lLngDigit > 9 Then lLngDigit = lLngDigit - 9
            
            lLngSum = lLngSum + lLngDigit
            
        End If
    Next

    ' A mod 10 check must not return any remainders
    LUHN = lLngSum Mod 10 = 0

End Function
' ------------------------------------------------------------------------------
Function ParseDigits(ByRef pStrData)
    
    ' Strip all the numbers from a string
    ' (cleans up dashes and spaces)
    
    Dim lLngMaxPosition
    Dim lLngPosition
    
    lLngMaxPosition = Len(pStrData)
    
    For lLngPosition = 1 To lLngMaxPosition
        If IsNumeric(Mid(pStrData, lLngPosition, 1)) Then
            ParseDigits = ParseDigits & Mid(pStrData, lLngPosition, 1)
        End If
    Next

End Function
' ------------------------------------------------------------------------------
%>