import 'package:http/http.dart' as http;

import 'models.dart';
import 'parser.dart';

class Store {
  Map<String, Subscription> subscriptions;
  List<Article> articles;

  Store(Map<String, Subscription> subscriptions, List<Article> articles)
      : subscriptions = Map.from(subscriptions),
        articles = articles;

  void addSubscription(String url, Subscription addedSubscription) {
    subscriptions[url] = addedSubscription;
  }

  void addArticles(List<Article> addedArticles) {
    articles.addAll(addedArticles);
  }

  Future fetch(String url) async {
    final response = await http.get(url);

    if (response.statusCode != 200) {
      return false;
    }

    var document = FeedDocument.parse(response.body);

    addSubscription(url, document.subscription);
    addArticles(document.articles);

    return true;
  }

  Future fetchAll() {
    return Future.wait(subscriptions.keys.map((key) => fetch(key)));
  }
}
