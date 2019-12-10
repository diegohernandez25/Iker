import 'package:flutter/material.dart';
import 'package:suberui/screens/mainApp/MyBookedTrips.dart';
import 'package:suberui/screens/mainApp/myTripsPage.dart';
import 'package:suberui/screens/mainApp/pendingRevList.dart';
import 'package:suberui/screens/mainApp/profileScreen.dart';
import 'package:suberui/screens/mainApp/reviewPage.dart';
import 'package:suberui/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:suberui/models/user.dart';


class CustomDrawer extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {

    final user= Provider.of<User>(context);

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green[900],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user.imageUrl)
                ),
                SizedBox(height: 10),
                Text(
                  user.name,
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  user.email,
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Home'),
            leading: Icon(Icons.home),
            onTap: () {

              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Profile'),
            leading: Icon(Icons.person),
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen(email: user.email,)),
              );
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Active Trips'),
            leading: Icon(Icons.directions_car),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyTripsPage()),
              );
              //Navigator.pop(context);
            },
          ),


          ListTile(
            title: Text('Booked Trips'),
            leading: Icon(Icons.book),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyBookedTrips()),
              );
              //Navigator.pop(context);
            },
          ),

          ListTile(
            title: Text('Pending Reviews'),
            leading: Icon(Icons.star),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PendingRevList()),
              );
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.power_settings_new),

            onTap: () async{

              //if(ModalRoute.of(context).settings.name!='/'){
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              //}
              await _auth.signOutGoogle();
              //
            },
          ),
        ],
      ),
    );
  }
}
