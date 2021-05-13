import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/article.dart';
import '../services/repository.dart';
import '../widgets/article_list.dart';
import '../widgets/search.dart';

class BookmarkSearch extends Search<Article> {
  @override
  Widget buildResults(BuildContext context) {
    var repository = Provider.of<Repository>(context);

    return InfiniteArticleList(
      fetch: (limit, offset) =>
          repository.findBookmarks(this.query, limit, offset),
    );

  }
}