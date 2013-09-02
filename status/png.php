<?php
// This script generates an overview image of the PDF.
// We use the number of pages given in the configuration as a constant for
// the overview image's dimensions.
$total_pages = $target_page_number_body + $overhead_pages;

/**
 * 1.  area = width * height
 * 2.  width / height = ratio
 * 3.  ratio > 1,3
 * 4.  ratio < 1,78
 *   
 *   area / height = width
 *   area / width  = height
 *   
 *   width = ratio * height
 *   height = width / ratio
 *   
 *   area / height = ratio * height
 *   area = ratio * height * height
 * 
 *   height = sqrt(area / ratio)
 *   
 *   area / width = width / ratio
 *   area = width * width / ratio
 *   
 *   width = sqrt(area * ratio)
 */
function determine_rect($pages) {
  $ratio  = ((1 + sqrt(5)) / 2) /*Goldener Schnitt*/  * sqrt(2) /* A4 ratio, because pages aren't square */;
  $height = (int)sqrt($pages / $ratio);
  $width  = (int)sqrt($pages * $ratio);
  return array($width, $height);
}

function determine_adjusted_rect($pages) {
  list($width, $height) = determine_rect($pages);

  if ($pages > $width * $height) $width  += 1;
  if ($pages > $width * $height) $height += 1;
  return array($width, $height);
}

list($width, $height) = determine_adjusted_rect($total_pages);

if ($pages > $width * $height) {
  list($width, $height) = determine_adjusted_rect($pages);
}

mkdir("tmp");
shell_exec("convert $pdffile tmp/$pdffile-%04d.png");

$cmd = "montage -background \#ffffff -geometry +0+0 -tile {$width}x{$height} \"tmp/{$pdffile}-*.png\" status/overview-{$version_count}.png";
shell_exec($cmd);
shell_exec("rm -rf tmp");
shell_exec("chmod a+r status/overview-*.png");