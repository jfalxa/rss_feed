import 'package:flutter_test/flutter_test.dart';

import '../lib/src/utils/parser.dart';

const FEEDS = [
  'http://feeds.feedburner.com/blogspot/amDG',
  'https://news.ycombinator.com/rss',
  'https://www.lefigaro.fr/rss/figaro_actualites.xml',
  'https://www.lemonde.fr/rss/une.xml',
  'https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml',
  'https://www.polygon.com/rss/index.xml',
  'https://www.theguardian.com/uk/rss',
  'http://toutiao.secjia.com/feed/',
];

void main() {
  test('try and parse different kinds of feeds', () async {
    var futures = FEEDS.map(FeedDocument.fetchAndParse);
    var results = await Future.wait(futures);

    results.forEach((doc) {
      // verify that we parsed some data
      expect(doc.articles.length, greaterThan(0));
    });
  });
}
