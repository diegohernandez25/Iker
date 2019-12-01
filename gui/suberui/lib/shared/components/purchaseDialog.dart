import 'dart:async';

import 'package:flutter/material.dart';
import 'package:suberui/models/event.dart';
import 'package:suberui/models/trip.dart';
import 'starDisplay.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'webDialog.dart';




class PurchaseDialog extends StatefulWidget {
  final Trip trip;
  final Event event;
  PurchaseDialog({this.trip, this.event});

  @override
  _PurchaseDialogState createState() => _PurchaseDialogState();

}

class _PurchaseDialogState extends State<PurchaseDialog> {

  @override
  Widget build(BuildContext context) {
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
                CircleAvatar(
                  radius: 40,
                  backgroundImage: widget.trip.authorImage ,
                ),
                Text(widget.trip.authorName, style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                ),
                IconTheme( data: IconThemeData(color: Colors.amber, size: 30,),child: StarDisplay(value: widget.trip.authorRtng.round())),
                Text(
                    'See profile'
                ),
                SizedBox(height: 40,),
                Row(
                  children: <Widget>[
                    Icon(
                        Icons.pin_drop
                    ),
                    Text(widget.event.name)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                        Icons.event
                    ),
                    Text(widget.event.date.toIso8601String())
                  ],
                ),
                Text(widget.trip.price.toString() + '€', style: TextStyle(
                    fontSize: 30
                ),),
                SizedBox(height: 10,),
                RaisedButton(
                  onPressed: (){

                    showDialog(
                        context: context,
                        builder: (BuildContext context) => WebDialog()
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




