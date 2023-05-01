import 'package:flutter/material.dart';
import 'package:prc_app/screens/search_history_screen.dart';
import 'package:prc_app/screens/image_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Price Comparison'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchHistoryScreen()),
                );
              },
              child: Text('View Search History'),
            ),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageScreen()),
                );
              },
              child: Text('Take a Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
