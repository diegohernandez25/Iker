import 'package:flutter/cupertino.dart';

class Event {

  final int eid;
  final String name;
  final ImageProvider eventImage;
  final String description;
  final DateTime date;
  final String location;

  Event ({this.eid, this.name,this.eventImage, this.description,this.date,this.location});


  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eid: json['id'] as int,
      name: json['name'] as String,
      eventImage: NetworkImage(json['image_url']),
      description: json['description'] as String,
      date: DateTime.parse(json['date']+' 00:00:00.000'),
      location: json['city'] as String,
    );
  }

}