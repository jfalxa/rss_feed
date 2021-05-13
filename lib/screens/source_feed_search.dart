import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/article.dart';
import '../models/source.dart';
import '../services/repository.dart';
import '../widgets/article_list.dart';
import '../widgets/search.dart';

class SourceFeedSearch extends Search<Article> {
  final Source _source;

  SourceFeedSearch({@required Source source})
      : _source = source,
        super();

  @override
  Widget buildResults(BuildContext context) {
    var repository = Provider.of<Repository>(context);

    return InfiniteArticleList(
      fetch: (limit, offset) =>
          repository.findSourceArticles(_source, this.query, limit, offset),
    );
  }
}
