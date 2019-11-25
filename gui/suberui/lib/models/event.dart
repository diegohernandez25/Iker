import 'package:flutter/cupertino.dart';

class Event {

  final int eid;
  final String name;
  final AssetImage eventImage;
  final String description;
  final DateTime date;
  final String location;

  Event ({this.eid, this.name,this.eventImage, this.description,this.date,this.location});
}