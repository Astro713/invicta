<?php
$aws_autoloader = 'G:/WWWRoot/Classes/aws/aws-autoloader.php';
if (file_exists($aws_autoloader))
{
  require($aws_autoloader);
}

Class AWSTools
{
  function getCloudFrontURL($key, $expiry_seconds)
  {
    global $config;

    if (!class_exists('\Aws\CloudFront\CloudFrontClient'))
    {
      return rtrim($config['aws']['cloudfronturl'] ?? '', '/') . '/' . ltrim($key, '/');
    }

    // Create a CloudFront Client
    $client = new \Aws\CloudFront\CloudFrontClient([
        'profile' => 'default',
        'version' => '2014-11-06',
        'region' => $config['aws']['region']
    ]);

    // Set up parameter values for the resource
    $resourceKey = $config['aws']['cloudfronturl'] . $key;
    // $resourceKey = $baseUrl . $fullArchiveName;
    $expires = time() + $expiry_seconds; // Minutes*Seconds

    // Set up parameter values for the resource
    $customPolicy = <<<POLICY
    {
        "Statement": [
            {
                "Resource": "{$resourceKey}",
                "Condition": {
                    "DateLessThan": {"AWS:EpochTime": {$expires}}
                }
            }
        ]
    }
    POLICY;
                    // "IpAddress": {"AWS:SourceIp": "{$_SERVER['REMOTE_ADDR']}/32"},

    // Create a signed URL for the resource using the canned policy
    $signedUrlCannedPolicy = $client->getSignedUrl([
        'url' => $resourceKey,
        'policy' => $customPolicy,
        'private_key' => $config['aws']['private_key_file'],
        'key_pair_id' => $config['aws']['key_pair_id'],
    ]);
    return $signedUrlCannedPolicy;
  }

  function getS3SignedURL($key, $expiry_seconds)
  {
    global $config;

    if (!class_exists('\Aws\S3\S3Client'))
    {
      return rtrim($config['aws']['s3url'] ?? '', '/') . '/' . ltrim($key, '/');
    }
    
    // Create an S3 Client
    $s3Client = new \Aws\S3\S3Client([
        'profile' => $config['aws']['credential_download_profile'],
        'region' => $config['aws']['region'],
        'version' => 'latest',
    ]);

    $cmd = $s3Client->getCommand('GetObject', [
        'Bucket' => $config['aws']['bucketname'],
        'Key' => $key,
      ]);
      $request = $s3Client->createPresignedRequest($cmd, '+60 minutes');
      return (string)$request->getUri();

  }
}

?>
