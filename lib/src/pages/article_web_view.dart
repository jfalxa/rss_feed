import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rss_feed/src/widgets/top_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../data/models.dart';

class ArticleWebView extends StatelessWidget {
  final Article _article;

  ArticleWebView({Article article}) : _article = article {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PopTopBar(title: _article.title),
      body: WebView(
        initialUrl: _article.link,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
