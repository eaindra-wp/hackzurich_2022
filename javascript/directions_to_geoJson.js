// https://github.com/jhermsmeier/node-google-polyline/blob/master/lib/decode.js
var PRECISION = 1e5;
function decode( value ) {
  var points = []
  var lat = 0
  var lon = 0
  var values = decode.integers( value, function( x, y ) {
    lat += x
    lon += y
    points.push([ lat / PRECISION, lon / PRECISION ])
  })
  return points
}
decode.sign = function( value ) {
  return value & 1 ? ~( value >>> 1 ) : ( value >>> 1 )
}
decode.integers = function( value, callback ) {
  var values = 0
  var x = 0
  var y = 0
  var byte = 0
  var current = 0
  var bits = 0
  for( var i = 0; i < value.length; i++ ) {
    byte = value.charCodeAt( i ) - 63
    current = current | (( byte & 0x1F ) << bits )
    bits = bits + 5
    if( byte < 0x20 ) {
      if( ++values & 1 ) {
        x = decode.sign( current )
      } else {
        y = decode.sign( current )
        callback( x, y )
      }
      current = 0
      bits = 0
    }
  }
  return values
}
const drivingCoordinatesToFeature = (coordinates) => {
  return {
    type: 'Feature',
    geometry: {
      type: 'LineString',
      coordinates: coordinates
    }   
  }
}
const directions = {{get_directions.data}};
if (directions && directions.routes && directions.routes.length) {
  let decoded = decode(directions.routes[0].overview_polyline.points);
  let features = [];
  features.push(drivingCoordinatesToFeature(decoded.map(p=>p.reverse()))) // google maps coordinate pairs are opposite of MapBox
  if (directions.routes[1] && directions.routes[0].overview_polyline.points) {
    decoded = decode(directions.routes[1].overview_polyline.points);
    features.push(drivingCoordinatesToFeature(decoded.map(p=>p.reverse()))) // google maps coordinate pairs are opposite of MapBox
  }
  return {
    type: 'FeatureCollection',
    features: features
  }
} else {
  return undefined;
}
