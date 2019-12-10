import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suberui/models/bookedTrip.dart';
import 'package:suberui/models/user.dart';
import 'package:suberui/shared/components/MyBookedTripTile.dart';
import 'package:suberui/shared/components/customDrawer.dart';
import 'package:http/http.dart' as http;

class MyBookedTrips extends StatefulWidget {
  @override
  _MyBookedTripsState createState() => _MyBookedTripsState();
}

class _MyBookedTripsState extends State<MyBookedTrips> {
  List<BookedTrip> _fetchedListOfTrips = [];
  void _getTrips (User user) async {
    final _authority = "168.63.30.192:5000";
    final _path = "/get_my_reservations";
    final _params={
      "usr_id": user.uid
    };
    final _uri =  Uri.http(_authority, _path,_params);
    print(_uri.toString());
    http.Response res = await http.get(_uri.toString());
    print(res.statusCode);
    if (res.statusCode == 200) {
      List<dynamic> body = json.decode(res.body);
      List<BookedTrip> tripList = body.map((dynamic item) => BookedTrip.fromJson(item),)
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
        title: Text("Booked Trips"),
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
              itemCount: _fetchedListOfTrips.isEmpty?1:_fetchedListOfTrips.length,
              itemBuilder: (context, index) {
                return  _fetchedListOfTrips.isNotEmpty
                  ?Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: GestureDetector(
                    onTap: (){
                      //showDialog(context: null);
                    },
                    child: MyBookedTripTile(
                        trip: _fetchedListOfTrips[index]
                    ),
                  ),
                )
                    :
                Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('No Booked Trips', style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),)
                      ],
                    ));
              }
          )
      ),
    );
  }
}
