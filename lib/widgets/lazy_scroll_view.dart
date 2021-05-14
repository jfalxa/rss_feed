import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import './separator.dart';

import 'dart:developer' as dev;

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

        dev.log(
            "${items.length} loaded ($offset:${widget.limit}), ${widget.onRequest}");

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
      separatorBuilder: separatorBuilder,
      builderDelegate: PagedChildBuilderDelegate<T>(
        itemBuilder: widget.itemBuilder,
      ),
    );
  }
}
