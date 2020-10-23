import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../data/repository.dart';
import '../widgets/loader.dart';
import '../widgets/article_list.dart';
import 'search.dart';

class SourceFeedSearch extends Search<Article> {
  final Source _source;

  SourceFeedSearch({@required Source source})
      : _source = source,
        super();

  @override
  Widget buildResults(BuildContext context) {
    var repository = Provider.of<Repository>(context);

    return Loader<List<Article>>(
      future: repository.findSourceArticles(_source, this.query),
      error: "Error searching for articles",
      builder: (context, articles) => ArticleList(
        articles: articles,
        onToggleBookmark: repository.toggleBookmark,
      ),
    );
  }
}
