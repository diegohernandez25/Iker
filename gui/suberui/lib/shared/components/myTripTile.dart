import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suberui/models/event.dart';
import 'package:suberui/models/trip.dart';
import 'package:suberui/models/mytrip.dart';
import 'package:suberui/shared/components/starDisplay.dart';

class MyTripTile extends StatelessWidget {
  final MyTrip trip;
  MyTripTile ({Key key,@required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Positioned(
              child:
              Stack(
                  children: <Widget> [
                    Container(
                      height: 90,
                      width: size.width-63,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: new LinearGradient(
                              colors:[
                                Colors.green[900],
                                Colors.green[500]
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50, right:10, bottom: 10,top: 10),
                        child:
                        Row(

                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(trip.eventName,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23
                                    ),
                                  ),

                                  SizedBox(height: 12,),
                                  Text(DateFormat('yyyy-MM-dd kk:mm').format(trip.startTime),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),

                      ),
                    ),
                  ]
              ),
            ),

            Positioned(
              left: 0,
              child: CircleAvatar(
                  radius: 35,
                  backgroundImage: trip.eventImg
              ),
            )
          ]
      ),
    );
  }
}
