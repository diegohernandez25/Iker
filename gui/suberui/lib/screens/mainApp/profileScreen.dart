import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
    ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20,),
            CircleAvatar(
              backgroundImage: AssetImage('Images/voa.jpg'),
              radius: 70,
            ),
            SizedBox(height: 10,),
            Text('Name',
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('5'),
                    Text('Rating', style: Theme.of(context).textTheme.caption)
                  ],
                ),
                SizedBox(width: 50,),
                Column(
                  children: <Widget>[
                    Text(''),
                    Text('')
                  ],
                ),
                SizedBox(width: 50,),
                Column(
                  children: <Widget>[
                    Text('location'),
                    Text('Location', style: Theme.of(context).textTheme.caption,)
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
