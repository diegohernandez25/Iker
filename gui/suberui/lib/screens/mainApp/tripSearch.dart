import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suberui/models/user.dart';
import 'package:suberui/screens/mainApp/tripDetail.dart';
import 'package:suberui/services/auth.dart';
import 'package:suberui/shared/components/purchaseDialog.dart';
import 'package:suberui/shared/components/tripTile.dart';
import 'package:suberui/models/trip.dart';

class TripSearch extends StatefulWidget {
  @override
  _TripSearchState createState() => _TripSearchState();
}

class _TripSearchState extends State<TripSearch> {
  final AuthService _auth = AuthService();



  @override
  Widget build(BuildContext context) {
    final user= Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip Search"),
        //backgroundColor: Colors.teal[500],
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.imageUrl),
              radius: 20.0,
            ),
          ),
          FlatButton.icon(
              onPressed: () async{
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                await _auth.signOutGoogle();

              },
              icon: Icon(Icons.power_settings_new ),
              label: Text(''))
        ],
      ),
      body: Padding(
            padding: EdgeInsets.all(0.0),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 7,
                itemBuilder: (context, index) {
                  return  Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: GestureDetector(
                        onTap: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => PurchaseDialog(
                              trip: Trip(
                                  tid: 1,
                                  authorId: '1',
                                  authorImage: AssetImage('Images/voa.jpg'),
                                  authorName: 'Rodrigo Pereira',
                                  authorRtng: 4.3,
                                  price: 150.90
                              ),
                            ),
                          );
                        },
                        child: TripTile(
                          trip: Trip(
                            tid: 1,
                            authorId: '1',
                            authorImage: AssetImage('Images/voa.jpg'),
                            authorName: 'Rodrigo Pereira',
                            authorRtng: 4.3,
                            price: 150.90
                          )
                        ),
                      ),

                  );
                }
            )
          
      ),

    );
  }
}
