import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rss_feed/widgets/lazy_scroll_view.dart';

import '../models/source.dart';
import './source_list_item.dart';

class SourceLazyList extends StatelessWidget {
  static final int limit = 20;
  final PagingController<int, Source> _controller;
  final Future<List<Source>> Function(int, int) _onRequest;
  final Function(Source) _onTap;
  final Function(Source) _onRemove;

  SourceLazyList({
    Key key,
    PagingController<int, Source> controller,
    Future<List<Source>> Function(int, int) onRequest,
    Function(Source) onTap,
    Function(Source) onRemove,
  })  : _controller = controller,
        _onRequest = onRequest,
        _onTap = onTap,
        _onRemove = onRemove,
        super(key: key);

  // immediately remove source from list to avoid bugs with Dismissible widget
  _removeSource(Source s) async {
    try {
      await _onRemove(s);
      _controller.refresh();
    } catch (err) {
      print("Error removing source: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LazyScrollView<Source>(
      controller: _controller,
      onRequest: _onRequest,
      itemBuilder: (context, item, i) => SourceListItem(
        source: item,
        onTap: _onTap,
        onRemove: _removeSource,
      ),
    );
  }
}
