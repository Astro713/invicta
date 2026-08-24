<?php

function web_header($opt = [])
{
  /* 
  depth => How deep into directories. Top level is 1
  fn => File Name; The menu function checks the script name against this string to know what the current page is
  header_extras; Inserted in the <head> section
  container_class; The Bootstrap class for the main content container. Usually either 'container' or 'container-fluid'
  auth_needed; (boolean), whether this page needs to show the login/logout and check logged-in status.
  ad_suppress; (boolean), stop banner ads from showing up
  slider_class; css class of slider/carousel container
  slider_name; 
  */
  $wh_config = [
    'return'=>false,
    'depth'=>1,
    'fn'=>null,
    'page_title'=>null,
    'meta_description'=>'Invicta Cane Corso is a Cane Corso breeding program in Cypress, Texas, serving Greater Houston with thoughtfully raised dogs and updates on planned litters.',
    'canonical_path'=>null,
    'og_image'=>'/images/invicta_logo_master.png',
    'header_extras'=>null,
    'container_class'=>'container',
    'auth_needed'=>false,
    'ad_suppress'=>true,
    'slider_class'=>'innerSlider',
    'slider_name'=>null,
  ];

  $wh_config = array_replace($wh_config, $opt);

  global $config;
  global $isLoggedIn;

  $css_name = strtolower($config['conference']['conferencenameshort']);
  $menu_text = \CMS\MenuTools\draw_menu($wh_config['depth'], $wh_config['fn']);
  $conf_name = ($config['conference']['conferencename']);
  $conf_location = ($config['conference']['conferencelocation']);
  $conf_brand_top_raw = trim((string)($config['conference']['conf_name_html'] ?? 'Invicta'));
  $conf_brand_bottom_raw = trim((string)($config['conference']['conf_name_html_2'] ?? 'Cane Corso'));
  $conf_brand_top_raw = $conf_brand_top_raw !== '' ? $conf_brand_top_raw : 'Invicta';
  $conf_brand_bottom_raw = $conf_brand_bottom_raw !== '' ? $conf_brand_bottom_raw : 'Cane Corso';
  $conf_brand_top = htmlspecialchars($conf_brand_top_raw, ENT_QUOTES);
  $conf_brand_bottom = htmlspecialchars($conf_brand_bottom_raw, ENT_QUOTES);
  $conf_brand_label = htmlspecialchars(trim(strip_tags($conf_brand_top_raw . ' ' . $conf_brand_bottom_raw)), ENT_QUOTES);

  $current_page = $wh_config['fn'];
  $is_home = ($current_page === 'index.php');
  $canonical_base_url = rtrim((string)($config['web']['canonical_base_url'] ?? 'https://www.invictacanecorso.com'), '/');
  $canonical_path = $wh_config['canonical_path'];
  if ($canonical_path === null) {
    $canonical_path = $is_home ? '/' : '/' . ltrim((string)$current_page, '/');
  }
  $canonical_url_raw = $canonical_base_url . '/' . ltrim((string)$canonical_path, '/');
  $canonical_url = htmlspecialchars($canonical_url_raw, ENT_QUOTES);

  $page_title_raw = trim((string)($wh_config['page_title'] ?? ''));
  if ($page_title_raw === '') {
    $page_title_raw = 'Houston-Area Cane Corso Breeder | Invicta Cane Corso';
  }
  $page_title = htmlspecialchars($page_title_raw, ENT_QUOTES);
  $meta_description_raw = trim((string)$wh_config['meta_description']);
  $meta_description = htmlspecialchars($meta_description_raw, ENT_QUOTES);
  $og_image_raw = $canonical_base_url . '/' . ltrim((string)$wh_config['og_image'], '/');
  $og_image = htmlspecialchars($og_image_raw, ENT_QUOTES);

  $google_verification_html = '';
  $google_site_verification = trim((string)($config['web']['google_site_verification'] ?? ''));
  if ($google_site_verification !== '') {
    $google_site_verification = htmlspecialchars($google_site_verification, ENT_QUOTES);
    $google_verification_html = "<meta name=\"google-site-verification\" content=\"{$google_site_verification}\">";
  }

  $google_analytics_html = '';
  $google_analytics_id = trim((string)($config['web']['google_analytics_id'] ?? ''));
  if (preg_match('/^G-[A-Z0-9]+$/i', $google_analytics_id)) {
    $google_analytics_id = htmlspecialchars($google_analytics_id, ENT_QUOTES);
    $google_analytics_html = <<<HTML
        <script async src="https://www.googletagmanager.com/gtag/js?id={$google_analytics_id}"></script>
        <script>
          window.dataLayer = window.dataLayer || [];
          function gtag(){dataLayer.push(arguments);}
          gtag('js', new Date());
          gtag('config', '{$google_analytics_id}');
        </script>
    HTML;
  }

  $structured_data_html = '';
  if ($is_home) {
    $same_as_urls = [
      'https://www.tiktok.com/@azulathecanecorso',
      'https://www.instagram.com/azulathecanecorso/',
    ];
    $google_business_profile_url = trim((string)($config['web']['google_business_profile_url'] ?? ''));
    if (filter_var($google_business_profile_url, FILTER_VALIDATE_URL)) {
      $same_as_urls[] = $google_business_profile_url;
    }

    $organization_data = [
      '@context' => 'https://schema.org',
      '@type' => 'Organization',
      '@id' => $canonical_base_url . '/#organization',
      'name' => 'Invicta Cane Corso',
      'url' => $canonical_base_url . '/',
      'logo' => $canonical_base_url . '/images/invicta_logo_master.png',
      'description' => $meta_description_raw,
      'email' => 'mailto:' . $config['email']['emailsupport'],
      'address' => [
        '@type' => 'PostalAddress',
        'addressLocality' => 'Cypress',
        'addressRegion' => 'TX',
        'addressCountry' => 'US',
      ],
      'areaServed' => [
        ['@type' => 'City', 'name' => 'Cypress, Texas'],
        ['@type' => 'City', 'name' => 'Houston, Texas'],
        ['@type' => 'AdministrativeArea', 'name' => 'Greater Houston'],
      ],
      'sameAs' => $same_as_urls,
    ];
    $organization_json = json_encode($organization_data, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    $structured_data_html = "<script type=\"application/ld+json\">{$organization_json}</script>";
  }

  $prefix = str_repeat('../', $wh_config['depth']-1);
  $site_css_version = filemtime(__ROOT__ . "/css/{$css_name}.css");
  $carousel_css_version = filemtime(__ROOT__ . '/css/carousel.css');
  $h_authbar = '';
  $adHTML = null;
  $tab_slides = [
    'home' => [
        'slides' => [
            ['image' => 'carousel_b1.jpg', 'alt' => 'Invicta Cane Corso dogs in Cypress, Texas', 'caption' => ''],
            // ['image' => 'carousel_b1.1.jpg', 'alt' => 'Second Slide', 'caption' => ''],
        ],
        'pages' => ['index.php']
    ],
    'dogs' => [
        'slides' => [
            ['image' => 'carousel_b3.jpg', 'alt' => 'Cane Corso from the Invicta breeding program', 'caption' => ''],
            // ['image' => 'carousel_b3.jpg', 'alt' => 'Second Slide', 'caption' => ''],
            // ['image' => 'carousel_b2.jpg', 'alt' => 'Third Slide', 'caption' => ''],
        ],
        'pages' => ['dogs.php']
    ],
    'puppies' => [
        'slides' => [
            ['image' => 'carousel_b2.jpg', 'alt' => 'Invicta Cane Corso in Cypress, Texas', 'caption' => ''],
            // ['image' => 'carousel_b3.jpg', 'alt' => 'Second Slide', 'caption' => ''],
            // ['image' => 'carousel_b2.jpg', 'alt' => 'Third Slide', 'caption' => ''],
        ],
        'pages' => ['about.php']
    ]

  ];
  $default_slides = [
    ['image' => 'carousel_4.1.jpg', 'alt' => 'Invicta Cane Corso', 'caption' => '']
  ];
  $carousel_slides = $default_slides;
  foreach ($tab_slides as $tab => $tab_config) {
    if (isset($tab_config['pages']) && in_array($current_page, $tab_config['pages'])) {
      $carousel_slides = $tab_config['slides'];
      break;
    }
    elseif (!isset($tab_config['pages']) && $current_page === $tab . '.php') {
      $carousel_slides = $tab_config['slides'];
      break;
    }
  }

  if ($is_home) {
    $carousel_slides = $tab_slides['home']['slides'];
  }

  $carousel_items = '';
  $carousel_indicators = '';
  foreach ($carousel_slides as $index => $slide) {
    $active_class = ($index === 0) ? 'active' : '';
    $dim_class = ($index === 0) ? ' dim-animate' : '';
    $caption_html = '';
    if (!empty($slide['caption'])) {
      $caption_text = htmlspecialchars($slide['caption'], ENT_QUOTES);
      $caption_html = "<div class=\"carousel-slide-caption\">{$caption_text}</div>";
    }
    $slide_number = $index + 1;
    $indicator_active = ($index === 0) ? ' class="active" aria-current="true"' : '';
    $carousel_indicators .= "<button type=\"button\" data-bs-target=\"#IG27-carousel\" data-bs-slide-to=\"{$index}\"{$indicator_active} aria-label=\"Slide {$slide_number}\"></button>";
    $carousel_items .= <<<HTML
                <div class="carousel-item {$active_class}{$dim_class}">
                    <img src="{$prefix}images/carousel/{$slide['image']}" class="d-block w-100" alt="{$slide['alt']}">
                    {$caption_html}
                </div>
    HTML;
  }

  $carousel_class = $is_home ? '' : ' compact';
  $carousel_indicators_html = '';
  if (count($carousel_slides) > 1) {
    $carousel_indicators_html = <<<HTML
            <div class="carousel-indicators">
                {$carousel_indicators}
            </div>
    HTML;
  }

  $h_out = <<<HTML
    <!doctype html>
    <html lang="en">
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>{$page_title}</title>
        <meta name="description" content="{$meta_description}">
        <link rel="canonical" href="{$canonical_url}">
        <meta property="og:type" content="website">
        <meta property="og:site_name" content="Invicta Cane Corso">
        <meta property="og:title" content="{$page_title}">
        <meta property="og:description" content="{$meta_description}">
        <meta property="og:url" content="{$canonical_url}">
        <meta property="og:image" content="{$og_image}">
        <meta name="twitter:card" content="summary_large_image">
        {$google_verification_html}
        {$google_analytics_html}
        {$structured_data_html}
        <link rel="icon" type="image/png" href="images/favicon_3.png">
        <link href="https://fonts.cdnfonts.com/css/placard-next" rel="stylesheet">
        <link href="https://fonts.cdnfonts.com/css/helvetica-now" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@600;700;800&family=Instrument+Sans:ital,wght@0,400..700;1,400..700&family=Oswald:wght@200..700&display=swap" rel="stylesheet">
        
        <link href="{$prefix}css/bootstrap.min.css" rel="stylesheet">
        <link href="{$prefix}css/bootstrap-icons.css" rel="stylesheet">
        <link href="{$prefix}css/cms.css" rel="stylesheet">
        <link href="{$prefix}css/other.css" rel="stylesheet">
        <link href="{$prefix}css/{$css_name}.css?v={$site_css_version}" rel="stylesheet" type="text/css">
        <link href="{$prefix}css/carousel.css?v={$carousel_css_version}" rel="stylesheet" type="text/css">
        <script src="{$prefix}js/jquery-3.6.3.min.js"></script>
        <script src="{$prefix}js/bootstrap.bundle.min.js"></script>
        <script src="{$prefix}js/{$css_name}.js"></script>
        {$wh_config['header_extras']}
      </head>
    
      <body class="d-flex flex-column min-vh-100" id="html-body" style="background: linear-gradient(to right, #252a2b, #171c1d, #0c1112);">
    
       <nav class="navbar navbar-expand-lg navbar-custom-color fixed-top">
              <div class="container-fluid">
    
                <a class="navbar-brand invicta-wordmark me-0 mt-2" href="{$config['web']['confurl']}" aria-label="{$conf_brand_label}">
                  <img src="{$prefix}images/invicta_wordmark_nav.png" alt="" class="invicta-wordmark-image">
                </a>
    
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
                  <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse justify-content-stretch" id="navbarCollapse">
                {$menu_text}
                </div>
              </div><!--./container-->
            </nav>
            
    
        <!-- HEADER -->
        <div id="IG27-carousel" class="carousel slide carousel-fade{$carousel_class}" data-bs-ride="carousel">
            <div class="carousel-logo">
                <div class="carousel-brand-panel" aria-label="{$conf_brand_label}">
                    <span class="carousel-vertical-title" aria-hidden="true">{$conf_brand_top}</span>
                    <a class="carousel-crest-link" href="/" aria-label="{$conf_brand_label} home">
                        <img src="{$prefix}images/invicta_logo_master.png" alt="">
                    </a>
                    <div class="carousel-brand-copy">
                        <strong>{$conf_brand_top}</strong>
                        <small>{$conf_brand_bottom}</small>
                    </div>
                </div>
            </div>
            <!-- <div class="carousel-logos-right">
                <a href="https://ieee.org/" class="logo-ieee" target="_blank">
                    <img src="{$prefix}images/IEEELogoW.svg" alt="IEEE" class="img-fluid">
                </a>
                <a href="https://grss-ieee.org/" class="logo-grss" target="_blank">
                    <img src="{$prefix}images/GRSS_Logo_White.svg" alt="GRSS" class="img-fluid">
                </a>
            </div> -->
            <!-- Carousel Inner -->
            <div class="carousel-inner">
                {$carousel_items}
            </div>
            {$carousel_indicators_html}
    
            <!-- Carousel Controls -->
            <!-- <button class="carousel-control-prev" type="button" data-bs-target="#IG27-carousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#IG27-carousel" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button> -->
            <div class="curve"><img src="{$prefix}images/slider-curve.svg" alt=""></div>
        </div>
        <!-- HEADER -->
    
    
      <div class="container" id="main-content">
      
    HTML;

  if ($wh_config['return'])
  {
    return $h_out;
  }
  else
  {
    echo $h_out;
  }

}

?>
