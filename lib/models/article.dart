import 'package:sqflite/sqflite.dart';
import 'package:webfeed/webfeed.dart';

import '../services/scraper.dart';

final String tArticle = 'article';
final String cArticleGuid = 'guid';
final String cArticleLink = 'link';
final String cArticleTitle = 'title';
final String cArticleDescription = 'description';
final String cArticleImage = 'image';
final String cArticleDate = 'date';
final String cArticleIsBookmarked = 'is_bookmarked';

class Article {
  String guid;
  String title;
  String link;
  String? image;
  String description;
  DateTime date;
  bool isBookmarked = false;

  Article({
    required this.guid,
    required this.title,
    required this.link,
    required this.image,
    required this.description,
    required this.date,
  });

  Article.fromMap(Map<String, dynamic> map)
      : guid = map[cArticleGuid],
        title = map[cArticleTitle],
        link = map[cArticleLink],
        image = map[cArticleImage],
        description = map[cArticleDescription],
        date = DateTime.parse(map[cArticleDate]),
        isBookmarked = map[cArticleIsBookmarked] == 1;

  Article.fromRss(RssItem item)
      : link = item.link ?? '',
        guid = item.guid ?? item.link ?? '',
        title = item.title ?? '',
        description = item.description ?? '',
        date = item.pubDate ?? DateTime.now() {
    if (item.media?.thumbnails?.isNotEmpty ?? false) {
      image = item.media?.thumbnails?[0].url;
    } else if (item.media?.contents?.isNotEmpty ?? false) {
      image = item.media?.contents?[0].url;
    }
  }

  Article.fromAtom(AtomItem item)
      : link = item.links?[0].href ?? '',
        guid = item.id ?? item.links?[0].href ?? '',
        title = item.title ?? '',
        date = parseDate(item.published ?? ''),
        description = item.summary ?? '' {
    if (item.media?.thumbnails?.isNotEmpty ?? false) {
      image = item.media?.thumbnails?[0].url;
    } else if (item.media?.contents?.isNotEmpty ?? false) {
      image = item.media?.contents?[0].url;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      cArticleGuid: guid,
      cArticleTitle: title,
      cArticleLink: link,
      cArticleImage: image,
      cArticleDescription: description,
      cArticleDate: date.toIso8601String(),
      cArticleIsBookmarked: isBookmarked ? 1 : 0
    };
  }
}

class ArticleDao {
  final Future<Database> db;

  ArticleDao({required this.db});

  static Future createArticleTable(Transaction tx) {
    return tx.execute('''
      CREATE TABLE $tArticle (
        $cArticleGuid TEXT PRIMARY KEY,
        $cArticleTitle TEXT,
        $cArticleDescription TEXT,
        $cArticleLink TEXT,
        $cArticleImage TEXT,
        $cArticleDate TEXT,
        $cArticleIsBookmarked INTEGER
      )
    ''');
  }

  Future addArticles(List<Article> articles, [Transaction? tx]) async {
    var batch = (tx ?? await db).batch();

    articles.forEach(
      (article) => batch.insert(
        tArticle,
        article.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      ),
    );

    return batch.commit();
  }

  Future<List<Article>> getArticles(int limit, int offset) async {
    final articles = await (await db).query(
      tArticle,
      orderBy: '$cArticleDate DESC',
      limit: limit,
      offset: offset,
    );

    return articles.map((article) => Article.fromMap(article)).toList();
  }

  Future<List<Article>> findArticles(
    String query,
    int limit,
    int offset,
  ) async {
    final foundArticles = await (await db).query(
      tArticle,
      where: '$cArticleTitle LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: '$cArticleDate DESC',
      limit: limit,
      offset: offset,
    );

    return foundArticles.map((article) => Article.fromMap(article)).toList();
  }

  Future<bool> toggleBookmark(Article article, [bool? toggle]) async {
    final isBookmarked = (toggle != null && toggle) || !article.isBookmarked;

    await (await db).update(
      tArticle,
      {cArticleIsBookmarked: isBookmarked ? 1 : 0},
      where: '$cArticleGuid = ?',
      whereArgs: [article.guid],
    );

    return isBookmarked;
  }

  Future<List<Article>> getBookmarks(int limit, int offset) async {
    final bookmarks = await (await db).query(
      tArticle,
      where: '$cArticleIsBookmarked = 1',
      orderBy: '$cArticleDate DESC',
      limit: limit,
      offset: offset,
    );

    return bookmarks.map((article) => Article.fromMap(article)).toList();
  }

  Future<List<Article>> findBookmarks(
    String query,
    int limit,
    int offset,
  ) async {
    final foundArticles = await (await db).query(
      tArticle,
      where: '$cArticleTitle LIKE ? AND $cArticleIsBookmarked = 1',
      whereArgs: ['%$query%'],
      orderBy: '$cArticleDate DESC',
      limit: limit,
      offset: offset,
    );

    return foundArticles.map((article) => Article.fromMap(article)).toList();
  }
}
