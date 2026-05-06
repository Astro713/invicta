<!--#include file="Tools.asp"-->
<!--#include file="inifile.asp"-->
<%
IniFileLoad("physical=" & SearchIncludePath("_config.toml"))
strEmailSupport = IniFileValue("email|emailsupport")
strPaperSupport = IniFileValue("email|papersupport")
strWebSupport = IniFileValue("email|websupport")
strExhibitSupport = IniFileValue("email|exhibitorsupport")
strRegSupport = IniFileValue("email|regsupport")
strReviewSupport = IniFileValue("email|reviewsupport")
strHousingSupport = IniFileValue("email|housingsupport")
strCopyrightSupport = IniFileValue("email|copyrightsupport")
strSpecialSessionSupport = IniFileValue("email|specialsessionsupport")
strTutorialSupport = IniFileValue("email|tutorialsupport")
strConferenceName = IniFileValue("conference|conferencename")
strConferenceNameFull = IniFileValue("conference|conferencenamefull")
strShortConferenceName = IniFileValue("conference|conferencenameshort")
strHOPNum = IniFileValue("conference|hopnum")

strDSNName =   IniFileValue("database|dsnname")
strDSNUser =   IniFileValue("database|dsnuser")
strDSNUserRO = IniFileValue("database|dsnuserro")
strDSNPass =   IniFileValue("database|dsnpass")
strDSNPassRO = IniFileValue("database|dsnpassro")
strDSNServer = IniFileValue("database|dsnserver")
strConnStr = "Provider=SQLNCLI11;Server={" & strDSNServer & "};Database={" & strDSNName & "};UID={" & strDSNUser & "};PWD={"& strDSNPass & "};"
strConnStrRO = "Provider=SQLNCLI11;Server={" & strDSNServer & "};Database={" & strDSNName & "};UID={" & strDSNUserRO & "};PWD={" & strDSNPassRO & "};"

intStage = IniFileValue("general|stage")

strInspPassedField = IniFilevalue("database|insppassedfield")
strInspField = IniFilevalue("database|inspfield")
strInspPassedField_Review = IniFilevalue("database|insppassedfield_review")

strReviewerEncryptionCode = IniFilevalue("passwords|reviewerencryption")
strSessionChairEncryption = IniFilevalue("passwords|sessionchairencryption")
strMeetingConfirmPassword = strDSNName & strDSNPass & "MeetingConfirm"
strInvitationEncryptionCode = strDSNName & strDSNPass & "Invitation"
strPaymentPW = strDSNName & strDSNPass & "Payment"

strPublicationTitle = IniFilevalue("conference|publicationtitle")

strCCDSNName = IniFilevalue("database|ccdsnname")
strCCDSNUser = IniFilevalue("database|ccdsnuser")
strCCDSNPass = IniFilevalue("database|ccdsnpass")

strConferenceDate = IniFilevalue("conference|conferencedate")
strConferenceLocation = IniFilevalue("conference|conferencelocation")
strPayableTo = IniFilevalue("conference|payableto")

strTZID = IniFilevalue("conference|tzid")

strECFURL = IniFilevalue("ecf|ecfurl")
strECFCode = IniFilevalue("ecf|ecfcode")
strECFReturnURL = IniFilevalue("ecf|ecfreturnurl")

strFinePrintHTML = IniFilevalue("fineprint|regfineprinthtml")
strFinePrintText = IniFilevalue("fineprint|regfineprinttext")

strPatronFinePrintHTML = IniFilevalue("fineprint|patronfineprinttext")
strPatronFinePrintText = IniFilevalue("fineprint|patronfineprinttext")

strOriginalPropUploadPath=Server.MapPath(IniFilevalue("paths|originalpropuploadpath"))
strCrossRefPropUploadPath=Server.MapPath(IniFilevalue("paths|crossrefpropuploadpath"))
strPropUploadPath=Server.MapPath(IniFilevalue("paths|propuploadpath"))
strPropUploadPath2=IniFilevalue("paths|propuploadpath2")

strOriginalFinalUploadPath=Server.MapPath(IniFilevalue("paths|originalfinaluploadpath"))
strCrossRefFinalUploadPath=Server.MapPath(IniFilevalue("paths|crossreffinaluploadpath"))
strFinalUploadPath=Server.MapPath(IniFilevalue("paths|finaluploadpath"))
strFinalUploadPath2=IniFilevalue("paths|finaluploadpath2")

strNewSubmissionCutoffDate = IniFilevalue("dates|newsubmissioncutoffdate")
strRevisionCutoffDate = IniFilevalue("dates|revisioncutoffdate")
strSSSubmissionCutoffDate = IniFilevalue("dates|sssubmissioncutoffdate")
strSSRevisionCutoffDate = IniFilevalue("dates|ssrevisioncutoffdate")
strJournalSubmissionCutoffDate = IniFilevalue("dates|journalsubmissioncutoffdate")
strJournalRevisionCutoffDate = IniFilevalue("dates|journalrevisioncutoffdate")
strFullRevisionCutoffDate = IniFilevalue("dates|fullrevisioncutoffdate")

