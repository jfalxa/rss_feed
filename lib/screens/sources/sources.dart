import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../models/source.dart';
import '../../services/repository.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/source_list.dart';
import './source_search.dart';
import './source_add.dart';
import './source_feed.dart';

class Sources extends StatelessWidget {
  final ScrollController controller;
  final PagingController<int, Source> pagingController =
      PagingController(firstPageKey: 0);

  Sources({Key key, this.controller}) : super(key: key);

  void _goToSourceFeed(BuildContext context, Source source) {
    Navigator.pushNamed(context, SourceFeed.routeName, arguments: source);
  }

  void _goToSourceSearch(BuildContext context) async {
    await showSearch(
      context: context,
      delegate: SourceSearch(),
    );
  }

  void _goToSourceApiSearch(BuildContext context) async {
    final Source source = await showSearch<Source>(
      context: context,
      delegate: SourceAdd(),
    );

    if (source != null) {
      var repository = context.read<Repository>();
      await repository.addSource(source);
      pagingController.refresh();
      await repository.fetchSource(source);
    }
  }

  @override
  Widget build(BuildContext context) {
    var repository = context.read<Repository>();

    return Scaffold(
      body: NestedScrollView(
        controller: controller,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          TopBar(
            title: 'Sources',
            onSearch: () => _goToSourceSearch(context),
          ),
        ],
        body: LazySourceList(
          controller: pagingController,
          onRequest: repository.getSources,
          onTap: (source) => _goToSourceFeed(context, source),
          onRemove: (source) => repository.removeSource(source),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _goToSourceApiSearch(context),
      ),
    );
  }
}
