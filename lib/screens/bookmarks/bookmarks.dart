import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../models/article.dart';
import '../../services/database.dart';
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

  void _goToBookmarkSearch() async {
    await showSearch(
      context: context,
      delegate: BookmarkSearch(),
    );
  }

  Future<List<Article>> _getBookmarks(int limit, int offset) {
    final database = context.read<Database>();
    return database.getBookmarks(limit, offset);
  }

  Widget _buildEmpty(BuildContext context) {
    return EmptyIndicator(
      icon: Icons.bookmark_border,
      title: 'No bookmarks found.',
      message: 'Try adding some by tapping the bookmark icon on articles.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackToTop(
      builder: (context, controller) => NestedScrollView(
        controller: controller,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          TopBar(title: 'Bookmarks', onSearch: _goToBookmarkSearch),
        ],
        body: ArticleLazyList(
          controller: _controller,
          onRequest: _getBookmarks,
          emptyBuilder: _buildEmpty,
        ),
      ),
    );
  }
}
