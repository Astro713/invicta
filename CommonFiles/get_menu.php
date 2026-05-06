<?php
require_once("_config.php");

$depth = $_GET['d'] ?? 1;
$fn = $_GET['f'] ?? '';

// echo $fn;
$menu_text = draw_menu($depth, $fn);

echo $menu_text;

?>