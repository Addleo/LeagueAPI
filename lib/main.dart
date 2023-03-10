import 'package:flutter/material.dart';
import 'package:league_api/ui/screens/home.dart';
import 'package:league_api/ui/screens/searchSummoner.dart';
import 'package:league_api/ui/screens/moreInfo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'League Api',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      routes: {
      '/home': (context) => Home(),
      '/searchSummoner': (context) => SearchSummoner(),
      '/moreInfo': (context) => MoreInfo(),
      },
      initialRoute: '/home',
    );
  }
}