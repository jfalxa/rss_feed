import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/article.dart';
import '../services/repository.dart';

class ToggleBookmark<T> extends StatefulWidget {
  final Article article;

  ToggleBookmark({
    Key key,
    this.article,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ToggleBookmarkState<T>();
}

class _ToggleBookmarkState<T> extends State<ToggleBookmark<T>> {
  bool _isBookmarked = false;

  Future refreshBookmark(BuildContext context) async {
    var repository = context.watch<Repository>();
    var article = await repository.getArticle(widget.article.guid);

    if (_isBookmarked != article.isBookmarked) {
      setState(() {
        _isBookmarked = article.isBookmarked;
      });
    }
  }

  Future toggleBookmark(BuildContext context) async {
    var repository = context.read<Repository>();
    await repository.toggleBookmark(widget.article.guid);
  }

  @override
  Widget build(BuildContext context) {
    refreshBookmark(context);

    var icon = _isBookmarked
        ? Icon(Icons.bookmark, color: Colors.black87)
        : Icon(Icons.bookmark_border, color: Colors.black38);

    return IconButton(
      icon: icon,
      onPressed: () => toggleBookmark(context),
    );
  }
}
