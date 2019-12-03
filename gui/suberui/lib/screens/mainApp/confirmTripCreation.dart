import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suberui/models/event.dart';
import 'package:suberui/models/user.dart';
import 'package:suberui/shared/components/customDrawer.dart';

import 'package:http/http.dart' as http;

class ConfirmTripCreation extends StatefulWidget {

  final Event event;
  final String lastBody;
  final num cost;
  final num dist;
  final num time;

  ConfirmTripCreation({this.event,this.lastBody,this.cost,this.dist,this.time});


  @override
  _ConfirmTripCreationState createState() => _ConfirmTripCreationState();
}

class _ConfirmTripCreationState extends State<ConfirmTripCreation> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _textFormPriceController;
  TextEditingController _textFormDetController;


  TimeOfDay _time= new TimeOfDay.now();
  num _price;
  num _maxDet=0.0;
  String _seats="1";


  //Functions
  Future<Null> _selectTime(BuildContext context) async{

    final TimeOfDay picked = await showTimePicker(context: context, initialTime: _time);

    if(picked != null && picked != _time ){
      print('Time selected: : ${_time.toString()}');
      setState(() {
        _time=picked;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    print('[Confirm Trip Creation] cost: '+widget.cost.toString());
    _textFormPriceController= new TextEditingController(text: (widget.cost/2).toStringAsFixed(2));
    _textFormDetController= new TextEditingController(text: '0.0');
    setState(() {
      _price=(widget.cost/2);
    });
  }
  @override
  Widget build(BuildContext context) {

    final user= Provider.of<User>(context);
    void _sendFormInfo() async{
      final _authority = "168.63.30.192:5000";
      final _path = "register_trip";
      final _params={
        "usr_id": user.uid
      };
      Map<String, dynamic> jsonBody= json.decode(widget.lastBody);

      jsonBody['EventID']=widget.event.eid;
      jsonBody['City']="Nada";
      jsonBody['MaxDetour']=_maxDet;
      jsonBody['StartTime']= _time.hour*60*60+_time.minute*60;
      jsonBody['name']="name";
      jsonBody['information']="info";
      jsonBody['Price']=_price;
      jsonBody['NumSeats']=int.parse(_seats);

      print(json.encode(jsonBody));


      final _uri =  Uri.http(_authority, _path, _params);

      print(_uri.toString());

      http.Response res = await http.post(_uri.toString(),
          headers: { "accept": "application/json", "content-type": "application/json" },
          body: json.encode(jsonBody));

      //print(_uri.toString());
      print(res.statusCode);
      print(res.body);

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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Start Time: ', style: TextStyle(
                fontSize: 25
              ),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  color: Colors.teal,
                                ),
                                Text(
                                  _time.hour.toString()+':'+_time.minute.toString(),
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                onPressed: (){
                  _selectTime(context);
                },
              ),
              SizedBox(height: 20,),
              Form(
                key:  this._formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Number of available seats:  ', style: TextStyle(
                            fontSize: 20
                          ),),
                          DropdownButton<String>(
                            value: _seats,
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
                                _seats = newValue;
                                _price =  widget.cost/(int.parse(_seats)+1);
                              });
                              _textFormPriceController.text=_price.toStringAsFixed(2);
                            },
                            items: <String>['1', '2', '3','4', '5', '6','7', '8']
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
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextFormField(

                        //initialValue: '0.0',
                        controller: _textFormDetController,
                        decoration: const InputDecoration(
                            labelText: 'Max Detour in Km',
                            labelStyle: TextStyle(
                                fontSize: 20
                            )
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _maxDet=double.parse(value);
                          });

                        },
                        onTap: (){
                          _textFormDetController.clear();
                        },
                        validator: (String value) {
                          print('Detour');
                          print(value);
                          return value==null ? 'Plese enter number' : null;
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(height: 40,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextFormField(
                        controller: _textFormPriceController,
                        decoration: const InputDecoration(
                            labelText: 'Price in €',
                            labelStyle: TextStyle(
                                fontSize: 20
                            )
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _price=double.parse(value);
                          });

                        },
                        onTap: (){
                          _textFormPriceController.clear();
                        },
                        validator: (String value) {
                          print('Price');
                          print(value);
                          return value==null ? 'Plese enter number' : null;
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () async{

                      if(this._formKey.currentState.validate()) {
                        _sendFormInfo();
                      }
                    },
                    child: Text('Register Trip'),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
