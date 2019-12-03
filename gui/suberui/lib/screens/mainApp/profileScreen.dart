import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:suberui/models/review.dart';
import 'package:suberui/shared/components/reviewTile.dart';
import 'package:suberui/shared/components/starDisplay.dart';
import 'package:suberui/shared/components/customDrawer.dart';
import 'package:http/http.dart' as http;



class ProfileScreen extends StatefulWidget {
  final String email;
  ProfileScreen({this.email});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}



class _ProfileScreenState extends State<ProfileScreen>  {


  String _name='Dummy';
  List<Review> _lRev=[];
  NetworkImage _pImage;
  num _rat=5;


  void _getInfo() async{
    final _authority = "168.63.30.192:5000";
    final _path = "/get_usr_profile";
    final _params={
      'usr_mail': widget.email
    };


    final _uri =  Uri.http(_authority, _path, _params);

    //print(_uri.toString());

    http.Response res = await http.get(_uri);
    print(res.body);

    var jsonBody= json.decode(res.body);

    setState(() {
      _name=jsonBody['usr_name'];
      _rat=jsonBody['avgRating'];
      _pImage=NetworkImage(jsonBody['img_url']);
      List<dynamic> lR = json.decode(res.body)['reviews'];
      _lRev = lR.map((dynamic item) =>Review.fromJson(item),)
          .toList();
    });


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getInfo();
  }



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
                backgroundImage: _pImage,
              ),
              SizedBox(height: height/80,),
              Text(_name,
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
                child: StarDisplay(value: _rat),
              ),
              SizedBox(height: height/30,)

            ],
          ),
       ),

      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _lRev.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 10),
            child: ReviewTile(review: _lRev[index] ),
          );
        }
    )

    );
  }
}
