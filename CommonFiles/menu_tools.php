<?php
namespace CMS\MenuTools;

function draw_menu($depth, $file_name)
{
  $file_name = strtolower($file_name);

  $menu = get_menu();
  // print_r($menu);

  for ($a=0; $a<sizeof($menu); $a++)
  {
    if (is_array($menu[$a][2]))
    {
      for ($b=0; $b<sizeof($menu[$a][2]); $b++)
      {
        if ($menu[$a][2][$b][1] == $file_name)
        {
          $menu[$a][4][] = 'active';
          $menu[$a][2][$b][4][] = 'active';
          // $menu[$a][3] = true;
          // $menu[$a][2][$b][2] = true;
        }
      }
    }
    else
    {
      if ($menu[$a][1] == $file_name)
      {
        $menu[$a][4][] = 'active';
        // $menu[$a][3] = true;
      }
    }
  }
  // print_r($menu);


  // echo $file_name;
  $prefix = str_repeat('../', $depth-1);

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
    <a href=\"#\" class=\"nav-link dropdown-toggle {$class_a} \" data-bs-toggle=\"dropdown\">{$btn[0]}</a>
    <div class=\"dropdown-menu dropdown-menu-end\">
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

    }
  }
  $menu_text .= "</ul>";

  return $menu_text;
}
?>