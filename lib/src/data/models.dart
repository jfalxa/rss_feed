import 'database.dart';

class Subscription {
  String url;
  String title;
  String website;
  String icon;
  String description;

  Subscription({
    this.url,
    this.title,
    this.website,
    this.icon,
    this.description,
  });

  Subscription.fromMap(Map<String, dynamic> map) {
    url = map[S_URL];
    title = map[S_TITLE];
    website = map[S_WEBSITE];
    icon = map[S_ICON];
    description = map[S_DESCRIPTION];
  }

  Map<String, dynamic> toMap() {
    return {
      S_URL: url,
      S_TITLE: title,
      S_WEBSITE: website,
      S_ICON: icon,
      S_DESCRIPTION: description,
    };
  }
}

class Article {
  String guid;
  String title;
  String link;
  String image;
  String description;
  DateTime date;

  Article({
    this.guid,
    this.title,
    this.link,
    this.image,
    this.description,
    this.date,
  });

  Article.fromMap(Map<String, dynamic> map) {
    guid = map[A_GUID];
    title = map[A_TITLE];
    link = map[A_LINK];
    image = map[A_IMAGE];
    description = map[A_DESCRIPTION];
    date = DateTime.parse(map[A_DATE]);
  }

  Map<String, dynamic> toMap() {
    return {
      A_GUID: guid,
      A_TITLE: title,
      A_LINK: link,
      A_IMAGE: image,
      A_DESCRIPTION: description,
      A_DATE: date.toIso8601String(),
    };
  }
}

class SubscriptionAndArticle {
  String subscriptionUrl;
  String articleGuid;

  SubscriptionAndArticle(Subscription s, Article a)
      : subscriptionUrl = s.url,
        articleGuid = a.guid;

  Map<String, dynamic> toMap() {
    return {
      S_A_SUBSCRIPTION_URL: subscriptionUrl,
      S_A_ARTICLE_GUID: articleGuid
    };
  }
}
