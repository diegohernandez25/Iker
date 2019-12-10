
//TODO Driver id
import 'package:flutter/cupertino.dart';

class BookedTrip {
  final String driverName;
  final ImageProvider driverImage;
  final String eventName;
  final DateTime tripDate;


  BookedTrip ({this.driverName, this.driverImage,this.eventName,this.tripDate});

  factory BookedTrip.fromJson(Map<String, dynamic> json) {

    return BookedTrip (
        driverName: json['driver']['usr_name'] as String,
        driverImage: NetworkImage(json['driver']['img_url']),
        eventName: json['event']['name'] as String,
        tripDate: DateTime.fromMillisecondsSinceEpoch((json['event']['date_epoch']+json['trip']['init_time'])*1000),

      //price: json['pro']
    );
  }
}