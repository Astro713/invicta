<?php

require_once('CommonFiles/_config.php');

$page_title = "Available Puppies";

// Start Page Display
web_header(['depth'=>1, 'fn'=>pathinfo(__FILE__, PATHINFO_BASENAME), 'auth_needed'=>$config['auth']['enabled'], 'header_extras'=>null]);

?>

<div class="row mt-5">
  <div class="col">
  <h2><?= $page_title ?></h2>

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
        src="https://player.vimeo.com/video/1190604186?h=e6bae92994&background=1&autoplay=1&loop=1&muted=1&playsinline=1"
        allow="autoplay; fullscreen; picture-in-picture; clipboard-write; encrypted-media; web-share"
        referrerpolicy="strict-origin-when-cross-origin"
        allowfullscreen>
      </iframe>
    </div>
  </div>
</div>

<div class="row justify-content-center mt-5">
  <div class="col-12 col-md-6 col-lg-5">
    <p class="text-white text-center mb-3">We are expecting a litter from <a href="dogs.php#azula" class="text-white text-decoration-underline">Invicta's Azula</a> and <a href="dogs.php#ozai" class="text-white text-decoration-underline">Mad River's Ozai</a> near the end of 2026. Stay tuned for updates as we get closer, and follow our social media pages for the latest news, announcements, and puppy updates from Invicta Cane Corso.</p>
</div>
</div>

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
