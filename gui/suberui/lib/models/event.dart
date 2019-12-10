import 'package:flutter/cupertino.dart';

class Event {

  final int eid;
  final String name;
  final ImageProvider eventImage;
  final String description;
  final DateTime date;
  final String location;
  final String category;

  Event ({this.eid, this.name,this.eventImage, this.description,this.date,this.location, this.category});


  factory Event.fromJson(Map<String, dynamic> json) {

    return Event(
      eid: json['id'] as int,
      name: json['name'] as String,
      eventImage: NetworkImage(json['image_url']),
      description: json['description'] as String,
      date: DateTime.parse(json['date']),
      location: json['city'] as String,
      category: json['category'] as String
    );
  }

}