import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../data/models.dart';

class ArticleListItem extends StatelessWidget {
  final Article _article;
  final int _index;

  ArticleListItem(int index, {Key key, Article article})
      : _article = article,
        _index = index,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var uri = Uri.parse(_article.link);
    var ago = timeago.format(_article.date);
    var top = _index == 0 ? 20.0 : 8.0;

    return Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: top),
        child: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Flexible(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          uri.host,
                          style: Theme.of(context).textTheme.caption,
                        )),
                    Text(
                      _article.title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ])),
              Container(
                  margin: EdgeInsets.only(left: 16.0),
                  child: Image.asset('assets/images/dummy-image.jpg'),
                  width: 72.0,
                  height: 72.0),
            ]),
            Container(
                margin: EdgeInsets.only(top: 8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        ago,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      IconButton(
                          icon: Icon(Icons.bookmark_border),
                          color: Colors.black38,
                          onPressed: () => null)
                    ])),
            Divider()
          ],
        ));
  }
}
