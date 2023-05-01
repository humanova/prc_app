import 'package:flutter/material.dart';
import 'package:prc_app/screens/home_screen.dart';
import 'package:prc_app/screens/image_screen.dart';
import 'package:prc_app/screens/product_prices_screen.dart';
import 'package:prc_app/screens/search_history_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/image': (context) => ImageScreen(),
        '/product-prices': (context) => ProductPricesScreen(),
        '/search-history': (context) => SearchHistoryScreen(),
      },
    );
  }
}
