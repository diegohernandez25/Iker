import 'package:flutter/cupertino.dart';

class Review {

  final String rid;
  final String authorId;
  final String reviewedObjectID;
  final num rating;
  final String reviewText;
  final DateTime rdate;
  final ImageProvider image;
  final String usrName;

  Review({this.rid,this.authorId,this.reviewedObjectID,this.rating, this.reviewText, this.rdate,this.image,this.usrName});

  factory Review.fromJson(Map<String, dynamic> json) {
    print('-------------------------'+json['img_url']);
    return Review(
      rid: json['_id'] as String,
      authorId: json['authorID'] as String,
      reviewedObjectID: json['reviewdObjectID'] as String,
      rating: json['rating'] as num ,
      reviewText: json['reviewText'] as String,
      rdate: DateTime.parse(json['date']),
      image: NetworkImage(json['img_url']),
      usrName: json['name'] as String
      //price: json['pro']
    );
  }
}