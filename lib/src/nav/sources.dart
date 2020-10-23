import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/repository.dart';
import '../data/models.dart';
import '../routes/source_feed.dart';
import '../widgets/loader.dart';
import '../widgets/top_bar.dart';
import '../widgets/source_list.dart';
import '../search/source_search.dart';
import '../search/source_api_search.dart';

class Sources extends StatelessWidget {
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
      delegate: SourceApiSearch(),
    );

    if (source != null) {
      var repository = Provider.of<Repository>(context, listen: false);
      repository.addSource(source);
      repository.refreshAllSources();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Repository>(
      builder: (context, repository, child) => Scaffold(
        appBar: TopBar(
          title: 'Sources',
          onSearch: () => _goToSourceSearch(context),
        ),
        body: Loader(
          future: repository.loader,
          error: 'Error loading sources',
          builder: (context, _) => FutureSourceList(
              sources: repository.getSources(),
              onTap: (source) => _goToSourceFeed(context, source),
              onRemove: (source) => repository.removeSource(source)),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _goToSourceApiSearch(context),
        ),
      ),
    );
  }
}
