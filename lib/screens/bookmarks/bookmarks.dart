import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../models/article.dart';
import '../../services/repository.dart';
import '../../widgets/empty_indicator.dart';
import '../../widgets/back_to_top.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/article_lazy_list.dart';
import './bookmark_search.dart';

class Bookmarks extends StatefulWidget {
  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  final PagingController<int, Article> _controller =
      PagingController(firstPageKey: 0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        indicatorBuilder: (context) => EmptyIndicator(
          icon: Icons.bookmark_border,
          title: 'No bookmarks found.',
          message:
              'Try adding some by tapping the bookmark icon on your feeds\' articles.',
        ),
      ),
    );
  }
}
