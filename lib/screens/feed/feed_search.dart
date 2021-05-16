import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/article.dart';
import '../../services/repository.dart';
import '../../widgets/empty_indicator.dart';
import '../../widgets/article_lazy_list.dart';
import '../../widgets/search.dart';

class FeedSearch extends Search<Article> {
  @override
  Widget buildResults(BuildContext context) {
    var repository = context.read<Repository>();

    return ArticleLazyList(
      controller: controller,
      onRequest: (l, o) => repository.findArticles(this.query, l, o),
      indicatorBuilder: (context) => EmptyIndicator(title: 'No article found.'),
    );
  }
}
