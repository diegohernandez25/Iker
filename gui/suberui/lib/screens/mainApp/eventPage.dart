import 'package:flutter/material.dart';
import 'package:suberui/services/auth.dart';
import 'package:suberui/models/event.dart';
import 'tripSearch.dart';
import 'package:provider/provider.dart';
import 'package:suberui/models/user.dart';


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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.imageUrl),
                    radius: 20.0,
                  ),
                ),
                FlatButton.icon(
                    onPressed: () async{
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                      await _auth.signOutGoogle();

                    },
                    icon: Icon(Icons.power_settings_new ),
                    label: Text(''))
              ],
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(event.name,
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
                Text("Super Bock Super Rock",
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
                    Text(event.location,style: Theme.of(context).textTheme.subhead,)
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.calendar_today,size: 40),
                    SizedBox(width: 10),
                    Text("10-2-2019",style: Theme.of(context).textTheme.subhead,)
                  ],
                ),
                SizedBox(height: 60),

              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TripSearch()),
          );
        },
        label: Text('Book Trip'),
        icon: Icon(Icons.bookmark),
        backgroundColor: Colors.green[900],
      ),
    );

  }
}
