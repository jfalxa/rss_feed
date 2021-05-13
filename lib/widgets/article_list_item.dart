import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import '../models/article.dart';

var dateFormat = DateFormat('d/M/y');

class ArticleListItem extends StatelessWidget {
  final Article article;
  final Function(Article) onToggleBookmark;

  ArticleListItem({Key key, this.article, this.onToggleBookmark})
      : super(key: key);

  void goToArticle(BuildContext context) async {
    if (await canLaunch(article.link)) {
      await launch(article.link);
    } else {
      throw 'Could not launch ${article.link}';
    }
  }

  @override
  Widget build(BuildContext context) {
    var uri = Uri.parse(article.link);

    var time = DateTime.now().difference(article.date) > Duration(days: 1)
        ? DateFormat.yMMMMd().format(article.date)
        : timeago.format(article.date);

    return InkWell(
      onTap: () => goToArticle(context),
      child: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          uri.host,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Text(
                        article.title,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: article.image == null
                        ? Image.asset(
                            'assets/images/dummy-image.jpg',
                            width: 72.0,
                            height: 72.0,
                          )
                        : Image.network(
                            article.image,
                            width: 72.0,
                            height: 72.0,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(time, style: Theme.of(context).textTheme.caption),
                  IconButton(
                    icon: article.isBookmarked
                        ? Icon(Icons.bookmark, color: Colors.black87)
                        : Icon(Icons.bookmark_border, color: Colors.black38),
                    onPressed: () => onToggleBookmark(article),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
