<?php
// require_once('_config.php');

function web_footer($opt = [])
{
  /* 
  $depth => How deep into directories. Top level is 1
  $fn => File Name; The menu function checks the script name against this string to know what the current page is
  $footer_extras; Inserted in the <head> section
  $auth_needed; (boolean), whether this page needs to show the login/logout and check logged-in status.
  */
  $wf_config = [
    'return'=>false,
    'depth'=>1,
    'fn'=>null,
    'footer_extras'=>null,
    'auth_needed'=>false,
  ];

  $wf_config = array_replace($wf_config, $opt);

  global $config;
  $last_mod_date = "Last updated " . date ("d F Y.", getlastmod());
  $year = date("Y");

  $f_out = <<<HTML

    </div>
    <!-- /.container -->
      
    <hr class="mt-5 mb-5" style="border-color: transparent;">
    <!-- <footer id="footer" class="footer mt-auto text-white">
      <div class="container-fluid">
        <div class="row justify-content-between align-items-center">

          <div class="col-12 col-md-4 text-center text-md-start">
            <p class="mb-0">&copy;{$year} <a href="#" target="_blank" class="text-white">IEEE International Geoscience and Remote Sensing Symposium.</a></p>
            <p class="mb-0">{$last_mod_date}</p>
          </div>
          
          <div class="col-12 col-md-4 text-center my-0 my-md-0">
              <a target="_blank" href="https://twitter.com/IEEE_GRSS" class="text-white mx-2"><i class="bi bi-twitter fs-custom"></i></a>
              <a target="_blank" href="https://www.facebook.com/IEEE.GRSS" class="text-white mx-2"><i class="bi bi-facebook fs-custom"></i></a>
              <a target="_blank" href="https://www.instagram.com/ieeeorg/" class="text-white mx-2"><i class="bi bi-instagram fs-custom"></i></a>
              <a target="_blank" href="https://www.linkedin.com/company/ieee-grss/" class="text-white mx-2"><i class="bi bi-linkedin fs-custom"></i></a>
              <a target="_blank" href="https://www.youtube.com/c/IEEEGRSS/" class="text-white mx-2"><i class="bi bi-youtube fs-custom"></i></a>
          </div>

          <div class="col-12 col-md-4 text-center text-md-end">
            <p class="mb-0">Contact: <a href="mailto:{$config['email']['emailsupport']}" class="text-white">{$config['email']['emailsupport']}</a></p>
            <p class="mb-0">Host: <a href="https://cmsworldwide.com/" target="_blank" class="text-white">https://cmsworldwide.com/</a></p>
          </div>

        </div>
      </div>
    </footer> -->
    <footer id="footer" class="footer text-light mt-auto pt-5">
      <div class="container px-2">
          <div class="row">
              <div class="col-6 col-lg-4">
                  <h5 class="mt-3 mb-1">{$config['conference']['conferencename']}</h5>
                  <p>Location: {$config['conference']['conferencelocation']}</p>
                  <p>Registration: American Kennel Club (AKC)</p>
              </div>
              <div class="col">
                  <h6 class="mt-3 mb-1">Menu</h6>
                  <ul class="list-unstyled ">
                      <li class="py-1"><a href="index.php">Home</a></li>
                      <li class="py-1"><a href="about.php">About Us</a></li>
                      <li class="py-1"><a href="puppies.php">Available Puppies</a></li>
                  </ul>
              </div>
              <div class="col">
                  <h6 class="mt-3 mb-1">Contact</h6>
                  <ul class="list-unstyled ">
                      <li class="py-1">Contact: <a href="mailto:{$config['email']['emailsupport']}" class="text-white">{$config['email']['emailsupport']}</a></li>
                  </ul>
              </div>
              <div class="col-6 col-lg-3 text-lg-center">
                  <h6 class="mt-3 mb-1">Social Media Links</h6>
                  <div class="social-media ">
                    <a target="_blank" href="https://www.tiktok.com/@azulathecanecorso" class="text-white mx-2"><i class="bi bi-tiktok fs-custom"></i></a>
                    <a target="_blank" href="https://www.instagram.com/azulathecanecorso/" class="text-white mx-2"><i class="bi bi-instagram fs-custom"></i></a>
                    <a target="_blank" href="#" class="text-white mx-2"><i class="bi bi-youtube fs-custom"></i></a>
                  </div>
              </div>
          </div>
          <hr>
          <div class="d-sm-flex justify-content-between py-3">
              <p>&copy;{$year} <a href="#" target="_blank" class="text-white">Invicta Cane Corso</a></p>
              <!-- <p class="text-light text-decoration-none pe-4">
                  {$last_mod_date}
              </p> -->
          </div>
      </div>
    </footer>
    {$wf_config['footer_extras']}
  </body>
</html>
HTML;

  if ($wf_config['return']) {
    return $f_out;
  } else {
    echo $f_out;
  }
}
?>
