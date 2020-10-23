import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

import '../data/models.dart';

var formatter = DateFormat('EEE, dd MMM yyyy HH:mm:ss Z');

DateTime parseDate(String dateString) {
  try {
    return formatter.parse(dateString);
  } catch (error) {
    print(error);
  }

  return DateTime.now();
}

class FeedDocument {
  List<Article> articles;

  FeedDocument({this.articles});

  static FeedDocument _parseRss(String url, XmlElement root) {
    var channel = root.getElement('channel');

    var articles = channel.findElements('item').map((item) => Article(
        guid: item.getElement('guid').text,
        title: item.getElement('title').text,
        link: item.getElement('link').text,
        description: item.getElement('description').text,
        date: parseDate(item.getElement('pubDate').text)));

    return FeedDocument(articles: articles.toList());
  }

  static FeedDocument parse(String url, String xml) {
    try {
      var document = XmlDocument.parse(xml);
      var root = document.getElement('rss');

      if (root != null) {
        return _parseRss(url, root);
      }
    } catch (error) {
      print(error);
    }

    return null;
  }

  static Future<FeedDocument> fetchAndParse(String url) async {
    final response = await http.get(url);

    if (response.statusCode != 200) {
      return null;
    }

    return FeedDocument.parse(url, utf8.decode(response.bodyBytes));
  }
}
