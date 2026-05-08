<?php

require_once('CommonFiles/_config.php');

$page_title = "About Invicta Cane Corso";

// Start Page Display
web_header(['depth'=>1, 'fn'=>pathinfo(__FILE__, PATHINFO_BASENAME), 'auth_needed'=>$config['auth']['enabled'], 'header_extras'=>null]);

?>

<div class="row mt-5 align-items-center">
  <div class="col-12">
    <h2><?= $page_title ?></h2>
  </div>

<?php
  if (true)
  {
?>

<div class="col-md-6 mt-5">
<img src="images/invicta_azula_3.jpg" alt="" class="img-fluid w-100" style="aspect-ratio: 1 / 1; object-fit: cover;">
</div>

<div class="col-md-6 mt-5">
<p class="text-start text-light">Invicta Cane Corso was established in the countryside of Hempstead, Texas, where Alexis and Brenda welcomed their first Cane Corso, Azula, in 2024. After falling in love with the breed's loyalty, confidence, strength, and natural protective instincts, they expanded their family in 2025 with Ozai after moving to Cypress, Texas. With Azula's strong European bloodline and Ozai's powerful American lineage, they founded Invicta Cane Corso with a commitment to raising well-tempered, confident puppies backed by exceptional AKC pedigree and placing them in loving, responsible homes.</p>
</div>



<?php
  }
?>
</div><!--/row-->

<?php
// End Page Display
// web_footer(1, pathinfo(__FILE__, PATHINFO_BASENAME));
web_footer(['depth'=>1, 'fn'=>pathinfo(__FILE__, PATHINFO_BASENAME), 'footer_extras'=>null]);


?>
