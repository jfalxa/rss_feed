import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_feed/src/widgets/top_bar.dart';

import '../data/repository.dart';
import '../widgets/loader.dart';
import '../widgets/top_bar.dart';
import '../widgets/article_list.dart';
import '../search/bookmark_search.dart';

class Bookmarks extends StatelessWidget {
  void _goToBookmarkSearch(BuildContext context) async {
    await showSearch(
      context: context,
      delegate: BookmarkSearch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Repository>(
      builder: (context, repository, child) => Scaffold(
        appBar: TopBar(
          title: 'Bookmarks',
          onSearch: () => _goToBookmarkSearch(context),
        ),
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
