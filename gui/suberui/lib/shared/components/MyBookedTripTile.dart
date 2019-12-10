import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suberui/models/bookedTrip.dart';


class MyBookedTripTile extends StatelessWidget {
  final BookedTrip trip;
  MyBookedTripTile ({Key key,@required this.trip}) : super(key: key);

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
                                  FittedBox(
                                    fit:BoxFit.fitWidth,
                                    child: Text(trip.eventName,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,

                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 12,),
                                  FittedBox(
                                    fit:BoxFit.fitWidth,
                                    child: Text(DateFormat('yyyy-MM-dd kk:mm').format(trip.tripDate),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,

                                      ),
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
                  backgroundImage: trip.driverImage
              ),
            )
          ]
      ),
    );
  }
}
