var feedRx = RegExp(r'rss|xml');

class Subscription {
  String url;
  String title;
  String website;
  String description;
  String icon;

  Subscription({
    this.url,
    this.title,
    this.website,
    this.description,
    this.icon,
  });

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
}

class Article {
  String guid;
  String title;
  String link;
  String description;
  DateTime date;

  Article({
    this.guid,
    this.title,
    this.link,
    this.description,
    this.date,
  });
}

class SubscriptionAndArticle {
  String subscriptionUrl;
  String articleGuid;

  SubscriptionAndArticle(this.subscriptionUrl, this.articleGuid);
}
