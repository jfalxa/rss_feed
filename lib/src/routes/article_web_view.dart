import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rss_feed/src/widgets/top_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../data/models.dart';

class ArticleWebView extends StatelessWidget {
  static final String routeName = '/article-web-view';

  ArticleWebView({Key key}) : super(key: key) {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    Article article = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: PopTopBar(title: article.title),
      body: WebView(
        initialUrl: article.link,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
