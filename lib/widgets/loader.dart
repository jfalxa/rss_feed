import 'package:flutter/material.dart';

class Loader<T> extends StatelessWidget {
  final Future<T> _future;
  final String _error;
  final Widget Function(BuildContext, T) _builder;

  Loader({
    Key? key,
    required Future<T> future,
    required String error,
    required Widget Function(BuildContext, T) builder,
  })   : _future = future,
        _error = error,
        _builder = builder,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _builder(context, snapshot.data!);
        } else if (snapshot.hasError) {
          return Center(child: Text(_error));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(child: Text('No data yet.'));
        }
      },
    );
  }
}
