import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:webfeed/webfeed.dart';

import './source_article.dart';

final String tArticle = 'article';

final String cGuid = 'guid';
final String cTitle = 'title';
final String cLink = 'link';
final String cDescription = 'description';
final String cImage = 'image';
final String cDate = 'date';
final String cIsBookmarked = 'is_bookmarked';

var formatter = DateFormat('EEE, dd MMM yyyy HH:mm:ss Z');

DateTime parseDate(String dateString) {
  try {
    return formatter.parse(dateString);
  } catch (error) {
    print('DATE PARSING ERROR: $error');
  }

  return DateTime.now();
}

class Article {
  String guid;
  String title;
  String link;
  String image;
  String description;
  DateTime date;
  bool isBookmarked = false;

  Article({
    this.guid,
    this.title,
    this.link,
    this.image,
    this.description,
    this.date,
  });

  Article.fromMap(Map<String, dynamic> map) {
    guid = map[cGuid];
    title = map[cTitle];
    link = map[cLink];
    image = map[cImage];
    description = map[cDescription];
    date = DateTime.parse(map[cDate]);
    isBookmarked = map[cIsBookmarked] == 1;
  }

  Article.fromRss(RssItem item) {
    link = item.link;
    guid = item.guid ?? link;
    title = item.title;
    date = item.pubDate;
    description = item.description;

    if (item.media.thumbnails.length > 0) {
      image = item.media.thumbnails[0].url;
    } else if (item.media.contents.length > 0) {
      image = item.media.contents[0].url;
    }
  }

  Article.fromAtom(AtomItem item) {
    link = item.links[0].href;
    guid = item.id ?? link;
    title = item.title;
    date = parseDate(item.published);
    description = item.summary;

    if (item.media.thumbnails.length > 0) {
      image = item.media.thumbnails[0].url;
    } else if (item.media.contents.length > 0) {
      image = item.media.contents[0].url;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      cGuid: guid,
      cTitle: title,
      cLink: link,
      cImage: image,
      cDescription: description,
      cDate: date.toIso8601String(),
      cIsBookmarked: isBookmarked ? 1 : 0
    };
  }

  static Future createTable(Transaction tx) {
    return tx.execute('''
      CREATE TABLE $tArticle (
        $cGuid TEXT PRIMARY KEY,
        $cTitle TEXT,
        $cLink TEXT,
        $cDescription TEXT,
        $cImage TEXT,
        $cDate TEXT,
        $cIsBookmarked INTEGER
      )
    ''');
  }

  static Future addArticles(Transaction tx, List<Article> al) {
    var batch = tx.batch();

    al.forEach(
      (a) => batch.insert(
        tArticle,
        a.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      ),
    );

    return batch.commit();
  }

  static Future addBookmark(Database db, Article a) async {
    return db.update(tArticle, {cIsBookmarked: 1},
        where: '$cGuid = ?', whereArgs: [a.guid]);
  }

  static Future<List<Article>> getArticles(
    Database db,
    int limit,
    int offset,
  ) async {
    final articles = await db.query(
      tArticle,
      orderBy: '$cDate DESC',
      limit: limit,
      offset: offset,
    );

    return articles.map((a) => Article.fromMap(a)).toList();
  }

  static Future<List<Article>> getBookmarks(
      Database db, int limit, int offset) async {
    final bookmarkedArticles = await db.query(tArticle,
        where: '$cIsBookmarked = 1',
        orderBy: '$cDate DESC',
        limit: limit,
        offset: offset);

    return bookmarkedArticles.map((a) => Article.fromMap(a)).toList();
  }

  static Future<List<Article>> findArticles(
    Database db,
    String query,
    int limit,
    int offset,
  ) async {
    final foundArticles = await db.query(
      tArticle,
      where: '$cTitle LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: '$cDate DESC',
      limit: limit,
      offset: offset,
    );

    return foundArticles.map((a) => Article.fromMap(a)).toList();
  }

  static Future<List<Article>> findBookmarks(
    Database db,
    String query,
    int limit,
    int offset,
  ) async {
    final foundArticles = await db.query(
      tArticle,
      where: '$cTitle LIKE ? AND $cIsBookmarked = 1',
      whereArgs: ['%$query%'],
      orderBy: '$cDate DESC',
      limit: limit,
      offset: offset,
    );

    return foundArticles.map((a) => Article.fromMap(a)).toList();
  }

  static Future removeOrphans(Transaction tx) {
    return tx.rawDelete('''
      DELETE FROM $tArticle
      WHERE $cGuid NOT IN (
        SELECT $cArticleGuid
        FROM $tSourceAndArticle
      )
    ''');
  }

  static Future removeBookmark(Database db, Article a) async {
    return db.update(tArticle, {cIsBookmarked: 0},
        where: '$cGuid = ?', whereArgs: [a.guid]);
  }
}
