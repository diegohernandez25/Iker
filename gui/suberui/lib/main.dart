import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:english_words/english_words.dart';


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
        primarySwatch: Colors.teal
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

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

class MainPage extends StatelessWidget {
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
                Image.asset('Images/face.png', width: 150, height: 150),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchTripPage()),
                );
              },
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
              onPressed: () {},
              child: const Text(
                  'Create Trip',
                  style: TextStyle(fontSize: 20)
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class SearchTripPage extends StatefulWidget {
  @override
  _SearchTripPageState createState() => new _SearchTripPageState();
}

class _SearchTripPageState extends State<SearchTripPage> {

  TextEditingController editingController = TextEditingController();
  final staticItems = List<String>.generate(20, (i) => "Trip of Driver $i");
  var items = List<String>();

  @override
  void initState() {
    items.addAll(staticItems);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> tempSearchList = List<String>();
    tempSearchList.addAll(staticItems);
    if(query.isNotEmpty) {
      List<String> tempListData = List<String>();
      tempSearchList.forEach((item) {
        if(item.contains(query)) {
          tempListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(tempListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(staticItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search for Trip"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailTripPage(profilePic:ClipOval(
                            //borderRadius: new BorderRadius.circular(30.0),
                              child: Image(
                                image: AssetImage('Images/face.png'),
                              )
                          ),
                            driverName: '${items[index]}',
                            driverDescription:'Pricey . Talkative',
                            publishDate:'Nov 4',
                            rating:'5',
                            avSeats:'4',
                            price:'5.6'),
                        ),
                      );
                    },
                    child: CustomTripTile(
                      profilePic:ClipOval(
                        //borderRadius: new BorderRadius.circular(30.0),
                          child: Image(
                            image: AssetImage('Images/face.png'),
                          )
                      ),
                      driverName: '${items[index]}',
                      driverDescription:'Pricey . Talkative',
                      publishDate:'Nov 4',
                      rating:'5',
                      avSeats:'4',
                      price:'5.6',
                        ),
                    /*
                  child: ListTile(
                    leading: ClipOval(
                      //borderRadius: new BorderRadius.circular(30.0),
                      child: Image(
                        image: AssetImage('Images/face.png'),

                      )
                    ),
                    title: Text('${items[index]}'),
                    subtitle: Text(
                    'A sufficiently long subtitle warrants three lines.'
                    ),
                    trailing: Icon(Icons.more_vert),
                      isThreeLine: true,
                      )
                      */

                    );


                    //title: Text('${items[index]}'),

                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}

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