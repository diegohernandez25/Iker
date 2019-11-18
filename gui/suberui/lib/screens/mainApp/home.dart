import 'package:flutter/material.dart';
import 'package:suberui/shared/components/EventTile.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:suberui/services/auth.dart';




class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  final List<EventTile> evtList=[
    EventTile(
        eventImage: AssetImage('Images/super.png'),
        eventTitle:'SuperBock',
        date:'date',
        location:'location'
    ),
    EventTile(
        eventImage: AssetImage('Images/voa.jpg'),
        eventTitle:'VOA',
        date:'date',
        location:'location'
    ),
    EventTile(
        eventImage: AssetImage('Images/edp.jpg'),
        eventTitle:'EDP',
        date:'date',
        location:'location')

  ];

  final eventList = List<EventTile>.generate(20,
          (i) {

        return EventTile(
          eventImage: AssetImage('Images/super.png'),
          eventTitle:'title $i',
          date:'date',
          location:'location',
        );
      }
  );
  final soccerList = List<EventTile>.generate(20,
          (i) {
        return EventTile(
          eventImage: AssetImage('Images/super.png'),

          eventTitle:'title $i',
          date:'date',
          location:'location',
        );
      }
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Main Page"),
          backgroundColor: Colors.teal[500],
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () async{
                  await _auth.signOutGoogle();
                },
                icon: Icon(Icons.person),
                label: Text('logout'))
          ],
        ),
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 25.0),
            Text(
              'Events Near You',
              style: TextStyle(
                  color: Colors.teal,
                  fontSize: 30.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.bold
              ),
            ),
            CarouselSlider(
              height: 200.0,
              items: evtList.map((i) {
                return Builder(
                    builder: (BuildContext context){
                      return i;
                    }
                );
              }).toList(),
            ),


            SizedBox(height: 25.0),
            Text(
              'Soccer Games',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.teal,
                  fontSize: 30.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.bold
              ),
            ),
            CarouselSlider(
              height: 200.0,
              items: eventList.map((i) {
                return Builder(
                    builder: (BuildContext context){
                      return i;
                    }
                );
              }).toList(),
            ),

          ],
        )
    );
  }
}