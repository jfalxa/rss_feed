import 'package:flutter/material.dart';

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

  void addItems() async {
    var items = await widget.fetch(widget.limit, _items.length);

    setState(() {
      _items.addAll(items);
    });
  }

  @override
  void initState() {
    super.initState();
    _items = [];
    addItems();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final controller = PrimaryScrollController.of(context);
      controller.addListener(() {
        if (controller.position.pixels == controller.position.maxScrollExtent) {
          var position = controller.position.pixels;
          var max = controller.position.maxScrollExtent;

          if (position == max) {
            addItems();
          }
        }
      });

      return ListView.separated(
        itemCount: _items.length,
        padding: EdgeInsets.all(0),
        separatorBuilder: separatorBuilder,
        itemBuilder: (context, i) => widget.itemBuilder(context, _items[i]),
      );
    });
  }
}
