import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:suberui/models/trip.dart';
import 'package:suberui/shared/components/webDialog.dart';
import 'package:suberui/shared/components/starDisplay.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:suberui/models/location.dart';



class TripPurchase extends StatefulWidget {
  final Trip trip;
  TripPurchase({this.trip});
  @override
  _TripPurchaseState createState() => _TripPurchaseState();
}

class _TripPurchaseState extends State<TripPurchase> {

  final TextEditingController _typeAheadController = TextEditingController();

  Location _selectedLocation= null;
  String _selectedLocationText= null;

  //TODO Escape query
  Future<List<Location>>  _getSuggestions (String query) async {
    final _authority = "maps.googleapis.com";
    final _path = "maps/api/geocode/json";
    final _params = { "address" : query , "key": 'AIzaSyDDuuTiQwp9tXWUTWE1tRs3oYCr90Lz6YE'};
    final _uri =  Uri.https(_authority, _path, _params);
    print(_uri.toString());

    http.Response res = await http.get(_uri.toString());

    List<dynamic> body = json.decode(res.body)['results'];

    List<Location> locList = body.map((dynamic item) => Location.fromJson(item),).toList();
    locList.map((item) => print(item.name));
    return locList;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Purchase"),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Container(
            height: 500,
            width: 400,
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.red ,
                ),
                Text('Name', style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                ),
                IconTheme( data: IconThemeData(color: Colors.amber, size: 30,),child: StarDisplay(value: 5)),
                Text(
                    'See profile'
                ),
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: this._typeAheadController,
                      decoration: InputDecoration(
                          labelText: 'Location'
                      )
                  ),

                  suggestionsCallback: (pattern) {
                    return _getSuggestions(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion.name),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    this._typeAheadController.text = suggestion.name;
                    this._selectedLocation=suggestion;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please select a city';
                    }
                    return null;
                  },
                  onSaved: (value) => this._selectedLocationText = value,

                ),
                SizedBox(height: 40,),
                Row(
                  children: <Widget>[
                    Icon(
                        Icons.pin_drop
                    ),
                    Text('Location')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                        Icons.event
                    ),
                    Text('Date')
                  ],
                ),

                //TypeAheadField(),
                Text('Price', style: TextStyle(
                    fontSize: 30
                ),),

            RaisedButton(
              onPressed: (){
                print(_selectedLocation.lat);
                print(_selectedLocation.lon);
              },
              child: Text('hello'),
            ),


                SizedBox(height: 30,),
                RaisedButton(
                  onPressed: (){

                    showDialog(
                        context: context,
                        builder: (BuildContext context) => WebDialog()
                    );
                  },
                  color: Colors.green[900],
                  child: Text('Book',style: TextStyle(color: Colors.white),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
