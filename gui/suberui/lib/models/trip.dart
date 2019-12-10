
//TODO Driver id
import 'package:flutter/cupertino.dart';

class Trip {
  final int tid;
  final String authorEmail;
  final String authorName;
  final ImageProvider authorImage;
  final num authorRtng;
  final num price;
  final int hour;



  Trip ({this.tid, this.authorEmail,this.authorName, this.authorImage,this.authorRtng,this.price, this.hour});

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tid: json['id'] as int,
      authorEmail: json['mail'] as String,
      authorName: json['usr_name'] as String,
      authorImage: NetworkImage(json['user_img']),
      authorRtng: json['review'] as num,
      price: json['price'] as num,
      hour: json['hour'] as int
      //price: json['pro']
    );
  }
}