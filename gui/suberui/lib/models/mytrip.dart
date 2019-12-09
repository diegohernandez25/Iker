
//TODO Driver id
import 'package:flutter/cupertino.dart';

class MyTrip {
  final bool available;
  final ImageProvider eventImg;
  final String eventName;
  final num id;
  //Waypints
  final List<dynamic> coords;
  final List<dynamic> waypoints;
  final DateTime startTime;
  final int idIPTF;

  MyTrip ({this.available, this.eventImg,this.eventName,this.id,this.coords,this.waypoints,this.startTime, this.idIPTF});

  factory MyTrip.fromJson(Map<String, dynamic> json) {
    print(json['trip']['StartTime']);
    return MyTrip (
      available: json['available'] as bool,
      eventImg: NetworkImage(json['eventImg']),
      eventName: json['eventName'] as String,
      id: json['id'] as num,
      coords: json['trip']['Coords'] as List<dynamic>,
      waypoints: json['trip']['Waypoints'] as List<dynamic>,
      startTime: DateTime.fromMillisecondsSinceEpoch(json['trip']['StartTime']*1000),
      idIPTF: json['id_iptf']
      //price: json['pro']
    );
  }
}