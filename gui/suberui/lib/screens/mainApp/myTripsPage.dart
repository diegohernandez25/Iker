import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suberui/models/event.dart';
import 'package:suberui/models/location.dart';
import 'package:suberui/models/mytrip.dart';
import 'package:suberui/models/user.dart';
import 'package:suberui/screens/mainApp/_____tripDetail.dart';
import 'package:suberui/screens/mainApp/tripPurchase.dart';
import 'package:suberui/screens/mainApp/tripScreen.dart';
import 'package:suberui/services/auth.dart';
import 'package:suberui/shared/components/purchaseDialog.dart';
import 'package:suberui/shared/components/tripTile.dart';
import 'package:suberui/shared/components/myTripTile.dart';
import 'package:suberui/models/trip.dart';
import 'package:suberui/shared/components/customDrawer.dart';
import 'package:http/http.dart' as http;

class MyTripsPage extends StatefulWidget {
  final Event event;
  final Location location;
  MyTripsPage({this.event,this.location});
  @override
  _MyTripsPageState createState() => _MyTripsPageState();
}



class _MyTripsPageState extends State<MyTripsPage> {
  final AuthService _auth = AuthService();

  List<MyTrip> _fetchedListOfTrips = [];

  void _getTrips (User user) async {

    //print('-----------------------------------------event ID'+widget.event.eid.toString());

    final _authority = "168.63.30.192:5000";
    final _path = "/get_my_trips";
    final _params={
      "usr_id": user.uid
    };

    final _uri =  Uri.http(_authority, _path,_params);
    print(_uri.toString());

    http.Response res = await http.get(_uri.toString());
    print(res.statusCode);

    if (res.statusCode == 200) {
      List<dynamic> body = json.decode(res.body);
      List<MyTrip> tripList = body.map((dynamic item) => MyTrip.fromJson(item),)
          .toList();

      setState(() { _fetchedListOfTrips = tripList; });
    }
    else{
      setState(() { _fetchedListOfTrips = []; });
    }


  }

  @override
  void initState() {
    Future.delayed(Duration.zero,() {
      _getTrips(Provider.of<User>(context));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("My trips"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
            },
          ),
        ],
        //backgroundColor: Colors.teal[500],
      ),
      body: Padding(
          padding: EdgeInsets.all(0.0),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _fetchedListOfTrips.length,
              itemBuilder: (context, index) {
                return  Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => tripScreen(mtrip:_fetchedListOfTrips[index])));

                     //introduce logic here
                    },
                    child: MyTripTile(
                        trip: _fetchedListOfTrips[index]
                    ),
                  ),
                );
              }
          )
      ),
    );
  }
}
