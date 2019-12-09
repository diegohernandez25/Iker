import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class GPSignaler{

  Timer timer;
  final tripId;
  Function(Position p) onUpdate;

  GPSignaler({@required this.tripId, this.onUpdate});

  void _sendToBackend(Position p) {
    final _authority = "168.63.30.192:8081";
    final _path = "trip_update";

    final _uri =  Uri.http(_authority, _path);
    Map<String, dynamic> body={
      "TripId": tripId,
      "Coords":[p.latitude,p.longitude]
    };
    http.post(_uri.toString(),
        headers: { "accept": "application/json", "content-type": "application/json" },
        body: json.encode(body));
  }

  void startSignaling(){
    print("Timer called");
    timer= Timer.periodic(Duration(seconds: 5), (timer) async{
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print('GPS Signal sent : '+position.latitude.toString()+position.longitude.toString());
      _sendToBackend(position);
      onUpdate(position);
    });
  }

  void stopSignaling(){
    if(timer!=null){
      timer.cancel();
    }
  }


}