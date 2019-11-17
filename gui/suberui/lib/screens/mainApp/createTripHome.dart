import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'home.dart';


class CreateTripHome extends StatefulWidget{
  CreateTripState createState()=> CreateTripState();
}

class CreateTripState extends State<CreateTripHome> {
  String car = 'Pick a vehicle';
  String _date = "Not set";
  String _time = "Not set";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Trip"),
        backgroundColor: Colors.teal[500],
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Pick  vehicle:',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 5),
                      DropdownButton<String>(
                        value: car,
                        icon: Icon(Icons.arrow_downward, color: Colors.teal),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: Colors.black
                        ),
                        underline: Container(
                          height: 2,
                          color: Colors.teal,
                        ),
                        onChanged: (String newValue) {
                          if(newValue != 'Pick a vehicle'){
                            setState(() {
                              car = newValue;
                            });
                          }
                        },
                        items: <String>['Pick a vehicle', 'Fiat Panda', 'Fiat 500', 'Fiat Multipla'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )]),
                const SizedBox(height: 5),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Number of free seats:',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 5),
                      Container(
                          width: 50,
                          child: TextField(
                            maxLength: 2,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                            ),
                          ))
                    ]
                ),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: 100,
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: 'Source'
                            ),
                          )),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.teal,
                        size: 24.0,
                      ),
                      const SizedBox(width: 10),
                      Container(
                          width: 100,
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: 'Destination'
                            ),
                          ))
                    ]
                ),
                const SizedBox(height: 15),
                SizedBox(
                    width: 250,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                              print('confirm $date');
                              _date = '${date.year} - ${date.month} - ${date.day}';
                              setState(() {});
                            }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.date_range,
                                        size: 18.0,
                                        color: Colors.teal,
                                      ),
                                      Text(
                                        " $_date",
                                        style: TextStyle(
                                            color: Colors.teal,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Text(
                              "  Change",
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    )),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                    width: 250,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                        DatePicker.showTimePicker(context,
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            showTitleActions: true, onConfirm: (time) {
                              print('confirm $time');
                              _time = '${time.hour} : ${time.minute} : ${time.second}';
                              setState(() {});
                            }, currentTime: DateTime.now(), locale: LocaleType.en);
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                        size: 18.0,
                                        color: Colors.teal,
                                      ),
                                      Text(
                                        " $_time",
                                        style: TextStyle(
                                            color: Colors.teal,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Text(
                              "  Change",
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    )
                ),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Maximum detour:',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 5),
                      Container(
                          width: 50,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                            ),
                          )
                      ),
                      Text(
                        'Km',
                        style: TextStyle(color: Colors.teal),
                        textAlign: TextAlign.center,
                      ),
                    ]
                ),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Price per seat:',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 5),
                      Container(
                          width: 50,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                            ),
                          )
                      ),
                      Icon(
                        Icons.euro_symbol,
                        color: Colors.teal,
                        size: 21.0,
                      ),
                    ]
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                    child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 20, color: Colors.teal)
                    ),
                  ),
                ),
              ])
      ),
    );
  }

}