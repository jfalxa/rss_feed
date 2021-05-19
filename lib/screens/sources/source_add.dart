import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/source.dart';
import '../../services/scraper.dart';
import '../../widgets/loader.dart';
import '../../widgets/source_list.dart';
import '../../widgets/search.dart';

class SourceAdd extends Search<Source> {
  @override
  Widget buildResults(BuildContext context) {
    final scraper = context.read<Scraper>();

    return Loader<List<Source>>(
      future: scraper.search(query),
      error: 'Error searching for sources',
      builder: (context, sources) => SourceList(
        sources: sources,
        onTap: (s) => close(context, s),
      ),
    );
  }
}
