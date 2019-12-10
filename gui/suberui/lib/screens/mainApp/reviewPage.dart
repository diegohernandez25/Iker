import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suberui/models/user.dart';
import 'package:suberui/shared/components/customDrawer.dart';
import 'package:suberui/shared/components/touchStarRating.dart';

import 'package:http/http.dart' as http;


class ReviewPage extends StatefulWidget {

  final int usrRating;
  final String usrName;
  final String usrEmail;
  final String image;

  ReviewPage({
    @required this.usrRating,
    @required this.usrEmail,
    @required this.usrName,
    @required this.image
  });


  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {

  String _reviewText;
  int _rating;

  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {


    final user= Provider.of<User>(context);

    void _sendForm() async{
      if(_formKey.currentState.validate()){
        print('form validated');
        _formKey.currentState.save();


        final _authority = "168.63.30.192:5000";
        final _path = "create_review";
        final _params={
          "usr_id": user.uid
        };

        final _uri =  Uri.http(_authority, _path,_params);
        
        Map<String, dynamic> body={
         "reviewdObjectID" : widget.usrEmail,
          "rating": _rating,
          "reviewText": _reviewText
        };

        http.Response res = await http.post(_uri.toString(),
            headers: { "accept": "application/json", "content-type": "application/json" },
            body: json.encode(body));

        if(res.statusCode==200){
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        }

        else{
          showDialog(
              context: context,
              builder: (BuildContext context)
          {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Problems Submiting try again"),
              content: new Text("Problems Submiting try again"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        }
      }

    }

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Review"),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.image),
                  radius: 50,
                ),
                Text(widget.usrName,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                Form(
                  key: this._formKey,
                  child:
                    Column(
                      children: <Widget>[
                        TouchStarRating(
                            iconSize: 40,
                            iconColor: Colors.amber,
                            autovalidate: false,
                            onChanged: (value){
                              setState(() {
                                _rating=value;
                              });

                            },
                            onSaved: (value) => _rating=value,
                            validator: (value){
                              print(value);
                              if(value<=0 && value!=null){

                                return 'Please leave a rating from 1 to 5';
                              }
                              return null;
                            }
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          maxLength: 500,
                          decoration: new InputDecoration(
                            labelText:'Leave here your review',
                            border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10),
                                borderSide:new BorderSide(
                                  color: Colors.green[900]
                                )
                              )
                          ),
                          onChanged: (value){
                            setState(() {
                              _reviewText=value;

                            });
                          },
                            onSaved:(value)=> _reviewText=value,
                          validator: (value) {
                           return null;
                          }
                        ),
                      ],
                    )

                ),

                SizedBox(height: 150,),
                RaisedButton(
                  onPressed: (){
                    if(_formKey.currentState.validate()){
                      print('form validated');
                      _sendForm();
                    }
                  },
                  child: Text('Submit'),
                )
              ],
            ),
        ),
      ),

    );
  }
}
