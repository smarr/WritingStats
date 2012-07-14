<?php
header('Content-Type: application/rss+xml; charset=UTF-8');

date_default_timezone_set('Europe/Brussels');

$folder = dirname(__FILE__);

$items = $folder.'/status.items';

echo '<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Thesis Status</title>
    <link>http://www.stefan-marr.de/</link>
    <description>Current Metrics of the Thesis Text</description>
    <language>en-en</language>
    <pubDate>'.date('r', filemtime($items)).'</pubDate>
    <lastBuildDate>'.date('r', filemtime($items)).'</lastBuildDate>
    <docs>http://stefan-marr.de/phd/status.rss.php</docs>
    <ttl>120</ttl>
    
    '.file_get_contents($items).'

  </channel>
</rss>';