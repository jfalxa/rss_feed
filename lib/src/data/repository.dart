import 'package:flutter/foundation.dart';
import 'package:rss_feed/src/data/database.dart';
import 'package:rss_feed/src/utils/parser.dart';

import 'models.dart';

class Repository extends ChangeNotifier {
  FeedDatabase _database = FeedDatabase();
  Future loader;

  Repository() {
    loader = refreshAllSubscriptions();
  }

  Future addSubscription(Subscription s) {
    return _database.addSubscription(s);
  }

  Future addSubscriptionArticles(Subscription s, List<Article> aa) {
    return _database.addSubscriptionArticles(s, aa);
  }

  Future<List<Subscription>> getSubscriptions() {
    return _database.getSubscriptions();
  }

  Future<List<Article>> getArticles() {
    return _database.getArticles();
  }

  Future<List<Article>> getSubscriptionArticles(Subscription s) {
    return _database.getSubscriptionArticles(s);
  }

  Future refreshSubscription(Subscription s) async {
    var document = await FeedDocument.fetchAndParse(s.url);

    if (document != null) {
      addSubscriptionArticles(s, document.articles);
    }
  }

  Future refreshAllSubscriptions() async {
    var subscriptions = await getSubscriptions();
    loader = Future.wait(subscriptions.map(refreshSubscription));
    notifyListeners();
    await loader;
    return true;
  }
}
