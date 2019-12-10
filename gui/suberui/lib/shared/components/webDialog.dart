import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebDialog extends StatefulWidget {
  final String trid;
  WebDialog({this.trid});

  @override
  _WebDialogState createState() => _WebDialogState();
}

class _WebDialogState extends State<WebDialog> {
  @override



  Widget build(BuildContext context) {
    final Completer<WebViewController> _controller=
      Completer<WebViewController>();


    //WebViewController _controller2=null;




    return WillPopScope(
      onWillPop: () async=>false,
      child: Dialog(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.white,
        child: WebView(
          initialUrl: "http://168.63.30.192:8080/sign_in?token="+widget.trid,
          onPageFinished: (String url){
            print(url);

            if(Uri.parse(url).path=='/done' || Uri.parse(url).path=='/invalid'){
              print('hello');
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
            }

          },
          onWebViewCreated: (WebViewController webViewController){
            _controller.complete(webViewController);
          },

        )
      ),
    );
  }
}
