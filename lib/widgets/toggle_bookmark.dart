import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/article.dart';
import '../services/database.dart';

class ToggleBookmark<T> extends StatefulWidget {
  final Article _article;

  ToggleBookmark({Key? key, required Article article})
      : _article = article,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ToggleBookmarkState<T>();
}

class _ToggleBookmarkState<T> extends State<ToggleBookmark<T>> {
  bool _isBookmarked = false;

  @override
  initState() {
    super.initState();
    _isBookmarked = widget._article.isBookmarked;
  }

  Future _toggleBookmark(BuildContext context) async {
    try {
      final database = context.read<Database>();
      var isBookmarked = await database.toggleBookmark(widget._article.guid);

      setState(() {
        _isBookmarked = isBookmarked;
      });
    } catch (err) {
      print('Error bookmarking article: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    var icon = _isBookmarked ? Icons.bookmark : Icons.bookmark_border;

    return Opacity(
      opacity: _isBookmarked ? 1 : 0.5,
      child: IconButton(
        icon: Icon(icon),
        onPressed: () => _toggleBookmark(context),
      ),
    );
  }
}
