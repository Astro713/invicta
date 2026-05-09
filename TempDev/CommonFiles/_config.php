<?php
$isLoggedIn = false;

define('__ROOT__', dirname(__FILE__,2));

function loadLocalConfig($configPath)
{
  $config = [];
  $section = null;
  $lines = file($configPath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

  foreach ($lines as $line)
  {
    $line = trim($line);
    if ($line === '' || $line[0] === '#' || $line[0] === ';')
    {
      continue;
    }

    if (preg_match('/^\[([^\]]+)\]$/', $line, $matches))
    {
      $section = $matches[1];
      $config[$section] = [];
      continue;
    }

    if ($section === null || strpos($line, '=') === false)
    {
      continue;
    }

    [$key, $value] = array_map('trim', explode('=', $line, 2));
    $lowerValue = strtolower($value);

    if ($lowerValue === 'true')
    {
      $value = true;
    }
    elseif ($lowerValue === 'false')
    {
      $value = false;
    }
    elseif (strlen($value) >= 2 && $value[0] === '"' && substr($value, -1) === '"')
    {
      $value = stripcslashes(substr($value, 1, -1));
    }

    $config[$section][$key] = $value;
  }

  return $config;
}

function db_PDO_makeConnString($server, $dbname)
{
  return "sqlsrv:server={$server}; Database={$dbname}; Encrypt=true; TrustServerCertificate=true";
}

$db_PDO_options = [
  PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC,
];

$config = loadLocalConfig(__DIR__ . '/_config.toml');
$config['auth']['enabled'] = false;
$config['web']['confurl'] = 'index.php';

date_default_timezone_set($config['conference']['tzid']);

if (session_status() === PHP_SESSION_NONE)
{
  session_start([
    'cookie_lifetime' => (int) $config['auth']['cookielifetime_seconds']
  ]);
}

// Local tools
require_once('_config_menu.php');
require_once('menu_tools.php');
require_once('header.php');
require_once('footer.php');
require_once('Tools.php');
require_once('Util.php');
require_once('meeting_tools.php');

$utc_tz = new DateTimeZone('UTC');

$tzList = [
  [ 'tz'=>new DateTimeZone($config['conference']['tzid']), 'name'=>$config['conference']['tzname'], 'class'=>'tz-badge badge-tz1', 'offset_text'=>'', 'offset_hours'=>0],
  // [ 'tz'=>new DateTimeZone('Europe/Paris'), 'name'=>'', 'class'=>'tz-badge badge-tz2', 'offset_text'=>'', 'offset_hours'=>0],
  // [ 'tz'=>new DateTimeZone('UTC'), 'name'=>'', 'class'=>'tz-badge badge-tz3', 'offset_text'=>'', 'offset_hours'=>0],
  // [ 'tz'=>new DateTimeZone('America/New_York'), 'name'=>'', 'class'=>'tz-badge badge-tz4', 'offset_text'=>'', 'offset_hours'=>0],
];

foreach ($tzList as &$tz)
{
  // Calculate UTC Offset
  $dtz = new DateTime("now", $utc_tz);
  $dtt = new DateTime("now", $tz['tz']);
  $tz['offset_hours'] = $tz['tz']->getOffset($dtz) / 3600.0;
  if ($tz['offset_hours']!=0)
  {
    $tz['offset_text'] = sprintf(" (UTC %+d)", $tz['offset_hours']);
    // $tz[1] = $tz[0]->getName();;
  }
  // Initialize IntlTimeZone object for display name usage
  $tz['intl_tz'] = class_exists('IntlTimeZone') ? IntlTimeZone::fromDateTimeZone($tz['tz']) : null;
}
unset($tz);

function get_timezone_text(DateTimeInterface $time, $tz)
{
  if (!$tz['intl_tz'])
  {
    return $tz['tz']->getName();
  }
  $is_dst = ($time->format('I')=='1' ? 1 : 0);
  $tx = $tz['intl_tz']->getDisplayName($is_dst, IntlTimeZone::DISPLAY_LONG, 'en_US');
  return $tx;
}

function get_timezone_longname(DateTimeInterface $time, $tz)
{
  if (!$tz['intl_tz'])
  {
    return $tz['tz']->getName();
  }
  $is_dst = ($time->format('I')=='1' ? 1 : 0);
  // $tx = $tz['intl_tz']->getDisplayName($is_dst, IntlTimeZone::DISPLAY_GENERIC_LOCATION, 'en_US');
  $tx = $tz['intl_tz']->getDisplayName($is_dst, IntlTimeZone::DISPLAY_LONG_GENERIC, 'en_US');
  $tx = str_replace('GMT', 'UTC', $tx);
  return $tx;
}

function get_timezone_shortname(DateTimeInterface $time, $tz)
{
  if (!$tz['intl_tz'])
  {
    return $tz['tz']->getName();
  }
  $is_dst = ($time->format('I')=='1' ? 1 : 0);
  // $tx = $tz['intl_tz']->getDisplayName($is_dst, IntlTimeZone::DISPLAY_GENERIC_LOCATION, 'en_US');
  $tx = $tz['intl_tz']->getDisplayName($is_dst, IntlTimeZone::DISPLAY_SHORT_GENERIC, 'en_US');
  $tx = str_replace('GMT', 'UTC', $tx);
  return $tx;
}


?>