strSPCSubmissionCutoffDate = IniFilevalue("dates|spcsubmissioncutoffdate")
strSPCRevisionCutoffDate = IniFilevalue("dates|spcrevisioncutoffdate")
strSPCAdvisorDeadline = IniFilevalue("dates|spcadvisordeadline")
strSPCAdvisorDeadline_Print = IniFilevalue("dates|spcadvisordeadline_print")
strSPCPaperDeadline_Print = IniFilevalue("dates|spcpaperdeadline_print")

strRevisionExceptionPaperNums = IniFilevalue("dates|revisionexceptionpapernums")

strReviewDeadlineDate = IniFilevalue("dates|reviewdeadlinedate")
strReviewResultsDate = IniFilevalue("dates|reviewresultsdate")

bSecure = vbTrue
arySecurePages = Array("PatronReg.asp","ExhibitorInformation.asp", "AuthorInvitationLetter.asp", "ILR.asp", "Registration.asp","TutorialFileUpload.asp", "TutorialFileReceiver.asp")
strConfURL = IniFilevalue("web|confurl")
strBaseURL = IniFilevalue("web|baseurl")
strBaseURLS = IniFilevalue("web|baseurlsecure")

strPaperSubmitConfirmationEmailSender = IniFilevalue("web|papersubmitemailsender")
strPaperAttestConfirmationEmailSender = IniFilevalue("web|paperattestemailconfirmsender")
strRegConfirmationEmailSender = IniFilevalue("web|regconfirmationemailsender")

strInvitationGenURL = IniFilevalue("web|invitationgenurl")
strInvitationGenTempURL = IniFilevalue("web|invitatingenurltemp")

strReCaptchaSecret = IniFilevalue("keys|recaptchasecret")
strReCaptchaSitekey = IniFilevalue("keys|recaptchasitekey")

If InStr(1, Request.ServerVariables("SCRIPT_NAME"), "tempdev", 1)<>0 Then
  strRegistrationStartPath = strBaseURLS & "/TempDev/"
  strRegistrationStartURL = strBaseURLS & "/TempDev/RegistrationTest.asp"
  strPaymentCollectURL = strBaseURLS & "/TempDev/PayCollect.asp"
  strSPSuccessLink = strBaseURLS & "/TempDev/PaySuccess.asp"
  strSPBackLink = strBaseURLS & "/TempDev/PayAborted.asp"
  strSPFailLink = strBaseURLS & "/TempDev/PayFail.asp"
Else
  strRegistrationStartPath = strBaseURLS & ""
  strRegistrationStartURL = strBaseURLS & "/RegistrationTest.asp"
  strPaymentCollectURL = strBaseURLS & "/PayCollect.asp"
  strSPSuccessLink = strBaseURLS & "/PaySuccess.asp"
  strSPBackLink = strBaseURLS & "/PayAborted.asp"
  strSPFailLink = strBaseURLS & "/PayFail.asp"
End If

aryIEEEMemberGrades = Array("Associate Member", _
                            "Fellow", _
                            "Graduate Student Member", _
                            "Honorary Member", _
                            "Individual", _
                            "Life Fellow", _
                            "Life Member", _
                            "Life Senior", _
                            "Member", _
                            "SA Member", _
                            "Senior Member", _
                            "Student Member")

aryIEEEStudentGrades = Array("Graduate Student Member", _
                             "Student Member")

aryIEEELifeGrades = Array("Life Fellow", _
                          "Life Member", _
                          "Life Senior")

aryIEEEAllGrades = Array("Affiliate", _
                         "Associate Member", _
                         "Fellow", _
                         "Graduate Student Member", _
                         "Honorary Member", _
                         "Individual", _
                         "Life Fellow", _
                         "Life Member", _
                         "Life Senior", _
                         "Member", _
                         "SA Member", _
                         "Senior Member", _
                         "Student Member")



bAllowAuthorTitleChanges = vbTrue
strAuthorTitleChangesExceptions = "0"

strAdvanceCutoffDate = IniFilevalue("dates|advancecutoffdate")
strRegularCutoffDate = IniFilevalue("dates|regularcutoffdate")
strPatronAdvanceCutoffDate = IniFilevalue("dates|patronadvancecutoffdate")

strDarkLineColor = "#6c87ad" 'Odd-line color
strLightLineColor = "#89a7e1" 'Even-line color
strXDarkLineColor = "#fec60c" 'Table Header color
'strPageBackgroundColor = "#f0f0b0"
strPageBackgroundColor2 = "#b8d6ff" 'Page background

bTechChair_RawPapers = CBool(IniFileValue("review|techchair_rawpapers"))
bTPCMember_RawPapers = CBool(IniFileValue("review|tcso_rawpapers"))

strFileUploadPath = Server.MapPath("../Papers/Uploads")
%>
<!--#include file="CountryList.asp"-->
<!--#include file="BlockedCCAccess.asp"-->
<!--#include file="ChargeActive.prefs"-->
