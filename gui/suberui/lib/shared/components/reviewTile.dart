import 'package:flutter/material.dart';
import 'starDisplay.dart';


class ReviewTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: CircleAvatar(
              radius:20,
              backgroundColor: Colors.red,
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Name',style: TextStyle(
                  fontSize: 20
                )),
                IconTheme(
                  data: IconThemeData(
                    color: Colors.grey[700],
                    size: 20,
                  ),
                  child: StarDisplay(value: 5),
                ),
                SizedBox(height: 10,),
                Text('olaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaolaola'
                )
              ],

            ),
          )
        ],
      ),
    );
  }
}
