import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/article.dart';
import '../services/repository.dart';

class ToggleBookmark<T> extends StatefulWidget {
  final Article _article;

  ToggleBookmark({Key key, Article article})
      : _article = article,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ToggleBookmarkState<T>();
}

class _ToggleBookmarkState<T> extends State<ToggleBookmark<T>> {
  bool _isBookmarked;

  @override
  initState() {
    super.initState();
    _isBookmarked = widget._article.isBookmarked;
  }

  Future _toggleBookmark(BuildContext context) async {
    try {
      var repository = context.read<Repository>();
      var isBookmarked = await repository.toggleBookmark(widget._article.guid);

      if (isBookmarked != _isBookmarked) {
        setState(() {
          _isBookmarked = isBookmarked;
        });
      }
    } catch (err) {
      print("Error bookmarking article: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    var icon = _isBookmarked ? Icons.bookmark : Icons.bookmark_border;

    return IconButton(
      icon: Icon(icon),
      onPressed: () => _toggleBookmark(context),
    );
  }
}
