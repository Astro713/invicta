<?php

require_once('CommonFiles/_config.php');

$page_title = "Available Puppies";
$puppies_video_header_extras = <<<HTML
        <link rel="preconnect" href="https://player.vimeo.com">
        <link rel="preconnect" href="https://i.vimeocdn.com">
        <link rel="preconnect" href="https://f.vimeocdn.com">
        <link rel="dns-prefetch" href="//player.vimeo.com">
        <link rel="dns-prefetch" href="//i.vimeocdn.com">
        <link rel="dns-prefetch" href="//f.vimeocdn.com">
HTML;

// Start Page Display
web_header(['depth'=>1, 'fn'=>pathinfo(__FILE__, PATHINFO_BASENAME), 'page_title'=>'Cane Corso Puppies near Houston, TX | Invicta Cane Corso', 'canonical_path'=>'/puppies.php', 'auth_needed'=>$config['auth']['enabled'], 'header_extras'=>$puppies_video_header_extras]);

?>

<div class="row mt-4">
  <div class="col">
  <h1><?= $page_title ?></h1>

<?php
  if (true)
  {
?>

<div class="alert alert-dark mt-4">Coming soon.</div>

<div class="row justify-content-center mt-5">
  <div class="col-12 col-md-6 col-lg-5">
    <div class="puppies-video-wrapper mx-auto">
      <iframe
        title="Invicta Cane Corso video"
        src="https://player.vimeo.com/video/1190604186?h=e6bae92994&background=1&autoplay=1&loop=1&muted=1&playsinline=1&dnt=1"
        allow="autoplay; fullscreen; picture-in-picture; clipboard-write; encrypted-media; web-share"
        loading="eager"
        fetchpriority="high"
        referrerpolicy="strict-origin-when-cross-origin"
        allowfullscreen>
      </iframe>
    </div>
  </div>
</div>

<div class="row justify-content-center mt-5">
  <div class="col-12 col-md-6 col-lg-5">
    <p class="text-white text-center mb-3">We are expecting a litter from <a href="dogs.php#azula" class="text-decoration-underline">Invicta's Azula</a> and <a href="dogs.php#ozai" class="text-decoration-underline">Mad River's Ozai</a> near the beginning of 2027. Stay tuned for updates as we get closer, and follow our social media pages for the latest news, announcements, and puppy updates from Invicta Cane Corso.</p>
    <div class="social-media text-center mt-3 mb-3">
        <a target="_blank" rel="noopener" href="https://www.tiktok.com/@azulathecanecorso" class="text-white mx-2" aria-label="Invicta Cane Corso on TikTok"><i class="bi bi-tiktok fs-custom"></i></a>
        <a target="_blank" rel="noopener" href="https://www.instagram.com/azulathecanecorso/" class="text-white mx-2" aria-label="Invicta Cane Corso on Instagram"><i class="bi bi-instagram fs-custom"></i></a>
        <a href="mailto:info@invictacanecorso.com" class="text-white mx-2" aria-label="Email Invicta Cane Corso"><i class="bi bi-envelope fs-custom"></i></a>
    </div>
</div>
</div>

<section id="flight-nanny" class="row justify-content-center mt-5 dog-profile-anchor" aria-labelledby="flight-nanny-heading">
  <div class="col-12 col-md-8 text-center">
    <h2 id="flight-nanny-heading" class="ig-index-font-h2 mb-3">Domestic Flight Nanny Delivery</h2>
    <p class="text-white mb-3">For families who live outside Texas, Invicta Cane Corso may arrange delivery to destinations within the United States through a trusted flight nanny. The flight nanny personally accompanies the puppy during air travel and coordinates a safe handoff with the new family.</p>
    <p class="text-white mb-3">Flight nanny delivery is optional, subject to availability and applicable airline and veterinary travel requirements, and requires an additional fee based on the destination and travel arrangements. Details and the total delivery cost will be agreed upon before travel is scheduled.</p>
  </div>
</section>

<?php
  }
?>
    
  </div><!--/col-->
</div><!--/row-->

<?php
// End Page Display
// web_footer(1, pathinfo(__FILE__, PATHINFO_BASENAME));
web_footer(['depth'=>1, 'fn'=>pathinfo(__FILE__, PATHINFO_BASENAME), 'footer_extras'=>null]);


?>
