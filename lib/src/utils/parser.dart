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

    var items = channel.findElements('item').map((item) {
      var guid = item.getElement('guid')?.text;
      var title = item.getElement('title')?.text;
      var link = item.getElement('link')?.text;
      var description = item.getElement('description')?.text;
      var image = item.getElement('media:content')?.getAttribute("url");
      var date = parseDate(item.getElement('pubDate')?.text);

      return Article(
        guid: guid ?? link,
        title: title,
        link: link,
        description: description,
        image: image,
        date: date,
      );
    });

    articles = items.toList();
  }

  FeedDocument.parseAtom(XmlElement feed) {
    var entries = feed.findElements('entry').map((entry) {
      var guid = entry.getElement('id').text;
      var title = entry.getElement('title').text;
      var link = entry.getElement('link').getAttribute("href");
      var description = entry.getElement('summary')?.text;
      var image = parseImage(entry.getElement('content')?.text);
      var date = DateTime.parse(entry.getElement('published').text);

      return Article(
        guid: guid ?? link,
        title: title,
        link: link,
        description: description,
        image: image,
        date: date,
      );
    });

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
