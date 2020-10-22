import 'package:http/http.dart' as http;
import 'parser.dart';

var feedRx = RegExp(r'rss|xml');

class Subscription {
  String url;
  String title;
  String website;
  String description;
  String icon;

  Subscription(
      {this.url, this.title, this.website, this.description, this.icon});

  factory Subscription.fromJson(Map<String, dynamic> json) {
    var url = json['website'].contains(feedRx)
        ? json['website']
        : json['feedId'].substring(5);

    return Subscription(
        url: url,
        website: json['website'],
        title: json['title'],
        description: json['description'],
        icon: json['iconUrl']);
  }

  Future<FeedDocument> fetch() async {
    final response = await http.get(url);

    if (response.statusCode != 200) {
      return null;
    }

    return FeedDocument.parse(url, response.body);
  }
}

class Article {
  String guid;
  String title;
  String link;
  String description;
  DateTime date;
  String subscriptionUrl;

  Article(
      {this.guid,
      this.title,
      this.link,
      this.description,
      this.date,
      this.subscriptionUrl});
}
