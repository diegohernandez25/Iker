import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suberui/models/event.dart';
import 'package:suberui/models/location.dart';
import 'package:suberui/models/user.dart';
import 'package:suberui/screens/mainApp/_____tripDetail.dart';
import 'package:suberui/screens/mainApp/tripPurchase.dart';
import 'package:suberui/services/auth.dart';
import 'package:suberui/shared/components/purchaseDialog.dart';
import 'package:suberui/shared/components/tripTile.dart';
import 'package:suberui/models/trip.dart';
import 'package:suberui/shared/components/customDrawer.dart';
import 'package:http/http.dart' as http;

class TripSearch extends StatefulWidget {
  final Event event;
  final Location location;
  TripSearch({this.event,this.location});
  @override
  _TripSearchState createState() => _TripSearchState();
}



class _TripSearchState extends State<TripSearch> {
  final AuthService _auth = AuthService();

  List<Trip> _fetchedListOfTrips = [];

  void _getTrips () async {


    print('-----------------------------------------event ID'+widget.event.eid.toString());

    final _authority = "168.63.30.192:5000";
    final _path = "/get_av_trips_event";
    final _params = {
      "event_id": widget.event.eid.toString(),
      "lat": widget.location.lat.toString(),
      "lon": widget.location.lon.toString()
    };
    final _uri =  Uri.http(_authority, _path,_params);
    print(_uri.toString());


    http.Response res = await http.get(_uri.toString());
    if (res.statusCode == 200) {
      List<dynamic> body = json.decode(res.body);

      List<Trip> tripList = body.map((dynamic item) => Trip.fromJson(item),)
          .toList();


      //print(eventList.length);
      for (int i = 0; i < tripList.length; i++) {
        print(tripList[i].tid);
      }

      setState(() { _fetchedListOfTrips = tripList; });
    }
    else{
      setState(() { _fetchedListOfTrips = []; });
    }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTrips();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.event.name);

    final user= Provider.of<User>(context);
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Trip Search"),
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
                         /* Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TripPurchase()),
                          );*/


                          showDialog(
                            context: context,
                            builder: (BuildContext context) => PurchaseDialog(
                              trip: _fetchedListOfTrips[index],
                              event: widget.event,
                              location: widget.location,
                            ),
                          );
                        },
                        child: TripTile(
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
