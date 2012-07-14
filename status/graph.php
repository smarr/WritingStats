<?php
error_reporting(E_ALL | E_STRICT);

function get_graph_data() {
  global $start_day;
  global $duration;
  global $target_page_number_body;
  global $target_word_count;

// Config

$data_file = dirname(__FILE__).'/status.data';

// code
$start_timestamp = strtotime($start_day);
$row = 0;
$content = array(); // the normal file content
$byDate  = array(); // dictionary by date

// initialize arrays
$wordDiff = array(); $pageDiff = array();
$words    = array(); $pages    = array();
$commits  = array();
for ($i = 0; $i < $duration; $i++) {
  $words[$i] = 0;
  $pages[$i] = 0;
  $commits[$i] = 0;
}


if (($handle = fopen($data_file, "r")) !== FALSE) {
  while (($data = fgetcsv($handle, 1000, "\t")) !== FALSE) {
    $content[$row]    = $data;
    $timestamp        = strtotime($data[2]); // get timestamp for sorting
    $content[$row][3] = $timestamp;
    if ($timestamp) {
      $byDate[$timestamp]=$data;
    }
    $row++;
  }
  fclose($handle);
}



/// calculating statistics
$last_day = 0;

ksort($byDate);

foreach ($byDate as $date => $value) {
  $xAxis[] = sprintf("%.2f", diff_in_days($start_timestamp, $date));
  $wordAxis[] = $value[0];
  $pagesAxis[] = $value[1];

  $curDay = (int)floor(diff_in_days($start_timestamp, $date));
  $commits[$curDay]++;

  $words[$curDay] = $value[0];
  $pages[$curDay] = $value[1];
  while ($last_day < $curDay) {
    if ($words[$last_day] === 0 && $last_day > 0) {
      $words[$last_day] = $words[$last_day - 1];
      $pages[$last_day] = $pages[$last_day - 1];
    }
  $last_day++;
  }
}

// generate diffs to previous day
$wordDiff[0] = 0;
$pageDiff[0] = 0;
for ($i = 1; $i <= $last_day; $i++) {
  $wordDiff[$i] = $words[$i] - $words[$i - 1];
  $pageDiff[$i] = $pages[$i] - $pages[$i - 1];
}


$progressData = "
[
    ['x', 'Pages', 'Words', 'Ideal'],";

while (count($xAxis) > 0) {
  $x    = array_shift($xAxis);
  $page = array_shift($pagesAxis);
  $word = array_shift($wordAxis);
  
  $progressData .= "[$x, $page, $word, $target_page_number_body/$duration*$x],\n";
}

// Add the ideal line
$progressData .= "[$duration, null, null, $target_page_number_body],\n";
$progressData .= "  ]";


$speedData = "
[
  ['x', 'Pages', 'Words', 'Commits'],";


for ($i = 0; $i <= $last_day; $i++) { 
  $speedData .= "[$i, ${pageDiff[$i]}, ${wordDiff[$i]}, ${commits[$i]}],\n";
}
$speedData .= "  ]";
  
   return array('progress'    => $progressData,
                'speed'       => $speedData,
                'totalWords'  => $target_word_count,
        'targetPages' => $target_page_number_body,
        'duration'    => $duration);
}
