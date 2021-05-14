import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../models/article.dart';
import '../../services/repository.dart';
import '../../widgets/back_to_top.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/article_lazy_list.dart';
import './bookmark_search.dart';

class Bookmarks extends StatelessWidget {
  final PagingController<int, Article> _controller =
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

    return BackToTop(
      header: TopBar(
        title: 'Bookmarks',
        onSearch: () => _goToBookmarkSearch(context),
      ),
      body: ArticleLazyList(
        controller: _controller,
        onRequest: repository.getBookmarks,
      ),
    );
  }
}
