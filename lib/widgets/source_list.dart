import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rss_feed/widgets/lazy_scroll_view.dart';

import '../models/source.dart';
import './source_list_item.dart';
import './separator.dart';

class SourceList extends StatelessWidget {
  final List<Source> sources;
  final Function(Source) onTap;

  SourceList({Key key, this.sources, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sources.length == 0) {
      return Center(child: Text('No sources found.'));
    }

    return ListView.separated(
      itemCount: sources.length,
      padding: EdgeInsets.all(0),
      separatorBuilder: separatorBuilder,
      itemBuilder: (context, i) => SourceListItem(
        source: sources[i],
        onTap: onTap,
      ),
    );
  }
}

class LazySourceList extends StatelessWidget {
  static final int limit = 20;
  final PagingController<int, Source> controller;
  final Future<List<Source>> Function(int, int) onRequest;
  final Function(Source) onTap;
  final Function(Source) onRemove;

  LazySourceList({
    Key key,
    this.controller,
    this.onTap,
    this.onRemove,
    this.onRequest,
  }) : super(key: key);

  // immediately remove source from list to avoid bugs with Dismissible widget
  removeSource(Source s) async {
    await onRemove(s);
    controller.refresh();
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
