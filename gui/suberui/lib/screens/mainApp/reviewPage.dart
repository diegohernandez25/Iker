import 'package:flutter/material.dart';
import 'package:suberui/shared/components/customDrawer.dart';
import 'package:suberui/shared/components/touchStarRating.dart';


class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {

  String _reviewText;
  int _rating;

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
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
                  backgroundColor: Colors.red,
                  radius: 50,
                ),
                Text('Name',
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
