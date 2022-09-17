console.log("running transformer", arr);
var arr = [];

console.log("testing", data);
//const val = {{get_sentiment_data_with_coordinates.data}};
console.log("hello testing", get_sentiment_data_with_coordinates.data);
console.log("hello lats", get_sentiment_data_with_coordinates.data.lat);

var data = get_sentiment_data_with_coordinates.data.coordinates;
console.log("RUNNING DATA", data)

for (let i = 0; i < get_sentiment_data_with_coordinates.data.lat.length; i++) {
  var dict = {}
  console.log("looping", get_sentiment_data_with_coordinates.data.lat[i]);
  dict["longitude"] = get_sentiment_data_with_coordinates.data.long[i];
  dict["latitude"] = get_sentiment_data_with_coordinates.data.lat[i];
  arr.push(dict);
  }
console.log("arrar", arr)

return arr
