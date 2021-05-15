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
    Key? key,
    required PagingController<int, Source> controller,
    required Future<List<Source>> Function(int, int) onRequest,
    required Function(Source) onTap,
    required Function(Source) onRemove,
  })   : _controller = controller,
        _onRequest = onRequest,
        _onTap = onTap,
        _onRemove = onRemove,
        super(key: key);

  _removeSource(Source s) async {
    await _onRemove(s);
    _controller.refresh();
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
