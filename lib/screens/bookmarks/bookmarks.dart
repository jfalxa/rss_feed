import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../models/article.dart';
import '../../services/repository.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/article_list.dart';
import 'bookmark_search.dart';

class Bookmarks extends StatelessWidget {
  final PagingController<int, Article> controller =
      PagingController(firstPageKey: 0);

  Bookmarks({Key key}) : super(key: key);

  void _goToBookmarkSearch(BuildContext context) async {
    await showSearch(
      context: context,
      delegate: BookmarkSearch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var repository = context.read<Repository>();

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        TopBar(
          title: 'Bookmarks',
          onSearch: () => _goToBookmarkSearch(context),
        ),
      ],
      body: LazyArticleList(
        controller: controller,
        onRequest: repository.getBookmarks,
      ),
    );
  }
}
