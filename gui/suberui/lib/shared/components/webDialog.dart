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


    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      backgroundColor: Colors.white,
      child: WebView(
        initialUrl: "https://google.com",
        onWebViewCreated: (WebViewController webViewController){
          _controller.complete(webViewController);
        },
      )
    );
  }
}
