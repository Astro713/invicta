<?php

require_once('CommonFiles/_config.php');

$page_title = "%%%PAGETITLE%%%";

// Start Page Display
web_header(['depth'=>1, 'fn'=>pathinfo(__FILE__, PATHINFO_BASENAME), 'auth_needed'=>$config['auth']['enabled'], 'header_extras'=>null]);

?>

<div class="row">
  <div class="col">
  <h2><?= $page_title ?></h2>

<?php
  if (true)
  {
?>

<div class="row">
  <div class="col">
    <div class="alert alert-info">Coming soon.</div>
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