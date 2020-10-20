import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

import 'models.dart';

var formatter = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z");

DateTime parseDate(String dateString) {
  try {
    var date = formatter.parse(dateString);
    return date;
  } catch (error) {
    print(error);
  }

  return DateTime.now();
}

class FeedDocument {
  Subscription subscription;
  List<Article> articles;

  FeedDocument({this.subscription, this.articles});

  static FeedDocument _parseRss(XmlElement root) {
    var channel = root.getElement('channel');

    var subscription = Subscription(
      title: channel.getElement('title').text,
      link: channel.getElement('link').text,
      description: channel.getElement('description').text,
    );

    var articles = channel.findElements('item').map((item) => Article(
          guid: item.getElement('guid').text,
          title: item.getElement('title').text,
          link: item.getElement('link').text,
          description: item.getElement('description').text,
          date: parseDate(item.getElement('pubDate').text),
        ));

    return FeedDocument(
        subscription: subscription, articles: articles.toList());
  }

  static FeedDocument parse(String xml) {
    var document = XmlDocument.parse(xml);
    var root = document.getElement("rss");

    if (root != null) {
      return _parseRss(root);
    }

    return null;
  }
}
