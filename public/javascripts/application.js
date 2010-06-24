function togglePolygons(polygons) {
  polygons.each(function(polygon) {
    if (polygon.isHidden()) {
      polygon.show();
    } else {
      polygon.hide();
    }
  });
}

var geocoder = new GClientGeocoder();
function geocodeAddress(address) {
  geocoder.getLatLng(
    address,
    function(point) {
      if (!point) {
        alert(address + " not found");
      } else {
        $('address_span').hide();
        $('lat_lng').show();
        $('lat').value = point.lat();
        $('lng').value = point.lng();
      }
    }
  );
}

function clear_box(){
  $('address_span').show();
  $('lat_lng').hide();
}
