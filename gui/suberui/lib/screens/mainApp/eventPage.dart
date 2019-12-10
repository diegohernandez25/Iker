import 'package:flutter/material.dart';
import 'package:suberui/screens/mainApp/_____createTripHome.dart';
import 'package:suberui/screens/mainApp/createTrip.dart';
import 'package:suberui/screens/mainApp/locationPicker.dart';
import 'package:suberui/services/auth.dart';
import 'package:suberui/models/event.dart';
import 'tripSearch.dart';
import 'package:provider/provider.dart';
import 'package:suberui/models/user.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:suberui/shared/components/customDrawer.dart';
import 'package:intl/intl.dart';


class EventPage extends StatelessWidget {

  final Event event;
  EventPage({Key key, @required this.event}) : super(key: key);
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context, ) {

    final user= Provider.of<User>(context);

    return Scaffold(

      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,

              floating: true,
              pinned: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                  },
                ),
              ],

              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(event.name ,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: Image(
                    image: event.eventImage,
                    fit: BoxFit.cover,

                  )),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(event.name,
                  style: Theme.of(context).textTheme.title),
                SizedBox(height: 30),
                Text(event.description,
                style: Theme.of(context).textTheme.body2,
                textAlign: TextAlign.justify),
                SizedBox(height: 50),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.place,size: 40),
                    SizedBox(width: 10),

                    Expanded(child: Text(event.location,style: Theme.of(context).textTheme.subhead,))
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.calendar_today,size: 40),
                    SizedBox(width: 10),
                    Text(DateFormat('yyyy-MM-dd').format(event.date),style: Theme.of(context).textTheme.subhead,)
                  ],
                ),
                SizedBox(height: 60),

              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(

        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        backgroundColor: Colors.green[900],
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.bookmark),
              backgroundColor: Colors.green[700],
              label: 'Book Trip',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocationPicker(event: event,)),
                );
              }
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            backgroundColor: Colors.green[400],
            label: 'Create Trip',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateTrip(event: event,))
              );
            },
          ),

        ],
      ),

      drawer: CustomDrawer()
      /*floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TripSearch()),
          );
        },
        label: Text('Book Trip'),
        icon: Icon(Icons.bookmark),
        backgroundColor: Colors.green[900],
      ),*/
    );

  }
}
