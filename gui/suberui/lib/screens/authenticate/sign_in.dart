import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:suberui/services/auth.dart';
import 'package:suberui/models/user.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();


  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        backgroundColor: Colors.teal[500],
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child:Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Sign In with Google'),
              onPressed: () => _auth.signInGoogle()
                  .then((User user)=> print(user.uid))
                  .catchError((e)=>print(e)),
              /*onPressed: () async{
                dynamic result = await _auth.signInGoogle();
                if(result!= null){
                  print("success");
                }
                else{
                  print("Error Signing in");
                }
              }*/

            ),
        RaisedButton(
          child: Text('Sign Out'),
          /*nPressed: () => _auth.signOutGoogle()
              .then((FirebaseUser user)=> print(user))
              .catchError((e)=>print(e)),*/
        )

          ],
        )

      ),
    );*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("Images/iker.png"), height: 150.0),
              SizedBox(height: 50),
              OutlineButton(
                splashColor: Colors.grey,
                onPressed: () => _auth.signInGoogle()
                    .then((User user)=> print(user.imageUrl))
                    .catchError((e)=>print(e)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                highlightElevation: 0,
                borderSide: BorderSide(color: Colors.grey),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(image: AssetImage("Images/google_logo.png"), height: 35.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}


