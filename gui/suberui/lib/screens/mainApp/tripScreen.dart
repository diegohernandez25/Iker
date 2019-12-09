import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:suberui/models/mytrip.dart';
import 'package:geolocator/geolocator.dart';
import 'package:suberui/shared/components/GPSignaler.dart';
import 'package:suberui/shared/components/customDrawer.dart';
import 'package:http/http.dart' as http;

class tripScreen extends StatefulWidget {

  final MyTrip mtrip;
  tripScreen({@required this.mtrip});

  @override
  _tripScreenState createState() => _tripScreenState();
}

class _tripScreenState extends State<tripScreen> {
  final Set<Marker> _markers = {};
  final Set<Marker> _carMarkers ={};
  final Set<Polyline> _polylines = {};

  bool _ongoing = false;
  GPSignaler gpsig;
  Completer<GoogleMapController> _controller = Completer();


  Future<List<LatLng>> _snapToRoad(List<LatLng> initWay) async{
    String path="";

    for(int i = 0; i<initWay.length;i++){
      path+=initWay[i].latitude.toString()+','+initWay[i].longitude.toString()+'|';
    }

    print(widget.mtrip.waypoints.toString());



    path=path.substring(0,path.length-1);
    final _authority = "roads.googleapis.com";
    final _path = "/v1/snapToRoads";
    final _params = {
      "path": path,
      "interpolate": "true",
      "key":"AIzaSyDDuuTiQwp9tXWUTWE1tRs3oYCr90Lz6YE"
    };

    final _uri =  Uri.https(_authority, _path,_params);
    print(_uri.toString());



    http.Response res = await http.get(_uri.toString());

    if (res.statusCode == 200) {
      List<dynamic> body = json.decode(res.body)['snappedPoints'];

      List<LatLng> snapedWaypoints = body.map((dynamic item) => LatLng(item['location']['latitude'],item['location']['longitude']))
          .toList();

      return snapedWaypoints;
    }
    return null;
  }

  void _onMapCreated(GoogleMapController controller) async{
    _controller.complete(controller);


    for(int i=0; i<widget.mtrip.coords.length;i++){

      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(
              i.toString()
            ),
            position: LatLng(widget.mtrip.coords[i][0],widget.mtrip.coords[i][1]),
            infoWindow: InfoWindow(
              title: 'Marker',
              snippet: 'Marker snip'
            ),
            icon: BitmapDescriptor.defaultMarker
          )
        );
      });

      List<LatLng> _polylinesLatLong=[];

      for(int i=0; i<widget.mtrip.waypoints.length;i++ ){
        _polylinesLatLong.add(LatLng(widget.mtrip.waypoints[i][0],widget.mtrip.waypoints[i][1]));
      }

        List<LatLng> _polySnapped = await _snapToRoad(_polylinesLatLong);
        setState(() {
          _polylines.add(Polyline(
            polylineId: PolylineId('PolyId'),
            visible: true,
            points:  _polySnapped ,
            color: Colors.blue,
            width: 4
          ));
        });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gpsig = new GPSignaler(
        tripId: widget.mtrip.idIPTF,
        onUpdate: (pos){
          print("ola");
          print(pos);

          setState(() {
            if(_carMarkers.isNotEmpty){
              _carMarkers.clear();
            }
            _carMarkers.add(Marker(
                markerId: MarkerId('abcd'),
                position: LatLng(pos.latitude,pos.longitude),
                infoWindow: InfoWindow(
                    title: 'Marker',
                    snippet: 'Marker snip'
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan)


            )
            );
          });
          /*setState(() {

        });*/
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: Text("Trip"),
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
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target:  LatLng(widget.mtrip.coords[0][0],widget.mtrip.coords[0][1]),
                zoom: 11.0,
              ),
              markers: new Set.from(_markers)..addAll(_carMarkers),
              polylines: _polylines,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    if(_ongoing){
                      gpsig.stopSignaling();
                      setState(() {
                        _ongoing=!_ongoing;
                      });
                    }
                    else{
                      setState(() {
                        gpsig.startSignaling();
                        _ongoing=!_ongoing;
                      });
                    }

                  },
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: _ongoing
                      ? Colors.red
                      : Colors.green,
                  child: _ongoing
                      ? const Icon(Icons.stop, size: 36.0)
                      : const Icon(Icons.play_arrow, size: 36.0),
                ),
              ),
            ),
          ],
        ),
      );

  }
}