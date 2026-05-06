<?php
require_once "Auth.php";
// require_once "Util.php";

function validateSession()
{
  global $config;

  // $util = new CMS\Util\Util();
  $auth = new Auth();

  // Get Current date, time
  $current_date = (new DateTime())->format("Y-m-d H:i:s");
  $current_time = time();

  // Set Cookie expiration for 1 month
  // $cookie_expiration_time = $current_time + (30 * 24 * 60 * 60);  // for 1 month
  // $cookie_expiration_time = $current_time + (10 * 60);  // for 10 minutes

  $isLoggedIn = false;

  // error_log("Validate Login: Session Variable 'reg_id': " . ($_SESSION['reg_id'] ?? 'no_exist'));
  // error_log("Cookie[reg_id]: " . ($_COOKIE["reg_id"] ?? 'no_exist'));
  // error_log("Cookie[random_password]: " . ($_COOKIE["random_password"] ?? 'no_exist'));
  // error_log("Cookie[random_selector]: " . ($_COOKIE["random_selector"] ?? 'no_exist'));


  if (! empty($_SESSION["reg_id"]))
  {
    // Check if loggedin session
    // $isLoggedIn = true;
    $isLoggedIn = $_SESSION["reg_id"];
  }
  else if (! empty($_COOKIE["reg_id"]) && ! empty($_COOKIE["random_password"]) && ! empty($_COOKIE["random_selector"]))
  {
    // Check if loggedin session exists
    // Initiate auth token verification directive to false
    $isPasswordVerified = false;
    $isSelectorVerified = false;
    $isNotExpiredVerified = false;
    $isExpiryDateVerified = false;
    
    // Get token for username
    $userToken = $auth->getTokenByRegId($_COOKIE["reg_id"],0);

    if ($userToken !== null)
    {

      // Validate random password cookie with database
      if (password_verify($_COOKIE["random_password"], $userToken[0]["password_hash"]))
      {
        $isPasswordVerified = true;
      }
      
      // Validate random selector cookie with database
      if (password_verify($_COOKIE["random_selector"], $userToken[0]["selector_hash"]))
      {
        $isSelectorVerified = true;
      }
      
      // check cookie expiration by db
      if($userToken[0]["is_expired"] == 0)
      {
        $isNotExpiredVerified = true;
      }
      
      // check cookie expiration by date
      if($userToken[0]["expiry_date"] >= $current_date)
      {
        $isExpiryDateVerified = true;
      }
      
      // Redirect if all cookie based validation returns true
      // Else, mark the token as expired and clear cookies
      if (!empty($userToken[0]["id"]) && $isPasswordVerified && $isSelectorVerified && $isNotExpiredVerified && $isExpiryDateVerified)
      {
        // $isLoggedIn = true;
        $isLoggedIn = $_COOKIE["reg_id"];
        $_SESSION["reg_id"] = $_COOKIE["reg_id"];
      } else {
        if(!empty($userToken[0]["id"]))
        {
          $auth->markAsExpired($userToken[0]["id"]);
        }
        // clear cookies
        // $util->clearAuthCookie($config['web']['domain']);
      }
    }
  }

  return $isLoggedIn;
}

function var_dump_ret($mixed = null) {
  ob_start();
  var_dump($mixed);
  $content = ob_get_contents();
  ob_end_clean();
  return $content;
}

?>