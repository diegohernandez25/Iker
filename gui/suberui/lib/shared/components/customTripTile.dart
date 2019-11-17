import 'package:flutter/material.dart';

class _TripData extends StatelessWidget {
  _TripData({
    Key key,
    this.driverName,
    this.driverDescription,
    this.publishDate,
    this.rating,
    this.avSeats,
    this.price
  }) : super(key: key);

  final String driverName;
  final String driverDescription;
  final String publishDate;
  final String rating;
  final String avSeats;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$driverName',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                '$driverDescription',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[

              Text(
                'Av. Seats: $avSeats      $rating ★',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
              /*Row(
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(color: Colors.pink),
                  ),
                ]
              )*/
            ],
          ),
        ),
      ],
    );
  }
}

class CustomTripTile extends StatelessWidget {
  CustomTripTile({
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
    return
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.0,
                child: profilePic,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                  child: _TripData(
                    driverName: driverName,
                    driverDescription:driverDescription,
                    publishDate:publishDate,
                    rating:rating,
                    avSeats:avSeats,
                    price:price,

                  ),
                ),
              ),
              Container(
                  margin:const EdgeInsets.all(10.0),

                  alignment: Alignment.center,
                  child: Text('$price €',
                    style: const TextStyle(
                      fontSize: 50.0,
                      color: Colors.black54,
                    ),)
              )

            ],
          ),
        ),
      );
  }
}