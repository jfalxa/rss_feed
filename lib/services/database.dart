import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../models/article.dart';
import '../models/source.dart';
import '../models/source_article.dart';
import './scraper.dart';

mixin _Sources {
  sql.Database? db;

  Future createSourceTable(sql.Transaction tx) {
    return tx.execute('''
      CREATE TABLE $tSource (
        $cSourceUrl TEXT PRIMARY KEY,
        $cSourceTitle TEXT,
        $cSourceDescription TEXT,
        $cSourceWebsite TEXT,
        $cSourceIcon TEXT
      )
    ''');
  }

  Future addSource(Source source) async {
    return db?.insert(tSource, source.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.ignore);
  }

  Future<List<Source>> getSources([int? limit, int? offset]) async {
    final sources = await db?.query(
      tSource,
      orderBy: '$cSourceTitle',
      limit: limit,
      offset: offset,
    );

    return (sources ?? []).map((source) => Source.fromMap(source)).toList();
  }

  Future<List<Source>> findSources(String query, int limit, int offset) async {
    final foundSources = await db?.query(
      tSource,
      where: '$cSourceTitle LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: '$cSourceTitle',
      limit: limit,
      offset: offset,
    );

    return (foundSources ?? [])
        .map((source) => Source.fromMap(source))
        .toList();
  }

  Future removeSource(sql.Transaction tx, Source source) async {
    return tx.delete(
      tSource,
      where: '$cSourceUrl = ?',
      whereArgs: [source.url],
    );
  }
}

