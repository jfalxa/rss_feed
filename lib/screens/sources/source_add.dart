import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/source.dart';
import '../../services/repository.dart';
import '../../widgets/loader.dart';
import '../../widgets/source_list.dart';
import '../../widgets/search.dart';

class SourceAdd extends Search<Source> {
  @override
  Widget buildResults(BuildContext context) {
    final repository = context.read<Repository>();

    return Loader<List<Source>>(
      future: repository.searchSources(query),
      error: 'Error searching for sources',
      builder: (context, sources) => SourceList(
        sources: sources,
        onTap: (s) => close(context, s),
      ),
    );
  }
}
