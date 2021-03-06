import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../data/repository.dart';
import '../widgets/loader.dart';
import '../widgets/article_list.dart';
import 'search.dart';

class BookmarkSearch extends Search<Article> {
  @override
  Widget buildResults(BuildContext context) {
    var repository = Provider.of<Repository>(context);

    return Loader<List<Article>>(
      future: repository.findBookmarks(this.query),
      error: "Error searching for articles",
      builder: (context, articles) => ArticleList(
        articles: articles,
        onToggleBookmark: repository.toggleBookmark,
      ),
    );
  }
}
