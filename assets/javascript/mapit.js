function addLoadEvent(func) {
  var oldonload = window.onload;
  if (typeof(window.onload) != 'function') {
    window.onload = func;
  } else {
    window.onload = function() {
      if (oldonload) {
        oldonload();
      }
      func();
    }
  }
}

function buildMapIt(map_div, points, options) {
  buildLatLng(points);
  var map_type = options['map_type'] || google.maps.MapTypeId.ROADMAP
  var myOptions = {
    zoom: 10,
    center: points[0]["latlng"],
    mapTypeId: map_type
  };
  
  var map = new google.maps.Map(document.getElementById(map_div), myOptions);
  
  var markers = buildMarkers(points, map)
  var bounds = findCenterPoint(points)
  map.fitBounds(bounds);
}

function buildLatLng(map_points) {
  for(i = 0; i < map_points.length; i++) {
    map_points[i]["latlng"] = new google.maps.LatLng(map_points[i]["latitude"],map_points[i]["longitude"]);
  }
}

function findCenterPoint(map_points) {
  bounds = new google.maps.LatLngBounds();
  for(i = 0; i < map_points.length; i++) {
    bounds.extend(map_points[i]["latlng"]);
  }
  return bounds
}

function buildMarkers(map_points, map) {
  var markers = new Array();
  for(i = 0; i < map_points.length; i++) {
    name = map_points[i]["info"];
    markers[i] = new google.maps.Marker({
        position: map_points[i]["latlng"], 
        map: map,
        title: name
    });
    addInfoWindow(name, markers[i], map);
  }
  return markers;
}

function addInfoWindow(name, marker, map) {
  google.maps.event.addListener(marker, "click", function() {
    if(infowindow) {infowindow.close()}
    infowindow = new google.maps.InfoWindow({content: name});
    infowindow.open(map, marker);
  });
}