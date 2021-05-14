import 'package:flutter/material.dart';

class Loader<T> extends StatelessWidget {
  final Future future;
  final String error;
  final Widget Function(BuildContext, T) builder;

  Loader({Key key, @required this.future, @required this.builder, this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return builder(context, snapshot.data);
        } else if (snapshot.hasError) {
          print("Error while loading: ${snapshot.error}");
          return Center(child: Text(error));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(child: Text('No data yet.'));
        }
      },
    );
  }
}
