import 'package:flutter/material.dart';

class BackToTop extends StatelessWidget {
  final bool show;
  final Function onPressed;

  BackToTop({Key key, this.show, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: show ? 1 : 0,
      duration: Duration(milliseconds: 300),
      child: FloatingActionButton(
        mini: true,
        child: Icon(Icons.arrow_upward),
        onPressed: onPressed,
      ),
    );
  }
}
