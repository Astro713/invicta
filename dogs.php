<?php

require_once('CommonFiles/_config.php');

$page_title = "Our Dogs";

// Start Page Display
web_header(['depth'=>1, 'fn'=>pathinfo(__FILE__, PATHINFO_BASENAME), 'auth_needed'=>$config['auth']['enabled'], 'header_extras'=>null]);

?>

<div class="row mt-5">
  <div class="col">
  <h1><?= $page_title ?></h1>

<?php
  if (true)
  {
?>

<div id="azula" class="container p-5 mt-4 dog-profile-anchor">
    <div class="row align-items-center">
        <div class="col-md-6">
            <img src="images/invictas_azula.jpg" class="img-fluid mx-auto d-block" style="max-height: 375px; width: auto;">
        </div>
        <div class="col-md-6">
            <p class="ig-index-font-h2 mb-3 mt-3">Invicta's Azula</p>
            <p class="text-white mb-3">Azula is a majestic Cane Corso who reflects the original standard of the breed with strength, balance, athleticism, and presence. Her bloodline is primarily European and includes respected pedigree influence from X-Man of Barcelona, Spain. She embodies the qualities that make the Cane Corso exceptional: powerful movement, intense drive, and reliable protective instincts. Whether in a family setting, on open land, or in a working environment, Azula carries herself with the awareness, loyalty, and purpose expected from a true Cane Corso.</p>
        </div>
    </div>
</div>

<div id="ozai" class="destination-section dog-profile-anchor">
    <div class="container p-5">
        <div class="row align-items-center">
            <div class="col-md-6 order-2 order-md-1">
                <p class="ig-index-font-h2 mb-3 mt-3">Mad River's Ozai</p>
                <p class="text-white mb-3">Ozai represents the future of the Invicta Cane Corso program. Built from one of the strongest American bloodlines through Mad River Cane Corso in Ohio, he is young, composed, and already showing the natural confidence that defines a well-bred Cane Corso. At just 8 months old, Ozai stands 27 inches at the shoulder and weighs 110 pounds. His broad shoulders, powerful paws, strong head, and balanced structure are setting the tone for the quality, strength, and presence expected in future Invicta litters.</p>
            </div>
            <div class="col-md-6 order-1 order-md-2">
                <img src="images/invictas_ozai.jpg" class="img-fluid mx-auto d-block" style="max-height: 375px; width: auto;">
            </div>
        </div>
    </div>
</div>

<hr class="mt-5 mb-5" style="border-color: transparent;">
<hr class="mt-5 mb-5" style="border-color: transparent;">

<div class="row justify-content-center mt-5 mb-5">
    <div class="col-md-6 text-center">
    <a href="#">
        <img src="images/invicta_logo_master.png" alt="" class="img-fluid index-logo">
    </a>
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
