<?php
namespace CMS\Tools;

Class Tools {

  function encrypt_old($keystring, $plaintext)
  {
    // error_log(print_r(openssl_get_cipher_methods(),true));
    $cipher = 'des-cbc';
    $ivlen = openssl_cipher_iv_length($cipher);
    $iv = openssl_random_pseudo_bytes($ivlen);  
    // $plaintext = $scid.':'.$sc_salt;
    $key = sha1($keystring, true);
    $ciphertext = substr('00'.dechex($ivlen), -2);
    $ciphertext .= strtoupper( bin2hex( $iv ) );
    $ciphertext .= strtoupper( bin2hex( openssl_encrypt ( $plaintext, $cipher, $key,  OPENSSL_RAW_DATA, $iv ) ) );
    return $ciphertext;
  }

  function decrypt_old($keystring, $ciphertext)
  {
    $cipher = 'des-cbc';
    $key = sha1($keystring, true);
    $iv_len = hexdec(substr($ciphertext, 0, 2));
    if (!is_integer($iv_len))
    {
        return false;
    }
    $iv_len *= 2; // Hex characters
    $iv_str = substr($ciphertext, 2, $iv_len);
    
    $ciphertext_str = substr($ciphertext, 2+$iv_len);
    $plaintext = openssl_decrypt( (hex2bin($ciphertext_str)), $cipher, ($key), OPENSSL_RAW_DATA|0, hex2bin($iv_str) );
    return $plaintext;
  }

  function encrypt_new($keystring, $plaintext)
  {
    // error_log(print_r(openssl_get_cipher_methods(),true));
    // $cipher = 'des-cbc';
    $cipher = 'aes-128-cbc';
    $ivlen = openssl_cipher_iv_length($cipher);
    $iv = openssl_random_pseudo_bytes($ivlen);  
    // $plaintext = $scid.':'.$sc_salt;
    // $key = sha1($keystring, true);
    $key = hash('sha256', $keystring, true);
    $ciphertext = substr('00'.dechex($ivlen), -2);
    $ciphertext .= strtoupper( bin2hex( $iv ) );
    $ciphertext .= strtoupper( bin2hex( openssl_encrypt ( $plaintext, $cipher, $key,  OPENSSL_RAW_DATA, $iv ) ) );
    return $ciphertext;
  }

  function decrypt_new($keystring, $ciphertext)
  {
    // $cipher = 'des-cbc';
    $cipher = 'aes-128-cbc';
    $key = hash('sha256', $keystring, true);
    // $key = sha1($keystring, true);
    $iv_len = hexdec(substr($ciphertext, 0, 2));
    if (!is_integer($iv_len))
    {
        return false;
    }
    $iv_len *= 2; // Hex characters
    $iv_str = substr($ciphertext, 2, $iv_len);

    $ciphertext_str = substr($ciphertext, 2+$iv_len);
    $plaintext = openssl_decrypt( (hex2bin($ciphertext_str)), $cipher, ($key), OPENSSL_RAW_DATA|0, hex2bin($iv_str) );
    return $plaintext;
  }

  function encrypt($keystring, $plaintext)
  {
    return $this->encrypt_new($keystring, $plaintext);
  }

  function decrypt($keystring, $ciphertext)
  {
    $iv_len = hexdec(substr($ciphertext, 0, 2));
    if ($iv_len==8)
    {
      return $this->decrypt_old($keystring, $ciphertext);
    }
    else
    {
      return $this->decrypt_new($keystring, $ciphertext);
    }
  }

  /**
  * A sweet interval formatting, will use the two biggest interval parts.
  * On small intervals, you get minutes and seconds.
  * On big intervals, you get months and days.
  * Only the two biggest parts are used.
  *
  * @param DateTime $start
  * @param DateTime|null $end
  * @return string
  */
  public function formatDateDiff($start, $end=null) {
      if(!($start instanceof DateTime)) {
          $start = new DateTime($start);
      }
    
      if($end === null) {
          $end = new DateTime();
      }
    
      if(!($end instanceof DateTime)) {
          $end = new DateTime($start);
      }
    
      $interval = $end->diff($start);
      $doPlural = function($nb,$str){return $nb>1?$str.'s':$str;}; // adds plurals
    
      $format = array();
      if($interval->y !== 0) {
          $format[] = "%y ".$doPlural($interval->y, "year");
      }
      if($interval->m !== 0) {
          $format[] = "%m ".$doPlural($interval->m, "month");
      }
      if($interval->d !== 0) {
          $format[] = "%d ".$doPlural($interval->d, "day");
      }
      if($interval->h !== 0) {
          $format[] = "%h ".$doPlural($interval->h, "hour");
      }
      if($interval->i !== 0) {
          $format[] = "%i ".$doPlural($interval->i, "minute");
      }
      if($interval->s !== 0) {
          if(!count($format)) {
              return "less than a minute";
          } else {
              $format[] = "%s ".$doPlural($interval->s, "second");
          }
      }
    
      // We use the two biggest parts
      if(count($format) > 1) {
          $format = array_shift($format)." and ".array_shift($format);
      } else {
          $format = array_pop($format);
      }
    
      // Prepend 'since ' or whatever you like
      return $interval->format($format);
  }
}

?>