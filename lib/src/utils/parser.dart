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
    print('DATE PARSING ERROR: $error');
  }

  return DateTime.now();
}

String parseImage(String html) {
  try {
    var document = XmlDocument.parse('<html>$html</html>');
    return document.getElement('html')?.getElement('img')?.getAttribute('src');
  } catch (error) {
    print('IMAGE PARSING ERROR: $error');
  }

  return null;
}

class FeedDocument {
  List<Article> articles;

  FeedDocument.parseRss(XmlElement root) {
    var channel = root.getElement('channel');
    var items = channel.findElements('item').map(
          (item) => Article(
            guid: item.getElement('guid')?.text,
            title: item.getElement('title')?.text,
            link: item.getElement('link')?.text,
            description: item.getElement('description')?.text,
            image: item.getElement('media:content')?.getAttribute("url"),
            date: parseDate(item.getElement('pubDate')?.text),
          ),
        );

    articles = items.toList();
  }

  FeedDocument.parseAtom(XmlElement feed) {
    var entries = feed.findElements('entry').map(
          (entry) => Article(
            guid: entry.getElement('id').text,
            title: entry.getElement('title').text,
            link: entry.getElement('link').getAttribute("href"),
            description: entry.getElement('summary')?.text,
            image: parseImage(entry.getElement('content')?.text),
            date: DateTime.parse(entry.getElement('published').text),
          ),
        );

    articles = entries.toList();
  }

  factory FeedDocument.parse(String xml) {
    try {
      var document = XmlDocument.parse(xml);

      var root = document.getElement('rss');
      var feed = document.getElement('feed');

      if (root != null) {
        return FeedDocument.parseRss(root);
      } else if (feed != null) {
        return FeedDocument.parseAtom(feed);
      }
    } catch (error) {
      print('COULD NOT PARSE XML: $error');
    }

    return null;
  }

  static Future<FeedDocument> fetchAndParse(String url) async {
    final response = await http.get(url);

    if (response.statusCode != 200) {
      return null;
    }

    var xml = utf8.decode(response.bodyBytes);
    return FeedDocument.parse(xml);
  }
}
