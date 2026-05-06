<?php

function web_header($opt = [])
{
  /* 
  $depth => How deep into directories. Top level is 1
  $fn => File Name; The menu function checks the script name against this string to know what the current page is
  $header_extras; Inserted in the <head> section
  $container_class; The Bootstrap class for the main content container. Usually either 'container' or 'container-fluid'
  $auth_needed; (boolean), whether this page needs to show the login/logout and check logged-in status.
  */
  $wh_config = [
    'depth'=>1,
    'fn'=>null,
    'header_extras'=>null,
    'container_class'=>'container',
    'auth_needed'=>false,
    'ad_suppress'=>false,
  ];

  $wh_config = array_replace($wh_config, $opt);

  global $config;
  global $isLoggedIn;

  $css_name = strtolower($config['conference']['conferencenameshort']);
  $menu_text = draw_menu($wh_config['depth'], $wh_config['fn']);
  $conf_name = ($config['conference']['conferencename']);
  $conf_name_full = ($config['conference']['conferencenamefull']);
  $conf_location = ($config['conference']['conferencelocation']);
  $conf_dates = ($config['conference']['conferencedate']);

  $prefix = str_repeat('../', $wh_config['depth']-1);

  $h_authbar = '';
  //  Uncomment this section when login available.
  if ($wh_config['auth_needed'])
  {

    $request_uri = urlencode(filter_input(INPUT_SERVER, 'REQUEST_URI', FILTER_SANITIZE_URL));

    if ($isLoggedIn) {
        // $util->redirect("test.php");
        $button_html = "<form class='form-inline' action='{$prefix}{$config['auth']['logout_page']}' method='post'><input type='submit' class='btn btn-primary' name='logout' value='Logout' /><input type='hidden' name='r' value='{$request_uri}' /></form>";

        // Check if chair/manager or admin
        $auth = new Auth();
        if (
          $auth->checkAccessMask($auth->getMemberMaskByRegId($isLoggedIn), 12) ||
          $auth->isSessionChairOrManager($isLoggedIn)
          )
        {
          $button_html .= "<a href=\"mailto:sos@igarss2022.org?subject=IGARSS%20SOS\" target=\"_blank\" class=\"btn btn-info\">Session Chair/Manager SOS</a>";
        }
        $auth = null;        
    
        $virtual_start = new DateTimeImmutable($config['dates']['virtualstart']);
        $date_diff = $virtual_start->diff(new DateTime());
        if (true || ($date_diff->invert == 0))
        {
          $button_html .= "<a class=\"btn btn-success bg-success\" data-cms-api-url=\"api/klcc_redirect_login.php\" onclick=\"return getKLCCLogin(this, 'DJKJJ');\"  href=\"\">Enter Virtual KLCC</a>";
        }
        
        $button_html .= "<a class='btn btn-info' href='help.php'>Login Help</a>";
        $button_html .= "<form class='form-inline' action='{$prefix}dashboard.php'><input type='submit' class='btn btn-info' value='Dashboard' /></form>";
        // $button_html .= "<div class=\"nav-text ml-4\">{$config['conference']['conferencename']} Restricted Access</div>";
    }
    else
    {
        $button_html = "<form class='form-inline' action='{$config['auth']['login_page']}' method='post'><input type='submit' class='btn btn-primary' value='Login' /><input type='hidden' name='r' value='{$request_uri}' /></form>";
        $button_html .= "<a class='btn btn-info' href='help.php'>Login Help</a>";
        $button_html .= "<div class=\"nav-text ml-4\">{$config['conference']['conferencename']} Attendee Access</div>";
    }

    $h_authbar = <<<HTML

        <!-- Auth bar -->
        <nav id="auth-nav" class="navbar justify-content-between navbar-light bg-light border-bottom border-secondary py-2 my-0">
        <div class="container-fluid">
        {$button_html}
        </div>
        </nav>
      HTML;
  }

/*
  $adHTML = null;

  if (( rand(0, 99) <= 25) && !$wh_config['ad_suppress'])
  {
    global $db_PDO_options;
    // Connect to DB
    $conn = new PDO( db_PDO_makeConnString($config['database']['dsnserver'], $config['database']['dsnname']), $config['database']['dsnuserro'], $config['database']['dsnpassro'], $db_PDO_options);
    // Ads
    $q = "SELECT TOP 1 ImagePath, DestURL FROM Ads WHERE active=1 ORDER BY NewID()";
    $rstAd = $conn->query($q);
    $ad = $rstAd->fetch();
    $rstAd = null;

    if ($ad)
    {
      $imgPath = null;
      $destURL = null;
      if ($ad['ImagePath'])
      {
        $imgPath = "<img class=\"img-responsive w-100\" src=\"{$prefix}{$ad['ImagePath']}\" alt=\"\" />";
      }
      if ($ad['DestURL'])
      {
        if (substr($ad['DestURL'], 0, 4)=='http')
        {
          $ad_prefix = '';
        }
        else
        {
          $ad_prefix = $prefix;
        }
        $destURL = "<a href onclick=\"window.open('{$ad_prefix}{$ad['DestURL']}', '_blank'); return false;\">{$imgPath}</a>";
      }
      $adHTML = <<<HTM
      <div class="container">
        <div class="row">
          <div class="col">
            <div class="adv my-2">
              {$destURL}
            </div>
          </div>
        </div>
      </div>
HTM;
    }
  }
*/
$h_out = <<<HTML
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="keywords" content="IGARSS 2022 Kuala Lumpur Malaysia">
  <meta name="description" content="IGARSS 2022 Kuala Lumpur Malaysia">
  <meta name="format-detection" content="telephone=no">
  <meta name="author" content="">

  <title>IEEE {$conf_name} || {$conf_location} || {$conf_dates}</title>

  <!-- Global site tag (gtag.js) - Google Analytics -->
  <script async src="https://www.googletagmanager.com/gtag/js?id={$config['web']['googletag']}"></script>
  <script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());

    gtag('config', '{$config['web']['googletag']}');
  </script>

  <!-- jQuery -->
  <script src="{$prefix}js/jquery-3.5.1.min.js"></script>
  <!-- Bootstrap core CSS -->
  <script src="{$prefix}js/bootstrap.bundle.min.js"></script>
  <script src="{$prefix}js/popper.min.js"></script>
  <script src="{$prefix}js/cms-virtual.js"></script>
  <script src="{$prefix}js/{$css_name}.js"></script>

  <link href="{$prefix}css/bootstrap.min.css" rel="stylesheet">
  <link href="{$prefix}css/bootstrap-icons.css" rel="stylesheet">
  <link href="{$prefix}css/all.min.css" rel="stylesheet">
  <link href="{$prefix}css/other.css" rel="stylesheet">
  <!--<link rel="stylesheet" href="https://github.hubspot.com/odometer/themes/odometer-theme-digital.css" />-->
  {$wh_config['header_extras']}
  
  <!-- Custom styles for this template -->
  <link href="{$prefix}css/{$css_name}.css" rel="stylesheet" type="text/css" />
  
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
<header class="page-header cms-header cms-header-01">
<nav class="navbar navbar-expand-xl navbar-dark fixed-top bg-dark navbar-ig21 py-0">
  <div class="container-fluid">
    <a class="navbar-brand" href="{$prefix}index.php">IEEE {$conf_name}</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse justify-content-stretch" id="navbarCollapse">
      {$menu_text}
    </div>
  </div>
