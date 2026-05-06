<?php

require_once('_config_menu.php');

$template = file_get_contents('page_template.php');


$menu = get_menu();

$prefix = str_repeat('../', 1);

$menu_text = "<ul class=\"navbar-nav mr-auto\">\n";
foreach($menu as $btn)
{
  if ($btn[0] == null)
  {
    $menu_text .= "<li class=\"spacer\">&nbsp;</li>\n";
  }
  elseif (is_array($btn[2]))
  {
    // $class = [];
    // $class_a = [];
    // if ($btn[3])
    // {
    //   $class[] = 'active';
    // }
    $class = $btn[4];
    $class_a = $btn[5];
    // $class[] = ($btn[4] !== null) ? $btn[4] : null;
    // $class_a[] = ($btn[5] !== null) ? $btn[5] : null;

    $class = implode(' ', $class);
    $class_a = implode(' ', $class_a);

    $menu_text .= "
<li class=\"nav-item dropdown {$class} \">
  <a href=\"#\" class=\"nav-link dropdown-toggle {$class_a} \" data-toggle=\"dropdown\">{$btn[0]}</a>
  <div class=\"dropdown-menu\">
";
    foreach($btn[2] as $menu_item)
    {
      $class = $menu_item[3];
      $class_a = $menu_item[4];

      $class = implode(' ', $class);
      $class_a = implode(' ', $class_a);

      // $class = $menu_item[2] ? ' active ' : '';
      // $class .= $menu_item[4];
      $menu_text .= "<a href=\"{$prefix}{$menu_item[1]}\" class=\"dropdown-item {$class_a} \">{$menu_item[0]}</a>\n";
      if (!file_exists($prefix.$menu_item[1]))
      {
          $tmp = str_replace('%%%PAGETITLE%%%', $menu_item[0], $template);
          file_put_contents($prefix.$menu_item[1], $tmp);
      }
    }
    $menu_text .= "        
  </div>
</li>";
  }
  else
  {
    // $class = btn[4];
    // $class_a = btn[5];
    // $class = $btn[3] ? ' active ' : '';
    // $class .= ($btn[4] !== null) ? " {$btn[4]} " : '';

    $class = implode(' ', $btn[4]);
    $class_a = implode(' ', $btn[5]);

    $menu_text .= "<li class=\"nav-item {$class}\">
  <a class=\"nav-link {$class_a}\" href=\"{$prefix}{$btn[1]}\">{$btn[0]}</a>
</li>";
    if (!file_exists($prefix.$btn[1]))
    {
        $tmp = str_replace('%%%PAGETITLE%%%', $btn[0], $template);
        file_put_contents($prefix.$btn[1], $tmp);
    }

  }
}
$menu_text .= "</ul>";


?>