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
  var map_type = options['map_type'] || google.maps.MapTypeId.ROADMAP;
  var label = options['labels'] || false;
  var map_type_control = options['map_type_control'] || true
  var map_type_control_options_style = options['map_type_control_options']['style'] || google.maps.MapTypeControlStyle.DROP_DOWN
  var myOptions = {
    zoom: 10,
    center: points[0]["latlng"],
    mapTypeId: map_type,
    mapTypeControl: map_type_control,
    mapTypeControlOptions: {
      style: map_type_control_options_style
    }
  };
  
  var map = new google.maps.Map(document.getElementById(map_div), myOptions);
  
  var markers = buildMarkers(points, map, label)
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

function buildMarkers(map_points, map, label) {
  var markers = new Array();
  for(i = 0; i < map_points.length; i++) {
    name = map_points[i]["info"];
    options = {
        position: map_points[i]["latlng"], 
        map: map,
        title: name,
        icon: addLabels(map_points[i], label),
        shadow: addShadows(map_points[i], label)
    }
    markers[i] = new google.maps.Marker(options);
    addInfoWindow(name, markers[i], map_points[i]["id"], map);
  }
  return markers;
}

function addLabels(map_point, label) {
  if (label == true) {
    url = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld="+ map_point["letter"] +"|f97569|000000",
            new google.maps.Size(20, 34),
            new google.maps.Point(0, 0),
            new google.maps.Point(10, 34)
          );
  } else {
    url = null
  }
  return url
}

function addShadows(map_point, label) {
  if (label == true) {
    url = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_shadow",
            new google.maps.Size(40, 37),
            new google.maps.Point(0, 0),
            new google.maps.Point(10, 37)
          );
  } else {
    url = null
  }
  return url
}

function addInfoWindow(name, marker, id, map) {
  eval("infoWindow_" + id + "= function() { infowindow = new google.maps.InfoWindow({content: name}); infowindow.open(map, marker); }" );
  google.maps.event.addListener(marker, "click", eval("infoWindow_" + id) );
}