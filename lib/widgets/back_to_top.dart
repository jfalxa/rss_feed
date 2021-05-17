import 'package:flutter/material.dart';

class BackToTop extends StatefulWidget {
  final Widget Function(BuildContext, ScrollController) _builder;

  BackToTop({
    Key? key,
    required Widget Function(BuildContext, ScrollController) builder,
  })   : _builder = builder,
        super(key: key);

  @override
  _BackToTopState createState() => _BackToTopState();
}

// class BackToTop extends StatelessWidget {
class _BackToTopState extends State<BackToTop> {
  final ScrollController _controller = ScrollController();

  bool _show = false;

  @override
  initState() {
    super.initState();

    _controller.addListener(() {
      var position = _controller.position.pixels;
      var max = _controller.position.maxScrollExtent;

      if (!_show && position >= max) {
        setState(() {
          _show = true;
        });
      } else if (_show && position < max) {
        setState(() {
          _show = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _backToTop() {
    _controller.animateTo(
      0,
      duration: Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget._builder(context, _controller),
      floatingActionButton: AnimatedOpacity(
        opacity: _show ? 1 : 0,
        duration: Duration(milliseconds: 300),
        child: FloatingActionButton(
          heroTag: 'back-to-top',
          mini: true,
          child: Icon(Icons.arrow_upward),
          onPressed: _backToTop,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
