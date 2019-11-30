import 'package:flutter/material.dart';

class DetailTripPage extends StatelessWidget {
  DetailTripPage({
    Key key,
    this.profilePic,
    this.driverName,
    this.driverDescription,
    this.publishDate,
    this.rating,
    this.avSeats,
    this.price,
  }) : super(key: key);

  final Widget profilePic;
  final String driverName;
  final String driverDescription;
  final String publishDate;
  final String rating;
  final String avSeats;
  final String price;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details of a Trip"),
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                  backgroundImage: AssetImage('Images/face.png'),
                  radius:50.0
              ),
              SizedBox(height: 10.0),
              Text(
                  'Driver\'s Name',
                  style:TextStyle(
                    fontSize: 18.0,
                    color:Colors.black87,
                    letterSpacing: 2.0,
                  )
              ),
              SizedBox(height: 10.0),
              Text(
                  '$driverName',
                  style: TextStyle(
                      color: Colors.teal,
                      letterSpacing: 2.0,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold
                  )
              ),
              SizedBox(height: 25.0),


              Text(
                  'No. Available Seats',
                  style:TextStyle(
                    fontSize: 18.0,
                    color:Colors.black87,
                    letterSpacing: 2.0,
                  )
              ),
              SizedBox(height: 10.0),
              Text(
                  '$avSeats',
                  style: TextStyle(
                      color: Colors.teal,
                      letterSpacing: 2.0,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold
                  )
              ),
              SizedBox(height: 25.0),
              Text(
                  'Rating',
                  style:TextStyle(
                    fontSize: 18.0,
                    color:Colors.black87,
                    letterSpacing: 2.0,
                  )
              ),
              SizedBox(height: 10.0),
              Text(
                  '$rating ★',
                  style: TextStyle(
                      color: Colors.teal,
                      letterSpacing: 2.0,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold
                  )
              ),


              SizedBox(height: 25.0),
              Row(
                  children: <Widget>[
                    Icon(
                        Icons.directions_car,
                        color: Colors.black
                    ),
                    Text(
                      'Origem -> Destino',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ]
              ),
              SizedBox(height: 25.0),
              Row(
                  children: <Widget>[
                    Icon(
                        Icons.calendar_today,
                        color: Colors.black
                    ),
                    Text(
                      'YYYY:MM:DD:HH:mm',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ]
              ),
              SizedBox(height: 25.0),
              Center(
                child: Text(
                  '$price € .seat',
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 30.0,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),

              Center(
                child: RaisedButton(
                  onPressed: () {},
                  color: Colors.teal,
                  child: const Text(
                      'Book',
                      style: TextStyle(fontSize: 30)
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}