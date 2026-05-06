<!--#include file="_config.asp" -->
<%
  bSecure = vbTrue
  url = Request.ServerVariables("URL")
  For Each tURL in arySecurePages
    If InStr(1, url, tURL, 1)>0 Then
      bSecure = vbTrue
    End If
  Next
  If bSecure Then
    If Not(StrComp(Request.ServerVariables("HTTPS"),"on",1)=0) Then
      strURL = strBaseURLS & url
      If Len(Request.ServerVariables("QUERY_STRING"))>0 Then
        strQS = "?" & Request.ServerVariables("QUERY_STRING")
      Else
        strQS = ""
      End If
      Response.Redirect(strURL & strQS)
    End If
  Else
    If (StrComp(Request.ServerVariables("HTTPS"),"on",1)=0) Then
      index = InStr(2, url, "/")
      trunc = Right(url, Len(url)-index)
      strURL = strBaseURL & trunc
      If Len(Request.ServerVariables("QUERY_STRING"))>0 Then
        strQS = "?" & Request.ServerVariables("QUERY_STRING")
      Else
        strQS = ""
      End If
      Response.Redirect(strURL & strQS)
    End If
  End If
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->  <title><%=strConferenceName%> | <%=strConferenceNameFull%> | <%=strConferenceDate%> | <%=strConferenceLocation%></title>
    
    <!-- jQuery -->
    <script src="js/jquery-3.4.0.min.js"></script>
    <!-- Bootstrap core JS -->
    <script src="js/bootstrap.bundle.min.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/bs-custom-file-input.min.js"></script>
    
    <script src="js/paymentform.js"></script>
    <!-- Bootstrap core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/other.css" rel="stylesheet">
    <link href="css/ig20.css" rel="stylesheet">
    <%=strHeaderExtras%>
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <script src="https://s3-us-west-2.amazonaws.com/ieeeshutpages/gdpr/settings.js"></script>
  <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.0.3/cookieconsent.min.css" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.0.3/cookieconsent.min.js"></script>
  <script>
  window.addEventListener("load", function(){
   window.cookieconsent.initialise(json)
  });
  </script>
</head>

  <body>

    <!-- Fixed navbar -->
    
    
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top bg-dark py-0">
        <a class="navbar-brand" href="default.asp">IEEE IGARSS 2020</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-stretch" id="navbarCollapse">
            
        <ul class="navbar-nav mr-auto">


        <li class="nav-item dropdown">
        <a href="#" class="nav-link dropdown-toggle active " data-toggle="dropdown">General</a>
        <div class="dropdown-menu"> 
        <a href="default.asp" class="dropdown-item  active ">Home</a>
        <a href="CallForPapers.asp" class="dropdown-item ">Call for Papers</a>
        <a href="OrganizingCommittee.asp" class="dropdown-item ">Organizing Committee</a>
        <a href="Contacts.asp" class="dropdown-item ">Contacts</a>
        <a href="PrivacyNonDiscrimination.asp" class="dropdown-item ">Privacy and Non-Discrimination</a>
        </div>
        </li>



        <li class="nav-item dropdown">
        <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown">Program</a>
        <div class="dropdown-menu"> 
        <a href="InvitedSessionProposals.asp" class="dropdown-item ">Invited Session Proposals</a>
        <a href="TutorialProposals.asp" class="dropdown-item ">Tutorial Proposals</a>
        </div>
        </li>



        <li class="nav-item dropdown">
        <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown">For Authors</a>
        <div class="dropdown-menu"> 
        <a href="ImportantDates.asp" class="dropdown-item ">Important Dates</a>
        <a href="Papers.asp" class="dropdown-item ">Paper Submission</a>
        <a href="StudentPaperCompetition.asp" class="dropdown-item ">Student Paper Competition</a>
        <a href="StudentTravelSupport.asp" class="dropdown-item ">Student Travel Support</a>
        </div>
        </li>



        <li class="nav-item dropdown">
        <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown">Exhibits &amp; Sponsors</a>
        <div class="dropdown-menu"> 
        <a href="Exhibition.asp" class="dropdown-item ">Exhibition</a>
        <a href="SponsorshipOpportunities.asp" class="dropdown-item ">Sponsorship Opportunities</a>
        </div>
        </li>



        <li class="nav-item dropdown">
        <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown">Travel &amp; Venue</a>
        <div class="dropdown-menu"> 
        <a href="Venue.asp" class="dropdown-item ">Conference Venue</a>
        <a href="Hotels.asp" class="dropdown-item ">Conference Hotels</a>
        <a href="Travel.asp" class="dropdown-item ">Travel</a>
        </div>
        </li>



        </ul>
        </div>
    </nav>


    <header class="page-header ig20-header ig20-header-02">

    <div class="container-fluid ig20-info d-none d-lg-block">
        <div class="row align-items-center">

        <div class="col-3">
            <a href="https://ieee.org/"><img id="header_ieeelogo" src="images/IEEELogoW.svg" alt="Institute of Electrical and Electronics Engineers (IEEE)" class="img-fluid header_ieeelogo" /></a>
        </div><!--/col-->
        <div class="col-7 text-center">
            <img id="ig20_logo" src="images/IG20_LogoWbg.svg" alt="IGARSS 2020 &bull; July 19 &ndash; 24, 2020 &bull; Waikoloa, Hawaii, USA" class="img-fluid align-top mx-auto header_ig20logo" />
        </div><!--/col-->
        <div class="col-2">
            <a href="https://grss-ieee.org/"><img id="header_grsslogo" src="images/GRSS_Logo_White.svg" alt="IEEE Geoscience and Remote Sensing Society (GRSS)" class="img-fluid align-bottom py-3 header_grsslogo" /></a>
        </div><!--/col-->

        </div><!--/row-->
        <div class="row align-items-center">
        <div class="col text-center">
            <h2>2020 IEEE International Geoscience and Remote Sensing Symposium</h2>
            <h4>July 19 &ndash; 24, 2020 &bull; Waikoloa, Hawaii, USA</h4>
        </div><!--/col-->
        </div><!--/row-->
    </div><!--/container-fluid-->
    <!-- For Mobile -->
    <div class="container-fluid ig20-info ig20-narrow d-lg-none">
        <div class="row align-items-center">
        <div class="col">
            <h2>2020 IEEE International Geoscience and Remote Sensing Symposium</h2>
            <h4>July 19 &ndash; 24, 2020 &bull; Waikoloa, Hawaii, USA</h4>
        </div><!--/col-->
        </div><!--/row-->
    </div><!--/container-fluid-->
    </header>
  


    <div class="container">
    <!-- Begin page content -->
