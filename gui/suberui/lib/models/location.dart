class Location {

  final String name;

  final double lat;
  final double lon;


  Location({this.name, this.lat,this.lon});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['formatted_address'] as String,
      lat: json['geometry']['location']['lat'] as double,
      lon: json['geometry']['location']['lng'] as double,
    );
  }
/*
  static Location fromJson(Map<String, dynamic> json) {
    Location l = new Location(
      name:json['formatted_address'] as String,
      lat: json['geometry']['location']['lat'] as int,
      lon: json['geometry']['location']['lng'] as int,
  );
    return l;
}*/


}