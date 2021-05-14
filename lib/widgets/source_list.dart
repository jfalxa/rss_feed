import 'package:flutter/material.dart';

import '../models/source.dart';
import './source_list_item.dart';

class SourceList extends StatelessWidget {
  final List<Source> _sources;
  final Function(Source) _onTap;

  SourceList({Key key, List<Source> sources, Function(Source) onTap})
      : _sources = sources,
        _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_sources.length == 0) {
      return Center(child: Text('No sources found.'));
    }

    return ListView.separated(
      itemCount: _sources.length,
      padding: EdgeInsets.all(0),
      separatorBuilder: (context, index) =>
          Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, i) =>
          SourceListItem(source: _sources[i], onTap: _onTap),
    );
  }
}
