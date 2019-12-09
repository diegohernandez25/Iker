import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suberui/models/event.dart';
import 'package:suberui/models/location.dart';
import 'package:suberui/models/user.dart';
import 'package:suberui/shared/components/pendingRevTile.dart';
import 'package:suberui/shared/components/purchaseDialog.dart';
import 'package:suberui/shared/components/tripTile.dart';
import 'package:suberui/models/trip.dart';
import 'package:suberui/shared/components/customDrawer.dart';
import 'package:http/http.dart' as http;

class PendingRevList extends StatefulWidget {

  PendingRevList();
  @override
  _PendingRevListState createState() => _PendingRevListState();
}



class _PendingRevListState extends State<PendingRevList> {
  List<PendingRevTile> _fetchedListOfPendingRev = [
    PendingRevTile(
      id: 1,
      imgURI: "https://cdn.discordapp.com/attachments/498949663513116673/653621965831012367/l7kP8PxFksl3VvLF4AAAAASUVORK5CYII.png",
      targetEmail: "ruddirudellas",
      targetName: "Rodrigo",
    )
  ];

  void _getPending (User user) async {
    final _authority = "168.63.30.192:5000";
    final _path = "list_pending_reviews";
    final _params = {
      "usr_id": user.uid
    };
    final _uri =  Uri.http(_authority, _path,_params);
    print('[Pendiing Rev List] getting List...  URL: '+_uri.toString());
    http.Response res = await http.get(_uri.toString());
    if (res.statusCode == 200) {
      List<dynamic> body = json.decode(res.body);
      List<PendingRevTile> pendingList = body.map((dynamic item) => PendingRevTile(
        id: item['id'],
        imgURI: item['img_url'],
        targetEmail: item['usr_mail'],
        targetName: item['usr_name'],
        rating: item['avgRating']
        ),
      )
          .toList();
      setState(() { _fetchedListOfPendingRev = pendingList; });
    }
    else{
      setState(() { _fetchedListOfPendingRev = []; });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero,() {
      _getPending(Provider.of<User>(context));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Trip Search"),
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
      body: Padding(
          padding: EdgeInsets.all(0.0),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _fetchedListOfPendingRev.length,
              itemBuilder: (context, index) {
                return  Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: _fetchedListOfPendingRev[index]

                );
              }
          )

      ),



    );
  }
}
