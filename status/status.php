#!/usr/bin/php
<?php
error_reporting(E_ALL | E_STRICT);

$folder = dirname(__FILE__);

function diff_in_days($start, $end) {
  $datediff = abs($end - $start);
  return $datediff / (60 * 60 * 24);  // floor()
}

include($folder.'/../status.conf');


// collect raw data
$latex_log = file_get_contents($logfile);
$texcount  = "";
$texcount_bin = determine_texcount_bin();

if (!file_exists($texcount_bin)) {
  die('texcount binary not found. Please check status.conf and make sure it is installed. See: http://app.uio.no/ifi/texcount/download.html');
}
  

$texcount = shell_exec("$texcount_bin -merge $mainfile");

// process data
$matches = array();
preg_match('/Output written on .* \(([0-9]+) page(s)?, [0-9]+ bytes\)./', $latex_log, $matches);

$pages = (int)$matches[1];

preg_match('/Words in text: ([0-9]+)/', $texcount, $matches);
$textWordCnt = (int)$matches[1];

preg_match('/Words in headers: ([0-9]+)/', $texcount, $matches);
$headerWordCnt = (int)$matches[1];

$totalWordCnt = $headerWordCnt + $textWordCnt;


$deadline_time = strtotime($deadline);
$today = strtotime('now');
$timeLeft = round(($deadline_time - $today) / 60 / 60 / 24 * 100) /100; // time left in days
$timeLeftUseableDays = round($timeLeft * 5 / 7 * 100) / 100;

$progress = round($totalWordCnt / $target_word_count * 10000) / 100;
$wordsLeft = $target_word_count - $totalWordCnt;
$pagesLeft = ($target_page_number_body + $overhead_pages) - $pages;
$leftWordsPerDay = round($wordsLeft / $timeLeftUseableDays);
$pagesPerDay = round($leftWordsPerDay / $words_per_page * 100) / 100;

$result = "Goal\n";
$result .= "----\n";
$result .= "\n";
$result .= "Words: $target_word_count\n";
$result .= "Pages: $target_page_number_body\n";
$result .= "Words/Page: ca. $words_per_page\n";
$result .= "Draft Deadline: $deadline";
$result .= "\n";
$result .= "\n";
$result .= "Current Status\n";
$result .= "--------------\n";
$result .= "\n";
$result .= 'Words: '.$totalWordCnt."\n";
$result .= 'Pages: '.$pages."\n";
$result .= 'Words to be written: '.$wordsLeft."\n";
$result .= 'Pages to be written: ca. '.$pagesLeft."\n";
$result .= 'Progress: '.$progress."% finished\n";
$result .= 'Remaining Days: '.$timeLeft."\n";
$result .= 'Remaining Workdays: '.$timeLeftUseableDays."\n";
$result .= 'Remaining Words/Workday: '.$leftWordsPerDay."\n";
$result .= 'Pages/Day: '.$pagesPerDay."\n";
$result .= 'Current Date: ';
// Little bit other Syntax but better effect
$result .= strftime('%A, %d. %B %Y %H:%M:%S');
$html_result = nl2br(htmlspecialchars($result, ENT_QUOTES, 'UTF-8'));



// prepend current values to data file for graphs
$graph_data = file_get_contents($folder.'/status.data');
$graph_data = "$totalWordCnt\t$pages\t".strftime('%A, %d. %B %Y %H:%M:%S')."\n".$graph_data;
file_put_contents($folder.'/status.data', $graph_data);

include($folder.'/graph.php');

$graphs = get_graph_data();




$version_count = substr_count($graph_data, "\n");
include($folder.'/png.php');

$overview_images = "<div id='images' style='width: 900px;'>\n";

file_put_contents($folder.'/status.txt', $result);


for ($i = 1; $i <= $version_count; $i++) {
  $overview_images .= "<img src='overview-$i.png' style='display:none;width:100%;height:auto;' />\n";
}
$overview_images .= "</div>\n";

$rss = "
    <item>
      <title>Current Status: $progress%, $timeLeftUseableDays days left</title>
      <description>".$html_result."</description>
      <pubDate>".date('r').'</pubDate>
      <guid>http://soft.vub.ac.be/~smarr/phd/status.rss.php#'.uniqid().'</guid>
    </item>';

$rss .= "\n".file_get_contents($folder.'/status.items');

file_put_contents($folder.'/status.items', $rss);


// Generate the HTML status page
$full_html = '<html><head><title>Latest Stats on PhD Writing Progress</title>
  <script type="text/javascript" src="https://www.google.com/jsapi"></script>
  <script type="text/javascript">
	      google.load("visualization", "1", {packages:["corechart"]});
	      google.setOnLoadCallback(drawChart);
        
        var image_nodes = null;
        var img_idx = 0;
        var play = true;
        
	      function drawChart() {
	        var progress_data = google.visualization.arrayToDataTable('.$graphs['progress'].');
	        var speed_data    = google.visualization.arrayToDataTable('.$graphs['speed'].');

	        var progress_options = {
	          title: "Progress (per day)",
	          curveType: "function",
	          width: 900, height: 500,
	          hAxis: {maxValue: '.$graphs['duration'].', title: "Days"},
	          vAxes: { 0: {title:"Pages", maxValue: '.$graphs['targetPages'].'},
	                   1: {title:"Words", maxValue: '.$graphs['totalWords'].'},
	                   2: {title:"Ideal", maxValue: '.$graphs['targetPages'].'}
	          },
              series: {
				       0: {targetAxisIndex: 0},
					   1: {targetAxisIndex: 1},
					   2: {targetAxisIndex: 0, color: "#ccc"},
			     },
	    };
			
			var speed_options = {
	          title: "Speed",
			  curveType: "function",
			  width: 900, height: 500,
			  hAxis: {title:"Days"},
			  vAxes: { 0: {title:"Pages"},
	                   1: {title:"Words"},
	                   2: {title:"Commits"}
	          },
              series: {
				       0: {targetAxisIndex: 0},
					   1: {targetAxisIndex: 1},
					   2: {targetAxisIndex: 0, color: "#ccc"},
			  },
	        };

	        var progress_chart = new google.visualization.LineChart(document.getElementById("progress"));
	        progress_chart.draw(progress_data, progress_options);
	        var speed_chart = new google.visualization.LineChart(document.getElementById("speed"));
	        speed_chart.draw(speed_data, speed_options);
          
          
          startImageTime();
          image_nodes = document.getElementById("images").children;
	      };
        
        function startImageTime() {
          setInterval(displayNextImage, 250);
        }
        
        function toggleAnimation() {
          play = !play;
        }
        
        function displayNextImage() {
          if (!play)
            return;
            
          if (img_idx >= image_nodes.length + 10) { // the + 10 adds a little pause after a cycle
            img_idx = 0;
          }
          
          if (img_idx < image_nodes.length) {
            var old_idx = (img_idx == 0) ? image_nodes.length - 1 : img_idx - 1;
          
            // console.log("display: idx " + img_idx);
            // console.log("hide: idx " + old_idx);
          
            image_nodes[img_idx].style.display = "block";
            image_nodes[old_idx].style.display = "none";
          }
          
          img_idx++;
        }
        
        
	    </script>
	  </head>
</head>
<body>'.$html_result.'
<div id="progress" style="width: 900px; height: 500px;"></div>
<div id="speed"    style="width: 900px; height: 500px;"></div>

<h2>Overview</h2>
'.$overview_images.'

<button onclick="toggleAnimation();">play</button>
</body></html>';



file_put_contents($folder.'/status.html', $full_html);

shell_exec("cp $pdffile status/$pdffile");
echo $result."\n";



