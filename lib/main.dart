import 'package:flutter/material.dart';
import 'src/app.dart';

void main() {
  runApp(RssFeed());
}

class RssFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Rss Feed',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: App());
  }
}
