<?php
require_once("_config.php");

$depth = $_GET['d'] ?? 1;
$fn = $_GET['f'] ?? '';
$page_title = $_GET['t'] ?? '';

// echo $fn;
// $menu_text = draw_menu($depth, $fn);

$footer_text = web_footer(['return'=>true, 'depth'=>$depth, 'fn'=>$fn, 'title'=>$page_title, 'auth_needed'=>$config['auth']['enabled']]);

echo $footer_text;

?>