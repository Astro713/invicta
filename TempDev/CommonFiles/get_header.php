<?php
require_once("_config.php");

$depth = $_GET['d'] ?? 1;
$fn = $_GET['f'] ?? '';
$page_title = $_GET['t'] ?? '';
$hextras = $_GET['he'] ?? null;
if ($hextras)
{
    $hextras = base64_decode($hextras);
}

$header_text = web_header(['return'=>true, 'depth'=>$depth, 'fn'=>$fn, 'title'=>$page_title, 'auth_needed'=>$config['auth']['enabled'], 'header_extras'=>$hextras]);

echo $header_text;

?>