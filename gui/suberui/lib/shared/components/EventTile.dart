import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:suberui/models/event.dart';
import 'package:suberui/screens/mainApp/eventPage.dart';

class EventTile extends StatefulWidget {
  EventTile({
    Key key,
    this.event
    /*this.eventId,
    this.eventImage,
    this.eventTitle,
    this.date,
    this.location,*/

  }) : super(key: key);

  final Event event;
  /*final int eventId;
  final AssetImage eventImage;
  final String eventTitle;
  final String date;
  final String location;*/

  @override
  EventTileState createState() => EventTileState();
}

class EventTileState extends State<EventTile> {
  bool _isFavorited=true;

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _isFavorited = false;
      } else {
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return
    GestureDetector(
          onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context ) => EventPage(event: widget.event,)),
          );
        },
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.8,
            child:Container(
              height: 200.0,
              margin: new EdgeInsets.all(10.0),
              decoration: new BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: widget.event.eventImage,
                  fit: BoxFit.fill),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4.0, // has the effect of softening the shadow
                    spreadRadius: 1, // has the effect of extending the shadow
                    offset: Offset(
                      8.0, // horizontal, move right 10
                      8.0, // vertical, move down 10
                    ),
                  )
                ],

                borderRadius: new  BorderRadius.circular(20.0),
               /* gradient: new LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.1, 0.5, 0.7, 0.9],
                  colors: [
                    Colors.indigo[800],
                    Colors.indigo[700],
                    Colors.indigo[600],
                    Colors.indigo[400],
                  ],
                ),

                */


              ),
              /*
              child: Card(semanticContainer: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                    children: <Widget>[
                      eventImage,
                      Text(
                        'SuperBock SuperRock',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ]),
              )
                */
            )
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              /*Row(
                children: <Widget>[
                  Expanded (child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text(widget.event.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold
                      ),

                      ),
                    )
                    ),

]           )*/
            ],
          )
        ]
      ),
    );
  }
}

