import 'package:flutter/material.dart';

import 'dart:developer' as dev;

Widget separatorBuilder(BuildContext context, int index) {
  return Divider(
    height: 1,
    indent: 16,
    endIndent: 16,
  );
}

class InfiniteScroll<T> extends StatefulWidget {
  final int limit;
  final Future<List<T>> Function(int limit, int offset) fetch;
  final Widget Function(BuildContext, T) itemBuilder;

  InfiniteScroll({
    Key key,
    this.itemBuilder,
    this.fetch,
    this.limit = 10,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InfiniteScrollState<T>();
}

class _InfiniteScrollState<T> extends State<InfiniteScroll<T>> {
  List<T> _items;
  ScrollController _controller = ScrollController();

  void addItems() async {
    dev.log("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA START FETCHIN");
    var items = await widget.fetch(widget.limit, _items.length);
    dev.log("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB STOP FETCHIN");

    setState(() {
      _items.addAll(items);
    });
  }

  @override
  void initState() {
    super.initState();

    _items = [];

    addItems();

    _controller.addListener(() {
      var position = _controller.position.pixels;
      var max = _controller.position.maxScrollExtent;

      dev.log("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS SCROLLIN");
      dev.log("$position | $max");

      if (position == max) {

        addItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _items.length,
      controller: _controller,
      padding: EdgeInsets.all(0),
      separatorBuilder: separatorBuilder,
      itemBuilder: (context, i) => widget.itemBuilder(context, _items[i]),
    );
  }
}
