import 'package:flutter/material.dart';
import '_____createTripHome.dart';


class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip History"),
        backgroundColor: Colors.teal[500],
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Material(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfilePage()),
                            );
                          },
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset('Images/face.png', width: 150, height: 150),
                            ),),
                        )
                    ),
                    //Image.asset('Images/face.png', width: 150, height: 150),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Diogo Fernandes') // ADD MORE INFO
                      ],
                    )
                  ]
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 200,
                child: RaisedButton(
                  onPressed: () {},
                  child: const Text(
                      'Search Trip',
                      style: TextStyle(fontSize: 20)
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateTripHome()),
                    );
                  },
                  child: const Text(
                      'Create Trip',
                      style: TextStyle(fontSize: 20)
                  ),
                ),
              ),
            ]
        ),
      ),

    );

  }
}