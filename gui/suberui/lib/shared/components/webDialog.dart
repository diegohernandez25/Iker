import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebDialog extends StatefulWidget {
  @override
  _WebDialogState createState() => _WebDialogState();
}

class _WebDialogState extends State<WebDialog> {
  @override



  Widget build(BuildContext context) {
    final Completer<WebViewController> _controller=
      Completer<WebViewController>();


    WebViewController _controller2=null;




    return WillPopScope(
      onWillPop: () async=>false,
      child: Dialog(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.white,
        child: WebView(
          initialUrl: "http://168.63.30.192:8080/sign_in?token=5",
          onPageFinished: (String url){
            print(url);
            Uri finalUri = Uri.parse(url);
            print(finalUri.path);
            if(url=='http://168.63.30.192:8080/done'){
              print('hello');
              var count = 0;
              Navigator.popUntil(context, (route) {
                return count++ == 2;
              });
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
