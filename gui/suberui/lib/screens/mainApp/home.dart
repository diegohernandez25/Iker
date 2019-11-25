import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suberui/models/user.dart';
import 'package:suberui/models/event.dart';
import 'package:suberui/shared/components/EventTile.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:suberui/services/auth.dart';
import 'profileScreen.dart';




class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

 final List<Event> listOfEvents=[
   Event(
     eid: 1,
     name:'SuperRock',
     eventImage: AssetImage('Images/super.png'),
     description:'O Super Bock Super Rock é um dos festivais de música mais famosos e aclamados de Portugal. Todos os verões, o festival convida atuações de renome internacional para um alinhamento que inclui também muitos talentos locais.',
     date: DateTime.now(),
     location: 'Lisboa'
   ),
   Event(
       eid: 2,
       name:'VOA',
       eventImage: AssetImage('Images/voa.jpg'),
       description:'Description',
       date: DateTime.now(),
       location: 'Lisboa'
   ),
   Event(
       eid: 1,
       name:'EDP CoolJazz',
       eventImage: AssetImage('Images/edp.jpg'),
       description:'Description',
       date: DateTime.now(),
       location: 'Lisboa'
   )
 ];

  @override
  Widget build(BuildContext context) {
    final user= Provider.of<User>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Main Page"),
          //backgroundColor: Colors.teal[500],
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.imageUrl),
                  radius: 20.0,
                ),
              ),
            ),
            FlatButton.icon(
                onPressed: () async{
                  await _auth.signOutGoogle();
                },
                icon: Icon(Icons.power_settings_new ),
                label: Text(''))
          ],
        ),
        body:SingleChildScrollView(
          child: Column(
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
                items: listOfEvents.map((i) {
                  return Builder(
                      builder: (BuildContext context){
                        return EventTile(event: i);
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
                items: listOfEvents.map((i) {
                  return Builder(
                      builder: (BuildContext context){
                        return EventTile(event: i,);
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
                items: listOfEvents.map((i) {
                  return Builder(
                      builder: (BuildContext context){
                        return EventTile(event: i,);
                      }
                  );
                }).toList(),
              ),

            ],
          ),
        )
    );
  }
}