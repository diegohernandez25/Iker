import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flushbar/flushbar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suberu App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SuberU'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      //appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
      //  title: Text(widget.title),
      //),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('Images/suberu_katchau.png')
            ),
            const SizedBox(height: 30),
            RaisedButton(
              onPressed: () {},
              child: const Text(
                  'Nice to meet you!',
                  style: TextStyle(fontSize: 20)
              ),
            ),
            const SizedBox(height: 20),
            FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
              child: const Text(
                  'You already know me',
                  style: TextStyle(fontSize: 20)
              ),
            ),
          ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.status}) : super(key: key);

  final String status;

  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Trip added successfully'))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Page"),
        backgroundColor: Colors.teal[500],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset('Images/face.png', width: 150, height: 150),
                      ),),
                  )
                ),
                //Image.asset('Images/face.png', width: 150, height: 150),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Diogo Fernandes') // ADD MORE INFO
                  ],
                )
              ]
            ),
          const SizedBox(height: 30),
          SizedBox(
            width: 200,
            child: RaisedButton(
              onPressed: () {},
              child: const Text(
                  'Search Trip',
                  style: TextStyle(fontSize: 20)
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 200,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateTripHome()),
                );
              },
              child: const Text(
                  'Create Trip',
                  style: TextStyle(fontSize: 20)
              ),
            ),
          ),
          ]
        ),
      ),

    );

  }

}


/// CREATE TRIP BUTTON

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
                          MaterialPageRoute(builder: (context) => MainPage(status: 'Success',)),
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

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip History"),
        backgroundColor: Colors.teal[500],
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Material(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfilePage()),
                            );
                          },
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset('Images/face.png', width: 150, height: 150),
                            ),),
                        )
                    ),
                    //Image.asset('Images/face.png', width: 150, height: 150),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Diogo Fernandes') // ADD MORE INFO
                      ],
                    )
                  ]
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 200,
                child: RaisedButton(
                  onPressed: () {},
                  child: const Text(
                      'Search Trip',
                      style: TextStyle(fontSize: 20)
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateTripHome()),
                    );
                  },
                  child: const Text(
                      'Create Trip',
                      style: TextStyle(fontSize: 20)
                  ),
                ),
              ),
            ]
        ),
      ),

    );

  }
}
