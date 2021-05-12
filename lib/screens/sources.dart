import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/repository.dart';
import '../models/source.dart';
import '../widgets/top_bar.dart';
import '../widgets/source_list.dart';
import './source_search.dart';
import './source_add.dart';
import './source_feed.dart';

class Sources extends StatelessWidget {
  final ScrollController controller;

  Sources({Key key, this.controller})
      : super(key: key);

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
      var repository = Provider.of<Repository>(context, listen: false);
      repository.addSource(source);
      repository.fetchAllSources();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Repository>(
      builder: (context, repository, child) => Scaffold(
        body: NestedScrollView(
          controller: controller,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            TopBar(
              title: 'Sources',
              onSearch: () => _goToSourceSearch(context),
            ),
          ],
          body: FutureSourceList(
            sources: repository.getSources(),
            onTap: (source) => _goToSourceFeed(context, source),
            onRemove: (source) => repository.removeSource(source),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _goToSourceApiSearch(context),
        ),
      ),
    );
  }
}
