class Subscription {
  String url;
  String title;
  String link;
  String description;

  Subscription({this.url, this.title, this.link, this.description});
  Subscription.empty();
}

class Article {
  String guid;
  String title;
  String link;
  String description;
  DateTime date;

  Article({this.guid, this.title, this.link, this.description, this.date});
}
