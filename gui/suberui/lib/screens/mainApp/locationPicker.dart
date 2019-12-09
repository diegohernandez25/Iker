import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:suberui/models/event.dart';
import 'package:suberui/screens/mainApp/tripSearch.dart';
import 'package:suberui/shared/components/customDrawer.dart';
import 'package:suberui/models/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';

class LocationPicker extends StatefulWidget {
  final Event event;
  LocationPicker({this.event});
  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {

  final TextEditingController _typeAheadController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Location _selectedLocation= null;
  String _selectedLocationText= null;


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
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Location Picker"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Text('Starting location:', style: TextStyle(fontSize: 30),),
            Expanded(
              child: Form(
                key:  this._formKey,
                child: TypeAheadFormField(

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
                    if (value.isEmpty && this._selectedLocation!=null) {
                      return 'Please select a Location';
                    }
                    return null;
                  },
                  onSaved: (value) => this._selectedLocationText = value,

                ),
              ),
            ),
           // SizedBox(height: 100,),
            RaisedButton(

              onPressed: (){
                print('------------------------------------- id'+widget.event.eid.toString());
                if(this._formKey.currentState.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TripSearch(event: widget.event,location: _selectedLocation)),
                  );
                }
              },
              child: Text('Search Trips'),
            )
          ],
        ),
      ),
    );
  }
}
