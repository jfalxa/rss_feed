import 'package:sqflite/sqflite.dart';

import './source.dart' hide cSourceTitle;
import './article.dart';

final String tSourceAndArticle = 'source_and_article';
final String cForeignSourceUrl = 'source_url';
final String cForeignArticleGuid = 'article_guid';

class SourceAndArticle {
  String sourceUrl;
  String articleGuid;

  SourceAndArticle(Source s, Article a)
      : sourceUrl = s.url,
        articleGuid = a.guid;

  Map<String, dynamic> toMap() {
    return {
      cForeignSourceUrl: sourceUrl,
      cForeignArticleGuid: articleGuid,
    };
  }
}

class SourceAndArticleDao {
  final Future<Database> db;

  SourceAndArticleDao({required this.db});

  static Future createSourceAndArticleTable(Transaction tx) {
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
    Transaction tx,
    Source source,
    List<Article> articles,
  ) async {
    var batch = tx.batch();

    articles.forEach(
      (article) => batch.insert(
        tSourceAndArticle,
        SourceAndArticle(source, article).toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
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
      FROM $tArticle
      WHERE $cArticleGuid IN (
        SELECT $cForeignArticleGuid
        FROM $tSourceAndArticle
        WHERE $cForeignSourceUrl = ?
      )
      ORDER BY $cArticleDate DESC
      LIMIT ? OFFSET ?
    ''';

    final sourceArticles =
        await (await db).rawQuery(sql, [source.url, limit, offset]);

    return sourceArticles.map((article) => Article.fromMap(article)).toList();
  }

  Future<List<Article>> findSourceArticles(
    Source source,
    String query,
    int limit,
    int offset,
  ) async {
    final sql = '''
      SELECT *
      FROM $tArticle
      WHERE $cArticleTitle LIKE ?
      AND $cArticleGuid IN (
        SELECT $cForeignArticleGuid
        FROM $tSourceAndArticle
        WHERE $cForeignSourceUrl = ?
      )
      ORDER BY $cArticleDate DESC
      LIMIT ? OFFSET ?
    ''';

    final foundArticles = await (await db).rawQuery(sql, [
      '%$query%',
      source.url,
      limit,
      offset,
    ]);

    return foundArticles.map((a) => Article.fromMap(a)).toList();
  }

  Future removeSourcesAndArticles(Transaction tx, Source source) async {
    await tx.delete(
      tSourceAndArticle,
      where: '$cForeignSourceUrl = ?',
      whereArgs: [source.url],
    );
  }

  Future removeOrphanArticles(Transaction tx) {
    return tx.rawDelete('''
      DELETE FROM $tArticle
      WHERE $cArticleGuid NOT IN (
        SELECT $cForeignArticleGuid
        FROM $tSourceAndArticle
      )
    ''');
  }
}
