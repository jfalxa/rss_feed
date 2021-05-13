import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/repository.dart';
import '../widgets/top_bar.dart';
import '../widgets/article_list.dart';
import './bookmark_search.dart';

class Bookmarks extends StatelessWidget {
  final ScrollController controller;

  Bookmarks({Key key, this.controller})
      : super(key: key);

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
        controller: controller,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          TopBar(
            title: 'Bookmarks',
            onSearch: () => _goToBookmarkSearch(context),
          ),
        ],
        body: InfiniteArticleList(
          fetch: (limit, offset) => repository.getBookmarks(limit, offset),
          controller: controller,
          onToggleBookmark: repository.toggleBookmark,
        ),
      ),
    );
  }
}
