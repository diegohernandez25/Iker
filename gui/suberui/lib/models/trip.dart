
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
}