</nav>




<!-- For Desktop -->
<div class="container-fluid cms-info d-none d-lg-block px-0">
  <div class="row mx-0 align-items-center justify-content-center cms-info-top bg-light">

    <div class="col-auto px-5">
      <img class="img-fluid mb-3" style="width: 15rem;" src="images/IGARSS2023_Logo.svg">
    </div>

    <div class="col">
      <div class="header-image-text">
        <h1>{$conf_name_full}</h1>
        <h2>{$conf_dates} &bull; {$conf_location}</h2>
      </div>
    </div>

    <div class="col-auto px-5  align-self-center">
      <div class="row">
        <div class="col-auto mx-auto"><img class="img-fluid mb-3" style="width: 12rem;" src="images/GRSS_Logo.svg"></div>
      </div>
      <div class="row">
        <div class="col-auto mx-auto"><img class="img-fluid mb-3" style="width: 15rem;" src="images/IEEELogo.svg"></div>
      </div>
      <br>
    </div>

  </div>
</div><!--/container-fluid-->

<!-- For Mobile -->
<div class="container-fluid cms-info cms-narrow d-lg-none bg-light px-0">
  <div class="row mx-0 align-items-center bg-ieee-bright">
    <div class="col">
      <div class="header-image-text">
        <h1>{$conf_name_full}</h1>
        <h2>{$conf_dates} &bull; {$conf_location}</h2>
      </div>
    </div>
  </div><!--/row-->
</div><!--/container-fluid-->

{$h_authbar}
</header>

<!-- Page Content -->
<div class="{$wh_config['container_class']} cms-main" id="cms-container">
  <div class="row">
    <div class="col">

      
    </div><!--/col-->
  </div><!--/row-->
HTML;
  echo $h_out;

}

?>