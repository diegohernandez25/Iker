import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suberui/models/user.dart';
import 'package:suberui/models/event.dart';
import 'package:suberui/shared/components/EventTile.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:suberui/services/auth.dart';
import 'profileScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:suberui/shared/components/customDrawer.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {



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

  List<Event> _fetchedListOfEvents = [
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _getEvents();
  }


  void _getEvents () async {
    print('im here');
    final _authority = "168.63.30.192:5000";
    final _path = "get_all_events";
    //final _params = {};
    final _uri =  Uri.http(_authority, _path);
    print(_uri.toString());


    http.Response res = await http.get(_uri.toString());
    if (res.statusCode == 200) {
      List<dynamic> body = json.decode(res.body);

      List<Event> eventList = body.map((dynamic item) => Event.fromJson(item),)
          .toList();
      //print(eventList.length);
      for (int i = 0; i < eventList.length; i++) {

        //print(eventList[i].eid);
       /* print(eventList[i].name);
        print(eventList[i].eventImage);
        print(eventList[i].description);
        print(eventList[i].date);
        print(eventList[i].location);
        print('..............');*/
      }


      setState(() { _fetchedListOfEvents = eventList; });
    }
    else{
      setState(() { _fetchedListOfEvents = listOfEvents; });
    }

  }

  @override
  Widget build(BuildContext context) {
    //_getEvents();
    print(_fetchedListOfEvents.length);

    final user= Provider.of<User>(context);

    return  DefaultTabController(
      length: 2,
      child: new Scaffold(
          appBar: AppBar(
            title: Text("Main Page"),
            //backgroundColor: Colors.teal[500],

          ),
          body:TabBarView(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Test'),
                        onPressed: () async{
                          _getEvents();
                        },
                      ),
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
                        items: _fetchedListOfEvents.map((i) {
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
                        items: _fetchedListOfEvents.map((i) {
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
                        items: _fetchedListOfEvents.map((i) {
                          return Builder(
                              builder: (BuildContext context){
                                return EventTile(event: i,);
                              }
                          );
                        }).toList(),
                      ),

                    ],
                  ),

                ),
                GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                    new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: _fetchedListOfEvents.length  ,

                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: EventTile(
                              event:  _fetchedListOfEvents[index]
                          )
                      );
                    }
                ),

              ]
          ),
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                icon: new Icon(Icons.home),
              ),
              Tab(
                icon: new Icon(Icons.search),
              ),


            ],
            labelColor: Colors.green[900],
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.green,
          ),



          drawer: CustomDrawer()
      ),

    );
  }
}

