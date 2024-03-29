import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class LazyScrollView<T> extends StatefulWidget {
  final int _limit;
  final PagingController<int, T> _controller;
  final Future<List<T>> Function(int, int) _onRequest;
  final Widget Function(BuildContext, T, int) _itemBuilder;
  final Widget Function(BuildContext) _emptyBuilder;

  LazyScrollView({
    Key? key,
    int limit = 10,
    required PagingController<int, T> controller,
    required Future<List<T>> Function(int, int) onRequest,
    required Widget Function(BuildContext, T, int) itemBuilder,
    required Widget Function(BuildContext) emptyBuilder,
  })   : _limit = limit,
        _controller = controller,
        _onRequest = onRequest,
        _itemBuilder = itemBuilder,
        _emptyBuilder = emptyBuilder,
        super(key: key);

  @override
  _LazyScrollViewState<T> createState() => _LazyScrollViewState<T>();
}

class _LazyScrollViewState<T> extends State<LazyScrollView<T>> {
  @override
  initState() {
    super.initState();

    widget._controller.addPageRequestListener((offset) async {
      try {
        final items = await widget._onRequest(widget._limit, offset);
        final isLastPage = items.length < widget._limit;

        if (isLastPage) {
          widget._controller.appendLastPage(items);
        } else {
          widget._controller.appendPage(items, offset + items.length);
        }
      } catch (error) {
        widget._controller.error = error;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, T>.separated(
      pagingController: widget._controller,
      padding: EdgeInsets.only(top: 0),
      separatorBuilder: (context, index) =>
          Divider(height: 1, indent: 16, endIndent: 16),
      builderDelegate: PagedChildBuilderDelegate<T>(
        itemBuilder: widget._itemBuilder,
        noItemsFoundIndicatorBuilder: widget._emptyBuilder,
      ),
    );
  }
}
