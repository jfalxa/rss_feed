import 'package:flutter/material.dart';

import '../models/source.dart';
import './source_list_item.dart';

class SourceList extends StatelessWidget {
  final List<Source> sources;
  final Function(Source) onTap;

  SourceList({Key key, this.sources, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sources.length == 0) {
      return Center(child: Text('No sources found.'));
    }

    return ListView.separated(
      itemCount: sources.length,
      padding: EdgeInsets.all(0),
      separatorBuilder: (context, index) =>
          Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, i) =>
          SourceListItem(source: sources[i], onTap: onTap),
    );
  }
}
