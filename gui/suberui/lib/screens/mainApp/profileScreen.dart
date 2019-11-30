import 'package:flutter/material.dart';
import 'package:suberui/shared/components/reviewTile.dart';
import 'package:suberui/shared/components/starDisplay.dart';
import 'package:suberui/shared/components/customDrawer.dart';

class ProfileScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double nH=height/3;

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
            },
          ),
        ],
        title: Text("Profile"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Colors.green[800],
                Colors.green[400]
              ],
            ),
          ),
        ),
        bottom: PreferredSize(
        preferredSize: Size.fromHeight(height/3),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: height/11,
                backgroundColor: Colors.red,
              ),
              SizedBox(height: height/80,),
              Text('Rodrigo Pereira',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height/60,),
              IconTheme(
                data: IconThemeData(
                  color: Colors.amber,
                  size: 30,
                ),
                child: StarDisplay(value: 5),
              ),
              SizedBox(height: height/30,)

            ],
          ),
       ),

      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 10),
            child: ReviewTile(),
          );
        }
    )

    );
  }
}
