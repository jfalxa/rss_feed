import 'package:flutter/material.dart';

class Loader<T> extends StatelessWidget {
  final Future _future;
  final Widget Function(BuildContext, T) _builder;

  Loader(
      {Key key,
      @required Future future,
      @required Widget Function(BuildContext, T) builder,
      String error,
      Function onRefresh})
      : _future = future,
        _builder = builder,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _builder(context, snapshot.data);
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(child: Text('No data yet.'));
        }
      },
    );
  }
}