import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class LazyScrollView<T> extends StatefulWidget {
  final int limit;
  final PagingController<int, T> controller;
  final Future<List<T>> Function(int, int) onRequest;
  final Widget Function(BuildContext, T, int) itemBuilder;

  LazyScrollView({
    Key key,
    this.limit = 10,
    this.onRequest,
    this.itemBuilder,
    this.controller,
  }) : super(key: key);

  @override
  _LazyScrollViewState<T> createState() => _LazyScrollViewState<T>();
}

class _LazyScrollViewState<T> extends State<LazyScrollView<T>> {
  @override
  initState() {
    super.initState();

    widget.controller.addPageRequestListener((offset) async {
      try {
        final items = await widget.onRequest(widget.limit, offset);
        final isLastPage = items.length < widget.limit;

        if (isLastPage) {
          widget.controller.appendLastPage(items);
        } else {
          widget.controller.appendPage(items, offset + items.length);
        }
      } catch (error) {
        widget.controller.error = error;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, T>.separated(
      pagingController: widget.controller,
      separatorBuilder: (context, index) =>
          Divider(height: 1, indent: 16, endIndent: 16),
      builderDelegate: PagedChildBuilderDelegate<T>(
        itemBuilder: widget.itemBuilder,
      ),
    );
  }
}
