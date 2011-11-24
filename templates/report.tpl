<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>criterion report</title>
    <!--[if lte IE 8]>
      <script language="javascript" type="text/javascript">
        {{#include}}js/excanvas-r3.min.js{{/include}}
      </script>
    <![endif]-->
    <script language="javascript" type="text/javascript">
      {{#include}}js/jquery-1.6.4.min.js{{/include}}
    </script>
    <script language="javascript" type="text/javascript">
      {{#include}}js/jquery.flot-0.7.min.js{{/include}}
    </script>
    <script language="javascript" type="text/javascript">
      {{#include}}js/jquery.criterion.js{{/include}}
    </script>
    <style type="text/css">
{{#include}}criterion.css{{/include}}
</style>
 </head>
    <body>
      <div class="body">
    <h1>pronk performance measurements</h1>

<h2><a name="b{{number}}">name</a></h2>
 <table width="100%">
  <tbody>
   <tr>
    <td><div id="kde0" class="kdechart"
             style="width:450px;height:278px;"></div></td>
    <td><div id="time0" class="timechart"
             style="width:450px;height:278px;"></div></td>
  </tbody>
 </table>
 <table>
  <thead class="analysis">
   <th></th>
   <th class="cibound"
       title="{{anMean.estConfidenceLevel}} confidence level">lower bound</th>
   <th>estimate</th>
   <th class="cibound"
       title="{{anMean.estConfidenceLevel}} confidence level">upper bound</th>
  </thead>
  <tbody>
   <tr>
    <td>Mean execution time</td>
    <td><span class="citime">{{anMean.estLowerBound}}</span></td>
    <td><span class="time">{{anMean.estPoint}}</span></td>
    <td><span class="citime">{{anMean.estUpperBound}}</span></td>
   </tr>
   <tr>
    <td>Standard deviation</td>
    <td><span class="citime">{{anStdDev.estLowerBound}}</span></td>
    <td><span class="time">{{anStdDev.estPoint}}</span></td>
    <td><span class="citime">{{anStdDev.estUpperBound}}</span></td>
   </tr>
  </tbody>
 </table>

 <span class="outliers">
   <p>Outlying measurements have {{anOutlierVar.ovDesc}}
     (<span class="percent">{{anOutlierVar.ovFraction}}</span>%)
     effect on estimated standard deviation.</p>
 </span>
{{/report}}

<script type="text/javascript">
$(function () {
  function mangulate(number, name, mean, times, kdetimes, kdepdf) {
    kdetimes = $.scaleTimes(kdetimes)[0];
    var meanSecs = mean;
    mean *= $.timeUnits(mean)[0];
    var ts = $.scaleTimes(times);
    var units = ts[1];
    ts = ts[0];
    var kq = $("#kde" + number);
    var k = $.plot(kq,
           [{ label: name + " latency densities (" + units + ")",
              data: $.zip(kdetimes, kdepdf),
              }],
           { yaxis: { ticks: false },
             grid: { hoverable: true, markings: [ { color: '#6fd3fb',
                     lineWidth: 1.5, xaxis: { from: mean, to: mean } } ] },
           });
    var o = k.pointOffset({ x: mean, y: 0});
    kq.append('<div class="meanlegend" title="' + $.renderTime(meanSecs) +
              '" style="position:absolute;left:' + (o.left + 4) +
              'px;bottom:139px;">mean</div>');
    var timepairs = new Array(ts.length);
    for (var i = 0; i < ts.length; i++)
      timepairs[i] = [ts[i],i];
    $.plot($("#time" + number),
           [{ label: name + " latencies (" + units + ")",
              data: timepairs }],
           { points: { show: true },
             grid: { hoverable: true },
             xaxis: { min: kdetimes[0], max: kdetimes[kdetimes.length-1] },
             yaxis: { ticks: false },
           });
    $.addTooltip("#kde" + number, function(x,y) { return x + ' ' + units; });
    $.addTooltip("#time" + number, function(x,y) { return x + ' ' + units; });
  };
  mangulate(0, "name",
            {{latency.mean}},
            [{{#latValues}}{{summElapsed}},{{/latValues}}],
            [{{#latKdeTimes}}{{x}},{{/latKdeTimes}}],
            [{{#latKdePDF}}{{x}},{{/latKdePDF}}]);
});
$(document).ready(function () {
    $(".time").text(function(_, text) {
        return $.renderTime(text);
      });
    $(".citime").text(function(_, text) {
        return $.renderTime(text);
      });
    $(".percent").text(function(_, text) {
        return (text*100).toFixed(1);
      });
  });
</script>

   </div>
 </body>
</html>
