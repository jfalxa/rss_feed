import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_feed/src/widgets/top_bar.dart';

import '../data/repository.dart';
import '../widgets/loader.dart';
import '../widgets/top_bar.dart';
import '../widgets/article_list.dart';
import '../search/bookmark_search.dart';

class Bookmarks extends StatelessWidget {
  final ScrollController _scroll;

  Bookmarks({Key key, ScrollController scroll})
      : _scroll = scroll,
        super(key: key);

  void _goToBookmarkSearch(BuildContext context) async {
    await showSearch(
      context: context,
      delegate: BookmarkSearch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Repository>(
      builder: (context, repository, child) => NestedScrollView(
        controller: _scroll,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverTopBar(
            title: 'Bookmarks',
            onSearch: () => _goToBookmarkSearch(context),
          ),
        ],
        body: Loader(
          future: repository.loader,
          error: 'Error refreshing bookmarks',
          builder: (context, data) => FutureArticleList(
            articles: repository.getBookmarks(),
            onRefresh: repository.refreshAllSources,
            onToggleBookmark: repository.toggleBookmark,
          ),
        ),
      ),
    );
  }
}
