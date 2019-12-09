import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:suberui/models/event.dart';
import 'package:suberui/models/location.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:suberui/models/user.dart';
import 'package:suberui/screens/mainApp/confirmTripCreation.dart';
import 'package:suberui/shared/components/customDrawer.dart';



class CreateTrip extends StatefulWidget {
  @override
  _CreateTripState createState() => _CreateTripState();

  final Event event;
  CreateTrip({this.event});
}

class _CreateTripState extends State<CreateTrip> {

  //Controllers
  final TextEditingController _typeAheadController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _textFormController;
  TextEditingController _textFormController2;
  TextEditingController _textFormController3;

  //Variables
  List<String> _dropVals=['diesel','gpl','petrol'];

  Location _selectedLocation= null;
  String _selectedLocationText= null;
  bool _tolls=false;
  num _cons50=0.0;
  num _cons90=0.0;
  num _cons120=0.0;
  String _fuelType = 'diesel';
  String _body;

  //Functions
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _textFormController= new TextEditingController(text: '0.0');
    _textFormController2= new TextEditingController(text: '0.0');
    _textFormController3= new TextEditingController(text: '0.0');
  }

  @override
  Widget build(BuildContext context) {

    final user= Provider.of<User>(context);
    Future<String> _sendFormInfo() async{
      final _authority = "168.63.30.192:5000";
      final _path = "probe_trip";
      final _params={
        "event_id": widget.event.eid.toString()
      };

      //print(_params['event_id']);


      final _uri =  Uri.http(_authority, _path, _params);
      Map<String, dynamic> body={
        "StartCoords": [_selectedLocation.lat,_selectedLocation.lon],
        "MaxDetour": 0,
        "Consumption": [_cons50,_cons90,_cons120],
        "AvoidTolls": _tolls,
        "StartTime": 0,
        "FuelType": _fuelType
      };

      setState(() {
        _body = json.encode(body);
      });


      print(_uri.toString());

      http.Response res = await http.post(_uri.toString(),
          headers: { "accept": "application/json", "content-type": "application/json" },
          body: json.encode(body));

      print(json.encode(body));

      return res.body;

    }

    return Scaffold(
      drawer: CustomDrawer(),
        appBar: AppBar(
          title: Text("Create Trips"),
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
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[

               Form(
                  key:  this._formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TypeAheadFormField(

                        textFieldConfiguration: TextFieldConfiguration(
                            controller: this._typeAheadController,
                            decoration: InputDecoration(
                                labelText: 'Starting Location'
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
                          if (value.isEmpty || this._selectedLocation==null) {
                            return 'Please Select a Location';
                          }
                          return null;
                        },
                        onSaved: (value) => this._selectedLocationText = value,

                      ),
                      SizedBox(height: 50),
                      Text('Consumption'),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: _textFormController,
                              //initialValue: '0.0',
                              decoration: const InputDecoration(
                                labelText: 'at 50 km',
                                labelStyle: TextStyle(
                                  fontSize: 20
                                )
                              ),
                              onChanged: (String value) {
                                _cons50=double.parse(value);
                              },
                              onTap: () {
                                _textFormController.clear();
                              },
                              validator: (String value) {
                                return value==null ? 'Plese enter number' : null;
                              },
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              controller: _textFormController2,
                              //initialValue: '0.0',
                              decoration: const InputDecoration(
                                  labelText: 'at 90 km',
                                  labelStyle: TextStyle(
                                      fontSize: 20
                                  )
                              ),
                              onChanged: (String value) {
                                  setState(() {
                                    _cons90=double.parse(value);
                                  });
                              },
                              onTap: () {
                                _textFormController2.clear();
                              },
                              validator: (String value) {
                                return value==null ? 'Plese enter number' : null;
                              },
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              //initialValue: '0.0',
                              controller: _textFormController3,
                              decoration: const InputDecoration(
                                  labelText: 'at 120 km',
                                  labelStyle: TextStyle(
                                      fontSize: 20
                                  )
                              ),
                              onChanged: (String value) {
                                print(setState);
                                setState(() {
                                  _cons120=double.parse(value);
                                });
                                print(setState);
                              },
                              onTap: (){
                                _textFormController3.clear();
                              },
                              validator: (String value) {
                                return value==null ? 'Plese enter number' : null;
                              },
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),


                      Row(
                        children: <Widget>[
                          Text('Avoid tolls',style: TextStyle(
                            fontSize: 20
                          ),),
                          Switch(
                            value: _tolls,
                            onChanged: (newVal){
                              setState(() {
                                _tolls=newVal;
                                print(_tolls);
                              });
                            },
                          ),
                        ],
                      ),

                      Row(
                        children: <Widget>[
                          Text('Type of fuel: ', style: TextStyle(fontSize: 20),),
                          DropdownButton<String>(
                            value: _fuelType,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                                color: Colors.deepPurple
                            ),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                _fuelType = newValue;
                              });
                            },
                            items: <String>['diesel', 'petrol', 'gpl']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: TextStyle(fontSize: 20)),
                              );
                            })
                                .toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              //Expanded(child: SizedBox()),
              SizedBox(height: 100,),
              RaisedButton(
                onPressed: () async{

                if(this._formKey.currentState.validate()) {
                  print('[Create Trip] Form validated....');
                  String resposnseBody= await _sendFormInfo();
                  print(resposnseBody);
                  var rB=json.decode(resposnseBody);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmTripCreation(
                    event:widget.event,
                    lastBody:_body,
                    cost: rB['cost'] as num,
                    dist: rB['dist'] as num,
                    time: rB['time'] as num
                  )));
                }
                },
                child: Text('Prompt'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
