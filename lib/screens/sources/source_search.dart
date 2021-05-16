import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/source.dart';
import '../../services/repository.dart';
import '../../widgets/source_lazy_list.dart';
import '../../widgets/search.dart';
import '../../widgets/empty_indicator.dart';
import './source_feed.dart';

class SourceSearch extends Search<Source> {
  void _goToSourceFeed(BuildContext context, Source source) {
    Navigator.pushNamed(context, SourceFeed.routeName, arguments: source);
  }

  @override
  Widget buildResults(BuildContext context) {
    var repository = context.read<Repository>();

    return SourceLazyList(
      controller: controller,
      onRequest: (l, o) => repository.findSources(query, l, o),
      onTap: (source) => _goToSourceFeed(context, source),
      onRemove: (source) => repository.removeSource(source),
      indicatorBuilder: (context) => EmptyIndicator(title: 'No source found.'),
    );
  }
}
