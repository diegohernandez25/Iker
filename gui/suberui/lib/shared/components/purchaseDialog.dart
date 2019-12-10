import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suberui/models/event.dart';
import 'package:suberui/models/location.dart';
import 'package:suberui/models/trip.dart';
import 'package:suberui/screens/mainApp/profileScreen.dart';
import 'starDisplay.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'webDialog.dart';
import 'package:provider/provider.dart';
import 'package:suberui/models/user.dart';

import 'package:http/http.dart' as http;





class PurchaseDialog extends StatefulWidget {
  final Trip trip;
  final Event event;
  final Location location;

  PurchaseDialog({this.trip, this.event,this.location});

  @override
  _PurchaseDialogState createState() => _PurchaseDialogState();

}

class _PurchaseDialogState extends State<PurchaseDialog> {

  @override
  Widget build(BuildContext context) {

    final user= Provider.of<User>(context);
    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Container(
            height: 400,
            width: 400,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(
                     email: widget.trip.authorEmail,
                    )));
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: widget.trip.authorImage ,
                  ),
                ),
                Text(widget.trip.authorName, style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                ),
                IconTheme( data: IconThemeData(color: Colors.amber, size: 30,),child: StarDisplay(value: widget.trip.authorRtng.round())),

                SizedBox(height: 40,),
                Row(
                  children: <Widget>[
                    Icon(
                        Icons.pin_drop
                    ),
                    Expanded(child: Text(widget.event.name))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                        Icons.watch_later
                    ),
                    Text(DateFormat("HH:mm").format(DateTime.fromMillisecondsSinceEpoch(widget.trip.hour * 1000)))
                  ],
                ),
                Text(widget.trip.price.toStringAsPrecision(2) + '€', style: TextStyle(
                    fontSize: 30
                ),),
                SizedBox(height: 10,),
                RaisedButton(
                  onPressed: () async{
                    final _authority = "168.63.30.192:5000";
                    final _path = "/reserve_seat";
                    final _params={
                      "usr_id": user.uid,
                      "trip_id": widget.trip.tid.toString(),
                    };


                    final _uri =  Uri.http(_authority, _path, _params);
                    Map<String, String> body={
                      "lat": widget.location.lat.toString(),
                      "lon": widget.location.lon.toString(),
                      "name": "a new reservation",
                      "information": "None"
                    };
                    print(_uri.toString());

                    http.Response res = await http.post(_uri.toString(),
                        headers: { "accept": "application/json", "content-type": "application/json" },
                        body: json.encode(body));
                    print(res.statusCode);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => WebDialog(trid: json.decode(res.body)['token'].toString()),
                    );
                  },
                  color: Colors.green[900],
                  child: Text('Book',style: TextStyle(color: Colors.white),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}




