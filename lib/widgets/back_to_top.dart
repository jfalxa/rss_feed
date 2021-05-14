import 'package:flutter/material.dart';

class BackToTop extends StatelessWidget {
  final bool _show;
  final Function _onPressed;

  BackToTop({Key key, bool show, Function onPressed})
      : _show = show,
        _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _show ? 1 : 0,
      duration: Duration(milliseconds: 300),
      child: FloatingActionButton(
        mini: true,
        child: Icon(Icons.arrow_upward),
        onPressed: _onPressed,
      ),
    );
  }
}
