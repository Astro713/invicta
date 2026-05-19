<?php

require_once('CommonFiles/_config.php');

$page_title = "About Invicta Cane Corso";

// Start Page Display
web_header(['depth'=>1, 'fn'=>pathinfo(__FILE__, PATHINFO_BASENAME), 'auth_needed'=>$config['auth']['enabled'], 'header_extras'=>null]);

?>

<div class="row mt-5">
  <div class="col-12">
    <h2><?= $page_title ?></h2>
    <hr>
  </div>
</div>


<div class="row mt-5 text-center justify-content-center">
  <div class="col-md-6 ">
    <img src="images/invictas_azula.jpg" alt="" class="img-fluid mx-auto d-block" style="max-height: 450px; width: auto;">
  </div>
</div>


<div class="row mt-5 justify-content-center">
  <div class="col-md-6 ">
    <p class="text-center text-light"><span class="invicta-rg-text">Invicta Cane Corso</span> was established in the countryside of Hempstead, Texas, where Alexis and Brenda welcomed their first Cane Corso, <a href="dogs.php#azula" class=" text-decoration-underline">Azula</a>, in 2024. After falling in love with the breed's loyalty, confidence, strength, and natural protective instincts, they expanded their family in 2025 with <a href="dogs.php#ozai" class=" text-decoration-underline">Ozai</a> after moving to Cypress, Texas. With Azula's strong European bloodline and Ozai's powerful American lineage, they founded Invicta Cane Corso with a commitment to raising well-tempered, confident puppies backed by exceptional <span class="invicta-rg-text">AKC pedigree</span> and placing them in loving, responsible homes.</p>
  </div>
</div>


<?php
// End Page Display
// web_footer(1, pathinfo(__FILE__, PATHINFO_BASENAME));
web_footer(['depth'=>1, 'fn'=>pathinfo(__FILE__, PATHINFO_BASENAME), 'footer_extras'=>null]);


?>
