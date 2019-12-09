import 'package:flutter/material.dart';

import 'package:suberui/screens/mainApp/reviewPage.dart';


class PendingRevTile extends StatelessWidget {
  final int id;
  final String imgURI;
  final String targetEmail;
  final String targetName;


  PendingRevTile ({Key key,@required this.id, @required this.imgURI, @required this.targetName, @required this.targetEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=> ReviewPage()
        ));
      },
      child: Padding(
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
                                child: FittedBox(
                                      child: Text('Trip By '+targetName,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
                    backgroundImage: NetworkImage(imgURI)
                ),
              )
            ]
        ),
      ),
    );
  }
}
