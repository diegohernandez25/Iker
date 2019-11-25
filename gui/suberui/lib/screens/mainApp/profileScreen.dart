import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
    ),
      body: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage('Images/voa.jpg')
          ),
          Text('Name'),
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('Number'),
                  Text('Rating')
                ],
              ),
              Column(
                children: <Widget>[
                  Text('Number'),
                  Text('Rating')
                ],
              ),
              Column(
                children: <Widget>[
                  Text('Number'),
                  Text('Rating')
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
