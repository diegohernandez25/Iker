import 'package:flutter/material.dart';
import 'package:suberui/models/trip.dart';
import 'package:suberui/shared/components/starDisplay.dart';

class TripTile extends StatelessWidget {
  final Trip trip;
  TripTile({Key key,@required this.trip}) : super(key: key);

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
                                Text(trip.authorName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23
                                  ),
                                ),

                                SizedBox(height: 12,),
                                IconTheme(
                                  data: IconThemeData(
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  child: StarDisplay(value: trip.authorRtng.round()),
                                ),
                              ],
                            ),
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(trip.price.toString()+'€',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23
                                ),
                              ),
                            ],
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
              backgroundImage: trip.authorImage
            ),
          )
      ]
      ),
    );
  }
}
