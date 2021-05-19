import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/source.dart';
import '../../services/database.dart';
import '../../widgets/source_lazy_list.dart';
import '../../widgets/search.dart';
import '../../widgets/empty_indicator.dart';
import './source_feed.dart';

class SourceSearch extends Search<Source> {
  Future<List<Source>> _findSources(
      BuildContext context, int limit, int offset) {
    final database = context.read<Database>();
    return database.findSources(query, limit, offset);
  }

  void _removeSource(BuildContext context, Source source) async {
    final database = context.read<Database>();
    await database.forgetSource(source);
  }

  void _goToSourceFeed(BuildContext context, Source source) {
    Navigator.pushNamed(context, SourceFeed.routeName, arguments: source);
  }

  @override
  Widget buildResults(BuildContext context) {
    return SourceLazyList(
      controller: controller,
      onRequest: (limit, offset) => _findSources(context, limit, offset),
      onTap: (source) => _goToSourceFeed(context, source),
      onRemove: (source) => _removeSource(context, source),
      emptyBuilder: (context) => EmptyIndicator(title: 'No source found.'),
    );
  }
}