mixin _Articles {
  sql.Database? db;

  Future createArticleTable(sql.Transaction tx) {
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

  Future addArticles(sql.Transaction tx, List<Article> articles) {
    var batch = tx.batch();

    articles.forEach(
      (article) => batch.insert(
        tArticle,
        article.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.ignore,
      ),
    );

    return batch.commit();
  }

  Future addBookmark(Article article) async {
    return db?.update(
      tArticle,
      {cArticleIsBookmarked: 1},
      where: '$cArticleGuid = ?',
      whereArgs: [article.guid],
    );
  }

  Future<Article?> getArticle(String guid) async {
    var articles = await db?.query(
      tArticle,
      where: '$cArticleGuid = ?',
      whereArgs: [guid],
    );

    return articles?.length == 1 ? Article.fromMap(articles![0]) : null;
  }

  Future<List<Article>> getArticles(int limit, int offset) async {
    final articles = await db?.query(
      tArticle,
      orderBy: '$cArticleDate DESC',
      limit: limit,
      offset: offset,
    );

    return (articles ?? []).map((article) => Article.fromMap(article)).toList();
  }

  Future<List<Article>> getBookmarks(int limit, int offset) async {
    final bookmarks = await db?.query(
      tArticle,
      where: '$cArticleIsBookmarked = 1',
      orderBy: '$cArticleDate DESC',
      limit: limit,
      offset: offset,
    );

    return (bookmarks ?? [])
        .map((article) => Article.fromMap(article))
        .toList();
  }

  Future<List<Article>> findArticles(
    String query,
    int limit,
    int offset,
  ) async {
    final foundArticles = await db?.query(
      tArticle,
      where: '$cArticleTitle LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: '$cArticleDate DESC',
      limit: limit,
      offset: offset,
    );

    return (foundArticles ?? [])
        .map((article) => Article.fromMap(article))
        .toList();
  }

  Future<List<Article>> findBookmarks(
    String query,
    int limit,
    int offset,
  ) async {
    final foundArticles = await db?.query(
      tArticle,
      where: '$cArticleTitle LIKE ? AND $cArticleIsBookmarked = 1',
      whereArgs: ['%$query%'],
      orderBy: '$cArticleDate DESC',
      limit: limit,
      offset: offset,
    );

    return (foundArticles ?? [])
        .map((article) => Article.fromMap(article))
        .toList();
  }

  Future removeOrphanArticles(sql.Transaction tx) {
    return tx.rawDelete('''
      DELETE FROM $tArticle}
      WHERE $cArticleGuid NOT IN (
        SELECT $cArticleGuid}
        FROM $tSourceAndArticle}
      )
    ''');
  }

  Future removeBookmark(Article article) async {
    return db?.update(
      tArticle,
      {cArticleIsBookmarked: 0},
      where: '$cArticleGuid = ?',
      whereArgs: [article.guid],
    );
  }
}

mixin _SourcesAndArticles {
  sql.Database? db;

  Future createSourceAndArticleTable(sql.Transaction tx) {
    final sql = '''
      CREATE TABLE $tSourceAndArticle (
        $cForeignSourceUrl TEXT,
        $cArticleGuid TEXT,
        FOREIGN KEY ($cForeignSourceUrl) REFERENCES $tSource}($cSourceUrl),
        FOREIGN KEY ($cArticleGuid) REFERENCES $tArticle}($cArticleGuid),
        PRIMARY KEY ($cForeignSourceUrl}, $cArticleGuid)
      )
    ''';

    return tx.execute(sql);
  }

  Future addSourceArticles(
    sql.Transaction tx,
    Source source,
    List<Article> articles,
  ) async {
    var batch = tx.batch();

    articles.forEach(
      (article) => batch.insert(
        tSourceAndArticle,
        SourceAndArticle(source, article).toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.ignore,
      ),
    );

    return batch.commit();
  }

  Future<List<Article>> getSourceArticles(
    Source source,
    int limit,
    int offset,
  ) async {
    final sql = '''
      SELECT *
      FROM $tArticle}
      WHERE $cArticleGuid IN (
        SELECT $cArticleGuid}
        FROM $tSourceAndArticle}
        WHERE $cForeignSourceUrl = ?
      )
      ORDER BY $cArticleDate DESC
      LIMIT ? OFFSET ?
    ''';

    final sourceArticles = await db?.rawQuery(sql, [source.url, limit, offset]);

    return (sourceArticles ?? [])
        .map((article) => Article.fromMap(article))
        .toList();
  }

  Future<List<Article>> findSourceArticles(
    Source source,
    String query,
    int limit,
    int offset,
  ) async {
    final sql = '''
      SELECT *
      FROM $tArticle}
      WHERE $cArticleTitle LIKE ?
      AND $cArticleGuid IN (
        SELECT $cArticleGuid}
        FROM $tSourceAndArticle}
        WHERE $cForeignSourceUrl = ?
      )
      ORDER BY $cArticleDate DESC
      LIMIT ? OFFSET ?
    ''';

    final foundArticles = await db?.rawQuery(sql, [
      '%$query%',
      source.url,
      limit,
      offset,
    ]);

    return (foundArticles ?? []).map((a) => Article.fromMap(a)).toList();
  }

  Future removeSourceAndArticle(sql.Transaction tx, Source source) async {
    await tx.delete(
      tSourceAndArticle,
      where: '$cForeignSourceUrl = ?',
      whereArgs: [source.url],
    );
  }
}

class Database extends ChangeNotifier
    with _Sources, _Articles, _SourcesAndArticles {
  sql.Database? db;

  Database() {
    _initDatabase();
  }

  void _initDatabase() async {
    db = await sql.openDatabase(
      'feed.db',
      version: 1,
      onCreate: (sql.Database db, int version) => db.transaction((tx) async {
        await createArticleTable(tx);
        await createSourceTable(tx);
        await createSourceAndArticleTable(tx);
      }),
    );

    notifyListeners();
  }

  Future refreshSource(Source source, List<Article> articles) async {
    return db?.transaction((tx) async {
      await addArticles(tx, articles);
      await addSourceArticles(tx, source, articles);
    });
  }

  Future forgetSource(Source source) async {
    return db?.transaction((tx) async {
      await removeSource(tx, source);
      await removeSourceAndArticle(tx, source);
      await removeOrphanArticles(tx);
    });
  }

  Future<bool> toggleBookmark(String guid, [bool? toggle]) async {
    Article? article = await getArticle(guid);

    if (article == null) {
      return false;
    }

    final shouldBookmark = (toggle != null && toggle) || !article.isBookmarked;

    if (shouldBookmark) {
      await addBookmark(article);
    } else {
      await removeBookmark(article);
    }

    return shouldBookmark;
  }
}
