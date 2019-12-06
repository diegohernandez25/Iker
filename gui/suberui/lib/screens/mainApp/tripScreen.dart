import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class tripScreen extends StatefulWidget {
  @override
  _tripScreenState createState() => _tripScreenState();
}

class _tripScreenState extends State<tripScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Trip in progress'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      if (!pressed) {
                        print("AQUI ACABAS COM A VIAGEM!");
                        pressed = !pressed;
                      } else {
                        pressed = !pressed;
                      }
                    });
                  },
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: pressed
                      ? Colors.green
                      : Colors.red,
                  child: pressed
                      ? const Icon(Icons.play_arrow, size: 36.0)
                      : const Icon(Icons.stop, size: 36.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}