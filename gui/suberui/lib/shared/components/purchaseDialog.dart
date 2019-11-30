import 'dart:async';

import 'package:flutter/material.dart';
import 'package:suberui/models/trip.dart';
import 'starDisplay.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'webDialog.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class PurchaseDialog extends StatefulWidget {
  final Trip trip;
  PurchaseDialog({this.trip});
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
      child: dialogContent(context),
    );
  }
}

dialogContent(BuildContext context){

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(40.0),
      child: Container(
        height: 500,
        width: 400,
        child: Column(
          children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.red ,
                ),
                Text('Name', style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                IconTheme( data: IconThemeData(color: Colors.amber, size: 30,),child: StarDisplay(value: 5)),
                Text(
                  'See profile'
                ),
            SizedBox(height: 40,),
            Row(
              children: <Widget>[
                Icon(
                  Icons.pin_drop
                ),
                Text('Location')
              ],
            ),
            Row(
              children: <Widget>[
                Icon(
                    Icons.event
                ),
                Text('Date')
              ],
            ),

            TypeAheadField(

            ),
            Text('Price', style: TextStyle(
              fontSize: 30
            ),),
            SizedBox(height: 30,),
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
  );
}


