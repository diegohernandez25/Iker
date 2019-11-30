
//TODO Driver id
import 'package:flutter/cupertino.dart';

class Trip {
  final int tid;
  final String authorId;
  final String authorName;
  final ImageProvider authorImage;
  final num authorRtng;
  final num price;


  Trip ({this.tid, this.authorId,this.authorName, this.authorImage,this.authorRtng,this.price});

  /*factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tid: json['id'] as int,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorImage: json['authorName'] as String,
      authorRtng: json['geometry']['location']['lat'] as double,
      price: json['geometry']['location']['lng'] as double,
    );
  }*/
}