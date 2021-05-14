import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rss_feed/widgets/lazy_scroll_view.dart';

import '../models/source.dart';
import './source_list_item.dart';

class SourceLazyList extends StatelessWidget {
  static final int limit = 20;
  final PagingController<int, Source> controller;
  final Future<List<Source>> Function(int, int) onRequest;
  final Function(Source) onTap;
  final Function(Source) onRemove;

  SourceLazyList({
    Key key,
    this.controller,
    this.onTap,
    this.onRemove,
    this.onRequest,
  }) : super(key: key);

  // immediately remove source from list to avoid bugs with Dismissible widget
  removeSource(Source s) async {
    try {
      await onRemove(s);
      controller.refresh();
    } catch (err) {
      print("Error removing source: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LazyScrollView<Source>(
      controller: controller,
      onRequest: onRequest,
      itemBuilder: (context, item, i) => SourceListItem(
        source: item,
        onTap: onTap,
        onRemove: removeSource,
      ),
    );
  }
}
