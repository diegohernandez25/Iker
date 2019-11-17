import 'package:flutter/material.dart';
import 'package:suberui/shared/components/customTripTile.dart';
import 'tripDetailPage.dart';

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